use empresaclase;

-- 1 Obtener todos los datos de todos los empleados.
select *
from empleados;

-- 2 Obtener la extensión telefónica de “Juan López”.
select extelem
from empleados
where nomem = 'Juan' and ape1em = 'López';

-- 3 Obtener el nombre completo de los empleados que tienen más de un hijo.
select numem, ape1em, ape2em
from empleados
where numhiem > 1;

-- 4 Obtener el nombre completo y en una sola columna de los empleados que tienen entre 1 y 3 hijos.
select concat_ws(nomem, ape1em, ape2em) as 'Nombre completo'
from empleados
where numhiem between 1 and 3;

-- 5 Obtener el nombre completo y en una sola columna de los empleados sin comisión.
select concat(nomem, ' ', ape1em, ' ', ifnull(concat(' ', ape2em), ''), ' ') as 'Nombre completo'
from empleados
where comisem is null or comisem = 0;

-- 6 Obtener la dirección del centro de trabajo “Sede Central”.
select dirce 
from centros
where nomce = ' Sede Central';

-- 7 Obtener el nombre de los departamentos que tienen más de 6000 € de presupuesto.
select nomde
from departamentos
where presude > 6000;

-- 8 Obtener el nombre de los departamentos que tienen de presupuesto 6000 € o más.
select nomde
from departamentos
where presude >= 6000;

/* 9 Obtener el nombre completo y en una sola columna de los empleados que llevan 
trabajando en nuestra empresa más de 1 año. (Añade filas nuevas para poder comprobar que tu consulta funciona).*/
select concat_ws(nomem, ape1em, ifnull(ape2em, '')) as 'Nombre completo'
from empleados
where fecinem <= date_sub(curdate(), interval 1 year);

/* 10 Obtener el nombre completo y en una sola columna de los empleados que llevan 
trabajando en nuestra empresa entre 1 y tres años. (Añade filas nuevas para poder comprobar que tu consulta funciona).*/
select concat_ws(nomem, ape1em, ifnull(ape2em, '')) as 'Nombre completo'
from empleados
where  fecinem between date_sub(curdate(), interval 3 year) 
	and date_sub(curdate(), interval 1 year);
    
/* 11 Prepara un procedimiento almacenado que ejecute la consulta del apartado 1 
y otro que ejecute la del apartado 5.*/

delimiter $$
drop procedure if exists datosEmpleados $$
create procedure datosEmpleados
	()
begin
	select *
	from empleados;
end $$

drop procedure if exists empleadosSinComision $$
create procedure empleadosSinComision	
    (
	)
begin 
	select concat(nomem, ' ', ape1em, ' ', ifnull(concat(' ', ape2em), ''), ' ') as 'Nombre completo'
	from empleados
	where comisem is null or comisem = 0;
end $$

delimiter ;

/* 12 Prepara un procedimiento almacenado que ejecute la consulta del apartado 2
de forma que nos sirva para averiguar la extensión del empleado que deseemos 
en cada caso.*/

delimiter $$
drop procedure if exists extensionEmpleado $$
create procedure extensionEmpleado
	(in nombre varchar(20), in apellido1 varchar(20))
begin
	select extelem
	from empleados
	where nomem = nombre and ape1em = apellido1;
end $$
delimiter ;

/* 13 Prepara un procedimiento almacenado que ejecute la consulta del apartado 3 
y otro para la del apartado 4 de forma que nos sirva para averiguar el nombre 
de aquellos que tengan el número de hijos que deseemos en cada caso.*/

delimiter $$
drop procedure if exists empleadoPorNumHijos $$

create procedure empleadoPorNumHijos
	(in numeroHijos int)
begin	
	select numem, ape1em, ape2em
	from empleados
	where numhiem = numeroHijos;
end $$
    
drop procedure if exists empleadoPorHijosEntre $$
create procedure empleadoPorHijosEntre
(in minHijos int, in maxhijos int)
begin
	select concat_ws(nomem, ape1em, ape2em) as 'Nombre completo'
	from empleados
	where numhiem between minHijos and maxHijos;
end $$

delimiter ;

/* 14 Prepara un procedimiento almacenado que, dado el nombre de un centro de 
trabajo, nos DEVUELVA su dirección.*/

delimiter $$
drop procedure if exists direccionCentro $$
create procedure direccionCentro
	(in nombreCentro varchar(20), 
    out direccion varchar(50))
begin
	set direccion = ifnull
    ((select dircen
    from centros
    where lower(trim(nomcen)) = lower(trim(nombreCentro))),
    'No válido');
end $$
delimiter ;

call direccionCentro('Relación con los clientes', @direccion);



/* 15 Prepara un procedimiento almacenado que ejecute la consulta del apartado 7 
de forma que nos sirva para averiguar, dada una cantidad, el nombre de los 
departamentos que tienen un presupuesto superior a dicha cantidad.*/

delimiter $$
drop procedure if exists departamentoPresupuestoMayor $$
create procedure departamentoPresupuestoMayor
	(in presupuesto int)
begin
	select nomde
	from departamentos
	where presude > presupuesto;
end $$
delimiter ;

/* 16 Prepara un procedimiento almacenado que ejecute la consulta del apartado 8
 de forma que nos sirva para averiguar, dada una cantidad, el nombre de los 
 departamentos que tienen un presupuesto igual o superior a dicha cantidad.*/

delimiter $$
drop procedure if exists departamentoPresupuestoMayorIgual $$
create procedure departamentoPresupuestoMayorIgual
	(in presupuesto int)
begin
	select nomde
	from departamentos
	where presude >= presupuesto;
end $$
delimiter ;

/* 17 Prepara un procedimiento almacenado que ejecute la consulta del apartado 9
 de forma que nos sirva para averiguar, dada una fecha, el nombre completo 
 y en una sola columna de los empleados que llevan trabajando con nosotros 
 desde esa fecha.*/

delimiter $$
drop procedure if exists empleadosDesde $$
create procedure empleadosDesde
	(in fechaInicio date)
begin
	select concat_ws(nomem, ape1em, ifnull(ape2em, '')) as 'Nombre completo'
	from empleados
	where fecinem = fechaInicio;
end $$
delimiter ;

/* 18 Prepara un procedimiento almacenado que ejecute la consulta del apartado 10
 de forma que nos sirva para averiguar, dadas dos fechas, el nombre completo
 y en una sola columna de los empleados que comenzaron a trabajar con nosotros
 en el periodo de tiempo comprendido entre esas dos fechas.*/

delimiter $$
drop procedure if exists empleadoDesdeEntre $$
create procedure empleadoDesdeEntre
	(fecha1 date, fecha2 date)
begin
	select concat_ws(nomem, ape1em, ifnull(ape2em, '')) as 'Nombre completo'
	from empleado
	where  fecinem between fecha1 and fecha2;
end $$
delimiter ;

/* 19 Prepara un procedimiento almacenado que ejecute la consulta del apartado 10
 de forma que nos sirva para averiguar, dadas dos fechas, el nombre completo
 y en una sola columna de los empleados que comenzaron a trabajar con nosotros
 fuera del periodo de tiempo comprendido entre esas dos fechas.*/

delimiter $$
drop procedure if exists empleadoDesdeFueraDe $$
create procedure empleadoDesdeFueraDe
	(fecha1 date, fecha2 date)
begin
	select concat_ws(nomem, ape1em, ifnull(ape2em, '')) as 'Nombre completo'
	from empleados
	where fecinem not between fecha1 and fecha2
    order by feciem;
end $$
delimiter ;

