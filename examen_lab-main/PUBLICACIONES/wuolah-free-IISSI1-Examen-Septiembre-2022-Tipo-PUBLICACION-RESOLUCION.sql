-- Esta documentación ha sido propuesta por PABLO BUZA MIRA.

-- RENOVACIÓN Y USO DE BASES DE DATOS:
DROP DATABASE IF EXISTS tipoPublicacionSep22;

CREATE DATABASE IF NOT EXISTS tipoPublicacionSep22;
USE tipoPublicacionSep22;

-- CREACIÓN DE TABLAS
CREATE TABLE grados(
	gradoId INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
	nombre VARCHAR(60) NOT NULL UNIQUE,
	años INT DEFAULT 4 NOT NULL,
	CONSTRAINT AñoGradoInvalido CHECK (años >=3 AND años <=5)
);
	
CREATE TABLE departamentos(
	departamentoId INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
	nombre VARCHAR(60) NOT NULL UNIQUE
);

CREATE TABLE asignaturas(
	asignaturaId INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
	nombre VARCHAR(100) NOT NULL UNIQUE,
	acronimo VARCHAR(8) NOT NULL UNIQUE,
	creditos INT NOT NULL,
	curso INT NOT NULL,
	tipo VARCHAR(20) NOT NULL,
	gradoId INT NOT NULL,
	departamentoId INT NOT NULL,
	FOREIGN KEY (gradoId) REFERENCES grados(gradoId),
	FOREIGN KEY (departamentoId) REFERENCES departamentos(departamentoId),
	CONSTRAINT asignaturaCreditosNegativos CHECK (creditos > 0),
	CONSTRAINT cursoAsignaturaInvalido CHECK (curso > 0 AND curso < 6),
	CONSTRAINT tipoAsignaturaInvalido CHECK (tipo IN ('Formacion Basica','Optativa','Obligatoria'))
);
	
CREATE TABLE clases(
	claseId INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
	nombre VARCHAR(60) NOT NULL UNIQUE,
	planta INT NOT NULL, 
	capacidad INT NOT NULL,
	tieneProyector BOOLEAN NOT NULL,
	tieneAltavoces BOOLEAN NOT NULL,
	CONSTRAINT plantaInvalida CHECK (planta >= 0),
	CONSTRAINT capacidadInvalida CHECK (capacidad > 0)
);
	
CREATE TABLE grupos(
	grupoId INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
	nombre VARCHAR(30) NOT NULL,
	actividad VARCHAR(20) NOT NULL,
	año INT NOT NULL,
	asignaturaId INT NOT NULL,
	claseId INT NOT NULL,
	FOREIGN KEY (asignaturaId) REFERENCES asignaturas(asignaturaId),
	FOREIGN KEY (claseId) REFERENCES clases(claseId),
	UNIQUE (nombre, año, asignaturaId),
	CONSTRAINT añoGrupoNegativo CHECK (año > 0),
	CONSTRAINT invalidoGrupoActividad CHECK (actividad IN ('Teoria','Laboratorio'))
);
	
CREATE TABLE estudiantes(
	estudianteId INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
	metodoAcceso VARCHAR(30) NOT NULL,
	dni CHAR(9) NOT NULL UNIQUE,
	nombre VARCHAR(100) NOT NULL,
	apellido VARCHAR(100) NOT NULL,
	cumple DATE NOT NULL,
	email VARCHAR(250) NOT NULL UNIQUE,
	CONSTRAINT invalidoMetodoAccesoEstudiante CHECK (metodoAcceso IN ('Selectividad', 'Ciclo', 'Mayor', 'Titulado Extranjero'))
);
	
CREATE TABLE gruposEstudiantes(
	grupoEstudianteId INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
	grupoId INT NOT NULL,
	estudianteId INT NOT NULL,
	FOREIGN KEY (grupoId) REFERENCES grupos(grupoId) ON DELETE CASCADE,
	FOREIGN KEY (estudianteId) REFERENCES estudiantes(estudianteId),
	UNIQUE (grupoId, estudianteId)
);


