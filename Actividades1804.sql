-- Javier Parodi

use ventapromoscompleta;

/*
Prepara una función que, dado el código de una venta, devuelva el importe de dicha venta
*/

drop function if exists importeVenta;
delimiter $$
create function importeVenta (venta int)

RETURNS int
	LANGUAGE SQL
	DETERMINISTIC
    READS SQL DATA

BEGIN

	return (select sum(cant*precioventa)
				from detalleventa
                where codventa = venta);

END$$

delimiter ;

/*Obtén un listado de las ventas de este año en el que se muestre el código de la venta, la fecha de la venta,
el nombre y apellidos del cliente de la venta y el importe de la venta (utiliza la función del apartado anterior).*/

SELECT ventas.codventa as 'Venta', date_format(ventas.fecventa, '%d/%m/%Y') as 'Fecha', 
	concat_ws(' ', clientes.nomcli, clientes.ape1cli, clientes.ape2cli) as 'Cliente', 
    importeVenta(ventas.codventa) as 'Total'
FROM ventas JOIN clientes ON ventas.codcli = clientes.codcli
WHERE year(ventas.fecventa) = year(curdate());


/*Prepara una función que devuelva la parte anterior a la arroba del email de un cliente dado*/

drop function if exists textoEmail;
delimiter $$
create function textoEmail (cliente int)

RETURNS varchar(100)
	LANGUAGE SQL
	DETERMINISTIC
    READS SQL DATA

BEGIN

	return (select substring(email, 1, (locate('@', email))-1)
				from clientes
                where codcli = cliente);

END$$

delimiter ;

-- Prueba 

SELECT *, textoEmail(codcli)
FROM clientes;
