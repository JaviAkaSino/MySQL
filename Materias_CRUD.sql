-- OPERACIONES CRUD

-- Materias 

-- BUSCAR materias

DROP procedure if exists buscarMaterias()
delimiter $$
create procedure buscarMaterias()

begin

	SELECT codmateria as 'Código', nommateria as 'Materia', 
		cursomateria as 'Curso'
    
    FROM materias
    
    ORDER BY nommateria and cursomateria;

end $$
delimiter ;

call buscarMaterias();


-- CREAR nueva materia


delete procedure if exists nuevaMateria()
delimiter $$
create procedure nuevaMateria(in nombre varchar(60), 
	in curso char(6), out codigo int)
    
    BEGIN
    
		declare nuevocentro int;
        
        start transaction;
        
			set nuevocentro = (select max(codmateria) + 1 
								from centros);
                                
			insert into materias
				(codmateria, nommateria, cursomateria)
				values
					(nuevocentro, nombre, curso);
                    
        commit;
    
    END $$
    delimiter ;

-- Prueba
call nuevaMateria('BADAT', '1º DAW', @resultado);

select @resultado;


