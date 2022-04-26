use empresaclase;
/*Ejercicio Crea la tabla de control de errores en la base de datos empresa. 
Averigua cual es el código de error para la restricción de integridad referencial 
(no existe el valor de clave foránea donde es clave primaria). Prepara un procedimiento 
almacenado que inserte un empleado nuevo, incluye el manejador de error para clave 
primaria repetida del ejercicio anterior y añade un manejador de error de restricción 
de integridad referencial con la tabla departamentos)*/

drop table if exists control_errores;
create table if not exists control_errores(
	cod_control INT NOT NULL, 
    fec_error DATETIME,
    mensaje_error VARCHAR(100),
    
    constraint pk_cod_control primary key (cod_control)
);

DROP PROCEDURE IF EXISTS inserta_empleado;
DELIMITER $$
CREATE PROCEDURE inserta_empleado 
	(num_empleado int,
	numde int ,
	extelem char(3) ,
	fecnaem date ,
	fecinem date ,
	salarem decimal(7,2) ,
	comisem decimal(7,2) ,
	numhiem tinyint ,
	nomem varchar(20) ,
	ape1em varchar(20) ,
	ape2em varchar(20) ,
	dniem char(9) ,
	userem char(12) ,
	passem char(12)
    )
MODIFIES SQL DATA
BEGIN
	DECLARE EXIT HANDLER FOR 1062 -- Clave duplida
	BEGIN
		DECLARE control INT;
		SET control = (select ifnull(max(cod_control),0)+1 FROM control_errores);
		INSERT INTO control_errores(cod_control, fec_error, mensaje_error)
			VALUES(control,	current_date, 'Inserción clave duplicada en empleados');
	END;
    
    DECLARE EXIT HANDLER FOR 1452 -- Valor de FK inexistente donde es PK
	BEGIN
		DECLARE control INT;
		SET control = (select ifnull(max(cod_control),0)+1 FROM control_errores);
		INSERT INTO control_errores(cod_control, fec_error, mensaje_error)
			VALUES(control,	current_date, 'No existe el valor de clave foránea donde es clave primaria');
	END;
    
	INSERT INTO empleados (numem, numde, extelem, fecnaem, fecinem, salarem,
		comisem, numhiem, nomem, ape1em, ape2em, dniem, userem, passem)
        VALUES(num_empleado, numde, extelem, fecnaem, fecinem, salarem,
		comisem, numhiem, nomem, ape1em, ape2em, dniem, userem, passem);
	
END$$

CALL inserta_empleado(456, 100, '123', '1996/09/16', '2020/05/20', 1000,
		250, 1, 'Javier', 'Parodi', 'Piñero', '00000384L', 'javiakasino8', '123456789123');

CALL inserta_empleado(1233, 1, '123', '1996/09/16', '2020/05/20', 1000,
		250, 1, 'Javier', 'Parodi', 'Piñero', '00000384L', 'javiakasino8', '123456789123');