-- Esta documentación ha sido propuesta por PABLO BUZA MIRA.

-- RENOVACIÓN Y USO DE TABLAS Y BASES DE DATOS:
CREATE DATABASE IF NOT EXISTS tipoAtracciones;
USE tipoAtracciones;

DROP TABLE IF EXISTS viajes;
DROP TABLE IF EXISTS atracciones;

-- CREACIÓN DE TABLAS
CREATE TABLE atracciones(
atraccionId mediumint AUTO_INCREMENT PRIMARY KEY,
nombre VARCHAR(50) UNIQUE, 
capacidadMaxima INT NOT NULL,
zona VARCHAR(30), 
estaturaMin INT NOT NULL,
CONSTRAINT zonasParque CHECK (zona IN ('Tanzania', 'Plateado','Katmandu','Cascada','Orilla','Carbonera'))
);

-- POBLACIÓN
INSERT INTO atracciones (nombre,capacidadMaxima,zona,estaturaMin)
VALUES
('Anaconda',85,'Plateado',145),
('Caida Libre',85,'Katmandu',150),
('Rapidos del Orinoco',34,'Tanzania',100),
('Latigo',65,'Katmandu',100),
('Nepal',65,'Katmandu',100),
('Lluvia',25,'Cascada',100),
('Copos',36,'Cascada',100),
('La noche',42,'Katmandu',100),
('Embarcadero',16,'Katmandu',120)
;


-- EJERCICIO 0: Prueba de eficiencia.
SELECT COUNT(*) FROM atracciones;

/*
-- EJERCICIO 1: Se requiere añadir el requisito de información Viajes de las atracciones.  
De cada viaje habrá que almacenar la atracción en cuestión, la fecha y hora del viaje, el número de personas que participan en el viaje, 
el número de personas que acceden con bono exprés en cada viaje. Hay que tener en cuenta las siguientes restricciones:
	-	La atracción debe existir en la tabla de atracciones.
	-	La fecha y hora no puede ser nula.
	-	En cada viaje, el número máximo de personas que pueden acceder con bono exprés es 5.
*/

CREATE or replace TABLE viajes(
viajeId INT AUTO_INCREMENT PRIMARY KEY,
fechahoraviaje DATETIME NOT NULL,
numPersonas INT,
numPersonasBono INT NOT NULL,
atraccionId MEDIUMINT,
FOREIGN KEY (atraccionId) REFERENCES atracciones(atraccionId),
CONSTRAINT maximoBonoExpres CHECK (numPersonasBono<=5)
);

/*
-- EJERCICIO 2: Cree y ejecute un procedimiento almacenado llamado creaViajes() que inserte cuatro viajes: 
uno en Anaconda, otro en Caída Libre y dos viajes en el Látigo, durante el día 24 de diciembre de 2021.
*/

DELIMITER //
CREATE OR REPLACE PROCEDURE creaViajes(atraccionId MEDIUMINT, fechahoraviaje DATETIME)
BEGIN
	INSERT INTO viajes VALUES
	(NULL, fechahoraviaje, 22, 4, atraccionId);
END //
DELIMITER ;
CALL creaViajes(1, '2021-12-24 12:00:00');
CALL creaViajes(2, '2021-12-24 12:00:00');
CALL creaViajes(4, '2021-12-24 12:00:00');
CALL creaViajes(4, '2021-12-24 12:00:00');

/*
-- EJERCICIO 3: Cree una consulta que devuelva el número de viajes que ha dado cada atracción.
*/

SELECT nombre, COUNT(atraccionId)
FROM atracciones NATURAL JOIN viajes
GROUP BY nombre;

/*
-- EJERCICIO 4: Cree una consulta que devuelva el número de atracciones que hay en cada zona del parque.
*/

SELECT zona, COUNT(*)
FROM atracciones
GROUP BY zona;

-- EJERCICIO 5: Implemente la restricción que impida que durante un viaje se supere la capacidad de una atracción determinada.
/*
CÓDIGO
*/

