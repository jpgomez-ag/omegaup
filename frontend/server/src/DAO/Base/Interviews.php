<?php
/** ******************************************************************************* *
  *                    !ATENCION!                                                   *
  *                                                                                 *
  * Este codigo es generado automaticamente. Si lo modificas tus cambios seran      *
  * reemplazados la proxima vez que se autogenere el codigo.                        *
  *                                                                                 *
  * ******************************************************************************* */

namespace OmegaUp\DAO\Base;

/** Interviews Data Access Object (DAO) Base.
 *
 * Esta clase contiene toda la manipulacion de bases de datos que se necesita
 * para almacenar de forma permanente y recuperar instancias de objetos
 * {@link \OmegaUp\DAO\VO\Interviews}.
 * @access public
 * @abstract
 */
abstract class Interviews {
    /**
     * Actualizar registros.
     *
     * @param \OmegaUp\DAO\VO\Interviews $Interviews El objeto de tipo Interviews a actualizar.
     *
     * @return int Número de filas afectadas
     */
    final public static function update(\OmegaUp\DAO\VO\Interviews $Interviews) : int {
        $sql = 'UPDATE `Interviews` SET `problemset_id` = ?, `acl_id` = ?, `alias` = ?, `title` = ?, `description` = ?, `window_length` = ? WHERE `interview_id` = ?;';
        $params = [
            is_null($Interviews->problemset_id) ? null : (int)$Interviews->problemset_id,
            is_null($Interviews->acl_id) ? null : (int)$Interviews->acl_id,
            $Interviews->alias,
            $Interviews->title,
            $Interviews->description,
            is_null($Interviews->window_length) ? null : (int)$Interviews->window_length,
            (int)$Interviews->interview_id,
        ];
        \OmegaUp\MySQLConnection::getInstance()->Execute($sql, $params);
        return \OmegaUp\MySQLConnection::getInstance()->Affected_Rows();
    }

    /**
     * Obtener {@link \OmegaUp\DAO\VO\Interviews} por llave primaria.
     *
     * Este metodo cargará un objeto {@link \OmegaUp\DAO\VO\Interviews}
     * de la base de datos usando sus llaves primarias.
     *
     * @return ?\OmegaUp\DAO\VO\Interviews Un objeto del tipo
     * {@link \OmegaUp\DAO\VO\Interviews} o NULL si no hay tal
     * registro.
     */
    final public static function getByPK(int $interview_id) : ?\OmegaUp\DAO\VO\Interviews {
        $sql = 'SELECT `Interviews`.`interview_id`, `Interviews`.`problemset_id`, `Interviews`.`acl_id`, `Interviews`.`alias`, `Interviews`.`title`, `Interviews`.`description`, `Interviews`.`window_length` FROM Interviews WHERE (interview_id = ?) LIMIT 1;';
        $params = [$interview_id];
        $row = \OmegaUp\MySQLConnection::getInstance()->GetRow($sql, $params);
        if (empty($row)) {
            return null;
        }
        return new \OmegaUp\DAO\VO\Interviews($row);
    }

    /**
     * Eliminar registros.
     *
     * Este metodo eliminará el registro identificado por la llave primaria en
     * el objeto {@link \OmegaUp\DAO\VO\Interviews} suministrado.
     * Una vez que se ha eliminado un objeto, este no puede ser restaurado
     * llamando a {@link replace()}, ya que este último creará un nuevo
     * registro con una llave primaria distinta a la que estaba en el objeto
     * eliminado.
     *
     * Si no puede encontrar el registro a eliminar,
     * {@link \OmegaUp\Exceptions\NotFoundException} será arrojada.
     *
     * @param \OmegaUp\DAO\VO\Interviews $Interviews El
     * objeto de tipo \OmegaUp\DAO\VO\Interviews a eliminar
     *
     * @throws \OmegaUp\Exceptions\NotFoundException Se arroja cuando no se
     * encuentra el objeto a eliminar en la base de datos.
     */
    final public static function delete(\OmegaUp\DAO\VO\Interviews $Interviews) : void {
        $sql = 'DELETE FROM `Interviews` WHERE interview_id = ?;';
        $params = [$Interviews->interview_id];

        \OmegaUp\MySQLConnection::getInstance()->Execute($sql, $params);
        if (\OmegaUp\MySQLConnection::getInstance()->Affected_Rows() == 0) {
            throw new \OmegaUp\Exceptions\NotFoundException('recordNotFound');
        }
    }

