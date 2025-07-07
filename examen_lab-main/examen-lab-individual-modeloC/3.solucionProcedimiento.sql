DELIMITER //

CREATE OR REPLACE PROCEDURE bonificar_pedido_retrasado(IN p_pedidoId INT)
-- incluya su solución a continuación
BEGIN
DECLARE id_empleado INT DEFAULT NULL;

  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
      ROLLBACK;
      SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error del procedure';
  END;

 START TRANSACTION;

SELECT p.empleadoId INTO id_empleado
FROM pedidos p
WHERE p.id = p_pedidoId
LIMIT 1;

  IF id_empleado IS NULL THEN
  	ROLLBACK;
      SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El pedido no tiene gestor';
  END IF;


UPDATE pedidos p
SET p.empleadoId = (SELECT e.id FROM empleados e WHERE e.id != id_empleado ORDER BY RAND() LIMIT 1)
WHERE p.id = p_pedidoId;

UPDATE lineaspedido lp 
SET lp.precio = lp.precio - lp.precio * 0.2
WHERE lp.pedidoId = p_pedidoId;





COMMIT;
END//
-- fin de su solución
DELIMITER ;

CALL bonificar_pedido_retrasado(1);