USE tiendaonline;

/*
. Consultas SQL (DQL). 3 puntos
Incluya su solución en el fichero 2.solucionConsultas.sql.

2.1. Devuelva el nombre del empleado, la fecha de realización del pedido y el nombre del cliente de todos
 los pedidos realizados este mes. (1 puntos)
 
2.2. Devuelva el nombre, las unidades totales pedidas y el importe total gastado de aquellos clientes que han
 realizado más de 5 pedidos en el último año. (2 puntos)*/
 
 -- 2.1
  
SELECT u.nombre AS empleado, p.fechaRealizacion, 
			(SELECT u1.nombre FROM pedidos p1 JOIN clientes c1 ON p1.clienteId = c1.id
				JOIN usuarios u1 ON c1.usuarioId = u1.id
				WHERE c1.id = p.clienteId
				LIMIT 1) AS cliente				
	FROM empleados e
	RIGHT JOIN usuarios u ON e.usuarioId = u.id-- importante el rigth join para que salgan todos 
	RIGHT JOIN pedidos p ON p.empleadoId = e.id
	WHERE MONTH(p.fechaRealizacion) = MONTH(CURDATE())
	  AND YEAR(p.fechaRealizacion) = YEAR(CURDATE()); 
-- 2.2 
/*
2.2. Devuelva el nombre, las unidades totales pedidas y el importe total gastado de aquellos clientes que han
 realizado más de 5 pedidos en el último año. (2 puntos)*/
 
 
SELECT u.nombre, SUM(lp.unidades) unidades, SUM(lp.precio * lp.unidades) importe FROM pedidos p
	JOIN clientes c ON p.clienteId = c.id
	JOIN usuarios u ON c.usuarioId = u.id
	JOIN lineaspedido lp ON lp.pedidoId= p.id
	WHERE YEAR(p.fechaRealizacion)= '2024'
	GROUP BY p.clienteId
	HAVING COUNT(*)>5;





 
 
 