    /**
     * Obtener todas las filas.
     *
     * Esta funcion leerá todos los contenidos de la tabla en la base de datos
     * y construirá un arreglo que contiene objetos de tipo
     * {@link \OmegaUp\DAO\VO\Interviews}.
     * Este método consume una cantidad de memoria proporcional al número de
     * registros regresados, así que sólo debe usarse cuando la tabla en
     * cuestión es pequeña o se proporcionan parámetros para obtener un menor
     * número de filas.
     *
     * @param ?int $pagina Página a ver.
     * @param int $filasPorPagina Filas por página.
     * @param ?string $orden Debe ser una cadena con el nombre de una columna en la base de datos.
     * @param string $tipoDeOrden 'ASC' o 'DESC' el default es 'ASC'
     *
     * @return \OmegaUp\DAO\VO\Interviews[] Un arreglo que contiene objetos del tipo
     * {@link \OmegaUp\DAO\VO\Interviews}.
     *
     * @psalm-return array<int, \OmegaUp\DAO\VO\Interviews>
     */
    final public static function getAll(
        ?int $pagina = null,
        int $filasPorPagina = 100,
        ?string $orden = null,
        string $tipoDeOrden = 'ASC'
    ) : array {
        $sql = 'SELECT `Interviews`.`interview_id`, `Interviews`.`problemset_id`, `Interviews`.`acl_id`, `Interviews`.`alias`, `Interviews`.`title`, `Interviews`.`description`, `Interviews`.`window_length` from Interviews';
        if (!is_null($orden)) {
            $sql .= ' ORDER BY `' . \OmegaUp\MySQLConnection::getInstance()->escape($orden) . '` ' . ($tipoDeOrden == 'DESC' ? 'DESC' : 'ASC');
        }
        if (!is_null($pagina)) {
            $sql .= ' LIMIT ' . (($pagina - 1) * $filasPorPagina) . ', ' . (int)$filasPorPagina;
        }
        $allData = [];
        foreach (\OmegaUp\MySQLConnection::getInstance()->GetAll($sql) as $row) {
            $allData[] = new \OmegaUp\DAO\VO\Interviews($row);
        }
        return $allData;
    }

    /**
     * Crear registros.
     *
     * Este metodo creará una nueva fila en la base de datos de acuerdo con los
     * contenidos del objeto {@link \OmegaUp\DAO\VO\Interviews}
     * suministrado.
     *
     * @param \OmegaUp\DAO\VO\Interviews $Interviews El
     * objeto de tipo {@link \OmegaUp\DAO\VO\Interviews} a crear.
     *
     * @return int Un entero mayor o igual a cero identificando el número de filas afectadas.
     */
    final public static function create(\OmegaUp\DAO\VO\Interviews $Interviews) : int {
        $sql = 'INSERT INTO Interviews (`problemset_id`, `acl_id`, `alias`, `title`, `description`, `window_length`) VALUES (?, ?, ?, ?, ?, ?);';
        $params = [
            is_null($Interviews->problemset_id) ? null : (int)$Interviews->problemset_id,
            is_null($Interviews->acl_id) ? null : (int)$Interviews->acl_id,
            $Interviews->alias,
            $Interviews->title,
            $Interviews->description,
            is_null($Interviews->window_length) ? null : (int)$Interviews->window_length,
        ];
        \OmegaUp\MySQLConnection::getInstance()->Execute($sql, $params);
        $affectedRows = \OmegaUp\MySQLConnection::getInstance()->Affected_Rows();
        if ($affectedRows == 0) {
            return 0;
        }
        $Interviews->interview_id = \OmegaUp\MySQLConnection::getInstance()->Insert_ID();

        return $affectedRows;
    }
}
