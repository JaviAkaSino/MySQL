-- Javier Parodi Piñero

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
	FROM articulos
    WHERE articulos.refart NOT IN (SELECT catalogospromos.refart
									FROM catalogospromos JOIN promociones ON catalogospromos.codpromo = promociones.codpromo
									WHERE curdate() BETWEEN promociones.fecinipromo AND date_add(promociones.fecinipromo, INTERVAL promociones.duracionpromo DAY));
    
SELECT *
FROM PRECIOS
ORDER BY Producto;