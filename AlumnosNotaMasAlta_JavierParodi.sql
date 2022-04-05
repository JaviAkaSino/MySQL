-- Javier Parodi Piñero

use GBDgestionaTests;
/*Obtener el número de alumnos matriculados en cada materia y la nota media de la materia
y el número de expediente de la nota mas alta*/

SELECT concat_ws(' - ', materias.nommateria, materias.cursomateria) as 'Materia', 
	ifnull(count(matriculas.numexped), 0) as 'Nº Alumnos', 
	round(avg(matriculas.nota), 2) as 'Nota media',
	max(matriculas.nota) as 'Nota máxima',
    
    (select m.numexped 
    from matriculas as m
    where m.nota = max(matriculas.nota) and m.codmateria = matriculas.codmateria
    ) as 'Nº expediente'

FROM matriculas JOIN materias on matriculas.codmateria = materias.codmateria
GROUP BY matriculas.codmateria;