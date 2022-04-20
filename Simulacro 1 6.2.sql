use bdgestproyectos;
/*1. (0.8 ptos.) Obtén los apellidos y el nombre de los clientes que solicitaron 
proyectos el año pasado y no se aprobaron (el campo aprobado será 1 en los 
proyectos aprobados). Queremos que se muestren en una sola columna, Primero 
apellidos y después nombre y con coma entre los apellidos y el nombre. 
Sabemos que el segundo apellido puede contener nulos. Queremos evitar 
que quede un espacio en blanco entre el primer apellido y el nombre
 cuando no hay segundo apellido.*/
 
SELECT concat(concat_ws(' ', clientes.ape1cli, clientes.ape2cli), ', ', clientes.nomcli) as 'Cliente'
FROM clientes JOIN proyectos ON clientes.numcli = proyectos.numcli
WHERE proyectos.aprobado = 0 and year(fecpresupuesto) = year(curdate())-1;
 
 /*2. (0.8 ptos.) Sabemos que hay empleados con nombre de usuario que no 
 cumplen con nuestro patrón. Obtén un listado con los números de empleados
 cuyo usuario no cumple con el patrón: tener 6 o más caracteres, incluir 
 algún número y empezar por una letra que se debe repetir 2 o 3 veces. */
 
 SELECT numem
 FROM empleados
 WHERE length(userem) < 6
	OR userem NOT RLIKE '[0-9]'
    OR userem NOT RLIKE '^[a-z]{2,3}';
 
/*3. (1 pto.) Prepara una rutina que devuelva el número de colaboradores 
y el número de empleados que han participado en un proyecto dado.*/

DROP PROCEDURE IF EXISTS ej03;
delimiter $$
CREATE PROCEDURE ej03
	(in proyecto int,
    out colaboradores int,
    out empleados int)

BEGIN

	SELECT count(distinct(colaboradoresenproyectos.numcol)), count(tecnicosenproyectos.numtec)
			into colaboradores, empleados
    FROM proyectos left join colaboradoresenproyectos on proyectos.numproyecto = colaboradoresenproyectos.numproyecto
		left join tecnicosenproyectos on proyectos.numproyecto = tecnicosenproyectos.numproyecto
    WHERE proyectos.numproyecto = proyecto
    GROUP BY proyectos.numproyecto;

END$$
delimiter ;

call ej03(1, @colaboradores, @empleados);
select @colaboradores,@empleados;

/*4. (1,6 pto) Nos interesa tener disponible los siguientes datos para 
poder hacer operaciones con ellos. Los datos que necesitamos son código,
 nombre, y apellidos (en columnas separadas) de los empleados que nunca 
 han dirigido un proyecto o bien no están dirigiendo un proyecto en 
 la actualidad.*/

DROP VIEW IF EXISTS ej04;

CREATE VIEW EJ04
(Codigo, Nombre, Apellidos)

AS

SELECT empleados.numem, empleados.nomem, concat(empleados.ape1em, ' ', ifnull(empleados.ape2em, ''))
FROM empleados join tecnicos on empleados.numem = tecnicos.numem
WHERE empleados.numem not in (select director from proyectos)

UNION

SELECT empleados.numem, empleados.nomem, concat(empleados.ape1em, ' ', ifnull(empleados.ape2em, ''))
FROM empleados join tecnicos on empleados.numem = tecnicos.numem
WHERE empleados.numem in (select director from proyectos where fecfinproy <= curdate());

SELECT * FROM EJ04;


/*5. (0,8 ptos.) Prepara una función que, dado un número de técnico y un 
código de proyecto devuelva el número de semanas que ha trabajado dicho
 técnico en el proyecto.*/ /*En las funciones, todo es in, no puede haber out. Devuelve con returns y SOLO UN VALOR*/
 
 DROP FUNCTION IF EXISTS ej05;
 delimiter $$
 CREATE FUNCTION ej05 
	(tecnico int, proyecto int)
 
 RETURNS int
 
 LANGUAGE SQL
 DETERMINISTIC
 READS SQL DATA
 
 BEGIN
 
 RETURN(SELECT sum(datediff(fecfintrabajo, fecinitrabajo)/7)
			FROM tecnicosenproyectos
            WHERE numproyecto = proyecto AND numtec = tecnico);
 
 END$$
 
 SELECT ej05(1,1);
 
