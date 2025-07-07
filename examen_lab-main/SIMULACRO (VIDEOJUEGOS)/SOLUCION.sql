DROP DATABASE IF EXISTS Videojuegos;
CREATE DATABASE Videojuegos ;
USE Videojuegos;

DROP TABLE if EXISTS  Valoraciones;
DROP TABLE if EXISTS  Jugadores;
DROP TABLE if EXISTS  Videojuegos;


CREATE TABLE Videojuegos(
	videojuegoId INT AUTO_INCREMENT NOT NULL PRIMARY KEY,
	nombre VARCHAR(80) NOT NULL,
	fechaLanzamiento DATE,
	logros INT,
	estado ENUM('Lanzado', 'Beta', 'Acceso anticipado'),
	precioLanzamiento DOUBLE
);

CREATE TABLE Jugadores(
	jugadorId INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
	nickname VARCHAR(60) NOT NULL
);

INSERT INTO Videojuegos(nombre, fechaLanzamiento,logros, estado,precioLanzamiento) VALUES ('The Legend of Zelda: Breath of the Wild', '2017-03-03', 76, 'Lanzado', 69.99);
INSERT INTO Videojuegos(nombre, fechaLanzamiento,logros, estado,precioLanzamiento) VALUES ('The Legend of Zelda: Tears of the Kingdom', '2023-05-12', 139, 'Lanzado', 79.99);
INSERT INTO Videojuegos(nombre, fechaLanzamiento,logros, estado,precioLanzamiento) VALUES ('Maniac Mansion', '1987-01-01', 1, 'Lanzado', 49.98);
INSERT INTO Videojuegos(nombre, fechaLanzamiento,logros, estado,precioLanzamiento) VALUES ('Horizon: Zero Dawn', '2017-02-28', 31, 'Lanzado', 79.99);
INSERT INTO Videojuegos(nombre, fechaLanzamiento,logros, estado,precioLanzamiento) VALUES ('Super Metroid', '1994-04-28', 1, 'Lanzado', 69.99);
INSERT INTO Videojuegos(nombre, fechaLanzamiento,logros, estado,precioLanzamiento) VALUES ('Final Fantasy IX', '2001-02-16', 9, 'Lanzado', 69.99);
INSERT INTO Videojuegos(nombre, fechaLanzamiento,logros, estado,precioLanzamiento) VALUES ('Pokemon Rojo', '1999-11-01', 151, 'Lanzado', 49.98);
INSERT INTO Videojuegos(nombre, fechaLanzamiento,logros, estado,precioLanzamiento) VALUES ('Pokemon Amarillo', '2000-06-16', 155, 'Lanzado', 49.98);
INSERT INTO Videojuegos(nombre, fechaLanzamiento,logros, estado,precioLanzamiento) VALUES ('Pokemon Beige Clarito', '2023-12-15', 3, 'Beta', 2000000);


INSERT INTO Jugadores(nickname) VALUES ('Currito92');
INSERT INTO Jugadores(nickname) VALUES ('MariTrini67');
INSERT INTO Jugadores(nickname) VALUES ('IISSI_USER');
INSERT INTO Jugadores(nickname) VALUES ('Samus');
INSERT INTO Jugadores(nickname) VALUES ('Aran');


CREATE TABLE Valoraciones (
	valoracionId INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
	jugadorId INT NOT NULL,
	videojuegoId INT NOT NULL,
	puntuacion DECIMAL(2,1) NOT NULL CHECK (puntuacion BETWEEN 0 AND 5),
	opinion VARCHAR(100) NOT NULL,
	likes INT DEFAULT(0),
	veredicto ENUM('Imprescindible','Recomendado','Comprar en rebajas','No merece la pena') NOT NULL,
	fechaValoracion DATE NOT NULL,
	FOREIGN KEY (jugadorId) REFERENCES Jugadores(jugadorId),
	FOREIGN KEY (videojuegoId) REFERENCES Videojuegos(videojuegoId),
	UNIQUE(jugadorId,videojuegoId)
);


