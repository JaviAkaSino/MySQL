-- Javier Parodi Piñero

use GBDturRural2015;

-- Ejercicio 1

DROP PROCEDURE IF EXISTS ej01;
delimiter $$
CREATE PROCEDURE ej01
	(in zona int,
    in caracteristica int)

BEGIN

	SELECT casas.nomcasa as 'Casa', casas.preciobase as 'Precio' 
    -- ,casas.codzona, caracteristicasdecasas.codcaracter, caracteristicasdecasas.tiene
    FROM casas JOIN caracteristicasdecasas ON casas.codcasa = caracteristicasdecasas.codcasa
    WHERE casas.codzona = zona
		AND caracteristicasdecasas.codcaracter = caracteristica 
		AND caracteristicasdecasas.tiene = 1
	ORDER BY casas.preciobase desc;
      

END$$
delimiter ;

call ej01(1, 1);


-- Ejercicio 2

SELECT casas.nomcasa as 'Casa', ifnull(caracteristicas.nomcaracter,'') as 'Caracteristica'
FROM casas LEFT JOIN caracteristicasdecasas ON casas.codcasa = caracteristicasdecasas.codcasa
	LEFT JOIN caracteristicas on caracteristicasdecasas.codcaracter = caracteristicas.numcaracter;

-- Ejercicio 3

DROP PROCEDURE IF EXISTS ej03;
delimiter $$
CREATE PROCEDURE ej03
	(in tipo int)

BEGIN

	SELECT zonas.nomzona as 'ZONA', casas.nomcasa as 'CASA',
		concat('de ', casas.minpersonas, ' a ', casas.maxpersonas, ' personas') as 'ALOJAMIENTO PARA'
    FROM casas JOIN zonas ON casas.codzona = zonas.numzona
    WHERE casas.codtipocasa = tipo
    ORDER BY zonas.nomzona;

END$$
delimiter ;

call ej03(1);



-- Ejercicio 4

DROP PROCEDURE IF EXISTS ej04;
delimiter $$
CREATE PROCEDURE ej04()

BEGIN

	SELECT zonas.nomzona as 'ZONA', avg(casas.m2) as 'MEDIA M2'
    FROM  zonas JOIN casas ON zonas.numzona = casas.codzona
	GROUP BY casas.codzona;
    
END$$
delimiter ;

call ej04();


-- Ejercicio 5

DROP FUNCTION IF EXISTS ej05;
 delimiter $$
 CREATE FUNCTION ej05 
	(casa int)
 
 RETURNS int
 
 LANGUAGE SQL
 DETERMINISTIC
 READS SQL DATA
 
 BEGIN
 
 RETURN(SELECT count(*)
			FROM reservas
            WHERE codcasa = casa);
 
 END$$
 
 SELECT ej05(1) as 'Reservas casa 1';
 SELECT ej05(2) as 'Reservas casa 2';

-- Ejercicio 6

DROP PROCEDURE IF EXISTS ej06;
delimiter $$
CREATE PROCEDURE ej06
	(in casa int,
    out reservas int,
    out totaldiasres int)

BEGIN

	SELECT count(*), sum(numdiasestancia) 
		into reservas, totaldiasres
	FROM reservas
    WHERE codcasa = casa;

END$$
delimiter ;

call ej06(1, @reservas, @totaldiasres);
select @reservas as 'Reservas casa 1',@totaldiasres as 'Días totales reservados';

-- Ejercicio 7

/*Rutina número de propiedades que tiene en alquiler cada propietario
nomre y apellidos separados sencillos. NO propietarios con solo una casa*/

DROP PROCEDURE IF EXISTS ej07;
delimiter $$
CREATE PROCEDURE ej07()

BEGIN

	UPDATE propietarios
	SET nompropietario = trim(nompropietario); -- Aseguramos que no empiece un nombre por ' '

	SELECT left(nompropietario, locate(' ', nompropietario)-1) as 'Nombre', -- Izquierda del espacio
		substring(nompropietario, locate(' ', nompropietario), length(nompropietario)) as 'Apellidos',
        
        -- substring_index(propietarios.nompropietario, ' ', 1)
        
        (select count(c.codcasa) 
        from casas as c join propietarios as p on c.codpropi = p.codpropietario
        where propietarios.codpropietario = p.codpropietario) as 'Propiedades'
        
    FROM propietarios
    WHERE (select count(c.codcasa)
        from casas as c join propietarios as p on c.codpropi = p.codpropietario
        where propietarios.codpropietario = p.codpropietario) > 1 -- Queda un poco guarro pero funciona
        
    GROUP BY propietarios.codpropietario;
    


END$$
delimiter ;

call ej07();

-- Ejercicio 8

/*PROC muestre casas codigo y nombre
disponibles para un rango de fechas y una zona*/

DROP PROCEDURE IF EXISTS ej08;
delimiter $$
CREATE PROCEDURE ej08
	(in fecinicial date,
    in fecfinal date,
    in zona int)

BEGIN

	SELECT casas.codcasa as 'Código', casas.nomcasa as 'Casa'
    FROM casas LEFT JOIN reservas ON casas.codcasa = reservas.codcasa
    WHERE codzona = zona -- Filtra por zona y...
		-- La fecha inicial o final de las reservas hechas no esta en el rango o está cancelada
        AND (((reservas.feciniestancia not between fecinicial and fecfinal)
        AND (date_add(reservas.feciniestancia, interval reservas.numdiasestancia day) not between fecinicial and fecfinal))
			OR reservas.fecanulacion is not null
            OR reservas.feciniestancia is null) -- O no hay reservas
       
		GROUP BY casas.codcasa
		
    ;

END$$
delimiter ;

call ej08('2013/03/25','2013/03/30',1);

