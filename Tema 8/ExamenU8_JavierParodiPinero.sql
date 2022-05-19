-- Javier Parodi Piñero
use GBDgestionaTests;

-- P1

DROP TRIGGER IF EXISTS compruebaPreguntaInsert;
delimiter $$
CREATE TRIGGER compruebaPreguntaInsert 
	BEFORE INSERT
ON preguntas
FOR EACH ROW
	BEGIN
		IF (NEW.textopreg IN (select textopreg from preguntas where codtest = new.codtest)) THEN
			SIGNAL SQLSTATE '45000'
				SET MESSAGE_TEXT = 'Esta pregunta ya existe para este test';
        END IF;
	END $$
delimiter ;


DROP TRIGGER IF EXISTS compruebaPreguntaUpdate;
delimiter $$
CREATE TRIGGER compruebaPreguntaUpdate 
	BEFORE UPDATE
ON preguntas
FOR EACH ROW
	BEGIN
		IF (NEW.textopreg <> OLD.textopreg AND
			NEW.textopreg IN (select textopreg from preguntas where codtest = new.codtest)) THEN
            
			SET NEW.textopreg = OLD.textopreg;
            
        END IF;
	END $$
delimiter ;


-- P2

/*Ahora, al utilizar el índice, la búsqueda por materia y unidad será mucho más rápida. Por contraparte,
la necesidad de almacenamiento es mayor y, además, cuando se hagan operaciones de manipulación de 
tests (insert, update...) éstas serán operaciones más complejas. Esto se debe a que, además de la
manipulación de la tabla tests en sí, también será necesaria la actualización de la tabla del índice.*/

CREATE INDEX materiaunidad
	ON tests (codmateria, unidadtest);

SHOW INDEX FROM tests;

-- P3

CREATE OR REPLACE
	DEFINER = user
	SQL SECURITY INVOKER 
    
VIEW NUMERO_TESTS
	(alumno, materia, numero)
AS
	select numexped, codmateria, count(*) 
    from respuestas join tests on respuestas.codtest = tests.codtest
    group by numexped, codmateria
    order by numexped;



DROP PROCEDURE IF EXISTS sumaPuntoAlumnoMateria;
delimiter $$
CREATE PROCEDURE sumaPuntoAlumnoMateria()
BEGIN
       /*Segundo intento fallido*/ 
        DECLARE alumno int;
        DECLARE materia int;
        
        select numexped, codmateria
		from respuestas join tests on respuestas.codtest = tests.codtest
        where count(*)>10
		group by numexped, codmateria
    
    INTO alumno, materia;
    
    select alumno, materia;
        
	if NUMERO_TESTS.numero >= 10 then
		begin
			SET alumno = NUMERO_TESTS.alumno;
            SET materia = NUMERO_TESTS.materia;
            select alumno; select materia;
        end;
    end if;
    
	UPDATE matriculas
    SET nota = nota + 1
    WHERE numexped = alumno and codmateria = materia;
END$$
delimiter ;

DROP EVENT IF EXISTS sumarPuntoTrimestral;
delimiter $$
CREATE EVENT sumarPuntoTrimestral
ON SCHEDULE
	EVERY 1 QUARTER
    /*Entendiendo que estamos en el año en el que va a EMPEZAR
    el curso (no tendría sentido esta norma a final de curso*/
    STARTS concat(year(curdate()),'-09-15') -- Primer dia de clase del año + 3 meses
				+ interval 3 month -- Será al finalizar el trimestre, y se hará la primera vez
                
    ENDS concat(year(curdate())+1,'-06-20') -- Hasta fin de curso (el año siguiente en junio)
DO
	BEGIN
		CALL sumaPuntoAlumnoMateria()
	END ;

delimiter ;


-- P4 

DROP TRIGGER IF EXISTS compruebaRespuestasInsert;
delimiter $$
CREATE TRIGGER compruebaRespuestasInsert
	BEFORE INSERT 
ON preguntas
FOR EACH ROW
	BEGIN
		IF (NEW.resa = New.resb OR NEW.resa = New.resc OR 
				NEW.resb = New.resc) THEN -- Si alguna de las respuestas es igual a otra
			BEGIN   
				SIGNAL SQLSTATE '45000' -- El 45000 está vacío
				SET MESSAGE_TEXT = 'No puede haber dos respuestas iguales';
			END;
        END IF;
	END $$
