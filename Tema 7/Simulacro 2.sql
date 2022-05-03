use ventapromoscompleta;


/*Nos han pedido que preparemos un procedimiento almacenado que, mediante el uso 
de cursores muestre un listado de clientes y las compras que han realizado por 
meses entre dos meses dados (usaremos el número de mes).
Además, a medida que vamos obteniendo los datos, para los clientes cuya media 
de artículos comprados supere a la media de la empresa para ese mes (media de 
artículos que se han comprado en la empresa en un mes) se les regalará 5 puntos.
Queremos asegurar que la operación se realice de manera íntegra y garantizando 
que al terminar, la base de datos quedará en buen estado.
El listado que queremos se mostraría para los meses ENERO (1) A MARZO (3) sería algo así:

COMPRAS  DE CLIENTES ENTRE ENERO Y MARZO:
-------------------------------------------------------------------------------------------------------------------------------------
CLIENTE: Nombre de cliente
-------------------------------------------------------------------------------------------------------------------------------------
ENERO:
Artículo					Unidades  compradas			Precio de compra
Nombre artículo					x					x,xx
Nombre artículo					x					x,xx
----------------------------------------------------------------------------------------------------------------------------------
Media de Nombre de cliente en ENERO:	Media unidades compradas*		puntos regalados**
----------------------------------------------------------------------------------------------------------------------------------
FEBRERO
Artículo					Unidades  compradas			Precio de compra
Nombre artítulo					x					x,xx
Nombre artítulo					x					x,xx
…..
-----------------------------------------------------------------------------------------------------------------------------------
Media de Nombre de cliente en FEBRERO:	Media unidades compradas*		puntos regalados**
----------------------------------------------------------------------------------------------------------------------------------
MARZO
Artículo					Unidades  compradas			Precio de compra
Nombre artítulo					x					x,xx
Nombre artítulo					x					x,xx
…..
-----------------------------------------------------------------------------------------------------------------------------------
Media de Nombre de cliente en MARZO:	Media unidades compradas*		puntos regalados**
-------------------------------------------------------------------------------------------------------------------------------------
CLIENTE: Nombre de cliente
------------------------------------------------------------------------------------------------------------
ENERO:
Artículo					Unidades  compradas			Precio de compra
Nombre artítulo					x					x,xx
Nombre artítulo					x					x,xx
…..
----------------------------------------------------------------------------------------------------------------------------------
Media de Nombre de cliente en ENERO:	Media unidades compradas*		puntos regalados**
----------------------------------------------------------------------------------------------------------------------------------
FEBRERO
Artículo					Unidades  compradas			Precio de compra
Nombre artítulo					x					x,xx
Nombre artítulo					x					x,xx
…..
-----------------------------------------------------------------------------------------------------------------------------------
Media de Nombre de cliente en FEBRERO:	Media unidades compradas*		puntos regalados**
----------------------------------------------------------------------------------------------------------------------------------
MARZO
Artículo					Unidades  compradas			Precio de compra
Nombre artítulo					x					x,xx
Nombre artítulo					x					x,xx
…..
-----------------------------------------------------------------------------------------------------------------------------------
Media de Nombre de cliente en MARZO:	Media unidades compradas*		puntos regalados**
……..

_____________________________________________________________________________________________________________________________________* Media de unidades compradas con respecto al número de compras.
**Si procede (si la media de unidades compradas por el cliene en ese mes supera a la media de la empresa en dicho mes)

*/



drop procedure if exists cursorVentasCliente;
delimiter $$
create procedure cursorVentasCliente(
	in mes1 int,
    in mes2 int)
