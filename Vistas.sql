-- Javier Parodi Piñero
/*CREAR UNA VISTA QUE SEA UN LISTÍN TELEFÓNICO CON EL NOMBRE COMPLETO DE LOS EMLEADOS (APE1, APE2, NOMBRE), EXTELEM
CADA USUARIO PODRÁ VER SÓLO LOS DATOS DE SUS COMPAÑEROS DE DEPARTAMENTO
*/
SELECT *
FROM mysql.user;

CREATE USER 'javi'@'localhost';

GRANT ALL PRIVILEGES ON * . * TO 'javi'@'localhost';

SELECT USER(), -- Usuario
	locate('@', user()), -- Dónde está la @
    left(user(), locate('@', user())), -- Lo que hay a la izq de esa posición
    locate('@', user())-1; -- Una menos para número caracteres 
SELECT left(user(),locate('@',user())-1); -- Caracteres a la izquierda de @

use empresaclase;

CREATE OR REPLACE
	DEFINER = user
	SQL SECURITY INVOKER 
    
VIEW LISTIN
	(Nombre, Extension)
AS
	SELECT concat_ws(' ', nomem, ape1em, ape2em), extelem
	FROM empleados
    WHERE numde = (select numde
					from empleados
					where userem = left(user(), locate('@',user())-1))
    ORDER BY extelem;
    
SELECT *
FROM LISTIN;

/* PREPARAR UNA VISTA EN LA QUE TENGAMOS DISPONIBLE CON FACILIDAD EL PRECIO DE VENTA DE 
CADA DÍA DE LOS PRODUCTOS */

use ventapromoscompleta;

DROP VIEW IF EXISTS PRECIOS;

CREATE
	-- [DEFINER = user]
	-- [SQL SECURITY { DEFINER | INVOKER }]
VIEW PRECIOS
	(Producto, Precio)
AS
	SELECT catalogospromos.refart, catalogospromos.precioartpromo
	FROM catalogospromos JOIN promociones ON catalogospromos.codpromo = promociones.codpromo
    WHERE curdate() BETWEEN promociones.fecinipromo AND date_add(promociones.fecinipromo, INTERVAL promociones.duracionpromo DAY)  
    
    UNION
    
    SELECT articulos.refart, articulos.precioventa
	FROM articulos LEFT JOIN catalogospromos ON articulos.refart = catalogospromos.refart
					LEFT JOIN promociones ON catalogospromos.codpromo = promociones.codpromo
    WHERE curdate() NOT BETWEEN promociones.fecinipromo AND date_add(promociones.fecinipromo, INTERVAL promociones.duracionpromo DAY);
    
SELECT *
FROM PRECIOS
ORDER BY Producto;
