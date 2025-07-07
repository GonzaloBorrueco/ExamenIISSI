DELIMITER //

-- incluya su solución a continuación
CREATE TRIGGER t_asegurar_mismo_tipo_producto_en_pedidos BEFORE INSERT ON LineasPedido
FOR EACH ROW
BEGIN

	DECLARE productos_fisicos INT;
	DECLARE productos_digitales INT;

    SELECT COUNT(*) INTO productos_fisicos
    FROM lineaspedido lp INNER JOIN productos p ON lp.productoId = p.id
    WHERE p.tipoProductoId = 1
	 AND lp.pedidoId = NEW.pedidoId;
	 
	 SELECT COUNT(*) INTO productos_digitales
    FROM lineaspedido lp INNER JOIN productos p ON lp.productoId = p.id
    WHERE p.tipoProductoId = 2
	 AND lp.pedidoId = NEW.pedidoId;

    IF productos_fisicos IS NOT NULL AND productos_digitales IS NOT NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Un mismo pedido NO puede incluir productos físicos y digitales.';
    END IF;
END //


-- fin de su solución
DELIMITER ;
