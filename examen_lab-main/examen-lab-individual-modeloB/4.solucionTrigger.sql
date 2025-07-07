-- ree un trigger llamado t_limitar_importe_pedidos_de_menores que impida que, a partir de ahora,
-- los pedidos realizados por menores superen los 500€

DELIMITER //
-- incluya su solución a continuación
CREATE OR REPLACE TRIGGER t_limitar_importe_pedidos_de_menores BEFORE INSERT ON lineaspedido
FOR EACH ROW
BEGIN
	DECLARE clienteEdad INT;
	DECLARE importe_pedido DECIMAL(10, 2);
	
	SELECT TIMESTAMPDIFF(YEAR, fechaNacimiento, CURDATE()) INTO clienteEdad
   FROM Clientes INNER JOIN Pedidos ON Clientes.id = Pedidos.clienteId
   WHERE Pedidos.id = NEW.pedidoId;
   
   
   SELECT SUM(lp.unidades*lp.precio)+NEW.unidades*NEW.precio INTO importe_pedido
	FROM lineaspedido lp 
	WHERE lp.pedidoId = NEW.pedidoId;

    IF clienteEdad < 18 AND importe_pedido > 500 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Los pedidos realizados por menores no pueden superar los 500€';
    END IF;
END //
-- fin de su solución
DELIMITER ;