DELIMITER //
CREATE OR REPLACE TRIGGER noSuperarCapacidad
BEFORE INSERT ON viajes FOR EACH ROW
BEGIN
	DECLARE maxCapacidadAtraccion INT;
	SET maxCapacidadAtraccion = (SELECT a.capacidadMaxima FROM atracciones a WHERE a.atraccionId = NEW.atraccionId);
	IF (NEW.numPersonas > maxCapacidadAtraccion) THEN
	SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'En un viaje no se puede superar la capacidad máxima de una atracción';
	END IF;
END //
DELIMITER ;
-- INSERT INTO viajes VALUES (NULL,'2022-06-18 16:32:45', 100, 4, 7);


/*
-- EJERCICIO 6: Implemente una consulta que muestre el nombre de aquellas atracciones en las que no se haya montado ningún 
viajero, por orden alfabético (normal). Nótese: solamente debe devolver 4 resultados entre todos los que puedan obtener, 
y el primer resultado que cumpla con la condición no debe mostrarse.
*/

SELECT nombre
FROM atracciones A
WHERE NOT EXISTS 
(SELECT * FROM viajes V 
WHERE A.atraccionId = V.atraccionId)
ORDER BY nombre ASC LIMIT 4 OFFSET 1;


/*
-- EJERCICIO 7: Implemente un disparador que no permita que se supere la cifra de 30 bonos exprés 
en un día entre tantas atracciones como existan.
*/

DELIMITER //
CREATE OR REPLACE TRIGGER tNoSuperarCapacidadBonos
BEFORE INSERT ON viajes FOR EACH ROW
BEGIN
	DECLARE fecha DATE;
	DECLARE sumaAntes INT;
	DECLARE sumaFinal INT;
	SET fecha = DATE(NEW.fechahoraviaje);
	SELECT SUM(numPersonasBono) INTO sumaAntes FROM viajes WHERE ((atraccionId=NEW.atraccionId) AND (DATE(fechahoraviaje)=fecha));
	SET sumaFinal = sumaAntes + NEW.numPersonasBono;
	IF (sumaFinal>30) THEN
	SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No se pueden superar 30 bonos exprés en una atracción en un mismo día';
	END IF;
END //
DELIMITER ;
/*
-- TEST DE PRUEBA (recuerde: se implantó una restricción que impedía que el número de Bonos Exprés fuera mayor a 5).
INSERT INTO viajes VALUES (NULL, '2021-12-24 19:00:00', 20, 5, 4);
INSERT INTO viajes VALUES (NULL, '2021-12-24 19:15:00', 15, 5, 4);
INSERT INTO viajes VALUES (NULL, '2021-12-24 19:30:00', 20, 5, 4);
INSERT INTO viajes VALUES (NULL, '2021-12-24 19:45:00', 25, 5, 4);
INSERT INTO viajes VALUES (NULL, '2021-12-24 19:59:00', 15, 5, 4);
*/

/*
-- EJERCICIO 8: Implemente una función fPersonaAtraccionIntervaloFecha() que permita responder a la siguiente pregunta: 
¿Cuántas personas se han montado en la atracción “Látigo” entre el 24 de diciembre de 2021 a las 10 de la mañana y el 
25 de diciembre de 2021 a las 2 de la madrugada? Haga uso de los parámetros.
*/

DELIMITER //
CREATE OR REPLACE FUNCTION fPersonaAtraccionIntervaloFecha(n VARCHAR(50), fI DATETIME, fF DATETIME) 
RETURNS INT
BEGIN
	DECLARE resultado INT;
	SET resultado = (SELECT COUNT(V.numPersonas) FROM atracciones A JOIN viajes V ON A.atraccionId = V.atraccionId WHERE A.nombre = n AND V.fechahoraviaje BETWEEN fI AND fF);
	RETURN resultado;
END //
DELIMITER ;

SELECT fPersonaAtraccionIntervaloFecha('Látigo', '2021-12-24 10:00:00', '2021-12-25 02:00:00');
	
