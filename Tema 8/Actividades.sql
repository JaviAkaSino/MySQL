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

DROP EVENT IF EXISTS numeroEmpleadosTrimestral;
delimiter $$
CREATE EVENT numeroEmpleadosTrimestral
ON SCHEDULE
	EVERY 1 QUARTER
DO
	BEGIN
		CALL numeroEmpleados();
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

/*8. El profesorado también puede matricularse en nuestro centro pero no de las 
materias que imparte. Para ello tendrás que hacer lo siguiente:*/
	-- a. Añade el campo dni en la tabla de alumnado.
    /*ALTER TABLE alumnos
	ADD COLUMN dni char(9) not null;*/
		
	-- b. Añade la tabla profesorado (codprof, nomprof, ape1prof, ape2prof, dniprof).
    CREATE TABLE IF NOT EXISTS profesorado
	(
        codprof int not null default 0,
        nomprof varchar(30),
        ape1prof varchar(30),
        ape2prof varchar(30),
        dniprof char(9),
        
        constraint pk_profesorado primary key (codprof)
        );
		
	-- c. Añade una clave foránea en materias ⇒ codprof references a profesorado (codprof).
	-- d. Introduce datos en las tablas y campos creados para hacer pruebas.*/



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

-- Para la base de datos gestionPromo 
use ventapromoscompleta;

/*1. El precio de un artículo en promoción nunca debe ser mayor o igual al precio 
habitual de venta (el de la tabla artículos).*/

-- Para la base de datos bdalmacen
use bdalmacen;

/*1. Hemos detectado que hay usuarios que consiguen que el precio del pedido sea negativo, 
con lo cual no se hace un cobro del cliente sino un pago, por esta razón hemos decidido
 comprobar el precio del pedido y hacer que siempre sea un valor positivo.*/
 

 
/*2. Cuando vendemos un producto:
Comprobar si tenemos suficiente stock para ello, si no es así, mostraremos un mensaje de no 
disponibilidad.*/

DROP TRIGGER IF EXISTS compruebaStockInsert;
delimiter $$
CREATE TRIGGER compruebaStockInsert 
	BEFORE INSERT
ON pedidos
FOR EACH ROW
	BEGIN
		IF (NEW.cantidad > (select stock from productos where codproducto = NEW.codproducto)) THEN
			SIGNAL SQLSTATE '45000' -- El 45000 está vacío
				SET MESSAGE_TEXT = 'No hay stock suficiente';
        END IF;
	END $$
delimiter ;


/*Si tenemos suficiente stock, se hará la venta y se disminuirá de forma automática el 
stock de dicho producto.




/*3. Queremos que, cuando queden menos de 5 unidades almacenadas  en nuestro almacén, se 
realice un pedido automático a nuestro proveedor.



/*4. Añade una columna de tipo bit para indicar los empleados jubilados y otra con la fecha 
de jubilación.



/*5. Cuando un empleado se jubila, si es director de algún departamento, debe aparecer un 
mensaje que recuerde que debemos buscar un nuevo director para ese departamento.



/*6. Prepara un evento que, cada trimestre, compruebe si hay algún departamento sin director 
actual, en cuyo caso mostraremos un mensaje con todos los departamentos sin director.



/*7. Crea un evento que, al comienzo de cada año, compruebe los empleados jubilados hace diez 
años o más y los elimine de la base de datos (haz una copia antes de ejecutar este apartado). 
Deberá eliminar, también, los registros de la tabla dirigir asociados a estos empleados.



/*8. Crea un evento anual que incremente en un 2,5% el salario de los empleados no jubilados. Este evento se creará deshabilitado.*/



