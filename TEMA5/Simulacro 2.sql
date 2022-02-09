-- 1
start transaction;
insert into clientes
	(codcli, nomcli, ape1cli, ape2cli, dnicli, tlf_contacto)
values 
	(899, "Juan",  "del Campo", "Sánchez", "07000001W", "607000001");
update reservas 
	set codcliente = 899
    where codreserva = 4356;
commit;

-- 2
delete from reservas
	where codcliente = 456 and fecreserva = curdate();
    
-- 3
update propietarios
	set tlf_contacto = '789000000',
		correoelectronico = 'dfg@gmail.com'
	where codcli = 789;

-- 4
start transaction;
	delete from caracteristicasdecasas
    where codcaracter = 230 or codcaracter = 245;
    
    delete from caracteristicas
    where numcaracter = 230 or codcaracter = 245;
commit;
   
   /*Aquí podría hacerse directamente el segundo delete si se aplicara
   on delete cascade. Al presumirse que está on delete no action por defecto,
   esta sería la forma ya que, si no, se quedarían caracteristicasdecasas con 
   campos nulos en su clave primaria*/
   
-- 5
update casas
set preciobase = preciobase * 1.1
where numbanios = 3 and m2 = 200;