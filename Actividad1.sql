/*ESQUEMA RELACIONAL:
centros(+numcentro, nomcentro, direccion)
deptos(+[numcentro*,numdepto], presupuesto, nomdepto, [deptodepen, centrodepen]*)
empleados(+numempleado, [numcentro, numdepto]*, extelefon, fecnacim, fecingreo, salario, comision, numhijos, nomemp)
dirigir(+[numempleado*, (numcentro, numdepto)*, fecinidir], fecfindir)
*/

create database if not exists actividad1;
use actividad1;

create table if not exists centros
(
	numcentro int not null,
    nomcentro varchar(40),
    direccion varchar(100),
    
    constraint pk_centros primary key (numcentro)
);

create table if not exists departamentos
(
	numcentro int not null,
    numdepto int not null,
    presupuesto decimal(10,2),
    nomdepto varchar(40),
    centrodepen int,
    deptodepen int,
    
    -- decimal(10,2) = 10 cifras de las cuales 2 son decimales
    
    constraint pk_departamentos primary key (numcentro,numdepto),
    constraint fk_departamentos_centros foreign key (numcentro)
			references centros (numcentro)
				on delete no action on update cascade,
    constraint fk_departamentos_departamentos foreign key (centrodepen,deptodepen)
			references departamentos (numcentro,numdepto)
				on delete no action on update cascade
);

create table if not exists empleados
(
	numempleado int not null,
    numcentro int,
    numdepto int,
    extelefon char(3),
    fecnacim date not null, 
    fecingreo date not null, 
    salario decimal(10,2), 
    comision decimal(10,2),
    numhijos tinyint unsigned default '0', 
    nomemp varchar(20),
    ap1emp varchar(20),
    ap2emp varchar(20),
    
    -- tinyint = int(1) Es 1 byte, -128 - 127
    -- Si es unsigned, 0 - 255, ya que utiliza los negativos

    constraint pk_empleados primary key (numempleado),
    constraint fk_empleados_departamentos foreign key (numcentro, numdepto)
			references departamentos (numcentro,numdepto)
				on delete no action on update cascade
);

create table if not exists dirigir
(
	numempleado int,
    numcentro int,
    numdepto int, 
    fecinidir date, 
    fecfindir date,
    
    constraint pk_dirigir primary key (numempleado,numcentro,numdepto,fecinidir),
    constraint fk_dirigir_empleados foreign key (numempleado)
			references empleados (numempleado)
				on delete no action on update cascade,
    constraint fk_dirigir_departamentos foreign key (numcentro,numdepto)
			references departamentos (numcentro,numdepto)
				on delete no action on update cascade
);

/*ALTER TABLE nombredetabla
	add column dfdsf
    add column sgsdg
    add constraint ...*/