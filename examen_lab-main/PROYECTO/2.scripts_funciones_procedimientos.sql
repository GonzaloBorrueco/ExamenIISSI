USE Concesionario;

-- PROCEDURE CREAR UNA RESERVA

DELIMITER //

CREATE OR REPLACE PROCEDURE CrearReserva(p_clienteId INT,p_vehiculoId INT, p_fechaReserva DATE)
BEGIN
   DECLARE v_fechaExpiracion DATE;

-- Verificar que el cliente exista
   IF NOT EXISTS (SELECT 1 FROM Cliente WHERE clienteId = p_clienteId) THEN
      SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'ERROR: El cliente especificado no existe';
   END IF;

-- Verificar que el vehículo exista
   IF NOT EXISTS (SELECT 1 FROM Vehiculo WHERE vehiculoId = p_vehiculoId) THEN
      SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'ERROR: El vehículo especificado no existe';
   END IF;

-- Verificar que el vehículo no esté reservado en el rango de fechas
   IF EXISTS (SELECT 1 FROM Reserva
      WHERE vehiculoId = p_vehiculoId AND fechaExpiracion >= CURRENT_DATE) THEN
      SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'ERROR: El vehículo ya está reservado';
   END IF;

-- Validar fecha reserva
   IF p_fechaReserva > DATE_ADD(CURRENT_DATE, INTERVAL 3 DAY) THEN
      SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'ERROR: Solo puedes reservar a 3 días vista';
   END IF;

-- Definir la fecha de expiración (10 días después de la fecha de reserva)
   SET v_fechaExpiracion = DATE_ADD(p_fechaReserva, INTERVAL 10 DAY);

-- Insertar la reserva en la tabla Reserva
   INSERT INTO Reserva (clienteId, vehiculoId, fechaCreacion, fechaReserva, fechaExpiracion)
   VALUES (p_clienteId, p_vehiculoId, CURDATE(), p_fechaReserva, v_fechaExpiracion);

END //

DELIMITER ;


CALL CrearReserva(1, 3,'2024-12-19');

CALL CrearReserva(2, 1, '2024-12-17');

CALL CrearReserva(3, 2, '2024-12-18');

CALL CrearReserva(4, 5, '2024-12-20');

CALL CrearReserva(5, 12, '2024-12-17');

-- CALL CrearReserva(2, 20,'24-12-30'); -- SOLO PUEDES RESERVAR A 3 DIAS VISTA COMO MÁXIMO
-- CALL CrearReserva(2, 3,'2024-12-19'); -- VEHICULO YA RESERVADO
-- CALL CrearReserva(2, 1232131,'24-12-16'); -- VEHICULO NO EXISTE
-- CALL CrearReserva(121312, 4,'24-12-16'); -- CLIENTE NO EXISTE



-- PROCEDURE MODIFICAR RESERVA

DELIMITER //

CREATE OR REPLACE PROCEDURE ModificarReserva(p_reservaId INT, p_nuevaFechaReserva DATE, p_nuevoVehiculoId INT)
BEGIN
   DECLARE v_fechaExpiracion DATE;
   DECLARE v_nuevoVehiculoId INT;
   
-- Fecha de modificación inválida

   IF p_nuevaFechaReserva < DATE_ADD(CURRENT_DATE,INTERVAL 1 DAY) OR p_nuevaFechaReserva > DATE_ADD(CURRENT_DATE, INTERVAL 3 DAY) THEN
      SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'ERROR: La fecha es inválida';
   END IF;
   
-- Mirar que la reserva exista

   IF NOT EXISTS (SELECT 1 FROM Reserva WHERE reservaId = p_reservaId) THEN
      SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'ERROR: La reserva especificada no existe';
   END IF;

-- Mirar el id del vehiculo que estaba reservado y guardarlo en la variable

   SELECT vehiculoId INTO v_nuevoVehiculoId 
   FROM Reserva 
   WHERE reservaId = p_reservaId;

-- Comprobar si la reserva ya ha expirado

   IF EXISTS (SELECT 1 FROM Reserva 
      WHERE reservaId = p_reservaId AND fechaExpiracion < CURRENT_DATE) THEN
      SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'ERROR: No se puede modificar una reserva expirada';
   END IF;