delimiter ;


DROP TRIGGER IF EXISTS compruebaRespuestasUpdate;
delimiter $$
CREATE TRIGGER compruebaRespuestasUpdate
	BEFORE UPDATE 
ON preguntas
FOR EACH ROW
	BEGIN
		IF (NEW.resa <> OLD.resa OR NEW.resb <> OLD.resb OR NEW.resc <> OLD.resc) AND
			(NEW.resa = New.resb OR NEW.resa = New.resc OR NEW.resb = New.resc) THEN 
            -- Si alguna de las respuestas cambia y es igual a otra
			BEGIN   
				SIGNAL SQLSTATE '45000' -- El 45000 está vacío
				SET MESSAGE_TEXT = 'No puede haber dos respuestas iguales';
			END;
        END IF;
	END $$
delimiter ;

-- P5


/*** PROCEDIMIENTO PARA AÑADIR LAS MATRÍCULAS DEL ALUMNADO    ***/
use gbdgestionatests;

-- NOTA: Para poder hacer este ejercicio, debes añadir una columna en la tabla matrículas:
-- (este campo valdrá 0 la primera vez que un alumno/a curse una materia y 1, 2, etc. cuando repita)
alter table matriculas
	add column repite tinyint default 0,
    drop primary key,
    add constraint pk_matriculas primary key (numexped, codmateria, repite);

delimiter $$
create procedure matriculaAlumnado
 (in numeroexped char(12),
  in nombrealum varchar(30),
  in apellido1alum varchar(30),
  in apellido2alum varchar(30),
  in fechanacimalum date,
  in callealum varchar(60),
  in poblacionalum varchar(60),
  in codpostalalum char(5),
  in emailalum varchar(60),
  in telefonoalum char(12),
  in nomuseralum char(8),
  in passwordalum char(12),
  in cursomatricula char(6)
)
begin
	/*Zona de declaración.*/
	declare alumnomatriculado boolean default false;
    declare numrepeticion tinyint default 0;
    
    /*Manejador de errores que revierte los cambios, para un caso en el que haya algun tipo de
    error. Pese a que no pueda haber un alumno en dos ventanillas, considero que sí 
    puede equivocarse uno de los administrativos y poner el mismo numero que otro etc
	por lo que, ante la duda y para cualquier error, creo el manejador*/
    
    /*La transacción puede no ser 100% necesaria, pero la añadimos acogiendo todo el código,
    para que el rollback del manejador de excepciones, elimine todos los cambios, por 
    cualquier posible error sucedido*/
    
    DECLARE EXIT HANDLER FOR sqlexception
		rollback; 
    
    START TRANSACTION;
    
    /*Zona de código.*/
/* A. Buscamos si el alumno/a ha estado dado de alta anteriormente */
	set alumnomatriculado = exists (select * from alumnos where numexped = numeroexped);

    
/* B. Si el alumno estaba matriculado anteriormente, nos aseguramos que sus datos sean los que nos han pasado,
	  si no, insertaremos al alumno  */
    if alumnomatriculado then
		update alumnos
        set nomalum = nombrealum,
			ape1alum = apellido1alum,
			ape2alum = apellido2alum,
			fecnacim = fechanacimalum,
			calle = callealum,
			poblacion = poblacionalum,
			codpostal = codpostalalum,
			email = emailalum,
			telefono = telefonoalum,
			nomuser = nomuseralum,
			password = passwordalum
		where numexped = numeroexped;
	else
		insert into alumnos
			(numexped, nomalum, ape1alum, ape2alum, fecnacim, calle, poblacion, codpostal, email, telefono, nomuser,password)
		values
			(numeroexped,nombrealum,apellido1alum,apellido2alum,fechanacimalum,callealum,poblacionalum,codpostalalum,emailalum,telefonoalum,nomuseralum,passwordalum);
	end if;
	
    /* C. Si el alumno estaba matriculado, comprobamos el número de veces de repetición de un curso */
    if alumnomatriculado then
		set numrepeticion = 0; /* PUNTO EXTRA */
	else
		set numrepeticion = 0;
	end if;
 
/* D. Añadimos las matrículas */
	/* PUNTO EXTRA */


	COMMIT;

end $$
delimiter ;
