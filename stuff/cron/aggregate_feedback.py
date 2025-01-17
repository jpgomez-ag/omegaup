#!/usr/bin/python3

'''Aggregates user feedback.

This script reads all user feedback submissions, and updates average difficulty
and rating based on bayesian averages.
'''

import argparse
import calendar
import collections
import datetime
import json
import operator
import logging
import warnings

import MySQLdb.constants.ER

import lib.db
import lib.logs

CONFIDENCE = 10
MIN_POINTS = 10
PROBLEM_TAG_VOTE_MIN_PROPORTION = 0.25
MAX_NUM_TOPICS = 5
VOTES_NUM = 5

# Before this id the questions were different
QUALITYNOMINATION_QUESTION_CHANGE_ID = 18663

# SQL Queries
GET_ALL_SCORES_AND_SUGGESTIONS = """SELECT qn.`contents`, ur.`score`
                                    FROM `QualityNominations` as qn
                                    LEFT JOIN `User_Rank` as ur
                                    ON ur.`user_id` = qn.`user_id`
                                    WHERE `nomination` = 'suggestion'
                                      AND qn.`qualitynomination_id` > %s;"""

GET_PROBLEM_SCORES_AND_SUGGESTIONS = """SELECT qn.`contents`, ur.`score`
                                        FROM `QualityNominations` as qn
                                        LEFT JOIN `User_Rank` as ur
                                        ON ur.`user_id` = qn.`user_id`
                                        WHERE qn.`nomination` = 'suggestion'
                                          AND qn.`qualitynomination_id` > %s
                                          AND qn.`problem_id` = %s;"""

# weighting factors according to user's range
WEIGHTING_FACTORS = {
    'user-rank-unranked': 2,
    'user-rank-beginner': 2,
    'user-rank-specialist': 3,
    'user-rank-expert': 4,
    'user-rank-master': 5,
    'user-rank-international-master': 6,
}


class Votes:
    '''This class is an abstraction of a vote with their
    simple count and weighted sum'''
    __slots__ = ['count', 'weighted_sum']

    def __init__(self, count=0, weighted_sum=0):
        self.count = count
        self.weighted_sum = weighted_sum


def fill_rank_cutoffs(dbconn):
    '''Creates and fills RankCutoff collection'''
    rank_cutoff = collections.namedtuple('rank_cutoff', ['classname', 'score'])
    with dbconn.cursor() as cur:
        cur.execute("""SELECT urc.`classname`, urc.`score`
                       FROM `User_Rank_Cutoffs` as urc
                       ORDER BY urc.`percentile` ASC;""")
        return [rank_cutoff(row[0], row[1]) for row in cur]


def get_weighting_factor(score, rank_cutoffs):
    '''Gets the user vote weighting factor based on user's
    score stored in User_Rank table and according to the
    User_Rank_Cutoffs scores and classnames'''
    if score is None:
        return WEIGHTING_FACTORS['user-rank-unranked']
    for cutoff in rank_cutoffs:
        if cutoff.score <= score:
            return WEIGHTING_FACTORS[cutoff.classname]
    return WEIGHTING_FACTORS['user-rank-unranked']


def get_global_quality_and_difficulty_average(dbconn, rank_cutoffs):
    '''Gets the global quality and difficulty average based on user feedback.

    This will be used as the prior belief when updating each individual
    problem's quality and difficulty ratings.
    '''
    with dbconn.cursor() as cur:
        cur.execute(GET_ALL_SCORES_AND_SUGGESTIONS,
                    (QUALITYNOMINATION_QUESTION_CHANGE_ID,))
        quality_sum = 0
        quality_n = 0
        difficulty_sum = 0
        difficulty_n = 0
        for row in cur:
            try:
                contents = json.loads(row[0])
            except json.JSONDecodeError:  # pylint: disable=no-member
                logging.exception('Failed to parse contents')
                continue

            user_score = row[1]
            weighting_factor = get_weighting_factor(user_score, rank_cutoffs)
            if 'quality' in contents and contents['quality'] is not None:
                quality_sum += weighting_factor * contents['quality']
                quality_n += weighting_factor
            if ('difficulty' in contents and
                    contents['difficulty'] is not None):
                difficulty_sum += weighting_factor * contents['difficulty']
                difficulty_n += weighting_factor

    global_quality_average = None
    if quality_n:
        global_quality_average = quality_sum / float(quality_n)
    global_difficulty_average = None
    if difficulty_n:
        global_difficulty_average = difficulty_sum / float(difficulty_n)
    return (global_quality_average, global_difficulty_average)