CREATE TABLE calificaciones(
	calificacionId INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
	valor DECIMAL(4,2) NOT NULL,
	calificacionNombre INT NOT NULL,
	matriculaHonor BOOLEAN NOT NULL,
	estudianteId INT NOT NULL,
	grupoId INT NOT NULL,
	FOREIGN KEY (estudianteId) REFERENCES estudiantes(estudianteId),
	FOREIGN KEY (grupoId) REFERENCES grupos(grupoId) ON DELETE CASCADE,
	CONSTRAINT valorCalificacionInvalido CHECK (valor >= 0 AND valor <= 10),
	CONSTRAINT calificacionNombreInvalido CHECK (calificacionNombre >= 1 AND calificacionNombre <= 3),
	UNIQUE (calificacionNombre, estudianteId, grupoId)
);

CREATE TABLE oficinas(
	oficinaId INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
	nombre VARCHAR(60) NOT NULL UNIQUE,
	planta INT NOT NULL, 
	capacidad INT NOT NULL,
	CONSTRAINT plantaInvalida CHECK (planta >= 0),
	CONSTRAINT capacidadInvalida CHECK (capacidad > 0)
);

CREATE TABLE profesores(
	profesorId INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
	oficinaId INT NOT NULL,
	departamentoId INT NOT NULL,
	categoria VARCHAR(5) NOT NULL,
	dni CHAR(9) NOT NULL UNIQUE,
	nombre VARCHAR(100) NOT NULL,
	apellido VARCHAR(100) NOT NULL,
	cumple DATE NOT NULL,
	email VARCHAR(250) NOT NULL UNIQUE,
	FOREIGN KEY (oficinaId) REFERENCES oficinas(oficinaId),
	FOREIGN KEY (departamentoId) REFERENCES departamentos(departamentoId),
	CONSTRAINT categoriaInvalida CHECK (categoria IN ('CU','TU','PCD','PAD'))
);

CREATE TABLE horaTutorias(
	tutoriaId INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
	profesorId INT NOT NULL,
	diaSemana INT NOT NULL,
	horaInicio TIME,
	horaFin TIME,
	FOREIGN KEY (profesorId) REFERENCES profesores(profesorId),
	CONSTRAINT diaSemanaInvalido CHECK (diaSemana >= 0 AND diaSemana <= 6)
);

CREATE TABLE citas(
	citaId INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
	tutoriaId INT NOT NULL,
	estudianteId INT NOT NULL,
	hora TIME NOT NULL,
	fecha DATE NOT NULL,
	FOREIGN KEY (tutoriaId) REFERENCES horaTutorias(tutoriaId),
	FOREIGN KEY (estudianteId) REFERENCES estudiantes(estudianteId)
);

CREATE TABLE cargaDidactica(
	cargaDidacticaId INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
	profesorId INT NOT NULL,
	grupoId INT NOT NULL,
	creditos INT NOT NULL,
	FOREIGN KEY (profesorId) REFERENCES profesores(profesorId),
	FOREIGN KEY (grupoId) REFERENCES grupos(grupoId),
	CONSTRAINT creditosInvalidos CHECK (creditos > 0)
);

	
-- ADICIÓN DE DATOS
INSERT INTO grados(nombre, años) VALUES
	('Ingeniería del Software', 4),
	('Ingeniería de Computadores', 4),
	('Tecnologías Informáticas', 4)
;

INSERT INTO departamentos(nombre) VALUES
	('Lenguajes y Sistemas Informáticos'),
	('Matemáticas')
;

