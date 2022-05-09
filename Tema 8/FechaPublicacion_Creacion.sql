use GBDgestionaTests;

-- Que la fecha de publicación de un test no sea anterior a la fecha de creación

delimiter $$

CREATE TRIGGER compruebaFechaPublicacion
	BEFORE INSERT
ON tests
FOR EACH ROW
	BEGIN
		IF NEW.fecpublic < NEW.feccreacion THEN
			SIGNAL SQLSTATE '45000' -- El 45000 está vacío
				SET MESSAGE_TEXT = 'La fecha de creación no puede ser posterior a la de publicación';
        END IF;
	END $$
delimiter ;