def get_problem_aggregates(dbconn, problem_id, rank_cutoffs):
    '''Gets the aggregates for a particular problem.'''
    with dbconn.cursor() as cur:
        cur.execute(GET_PROBLEM_SCORES_AND_SUGGESTIONS,
                    (QUALITYNOMINATION_QUESTION_CHANGE_ID, problem_id,))

        quality_votes = [Votes() for _ in range(VOTES_NUM)]
        difficulty_votes = [Votes() for _ in range(VOTES_NUM)]

        problem_tag_votes = collections.defaultdict(int)
        problem_tag_votes_n = 0
        for row in cur:
            contents = json.loads(row[0])
            user_score = row[1]
            weighting_factor = get_weighting_factor(user_score, rank_cutoffs)
            if 'quality' in contents and contents['quality'] is not None:
                quality_votes[contents['quality']].count += 1
                quality_votes[contents['quality']].weighted_sum += (
                    weighting_factor)
            if ('difficulty' in contents and
                    contents['difficulty'] is not None):
                difficulty_votes[contents['difficulty']].count += 1
                difficulty_votes[contents['difficulty']].weighted_sum += (
                    weighting_factor)
            if 'tags' in contents and contents['tags']:
                for tag in contents['tags']:
                    problem_tag_votes[tag] += weighting_factor
                    problem_tag_votes_n += weighting_factor

    return (quality_votes, difficulty_votes,
            problem_tag_votes, problem_tag_votes_n)


def bayesian_average(apriori_average, values):
    '''Gets the Bayesian average of an observation based on a prior value.'''
    weighted_n = 0
    weighted_sum = 0
    for i, vote in enumerate(values):
        weighted_n += vote.weighted_sum
        weighted_sum += i * vote.weighted_sum

    if weighted_n < CONFIDENCE or apriori_average is None:
        return None

    return (CONFIDENCE * apriori_average + weighted_sum) / (
        CONFIDENCE + weighted_n)


def get_most_voted_tags(problem_tag_votes, problem_tag_votes_n):
    '''Gets the most voted tags for each problem.

    This returns the list of user-suggested problem tags, provided that:
    * At least a minimum amount of votes have been cast, to make it more
      robust.
    * The number of votes cast for a particular tag is at least a certain
      proportion of the most voted for tag.
    * No more than a certain number of tags have been chosen (to avoid noise).
    '''

    if problem_tag_votes_n < MIN_POINTS:
        return None
    maximum = problem_tag_votes[max(problem_tag_votes,
                                    key=problem_tag_votes.get)]
    final_tags = [tag for (tag, votes) in problem_tag_votes.items()
                  if votes >= PROBLEM_TAG_VOTE_MIN_PROPORTION * maximum]
    if len(final_tags) >= MAX_NUM_TOPICS:
        return None
    return final_tags


def replace_autogenerated_tags(dbconn, problem_id, problem_tags):
    '''Replace the autogenerated tags for problem_id with problem_tags.'''

    try:
        logging.debug('Replacing problem %d tags with %r', problem_id,
                      problem_tags)
        with dbconn.cursor() as cur:
            cur.execute("""DELETE FROM
                               `Problems_Tags`
                           WHERE
                               `problem_id` = %s AND `autogenerated` = 1;""",
                        (problem_id,))
            cur.execute("""INSERT IGNORE INTO
                               `Problems_Tags`(`problem_id`, `tag_id`,
                                               `public`, `autogenerated`)
                           SELECT
                               %%s AS `problem_id`,
                               `t`.`tag_id` AS `tag_id`,
                               1 AS `public`,
                               1 AS `autogenerated `
                           FROM
                               `Tags` AS `t`
                           WHERE
                               `t`.`name` IN (%s);""" %
                        ', '.join('%s' for _ in problem_tags),
                        (problem_id,) + tuple(problem_tags))
            for msg in cur.messages:
                if isinstance(msg, tuple) and msg[0] == cur.Warning:
                    if msg[1][1] == MySQLdb.constants.ER.DUP_ENTRY:
                        # It is somewhat expected to get duplicate entries.
                        continue
                logging.warning('Warning while updated tags in problem %d: %r',
                                problem_id, msg)
            dbconn.commit()
    except:  # noqa: bare-except
        logging.exception('Failed to replace autogenerated tags')
        dbconn.rollback()


