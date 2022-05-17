use bdgestproyectos;

/*P1. */
DROP TRIGGER IF EXISTS sumarGratificaciones;
delimiter $$
CREATE TRIGGER sumarGratificaciones
	AFTER UPDATE 
ON proyectos
FOR EACH ROW
	BEGIN
		DECLARE mensaje varchar(100);
		IF (NEW.fecfinproy IS NOT NULL 
			AND OLD.fecfinproy IS NULL) THEN
            IF date_add(NEW.feciniproy, interval NEW.duracionprevista DAY) >= NEW.fecfinproy THEN
				BEGIN   
					INSERT INTO gratificaciones
						(numproyecto, numtecnico, tiempoenproyecto, gratifTotal)
					(select numproyecto, numtec, datediff(fecfintrabajo, fecinitrabajo),
						datediff(fecfintrabajo, fecinitrabajo)*NEW.gratifPorDia
                        from tecnicosenproyectos
                        where numproyecto = NEW.numproyecto);
				END;
			END IF;
        END IF;
	END $$
delimiter ;

/*P2. */

DROP TRIGGER IF EXISTS sumarGratificaciones;
delimiter $$
CREATE TRIGGER sumarGratificaciones
	BEFORE UPDATE 
ON proyectos
FOR EACH ROW
	BEGIN
		DECLARE mensaje varchar(100);
		IF (old.feciniproy is not null) THEN
           signal sqlstate'45000' set message_text = '';
        END IF;
	END $$
delimiter ;

