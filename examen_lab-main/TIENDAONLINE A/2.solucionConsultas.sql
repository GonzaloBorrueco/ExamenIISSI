USE tiendaonline;

/*
### 2. Consultas SQL (DQL). (3 puntos)

Incluya su solución en el fichero `2.solucionConsultas.sql`.

#### 2.1. Devuelva el nombre del producto, nombre del tipo de producto, y precio unitario al que se vendieron 
los productos digitales (1 punto)


#### 2.2. Consulta que devuelva el nombre del empleado, el número de pedidos de más de 500 euros 
gestionados en este año y el importe total de cada uno de ellos, ordenados de mayor a menor importe 
gestionado. Los empleados que no hayan gestionado ningún pedido, también deben aparecer. (2 puntos)*/

-- Consulta 2.1

SELECT p.nombre, tp.nombre, p.precio FROM productos p 
JOIN tiposproducto tp ON p.tipoProductoId=tp.id

WHERE tp.nombre='Digitales';

-- Consulta 2.2 IMPORTANTE EL HAVING PARA LAS CONDICIONES

SELECT u.nombre, SUM(lp.precio * lp.unidades) as suma 
FROM pedidos pe
left JOIN empleados e ON pe.empleadoId= e.id
left JOIN usuarios u ON u.id=e.usuarioId
JOIN lineaspedido lp ON lp.pedidoId=pe.id
GROUP BY pe.id
HAVING SUM(lp.precio * lp.unidades)>500
ORDER BY suma DESC;