def aggregate_problem_feedback(dbconn, problem_id, rank_cutoffs,
                               global_quality_average,
                               global_difficulty_average):
    '''Aggregates user feedback for a certain problem

    Updates problem quality, difficulty, and tags for a problem passed on
    the problem_id parameter.
    '''
    logging.debug('Aggregating feedback for problem %d', problem_id)

    (problem_quality_votes, problem_difficulty_votes,
     problem_tag_votes,
     problem_tag_votes_n) = get_problem_aggregates(dbconn, problem_id,
                                                   rank_cutoffs)

    problem_quality = bayesian_average(
        global_quality_average, problem_quality_votes)
    problem_difficulty = bayesian_average(global_difficulty_average,
                                          problem_difficulty_votes)
    if problem_quality is not None:
        logging.debug('quality=%f', problem_quality)
        with dbconn.cursor() as cur:
            cur.execute(
                """
                UPDATE
                `Problems` as p
                SET
                p.`quality` = %s,
                p.`quality_histogram` = %s
                WHERE
                p.`problem_id` = %s;""",
                (problem_quality,
                 json.dumps([vote.count for vote in
                             problem_quality_votes]),
                 problem_id))
    if problem_difficulty is not None:
        logging.debug('difficulty=%f', problem_difficulty)
        with dbconn.cursor() as cur:
            cur.execute(
                """
                UPDATE
                `Problems` as p
                SET
                p.`difficulty` = %s,
                p.`difficulty_histogram` = %s
                WHERE
                p.`problem_id` = %s;""",
                (problem_difficulty,
                 json.dumps([vote.count for vote in
                             problem_difficulty_votes]),
                 problem_id))
    if problem_quality is not None or problem_difficulty is not None:
        dbconn.commit()
    else:
        logging.debug('Not enough information for problem %d', problem_id)
    # TODO(heduenas): Get threshold parameter from DB for each problem
    # independently.
    problem_tags = get_most_voted_tags(problem_tag_votes,
                                       problem_tag_votes_n)
    if problem_tags:
        replace_autogenerated_tags(dbconn, problem_id, problem_tags)


def aggregate_feedback(dbconn):
    '''Aggregates user feedback.

    This updates problem quality, difficulty, and tags for each problem that
    has user feedback.
    '''
    rank_cutoffs = fill_rank_cutoffs(dbconn)
    (global_quality_average,
     global_difficulty_average) = get_global_quality_and_difficulty_average(
         dbconn, rank_cutoffs)

    with dbconn.cursor() as cur:
        cur.execute("""SELECT DISTINCT qn.`problem_id`
                       FROM `QualityNominations` as qn
                       WHERE qn.`nomination` = 'suggestion'
                         AND qn.`qualitynomination_id` > %s;""",
                    (QUALITYNOMINATION_QUESTION_CHANGE_ID,))
        for row in cur:
            aggregate_problem_feedback(dbconn, row[0], rank_cutoffs,
                                       global_quality_average,
                                       global_difficulty_average)


def get_last_friday():
    '''Returns datetime object corresponding to last Friday.
    '''
    current_date = datetime.datetime.now().date()
    last_friday = (
        current_date - datetime.timedelta(days=current_date.weekday())
        + datetime.timedelta(days=calendar.FRIDAY))

    # If day of the week is before Friday substract a week from the date.
    if current_date.weekday() < calendar.FRIDAY:
        last_friday -= datetime.timedelta(weeks=1)

    return last_friday


