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
 * Value Object class for table `ACLs`.
 *
 * @access public
 */
class ACLs extends \OmegaUp\DAO\VO\VO {
    const FIELD_NAMES = [
        'acl_id' => true,
        'owner_id' => true,
    ];

    function __construct(?array $data = null) {
        if (empty($data)) {
            return;
        }
        $unknownColumns = array_diff_key($data, self::FIELD_NAMES);
        if (!empty($unknownColumns)) {
            throw new \Exception('Unknown columns: ' . join(', ', array_keys($unknownColumns)));
        }
        if (isset($data['acl_id'])) {
            $this->acl_id = (int)$data['acl_id'];
        }
        if (isset($data['owner_id'])) {
            $this->owner_id = (int)$data['owner_id'];
        }
    }

    /**
     * [Campo no documentado]
     * Llave Primaria
     * Auto Incremento
     *
     * @var int|null
     */
    public $acl_id = 0;

    /**
     * El usuario que creó el objeto y que tiene un rol de administrador implícito
     *
     * @var int|null
     */
    public $owner_id = null;
}
