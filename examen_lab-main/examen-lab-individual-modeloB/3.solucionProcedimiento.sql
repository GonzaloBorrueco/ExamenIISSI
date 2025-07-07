
-- Cree un procedimiento que permita crear un nuevo producto con posibilidad de que sea para regalo.
-- Si el producto está destinado a regalo se creará un pedido con ese producto y costes 0€ para el
-- cliente más antiguo.

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

DECLARE cliente_mas_antiguo INT;
DECLARE ultimo_pedido INT;
DECLARE ultimo_producto INT;

SELECT c.id INTO cliente_mas_antiguo
FROM clientes c
ORDER BY c.fechaNacimiento
LIMIT 1;

IF p_esParaRegalo AND p_precio > 50 THEN
   SIGNAL SQLSTATE '45000'
   SET MESSAGE_TEXT = 'No se permite crear un producto para regalo de más de 50€';
END IF;


INSERT INTO productos (nombre, descripción, precio, tipoProductoId) 
VALUES (p_nombre, p_descripcion, p_precio, p_tipoProductoId);
SET ultimo_producto = LAST_INSERT_ID();

INSERT INTO Pedidos (fechaRealizacion, fechaEnvio, direccionEntrega, comentarios, clienteId, empleadoId) VALUES
(CURDATE(), NULL, '123 Calle Principal', 'Regalo', cliente_mas_antiguo,  1);
SET ultimo_pedido = LAST_INSERT_ID();

INSERT INTO lineaspedido (pedidoId, productoId, unidades, precio) VALUES
(ultimo_pedido, ultimo_producto, 1, 0);

END//
-- fin de su solución
DELIMITER ;

CALL insertar_producto_y_regalos('patatillas', 'saladitas', 220.0, 1, FALSE);