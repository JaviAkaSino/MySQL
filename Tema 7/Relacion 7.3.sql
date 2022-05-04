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
        
drop procedure if exists ejercicio1;
delimiter $$
create procedure ejercicio1()

BEGIN
	-- Orden de declaración: Variables, cursor y manejador
    -- VARIABLES
    DECLARE nombre_cat, descripcion_cat, descripcion_producto, categoria_auxiliar varchar(100) default '';
    DECLARE hay_stock char(2) default 'SI';
    DECLARE codigo_producto int;
    DECLARE precio_unidad decimal(7,2) default 0.00;
    DECLARE existencias boolean default false;
    
    DECLARE fin_cursor boolean DEFAULT 0; 
    
    -- CURSOR
    DECLARE cursor1 CURSOR FOR
		SELECT productos.codproducto, productos.descripcion, productos.preciounidad, 
			productos.stock, categorias.Nomcategoria, categorias.descripcion
		FROM productos JOIN categorias ON productos.codcategoria = categorias.codcategoria
        ORDER BY productos.codcategoria;
    
    -- MANEJADOR DE ERRORES
    DECLARE CONTINUE HANDLER FOR SQLSTATE '02000' -- IndexOutOfBounds
		BEGIN
			SET fin_cursor = 1;
        END;
        
	DROP TABLE IF EXISTS listado;
    CREATE TEMPORARY TABLE listado (filarecorrida varchar(500)); -- Crea la tabla temporal
    
    OPEN cursor1; -- Abre el cursor
    
    FETCH cursor1 INTO codigo_producto, descripcion_producto, precio_unidad, existencias,
		nombre_cat, descripcion_cat; -- Primera línea
    
    WHILE fin_cursor = 0 DO -- Mientras no se acaben los registros
		BEGIN
			IF nombre_cat <> categoria_auxiliar THEN -- Cuando el nombre cambie, cabecera nueva
				BEGIN
		               
					INSERT INTO listado -- Cabecera de cada categoria
					VALUES 						 
						(concat('Productos de: ', nombre_cat, ', ', descripcion_cat)),
						('Código          Descripción        Precio unidad        Existencias');
					
					SET categoria_auxiliar = nombre_cat;
                    				END;
			END IF;
			-- --------------------------------------------------------
			
            IF existencias = 0 or null THEN
				SET hay_stock = 'NO';
            END IF;
            
			INSERT INTO listado
            VALUES 
				(concat(codigo_producto, '            ',descripcion_producto, '            ', 
					precio_unidad, '             ', hay_stock)); -- Añade los datos del producto
        
			FETCH cursor1 INTO codigo_producto, descripcion_producto, precio_unidad, existencias,
		nombre_cat, descripcion_cat; -- Siguiente línea
        END;
	END WHILE; -- Termina el bucle, ya no hay más registros
					 
    CLOSE cursor1; -- Cierra el cursor
    
    
    SELECT * FROM listado; -- Enseña el listado
    
    DROP TABLE listado; -- 
    
END $$
delimiter ;


call ejercicio1();
        
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
    
  drop procedure if exists ejercicio2;
delimiter $$
create procedure ejercicio2()

BEGIN
	-- Orden de declaración: Variables, cursor y manejador
    -- VARIABLES
    DECLARE descripcion varchar(100) default '';
    DECLARE codigo_producto, pedidos, cantidad, producto_auxiliar int default 0;
    DECLARE  fecha date;
    
    DECLARE fin_cursor boolean DEFAULT 0; 
    
    -- CURSOR
    DECLARE cursor2 CURSOR FOR
		SELECT pedidos.fecpedido, pedidos.cantidad, pedidos.codproducto,
			productos.descripcion
		FROM pedidos JOIN productos ON pedidos.codproducto = productos.codproducto
        ORDER BY pedidos.codproducto;
    
    -- MANEJADOR DE ERRORES
    DECLARE CONTINUE HANDLER FOR SQLSTATE '02000' -- IndexOutOfBounds
		BEGIN
			SET fin_cursor = 1;
        END;
        
	DROP TABLE IF EXISTS listado;
    CREATE TEMPORARY TABLE listado (filarecorrida varchar(500)); -- Crea la tabla temporal
    
    OPEN cursor2; -- Abre el cursor
    
    FETCH cursor2 INTO fecha, cantidad, codigo_producto, descripcion; -- Primera línea
    
    WHILE fin_cursor = 0 DO -- Mientras no se acaben los registros
		BEGIN
			IF codigo_producto <> producto_auxiliar THEN -- Cuando el nombre cambie, cabecera nueva
				BEGIN
		               
					INSERT INTO listado -- Cabecera de cada categoria
					VALUES 						 
						(concat('Producto: ', descripcion, '(',codigo_producto,')', '-------- Pedidos: '));
						
					
					SET producto_auxiliar = codigo_producto;
                 END;
			END IF;
			-- --------------------------------------------------------
		            
			INSERT INTO listado
            VALUES 
				(concat(fecha, '                                   ', cantidad)); -- Añade los datos del producto
        
			FETCH cursor2 INTO fecha, cantidad, codigo_producto, descripcion; -- Siguiente línea
        END;
	END WHILE; -- Termina el bucle, ya no hay más registros
					 
    CLOSE cursor2; -- Cierra el cursor
    
    
    if (select count(*) from listado) > 0 then
    select * from listado;
	else
    select 'No existen productos pedidos';
	end if;
    
    DROP TABLE listado; -- 
    
