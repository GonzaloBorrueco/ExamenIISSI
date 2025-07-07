USE tiendaonline;


/*
4. Trigger. 2 puntos
Incluya su solución en el fichero 4.solucionTrigger.sql.

Cree un trigger llamado t_limitar_importe_pedidos_de_menores que impida que, a partir de ahora, 
los pedidos realizados por menores superen los 500€.*/


DELIMITER //

CREATE OR REPLACE TRIGGER t_limitar_importe_pedidos_de_menores
BEFORE INSERT ON lineaspedido
FOR EACH ROW
BEGIN
  DECLARE edad_cliente INT;
  DECLARE importe_actual DECIMAL(10,2);

  -- Calcular la edad del cliente que hizo el pedido
  SELECT TIMESTAMPDIFF(YEAR, c.fechaNacimiento, CURDATE()) INTO edad_cliente
  FROM pedidos p
  JOIN clientes c ON p.clienteId = c.id
  WHERE p.id = NEW.pedidoId;

  -- Calcular el importe total actual del pedido (sin la nueva línea aún)
  SELECT SUM(lp.unidades * lp.precio) INTO importe_actual
  FROM lineaspedido lp
  WHERE lp.pedidoId = NEW.pedidoId;

  -- Verificar si al añadir esta nueva línea se superan los 500 €
  IF edad_cliente < 18 AND importe_actual > 500 THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Clientes menores no pueden superar 500€ en pedidos';
  END IF;
  
END //

DELIMITER ;

