<?php
/** ******************************************************************************* *
  *                    !ATENCION!                                                   *
  *                                                                                 *
  * Este codigo es generado automaticamente. Si lo modificas tus cambios seran      *
  * reemplazados la proxima vez que se autogenere el codigo.                        *
  *                                                                                 *
  * ******************************************************************************* */

namespace OmegaUp\DAO\Base;

/** ProblemOfTheWeek Data Access Object (DAO) Base.
 *
 * Esta clase contiene toda la manipulacion de bases de datos que se necesita
 * para almacenar de forma permanente y recuperar instancias de objetos
 * {@link \OmegaUp\DAO\VO\ProblemOfTheWeek}.
 * @access public
 * @abstract
 */
abstract class ProblemOfTheWeek {
    /**
     * Actualizar registros.
     *
     * @param \OmegaUp\DAO\VO\ProblemOfTheWeek $Problem_Of_The_Week El objeto de tipo ProblemOfTheWeek a actualizar.
     *
     * @return int Número de filas afectadas
     */
    final public static function update(\OmegaUp\DAO\VO\ProblemOfTheWeek $Problem_Of_The_Week) : int {
        $sql = 'UPDATE `Problem_Of_The_Week` SET `problem_id` = ?, `time` = ?, `difficulty` = ? WHERE `problem_of_the_week_id` = ?;';
        $params = [
            is_null($Problem_Of_The_Week->problem_id) ? null : (int)$Problem_Of_The_Week->problem_id,
            $Problem_Of_The_Week->time,
            $Problem_Of_The_Week->difficulty,
            (int)$Problem_Of_The_Week->problem_of_the_week_id,
        ];
        \OmegaUp\MySQLConnection::getInstance()->Execute($sql, $params);
        return \OmegaUp\MySQLConnection::getInstance()->Affected_Rows();
    }

    /**
     * Obtener {@link \OmegaUp\DAO\VO\ProblemOfTheWeek} por llave primaria.
     *
     * Este metodo cargará un objeto {@link \OmegaUp\DAO\VO\ProblemOfTheWeek}
     * de la base de datos usando sus llaves primarias.
     *
     * @return ?\OmegaUp\DAO\VO\ProblemOfTheWeek Un objeto del tipo
     * {@link \OmegaUp\DAO\VO\ProblemOfTheWeek} o NULL si no hay tal
     * registro.
     */
    final public static function getByPK(int $problem_of_the_week_id) : ?\OmegaUp\DAO\VO\ProblemOfTheWeek {
        $sql = 'SELECT `Problem_Of_The_Week`.`problem_of_the_week_id`, `Problem_Of_The_Week`.`problem_id`, `Problem_Of_The_Week`.`time`, `Problem_Of_The_Week`.`difficulty` FROM Problem_Of_The_Week WHERE (problem_of_the_week_id = ?) LIMIT 1;';
        $params = [$problem_of_the_week_id];
        $row = \OmegaUp\MySQLConnection::getInstance()->GetRow($sql, $params);
        if (empty($row)) {
            return null;
        }
        return new \OmegaUp\DAO\VO\ProblemOfTheWeek($row);
    }

    /**
     * Eliminar registros.
     *
     * Este metodo eliminará el registro identificado por la llave primaria en
     * el objeto {@link \OmegaUp\DAO\VO\ProblemOfTheWeek} suministrado.
     * Una vez que se ha eliminado un objeto, este no puede ser restaurado
     * llamando a {@link replace()}, ya que este último creará un nuevo
     * registro con una llave primaria distinta a la que estaba en el objeto
     * eliminado.
     *
     * Si no puede encontrar el registro a eliminar,
     * {@link \OmegaUp\Exceptions\NotFoundException} será arrojada.
     *
     * @param \OmegaUp\DAO\VO\ProblemOfTheWeek $Problem_Of_The_Week El
     * objeto de tipo \OmegaUp\DAO\VO\ProblemOfTheWeek a eliminar
     *
     * @throws \OmegaUp\Exceptions\NotFoundException Se arroja cuando no se
     * encuentra el objeto a eliminar en la base de datos.
     */
    final public static function delete(\OmegaUp\DAO\VO\ProblemOfTheWeek $Problem_Of_The_Week) : void {
        $sql = 'DELETE FROM `Problem_Of_The_Week` WHERE problem_of_the_week_id = ?;';
        $params = [$Problem_Of_The_Week->problem_of_the_week_id];

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
     * {@link \OmegaUp\DAO\VO\ProblemOfTheWeek}.
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
     * @return \OmegaUp\DAO\VO\ProblemOfTheWeek[] Un arreglo que contiene objetos del tipo
     * {@link \OmegaUp\DAO\VO\ProblemOfTheWeek}.
     *
     * @psalm-return array<int, \OmegaUp\DAO\VO\ProblemOfTheWeek>
     */
    final public static function getAll(
        ?int $pagina = null,
        int $filasPorPagina = 100,
        ?string $orden = null,
        string $tipoDeOrden = 'ASC'
    ) : array {
        $sql = 'SELECT `Problem_Of_The_Week`.`problem_of_the_week_id`, `Problem_Of_The_Week`.`problem_id`, `Problem_Of_The_Week`.`time`, `Problem_Of_The_Week`.`difficulty` from Problem_Of_The_Week';
        if (!is_null($orden)) {
            $sql .= ' ORDER BY `' . \OmegaUp\MySQLConnection::getInstance()->escape($orden) . '` ' . ($tipoDeOrden == 'DESC' ? 'DESC' : 'ASC');
        }
        if (!is_null($pagina)) {
            $sql .= ' LIMIT ' . (($pagina - 1) * $filasPorPagina) . ', ' . (int)$filasPorPagina;
        }
        $allData = [];
        foreach (\OmegaUp\MySQLConnection::getInstance()->GetAll($sql) as $row) {
            $allData[] = new \OmegaUp\DAO\VO\ProblemOfTheWeek($row);
        }
        return $allData;
    }

    /**
     * Crear registros.
     *
     * Este metodo creará una nueva fila en la base de datos de acuerdo con los
     * contenidos del objeto {@link \OmegaUp\DAO\VO\ProblemOfTheWeek}
     * suministrado.
     *
     * @param \OmegaUp\DAO\VO\ProblemOfTheWeek $Problem_Of_The_Week El
     * objeto de tipo {@link \OmegaUp\DAO\VO\ProblemOfTheWeek} a crear.
     *
     * @return int Un entero mayor o igual a cero identificando el número de filas afectadas.
     */
    final public static function create(\OmegaUp\DAO\VO\ProblemOfTheWeek $Problem_Of_The_Week) : int {
        $sql = 'INSERT INTO Problem_Of_The_Week (`problem_id`, `time`, `difficulty`) VALUES (?, ?, ?);';
        $params = [
            is_null($Problem_Of_The_Week->problem_id) ? null : (int)$Problem_Of_The_Week->problem_id,
            $Problem_Of_The_Week->time,
            $Problem_Of_The_Week->difficulty,
        ];
        \OmegaUp\MySQLConnection::getInstance()->Execute($sql, $params);
        $affectedRows = \OmegaUp\MySQLConnection::getInstance()->Affected_Rows();
        if ($affectedRows == 0) {
            return 0;
        }
        $Problem_Of_The_Week->problem_of_the_week_id = \OmegaUp\MySQLConnection::getInstance()->Insert_ID();

        return $affectedRows;
    }
}