END $$
delimiter ;


call ejercicio2();  
    
/* 3. Prepara un procedimiento almacenado que, dado un código de producto, nos de el siguiente resultado para dicho producto:
	Nombre del producto:
	Proveedor: Empresa proveedora
	Contacto: Nombre de la persona de contacto
	Teléfono: Teléfono de contacto
	---------------------------------------------------------------------------------------
	Lista de pedidos de ese producto con la fecha del pedido, la cantidad pedida y la fecha prevista de 	entrega (si no se sabe que aparezca “SIN FECHA PREVISTA DE ENTREGA”)
*/

drop procedure if exists EJER_7_3_3;
DELIMITER $$
CREATE PROCEDURE EJER_7_3_3
(
    in codprod int
)
BEGIN

DECLARE desprod, nombreprov, contactoprov varchar(50);
DECLARE tlfprov char(9);
DECLARE fechaped, fechaent varchar(30);
DECLARE cantped int;

DECLARE final bit default 0;
	
DECLARE curPedidos CURSOR 
	FOR select  date_format(fecpedido,'%d/%m/%Y'), ifnull(date_format(fecentrega,'%d/%m/%Y'),'SIN FECHA PREVISTA DE ENTREGA'), cantidad
        from pedidos
        where codproducto = codprod
        order by fecpedido;
DECLARE CONTINUE HANDLER FOR SQLSTATE '02000' SET final = 1;

SELECT productos.descripcion, proveedores.nomempresa, proveedores.nomcontacto, proveedores.telefono
    INTO desprod, nombreprov, contactoprov, tlfprov 
FROM productos join categorias on categorias.codcategoria = productos.codcategoria
    join proveedores on proveedores.codproveedor = categorias.codproveedor
where productos.codproducto =codprod;

drop table if exists listado;
create temporary table listado
    (descripcion varchar(100));
-- escribimos los datos del producto y proveedor
INSERT INTO listado 
   -- (descripcion) 
VALUES 
   (CONCAT('Nombre del producto: ', desprod)),
   (CONCAT('Proveedor: ', nombreprov)),
   (CONCAT('Contacto: ', contactoprov)),
   (CONCAT('Teléfono: ', tlfprov)),
   ('Pedidos: '),
   ('   Fecha pedido               Unidades Pedidas           Fecha entrega');
OPEN curPedidos;
FETCH FROM curPedidos INTO fechaped,fechaent,cantped;
        
WHILE final = 0 DO
BEGIN
-- insertamos las fechas de pedidos 
    INSERT INTO listado 
           -- (descripcion) 
        VALUES 
            (CONCAT('  ',fechaped, '                    ', 
                    cantped, '                       ', case fechaent
                                                            when null then 'SIN FECHA PREVISTA DE ENTREGA'
                                                            else fechaent
                                                        end));
	FETCH FROM curPedidos INTO fechaped,fechaent,cantped;
END;
END WHILE;
CLOSE curPedidos;

if (select count(*) from listado) = 6 then
    insert into listado values ('No existen pedidos para este producto');
end if;
select * from listado;
drop table if exists listado;

END $$
DELIMITER ;

 call EJER_7_3_3(10);
 call EJER_7_3_3(17);
call EJER_7_3_3(21);

/* 4. Prepara un procedimiento almacenado que, dada una fecha, obtenga una lista de los productos pedidos hasta dicha fecha con la siguiente información:
Fecha máxima: fecha dada
Codproducto == > descripcion  ---  cantidad pedida ------- precio del pedido 
Codproducto == > descripciion ---  cantidad pedida ------- precio del pedido 
….
Total Precio ==== > total de todos los pedidos
Nota.- precio del pedido = cantidad pedida*preciounidad
	     total de todos los pedidos = suma de todos los precios de pedido*/
         
         
drop procedure if exists ejercicio4;
delimiter $$
create procedure ejercicio4(fecha date)

