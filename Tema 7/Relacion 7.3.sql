use bdalmacen;

/*1. Preparar un procedimiento almacenado que utilizando cursores, obtenga un catálogo de productos con el siguiente formato:
	Productos de: Nombre y descripción de categoría
		Código		Descripción		Precio unidad		Existencias
		--------------------------------------------------------------------------------------------
		Codproducto	descripcion		preciounitariio		SI/NO
		….
	Productos de: Nombre y descripción de categoría
		Código		Descripción		Precio unidad		Existencias
		--------------------------------------------------------------------------------------------
		Codproducto	descripcion		preciounitariio		SI/NO
		….*/
        
drop procedure if exists pruebaCursor;
delimiter $$
create procedure pruebaCursor()
BEGIN
	-- Orden de declaración: Variables, cursor y manejador
    -- VARIABLES
    DECLARE codproducto int DEFAULT 0; 
    DECLARE nomdepto, nomcentro, nomcentroaux varchar(100) DEFAULT '';
    DECLARE presupuesto decimal(12,2) DEFAULT 0.00;
    DECLARE suma_presupuestos decimal(12,2) DEFAULT 0.00;
    DECLARE primera_fila boolean DEFAULT 1;  
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
						('Nº Departamento	      Nombre	   	Presupesto');
					
					SET nomcentroaux = nomcentro;
                    SET primera_fila = 0; -- Primera fila a false
				END;
			END IF;
			-- --------------------------------------------------------
			SET suma_presupuestos = suma_presupuestos + presupuesto; -- Cada depto suma su presupuesto al total
			INSERT INTO listado
            VALUES 
				(concat(numdepto, '      	',nomdepto, '	  		', presupuesto)); -- Añade los datos del depto
        
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
        
/* 2. Prepara un procedimiento almacenado que, mediante el uso de cursores, obtenga un listado de productos pedidos con el siguiente formato:
	Producto: Descripción (código)  ------- Pedidos: pedidos
	-------------------------------------------------------------------------
	Fecha pedido			cantidad pedida
	Fecha pedido			cantidad pedida
	…
	Producto: Descripción (código)  ------- Pedidos: pedidos
	-------------------------------------------------------------------------
	Fecha pedido			cantidad pedida
	Fecha pedido			cantidad pedida
	…*/
    
    
    
/* 3. Prepara un procedimiento almacenado que, dado un código de producto, nos de el siguiente resultado para dicho producto:
	Nombre del producto:
	Proveedor: Empresa proveedora
	Contacto: Nombre de la persona de contacto
	Teléfono: Teléfono de contacto
	---------------------------------------------------------------------------------------
	Lista de pedidos de ese producto con la fecha del pedido, la cantidad pedida y la fecha prevista de 	entrega (si no se sabe que aparezca “SIN FECHA PREVISTA DE ENTREGA”)
*/



/* 4. Prepara un procedimiento almacenado que, dada una fecha, obtenga una lista de los productos pedidos hasta dicha fecha con la siguiente información:
Fecha máxima: fecha dada
Codproducto == > descripcion  ---  cantidad pedida ------- precio del pedido 
Codproducto == > descripciion ---  cantidad pedida ------- precio del pedido 
….
Total Precio ==== > total de todos los pedidos
Nota.- precio del pedido = cantidad pedida*preciounidad
	     total de todos los pedidos = suma de todos los precios de pedido*/
         
         
         
         
/* 5. Prepara un procedimiento almacenado “Pedidos masivos” que haga de forma automática un pedido de todos los productos cuyo stock esté por debajo de 5 unidades a fecha de hoy y por una cantidad de 5 unidades.
Nota.- Habrá que hacer la modificación oportuna en la tabla productos el campo “pedidos”.
*/