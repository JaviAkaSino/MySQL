use bdgestproyectos;
/*1. (0.8 ptos.) Obtén los apellidos y el nombre de los clientes que solicitaron 
proyectos el año pasado y no se aprobaron (el campo aprobado será 1 en los 
proyectos aprobados). Queremos que se muestren en una sola columna, Primero 
apellidos y después nombre y con coma entre los apellidos y el nombre. 
Sabemos que el segundo apellido puede contener nulos. Queremos evitar 
que quede un espacio en blanco entre el primer apellido y el nombre
 cuando no hay segundo apellido.*/
 
 
 
 /*2. (0.8 ptos.) Sabemos que hay empleados con nombre de usuario que no 
 cumplen con nuestro patrón. Obtén un listado con los números de empleados
 cuyo usuario no cumple con el patrón: tener 6 o más caracteres, incluir 
 algún número y empezar por una letra que se debe repetir 2 o 3 veces. */
 
 
 
/*3. (1 pto.) Prepara una rutina que devuelva el número de colaboradores 
y el número de empleados que han participado en un proyecto dado.*/



/*4. (1,6 pto) Nos interesa tener disponible los siguientes datos para 
poder hacer operaciones con ellos. Los datos que necesitamos son código,
 nombre, y apellidos (en columnas separadas) de los empleados que nunca 
 han dirigido un proyecto o bien no están dirigiendo un proyecto en 
 la actualidad.*/

drop view if exists EJ4;

create VIEW EJ4
	(Codigo, Nombre, Apelllidos)
AS

	SELECT empleados.numem, empleados.nomem, concat(empleados.ape1em, ' ', ifnull(empleados.ape2em, ''))
    FROM empleados JOIN tecnicos ON empleados.numem = tecnicos.numem
    WHERE tecnicos.numtec NOT IN (SELECT director FROM proyectos)
    
    UNION
    
    SELECT empleados.numem, empleados.nomem, concat(empleados.ape1em, ' ', ifnull(empleados.ape2em, ''))
    FROM empleados JOIN tecnicos ON empleados.numem = tecnicos.numem 
	WHERE tecnicos.numtec NOT IN (SELECT director FROM proyectos WHERE fecfinproy > curdate());				
    
SELECT * FROM EJ4;
    



/*5. (0,8 ptos.) Prepara una función que, dado un número de técnico y un 
código de proyecto devuelva el número de semanas que ha trabajado dicho
 técnico en el proyecto.*/ /*En las funciones, todo es in, no puede haber out. Devuelve con returns y SOLO UN VALOR*/
 
 
 
/*6. (1,6 ptos.) Prepara un procedimiento que obtenga el número de proyectos
 presupuestados de cada actividad (descripción de la actividad) y el número
 de proyectos llevados a cabo (campo aprobado será 1). Además queremos que,
 si no se ha presupuestado ningún proyecto de una actividad, se muestre 
 dicha actividad y tanto el número de proyectos presupuestados como 
 llevados a cabo será 0.*/
DROP PROCEDURE IF EXISTS ej6; 
delimiter $$ 
CREATE PROCEDURE ej6()

BEGIN

	SELECT actividades.nomactividad as 'Actividad', ifnull(count(proyectos.numproyecto), 0) as 'Presupuestos', ifnull((select count(*)
																				from proyectos as p right join actividades as a on p.codactividad = a.codactividad
																				where p.aprobado = 1 and
																				a.nomactividad = actividades.nomactividad), 0) as 'Realizados'
											
    FROM actividades LEFT JOIN proyectos ON actividades.codactividad = proyectos.codactividad
    
    GROUP BY actividades.nomactividad;

END $$
delimiter ;
call ej6(); 
 
/*7. (1,6 ptos.) Cada proyecto tiene una fecha de inicio de proyecto (cuando 
comienza a desarrollarse), una duración prevista (en días) y una fecha de 
fin real de proyecto. Obtén un listado de proyectos que han terminado en el
 tiempo previsto. Queremos mostrar el número de proyecto, el director de 
 proyecto (nombre y apellidos), el número de personal previsto (personal_prev),
 el número de técnicos y el número de colaboradores.*/
 
 DROP PROCEDURE IF EXISTS EJ7;
 delimiter $$
 CREATE PROCEDURE EJ7()
 BEGIN
 
	SELECT proyectos.numproyecto, proyectos.personal_prev,
		(select count(*) from tecnicosenproyectos where tecnicosenproyectos.numproyecto = proyectos.numproyecto) as 'Técnicos',
        (select count(*) from colaboradoresenproyectos where colaboradoresenproyectos.numproyecto = proyectos.numproyecto) as 'Colaboradores'
    FROM proyectos JOIN tecnicos ON proyectos.director = tecnicos.numtec
			JOIN empleados ON tecnicos.numem = empleados.numem
	WHERE  date_add(proyectos.feciniproy, INTERVAL proyectos.duracionprevista DAY) < proyectos.fecfinproy;
 
 END $$
 delimiter ;
 
 call EJ7();
 
/*8. (1,8 ptos.) Cada proyecto tiene un número previsto de personas necesarias 
(personal_prev). Obtén para cada proyecto que no haya superado en su ejecución
 al personal previsto (es decir, el número de técnicos y de colaboradores que
 han trabajado en el mismo no supera al número previsto) el número de técnicos
 y de colaboradores*/
 
DROP PROCEDURE IF EXISTS EJ8;
 delimiter $$
 CREATE PROCEDURE EJ8()
 BEGIN
 
	SELECT proyectos.numproyecto, proyectos.personal_prev,
		(select count(*) from tecnicosenproyectos where tecnicosenproyectos.numproyecto = proyectos.numproyecto) as 'Técnicos',
        (select count(*) from colaboradoresenproyectos where colaboradoresenproyectos.numproyecto = proyectos.numproyecto) as 'Colaboradores'
    FROM proyectos
	WHERE  (select count(*) from tecnicosenproyectos where tecnicosenproyectos.numproyecto = proyectos.numproyecto)
			+ (select count(*) from colaboradoresenproyectos where colaboradoresenproyectos.numproyecto = proyectos.numproyecto)
			<= proyectos.personal_prev;
 
 END $$
 delimiter ;
 
 call EJ8();
 
