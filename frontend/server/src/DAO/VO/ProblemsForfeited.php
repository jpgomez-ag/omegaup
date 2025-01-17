<?php
/** ******************************************************************************* *
  *                    !ATENCION!                                                   *
  *                                                                                 *
  * Este codigo es generado automaticamente. Si lo modificas tus cambios seran      *
  * reemplazados la proxima vez que se autogenere el codigo.                        *
  *                                                                                 *
  * ******************************************************************************* */

namespace OmegaUp\DAO\VO;

/**
 * Value Object class for table `Problems_Forfeited`.
 *
 * @access public
 */
class ProblemsForfeited extends \OmegaUp\DAO\VO\VO {
    const FIELD_NAMES = [
        'user_id' => true,
        'problem_id' => true,
        'forfeited_date' => true,
    ];

    function __construct(?array $data = null) {
        if (empty($data)) {
            return;
        }
        $unknownColumns = array_diff_key($data, self::FIELD_NAMES);
        if (!empty($unknownColumns)) {
            throw new \Exception('Unknown columns: ' . join(', ', array_keys($unknownColumns)));
        }
        if (isset($data['user_id'])) {
            $this->user_id = (int)$data['user_id'];
        }
        if (isset($data['problem_id'])) {
            $this->problem_id = (int)$data['problem_id'];
        }
        if (isset($data['forfeited_date'])) {
            /**
             * @var string|int|float $data['forfeited_date']
             * @var int $this->forfeited_date
             */
            $this->forfeited_date = \OmegaUp\DAO\DAO::fromMySQLTimestamp($data['forfeited_date']);
        } else {
            $this->forfeited_date = \OmegaUp\Time::get();
        }
    }

    /**
     * Identificador de usuario
     * Llave Primaria
     *
     * @var int|null
     */
    public $user_id = null;

    /**
     * [Campo no documentado]
     * Llave Primaria
     *
     * @var int|null
     */
    public $problem_id = null;

    /**
     * [Campo no documentado]
     *
     * @var int
     */
    public $forfeited_date;  // CURRENT_TIMESTAMP
}