/*6. (1,6 ptos.) Prepara un procedimiento que obtenga el número de proyectos
 presupuestados de cada actividad (descripción de la actividad) y el número
 de proyectos llevados a cabo (campo aprobado será 1). Además queremos que,
 si no se ha presupuestado ningún proyecto de una actividad, se muestre 
 dicha actividad y tanto el número de proyectos presupuestados como 
 llevados a cabo será 0.*/

DROP PROCEDURE IF EXISTS ej06;
delimiter $$
CREATE PROCEDURE ej06()

BEGIN

	SELECT actividades.nomactividad as 'Actividad', 
		ifnull(count(proyectos.numproyecto), 0) as 'Presupuestados',
		ifnull((select count(numproyecto)
        from proyectos as p join actividades as a on p.codactividad = a.codactividad
        where actividades.codactividad = a.codactividad
			and p.aprobado = 1), 0) as 'Aprobados'
    FROM actividades LEFT JOIN proyectos ON actividades.codactividad = proyectos.codactividad
    WHERE proyectos.fecpresupuesto < curdate()
    GROUP BY actividades.codactividad;

END$$
delimiter ;

call ej06();
 
/*7. (1,6 ptos.) Cada proyecto tiene una fecha de inicio de proyecto (cuando 
comienza a desarrollarse), una duración prevista (en días) y una fecha de 
fin real de proyecto. Obtén un listado de proyectos que han terminado en el
 tiempo previsto. Queremos mostrar el número de proyecto, el director de 
 proyecto (nombre y apellidos), el número de personal previsto (personal_prev),
 el número de técnicos y el número de colaboradores.*/
 
SELECT proyectos.numproyecto as 'Proyecto',
concat(concat_ws(' ', empleados.ape1em, empleados.ape2em), ', ', empleados.nomem) as 'Director',
proyectos.personal_prev as 'Pesonal previsto',
(select count(*) from tecnicosenproyectos where proyectos.numproyecto = tecnicosenproyectos.numproyecto)as 'Técnicos', 
(select count(*) from colaboradoresenproyectos where proyectos.numproyecto = colaboradoresenproyectos.numproyecto) as 'Colaboradores'
FROM proyectos join tecnicos on proyectos.director = tecnicos.numtec
	join empleados on tecnicos.numem = empleados.numem

WHERE proyectos.duracionprevista >= datediff(proyectos.fecfinproy, proyectos.feciniproy);
 
/*8. (1,8 ptos.) Cada proyecto tiene un número previsto de personas necesarias 
(personal_prev). Obtén para cada proyecto que no haya superado en su ejecución
 al personal previsto (es decir, el número de técnicos y de colaboradores que
 han trabajado en el mismo no supera al número previsto) el número de técnicos
 y de colaboradores*/
 
SELECT distinct(proyectos.numproyecto) as 'Proyecto',
proyectos.personal_prev as 'Personal previsto',
(select count(distinct(tecnicosenproyectos.numtec)) from tecnicosenproyectos where proyectos.numproyecto = tecnicosenproyectos.numproyecto)as 'Técnicos', 
(select count(distinct(colaboradoresenproyectos.numcol)) from colaboradoresenproyectos where proyectos.numproyecto = colaboradoresenproyectos.numproyecto) as 'Colaboradores'

FROM proyectos
  

WHERE ((select count(distinct(tecnicosenproyectos.numtec)) from tecnicosenproyectos where proyectos.numproyecto = tecnicosenproyectos.numproyecto) + 
		(select count(distinct(colaboradoresenproyectos.numcol)) from colaboradoresenproyectos where proyectos.numproyecto = colaboradoresenproyectos.numproyecto)) < proyectos.personal_prev;
 
