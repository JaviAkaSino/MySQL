-- Javier Parodi Piñero

/*1. Para la base de datos “TurRural” prepara un procedimiento que 
muestre un listado con los nombres y apellidos de los propietarios 
en columnas separadas. Da por hecho que los nombres que tenemos 
son simples, esto es, nadie tiene un nombre o apellidos compuestos. 
Puedes modificar los datos para comprobar los resultados.*/
use GBDturRural2015;

drop procedure if exists nombrePropietarios;
delimiter $$
create procedure nombrePropietarios()

BEGIN
	UPDATE propietarios
	SET nompropietario = trim(nompropietario); -- Aseguramos que no empiece un nombre por ' '

	SELECT left(nompropietario, locate(' ', nompropietario)-1) as 'Nombre', -- Izquierda del espacio
			substring(nompropietario, locate(' ', nompropietario), length(nompropietario)) as 'Apellidos' -- Lo demás
    FROM propietarios;

END $$
delimiter ;
call nombrePropietarios();



/*2. Para la BD empresaclase, prepara un procedimiento que devuelva
 la contraseña inicial de un empleado. Esta será:
* La primera y la última letra de su nombre+
* La 2ª y 3ª letras de su primer apellido +
* La letra central de su 2º apellido o la z en caso de que no tenga 
	segundo apellido + 
* el último número de su dni sin la letra.*/
use empresaclase;

drop procedure if exists contra;
delimiter $$
create procedure contra()

BEGIN

	SELECT concat_ws(' ', nomem, ape1em, ape2em) as 'Nombre', dniem as 'DNI',
			
            concat(substring(nomem, 1, 1), -- Primera letra nombre
			substring(nomem, length(nomem), 1), -- Segunda letra nombre
            substring(ape1em, 2, 2), -- 2ª y 3ª letra 1er apellido
            ifnull(substring(ape2em, length(ape2em)/2, 1), 'Z'), -- Letra central 2º apellido
            ifnull(substring(dniem, 8, 1), '0') ) as 'Contraseña' -- Num DNI, si null, todo 0s
			
    FROM empleados;

END $$
delimiter ;
call contra();

/*3. Dado el código de un empleado, muestra cuando termina el periodo 
de formación de un empleado (6 meses y dos semanas desde la fecha de 
ingreso). El formato debe ser:
día ? del mes ?? del año ????.*/

drop procedure if exists finFormacion;
delimiter $$
create procedure finFormacion(in empleado int)

BEGIN

	SELECT numem as 'Empleado', fecinem as 'Fecha ingreso',
			concat('Día ', DAY(date_add(date_add(fecinem, INTERVAL 6 MONTH), INTERVAL 2 WEEK)),
			' del mes ', MONTH(date_add(date_add(fecinem, INTERVAL 6 MONTH), INTERVAL 2 WEEK)),
            ' del año ', YEAR(date_add(date_add(fecinem, INTERVAL 6 MONTH), INTERVAL 2 WEEK))) 
            as 'Fin de formación'
    FROM empleados
    WHERE numem = empleado;

END $$
delimiter ;
call finFormacion(120);

