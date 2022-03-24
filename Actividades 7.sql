
SET lc_time_names = 'es_ES';

use EmpresaClase;

/*1. Hallar el salario medio para cada grupo de empleados con igual comisión y para los 
que no la tengan, pero solo nos interesan aquellos grupos de comisión en los que haya más de un empleado.*/

drop procedure if exists ej1;
delimiter $$
create procedure ej1()
BEGIN
	SELECT ifnull(empleados.comisem, 0) as 'Comision', round(avg(empleados.salarem)) as 'Salario medio'
    FROM empleados
    GROUP BY ifnull(empleados.comisem, 9)
    HAVING count(empleados.salarem) > 0;
END $$
delimiter ;

call ej1();

/*2. Para cada extensión telefónica, hallar cuantos empleados la usan y el salario medio de éstos. 
Solo nos interesan aquellos grupos en los que hay entre 1 y 3 empleados*/

drop procedure if exists ej2;
delimiter $$
create procedure ej2()
BEGIN
	SELECT extelem as 'Extensión', count(*), round(avg(salarem), 2) as 'Salario medio'
    FROM empleados
    GROUP BY extelem
    HAVING count(*) between 1 and 3; 
END $$
delimiter ;

call ej2();


use ventapromoscompleta;

/*3. Prepara un procedimiento que, dada un código de promoción obtenga un listado con el 
nombre de las categorías que tienen al menos dos productos incluidos en dicha promoción.*/

drop procedure if exists ej3;
delimiter $$
create procedure ej3(in promo int)
BEGIN
	SELECT categorias.nomcat as'Categoria', count(*) as 'Articulos'
    FROM catalogospromos JOIN articulos on catalogospromos.refart = articulos.refart
						JOIN categorias on articulos.codcat = categorias.codcat
    WHERE catalogospromos.codpromo = promo                    
    GROUP BY categorias.nomcat
    HAVING count(*)>2;

END $$
delimiter ;

call ej3(1);

/*4. Prepara un procedimiento que, dado un precio, obtenga un listado con el nombre de las 
categorías en las que el precio  medio de sus productos supera a dicho precio.*/

drop procedure if exists ej4;
delimiter $$
create procedure ej4(in precio decimal)
BEGIN
	SELECT categorias.nomcat as 'Categoria', avg(articulos.precioventa)
    FROM categorias JOIN articulos ON categorias.codcat = articulos.codcat
	GROUP BY categorias.nomcat
    HAVING avg(articulos.precioventa) > precio;
END $$
delimiter ;

call ej4(3.5);

/*5. Prepara un procedimiento que muestre el importe total de las ventas por meses de un año 
dado.*/

drop procedure if exists ej5;
delimiter $$
create procedure ej5(in anio year)
BEGIN
	SELECT monthname(ventas.fecventa) as 'Mes', sum(detalleventa.precioventa*detalleventa.cant) as 'Total ventas (€)'
    
    FROM detalleventa JOIN ventas on detalleventa.codventa = ventas.codventa
    
    WHERE year(ventas.fecventa) = anio
    
    GROUP BY monthname(ventas.fecventa);
END $$
delimiter ;

call ej5(2012);

/*6. Como el ejercicio anterior, pero ahora solo nos interesa mostrar aquellos meses 
en los que se ha superado a la media del año.*/

drop procedure if exists ej6;
delimiter $$
create procedure ej6(in anio year)
BEGIN
	SELECT monthname(ventas.fecventa) as 'Mes', sum(detalleventa.precioventa*detalleventa.cant) as 'Total ventas (€)',
		round((select sum(detalleventa.precioventa*detalleventa.cant) from detalleventa )/12, 2) as 'Media año'
        
    FROM detalleventa JOIN ventas on detalleventa.codventa = ventas.codventa
    
    WHERE year(ventas.fecventa) = anio
    
    GROUP BY monthname(ventas.fecventa)
    
    HAVING sum(detalleventa.precioventa*detalleventa.cant) > 
				(select avg(detalleventa.precioventa*detalleventa.cant) 
                from detalleventa 
                join ventas on detalleventa.codventa = ventas.codventa
                where year(ventas.fecventa) = anio);
				
END $$
delimiter ;

call ej6(2012);

