use GBDgestionaTests;

-- Que la fecha de publicación de un test no sea anterior a la fecha de creación

DROP TRIGGER IF EXISTS compruebaFechaPublicacion;
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

-- Igual pero para modificación

DROP TRIGGER IF EXISTS compruebaFechaPublicacionUpdate;
delimiter $$
CREATE TRIGGER compruebaFechaPublicacionUpdate
	BEFORE UPDATE
ON tests
FOR EACH ROW
	BEGIN
		IF (NEW.fecpublic <> OLD.fecpublic OR NEW.feccreacion <> OLD.feccreacion) AND
			NEW.fecpublic < NEW.feccreacion THEN
			SIGNAL SQLSTATE '45000' -- El 45000 está vacío
				SET MESSAGE_TEXT = 'La fecha de creación no puede ser posterior a la de publicación';
        END IF;
	END $$
delimiter ;