/*

				AQUI SE HACEN LOS INSERT DE LAS RESTRCCIONES MAS ABAJO ESTA CON EL PROCEDURE
				
    • usuario 1 en el juego 2, puntuación = 5, un comentario de texto cualquiera, y veredicto ‘Imprescindible’, fecha de hoy.
    • usuario 2 en el juego 4, puntuación = 3, un comentario de texto cualquiera, y estado ‘Comprar en rebajas’, fecha de hoy.
    • usuario 3 en el juego 3, puntuación = 4, un comentario de texto cualquiera, y estado ‘Recomendado’, fecha de hoy.
    • usuario 4 en el juego 5, puntuación = 1, un comentario de texto cualquiera, y estado ‘No merece la pena’, fecha de hoy.
    • usuario 2 en el juego 3, puntuación = 4.5, un comentario de texto cualquiera, y estado ‘Imprescindible’, fecha de hoy.

    • usuario 1 en el juego 6, puntuación = 10, un comentario de texto cualquiera, y estado ‘Imprescindible’. (RN-1-01)
    • usuario 3 en el juego 1, puntuación = 3, un comentario de texto cualquiera, y estado ‘Ni fu ni fa’. (RN-1-02)
    • usuario 3 en el juego 3, puntuación = 2, comentario ‘No era para tanto’, y estado ‘No merece la pena’. (RN-1-03)
    • usuario 6 en el juego 8, puntuación = 3, un comentario de texto cualquiera, y estado ‘Comprar en rebajas’. (referencia no existente)


INSERT INTO valoraciones (jugadorId,videojuegoId,puntuacion,opinion,veredicto,fechaValoracion)
VALUES (1,2,5,'cualquiera','Imprescindible',CURDATE());

INSERT INTO valoraciones (jugadorId,videojuegoId,puntuacion,opinion,veredicto,fechaValoracion)
VALUES (2,4,3,'cualquiera','Comprar en rebajas',CURDATE());

INSERT INTO valoraciones (jugadorId,videojuegoId,puntuacion,opinion,veredicto,fechaValoracion)
VALUES (3,3,4,'cualquiera','Recomendado',CURDATE());

INSERT INTO valoraciones (jugadorId,videojuegoId,puntuacion,opinion,veredicto,fechaValoracion)
VALUES (4,5,1,'cualquiera','No merece la pena',CURDATE());

INSERT INTO valoraciones (jugadorId,videojuegoId,puntuacion,opinion,veredicto,fechaValoracion)
VALUES (2,3,4.5,'cualquiera','Imprescindible',CURDATE());

-- --------AHORA LAS MALAS------------------------
-- EXCESO DE VALORACION
INSERT INTO valoraciones (jugadorId,videojuegoId,puntuacion,opinion,veredicto,fechaValoracion)
VALUES (1,2,10,'cualquiera','Imprescindible',CURDATE());

-- VEREDICTO INCORRECTO
INSERT INTO valoraciones (jugadorId,videojuegoId,puntuacion,opinion,veredicto,fechaValoracion)
VALUES (1,2,5,'‘No era para tanto’','NI FU NI FA',CURDATE());

-- YA SE HABIA PUESTO ESTE USUARIO
INSERT INTO valoraciones (jugadorId,videojuegoId,puntuacion,opinion,veredicto,fechaValoracion)
VALUES (1,2,5,'cualquiera','Imprescindible',CURDATE());


-- REFERENCIA INEXISTENTE

INSERT INTO valoraciones (jugadorId,videojuegoId,puntuacion,opinion,veredicto,fechaValoracion)
VALUES (6,8,5,'cualquiera','Imprescindible',CURDATE());


*/

/*
Codifique un procedimiento almacenado que inserte una nueva valoración de un usuario concreto para un 
juego dado en la tabla creada en el ejercicio anterior, que será llamado tantas veces como progresos
se deseen añadir.
Para comprobar las RN y las restricciones de Integridad, se llamará al procedimiento con los parámetros que
 aparecen en Prueba1-Inserción de valoración de juegos. Las valoraciones en verde se insertarán y
 las marcadas en rojo serán rechazadas.*/

DELIMITER //

CREATE OR REPLACE PROCEDURE p_insercionUsuario (
jid INT, 
vid INT,
punt DECIMAL(2,1),
op VARCHAR(100),
vere ENUM('Imprescindible','Recomendado','Comprar en rebajas','No merece la pena'),
fecha DATE)
BEGIN 

	INSERT INTO valoraciones (jugadorId,videojuegoId,puntuacion,opinion,veredicto,fechaValoracion) values
	(jid,vid,punt,op,vere,fecha);

END //

DELIMITER ;


CALL p_insercionUsuario(1,2,5,'cualquiera','Imprescindible',CURDATE());
CALL p_insercionUsuario(2,4,3,'cualquiera','Comprar en rebajas',CURDATE());
CALL p_insercionUsuario(3,3,4,'cualquiera','Recomendado',CURDATE());
CALL p_insercionUsuario(4,5,1,'cualquiera','No merece la pena',CURDATE());
CALL p_insercionUsuario(2,3,4.5,'cualquiera','Imprescindible',CURDATE());

/*
-- AHORA LAS MALAS

-- EXCESO DE VALORACION
CALL p_insercionUsuario(1,2,10,'cualquiera','Imprescindible',CURDATE());

-- VEREDICTO INCORRECTO
CALL p_insercionUsuario(1,2,5,'cualquiera','ni fu ni fa',CURDATE());

-- YA SE HABIA PUESTO ESTE USUARIO
CALL p_insercionUsuario(3,3,5,'cualquiera','Imprescindible',CURDATE());

-- REFERENCIA INEXISTENTE
CALL p_insercionUsuario(6,8,5,'cualquiera','Imprescindible',CURDATE());
*/



/*
Cree una consulta que devuelva todos los usuarios, sus juegos y las valoraciones respectivas,
 ordenados por videojuegosId.

*/


SELECT j.nickname, vi.nombre, v.valoracionId, v.jugadorId, v.videojuegoId, v.fechaValoracion, v.puntuacion,
			v.opinion, v.likes, v.veredicto FROM valoraciones v
natural JOIN jugadores j 
natural JOIN videojuegos vi
ORDER BY vi.videojuegoId;