INSERT INTO asignaturas(nombre, acronimo, creditos, curso, tipo, gradoId, departamentoId) VALUES
	('Diseño y Pruebas', 'DP', 12, 3, 'Obligatoria', 1, 1),
	('Acceso Inteligente a la Informacion', 'AII', 6, 4, 'Optativa', 1, 1),
	('Optimizacion de Sistemas', 'OS', 6, 4, 'Optativa', 1, 1),
	('Ingeniería de Requisitos', 'IR', 6, 2, 'Obligatoria', 1, 1),
	('Análisis y Diseño de Datos y Algoritmos', 'ADDA', 12, 2, 'Obligatoria', 1, 1),
	('Introducción a la Matematica Discreta', 'IMD', 6, 1, 'Formacion Basica', 2, 2),
	('Redes de Computadores', 'RC', 6, 2, 'Obligatoria', 2, 1),
	('Teoría de Grafos', 'TG', 6, 3, 'Obligatoria', 2, 2),
	('Aplicaciones de Soft Computing', 'ASC', 6, 4, 'Optativa', 2, 1),
	('Fundamentos de Programación', 'FP', 12, 1, 'Formacion Basica', 3, 1),
	('Lógica Informatica', 'LI', 6, 2, 'Optativa', 3, 2),
	('Gestión y Estrategia Empresarial', 'GEE', 12, 3, 'Optativa', 3, 1),
	('Trabajo de Fin de Grado', 'TFG', 12, 4, 'Obligatoria', 3, 1)
;

INSERT INTO clases(nombre, planta, capacidad, tieneProyector, tieneAltavoces) VALUES
	('F1.31', 1, 30, TRUE, FALSE),
	('F1.33', 1, 35, TRUE, FALSE),
	('A0.31', 1, 80, TRUE, TRUE)
;

INSERT INTO grupos(nombre, actividad, año, asignaturaId, claseId) VALUES
	('T1', 'Teoria', 2018, 1, 1),
	('T2', 'Teoria', 2018, 1, 2),
	('L1', 'Laboratorio', 2018, 1, 3),
	('L2', 'Laboratorio', 2018, 1, 1),
	('L3', 'Laboratorio', 2018, 1, 2),
	('T1', 'Teoria', 2019, 1, 3),
	('T2', 'Laboratorio', 2019, 1, 1),
	('L1', 'Laboratorio', 2019, 1, 2),
	('L2', 'Laboratorio', 2019, 1, 3),
	('Teor1', 'Teoria', 2018, 2, 1),
	('Teor2', 'Teoria', 2018, 2, 2),
	('Lab1', 'Laboratorio', 2018, 2, 3),
	('Lab2', 'Laboratorio', 2018, 2, 1),
	('Teor1', 'Teoria', 2019, 2, 2),
	('Lab1', 'Laboratorio', 2019, 2, 3),
	('Lab2', 'Laboratorio', 2019, 2, 1),
	('T1', 'Teoria', 2019, 10, 2),
	('T2', 'Teoria', 2019, 10, 3),
	('T3', 'Teoria', 2019, 10, 1),
	('L1', 'Laboratorio', 2019, 10, 2),
	('L2', 'Laboratorio', 2019, 10, 3),
	('L3', 'Laboratorio', 2019, 10, 1),
	('L4', 'Laboratorio', 2019, 10, 2),
	('Clase', 'Teoria', 2019, 12, 3),
	('T1', 'Teoria', 2019, 6, 1)
;

