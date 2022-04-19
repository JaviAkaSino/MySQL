-- EXPRESIONES REGULARES

use empresaclase;

--  Empleados cuyo nombre empiece por vocal y después tenga una l o una n

SELECT *
FROM empleados
WHERE nomem RLIKE '^[aeiou][ln]';

-- Comience por vocal, lo que sea y acabe en alter

SELECT *
FROM empleados
WHERE nomem RLIKE '^[aeiou].*a$';

-- Que empiecen por dos vocales

SELECT *
FROM empleados
WHERE nomem RLIKE '^[aeiou]{2}';

-- Empiecen por 'j' y contengan 1 o más de una 'n'

SELECT *
FROM empleados
WHERE nomem RLIKE '^j.*n+';

-- Empiecen por 'e' y justo después 0 ó 1 'b'

SELECT *
FROM empleados
WHERE nomem RLIKE '^eb?';

-- Empiecen por 'au'

SELECT *
FROM empleados
WHERE nomem RLIKE '^(au)';

