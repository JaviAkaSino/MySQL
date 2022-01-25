/* 
ESQUEMA RELACIONAL:

categorias(+numcat, nomcategor, proveedor)
productos(+[numcat*, refprod], descripc, precio, codcat)
ventas(+codventa, fecventa, cliente)
lin_ventas(+[codventa*, (numcat, refprod)*], cantidad)
*/

create database if not exists ejercicio3;
use ejercicio3;

create table if not exists categorias
(
numcat int, 
nomcategor varchar(20) not null, 
proveedor int not null,
	constraint pk_categorias primary key (numcat)
);

create table if not exists productos
(
numcat int, 
refprod varchar(20), 
descripc varchar(40), 
precio decimal(6,2) not null, 
	constraint pk_productos primary key (numcat, refprod),
	constraint fk_productos_categorias foreign key (numcat)
		references categorias (numcat)
			on delete no action on update cascade
);

create table if not exists ventas
(
codventa int, 
fecventa date not null, 
cliente int not null,
	constraint pk_ventas primary key (codventa)
);

create table if not exists lin_ventas
(
codventa int, 
numcat int,
refprod varchar(20), 
cantidad tinyint unsigned not null,
	constraint pk_lin_ventas primary key (codventa, numcat, refprod),
	constraint fk_lin_ventas_ventas foreign key (codventa)
		references ventas(codventa),
	constraint fk_lin_ventas_productos foreign key (numcat, refprod)
		references productos(numcat, refprod)
			on delete no action on update cascade
);

/*En caso de error:
alter table ln_ventas
	add column codcat int,
    drop index fk_ln_ventas_productos *Esto no deberia ser necesario
    add constraint fk_ln_ventas_productos foreign key (refprod, codcat)
		references productos (refprod, codcat)
			on delete no action on update cascade,
		drop constraint fk_ln_ventas,
        
        drop primary key...*/
