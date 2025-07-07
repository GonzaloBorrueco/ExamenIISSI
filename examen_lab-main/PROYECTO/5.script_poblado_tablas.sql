USE Concesionario;


INSERT INTO Usuario (nombre, apellido, email, telefono, dni, edad) 
VALUES 
-- Vendedores
('Juan', 'Pérez', 'juan.perez@email.com', '123456789', '12345678A', 30), 
('María', 'González', 'maria.gonzalez@email.com', '987654321', '23456789B', 25),
('Carlos', 'Martínez', 'carlos.martinez@email.com', '456789123', '34567890C', 40),
('Ana', 'Rodríguez', 'ana.rodriguez@email.com', '321654987', '45678901D', 22),
('Luis', 'Hernández', 'luis.hernandez@email.com', '789123456', '56789012E', 28),
('Antonio', 'Ramírez', 'antonio.ramirez@email.com', '112233445', '67890123G', 35),
('Pedro', 'Fernández', 'pedro.fernandez@email.com', '223344556', '78901234H', 33),
('Javier', 'García', 'javier.garcia@email.com', '334455667', '89012345I', 45),
('David', 'López', 'david.lopez@email.com', '445566778', '90123456J', 38),
('Miguel', 'Morales', 'miguel.morales@email.com', '556677889', '01234567K', 50),

-- Clientes
('Eva', 'López', 'eva.lopez@email.com', '112233445', '67890123F', 25),
('Pedro', 'Gómez', 'pedro.gomez@email.com', '223344556', '78901234G', 29),
('Laura', 'Sánchez', 'laura.sanchez@email.com', '334455667', '89012345H', 32),
('José', 'Díaz', 'jose.diaz@email.com', '445566778', '90123456I', 24),
('Sofía', 'Álvarez', 'sofia.alvarez@email.com', '556677889', '01234567J', 38),
('Raquel', 'Martínez', 'raquel.martinez@email.com', '223344555', '12345678Q', 27),
('Carmen', 'González', 'carmen.gonzalez@email.com', '334455667', '23456789R', 26),
('Alberto', 'Jiménez', 'alberto.jimenez@email.com', '445566788', '34567890S', 33),
('Isabel', 'Moreno', 'isabel.moreno@email.com', '556677889', '45678901T', 28),
('Mario', 'Ruiz', 'mario.ruiz@email.com', '667788990', '56789012U', 40),
('Patricia', 'Torres', 'patricia.torres@email.com', '778899001', '67890123V', 32),
('Antonio', 'García', 'antonio.garcia@email.com', '889900112', '78901234W', 39),
('Fernando', 'Álvarez', 'fernando.alvarez@email.com', '990011223', '89012345X', 30),
('Sandra', 'Hernández', 'sandra.hernandez@email.com', '123123123', '90123456Y', 26),
('Rosa', 'Díaz', 'rosa.diaz@email.com', '234234234', '01234567Z', 35),

-- Admin
('Pepe', 'Dominguez', 'pepe.dominguez@email.com', '234294234', '01232597Z', 40);

INSERT INTO Vendedor (usuarioId, fechaContratacion, salario, numeroVentas)
VALUES 
(1, '2020-05-15', 2500.00, 50),
(2, '2021-03-10', 2300.00, 30),
(3, '2019-07-01', 2800.00, 75),
(4, '2022-06-25', 2200.00, 20),
(5, '2020-11-30', 2400.00, 45),
(6, '2023-06-01', 2600.00, 55),
(7, '2022-09-15', 2500.00, 40),
(8, '2021-11-20', 2300.00, 35),
(9, '2020-04-12', 2700.00, 65),
(10, '2023-01-25', 2200.00, 30);


