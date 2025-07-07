-- 2.1  Devuelva el nombre del producto, el precio unitario y las unidades compradas para las 5 líneas
-- de pedido con más unidades.
SELECT pro.nombre, lp.precio, lp.unidades
FROM lineaspedido lp 
JOIN productos pro ON lp.productoId = pro.id
ORDER BY lp.unidades DESC
LIMIT 5;


-- 2.2 Devuelva el nombre del empleado, la fecha de realización del pedido, el precio total del pedido y
-- las unidades totales del pedido para todos los pedidos que de más 7 días de antigüedad desde que
-- se realizaron. Si un pedido no tiene asignado empleado, también debe aparecer en el listado devuelto. 
SELECT u.nombre, p.fechaRealizacion, SUM(lp.unidades*lp.precio), SUM(lp.unidades)
FROM pedidos p
JOIN lineaspedido lp ON lp.pedidoId = p.id
LEFT JOIN empleados e ON p.empleadoId = e.id
LEFT JOIN usuarios u ON e.usuarioId = u.id
WHERE TIMESTAMPDIFF(DAY, p.fechaRealizacion, CURDATE()) >= 7
GROUP BY p.id, u.nombre, p.fechaRealizacion;


-- 2.3