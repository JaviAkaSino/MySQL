-- 1
insert into reservas
	(codreserva, codcliente, codcasa, fecreserva, pagocuenta, feciniestancia, numdiasestancia)
    value
    (3051, 520, 315, curdate(), 100, '2022/08/05', 7);

-- 2
update caracteristicasdecasas
set tiene = 1
where codcasa = 350 and (codcaracter = 17 or codcaracter = 3 or codcaracter = 5)
;

insert into caracteristicasdecasas
(codcasa,codcaracter,tiene)
values
(350,17,1),
(350,5,1),
(350,3,1);

-- 3
start transaction;
	update reservas
	set fecanulacion = curdate()
	where codreserva = 2450;

	insert into devoluciones
	(numdevol, codreserva,importedevol)
	values
	(226, 2450, 200);
commit;

-- 4
start transaction;
	delete from caracteristicasdecasas
    where codcasa = 5640 or codcasa = 5641;
    
    delete from casa
    where codcasa = 5640 or codcasa = 5641;
    
    delete from propietarios
    where codpropietario = 520;
commit;

-- 5
update casas
	set numhabit = 3,
		m2 = 200,
        minpersonas = 4,
        maxpersonas = 8
	where codcasa = 5789;
