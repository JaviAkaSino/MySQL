create database ejemplo1;
use ejemplo1;
/*Comentarios*/
-- O asi también para una línea

-- Def tabla 1

create table tabla1
(	
	-- null o not null para permitir o no valores null, si es PK no hace falta
	-- default x para un por defecto, no se puede en PK*/
	codt1 int not null,
    -- char(longitud) longitud EXACTA (tamaño fijo, CP, DNI...) y varchar(longitud) HASTA longitud
    -- fechas y cadenas de caracteres SIEMPRE entre comillas SIMPLES
	dest1 varchar (20) not null default 'descripcion de campo',
    constraint pk_tabla1 primary key (codt1)
);

create table tabla2
(
	codt2 int not null,
    dest2 varchar(20) default 'descripcion de campo',
    codt1 int null,
    constraint pk_tabla2 primary key (codt2),
    constraint fk_tabla2_tabla1 foreign key (codt1) references tabla1 (codt1)
	-- Si se intenta eliminar un dato que sea FK, acción
        -- no action: impide eliminar el dato. POR DEFECTO
        -- cascade: borra los registros relacionados, si 2 --> 3 y se borra 3, se borra 2
        -- set null: el campo de la FK se queda a null
	-- Si se actualiza, se cambian datos que sean FK igual
		-- cascade: actualiza los datos tambiÃ©n. POR DEFECTO	
        on delete no action on update cascade
);

create table tabla3
(
	codt1 int not null,
    codt2 int not null,
    fecharel2 date,
    constraint pk_tabla3 primary key (codt1, codt2),
    constraint fk_tabla3_tabla1 foreign key (codt1) references tabla1 (codt1)
		on delete no action on update cascade,
    constraint fk_tabla3_tabla2 foreign key (codt2) references tabla2 (codt2)
		on delete no action on update cascade   
);