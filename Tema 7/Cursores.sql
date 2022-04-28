use empresaclase;

/*Centro de trabajo: Relaciones con clientes
	DEPTO	NOMBRE	PRESUDE
    110		DIR C.	15000
    112		...		...
    131		...		...
Centro de trabajo: Sede central
	DEPTO	NOMBRE	PRESUDE
    ...		...		...
    ...		...		...
					TOTAL: ...
				
    */


 
drop procedure if exists pruebaCursor;
delimiter $$
create procedure pruebaCursor()
BEGIN
	-- Orden de declaración: Variables, cursor y manejador
    -- VARIABLES
    DECLARE numdepto int DEFAULT 0; 
    DECLARE nomdepto, nomcentro, nomcentroaux varchar(100) DEFAULT '';
    DECLARE presupuesto decimal(12,2) DEFAULT 0.00;
    DECLARE suma_presupuestos decimal(12,2) DEFAULT 0.00;
    DECLARE primera_fila int DEFAULT 1;  
    DECLARE fin_cursor boolean DEFAULT 0; 
    
    -- CURSOR
    DECLARE cursorDeptos CURSOR FOR
		SELECT numde, nomde, presude, nomce
		FROM departamentos JOIN centros ON departamentos.numce = centros.numce
		ORDER BY nomce;
    
    -- MANEJADOR DE ERRORES
    DECLARE CONTINUE HANDLER FOR SQLSTATE '02000' -- IndexOutOfBounds
		BEGIN
			SET fin_cursor = 1;
        END;
	
    CREATE TEMPORARY TABLE listado (filarecorrida varchar(500)); -- Crea la tabla temporal
    
    OPEN cursorDeptos; -- Abre el cursor
    
    FETCH cursorDeptos INTO numdepto, nomdepto, presupuesto, nomcentro; -- Primera línea
    
    WHILE fin_cursor = 0 DO -- Mientras no se acaben los registros
		BEGIN

			IF nomcentro <> nomcentroaux THEN -- Cuando el nombre cambie, cabecera nueva
				BEGIN
                
					IF NOT primera_fila THEN --  Si es la primera cabecera, no añade el total
						BEGIN
							INSERT INTO listado -- Pone el total del centro
							VALUES
								(concat('TOTAL PRESUPUESTO:             ',suma_presupuestos));
							SET suma_presupuestos = 0; -- Y pone lo pone a 0 para el siguiente
						END;
					END IF;
                
					INSERT INTO listado -- Cabecera de cada centro
					VALUES 						 
						(concat('Centro de trabajo: ', nomcentro)),
						('Nº Departamento	Nombre				Presupesto');
					
					SET nomcentroaux = nomcentro;
                    SET primera_fila = 0; -- Primera fila a false
				END;
			END IF;
			-- --------------------------------------------------------
			SET suma_presupuestos = suma_presupuestos + presupuesto; -- Cada depto suma su presupuesto al total
			INSERT INTO listado
            VALUES 
				(concat(numdepto, '	',nomdepto, '			', presupuesto)); -- Añade los datos del depto
        
			FETCH cursorDeptos INTO numdepto, nomdepto, presupuesto, nomcentro; -- Siguiente línea
        END;
	END WHILE; -- Termina el bucle, ya no hay más registros
    
	INSERT INTO listado -- E inserta el presupuesto total del último depto
	VALUES
		(concat('TOTAL PRESUPUESTO:             ',suma_presupuestos));
					 
    CLOSE cursorDeptos; -- Cierra el cursor
    
    
    SELECT * FROM listado; -- Enseña el listado
    
    DROP TABLE listado; -- 
    
END $$
delimiter ;


call pruebaCursor();