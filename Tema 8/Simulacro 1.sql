use ventapromoscompleta;

/*P1. Cuando se incluye un producto en una promoción, queremos controlar que su precio 
promocionado en ningún caso pueda ser mayor o igual al precio de venta habitual 
(precio fuera de promoción). Si sucediera esto habrá que evitar que se añada dicho 
producto a la promoción y se avisará de lo sucedido mediante mensaje.*/

DROP TRIGGER IF EXISTS precioPromoInferiorInsert;
delimiter $$
CREATE TRIGGER precioPromoInferiorInsert
	BEFORE INSERT
    ON catalogospromos
FOR EACH ROW
	BEGIN
		SET NEW.precioartpromo = abs(NEW.precioartpromo);
		IF (NEW.precioartpromo >= (select precioventa from articulos where refart = NEW.refart)) THEN
			SIGNAL SQLSTATE '45000' -- El 45000 está vacío
				SET MESSAGE_TEXT = 'El precio no puede ser superior al habitual';
        END IF;
    END;  

/*P2. También se nos ha pedido que controlemos lo anterior cuando se esté modificando 
el precio de un producto en una promoción. En este caso se permitirá la modificación 
pero se mantendrá el precio que tuviera previamente.*/

DROP TRIGGER IF EXISTS compruebaPrecioUpdate;
delimiter $$
CREATE TRIGGER compruebaPrecioUpdate
	BEFORE UPDATE
    ON catalogospromos
FOR EACH ROW
	BEGIN
		SET NEW.precioartpromo = abs(NEW.precioartpromo);
		IF (NEW.precioartpromo <> OLD.precioartpromo) AND 
        (NEW.precioartpromo >= (select precioventa from articulos where refart = NEW.refart)) THEN
			
				SET NEW.precioartpromo = OLD.precioartpromo;
        END IF;
    END; 

/*P3. Se ha elaborado un procedimiento “OptimizaCatalogosPromos”. Nos piden que hagamos 
lo que consideremos oportuno para que se ejecute cada semestre (2 trimestres) durante 
el próximo año. Para comenzar nos piden que lo dejemos preparado para que, desde hoy 
martes,  comience a ejecutarse el domingo a las 00.00h.*/

DROP EVENT IF EXISTS optimizarCatalogoSemestre;
delimiter $$
CREATE EVENT optimizarCatalogoSemestre
ON SCHEDULE
	EVERY 2 QUARTER
    STARTS '2022-05-22 00:00:00'
    ENDS '2022-05-22 00:00:00' + interval 1 year
DO
	BEGIN
		CALL OptimizaCatalogosPromos();
	END $$

delimiter ;


/*Teoría*/

/*** PROCEDIMIENTO PARA AÑADIR UNA NUEVA PROMOCIÓN  ***/
drop procedure if exists nuevoPromo;
delimiter $$
create procedure nuevoPromo
 (in descripcion varchar(100),
	fechainicio date,
	duracion int,
	porcentajeDes decimal (4,2),  -- porcentaje de descuento sobre el precio habitual
	puntos int -- puntos para los clientes
)
begin

	
	/*Zona de declaración.*/
    DECLARE EXIT HANDLER FOR sqlexception
		rollback;
    
	DECLARE nuevaPromocion int;
    /*Zona de código.*/
	start transaction;
		/* A. Buscamos última promocion + 1 */
		select ifnull(max(codpromo)+1,1) into nuevaPromo 
		from promociones;

		/* C. Insertamos la nueva promocion */
		insert into promociones
			(codpromo,despromo,fecinipromo,duracionpromo)
		values
			(nuevaPromocion, descipcion, fechainicio,duracion);
		/* D. Insertamos un producto por cada categoría. Buscamos el producto de cada categoría que lleva más tiempo sin promocionar */
		call insertaArticulosEnPromocion(nuevaPromo, porcentajeDes, puntos);	

	commit;
end $$
delimiter ;


