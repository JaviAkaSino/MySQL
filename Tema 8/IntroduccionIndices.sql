use empresaclase;

CREATE UNIQUE INDEX dniempleado
	ON empleados (dniem);

/*Salvo que sean unique o casos específicos de busquedas espaciales etc. (no vamos a trabajar) no hace falta poner el tipo*/

CREATE INDEX buscanombre
	ON empleados (ape1em(4), ape2em(4), nomem(3)); -- Las 4, 4 y 3 primeras letras

SHOW INDEX FROM empleados;

EXPLAIN select *
from empleados use index(dniempleado)
where dniem like '%5%';

SELECT * 
FROM empleados USE INDEX(buscanombre) -- IGNORE INDEX(buscanombre)
WHERE ape1em like '%tor%';

/*DECLARE EXIT HANDLER FOR SQLEXCEPTION
	ROLLBACK;*/


SHOW VARIABLES LIKE '%autocommit%';


