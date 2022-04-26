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


-- drop procedure if exists pruebaCursor;
delimiter $$
create procedure pruebaCursor()
BEGIN
	
    DECLARE cursorDeptos CURSOR FOR
		SELECT numde, nomde, presude, nomce
		FROM departamentos JOIN centros ON departamentos.numce = centros.numce
		ORDER BY nomce;
    
    DECLARE numdepto int DEFAULT 0; 
    DECLARE nomdepto, nomcentro, nomcentroaux varchar(100) DEFAULT '';
    DECLARE presupuesto decimal(12,2) DEFAULT 0.00;
    
    DECLARE fin_cursor boolean DEFAULT 0; -- Contador para fin bucle
    
    DECLARE CONTINUE HANDLER FOR SQLSTATE '02000' -- IndexOutOfBounds
		BEGIN
			SET fin_cursor = 1;
        END;
	
    CREATE TEMPORARY TABLE listado (filarecorrida varchar(500));
    
    OPEN cursorDeptos;
    
    FETCH cursorDeptos INTO numdepto, nomdepto, presupuesto, nomcentro;
    
    WHILE fin_cursor = 0 DO
		BEGIN
			IF nomcentro <> nomcentroaux THEN -- Cuando el nombre cambie, cabecera nueva
            BEGIN
				INSERT INTO listado
				VALUES 
					(concat('Centro de trabajo: ', nomcentro));
					
				INSERT INTO listado
				VALUES 
					('Nº Departamento	Nombre	Presupesto');
				
                SET nomcentroaux = nomcentro;
            END;
			END IF;
			-- --------------------------------------------------------

			INSERT INTO listado
            VALUES 
				(concat(numdepto, '	',nomdepto, '	', presupuesto));
        
			FETCH cursorDeptos INTO numdepto, nomdepto, presupuesto, nomcentro;
        END;
	END WHILE;
    
    CLOSE cursorDeptos;
    
    
    SELECT * FROM listado;
    
    DROP TABLE listado;
    
END $$
delimiter ;


call pruebaCursor();