-- Verificar que el nuevo vehículo no esté reservado

   IF p_nuevoVehiculoId != v_nuevoVehiculoId THEN
      IF EXISTS (SELECT 1 FROM Reserva 
         WHERE vehiculoId = p_nuevoVehiculoId 
         AND fechaExpiracion >= p_nuevaFechaReserva) THEN
         SIGNAL SQLSTATE '45000'
         SET MESSAGE_TEXT = 'ERROR: El vehículo ya está reservado en las nuevas fechas especificadas';
      END IF;
   END IF;

   SET v_fechaExpiracion = DATE_ADD(p_nuevaFechaReserva, INTERVAL 10 DAY);

-- Actualizar la reserva con los nuevos valores

   UPDATE Reserva
   SET 
      fechaReserva = p_nuevaFechaReserva,
      fechaExpiracion = v_fechaExpiracion,
      vehiculoId = IFNULL(p_nuevoVehiculoId, vehiculoId)
   WHERE reservaId = p_reservaId;

END //

DELIMITER ;

CALL ModificarReserva(1,'2024-12-19',6);

-- CALL ModificarReserva(1,'2024-12-30',6); -- LA FECHA ES INVÁLIDA
-- CALL ModificarReserva(12323,'2024-12-19',6); -- LA RESERVA NO EXISTE
-- CALL ModificarReserva(1,'2034-12-17',6); -- FECHA DE RESERVA INVÁLIDA
-- CALL ModificarReserva(2,'2024-12-19',6); -- EL VEHICULO ESTÁ RESERVADO




-- PROCEDURE REGISTRAR FACTURA

DELIMITER //

CREATE OR REPLACE PROCEDURE RegistrarFactura(p_reservaId INT)
BEGIN
	DECLARE v_importe DECIMAL(10,2);
	DECLARE v_vehiculoId INT;
	DECLARE v_numero_factura VARCHAR(50);
	
	SELECT vehiculoId INTO v_vehiculoId
	FROM reserva
	WHERE reservaId=p_reservaId;
	
	SET v_numero_factura = CONCAT('FTurboDrive', CAST(p_reservaId AS char));
	
	SELECT precio INTO v_importe 
	FROM vehiculo
	WHERE vehiculoId= v_vehiculoId;
	
	INSERT INTO Factura(reservaId, vehiculoId, numeroFactura, fechaFactura, importeTotal) VALUES
	(p_reservaId, v_vehiculoId, v_numero_factura, CURRENT_DATE, v_importe);

END //

DELIMITER ;

CALL RegistrarFactura(1);
CALL RegistrarFactura(3);
CALL RegistrarFactura(4);
CALL RegistrarFactura(5);


-- PROCEDURE REGISTRAR EL PAGO

DELIMITER //

CREATE OR REPLACE PROCEDURE RegistrarPago(p_facturaId INT, p_importe DECIMAL(10, 2), p_fechaPago DATE, p_metodoPago ENUM('Tarjeta_Crédito', 'Tarjeta_Débito', 'Transferencia', 'Efectivo'))

BEGIN
   DECLARE v_importeTotal DECIMAL(10, 2);
   DECLARE v_totalPagado DECIMAL(10, 2);
   
   IF p_metodoPago ='Efectivo' and p_importe>5000 THEN
   	SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'ERROR: El pago en efectivo no puede superar los 5000';
   END IF;
   
   IF p_fechaPago != CURRENT_DATE THEN
      SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'ERROR: La fecha de pago no es válida';
   END IF;

   SELECT importeTotal INTO v_importeTotal
   FROM Factura
   WHERE facturaId = p_facturaId;
   
   IF v_importeTotal IS NULL THEN
      SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'ERROR: La factura especificada no existe';
   END IF;

   SELECT IFNULL(SUM(importe), 0) INTO v_totalPagado
   FROM Pago
   WHERE facturaId = p_facturaId;

   IF (v_totalPagado + p_importe) > v_importeTotal THEN
      SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'ERROR: El importe total de los pagos no puede exceder el importe total de la factura';
   END IF;


   INSERT INTO Pago (facturaId, importe, fechaPago, metodoPago)
   VALUES (p_facturaId, p_importe, p_fechaPago, p_metodoPago);

