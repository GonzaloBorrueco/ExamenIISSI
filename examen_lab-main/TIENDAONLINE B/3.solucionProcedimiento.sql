USE tiendaonline;


/*
Incluya su solución en el fichero 3.solucionProcedimiento.sql.

Cree un procedimiento que permita crear un nuevo producto con posibilidad de que sea para regalo.
Si el producto está destinado a regalo se creará un pedido con ese producto y costes 0€ para el cliente más
antiguo. (1,5 puntos)

Asegure que el precio del producto para regalo no debe superar los 50 euros y lance excepción si se da el 
caso con el siguiente mensaje: (1 punto)

No se permite crear un producto para regalo de más de 50€.

Garantice que o bien se realizan todas las operaciones o bien no se realice ninguna. (1 punto*/

DELIMITER //

CREATE OR REPLACE PROCEDURE insertar_producto_y_regalos(
    IN p_nombre VARCHAR(255),
    IN p_descripcion VARCHAR(255),
    IN p_precio DECIMAL(10,2),
    IN p_tipoProductoId INT,
    IN p_esParaRegalo BOOLEAN
)
-- incluya su solución a continuación
BEGIN 
	DECLARE precioPedido DECIMAL(10,2);
	DECLARE errorPrecio BOOLEAN;
	DECLARE nuevoProductoId INT;
	declare nuevoPedidoId INT;
	DECLARE clienteAntiguo INT;
	DECLARE direccion VARCHAR(255);
	
	DECLARE exit handler FOR SQLEXCEPTION
	BEGIN 
		ROLLBACK;
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = ' Error al registrar producto y regalos';
		END;
		
		START TRANSACTION;
		
		SELECT MIN(clientes.id) INTO clienteAntiguo FROM clientes c;
		SELECT c.direccionEnvio INTO direccion FROM clientes c WHERE c.id = clienteAntiguo;
		
		INSERT INTO productos(nombre, descripcion, precio, tipoProductoId) VALUES 
		(p_nombre, p_descripcion, p_precio, p_tipoProductoId);
		
		SELECT MAX(productos.id) INTO nuevoProductoId FROM productos;
		
		
		SET errorPrecio = FALSE;
		
		if p_esParaRegalo then 
			if p_precio > 50 then
				SET errorPrecio = TRUE;
			ELSE 
				INSERT INTO pedidos (fechaRealizacion, direccionEntrega,clienteId)
				VALUES (CURDATE(),direccion, clienteAntiguo);
				
				SELECT MAX(pedidos.id) INTO nuevoPedidoId FROM pedidos;
				
					INSERT INTO lineaspedido (pedidoId, productoId, unidades, precio)
					VALUES (nuevoPedidoId,nuevoProductoId,1,0);
					
			END if;
		END if;
		
		
		if errorPrecio then
			ROLLBACK;
			SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No se permite crear un prodcuto para regalos por mas de 50 euros';
		ELSE 
			COMMIT;
		END if;	
	
END //

-- fin de su solución
DELIMITER ;














