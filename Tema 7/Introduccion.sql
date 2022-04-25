use empresaclase;

-- CASE

-- Formato A - Variable, se compara con igualdad

SELECT numem, nomem, ape1em, numhiem,
	CASE numhiem
		WHEN 0 THEN 'Sin hijos'
        WHEN 1 THEN 'Un hijo'
        WHEN 2 THEN 'Dos hijos'
        ELSE 'Más de dos hijos'
	END

FROM empleados;
       
       
-- Formato B - Con una condición

SELECT numem, nomem, ape1em, ape2em,
	CASE
		WHEN numhiem= 0 THEN 'Cero hijos'
		WHEN  numhiem <= 3 THEN 'Entre 1 y 3 hijos'
		ELSE 'Mas de tres hijos'
	END AS NUM_HIJOS
 
FROM empleados;






        