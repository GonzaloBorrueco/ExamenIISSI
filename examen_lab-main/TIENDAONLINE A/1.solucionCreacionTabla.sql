USE tiendaonline;

/*
Necesitamos conocer la garantía de nuestros productos. Para ello se propone la creación de una nueva tabla
 llamada `Garantias`. Cada producto tendrá como máximo una garantía (no todos los productos tienen garantía),
  y cada garantía estará relacionada con un producto.

Para cada garantía necesitamos conocer la fecha de inicio de la garantía, la fecha de fin de la garantía, 
si tiene garantía extendida o no.

Asegure que la fecha de fin de la garantía es posterior a la fecha de inicio.
*/

CREATE OR REPLACE TABLE Garantias(

garantiaId INT not null PRIMARY KEY AUTO_INCREMENT ,
productoId INT NOT NULL,
fechaIni DATE NOT NULL,
fechaFin DATE NOT NULL,
garantiaExtendida BOOLEAN NOT NULL,

CONSTRAINT c_fechasCorrectas CHECK(fechaFin>fechaIni),
FOREIGN KEY (productoId) REFERENCES productos(id),
UNIQUE(garantiaId,productoId)

);


