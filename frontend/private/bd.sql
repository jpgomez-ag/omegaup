-- phpMyAdmin SQL Dump
-- version 3.4.9
-- http://www.phpmyadmin.net
--
-- Host: localhost
-- Generation Time: Oct 14, 2012 at 10:54 PM
-- Server version: 5.5.27
-- PHP Version: 5.3.16-1~dotdeb.0

SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Database: `omegaup`
--

-- --------------------------------------------------------

--
-- Table structure for table `Announcement`
--

CREATE TABLE IF NOT EXISTS `Announcement` (
  `announcement_id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Identificador del aviso',
  `user_id` int(11) NOT NULL COMMENT 'UserID del autor de este aviso',
  `time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Fecha de creacion de este aviso',
  `description` text NOT NULL COMMENT 'Mensaje de texto del aviso',
  PRIMARY KEY (`announcement_id`),
  KEY `user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Sistema de mensajerÃ­a dentro del sitio.' AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `Auth_Tokens`
--

CREATE TABLE IF NOT EXISTS `Auth_Tokens` (
  `user_id` int(11) NOT NULL,
  `token` varchar(128) NOT NULL,
  PRIMARY KEY (`token`),
  KEY `user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Tokens de autorizaciÃ³n para los logins.';

-- --------------------------------------------------------

--
-- Table structure for table `Badges`
--

CREATE TABLE IF NOT EXISTS `Badges` (
  `badge_id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(45) NOT NULL DEFAULT 'MyBadge',
  `image_url` varchar(45) NOT NULL,
  `description` varchar(500) NOT NULL COMMENT 'La descripcion habla de como se obtuvo el badge, de forma corta.',
  `hint` varchar(100) DEFAULT NULL COMMENT 'Tip de como desbloquear el badge.',
  PRIMARY KEY (`badge_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Esta tabla guarda la informacion de cada uno de los badges.' AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `Clarifications`
--

CREATE TABLE IF NOT EXISTS `Clarifications` (
  `clarification_id` int(11) NOT NULL AUTO_INCREMENT,
  `author_id` int(11) NOT NULL COMMENT 'Autor de la clarificaciÃ³n.',
  `message` text NOT NULL,
  `answer` text,
  `time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `problem_id` int(11) NOT NULL COMMENT 'Lo ideal es que la clarificacion le llegue al problemsetter que escribio el problema.',
  `contest_id` int(11) DEFAULT NULL COMMENT 'Puede ser nulo si la clarificacion no se da en un concurso.',
  `public` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'SÃ³lo las clarificaciones que el problemsetter marque como publicacbles apareceran en la lista que toda la banda puede ver. Sino, solo al usuario. ',
  PRIMARY KEY (`clarification_id`),
  KEY `problem_id` (`problem_id`),
  KEY `contest_id` (`contest_id`),
  KEY `author_id` (`author_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COMMENT='Se guardan las clarificaciones.' AUTO_INCREMENT=344 ;

-- --------------------------------------------------------

--
-- Table structure for table `Coder_of_the_Month`
--

CREATE TABLE IF NOT EXISTS `Coder_of_the_Month` (
  `coder_of_the_month_id` int(11) NOT NULL AUTO_INCREMENT,
  `description` tinytext,
  `time` date NOT NULL DEFAULT '2000-01-01' COMMENT 'Fecha no es UNIQUE por si hay mÃ¡s de 1 coder de mes.',
  `interview_url` varchar(256) DEFAULT NULL COMMENT 'Para linekar a un post del blog con entrevistas.',
  PRIMARY KEY (`coder_of_the_month_id`),
  KEY `coder_of_the_month_id` (`coder_of_the_month_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Guardar histÃ³rico de coders del mes de forma sencilla.' AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `Contests`
--

CREATE TABLE IF NOT EXISTS `Contests` (
  `contest_id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'El identificador unico para cada concurso',
  `title` varchar(256) NOT NULL COMMENT 'El titulo que aparecera en cada concurso',
  `description` tinytext NOT NULL COMMENT 'Una breve descripcion de cada concurso.',
  `start_time` timestamp NOT NULL DEFAULT '2000-01-01 06:00:00' COMMENT 'Hora de inicio de este concurso',
  `finish_time` timestamp NOT NULL DEFAULT '2000-01-01 06:00:00' COMMENT 'Hora de finalizacion de este concurso',
  `window_length` int(11) DEFAULT NULL COMMENT 'Indica el tiempo que tiene el usuario para envÃ­ar soluciÃ³n, si es NULL entonces serÃ¡ durante todo el tiempo del concurso',
  `director_id` int(11) NOT NULL COMMENT 'el userID del usuario que creo este concurso',
  `rerun_id` int(11) NOT NULL COMMENT 'Este campo es para las repeticiones de algÃºn concurso',
  `public` tinyint(1) NOT NULL DEFAULT '1' COMMENT 'False implica concurso cerrado, ver la tabla ConcursantesConcurso',
  `alias` varchar(32) NOT NULL COMMENT 'AlmacenarÃ¡ el token necesario para acceder al concurso',
  `scoreboard` int(11) NOT NULL DEFAULT '1' COMMENT 'Entero del 0 al 100, indicando el porcentaje de tiempo que el scoreboard serÃ¡ visible',
  `points_decay_factor` double NOT NULL DEFAULT '0' COMMENT 'El factor de decaimiento de los puntos de este concurso. El default es 0 (no decae). TopCoder es 0.7',
  `partial_score` tinyint(1) NOT NULL DEFAULT '1' COMMENT 'Verdadero si el usuario recibirÃ¡ puntaje parcial para problemas no resueltos en todos los casos',
  `submissions_gap` int(11) NOT NULL DEFAULT '1' COMMENT 'Tiempo mÃ­nimo en segundos que debe de esperar un usuario despues de realizar un envÃ­o para hacer otro',
  `feedback` enum('no','yes','partial') NOT NULL,
  `penalty` int(11) NOT NULL DEFAULT '1' COMMENT 'Entero indicando el nÃºmero de minutos con que se penaliza por recibir un no-accepted',
  `penalty_time_start` enum('contest','problem','none') NOT NULL COMMENT 'Indica el momento cuando se inicia a contar el timpo: cuando inicia el concurso o cuando se abre el problema',
  `penalty_calc_policy` enum('sum','max') NOT NULL COMMENT 'Indica como afecta el penalty al score.',
  PRIMARY KEY (`contest_id`),
  UNIQUE KEY `contests_alias` (`alias`),
  KEY `director_id` (`director_id`),
  KEY `rerun_id` (`contest_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COMMENT='Concursos que se llevan a cabo en el juez.' AUTO_INCREMENT=47 ;

-- --------------------------------------------------------

--
-- Table structure for table `Contests_Users`
--

CREATE TABLE IF NOT EXISTS `Contests_Users` (
  `user_id` int(11) NOT NULL,
  `contest_id` int(11) NOT NULL,
  `access_time` datetime NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT 'Hora a la que entrÃ³ el usuario al concurso',
  `score` int(11) NOT NULL DEFAULT '1' COMMENT 'Ãndica el puntaje que obtuvo el usuario en el concurso',
  `time` int(11) NOT NULL DEFAULT '1' COMMENT 'Ãndica el tiempo que acumulo en usuario en el concurso',
  PRIMARY KEY (`user_id`,`contest_id`),
  KEY `user_id` (`user_id`),
  KEY `contest_id` (`contest_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Concursantes que pueden participar en concurso cerrado.';

-- --------------------------------------------------------

--
-- Table structure for table `Contest_Problems`
--

CREATE TABLE IF NOT EXISTS `Contest_Problems` (
  `contest_id` int(11) NOT NULL,
  `problem_id` int(11) NOT NULL,
  `points` double NOT NULL DEFAULT '1',
  PRIMARY KEY (`contest_id`,`problem_id`),
  KEY `contest_id` (`contest_id`),
  KEY `problem_id` (`problem_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Relacion entre Concursos y los problemas que tiene este';

-- --------------------------------------------------------

--
-- Table structure for table `Contest_Problem_Opened`
--

CREATE TABLE IF NOT EXISTS `Contest_Problem_Opened` (
  `contest_id` int(11) NOT NULL,
  `problem_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `open_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`contest_id`,`problem_id`,`user_id`),
  KEY `contest_id` (`contest_id`),
  KEY `problem_id` (`problem_id`),
  KEY `user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Relacion entre Concursos y los problemas que tiene este';

-- --------------------------------------------------------

--
-- Table structure for table `Countries`
--

CREATE TABLE IF NOT EXISTS `Countries` (
  `country_id` char(3) NOT NULL,
  `name` varchar(50) NOT NULL,
  PRIMARY KEY (`country_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='CatÃ¡logos para la normalizaciÃ³n';

-- --------------------------------------------------------

--
-- Table structure for table `Emails`
--

CREATE TABLE IF NOT EXISTS `Emails` (
  `email_id` int(11) NOT NULL AUTO_INCREMENT,
  `email` varchar(256) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`email_id`),
  KEY `user_id` (`user_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COMMENT='Esta tabla permite tener varios emails por persona' AUTO_INCREMENT=247 ;

-- --------------------------------------------------------

--
-- Table structure for table `Favorites`
--

CREATE TABLE IF NOT EXISTS `Favorites` (
  `user_id` int(11) NOT NULL,
  `problem_id` int(11) NOT NULL,
  PRIMARY KEY (`user_id`,`problem_id`),
  KEY `user_id` (`user_id`),
  KEY `problem_id` (`problem_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Problemas favoritos de los usuarios';

-- --------------------------------------------------------

--
-- Table structure for table `Languages`
--

CREATE TABLE IF NOT EXISTS `Languages` (
  `language_id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(45) NOT NULL,
  `country_id` char(3) DEFAULT NULL COMMENT 'Se guarda la relaciÃ³n con el paÃ­s para defaultear mÃ¡s rÃ¡pido.',
  PRIMARY KEY (`language_id`),
  UNIQUE KEY `nombre_UNIQUE` (`name`),
  KEY `country_id` (`country_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Lista de idiomas que potencialmente se soportarÃ­an.' AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `Messages`
--

CREATE TABLE IF NOT EXISTS `Messages` (
  `message_id` int(11) NOT NULL AUTO_INCREMENT,
  `read` tinyint(1) NOT NULL DEFAULT '0',
  `sender_id` int(11) NOT NULL,
  `recipient_id` int(11) NOT NULL,
  `message` tinytext NOT NULL,
  `date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`message_id`),
  KEY `sender_id` (`sender_id`,`recipient_id`),
  KEY `fk_m_recipient_id` (`recipient_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Sistema de mensajerÃ­a dentro del sitio.' AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `Password_Change`
--

CREATE TABLE IF NOT EXISTS `Password_Change` (
  `user_id` int(11) NOT NULL COMMENT 'Identificador de a que usuario pertenece este token',
  `token` char(64) NOT NULL COMMENT 'El token que se genera aleatoriamente para luego comparar cuando el usuario haga click en el link',
  `ip` char(15) NOT NULL COMMENT 'El ip desde donde se genero este reseteo de password',
  `expiration_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'La fecha en que vence este token',
  PRIMARY KEY (`user_id`),
  KEY `user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `Permissions`
--

CREATE TABLE IF NOT EXISTS `Permissions` (
  `permission_id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL COMMENT 'El nombre corto del permiso.',
  `description` varchar(100) NOT NULL COMMENT 'La descripciÃ³n humana del permiso.',
  PRIMARY KEY (`permission_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COMMENT='Establece los permisos que se pueden dar a los roles.' AUTO_INCREMENT=18 ;

-- --------------------------------------------------------

--
-- Table structure for table `Problems`
--

CREATE TABLE IF NOT EXISTS `Problems` (
  `problem_id` int(11) NOT NULL AUTO_INCREMENT,
  `public` tinyint(1) NOT NULL DEFAULT '1',
  `author_id` int(11) NOT NULL,
  `title` varchar(256) NOT NULL,
  `alias` varchar(32) NOT NULL,
  `validator` enum('remote','literal','token','token-caseless','token-numeric') NOT NULL DEFAULT 'token-numeric',
  `server` enum('uva','livearchive','pku','tju','spoj') DEFAULT NULL,
  `remote_id` varchar(10) DEFAULT NULL,
  `time_limit` int(11) DEFAULT '3000',
  `memory_limit` int(11) DEFAULT '64',
  `visits` int(11) NOT NULL DEFAULT '0',
  `submissions` int(11) NOT NULL DEFAULT '0',
  `accepted` int(11) NOT NULL DEFAULT '0',
  `difficulty` double NOT NULL DEFAULT '0',
  `creation_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `source` varchar(256) DEFAULT NULL,
  `order` enum('normal','inverse') NOT NULL DEFAULT 'normal',
  PRIMARY KEY (`problem_id`),
  UNIQUE KEY `problems_alias` (`alias`),
  KEY `author_id` (`author_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COMMENT='Se crea un registro por cada prob externo.' AUTO_INCREMENT=102 ;

-- --------------------------------------------------------

--
-- Table structure for table `Problems_Badges`
--

CREATE TABLE IF NOT EXISTS `Problems_Badges` (
  `badge_id` int(11) NOT NULL,
  `problem_id` int(11) NOT NULL,
  PRIMARY KEY (`badge_id`,`problem_id`),
  KEY `badge_id` (`badge_id`),
  KEY `problem_id` (`problem_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='RelaciÃ³n entre 1 badge y los problemas que lo desbloqueaan.';

-- --------------------------------------------------------

--
-- Table structure for table `Problems_Languages`
--

CREATE TABLE IF NOT EXISTS `Problems_Languages` (
  `problem_id` int(11) NOT NULL,
  `language_id` int(11) NOT NULL,
  `translator_id` int(11) NOT NULL,
  PRIMARY KEY (`problem_id`,`language_id`),
  KEY `problem_id` (`problem_id`),
  KEY `language_id` (`language_id`),
  KEY `translator_id` (`translator_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Las traducciones viven en el filesystem y no en la bdd.';

-- --------------------------------------------------------

--
-- Table structure for table `Problems_Tags`
--

CREATE TABLE IF NOT EXISTS `Problems_Tags` (
  `problem_id` int(11) NOT NULL,
  `tag_id` int(11) NOT NULL,
  PRIMARY KEY (`problem_id`,`tag_id`),
  KEY `tag_id` (`tag_id`),
  KEY `problem_id` (`problem_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Guarda la relacion entre Problemas y sus Tags';

-- --------------------------------------------------------

--
-- Table structure for table `Roles`
--

CREATE TABLE IF NOT EXISTS `Roles` (
  `role_id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL COMMENT 'El nombre corto del rol.',
  `description` varchar(100) NOT NULL COMMENT 'La descripciÃ³n humana del rol.',
  PRIMARY KEY (`role_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COMMENT='Establece los roles que se pueden dar a los usuarios.' AUTO_INCREMENT=5 ;

-- --------------------------------------------------------

--
-- Table structure for table `Roles_Permissions`
--

CREATE TABLE IF NOT EXISTS `Roles_Permissions` (
  `role_id` int(11) NOT NULL,
  `permission_id` int(11) NOT NULL,
  PRIMARY KEY (`role_id`,`permission_id`),
  KEY `role_id` (`role_id`),
  KEY `permission_id` (`permission_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Establece los roles que se pueden dar a los usuarios.';

-- --------------------------------------------------------

--
-- Table structure for table `Runs`
--

CREATE TABLE IF NOT EXISTS `Runs` (
  `run_id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `problem_id` int(11) NOT NULL,
  `contest_id` int(11) DEFAULT NULL,
  `guid` char(32) NOT NULL,
  `language` enum('c','cpp','java','py','rb','pl','cs','p','kp','kj') NOT NULL,
  `status` enum('new','waiting','compiling','running','ready') NOT NULL DEFAULT 'new',
  `veredict` enum('AC','PA','PE','WA','TLE','OLE','MLE','RTE','RFE','CE','JE') NOT NULL,
  `runtime` int(11) NOT NULL DEFAULT '0',
  `memory` int(11) NOT NULL DEFAULT '0',
  `score` double NOT NULL DEFAULT '0',
  `contest_score` double NOT NULL DEFAULT '0',
  `ip` char(15) NOT NULL,
  `time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `submit_delay` int(11) NOT NULL DEFAULT '0',
  `test` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`run_id`),
  UNIQUE KEY `runs_alias` (`guid`),
  KEY `user_id` (`user_id`),
  KEY `problem_id` (`problem_id`),
  KEY `contest_id` (`contest_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COMMENT='Estado de todas las ejecuciones.' AUTO_INCREMENT=10586 ;

-- --------------------------------------------------------

--
-- Table structure for table `Schools`
--

CREATE TABLE IF NOT EXISTS `Schools` (
  `school_id` int(11) NOT NULL,
  `state_id` int(11) NOT NULL,
  `name` varchar(50) NOT NULL,
  PRIMARY KEY (`school_id`),
  KEY `state_id` (`state_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='CatÃ¡logos para la normalizaciÃ³n';

-- --------------------------------------------------------

--
-- Table structure for table `States`
--

CREATE TABLE IF NOT EXISTS `States` (
  `state_id` int(11) NOT NULL,
  `country_id` char(3) NOT NULL,
  `name` varchar(50) NOT NULL,
  PRIMARY KEY (`state_id`),
  KEY `country_id` (`country_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='CatÃ¡logos para la normalizaciÃ³n';

-- --------------------------------------------------------

--
-- Table structure for table `Tags`
--

CREATE TABLE IF NOT EXISTS `Tags` (
  `tag_id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(45) NOT NULL,
  `description` tinytext,
  PRIMARY KEY (`tag_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Guarda los tags para los problemas' AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `Users`
--

CREATE TABLE IF NOT EXISTS `Users` (
  `user_id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(50) NOT NULL,
  `facebook_user_id` bigint(20) DEFAULT NULL COMMENT 'Facebook ID for this user.',
  `password` char(32) DEFAULT NULL,
  `main_email_id` int(11) DEFAULT NULL,
  `name` varchar(256) DEFAULT NULL,
  `solved` int(11) NOT NULL DEFAULT '0',
  `submissions` int(11) NOT NULL DEFAULT '0',
  `country_id` char(3) DEFAULT NULL,
  `state_id` int(11) DEFAULT NULL,
  `school_id` int(11) DEFAULT NULL,
  `scholar_degree` varchar(64) DEFAULT NULL,
  `graduation_date` date DEFAULT NULL,
  `birth_date` date DEFAULT NULL,
  `last_access` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `username` (`username`),
  KEY `country_id` (`country_id`),
  KEY `state_id` (`state_id`),
  KEY `school_id` (`school_id`),
  KEY `fk_main_email_id` (`main_email_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COMMENT='Usuarios registrados.' AUTO_INCREMENT=386 ;

-- --------------------------------------------------------

--
-- Table structure for table `Users_Badges`
--

CREATE TABLE IF NOT EXISTS `Users_Badges` (
  `badge_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `last_problem_id` int(11) NOT NULL COMMENT 'Este campo guarda el ultimo problema que logro que se desbloqueara el badge, just for fun.',
  PRIMARY KEY (`badge_id`,`user_id`),
  KEY `badge_id` (`badge_id`),
  KEY `user_id` (`user_id`),
  KEY `last_problem_id` (`last_problem_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Guarda los badges que han sido desbloqueados.';

-- --------------------------------------------------------

--
-- Table structure for table `Users_Permissions`
--

CREATE TABLE IF NOT EXISTS `Users_Permissions` (
  `user_id` int(11) NOT NULL,
  `permission_id` int(11) NOT NULL,
  PRIMARY KEY (`user_id`,`permission_id`),
  KEY `user_id` (`user_id`),
  KEY `permission_id` (`permission_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Establece los permisos que se pueden dar a los usuarios.';

-- --------------------------------------------------------

--
-- Table structure for table `User_Roles`
--

CREATE TABLE IF NOT EXISTS `User_Roles` (
  `user_id` int(11) NOT NULL,
  `role_id` int(11) NOT NULL,
  PRIMARY KEY (`user_id`,`role_id`),
  KEY `user_id` (`user_id`),
  KEY `role_id` (`role_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Establece los roles que se pueden dar a los usuarios.';

--
-- Constraints for dumped tables
--

--
-- Constraints for table `Announcement`
--
ALTER TABLE `Announcement`
  ADD CONSTRAINT `fk_au_user_id` FOREIGN KEY (`user_id`) REFERENCES `Users` (`user_id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Constraints for table `Auth_Tokens`
--
ALTER TABLE `Auth_Tokens`
  ADD CONSTRAINT `fk_atu_user_id` FOREIGN KEY (`user_id`) REFERENCES `Users` (`user_id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Constraints for table `Clarifications`
--
ALTER TABLE `Clarifications`
  ADD CONSTRAINT `fk_cp_contest_id` FOREIGN KEY (`contest_id`) REFERENCES `Contests` (`contest_id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_cp_problem_id` FOREIGN KEY (`problem_id`) REFERENCES `Problems` (`problem_id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_cu_author_id` FOREIGN KEY (`author_id`) REFERENCES `Users` (`user_id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Constraints for table `Coder_of_the_Month`
--
ALTER TABLE `Coder_of_the_Month`
  ADD CONSTRAINT `fk_cotmu_coder_of_the_month_id` FOREIGN KEY (`coder_of_the_month_id`) REFERENCES `Users` (`user_id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Constraints for table `Contests`
--
ALTER TABLE `Contests`
  ADD CONSTRAINT `fk_cu_director_id` FOREIGN KEY (`director_id`) REFERENCES `Users` (`user_id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Constraints for table `Contests_Users`
--
ALTER TABLE `Contests_Users`
  ADD CONSTRAINT `fk_cuc_contest_id` FOREIGN KEY (`contest_id`) REFERENCES `Contests` (`contest_id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_cuu_user_id` FOREIGN KEY (`user_id`) REFERENCES `Users` (`user_id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Constraints for table `Contest_Problems`
--
ALTER TABLE `Contest_Problems`
  ADD CONSTRAINT `fk_cpc_contest_id` FOREIGN KEY (`contest_id`) REFERENCES `Contests` (`contest_id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_cpp_problem_id` FOREIGN KEY (`problem_id`) REFERENCES `Problems` (`problem_id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Constraints for table `Contest_Problem_Opened`
--
ALTER TABLE `Contest_Problem_Opened`
  ADD CONSTRAINT `fk_cpo_contest_id` FOREIGN KEY (`contest_id`) REFERENCES `Contests` (`contest_id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_cpo_problem_id` FOREIGN KEY (`problem_id`) REFERENCES `Problems` (`problem_id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_cpo_user_id` FOREIGN KEY (`user_id`) REFERENCES `Users` (`user_id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Constraints for table `Emails`
--
ALTER TABLE `Emails`
  ADD CONSTRAINT `user_id` FOREIGN KEY (`user_id`) REFERENCES `Users` (`user_id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Constraints for table `Favorites`
--
ALTER TABLE `Favorites`
  ADD CONSTRAINT `fk_f_problem_id` FOREIGN KEY (`problem_id`) REFERENCES `Problems` (`problem_id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_f_user_id` FOREIGN KEY (`user_id`) REFERENCES `Users` (`user_id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Constraints for table `Languages`
--
ALTER TABLE `Languages`
  ADD CONSTRAINT `fk_l_country_id` FOREIGN KEY (`country_id`) REFERENCES `Countries` (`country_id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Constraints for table `Messages`
--
ALTER TABLE `Messages`
  ADD CONSTRAINT `fk_m_recipient_id` FOREIGN KEY (`recipient_id`) REFERENCES `Users` (`user_id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_m_sender_id` FOREIGN KEY (`sender_id`) REFERENCES `Users` (`user_id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Constraints for table `Password_Change`
--
ALTER TABLE `Password_Change`
  ADD CONSTRAINT `fk_pc_user_id` FOREIGN KEY (`user_id`) REFERENCES `Users` (`user_id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Constraints for table `Problems`
--
ALTER TABLE `Problems`
  ADD CONSTRAINT `author_id` FOREIGN KEY (`author_id`) REFERENCES `Users` (`user_id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Constraints for table `Problems_Badges`
--
ALTER TABLE `Problems_Badges`
  ADD CONSTRAINT `fk_pb_badge_id` FOREIGN KEY (`badge_id`) REFERENCES `Badges` (`badge_id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_pb_problem_id` FOREIGN KEY (`problem_id`) REFERENCES `Problems` (`problem_id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Constraints for table `Problems_Languages`
--
ALTER TABLE `Problems_Languages`
  ADD CONSTRAINT `fk_pl_language_id` FOREIGN KEY (`language_id`) REFERENCES `Languages` (`language_id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_pl_problem_id` FOREIGN KEY (`problem_id`) REFERENCES `Problems` (`problem_id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_pl_translator_id` FOREIGN KEY (`translator_id`) REFERENCES `Users` (`user_id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Constraints for table `Problems_Tags`
--
ALTER TABLE `Problems_Tags`
  ADD CONSTRAINT `fk_t_problem_id` FOREIGN KEY (`problem_id`) REFERENCES `Problems` (`problem_id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_t_tag_id` FOREIGN KEY (`tag_id`) REFERENCES `Tags` (`tag_id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Constraints for table `Roles_Permissions`
--
ALTER TABLE `Roles_Permissions`
  ADD CONSTRAINT `fk_rp_permission_id` FOREIGN KEY (`permission_id`) REFERENCES `Permissions` (`permission_id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_rp_role_id` FOREIGN KEY (`role_id`) REFERENCES `Roles` (`role_id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Constraints for table `Runs`
--
ALTER TABLE `Runs`
  ADD CONSTRAINT `fk_r_contest_id` FOREIGN KEY (`contest_id`) REFERENCES `Contests` (`contest_id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_r_problem_id` FOREIGN KEY (`problem_id`) REFERENCES `Problems` (`problem_id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_r_user_id` FOREIGN KEY (`user_id`) REFERENCES `Users` (`user_id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Constraints for table `Schools`
--
ALTER TABLE `Schools`
  ADD CONSTRAINT `state_id` FOREIGN KEY (`state_id`) REFERENCES `States` (`state_id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Constraints for table `States`
--
ALTER TABLE `States`
  ADD CONSTRAINT `country_id` FOREIGN KEY (`country_id`) REFERENCES `Countries` (`country_id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Constraints for table `Users`
--
ALTER TABLE `Users`
  ADD CONSTRAINT `fk_country_id` FOREIGN KEY (`country_id`) REFERENCES `Countries` (`country_id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_main_email_id` FOREIGN KEY (`main_email_id`) REFERENCES `Emails` (`email_id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_state_id` FOREIGN KEY (`state_id`) REFERENCES `States` (`state_id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `school_id` FOREIGN KEY (`school_id`) REFERENCES `Schools` (`school_id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Constraints for table `Users_Badges`
--
ALTER TABLE `Users_Badges`
  ADD CONSTRAINT `fk_ub_badge_id` FOREIGN KEY (`badge_id`) REFERENCES `Badges` (`badge_id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_ub_last_problem_id` FOREIGN KEY (`last_problem_id`) REFERENCES `Problems` (`problem_id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_ub_user_id` FOREIGN KEY (`user_id`) REFERENCES `Users` (`user_id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Constraints for table `Users_Permissions`
--
ALTER TABLE `Users_Permissions`
  ADD CONSTRAINT `fk_up_permission_id` FOREIGN KEY (`permission_id`) REFERENCES `Permissions` (`permission_id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_up_user_id` FOREIGN KEY (`user_id`) REFERENCES `Users` (`user_id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Constraints for table `User_Roles`
--
ALTER TABLE `User_Roles`
  ADD CONSTRAINT `fk_ur_role_id` FOREIGN KEY (`role_id`) REFERENCES `Roles` (`role_id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_ur_user_id` FOREIGN KEY (`user_id`) REFERENCES `Users` (`user_id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
