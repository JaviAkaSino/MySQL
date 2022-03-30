-- Javier Parodi Piñero

use bdalmacen;

/*1. Obtener todos los productos que comiencen por una letra determinada.*/
drop procedure if exists ej1;
delimiter $$
create procedure ej1(in letra char(1))

BEGIN

	SELECT *
	FROM productos
	WHERE left(productos.descripcion, 1) = letra ;
    
END $$

delimiter ;

call ej1('a');

/*2. Se ha diseñado un sistema para que los proveedores puedan acceder a ciertos datos,
 la contraseña que se les da es el teléfono de la empresa al revés. Se pide elaborar
 un procedimiento almacenado que dado un proveedor obtenga su contraseña y la muestre 
 en los resultados.*/
 
drop procedure if exists ej2;
delimiter $$
create procedure ej2(in proveedor int)

BEGIN

	SELECT REVERSE(telefono)
	FROM proveedores
    WHERE codproveedor = proveedor;
    
    
END $$

delimiter ;

call ej2(1);
 
/*3. Obtener el mes previsto de entrega para los pedidos que no se han recibido aún y 
para una categoría determinada.*/

drop procedure if exists ej3;
delimiter $$
create procedure ej3(in categoria int)

BEGIN
	SET lc_time_names = 'es_ES';
    
	SELECT pedidos.codpedido as 'Pedido', MONTHNAME(pedidos.fecentrega) as 'Mes entrega'
	FROM pedidos JOIN productos ON pedidos.codproducto = productos.codproducto
					JOIN categorias ON productos.codcategoria = categorias.codcategoria	
	WHERE categorias.codcategoria = categoria AND pedidos.fecentrega > curdate();
    
END $$

delimiter ;

call ej3(3);


/*4. Obtener un listado con todos los productos, ordenados por categoría, en el que se 
muestre solo las tres primeras letras de la categoría.*/

drop procedure if exists ej4;
delimiter $$
create procedure ej4()

BEGIN

	SELECT LEFT(categorias.Nomcategoria, 3) as 'CAT', productos.descripcion as 'Producto'
	FROM productos JOIN categorias ON productos.codcategoria = categorias.codcategoria
	ORDER BY categorias.Nomcategoria;
    
END $$

delimiter ;

call ej4();

/*5. Obtener el cuadrado y el cubo de los precios de los productos.*/

drop procedure if exists ej5;
delimiter $$
create procedure ej5()

BEGIN

	SELECT POWER(productos.preciounidad, 2) as 'Cuadrado', POWER(productos.preciounidad, 3) as 'Cubo'
	FROM productos;
    
END $$

delimiter ;

call ej5();

/*6. Devuelve la fecha del mes actual.*/

drop procedure if exists ej6;
delimiter $$
create procedure ej6()

BEGIN

	SELECT MONTHNAME(curdate()) as 'Mes actual';

END $$

delimiter ;

call ej6();

/*7. Para los pedidos entregados el mismo mes que el actual, obtener cuantos días 
hace que se entregaron.*/

drop procedure if exists ej7;
delimiter $$
create procedure ej7()

BEGIN

	SELECT pedidos.codpedido as 'Pedido', DATEDIFF (curdate(), pedidos.fecentrega) as 'Días entregado'
	FROM pedidos
	WHERE MONTH(pedidos.fecentrega) = MONTH(curdate()) 
			AND YEAR(pedidos.fecentrega) = YEAR(curdate());
    
END $$

delimiter ;

call ej7();

/*8. En el nombre de los productos, sustituir “tarta” por “pastel”.*/

drop procedure if exists ej8;
delimiter $$
create procedure ej8()

BEGIN

	SELECT REPLACE(LOWER(productos.descripcion), 'tarta', 'Pastel')
	FROM productos
    ORDER BY productos.descripcion;
    
END $$

delimiter ;

call ej8();

/*9. Obtener la población del código postal (los primeros dos caracteres se refieren 
a la provincia y los tres últimos a la población).*/

drop procedure if exists ej9;
delimiter $$
create procedure ej9()

BEGIN

	SELECT proveedores.codpostal as 'CP', RIGHT(proveedores.codpostal, 3) as 'Código población'
	FROM proveedores;

END $$

delimiter ;

call ej9();

/*10. Obtén el número de productos de cada categoría, haz que el nombre de la categoría 
se muestre en mayúsculas.*/

drop procedure if exists ej10;
delimiter $$
create procedure ej10()

BEGIN

	SELECT UPPER(categorias.Nomcategoria) as 'Categoría', COUNT(productos.codproducto) as 'Nº productos'
	FROM productos JOIN categorias ON productos.codcategoria = categorias.codcategoria
    GROUP BY Nomcategoria;
    
END $$

delimiter ;

call ej10();

/*11. Obtén un listado de productos por categoría y dentro de cada categoría del nombre
de producto más corto al más largo.*/

drop procedure if exists ej11;
delimiter $$
create procedure ej11()

BEGIN

	SELECT categorias.Nomcategoria as 'Categoría', productos.descripcion 'Producto'
	FROM productos JOIN categorias ON productos.codcategoria = categorias.codcategoria
    ORDER BY categorias.Nomcategoria, LENGTH(productos.descripcion);

    
END $$

delimiter ;

call ej11();

/*12. Asegúrate de que los nombres de los productos no tengan espacios en blanco al principio 
o al final de dicho nombre.*/

drop procedure if exists ej12;
delimiter $$
create procedure ej12()

BEGIN
	
    UPDATE productos
	SET descripcion = trim(descripcion);
    
    SELECT descripcion
    FROM PRODUCTOS;
        
END $$

delimiter ;

call ej12();

/*13. Lo mismo que en el ejercicio 2, pero ahora, además, sustituye el 4 y 5 número del resultado
 por las 2 últimas letras del nombre de la empresa.*/
 
drop procedure if exists ej13;
delimiter $$
create procedure ej13()

BEGIN

	SELECT telefono, nomempresa, REVERSE(telefono), SUBSTRING(REVERSE(telefono), 4, 2),
			REPLACE(REVERSE(telefono), SUBSTRING(REVERSE(telefono), 4, 2), RIGHT(nomempresa, 2))
	FROM proveedores;
    -- WHERE codproveedor = proveedor;
    
END $$

delimiter ;

call ej13();

/*14. Obtén el 10 por ciento del precio de los productos redondeados a dos decimales.*/

drop procedure if exists ej14;
delimiter $$
create procedure ej14()

BEGIN

	SELECT descripcion as 'Producto', ROUND(preciounidad*0.1, 2) as '10% del precio'
	FROM productos;
    
END $$

delimiter ;

call ej14();

/*15. Muestra un listado de productos en que aparezca el nombre del producto y el código de 
producto y el de categoría repetidos (por ejemplo para la tarta de azucar se mostrará “623623”).*/

drop procedure if exists ej15;
delimiter $$
create procedure ej15()

BEGIN

	SELECT productos.descripcion as 'Productos', REPEAT(CONCAT(productos.codproducto, productos.codcategoria), 2) as 'Código'
	FROM productos;
    
END $$

delimiter ;

call ej15();
