<?php
/** ******************************************************************************* *
  *                    !ATENCION!                                                   *
  *                                                                                 *
  * Este codigo es generado automaticamente. Si lo modificas tus cambios seran      *
  * reemplazados la proxima vez que se autogenere el codigo.                        *
  *                                                                                 *
  * ******************************************************************************* */

namespace OmegaUp\DAO\Base;

/** RolesPermissions Data Access Object (DAO) Base.
 *
 * Esta clase contiene toda la manipulacion de bases de datos que se necesita
 * para almacenar de forma permanente y recuperar instancias de objetos
 * {@link \OmegaUp\DAO\VO\RolesPermissions}.
 * @access public
 * @abstract
 */
abstract class RolesPermissions {
    /**
     * Obtener {@link \OmegaUp\DAO\VO\RolesPermissions} por llave primaria.
     *
     * Este metodo cargará un objeto {@link \OmegaUp\DAO\VO\RolesPermissions}
     * de la base de datos usando sus llaves primarias.
     *
     * @return ?\OmegaUp\DAO\VO\RolesPermissions Un objeto del tipo
     * {@link \OmegaUp\DAO\VO\RolesPermissions} o NULL si no hay tal
     * registro.
     */
    final public static function getByPK(?int $role_id, ?int $permission_id) : ?\OmegaUp\DAO\VO\RolesPermissions {
        $sql = 'SELECT `Roles_Permissions`.`role_id`, `Roles_Permissions`.`permission_id` FROM Roles_Permissions WHERE (role_id = ? AND permission_id = ?) LIMIT 1;';
        $params = [$role_id, $permission_id];
        $row = \OmegaUp\MySQLConnection::getInstance()->GetRow($sql, $params);
        if (empty($row)) {
            return null;
        }
        return new \OmegaUp\DAO\VO\RolesPermissions($row);
    }

    /**
     * Eliminar registros.
     *
     * Este metodo eliminará el registro identificado por la llave primaria en
     * el objeto {@link \OmegaUp\DAO\VO\RolesPermissions} suministrado.
     * Una vez que se ha eliminado un objeto, este no puede ser restaurado
     * llamando a {@link replace()}, ya que este último creará un nuevo
     * registro con una llave primaria distinta a la que estaba en el objeto
     * eliminado.
     *
     * Si no puede encontrar el registro a eliminar,
     * {@link \OmegaUp\Exceptions\NotFoundException} será arrojada.
     *
     * @param \OmegaUp\DAO\VO\RolesPermissions $Roles_Permissions El
     * objeto de tipo \OmegaUp\DAO\VO\RolesPermissions a eliminar
     *
     * @throws \OmegaUp\Exceptions\NotFoundException Se arroja cuando no se
     * encuentra el objeto a eliminar en la base de datos.
     */
    final public static function delete(\OmegaUp\DAO\VO\RolesPermissions $Roles_Permissions) : void {
        $sql = 'DELETE FROM `Roles_Permissions` WHERE role_id = ? AND permission_id = ?;';
        $params = [$Roles_Permissions->role_id, $Roles_Permissions->permission_id];

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
     * {@link \OmegaUp\DAO\VO\RolesPermissions}.
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
     * @return \OmegaUp\DAO\VO\RolesPermissions[] Un arreglo que contiene objetos del tipo
     * {@link \OmegaUp\DAO\VO\RolesPermissions}.
     *
     * @psalm-return array<int, \OmegaUp\DAO\VO\RolesPermissions>
     */
    final public static function getAll(
        ?int $pagina = null,
        int $filasPorPagina = 100,
        ?string $orden = null,
        string $tipoDeOrden = 'ASC'
    ) : array {
        $sql = 'SELECT `Roles_Permissions`.`role_id`, `Roles_Permissions`.`permission_id` from Roles_Permissions';
        if (!is_null($orden)) {
            $sql .= ' ORDER BY `' . \OmegaUp\MySQLConnection::getInstance()->escape($orden) . '` ' . ($tipoDeOrden == 'DESC' ? 'DESC' : 'ASC');
        }
        if (!is_null($pagina)) {
            $sql .= ' LIMIT ' . (($pagina - 1) * $filasPorPagina) . ', ' . (int)$filasPorPagina;
        }
        $allData = [];
        foreach (\OmegaUp\MySQLConnection::getInstance()->GetAll($sql) as $row) {
            $allData[] = new \OmegaUp\DAO\VO\RolesPermissions($row);
        }
        return $allData;
    }

    /**
     * Crear registros.
     *
     * Este metodo creará una nueva fila en la base de datos de acuerdo con los
     * contenidos del objeto {@link \OmegaUp\DAO\VO\RolesPermissions}
     * suministrado.
     *
     * @param \OmegaUp\DAO\VO\RolesPermissions $Roles_Permissions El
     * objeto de tipo {@link \OmegaUp\DAO\VO\RolesPermissions} a crear.
     *
     * @return int Un entero mayor o igual a cero identificando el número de filas afectadas.
     */
    final public static function create(\OmegaUp\DAO\VO\RolesPermissions $Roles_Permissions) : int {
        $sql = 'INSERT INTO Roles_Permissions (`role_id`, `permission_id`) VALUES (?, ?);';
        $params = [
            is_null($Roles_Permissions->role_id) ? null : (int)$Roles_Permissions->role_id,
            is_null($Roles_Permissions->permission_id) ? null : (int)$Roles_Permissions->permission_id,
        ];
        \OmegaUp\MySQLConnection::getInstance()->Execute($sql, $params);
        $affectedRows = \OmegaUp\MySQLConnection::getInstance()->Affected_Rows();
        if ($affectedRows == 0) {
            return 0;
        }

        return $affectedRows;
    }
}
