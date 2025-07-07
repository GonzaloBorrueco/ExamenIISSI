USE tiendaonline;


/*
### 3. Procedimiento. Actualizar precio de un producto y líneas de pedido no enviadas. (3,5 puntos)

Incluya su solución en el fichero `3.solucionProcedimiento.sql`.

Cree un procedimiento que permita actualizar el precio de un producto dado y que modifique los precios
 de las líneas de pedido asociadas al producto dado solo en aquellos pedidos que aún no hayan sido enviados. 
 (1,5 puntos)

Asegure que el nuevo precio no sea un 50% menor que el precio actual y lance excepción si se da el caso
 con el siguiente mensaje: (1 punto)

`No se permite rebajar el precio más del 50%`.

Garantice que o bien se realizan todas las operaciones o bien no se realice ninguna. (1 punto)

*/

DELIMITER //

CREATE OR REPLACE PROCEDURE actualizar_precio_producto(
    IN p_productoId INT,
    IN p_nuevoPrecio DECIMAL(10, 2)
)
BEGIN
    -- Variables locales
    DECLARE v_precioActual DECIMAL(10,2);

    -- Manejo de errores
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    -- Iniciar transacción
    START TRANSACTION;

    -- Obtener el precio actual del producto
    SELECT precio INTO v_precioActual
    FROM productos
    WHERE id = p_productoId;

    -- Comprobar que no se baja más del 50%
    IF p_nuevoPrecio < v_precioActual * 0.5 THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'No se permite rebajar el precio más del 50%';
    END IF;

    -- Actualizar precio del producto
    UPDATE productos
    SET precio = p_nuevoPrecio
    WHERE id = p_productoId;

    -- Actualizar líneas de pedido que aún no han sido enviadas
    UPDATE lineaspedido lp
    JOIN pedidos pe ON lp.pedidoId = pe.id
    SET lp.precio = p_nuevoPrecio
    WHERE lp.productoId = p_productoId
      AND pe.fechaEnvio IS NULL;

    -- Confirmar cambios
    COMMIT;
END //

DELIMITER ;
