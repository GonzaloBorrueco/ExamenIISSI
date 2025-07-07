USE Concesionario;

-- Cuenta el numero de pagos que ha hecho cada cliente

SELECT u.nombre AS Cliente, v.modelo AS Vehiculo , f.numeroFactura AS Factura, COUNT(p.pagoId) AS numeroPagos
FROM
   Pago p
JOIN
   Factura f ON p.facturaId = f.facturaId
JOIN
   Reserva r ON f.reservaId = r.reservaId
JOIN
   Cliente c ON r.clienteId = c.clienteId
JOIN
   Usuario u ON c.usuarioId = u.usuarioId 
JOIN
   Vehiculo v ON f.vehiculoId = v.vehiculoId
GROUP BY
   f.facturaId
ORDER BY
   Cliente, Vehiculo;


-- Muestra la media de importe de los pagos

SELECT COUNT(Distinct f.facturaId) AS NumeroFacturas, Round(AVG(p.importe)) AS MediaPagos
FROM factura f JOIN Pago p ON f.facturaId = p.facturaId;



-- Devuelve el numero de ventas de cada vendedor
SELECT 
   u.nombre, u.apellido,u.email,
   COUNT(f.facturaId) AS numeroVentas
FROM 
   factura f natural JOIN vehiculo v JOIN usuario u WHERE vendedorId=usuarioId
GROUP BY v.vendedorId;


-- Muestra los sueldos de cada vendededor de mayor a menor

SELECT ve.vendedorId,u.nombre, ve.salario
FROM 
   Vendedor ve JOIN usuario u ON ve.usuarioId=u.usuarioId
GROUP BY 
   ve.vendedorId, u.nombre, ve.salario
ORDER BY 
	ve.salario DESC;
   
   
-- modelos más vendidos mas vendidos:

SELECT v.marca, v.modelo, COUNT(f.facturaId) AS totalVentas
FROM vehiculo v JOIN Factura f ON v.vehiculoId = f.vehiculoId
GROUP BY 
   v.marca, v.modelo
ORDER BY 
   totalVentas DESC;
    
