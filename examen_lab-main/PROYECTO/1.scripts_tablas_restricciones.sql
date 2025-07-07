DROP DATABASE IF EXISTS Concesionario;
CREATE DATABASE Concesionario;
USE Concesionario;
DROP TABLE IF EXISTS Usuario;
DROP TABLE IF EXISTS Administrador;
DROP TABLE IF EXISTS Vendedor;
DROP TABLE IF EXISTS Cliente;
DROP TABLE IF EXISTS Vehiculo;
DROP TABLE IF EXISTS Reserva;
DROP TABLE IF EXISTS Factura;
DROP TABLE IF EXISTS Pago;

CREATE OR REPLACE TABLE Usuario (
   usuarioId INT PRIMARY KEY AUTO_INCREMENT,
   nombre VARCHAR(100) NOT NULL,
   apellido VARCHAR(100),
   email VARCHAR(255) UNIQUE NOT NULL,
   telefono VARCHAR(15),
   dni VARCHAR(20) UNIQUE NOT NULL,
   edad INT CHECK (edad >= 14)
);


CREATE OR REPLACE TABLE Administrador (
   adminId INT PRIMARY KEY AUTO_INCREMENT,
   usuarioId INT NOT NULL,
   FOREIGN KEY (usuarioId) REFERENCES Usuario(usuarioId)
);


CREATE OR REPLACE TABLE Vendedor (
   vendedorId INT PRIMARY KEY AUTO_INCREMENT,
   usuarioId INT NOT NULL,
	fechaContratacion DATE NOT NULL,
   salario DECIMAL(10, 2) CHECK (salario > 0),
   numeroVentas INT CHECK (numeroVentas >= 0),
   FOREIGN KEY (usuarioId) REFERENCES Usuario(usuarioId)
);


CREATE OR REPLACE TABLE Cliente (
   clienteId INT PRIMARY KEY AUTO_INCREMENT,
   usuarioId INT NOT NULL,
   direccion VARCHAR(255) NOT NULL,
   fechaRegistro DATE NOT NULL DEFAULT CURRENT_DATE,
   tipoCliente ENUM('Persona', 'Empresa') NOT NULL,
   FOREIGN KEY (usuarioId) REFERENCES Usuario(usuarioId)
);


CREATE OR REPLACE TABLE Vehiculo (
   vehiculoId INT PRIMARY KEY AUTO_INCREMENT,
   vendedorId INT NOT NULL,
   matricula VARCHAR(7) NOT NULL UNIQUE, 
   marca VARCHAR(50) NOT NULL,
   modelo VARCHAR(50) NOT NULL,
   tipoCombustible ENUM('Gasolina', 'Diésel', 'Híbrido', 'Eléctrico') NOT NULL,
   añoFabricacion YEAR NOT NULL,
   color VARCHAR(30) NOT NULL,
   precio DECIMAL(10, 2) NOT NULL CHECK(precio>0),
   tipoTransmision ENUM('Manual', 'Automático') NOT NULL,
   FOREIGN KEY (vendedorId) REFERENCES vendedor(vendedorId)  
);


CREATE OR REPLACE TABLE Reserva (
   reservaId INT PRIMARY KEY AUTO_INCREMENT,
   clienteId INT NOT NULL,
   vehiculoId INT NOT NULL,
   fechaCreacion DATE NOT NULL DEFAULT CURRENT_DATE,
   fechaReserva DATE NOT NULL,
   fechaExpiracion DATE DEFAULT NULL,
   FOREIGN KEY (clienteId) REFERENCES Cliente(clienteId),
   FOREIGN KEY (vehiculoId) REFERENCES Vehiculo(vehiculoId)
);


CREATE OR REPLACE TABLE Factura (
   facturaId INT PRIMARY KEY AUTO_INCREMENT,
   reservaId INT NOT NULL,
   vehiculoId INT NOT NULL,
   numeroFactura VARCHAR(20) UNIQUE NOT NULL,
   fechaFactura DATE NOT NULL DEFAULT CURRENT_DATE,
   importeTotal DECIMAL(10, 2),
   FOREIGN KEY (vehiculoId) REFERENCES Vehiculo(vehiculoId),
   FOREIGN KEY (reservaId) REFERENCES Reserva(reservaId)
);


CREATE OR REPLACE TABLE Pago (	
   pagoId INT PRIMARY KEY AUTO_INCREMENT,
   facturaId INT NOT NULL,
   importe DECIMAL(10, 2) CHECK (importe > 0),
   fechaPago DATE NOT NULL,
   metodoPago ENUM('Tarjeta_Crédito', 'Tarjeta_Débito', 'Transferencia', 'Efectivo') NOT NULL,
   FOREIGN KEY (facturaId) REFERENCES Factura(facturaId)
);
