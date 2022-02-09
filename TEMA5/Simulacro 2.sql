-- 1
start transaction;
insert into clientes
	(codcli,nomcli,dnicli,tlf_contacto)
value 
	(899, "Juan del Campo Sánchez", "07000001W", "607000001");
update reservas 
	set codcliente = 899
    where codreserva = 4356;
commit;

-- 2
delete from reservas
	where codcliente = 456 and fecreserva = curdate();
    
-- 3
update clientes
	set tlf_contacto = '789000000',
		correoelectronico = 'dfg@gmail.com'
	where codcli = 789;

-- 4
    
