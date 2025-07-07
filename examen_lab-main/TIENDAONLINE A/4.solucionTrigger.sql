USE tiendaonline;

/*
4. Trigger. 2 puntos.
Incluya su solución en el fichero 4.solucionTrigger.sql.

Cree un trigger llamado t_asegurar_mismo_tipo_producto_en_pedidos que impida que, a partir de ahora, 
un mismo pedido incluya productos físicos y digitales.*/

DELIMITER //

CREATE TRIGGER t_asegurar_mismo_tipo_producto_en_pedidos
BEFORE INSERT ON lineaspedido 
FOR EACH ROW
BEGIN
    DECLARE tipo_nuevo_producto INT;
    DECLARE tipo_existente_producto INT;

    -- Obtener el tipo del producto que se intenta insertar
    SELECT tipoProductoId INTO tipo_nuevo_producto
    FROM productos
    WHERE id = NEW.productoId;

    -- Obtener el tipo de producto existente (si hay alguno) en el mismo pedido
    SELECT tipoProductoId INTO tipo_existente_producto
    FROM productos p
    JOIN lineaspedido lp ON p.id = lp.productoId
    WHERE lp.pedidoId = NEW.pedidoId
    LIMIT 1;

    -- Si ya había productos en el pedido y el tipo es distinto, se lanza error
    IF tipo_existente_producto IS NOT NULL AND tipo_nuevo_producto != tipo_existente_producto THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'No se pueden mezclar productos físicos y digitales en el mismo pedido';
    END IF;
END //

DELIMITER ;