INSERT INTO estudiantes(metodoAcceso, dni, nombre, apellido, cumple, email) VALUES
	('Selectividad', '12345678A', 'Daniel', 'Pérez', '1991-01-01', 'daniel@alum.us.es'),
	('Selectividad', '22345678A', 'Rafael', 'Ramírez', '1992-01-01', 'rafael@alum.us.es'),
	('Selectividad', '32345678A', 'Gabriel', 'Hernández', '1993-01-01', 'gabriel@alum.us.es'),
	('Selectividad', '42345678A', 'Manuel', 'Fernández', '1994-01-01', 'manuel@alum.us.es'),
	('Selectividad', '52345678A', 'Joel', 'Gómez', '1995-01-01', 'joel@alum.us.es'),
	('Selectividad', '62345678A', 'Abel', 'López', '1996-01-01', 'abel@alum.us.es'),
	('Selectividad', '72345678A', 'Azael', 'González', '1997-01-01', 'azael@alum.us.es'),
	('Selectividad', '8345678A', 'Uriel', 'Martínez', '1998-01-01', 'uriel@alum.us.es'),
	('Selectividad', '92345678A', 'Gael', 'Sánchez', '1999-01-01', 'gael@alum.us.es'),
	('Titulado Extranjero', '12345678B', 'Noel', 'Álvarez', '1991-02-02', 'noel@alum.us.es'),
	('Titulado Extranjero', '22345678B', 'Ismael', 'Antúnez', '1992-02-02', 'ismael@alum.us.es'),
	('Titulado Extranjero', '32345678B', 'Nathanael', 'Antolinez', '1993-02-02', 'nathanael@alum.us.es'),
	('Titulado Extranjero', '42345678B', 'Ezequiel', 'Aznárez', '1994-02-02', 'ezequiel@alum.us.es'),
	('Titulado Extranjero', '52345678B', 'Ángel', 'Chávez', '1995-02-02', 'angel@alum.us.es'),
	('Titulado Extranjero', '62345678B', 'Matusael', 'Gutiérrez', '1996-02-02', 'matusael@alum.us.es'),
	('Titulado Extranjero', '72345678B', 'Samael', 'Gálvez', '1997-02-02', 'samael@alum.us.es'),
	('Titulado Extranjero', '82345678B', 'Baraquiel', 'Ibáñez', '1998-02-02', 'baraquiel@alum.us.es'),
	('Titulado Extranjero', '92345678B', 'Otoniel', 'Idiáquez', '1999-02-02', 'otoniel@alum.us.es'),
	('Titulado Extranjero', '12345678C', 'Niriel', 'Benítez', '1991-03-03', 'niriel@alum.us.es'),
	('Titulado Extranjero', '22345678C', 'Múriel', 'Bermúdez', '1992-03-03', 'muriel@alum.us.es'),
	('Titulado Extranjero', '32345678C', 'John', 'AII', '2000-01-01', 'john@alum.us.es')
;
	
INSERT INTO gruposEstudiantes(grupoId, estudianteId) VALUES
	(1, 1),
	(3, 1),
	(7, 1),
	(8, 1),
	(10, 1),
	(12, 1),
	(2, 2),
	(3, 2),
	(10, 2),
	(12, 2),
	(18, 21),
	(21, 21),
	(1, 9)
;

INSERT INTO calificaciones(valor, calificacionNombre, matriculaHonor, estudianteId, grupoId) VALUES
	(4.50, 1, 0, 1, 1),
	(3.25, 2, 0, 1, 1),
	(9.95, 1, 0, 1, 7),
	(7.5, 1, 0, 1, 10),
	(2.50, 1, 0, 2, 2),
	(5.00, 2, 0, 2, 2),
	(10.00, 1, 1, 2, 10),
	(0.00, 1, 0, 21, 18),
	(1.25, 2, 0, 21, 18),
	(0.5, 3, 0, 21, 18)
;

INSERT INTO oficinas(nombre, planta, capacidad) VALUES
	('F1.85', 1, 5),
	('F0.45', 0, 3)
;

INSERT INTO profesores(oficinaId, departamentoId, categoria, dni, nombre, apellido, cumple, email) VALUES
	(1, 1, 'PAD', '42345678C', 'Fernando', 'Ramírez', '1960-05-02', 'fernando@us.es'),
	(1, 1, 'TU', '52345678C', 'David', 'Zuir', '1902-01-01', 'dzuir@us.es'),
	(1, 1, 'TU', '62345678C', 'Antonio', 'Zuir', '1902-01-01', 'azuir@us.es'),
	(1, 2, 'CU', '72345678C', 'Rafael', 'Gómez', '1959-12-12', 'rdgomez@us.es'),
	(2, 1, 'TU', '82345678C', 'Inma', 'Hernández', '1234-5-6', 'inmahrdz@us.es')
