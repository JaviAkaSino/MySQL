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

DROP VIEW IF EXISTS LISTIN;

CREATE
	[DEFINER = user]
	[SQL SECURITY { DEFINER | INVOKER }]
VIEW LISTIN
	(Nombre, Extension)
AS
	SELECT concat(ape1em, ' ',ifnull(ape2em,''), ', ',nomem), extelem
	FROM empleados
    WHERE numde = (select numde
					from empleados
					where userem = left(user(), locate('@',user())-1))
    ORDER BY extelem;
    
SELECT *
FROM LISTIN
