DROP PROCEDURE IF EXISTS actualizar_precio_producto;

DELIMITER //

CREATE PROCEDURE actualizar_precio_producto(
    IN p_productoId INT,
    IN p_nuevoPrecio DECIMAL(10, 2)
)
-- incluya su solución a continuación
BEGIN

DECLARE precio_actual DECIMAL(10, 2);

SELECT precio INTO precio_actual FROM productos WHERE id = p_productoId;

IF p_nuevoPrecio < precio_actual*0.5 THEN 
	SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'No se permite rebajar el precio más del 50%';
END IF;

UPDATE productos 
SET precio = p_nuevoPrecio 
WHERE id = p_productoId;


UPDATE lineaspedido lp 
JOIN pedidos p ON lp.pedidoId = p.id 
SET lp.precio = p_nuevoPrecio 
WHERE lp.productoId = p_productoId
AND p.fechaEnvio IS NULL;


END//

-- fin de su solución
DELIMITER ;


CALL actualizar_precio_producto(1, 699.99);