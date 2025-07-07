USE tiendaonline;

/*
Incluya su solución en el fichero 4.solucionTrigger.sql. 
Cree un trigger llamado p_limitar_unidades_mensuales_de_productos_fisicos que, a partir de este 
momento, impida la venta de más de 1000 unidades al mes de cualquier producto físico.
*/

DELIMITER //
-- incluya su solución a continuación
CREATE OR REPLACE TRIGGER p_limitar_unidades_mensuales_de_productos_fisicos
BEFORE INSERT ON lineaspedido
FOR EACH ROW
BEGIN
	
	DECLARE unidadesVendidasMes INT;
	DECLARE tipoProducto INT;
	DECLARE fecha DATE;
	
	-- Cogemos el tipo del producto
	SELECT pr.tipoProductoId INTO tipoProducto FROM productos pr
	WHERE pr.id= NEW.productoId;
	
	-- si el producto es fisico (id=1) se hace el contenido del trigger
	if (tipoProducto=1) then 
		
		-- cogemos la fecha en la que se envia
		SELECT p.fechaRealizacion INTO fecha FROM pedidos p
		WHERE p.id= NEW.pedidoId;
		
		-- hacemos la suma de las unidades en el mismo mes del mismo año
		
		SELECT SUM(lp.unidades) INTO unidadesVendidasMes FROM lineaspedido lp
		WHERE lp.productoId= NEW.productoId AND MONTH(CURDATE())= MONTH(fecha) AND YEAR(CURDATE())= YEAR(fecha);
		
			
		-- hacemos otro if para la condicion de >1000
		if (unidadesVendidasMes>1000) then
		 SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'no se pueden vender mas de 1000 unidades de productos fisicos al mes';
		
		END if;
	
	END if;
END //
-- fin de su solución
DELIMITER ;