;

INSERT INTO horaTutorias(profesorId, diaSemana, horaInicio, horaFin) VALUES
	(1, 0, '12:00:00', '14:00:00'),
	(1, 1, '18:00:00', '19:00:00'),
	(1, 1, '11:30:00', '12:30:00'),
	(2, 2, '10:00:00', '20:00:00')
;
	
INSERT INTO citas(tutoriaId, estudianteId, hora, fecha) VALUES
	(1, 1, '13:00:00', '2019-11-18'),
	(2, 2, '18:20:00', '2019-11-19'),
	(4, 1, '15:00:00', '2019-11-20')
;
	
INSERT INTO cargaDidactica(profesorId, grupoId, creditos) VALUES
	(1, 1, 6),
	(2, 1, 12),
	(1, 2, 6),
	(1, 3, 12)
;

-- EJERCICIO 0: Prueba de eficiencia.
SELECT COUNT(*) FROM estudiantes;

/*
-- EJERCICIO 1: Añada el requisito de información Publicación. Una publicación es un artículo publicado en una revista por un profesor. 
Sus atributos son: el título de la publicación, el profesor que es el autor principal, el número total de autores, la fecha de publicación (día), 
y el nombre de la revista donde ha sido publicada. Hay que tener en cuenta las siguientes restricciones:
- Un profesor no puede tener varias publicaciones en la misma revista, el mismo día.
- El número de autores debe ser al menos 1 y como máximo 10.
- Todos los atributos son obligatorios a excepción de la fecha de publicación
*/
CREATE TABLE publicaciones(
publicacionId INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
titulo VARCHAR(64) NOT NULL,
profesorId INT NOT NULL,
numAutores INT NOT NULL,
fechaPublicacion DATE,
nombreRevista VARCHAR(32) NOT NULL,
FOREIGN KEY (profesorId) REFERENCES profesores(profesorId),
Unique(profesorId,nombreRevista,fechaPublicacion)
-- CONSTRAINT capacidadAutores CHECK (numAutores >=1 AND numAutores <=10)
);

/*
Este trigger es peor solucion que el unique, pero lo dejo para aun asi saber como se haria
DELIMITER //
CREATE OR REPLACE TRIGGER tProfesor1Pub1Rev1Dia
BEFORE INSERT ON publicaciones FOR EACH ROW
BEGIN
	IF (NEW.profesorId IN (SELECT profesorId FROM publicaciones WHERE NEW.fechaPublicacion = fechaPublicacion AND NEW.nombreRevista = nombreRevista)) THEN
	SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Un profesor no puede tener varias publicaciones en la misma revista el mismo día';
	END IF; 
END //
DELIMITER ;
*/

/* TEST DE PRUEBA
INSERT INTO publicaciones(titulo, profesorId, numAutores, fechaPublicacion, nombreRevista) VALUES
(1, 1, 1, '2022-01-01', 'Trakworty'),
(1, 1, 1, '2022-01-01', 'Trakworty')
;
*/

/*
-- EJERCICIO 2: Cree y ejecute un procedimiento almacenado llamado pInsertarPublicaciones() que cree las siguientes publicaciones:
- Publicación titulada “Publicación 1” del profesor con ID=1, con 3 autores, publicada en la revista “Revista 1”.
- Publicación titulada “Publicación 2”, del profesor con ID=1, con 5 autores, publicada el 1 de Enero de 2018 en la revista “Revista 2”.
- Publicación titulada “Publicación 3”, del profesor con ID=2, con 2 autores, publicada en la revista “Revista 3”.
*/

DELIMITER //
CREATE OR REPLACE PROCEDURE pInsertarPublicaciones(t VARCHAR(64), pr INT, na INT, fe DATE, nr VARCHAR(32))
BEGIN
	INSERT INTO publicaciones(titulo, profesorId, numAutores, fechaPublicacion, nombreRevista)
	VALUES (t, pr, na, fe, nr);
