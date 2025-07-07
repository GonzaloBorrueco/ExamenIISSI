USE tiendaonline;

/*
Incluya su solución en el fichero 3.solucionProcedimiento.sql. 
Cree un procedimiento que permita bonificar un pedido que se ha retrasado debido a la mala gestión 
del empleado a cargo. Recibirá un identificador de pedido, asignará a otro empleado como gestor y 
reducirá un 20% el precio unitario de cada línea de pedido asociada a ese pedido. (1,5 puntos) 
Asegure que el pedido estaba asociado a un empleado y en caso contrario lance excepción con el 
siguiente mensaje: (1 punto) 
El pedido no tiene gestor. 
Garantice que o bien se realizan todas las operaciones o bien no se realice ninguna. (1 punto)*/

DELIMITER //

CREATE PROCEDURE bonificar_pedido_retrasado(IN p_pedidoId INT)
-- incluya su solución a continuación
BEGIN
	DECLARE gestor INT;
	
	DECLARE exit handler FOR SQLEXCEPTION, SQLWARNING
	BEGIN
		ROLLBACK;
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error al bonificar el pedido';
	
	END;
	
	START TRANSACTION;
	
	-- seleccionar gestor actual
	SELECT pe.empleadoId INTO gestor 
	FROM pedidos pe WHERE pe.id= p_pedidoId;
	
	
	-- compruebo si hay gestor
	if gestor IS NULL then 
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'pedido sin gestor';
	END if;
	
	-- cambiar el gestor
	if (gestor=1) then 
		SET gestor=2;
		
	ELSE 
		SET gestor=1;
		
	END if;
	
	-- reduzco el precio del producto un 20%
	UPDATE lineaspedido lp
		SET lp.precio= lp.precio * 0.80
		WHERE lp.pedidoId= p_pedidoId;


	-- actualizo el pedido con el nuevo empleado
	
	UPDATE pedidos p
		SET p.empleadoId = gestor
		WHERE p.id = p_pedidoId;

	
	COMMIT;
END //

-- fin de su solución
DELIMITER ;