INSERT INTO Cliente (usuarioId, direccion, fechaRegistro, tipoCliente)
VALUES 
(11, 'Calle Falsa 123, Madrid', '2024-01-15', 'Persona'),
(12, 'Avenida Siempre Viva 456, Sevilla', '2024-02-10', 'Empresa'),
(13, 'Calle de la Luna 789, Valencia', '2024-03-22', 'Persona'),
(14, 'Calle del Sol 321, Barcelona', '2024-04-11', 'Persona'), 
(15, 'Paseo de la Reforma 654, Bilbao', '2024-05-03', 'Empresa'),
(16, 'Calle Mayor 123, Zaragoza', '2024-06-01', 'Persona'),
(17, 'Avenida de la Paz 456, Málaga', '2024-07-12', 'Empresa'),
(18, 'Calle del Mar 789, Valencia', '2024-08-20', 'Persona'),
(19, 'Calle de la Libertad 321, Salamanca', '2024-09-15', 'Persona'),
(20, 'Calle del Sol 654, Madrid', '2024-10-10', 'Empresa'),
(21, 'Calle del Río 987, Sevilla', '2024-11-01', 'Persona'),
(22, 'Avenida de los Álamos 123, Alicante', '2024-12-05', 'Persona'),
(23, 'Calle de la Luna 456, Cádiz', '2024-01-15', 'Empresa'),
(24, 'Calle de las Flores 321, Valencia', '2024-02-20', 'Persona'),
(25, 'Paseo del Mar 654, Bilbao', '2024-03-10', 'Empresa');

INSERT INTO Administrador (usuarioId)
VALUES (26); 


INSERT INTO Vehiculo (vendedorId, matricula, marca, modelo, tipoCombustible, añoFabricacion, color, precio, tipoTransmision)
VALUES 
(1, '1122AAA', 'Audi', 'A3', 'Gasolina', 2020, 'Rojo', 22000.00, 'Automático'),
(2, '2233BBB', 'BMW', 'Serie 3', 'Diésel', 2019, 'Blanco', 30000.00, 'Manual'),
(3, '3344CCC', 'Mercedes', 'Clase E', 'Híbrido', 2021, 'Negro', 40000.00, 'Automático'),
(4, '4455DDD', 'Seat', 'Ibiza', 'Gasolina', 2022, 'Azul', 18000.00, 'Manual'),
(5, '5566EEE', 'Volkswagen', 'Passat', 'Gasolina', 2020, 'Plata', 23000.00, 'Automático'),
(6, '6677FFF', 'Toyota', 'Yaris', 'Eléctrico', 2023, 'Blanco', 25000.00, 'Manual'),
(7, '7788GGG', 'Audi', 'Q5', 'Gasolina', 2021, 'Verde', 35000.00, 'Automático'),
(8, '8899HHH', 'BMW', 'X6', 'Diésel', 2020, 'Gris', 60000.00, 'Manual'),
(9, '9900III', 'Mercedes', 'Clase A', 'Gasolina', 2022, 'Rojo', 28000.00, 'Automático'),
(10, '1011JJJ', 'Seat', 'León', 'Híbrido', 2023, 'Negro', 27000.00, 'Manual'),
(1, '1122KKK', 'Volkswagen', 'Tiguan', 'Diésel', 2019, 'Azul', 29000.00, 'Automático'),
(2, '2233BBC', 'BMW', 'Serie 3', 'Diésel', 2019, 'Blanco', 30000.00, 'Manual'),
(3, '3344MMM', 'Audi', 'Q7', 'Híbrido', 2020, 'Rojo', 45000.00, 'Automático'),
(4, '4455NNN', 'BMW', 'Serie 5', 'Gasolina', 2022, 'Plata', 47000.00, 'Manual'),
(5, '5566OOO', 'Mercedes', 'Clase S', 'Eléctrico', 2023, 'Negro', 80000.00, 'Automático'),
(6, '6677PPP', 'Seat', 'Arona', 'Gasolina', 2021, 'Azul', 21000.00, 'Manual'),
(7, '7788QQQ', 'Volkswagen', 'Golf', 'Gasolina', 2022, 'Blanco', 24000.00, 'Automático'),
(8, '8899RRR', 'Toyota', 'Land Cruiser', 'Diésel', 2020, 'Verde', 45000.00, 'Manual'),
(9, '9900SSS', 'Audi', 'A4', 'Gasolina', 2021, 'Plata', 28000.00, 'Automático'),
(10, '1011TTT', 'BMW', 'X1', 'Eléctrico', 2023, 'Rojo', 42000.00, 'Manual'),
(1, '1122UUU', 'Mercedes', 'GLC', 'Diésel', 2021, 'Gris', 55000.00, 'Automático'),
(2, '2233VVV', 'Seat', 'Toledo', 'Gasolina', 2020, 'Blanco', 19000.00, 'Manual'),
(3, '3344WWW', 'Volkswagen', 'Arteon', 'Híbrido', 2022, 'Negro', 35000.00, 'Automático'),
(4, '4455XXX', 'Toyota', 'Hilux', 'Diésel', 2021, 'Azul', 37000.00, 'Manual'),
(5, '5566YYY', 'Audi', 'TT', 'Gasolina', 2022, 'Rojo', 34000.00, 'Automático'),
(6, '6677ZZZ', 'BMW', 'Serie 7', 'Híbrido', 2020, 'Blanco', 80000.00, 'Manual'),
(7, '7788AAA', 'Mercedes', 'EQA', 'Eléctrico', 2023, 'Plata', 50000.00, 'Automático'),
(8, '8899BBB', 'Seat', 'Mii', 'Gasolina', 2020, 'Negro', 15000.00, 'Manual'),
(9, '9900CCC', 'Volkswagen', 'Sharan', 'Gasolina', 2021, 'Verde', 32000.00, 'Automático'),
(10, '1011DDD', 'Toyota', 'RAV4', 'Híbrido', 2022, 'Azul', 35000.00, 'Manual');



