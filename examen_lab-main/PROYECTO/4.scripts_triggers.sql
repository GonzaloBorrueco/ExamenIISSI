USE Concesionario;

-- TRIGGER QUE COMPRUEBA QUE EL AÑO DE FABRICACIÓN DEL VEHÍCULO SEA VÁLIDO

DELIMITER //

CREATE OR REPLACE TRIGGER t_año_vehiculo_valido
BEFORE INSERT ON Vehiculo
FOR EACH ROW
BEGIN
   IF NEW.añoFabricacion <= 1886 OR NEW.añoFabricacion >= YEAR(CURDATE()) THEN
   	SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'ERROR: El año de fabricación debe ser válido';
   END IF;
END;
//

DELIMITER ;

-- TRIGGER QUE COMPRUEBA QUE LA MATRICULA TENGA ÚNICAMENTE 7 DÍGITOS

DELIMITER //

CREATE OR REPLACE TRIGGER t_matricula_valida
BEFORE INSERT ON Vehiculo
FOR EACH ROW
BEGIN
    IF CHAR_LENGTH(NEW.matricula) != 7 THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'ERROR: La matrícula debe tener exactamente 7 caracteres.';
    END IF;
END;//

DELIMITER ;

-- TRIGGER QUE COMPRUEBA QUE LA FECHA DE CREACIÓN SEA VÁLIDA

DELIMITER //

CREATE OR REPLACE TRIGGER t_fecha_creacion_valida
BEFORE INSERT ON Reserva
FOR EACH ROW
BEGIN
   IF NEW.fechaCreacion > CURDATE() THEN
      SIGNAL SQLSTATE '45000' 
      SET MESSAGE_TEXT = 'ERROR: La fecha de la creacion de la reserva no puede ser futura';
   END IF;
END;
//

DELIMITER ;

-- TRIGGER QUE APLICA AUMENTO DEL 10% EN EL PRECIO DE LOS VEHÍCULOS AUTOMÁTICOS

DELIMITER //

CREATE TRIGGER t_aumento_de_automáticos
BEFORE INSERT ON Vehiculo
FOR EACH ROW
BEGIN
   IF NEW.tipoTransmision = 'Automático' THEN
      SET NEW.precio = NEW.precio * 1.10;
   END IF;
END //

DELIMITER ;

-- TRIGGER QUE COMPRUEBA QUE UN CLIENTE NO TIENE RESERVAS DUPLICADAS

DELIMITER //

CREATE OR REPLACE TRIGGER t_reserva_duplicada
BEFORE INSERT ON Reserva
FOR EACH ROW
BEGIN
   DECLARE reservaExistente INT;
   
   SELECT COUNT(*) INTO reservaExistente FROM Reserva
   WHERE clienteId = NEW.clienteId AND vehiculoId = NEW.vehiculoId;
   
   IF reservaExistente > 0 THEN
      SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'ERROR: Hay reservas duplicadas, un cliente no puede reservar el mismo vehículo 2 veces.';
   END IF;
   
END //

DELIMITER ;

-- TRIGGER QUE COMPRUEBA FECHAS EN RELACIÓN A LA RESERVA

DELIMITER //

CREATE OR REPLACE TRIGGER t_validar_fechas_reserva
BEFORE INSERT ON Reserva
FOR EACH ROW
BEGIN
   IF NEW.fechaReserva < NEW.fechaCreacion THEN
      SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'La fecha de reserva no puede ser anterior a la fecha de creación.';
   END IF;

   IF NEW.fechaExpiracion < NEW.fechaReserva THEN
      SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'La fecha de expiración debe ser posterior a la fecha de reserva.';
   END IF;
END //

DELIMITER ;

-- TRIGGER QUE ELIMINA LAS RESERVAS QUE HAN EXPIRADO

DELIMITER //

CREATE OR REPLACE TRIGGER t_cancelar_reserva
AFTER UPDATE ON Reserva
FOR EACH ROW
BEGIN
   -- Comprobar si la fecha actual supera la fecha de expiración
   IF old.fechaExpiracion < CURRENT_DATE THEN
      DELETE FROM Reserva WHERE reservaId = OLD.reservaId;
   END IF;
END //

DELIMITER ;

-- TRIGGER QUE COMPRUEBA QUE EL PRIMER PAGO SEA DEL 10% DEL PRECIO 

DELIMITER //

CREATE TRIGGER t_primer_pago
BEFORE INSERT ON Pago
FOR EACH ROW
BEGIN
   DECLARE v_precioVehiculo DECIMAL(10, 2);
   DECLARE v_pagosPrevios INT;

-- Conocer el precio del vehículo
   SELECT precio INTO v_precioVehiculo
   FROM Vehiculo
   WHERE vehiculoId = (SELECT vehiculoId FROM Factura WHERE facturaId = NEW.facturaId);

-- Contar numero de pagos que han habido
   SELECT COUNT(*) INTO v_pagosPrevios
   FROM Pago
   WHERE facturaId = NEW.facturaId;

-- Comprobación del primer pago
   IF v_pagosPrevios = 0 THEN
      IF NEW.importe != (v_precioVehiculo * 0.10) AND NEW.importe != v_precioVehiculo THEN
         SIGNAL SQLSTATE '45000'
         SET MESSAGE_TEXT = 'ERROR: El primer pago a plazos debe ser exactamente el 10% del precio del vehículo';
      END IF;
   END IF;
END;
//

DELIMITER ;

-- TRIGGER QUE ACTUALIZA EL NUMERO DE VENTAS QUE HA HECHO CADA VENDEDOR

DELIMITER //

CREATE TRIGGER t_actualizar_numeroVentas
AFTER INSERT ON Factura
FOR EACH ROW
BEGIN
   DECLARE v_vendedorId INT;

-- Incrementar el número de ventas del vendedor
   UPDATE Vendedor
   SET numeroVentas = numeroVentas + 1
   WHERE vendedorId = v_vendedorId;
END //

DELIMITER ;
