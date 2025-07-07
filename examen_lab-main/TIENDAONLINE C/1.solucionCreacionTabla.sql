USE tiendaonline;


/*### 1. Creación de tabla. (1,5 puntos)

Incluya su solución en el fichero `1.solucionCreacionTabla.sql`.

Necesitamos conocer la opinión de nuestros clientes sobre nuestros productos. Para ello se propone la creación de una 
nueva tabla llamada `Valoraciones`. Cada valoración versará sobre un producto y será realizada por un solo cliente. 
Cada producto podrá ser valorado por muchos clientes. Cada cliente podrá realizar muchas valoraciones. Un cliente no
 puede valorar más de una vez un mismo producto.

Para cada valoración necesitamos conocer la puntuación de 1 a 5 (sólo se permiten enteros) y la fecha en que se realiza
 la valoración.*/
 
 CREATE OR REPLACE TABLE valoraciones(
 	valoracionId INT PRIMARY KEY AUTO_INCREMENT,
 	clienteId INT NOT NULL,
 	productoId INT NOT NULL,
 	puntuacion INT NOT NULL,
 	fechaValoracion DATE NOT NULL,
 	FOREIGN KEY (clienteId) REFERENCES clientes(id),
	FOREIGN KEY (productoId) REFERENCES productos(id),
	UNIQUE(clienteId,productoId),
	CONSTRAINT c_puntuacion CHECK(puntuacion BETWEEN 1 AND 5)
 );