BEGIN
	-- Orden de declaración: Variables, cursor y manejador
    -- VARIABLES
    DECLARE descripcion varchar(100) default '';
    DECLARE codigo_producto, cantidad int default 0;
    DECLARE precio_pedido, total_precio decimal(12,2) default 0;
    
    DECLARE fin_cursor boolean DEFAULT 0; 
    
    -- CURSOR
    DECLARE cursor4 CURSOR FOR
		SELECT pedidos.codproducto, productos.descripcion, 
			sum(pedidos.cantidad), sum(productos.preciounidad*pedidos.cantidad)
		FROM pedidos JOIN productos ON pedidos.codproducto = productos.codproducto
        WHERE pedidos.fecpedido <= fecha
        GROUP BY pedidos.codproducto;
    
    -- MANEJADOR DE ERRORES
    DECLARE CONTINUE HANDLER FOR SQLSTATE '02000' -- IndexOutOfBounds
		BEGIN
			SET fin_cursor = 1;
        END;
        
	DROP TABLE IF EXISTS listado;
    CREATE TEMPORARY TABLE listado (filarecorrida varchar(500)); -- Crea la tabla temporal
    
    INSERT INTO listado
	VALUES
		(concat('Fecha máxima: ', fecha));
    
    OPEN cursor4; -- Abre el cursor
    
    FETCH cursor4 INTO codigo_producto, descripcion, cantidad, precio_pedido; -- Primera línea
    
    
    
    WHILE fin_cursor = 0 DO -- Mientras no se acaben los registros
		BEGIN
            
            SET total_precio = total_precio + precio_pedido;
            
			INSERT INTO listado
            VALUES 
				(concat(codigo_producto, '==>', descripcion, ' --- ', cantidad, ' ---- ', precio_pedido)); -- Añade los datos del producto
        
			FETCH cursor4 INTO codigo_producto, descripcion, cantidad, precio_pedido; -- Siguiente línea
        END;
	END WHILE; -- Termina el bucle, ya no hay más registros
					 
	INSERT INTO listado
    		VALUES ('---------------------------------------------------------------------'),
            (concat('Total Precio ====> ', total_precio));
                     
    CLOSE cursor4; -- Cierra el cursor

    SELECT * FROM listado;
    
    DROP TABLE listado; -- 
    
END $$
delimiter ;


call ejercicio4('1996-08-08');          
         
/* 5. Prepara un procedimiento almacenado “Pedidos masivos” que haga de forma automática un pedido de todos los productos cuyo stock esté por debajo de 5 unidades a fecha de hoy y por una cantidad de 5 unidades.
Nota.- Habrá que hacer la modificación oportuna en la tabla productos el campo “pedidos”.
*/

DROP PROCEDURE IF EXISTS PEDIDOSMASIVOS;
DELIMITER $$
CREATE PROCEDURE PEDIDOSMASIVOS()
BEGIN
-- CALL PEDIDOSMASIVOS();
-- SELECT * FROM pedidos WHERE fecpedido = CURDATE();
DECLARE numpedidos, codprod, stockprod int;
DECLARE desprod VARCHAR(50);
DECLARE maxpedido int;

DECLARE final BIT DEFAULT 0;

DECLARE curProd CURSOR FOR
	SELECT codproducto, descripcion, stock, pedidos
	FROM productos
	WHERE stock <= 5;

DECLARE CONTINUE HANDLER FOR SQLSTATE '02000' SET final = 1;

DROP TABLE IF EXISTS listado;
CREATE TEMPORARY TABLE listado (descripcion VARCHAR(200));

OPEN curProd;	
FETCH FROM curProd INTO codprod, desprod, stockprod, numpedidos;

WHILE not final DO
BEGIN
    SELECT MAX(codpedido) + 1 INTO maxpedido FROM pedidos;
	INSERT pedidos
		(codpedido, codproducto, fecpedido, fecentrega, cantidad)
	VALUES
		(maxpedido,
		 codprod, CURDATE(), null, 5);
	UPDATE productos
	SET pedidos = pedidos + 5
	WHERE codproducto = codprod;
    
    INSERT INTO listado
    VALUES
        (CONCAT('SE HA REALIZADO UN PEDIDO DE 5 UNIDADES DEL PRODUCTO ', codprod,
                ' (', desprod, ')'));

	FETCH FROM curProd INTO codprod, desprod, stockprod, numpedidos;
END;
END WHILE;

CLOSE curProd;

if (select count(*) from listado) > 0 then
    select * from listado;
else
    select 'No ha sido necesario realizar ningún pedido automático';
end if;
drop table if exists listado;

END $$
DELIMITER ;







