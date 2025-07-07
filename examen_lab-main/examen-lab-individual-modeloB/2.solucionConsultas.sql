-- 2.1. Devuelva el nombre del del empleado, la fecha de realización del pedido y el nombre del cliente 
-- de todos los pedidos realizados este mes.

/*
SELECT u_e.nombre AS nombreEmpleado, p.fechaRealizacion, u_c.nombre AS nombreCliente
FROM pedidos p
JOIN clientes c ON c.id = p.clienteId
JOIN usuarios u_c ON u_c.id = c.usuarioId
LEFT JOIN empleados e ON e.usuarioId = p.empleadoId
LEFT JOIN usuarios u_e ON e.usuarioId = u_e.id
WHERE MONTH(p.fechaRealizacion) = '03';
*/

-- 2.2. Devuelva el nombre, las unidades totales pedidas y el importe total gastado de aquellos clientes
-- que han realizado más de 5 pedidos en el último año.
SELECT u.nombre, SUM(lp.unidades), SUM(lp.precio * lp.unidades)
FROM pedidos p
JOIN clientes c ON p.clienteId = c.id
JOIN usuarios u ON c.usuarioId = u.id
JOIN lineaspedido lp ON p.id = lp.pedidoId
WHERE YEAR(p.fechaRealizacion) = 2024
GROUP BY u.id
HAVING COUNT(DISTINCT p.id) > 5;


-- 2.3