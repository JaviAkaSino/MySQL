-- Javier Parodi

-- Para la base de datos empresa_clase:
use empresaclase;

/*Sabiendo que en la extensión de teléfono que utilizan los empleados, el primer dígito 
corresponde con el edificio, el segundo con la planta y el tercero con la puerta. 
Busca aquellos empleados que trabajan en la misma planta (aunque sea en edificios diferentes) 
que el empleado 120.*/

SELECT *
FROM empleados
WHERE extelem RLIKE concat('^.', (select substring(extelem, 2, 1)
							from empleados
                            where numem= 120))
                            ;

-- Para la base de datos turRural:
use GBDturRural2015;

/*Sabiendo que los dos primeros dígitos del código postal se corresponden con la provincia 
y los 3 siguientes a la población dentro de esa provincia. Busca los clientes (todos sus datos) 
de las 9 primeras poblaciones de la provincia de Málaga (29001 a 29009).*/

SELECT *
FROM clientes
WHERE codpostalcli RLIKE '^2900[1-9]';

/*Sabiendo que los dos primeros dígitos del código postal se corresponden con la provincia y 
los 3 siguientes a la población dentro de esa provincia. Busca los clientes (todos sus datos) 
de las 20 primeras poblaciones de la provincia de Málaga (29001 a 29020).*/

SELECT *
FROM clientes
WHERE codpostalcli RLIKE '^290([12]0|[01][1-9])';

/*Queremos encontrar clientes con direcciones de correo válidas, para ello queremos buscar 
aquellos clientes cuya dirección de email contiene una “@”, y termina en un símbolo punto (.) 
seguido de “com”, “es”, “eu” o “net”.*/

SELECT *
FROM clientes
WHERE correoelectronico RLIKE '.*@.*\\.[com|es|eu|net]$';

/*Queremos encontrar ahora aquellos clientes que no cumplan con la expresión regular anterior.*/
