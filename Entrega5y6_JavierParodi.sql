use ventapromoscompleta;

-- Javier Parodi Piñero

/*5. Prepara un procedimiento que muestre el importe total de las ventas por meses de un año 
dado.*/

drop procedure if exists ej5;
delimiter $$
create procedure ej5(in anio year)
BEGIN
	SELECT month(ventas.fecventa) as 'Mes', sum(detalleventa.precioventa*detalleventa.cant) as 'Total ventas (€)'
    
    FROM detalleventa JOIN ventas on detalleventa.codventa = ventas.codventa
    
    WHERE year(ventas.fecventa) = anio
    
    GROUP BY month(ventas.fecventa);
END $$
delimiter ;

call ej5(2012);

/*6. Como el ejercicio anterior, pero ahora solo nos interesa mostrar aquellos meses 
en los que se ha superado a la media del año.*/

drop procedure if exists ej6;
delimiter $$
create procedure ej6(in anio year)
BEGIN
	SELECT month(ventas.fecventa) as 'Mes', sum(detalleventa.precioventa*detalleventa.cant) as 'Total ventas (€)',
		round((select sum(detalleventa.precioventa*detalleventa.cant) from detalleventa )/12, 2) as 'Media año'
        
    FROM detalleventa JOIN ventas on detalleventa.codventa = ventas.codventa
    
    WHERE year(ventas.fecventa) = anio
    
    GROUP BY month(ventas.fecventa)
    
    HAVING sum(detalleventa.precioventa*detalleventa.cant) > 
				(select sum(detalleventa.precioventa*detalleventa.cant) 
                from detalleventa 
                join ventas on detalleventa.codventa = ventas.codventa
                where year(ventas.fecventa) = anio)/12;
				
END $$
delimiter ;

call ej6(2012);
