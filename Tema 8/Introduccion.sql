
use empresaclase;
delimiter $$

CREATE TRIGGER compruebaEdad 
	BEFORE INSERT
ON empleados
FOR EACH ROW
	BEGIN
		IF date_add(NEW.fecnacim, interval 16 year) > curdate() THEN
			SIGNAL SQLSTATE '45000' -- El 45000 está vacío
				SET MESSAGE_TEXT = 'El empleado no tiene la edad apropiada';
        END IF;
	END $$
delimiter ;


