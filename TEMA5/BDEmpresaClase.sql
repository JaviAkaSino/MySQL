USE `empresaclase`;

/*3 Se ha contratado a un empleado nuevo para dirigir un departamento de nueva creación. Utiliza
las sentencias sql que consideres oportunas para que aparezcan los datos del departamento
nuevo (Publicidad, con presupuesto de 15000 euros, dependiente de dirección comercial y
ubicado en el centro “Relación con clientes”), los datos del empleado que lo va a dirigir (“Rosa
del Campo Florido”, nacida el “12/6/1967”, la extensión telefónica que usará es la 930, su
salario será 2000 € y su comisión 150 €, tiene 2 hijos). Además el periodo de dirección es de un
año desde hoy y el módo de dirección es en Propiedad.*/

start transaction;

	insert into departamentos
	(numde,numce,presude, depende, nomde)
	values
	(132,20,15000,110,'Publicidad');
	insert into empleados
	()
	values
	();
commit;

/*4 El departamento “Sector industrial” se ha trasladado al centro “Sede central”.*/

update departamentos
set numce = 10
where nomde = 'Sector industrial';

/*5 Hemos contratado a dos nuevos empleados que van a formar parte del nuevo departamento
“Publicidad”. Sus datos son “Pedro González Sánchez” y “Juan Torres Campos” nacidos el
“12/2/1972” y “25/9/1975” respectivamente, ambos van a ganar 1400 € y no tendrán comisión.
El primero tiene 1 hijo y el segundo no tiene hijos. Compartirán la extensión telefónica 940.*/

insert into empleados
(numem,numde,extelem, fecnaem)
value
(567),
(568,132,'940','1975/9/25');
/*6 Se va a despedir a Juan Torres Campos por no superar el periodo de prueba.*/
delete from empleados
where numen = 568;

/*7 “Dorinda Lara” ha cambiado de departamento, ahora pertenece al departamento
“Organización”, se ha incrementado su sueldo en un 10% y su nueva extensión telefónica es la
910.*/

update empleados
set numde = 120,
	salarem = (salarem * 1.1),
	extelem = '910'
where nomem = 'Dorinda' and ape1em = 'Lara'; -- predicado

/*8 Haz una copia de seguridad de la BD con la que estás trabajando.*/