END //

DELIMITER ;


CALL RegistrarPago(1, 25000.00, CURRENT_DATE, 'Tarjeta_Crédito'); -- FACTURA 1 UN PAGO

CALL RegistrarPago(2, 3000.00, CURRENT_DATE, 'Efectivo');-- FACTURA 2 1/4 PAGOS

CALL RegistrarPago(2, 8200.00, CURRENT_DATE, 'Tarjeta_Crédito');-- FACTURA 2 2/4 PAGOS

CALL RegistrarPago(2, 7000.00, CURRENT_DATE, 'Tarjeta_Débito');-- FACTURA 2 3/4 PAGOS

CALL RegistrarPago(2, 11800.00, CURRENT_DATE, 'Tarjeta_Crédito');-- FACTURA 2 4/4 PAGOS

CALL RegistrarPago(3, 25300.00, CURRENT_DATE, 'Tarjeta_Débito');-- FACTURA 3 UN PAGO

CALL RegistrarPago(4, 3000.00, CURRENT_DATE, 'Efectivo');-- FACTURA 4 1/2 PAGOS

CALL RegistrarPago(4, 27000.00, CURRENT_DATE, 'Tarjeta_Débito');-- FACTURA 4 2/2 PAGOS


-- CALL RegistrarPago(2, 3000.00, CURRENT_DATE,'Efectivo'); -- PRIMER PAGO INVÁLIDO
-- CALL RegistrarPago(1, 5020.00, CURRENT_DATE,'Efectivo'); -- SUPERA EL IMPORTE MÁXIMO DE EFECTIVO
-- CALL RegistrarPago(1, 1000000.00,CURRENT_DATE, 'Tarjeta_Crédito'); -- EXCEDE EL PRECIO DE LA FACTURA
-- CALL RegistrarPago(12302, 10000.00, CURRENT_DATE, 'Tarjeta_Crédito'); -- FACTURA INEXISTENTE
-- CALL RegistrarPago(1, 10000.00, '2023-12-19', 'Tarjeta_Crédito'); -- FECHA DE PAGO INVÁLIDA




-- FUNCION DE VEHICULO RESERVADO

DELIMITER //
CREATE OR REPLACE FUNCTION EsVehiculoReservado(p_vehiculoId INT)
RETURNS VARCHAR(10) 
BEGIN
   DECLARE v_reservado INT;
   DECLARE mensaje VARCHAR(10);

-- Mira a ver si está dentro de una reserva por la fecha de expiración
   SELECT COUNT(*) > 0 INTO v_reservado
   FROM Reserva
   WHERE vehiculoId = p_vehiculoId
     AND fechaExpiracion >= CURDATE(); -- El vehiculo se libera un dia después de la fecha de expiración
   
   IF v_reservado = 1 THEN 
   SET mensaje= 'Reservado';
   ELSE SET mensaje = 'Libre';
   END IF;
   
   RETURN mensaje;
END //

DELIMITER ;

SELECT EsVehiculoReservado(vehiculoId) AS EstaReservado FROM vehiculo; 
SELECT EsVehiculoReservado(8) AS EstaReservado; -- Libre

-- FUNCION QUE COMPRUEBA QUE LA FACTURA ESTÉ PAGADA

DELIMITER //

CREATE OR REPLACE FUNCTION EsFacturaPagada(p_facturaId INT)
RETURNS BOOLEAN
BEGIN
   DECLARE v_importeTotal DECIMAL(10, 2);
   DECLARE v_totalPagado DECIMAL(10, 2);

   SELECT importeTotal INTO v_importeTotal
   FROM Factura
   WHERE facturaId = p_facturaId;

-- Suma los pagos realizados para esta factura
   SELECT SUM(importe) INTO v_totalPagado
   FROM Pago
   WHERE facturaId = p_facturaId;

-- Si el total pagado es mayor o igual al importe total, la factura está pagada
   RETURN v_totalPagado >= v_importeTotal;
END //

DELIMITER ;

SELECT facturaId, numeroFactura, importeTotal, EsFacturaPagada(facturaId) AS EstaPagada
FROM Factura;
