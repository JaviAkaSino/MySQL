/*
Prepara una función que, dado el código de una venta, devuelva el importe de dicha venta
*/
use ventapromoscompleta;
/*
delimiter $$
create procedure Proc_ejer_TAREA_18_1
( in venta int, out importe decimal (8,2)
)
begin
....
end $$
delimiter ;

call Proc_ejer_TAREA_18_1 (1, @importe);
select @importe;
*/
DROP FUNCTION IF EXISTS valorVenta;
DELIMITER $$
CREATE FUNCTION valorVenta
    (venta int)
  RETURNS DECIMAL(8,2)
    LANGUAGE SQL
	DETERMINISTIC
    reads sql data
    
    COMMENT 'MÓDULO: BASES DE DATOS - UNIDAD 6 - TAREA 18 DE ABRIL - EJERCICIO 1'
BEGIN

	return (select sum(cant*precioventa)
			from detalleventa
			where codventa = venta
            );
    

END $$
DELIMITER ;
/* 
Obtén un listado de las ventas de este año en el que se muestre el código de la venta, la fecha de la venta, 
el nombre y apellidos del cliente de la venta y el importe de la venta (utiliza la función del apartado anterior).

*/
select codventa, date_format(fecventa, '%d/%m/%Y'), concat_ws(' ', nomcli, ape1cli, ape2cli), Fun_ejer_TAREA_18_1(codventa)
from ventas join clientes on ventas.codcli = clientes.codcli
where year(fecventa) = year(curdate());
/*
Prepara una función que devuelva la parte anterior a la arroba del email de un cliente dado
*/
/*
delimiter $$
create procedure Proc_ejer_TAREA_18_3
( in cliente int, out nombre varchar(20)
)
begin
....
end $$
delimiter ;

call Proc_ejer_TAREA_18_3 (1, @nombre);
select @nombre;
*/
DROP FUNCTION IF EXISTS Fun_ejer_TAREA_18_3;
DELIMITER $$
CREATE FUNCTION Fun_ejer_TAREA_18_3
    (cliente int)
  RETURNS varchar(20)
    LANGUAGE SQL
	DETERMINISTIC
    reads sql data
    
    COMMENT 'MÓDULO: BASES DE DATOS - UNIDAD 6 - TAREA 18 DE ABRIL - EJERCICIO 3'
BEGIN
-- select Fun_ejer_TAREA_18_3(1);
/*	return (select ifnull(substring_index(email,'@',1), ' no tiene correo')
			from clientes
			where codcli = cliente
            );*/
    return (select ifnull(substring(email,1,locate('@',email)-1), ' no tiene correo')
			from clientes
			where codcli = cliente
            );
    

END $$
DELIMITER ;

/* PROPUESTO PARA 19 DE ABRIL:
Obtener un listado de clientes  (código de cliente, nombre y apellidos) 
y el importe de las ventas que han hecho dichos  clientes
Si un cliente no tiene ventras debe mostrrase
*/