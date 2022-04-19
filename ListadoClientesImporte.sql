-- Javier Parodi Piñero 

/* PROPUESTO:
Obtener un listado de clientes  (código de cliente, nombre y apellidos)
y el importe de las ventas que han hecho dichos  clientes
Si un cliente no tiene ventras debe mostrase
*/
use ventapromoscompleta;
DROP PROCEDURE IF EXISTS ejercicioProp;
DELIMITER $$
CREATE PROCEDURE ejercicioProp()

BEGIN

	SELECT  clientes.codcli as 'Código cliente', 
			concat_ws(' ', clientes.nomcli, clientes.ape1cli, clientes. ape2cli) as 'Nombre', 
            ifnull(sum(cant*precioventa), 0) as 'Importe ventas'
	FROM detalleventa JOIN ventas on detalleventa.codventa = ventas.codventa
		RIGHT JOIN clientes ON ventas.codcli = clientes.codcli
	GROUP BY clientes.codcli; 

END $$
DELIMITER ;

call ejercicioProp();

-- Sergio 

SELECT clientes.codcli AS 'Código cliente',
	concat_ws(' ', clientes.nomcli, clientes.ape1cli, clientes. ape2cli) as 'Nombre',
	ifnull(sum(valorVenta(ventas.codventa)), 0) as 'Importe ventas'
FROM ventas RIGHT JOIN clientes ON ventas.codcli=clientes.codcli
GROUP BY clientes.codcli;