END //
DELIMITER ;

CALL pInsertarPublicaciones('Publicacion 1', 1, 3, NULL ,'Revista 1');
CALL pInsertarPublicaciones('Publicacion 2', 1, 5, '2018-01-01', 'Revista 2');
CALL pInsertarPublicaciones('Publicacion 3', 2, 2, NULL ,'Revista 3');


/*
-- EJERCICIO 3: Cree un disparador (trigger) llamado tCorreccionAutores que, al actualizarse una publicación, 
si el número de autores fuera a pasar a ser más de 10, lo cambie a 10 en su lugar.
*/

DELIMITER //
CREATE OR REPLACE TRIGGER tCorreccionAutores
BEFORE UPDATE ON publicaciones FOR EACH ROW
BEGIN
	IF (NEW.numAutores > 10) THEN SET NEW.numAutores = 10;
	END IF;
END //
DELIMITER ;
-- UPDATE publicaciones SET numAutores = 12 WHERE publicacionId = 4;

/*
-- EJERCICIO 4: Cree un procedimiento almacenado llamado pActualizarPublicaciones(p, n) que actualiza el número de autores de las publicaciones 
del profesor p con el valor n. Ejecute la llamada a pActualizarPublicaciones(1,10). Cree un procedimiento almacenado llamado pBorrarPublicaciones(p) 
que elimina las publicaciones del profesor con ID=p. Ejecute la llamada pBorrarPublicaciones(2).
*/

DELIMITER //
CREATE OR REPLACE PROCEDURE pActualizarPublicaciones(p INT, n INT)
BEGIN
	UPDATE publicaciones SET numAutores=n WHERE profesorId = p;
END //
DELIMITER ;
CALL pActualizarPublicaciones(1,10);

DELIMITER //
CREATE OR REPLACE PROCEDURE pBorrarPublicaciones(p INT)
BEGIN
	DELETE FROM publicaciones WHERE profesorId = p;
END //
DELIMITER ;
CALL pBorrarPublicaciones(2);


/*
-- EJERCICIO 5: Cree una consulta que devuelva el nombre del grado, el nombre de la asignatura, el número de créditos de la asignatura y su tipo, 
para todas las asignaturas que pertenecen a todos los grados. Ordene los resultados por el nombre del grado.
*/

SELECT G.nombre, A.nombre, creditos, tipo
FROM grados G JOIN asignaturas A ON G.gradoId=A.gradoId
ORDER BY G.nombre;


-- EJERCICIO 6: Cree una consulta que devuelva las tutorías con al menos una cita.

SELECT tutoriaId
FROM citas NATURAL JOIN horatutorias
GROUP BY tutoriaId;


-- EJERCICIO 7: Cree una consulta que devuelva la carga media en créditos de docencia del profesor cuyo ID=1.

SELECT AVG(creditos)
FROM cargadidactica
WHERE profesorId = 1;


-- EJERCICIO 8: Cree una consulta que devuelva el nombre y los apellidos de los dos estudiantes con mayor nota media, sus notas medias y su nota más baja.

SELECT nombre, apellido, AVG(valor) media, MIN(valor)
FROM estudiantes E NATURAL JOIN calificaciones C
GROUP BY E.estudianteId
ORDER BY media DESC LIMIT 2;


-- EJERCICIO 9: Cree una consulta que devuelva el nombre y los apellidos del estudiante que ha sacado la nota más alta del grupo con ID=10.
-- OPCIÓN A
SELECT E.nombre, E.apellido 
FROM estudiantes E NATURAL JOIN calificaciones C
WHERE C.grupoId = 10
ORDER BY C.valor DESC LIMIT 1;

-- OPCIÓN B
SELECT (nombre,apellido)
FROM estudiantes NATURAL JOIN calificaciones 
WHERE valor = (SELECT MAX(valor) FROM calificaciones WHERE grupoId=10);
