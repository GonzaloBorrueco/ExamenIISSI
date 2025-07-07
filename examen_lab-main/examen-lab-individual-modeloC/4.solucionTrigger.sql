-- Cree un trigger llamado p_limitar_unidades_mensuales_de_productos_fisicos que, a partir de este
-- momento, impida la venta de más de 1000 unidades al mes de cualquier producto físico.

DELIMITER //
-- incluya su solución a continuación
CREATE OR REPLACE TRIGGER p_limitar_unidades_mensuales_de_productos_fisicos BEFORE INSERT ON lineaspedido
FOR EACH ROW
BEGIN

	DECLARE unidades_pedidos_mes INT;

	SELECT SUM(lp.unidades) INTO unidades_pedidos_mes
	FROM pedidos p
	JOIN lineaspedido lp ON p.id = lp.pedidoId
	JOIN productos pro ON lp.productoId = pro.id
	WHERE MONTH(p.fechaRealizacion) = MONTH(CURDATE())
	AND YEAR(p.fechaRealizacion) = YEAR(CURDATE())
	AND pro.tipoProductoId = 1
	AND pro.id = NEW.productoId;


    IF unidades_pedidos_mes+NEW.unidades > 1000 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'No se pueden vender más de 1000 unidades al mes de cualquier producto físico.';
    END IF;




END //
-- fin de su solución
DELIMITER ;