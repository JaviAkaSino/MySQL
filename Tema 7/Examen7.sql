-- Javier Parodi Piñero

use GBDgestionaTests;

drop procedure if exists examen7;
delimiter $$
create procedure examen7(in curso CHAR(6))

BEGIN
	-- Orden de declaración: Variables, cursor y manejador
    -- VARIABLES
    
    DECLARE nombre_materia, descripcion_test, materia_auxiliar varchar(100) default '';
    DECLARE dias_desde, numero_preguntas int default 0;
    
    DECLARE suma_dias, suma_preguntas, contador int default 0;
    DECLARE primera_linea boolean DEFAULT true;
    DECLARE fin_cursor boolean DEFAULT false; 
    
    -- CURSOR
    DECLARE cursorTest CURSOR FOR
		SELECT materias.nommateria,
			tests.descrip, datediff(curdate(), tests.fecpublic),
            preguntas.numpreg
		FROM materias LEFT JOIN tests ON materias.codmateria = tests.codmateria
			JOIN preguntas ON tests.codtest = preguntas.codtest
		WHERE materias.cursomateria = curso
        ORDER BY materias.nommateria;
    
    -- MANEJADOR DE ERRORES
    DECLARE CONTINUE HANDLER FOR SQLSTATE '02000' -- IndexOutOfBounds
		BEGIN
			SET fin_cursor = true;
        END;
        
    DECLARE EXIT HANDLER FOR 1365 -- Division /0
		BEGIN
			SELECT concat('El curso ', curso, ' no existe, no tiene tests o sus test no tienen preguntas');
        END;
	DROP TABLE IF EXISTS listado;
    
    CREATE TEMPORARY TABLE listado (filarecorrida varchar(500)); -- Crea la tabla temporal
    
    
    
    OPEN cursorTest; -- Abre el cursor
    
    FETCH cursorTest INTO nombre_materia, descripcion_test, dias_desde, numero_preguntas; -- Primera línea
    
    INSERT INTO listado
    VALUES
		(concat('MATERIAS DEL CURSO: ', curso));
    
    WHILE fin_cursor = false DO -- Mientras no se acaben los registros
		BEGIN

			IF nombre_materia <> materia_auxiliar THEN -- Cuando el nombre de materia cambie, cabecera nueva
				BEGIN
					
					IF NOT primera_linea THEN --  Si es la primera cabecera, no añade el total
						BEGIN
							INSERT INTO listado -- Pone las medias de la materia
							VALUES
								('----------------------------------------------------------------------------------------------------'),
								(concat('Media de ', materia_auxiliar, '      ', suma_preguntas/contador, '      ', suma_dias/contador));
							
                            SET suma_preguntas = 0, suma_dias = 0; -- Y los pone a 0 para la siguiente
                            SET contador = 0; -- Pone el contador de test a 0
						END;
					END IF;
		               
					INSERT INTO listado -- Cabecera de cada materia
					VALUES 				
						('----------------------------------------------------------------------------------------------------'),
						(concat('Materia: ', nombre_materia)),
                        (concat('Test                   Núm. preguntas test                   días desde la publicación')),
                        ('----------------------------------------------------------------------------------------------------');
						
					
					SET materia_auxiliar = nombre_materia;
                    SET primera_linea = false; -- Primera fila a false
                    
                 END;
			END IF;
			-- --------------------------------------------------------
		         
			SET contador = contador + 1;
            SET suma_dias = suma_dias + dias_desde;
            SET suma_preguntas = suma_preguntas + numero_preguntas;
			
			INSERT INTO listado
            VALUES 
				(concat(descripcion_test, '      ', numero_preguntas, '      ', dias_desde)); -- Añade los datos del test
			
            
			FETCH cursorTest INTO nombre_materia, descripcion_test, dias_desde, numero_preguntas; -- Siguiente línea
        END;
	END WHILE; -- Termina el bucle, ya no hay más registros
				
	INSERT INTO listado -- Medias de la última materia
	VALUES
		('----------------------------------------------------------------------------------------------------'),
		(concat('Media de ',nombre_materia, '      ', suma_preguntas/contador, '      ', suma_dias/contador));
							
                
                
    CLOSE cursorTest; -- Cierra el cursor
    
    IF (SELECT count(*) FROM listado) > 0 THEN -- Si hay datos con esa asignatura    
		SELECT * FROM listado;
    ELSE
		SELECT concat('No existen test para el curso ', curso);
	END IF;
  
    DROP TABLE listado; 
    
END $$
delimiter ;


-- call examen7('1ESO');  
-- call examen7('2ESO'); 
-- call examen7('MIAU'); 