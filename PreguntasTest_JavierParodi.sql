-- Javier Parodi Piñero 
use GBDgestionaTests;
/*Obtener el múmero de preguntas que tiene cada test*/

SELECT tests.descrip as 'Test', count(*) as 'Nº Preguntas'
FROM tests JOIN preguntas ON tests.codtest = preguntas.codtest
GROUP BY tests.descrip;