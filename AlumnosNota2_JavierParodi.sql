-- Javier Parodi Piñero

use GBDgestionaTests;
/*Obtenes el número de alumnos matriculados en cada materia y la nota media de la materia*/

SELECT concat_ws(' ', materias.nommateria, materias.cursomateria) as 'Materia', ifnull(count(distinct(matriculas.numexped)), 0) as 'Nº Alumnos', ifnull(avg(matriculas.nota), 0) as 'Nota media'
FROM materias LEFT JOIN matriculas on materias.codmateria = matriculas.codmateria
GROUP BY materias.codmateria;