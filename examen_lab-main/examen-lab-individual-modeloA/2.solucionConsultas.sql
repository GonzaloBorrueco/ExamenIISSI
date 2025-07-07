-- 2.1
SELECT p.nombre AS nombreProducto, tp.nombre AS tipoProducto, p.precio 
FROM Productos p JOIN TiposProducto tp 
WHERE tp.nombre = 'Digitales';


-- 2.2

SELECT u.nombre, COUNT(DISTINCT p.id), lp.precio
FROM empleados e LEFT JOIN usuarios u JOIN pedidos p JOIN lineaspedido lp
WHERE YEAR(p.fechaRealizacion) = 2024
GROUP BY u.nombre, p.id
HAVING importe_pedido > 500
ORDER BY lp.precio;

-- 2.3