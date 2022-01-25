/*
ESQUEMA RELACIONAL:

deptos(+numdepto, presupuesto, nomdepto, ubicacion)
profesores(+numprof, numdepto*, despacho, fecnacim, fecingreso, sueldo, nomprof, jefeprof*)
asignaturas(+numasigna, nomasigna, curso)
imparten(+[numasigna*, numprof*], anio_acad, grupo)
*/

create database if not exists ejercicio2;
use ejercicio2;

create table if not exists deptos
(
numdepto int, 
presupuesto decimal(10,2),
nomdepto varchar(20) not  null,
ubicacion varchar(20),
	constraint pk_deptos primary key (numdepto)
);

create table if not exists profes
(
numprof int, 
numdepto int, 
despacho int, 
fecnacim date not null, 
fecingreso date not null, 
sueldo decimal(7,2) not null, 
nomprof varchar(20) not null,
ap1prof varchar(20) not null,
ap2prof varchar(20),
jefeprof int,
	constraint pk_profes primary key (numprof),
	constraint fk_profes_deptos foreign key (numdepto)
		references deptos (numdepto),
	constraint fk_profes_profes foreign key (jefeprof)
		references profes (numprof)
			on delete no action on update cascade
);

create table if not exists asignaturas
(
numasigna int, 
nomasigna varchar(20) not null, 
curso int not null,
	constraint pk_asignaturas primary key (numasigna)
);



create table if not exists imparten
(
numasigna int,
numprof int, 
anio_acad char (9), 
grupo char(3),
	constraint pk_imparten primary key (numasigna, numprof),
	constraint fk_imparten_asignaturas foreign key (numasigna)
		references asignaturas (numasigna),
	constraint fk_imparten_profes foreign key (numprof)
		references profes (numprof)
			on delete no action on update cascade
);

/*FALLO en PK de la tabla impartir
	
*/

alter table imparten
	drop primary key,
    add constraint pk_impartendef primary key (numasigna, numprof, anio_acad);
    
    
-- Para borrar --> drop table if exists imparten;
