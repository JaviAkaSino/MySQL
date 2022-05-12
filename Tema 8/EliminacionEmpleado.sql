use empresaclase;

-- ALTER TABLE departamentos
	-- ADD COLUMN numempleados int not null default 0;
    
-- Calcular el número de empleados de cada departamento
DROP PROCEDURE IF EXISTS numeroEmpleados;
delimiter $$
CREATE PROCEDURE numeroEmpleados()
BEGIN
	UPDATE departamentos
    SET numempleados = (select count(*) from empleados where empleados.numde = departamentos.numde);
END$$
delimiter ;

call numeroEmpleados();



/* Cuando borro a un empleado, si es director de un departamento, no se puede hacer */

DROP TRIGGER IF EXISTS empleadoBorradoDirector
delimiter $$
CREATE TRIGGER empleadoBorradoDirector
	BEFORE DELETE
    ON empleados
FOR EACH ROW
	BEGIN
		IF (select fecinidir from dirigir where numempdirec = new.numem) not null AND
			(select fecfindir from dirigir where numempdirec = new.numem) is null THEN
			SIGNAL SQLSTATE '45000' -- El 45000 está vacío
				SET MESSAGE_TEXT = 'No se puede borrar a un director de departamento';
        END IF;
    END;

/*En todas las operaciones, que se recalcule el numero de empleados del departamento afectado*/

-- Cuando se borra un empleado
DROP TRIGGER IF EXISTS numeroEmpleadosBorrado
delimiter $$
CREATE TRIGGER numeroEmpleadosBorrado
	AFTER DELETE
    ON empleados
FOR EACH ROW
	BEGIN
		UPDATE departamentos
        SET numempleados = numempleados - 1
        WHERE numde = OLD.numde;
    END;

