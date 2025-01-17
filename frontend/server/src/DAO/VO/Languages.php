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
 * Value Object class for table `Languages`.
 *
 * @access public
 */
class Languages extends \OmegaUp\DAO\VO\VO {
    const FIELD_NAMES = [
        'language_id' => true,
        'name' => true,
        'country_id' => true,
    ];

    function __construct(?array $data = null) {
        if (empty($data)) {
            return;
        }
        $unknownColumns = array_diff_key($data, self::FIELD_NAMES);
        if (!empty($unknownColumns)) {
            throw new \Exception('Unknown columns: ' . join(', ', array_keys($unknownColumns)));
        }
        if (isset($data['language_id'])) {
            $this->language_id = (int)$data['language_id'];
        }
        if (isset($data['name'])) {
            $this->name = strval($data['name']);
        }
        if (isset($data['country_id'])) {
            $this->country_id = strval($data['country_id']);
        }
    }

    /**
     * [Campo no documentado]
     * Llave Primaria
     * Auto Incremento
     *
     * @var int|null
     */
    public $language_id = 0;

    /**
     * [Campo no documentado]
     *
     * @var string|null
     */
    public $name = null;

    /**
     * Se guarda la relación con el país para defaultear más rápido.
     *
     * @var string|null
     */
    public $country_id = null;
}
