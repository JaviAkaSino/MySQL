-- Javier Parodi Piñero

use GBDgestionaTests;
/*Obtener el número de materias de cada alumno*/

SELECT alumnos.numexped, concat_ws(' ', alumnos.nomalum, alumnos.ape1alum, alumnos.ape2alum) as 'Alumno', 
	ifnull(count(matriculas.codmateria), 0) as 'Nº materias'
FROM alumnos LEFT JOIN matriculas on alumnos.numexped = matriculas.numexped
GROUP BY alumnos.numexped;