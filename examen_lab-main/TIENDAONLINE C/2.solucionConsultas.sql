USE tiendaonline;

/*
2.1. Devuelva el nombre del producto, el precio unitario y las unidades compradas para las 5 líneas 
de pedido con más unidades. (1 punto) 

2.2. Devuelva el nombre del empleado, la fecha de realización del pedido, el precio total del pedido y 
las unidades totales del pedido para todos los pedidos que de más 7 días de antigüedad desde que 
se realizaron. Si un pedido no tiene asignado empleado, también debe aparecer en el listado 
devuelto. (2 puntos)*/

-- 2.1


SELECT p.nombre, lp.precio, lp.unidades FROM lineaspedido lp
JOIN productos p ON p.id= lp.productoId
ORDER BY (lp.unidades) desc
LIMIT 5;


-- 2.2

SELECT u.nombre, pe.fechaRealizacion, SUM(lp.precio * lp.unidades) precioTotal, SUM(lp.unidades) unidades FROM pedidos pe
left JOIN empleados e ON e.id= pe.empleadoId
left JOIN usuarios u ON e.usuarioId= u.id
JOIN lineaspedido lp ON lp.pedidoId= pe.id
GROUP BY pe.id
HAVING (pe.fechaRealizacion <=(DATE_SUB(CURDATE(),INTERVAL 7 DAY))) -- resta fecha actual menos 7 y la compara con fechaRealizacion
ORDER BY pe.fechaRealizacion;