-- ERRORES PARA CADA TRIGGER 
/*
-- t_año_vehículo: 
INSERT INTO Vehiculo (vendedorId, matricula, marca, modelo, tipoCombustible, añoFabricacion, color, precio, tipoTransmision)
VALUES (1, '7890DEF', 'Ford', 'T', 'Gasolina', 1880, 'Negro', 10000.00, 'Manual');


-- t_matricula_inválida: (7 dígitos)
INSERT INTO Vehiculo (vendedorId, matricula, marca, modelo, tipoCombustible, añoFabricacion, color, precio, tipoTransmision)
VALUES (2, '12345', 'Toyota', 'Corolla', 'Gasolina', 2020, 'Rojo', 15000.00, 'Automático');

-- t_fecha_creacion_inválida: (3 dias máximo)
INSERT INTO Reserva (clienteId, vehiculoId, fechaCreacion, fechaReserva, fechaExpiracion)
VALUES (1, 2, '2025-01-01', '2025-01-05', '2025-01-10');


-- t_reserva_duplicada:
INSERT INTO Reserva (clienteId, vehiculoId, fechaCreacion, fechaReserva, fechaExpiracion)
VALUES (2, 1, '2024-12-16', '2024-12-17', '2024-12-26'); 


-- t_validar_fechas_reserva:
INSERT INTO Reserva (clienteId, vehiculoId, fechaCreacion, fechaReserva, fechaExpiracion)
VALUES (3, 2, '2024-12-10', '2024-12-09', '2024-12-15');

-- La fecha de expiracion debe de ser posterior a la fecha de reserva
INSERT INTO Reserva (clienteId, vehiculoId, fechaCreacion, fechaReserva, fechaExpiracion)
VALUES (5, 3, '2024-12-10', '2024-12-11', '2024-12-10');


-- ActualizarNumeroVentas:
INSERT INTO Factura (reservaId, vehiculoId, numeroFactura, fechaFactura, importeTotal)
VALUES (1, 1, 'F202412050003', '2024-12-05', 15000.00);


-- t_primer_pago:
INSERT INTO Pago (facturaId, importe, fechaPago, metodoPago)
VALUES (1, 2000.00, '2024-12-15', 'Transferencia');



*/