/*
Codifique un trigger para impedir que la fecha de una valoración sea anterior a la fecha de lanzamiento 
del juego, y posterior a la fecha actual. Añada una instrucción que haga saltar el trigger.*/

DELIMITER //

CREATE OR REPLACE TRIGGER t_fechaInvalida
BEFORE INSERT ON valoraciones
FOR EACH ROW
BEGIN
	DECLARE fechaLan DATE;
	SET fechaLan = (SELECT v.fechaLanzamiento FROM videojuegos v WHERE v.videojuegoId=NEW.videojuegoId);
 
 	if (NEW.fechaValoracion<fechaLan OR NEW.fechaValoracion>CURDATE()) then
	 	SIGNAL SQLSTATE '45000' SET message_text =
			'Fecha de valoracion invalida';
	END if;
END //

DELIMITER ;

/*
-- CORRECTA
CALL p_insercionUsuario(2,1,5,'prueba del trigger','Imprescindible','2021-01-01');

-- ANTIGUA
CALL p_insercionUsuario(2,1,5,'prueba del trigger','Imprescindible','1991-01-01');

-- POSTERIOR
CALL p_insercionUsuario(2,1,5,'prueba del trigger','Imprescindible','2027-01-01');
*/


/*
Codifique una función que devuelva el número de valoraciones de un usuario dado.
Realice una prueba de la función con UsuarioId=2.*/

DELIMITER //

CREATE OR REPLACE FUNCTION f_numValoraciones(userId INT)  RETURNS INT 
BEGIN 
		DECLARE numValoraciones DOUBLE;
		SET numValoraciones = (SELECT COUNT(*) FROM valoraciones
			WHERE Valoraciones.jugadorId = userId);
		RETURN numValoraciones;
END //
DELIMITER ;

SELECT f_numValoraciones(2);


/*
Cree una consulta que devuelva los juegos y la media de las valoraciones recibidas, ordenados de mayor a 
menor. En el listado deben aparecer todos los juegos, tengan o no valoración.*/


SELECT vi.nombre, AVG(v.puntuacion) media FROM videojuegos vi LEFT JOIN valoraciones v ON v.videojuegoId=vi.videojuegoId
GROUP BY vi.videojuegoId
ORDER BY media desc;


/*
Cree un trigger que impida valorar un juego que esté en fase ’Beta’. (1 punto)*/


DELIMITER //

CREATE OR REPLACE TRIGGER t_faseBeta
BEFORE INSERT ON valoraciones
FOR EACH ROW
BEGIN
	DECLARE fase  ENUM('Lanzado', 'Beta', 'Acceso anticipado');
	SET fase = (SELECT v.estado FROM videojuegos v WHERE v.videojuegoId=NEW.videojuegoId);
 	
 	if (fase ='Beta') then
 	SIGNAL SQLSTATE '45000' SET message_text =
			'No se puede hacer una valoracion en fase beta';
	END if;
	
END //

DELIMITER ;


-- CALL p_insercionUsuario(2,9,5,'prueba del trigger','Imprescindible','2024-01-01');


/*
Cree un procedimiento pAddUsuarioValoracion que, dentro de una transacción, inserte un usuario y 
una valoración de dicho usuario a un videojuego dado. Incluya los parámetros que considere oportunos.
Realice dos llamadas: una que inserte ambos (el usuario y la valoración) correctamente, y una en la que 
el segundo rompa alguna restricción y aborte la transacción.*/

DELIMITER //

CREATE OR REPLACE PROCEDURE pAddUsuarioValoracion(
	IN v_nickname VARCHAR(60),
	IN v_videojuegoId INT,
	IN v_puntuacion DECIMAL(2,1),
	IN v_opinion VARCHAR(100),
	IN v_veredicto ENUM('Imprescindible','Recomendado','Comprar en rebajas','No merece la pena'),
	IN v_fecha DATE
)
BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		ROLLBACK;
		SELECT 'Transacción cancelada por error' AS resultado;
	END;

	START TRANSACTION;

	INSERT INTO Jugadores(nickname)
	VALUES (v_nickname);

	-- Obtener el ID recién insertado
	SET @nuevoJugadorId = LAST_INSERT_ID();

	INSERT INTO Valoraciones(jugadorId, videojuegoId, puntuacion, opinion, veredicto, fechaValoracion)
	VALUES (@nuevoJugadorId, v_videojuegoId, v_puntuacion, v_opinion, v_veredicto, v_fecha);

	COMMIT;
	SELECT 'Transacción completada con éxito' AS resultado;
END //

DELIMITER ;


-- LLAMADA CORRECTA


CALL pAddUsuarioValoracion(
	'NuevoJugador123',
	1,                     -- The Legend of Zelda: Breath of the Wild
	4.5,
	'Juego increíble',
	'Imprescindible',
	CURDATE()
);


-- LLAMADA INCORRECTA

CALL pAddUsuarioValoracion(
	'JugadorFallido',
	2,                    -- Tears of the Kingdom
	7.5,                  -- inválido: fuera del rango 0-5
	'Demasiado largo',
	'Recomendado',
	CURDATE()
);

