use empresaclase;

-- Obtener todos los datos de todos los empleados.
select *
from empleados;

-- Obtener la extensión telefónica de “Juan López”.
select extelem
from empleados
where nomem = 'Juan' and ape1em = 'López';

-- Obtener el nombre completo de los empleados que tienen más de un hijo.
select numem, ape1em, ape2em
from empleados
where numhiem > 1;

-- Obtener el nombre completo y en una sola columna de los empleados que tienen entre 1 y 3 hijos.
select concat_ws(nomem, ape1em, ape2em) as 'Nombre completo'
from empleados
where numhiem between 1 and 3;

-- Obtener el nombre completo y en una sola columna de los empleados sin comisión.
select concat(nomem, ' ', ape1em, ' ', ifnull(concat(' ', ape2em), ''), ' ') as 'Nombre completo'
from empleados
where comisem is null or comisem = 0;

-- Obtener la dirección del centro de trabajo “Sede Central”.
select dirce 
from centros
where nomce = ' Sede Central';

-- Obtener el nombre de los departamentos que tienen más de 6000 € de presupuesto.
select nomde
from departamentos
where presude > 6000;

-- Obtener el nombre de los departamentos que tienen de presupuesto 6000 € o más.
select nomde
from departamentos
where presude >= 6000;

/*Obtener el nombre completo y en una sola columna de los empleados que llevan 
trabajando en nuestra empresa más de 1 año. (Añade filas nuevas para poder comprobar que tu consulta funciona).*/
select concat_ws(nomem, ape1em, ifnull(ape2em, '')) as 'Nombre completo'
from departamentos
where fecinem <= date_sub(curdate(), interval 1 year);

/* Obtener el nombre completo y en una sola columna de los empleados que llevan 
trabajando en nuestra empresa entre 1 y tres años. (Añade filas nuevas para poder comprobar que tu consulta funciona).*/
select concat_ws(nomem, ape1em, ifnull(ape2em, '')) as 'Nombre completo'
from departamentos
where  fecinem between date_sub(curdate(), interval 3 year) 
	and date_sub(curdate(), interval 1 year);