BEGIN
	-- Orden de declaración: Variables, cursor y manejador
    -- VARIABLES
    DECLARE nombre_cliente, nombre_articulo, cliente_auxiliar, mes_venta, mes_auxiliar varchar(100);
    DECLARE unidades_compradas int DEFAULT 0; 
    DECLARE precio_compra decimal(7,5) DEFAULT 0;
 
    DECLARE mismo_cliente, primera_fila boolean DEFAULT 1;
    DECLARE fin_cursor boolean DEFAULT 0;
    
    -- CURSOR
    DECLARE cursorCLientes CURSOR FOR
		SELECT concat_ws(' ', clientes.nomcli, clientes.ape1cli, clientes.ape2cli), 
			monthname(ventas.fecventa), articulos.nomart, 
            detalleventa.cant, detalleventa.precioventa 
		FROM ventas JOIN clientes on ventas.codcli = clientes.codcli
			JOIN detalleventa on ventas.codventa = detalleventa.codventa
            JOIN articulos on detalleventa.refart = articulos.refart
		WHERE year(ventas.fecventa) = year(curdate()) 
			AND month(ventas.fecventa) between mes1 and mes2
		ORDER BY concat_ws(' ', clientes.nomcli, clientes.ape1cli, clientes.ape2cli),
			month(ventas.fecventa);

    
    -- MANEJADOR DE ERRORES
    DECLARE CONTINUE HANDLER FOR SQLSTATE '02000' -- IndexOutOfBounds
		BEGIN
			SET fin_cursor = 1;
        END;
	
    DROP TEMPORARY TABLE IF EXISTS listado;
    CREATE TEMPORARY TABLE listado (filarecorrida varchar(500)); -- Crea la tabla temporal
    
    OPEN cursorClientes; -- Abre el cursor
    
    FETCH cursorClientes INTO nombre_cliente, mes_venta, nombre_articulo, unidades_compradas, precio_compra; -- Primera línea
    
    INSERT INTO listado -- Pone el total del centro
		VALUES(concat('COMPRAS DE CLIENTES ENTRE: ', 
        upper(monthname(convert(concat('2020/', mes1, '/1'),date))),
        ' Y ', upper(monthname(convert(concat('2020/', mes2, '/1'), date))))),
        ('------------------------------------------------------------------');
    
    WHILE fin_cursor = 0 DO -- Mientras no se acaben los registros
		BEGIN

			IF nombre_cliente <> cliente_auxiliar THEN -- Cuando el nombre cambie, cabecera nueva
				BEGIN
                
                INSERT INTO listado -- Pone el nombre del cliente
							VALUES 
                            (concat('CLIENTE: ', concat_ws(' ', clientes.nomcli, clientes.ape1cli, clientes.ape2cli))),
                            ('------------------------------------------------------------------------------------'),
                            (upper(monthname(convert(concat('2020/', mes1, '/1'),date))));
							
					/*IF NOT primera_fila THEN --  Si es la primera cabecera, no añade el total
						BEGIN
							INSERT INTO listado -- Pone el total del centro
							VALUES
								(concat('Media de:  ', nombre_cliente, ' en ', mes_venta, ':  Media unidades compradas: ', media_mes ));
							SET suma_presupuestos = 0; -- Y pone lo pone a 0 para el siguiente
						END;
					END IF;
                
					INSERT INTO listado -- Cabecera de cada centro
					VALUES 						 
						(concat('Centro de trabajo: ', nomcentro)),
						('Nº Departamento	      Nombre	   	Presupesto');
					
					SET nombre_cliente = cliente_auxiliar;
                    SET primera_fila = 0; -- Primera fila a false*/
				END;
			END IF;
            
            IF mes_venta <> mes_auxiliar THEN
				BEGIN
					
                    INSERT INTO listado
                    VALUES
                    ();
                    
                END;
			END IF;
			-- --------------------------------------------------------
			/*SET suma_presupuestos = suma_presupuestos + presupuesto; -- Cada depto suma su presupuesto al total
			INSERT INTO listado
            VALUES 
				(concat(numdepto, '      	',nomdepto, '	  		', presupuesto)); -- Añade los datos del depto
        
			FETCH cursorDeptos INTO numdepto, nomdepto, presupuesto, nomcentro; -- Siguiente línea*/
        END;
	END WHILE; -- Termina el bucle, ya no hay más registros
    /*
	INSERT INTO listado -- E inserta el presupuesto total del último depto
	VALUES
		(concat('TOTAL PRESUPUESTO:             ',suma_presupuestos));*/
					 
    CLOSE cursorClientes; -- Cierra el cursor
    
    
    SELECT * FROM listado; -- Enseña el listado
    
   --  DROP TABLE listado  
    
END $$
delimiter ;


call cursorVentasCliente(1,3);