use empresaclase;

/*1. Comprueba que no podamos contratar a empleados que no tengan 16 años.*/
DROP TRIGGER IF EXISTS compruebaEdad;
delimiter $$
CREATE TRIGGER compruebaEdad 
	BEFORE INSERT
ON empleados
FOR EACH ROW
	BEGIN
		IF date_add(NEW.fecnaem, interval 16 year) > curdate() THEN
			SIGNAL SQLSTATE '45000' -- El 45000 está vacío
				SET MESSAGE_TEXT = 'El empleado no tiene la edad apropiada';
        END IF;
	END $$
delimiter ;

/*2. Comprueba que el departamento de las personas que ejercen la dirección 
de los departamentos pertenezcan a dicho departamento.*/
DROP TRIGGER IF EXISTS compruebaDirDepto;
delimiter $$
CREATE TRIGGER compruebaDirDepto
	BEFORE INSERT 
ON dirigir
FOR EACH ROW
	BEGIN
		DECLARE mensaje varchar(100);
		IF NEW.numdepto <> (select numde
						from empleados
                        where numem = NEW.numempdirec) THEN
			BEGIN   
				SET mensaje = concat('El empleado no pertenece al departamento ', NEW.numdepto);
				SIGNAL SQLSTATE '45000' -- El 45000 está vacío
				SET MESSAGE_TEXT = mensaje;
			END;
        END IF;
	END $$
delimiter ;

/*3. Añade lo que consideres oportuno para que las comprobaciones anteriores 
se hagan también cuando se modifiquen la fecha de nacimiento de un empleado o
al director/a de un departamento.*/

-- Edad
DROP TRIGGER IF EXISTS compruebaEdadUpdate;
delimiter $$
CREATE TRIGGER compruebaEdadUpdate
	BEFORE UPDATE
ON empleados
FOR EACH ROW
	BEGIN
		IF NEW.fecnaem <> OLD.fecnaem AND -- Si la fecha cambia y es menor
			date_add(NEW.fecnaem, interval 16 year) > curdate() THEN
			SIGNAL SQLSTATE '45000' -- El 45000 está vacío
				SET MESSAGE_TEXT = 'El empleado no tiene la edad apropiada';
        END IF;
	END $$
delimiter ;

-- Direccion
DROP TRIGGER IF EXISTS compruebaDirDeptoUpdate;
delimiter $$
CREATE TRIGGER compruebaDirDeptoUpdate
	BEFORE UPDATE 
ON dirigir
FOR EACH ROW
	BEGIN
		DECLARE mensaje varchar(100);
		IF (NEW.numdepto <> OLD.numdepto or NEW.numempdirec <> OLD. numempdirec) AND
			NEW.numdepto <> (select numde from empleados where numem = NEW.numempdirec) THEN
            
			BEGIN   
				SET mensaje = concat('El empleado no pertenece al departamento ', NEW.numdepto);
				SIGNAL SQLSTATE '45000' -- El 45000 está vacío
				SET MESSAGE_TEXT = mensaje;
			END;
		
        END IF;
	END $$
delimiter ;

/*4. Añade una columna numempleados en la tabla departamentos. En ella vamos 
a almacenar el número de empleados de cada departamento.*/

/*ALTER TABLE departamentos
	ADD COLUMN numempleados int not null default 0;*/

/*5. Prepara un procecdimiento que para cada departamento calcule el número de 
empleados y guarde dicho valor en la columna creada en el apartado 4.*/

DROP PROCEDURE IF EXISTS numeroEmpleados;
delimiter $$
CREATE PROCEDURE numeroEmpleados()
BEGIN
	UPDATE departamentos
    SET numempleados = (select count(*) from empleados where empleados.numde = departamentos.numde);
END$$
delimiter ;

call numeroEmpleados();

/*6. Prepara lo que consideres necesario para que cada trimestre se compruebe y 
actualice, en caso de ser necesario, el número de empleados de cada departamento.*/

DROP EVENT IF EXISTS nombre_evento;
delimiter $$
CREATE EVENT nombre_evento
ON SCHEDULE
	EVERY 1 DAY
	STARTS ‘fecha_inicio’
	ENDS ‘fecha_final’
DO
	BEGIN
		CALL procedimiento();
	END $$

delimiter ;


/*7. Asegúrate de que cuando eliminemos a un empleado, se actualice el número de 
empleados del departamento al que pertenece dicho empleado.*/

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

/*Para la base de datos gestionTests haz los siguientes ejercicios:*/

use GBDgestionaTests;

/*8. El profesorado también puede matricularse en nuestro centro pero no de las materias que imparte. Para ello tendrás que hacer lo sigjuiente:
Añade el campo dni en la tabla de alumnado.
Añade la tabla profesorado (codprof, nomprof, ape1prof, ape2prof, dniprof).
Añade una clave foránea en materias ⇒ codprof references a profesorado (codprof).
Introduce datos en las tablas y campos creados para hacer pruebas.*/



/*9. La fecha de publicación de un test no puede ser anterior a la de publicación.*/

-- Hecho en el archivo FechaPublicacion_Creacion

/*10. El alumnado no podrá hacer más de una vez un test (ya existe el registro de dicho 
test para el alumno/a) si dicho test no es repetible (tests.repetible = 0|false).*/

DROP TRIGGER IF EXISTS compruebaRepeticionTestInsert;
delimiter $$
CREATE TRIGGER compruebaRepeticionTestInsert 
	BEFORE INSERT
ON respuestas
FOR EACH ROW
	BEGIN
		IF (select repetible from tests where codtest = new.codtest) = 0 AND -- Si no es repetible
			-- Y ya hay algún intento hecho 
			(select count(*) from respuestas where codtest = new.codtest AND numexped = new.numexped) > 0 THEN
			SIGNAL SQLSTATE '45000' -- El 45000 está vacío
				SET MESSAGE_TEXT = 'El test no se puede repetir';
        END IF;
	END $$
delimiter ;