def update_problem_of_the_week(dbconn, difficulty):
    '''Computes and records the problem of the past week.

    We will choose the problem that has not previously been chosen as problem
    of the week, has been previously identified as being Easy, and has the
    largest sum of quality votes over the past week as the problem of the week.
    '''

    # First check if last Friday's problem has already been computed and stored
    last_friday = get_last_friday()
    with dbconn.cursor() as cur:
        cur.execute("""SELECT COUNT(*)
                       FROM `Problem_Of_The_Week`
                       WHERE `time` = %s
                         AND `difficulty` = %s;""",
                    (last_friday.strftime("%Y-%m-%d"), difficulty))
        if cur.fetchone()[0] > 0:
            return

    # If last Friday's problem hasn't been computed, we compute it and store it
    # in the DB.
    friday_before_last = last_friday - datetime.timedelta(weeks=1)
    with dbconn.cursor() as cur:
        cur.execute("""SELECT qn.`problem_id`, qn.`contents`
                       FROM `QualityNominations` AS qn
                       INNER JOIN `Problems`
                         AS p ON p.`problem_id` = qn.`problem_id`
                       LEFT JOIN `Problem_Of_The_Week`
                         AS pw ON pw.`problem_id` = qn.`problem_id`
                       WHERE qn.`nomination` = 'suggestion'
                         AND qn.`time` >= %s
                         AND qn.`time` < %s
                         AND pw.`problem_of_the_week_id` IS NULL
                         AND p.`difficulty` >= %s
                         AND p.`difficulty` < %s;""",
                    (friday_before_last.strftime("%Y-%m-%d %H:%M:%S"),
                     last_friday.strftime("%Y-%m-%d %H:%M:%S"),
                     0.0 if difficulty == 'easy' else 2.0,
                     2.0 if difficulty == 'easy' else 4.0))

        quality_map = collections.defaultdict(int)
        for row in cur:
            problem_id = row[0]
            try:
                contents = json.loads(row[1])
            except json.JSONDecodeError:  # pylint: disable=no-member
                logging.exception('Failed to parse contents')
                continue

            if 'quality' not in contents or contents['quality'] is None:
                continue

            quality_map[problem_id] += contents['quality']

        if not quality_map:
            logging.warning('No problem of the week found')
            return

        problem_of_the_week_problem_id = (
            max(quality_map.items(), key=operator.itemgetter(1))[0])
        logging.debug('Inserting problem of the week %d for week of %s',
                      problem_of_the_week_problem_id,
                      last_friday.strftime("%Y-%m-%d"))
        cur.execute("""INSERT INTO `Problem_Of_The_Week`
                       (`problem_id`, `time`, `difficulty`)
                       VALUES (%s, %s, %s);""",
                    (problem_of_the_week_problem_id,
                     last_friday.strftime("%Y-%m-%d"),
                     difficulty))
        dbconn.commit()


def main():
    '''Main entrypoint.'''
    parser = argparse.ArgumentParser(
        description='Aggregate user feedback.')

    lib.db.configure_parser(parser)
    lib.logs.configure_parser(parser)

    args = parser.parse_args()
    lib.logs.init(parser.prog, args)

    logging.info('Started')
    dbconn = lib.db.connect(args)
    warnings.filterwarnings('ignore', category=dbconn.Warning)
    try:
        try:
            aggregate_feedback(dbconn)
        except:  # noqa: bare-except
            logging.exception(
                'Failed to aggregate feedback and update problem tags.')
            raise

        try:
            # Problem of the week HAS to be computed AFTER feedback has been
            # aggregated. It uses difficulty tags computed from feedback to
            # pick a problem of the given difficulty.
            update_problem_of_the_week(dbconn, "easy")
            # TODO(heduenas): Compute "hard" problem of the week when we get
            # enough feedback records.
        except:  # noqa: bare-except
            logging.exception('Failed to update problem of the week')
            raise
    finally:
        dbconn.close()
        logging.info('Done')


if __name__ == '__main__':
    main()

# vim: tabstop=4 expandtab shiftwidth=4 softtabstop=4
