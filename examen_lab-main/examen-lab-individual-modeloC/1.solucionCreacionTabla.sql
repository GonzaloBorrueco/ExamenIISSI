CREATE OR REPLACE TABLE Valoraciones (
    id INT PRIMARY KEY AUTO_INCREMENT,
    puntuacion INT NOT NULL CHECK(puntuacion >= 1 AND puntuacion <= 5),
    fechaValoracion DATE NOT NULL,
    clienteId INT NOT NULL,
    productoId INT NOT NULL,
    UNIQUE(clienteId, productoId),
    FOREIGN KEY (clienteId) REFERENCES Clientes(id)
        ON DELETE CASCADE 
        ON UPDATE CASCADE,
        
   FOREIGN KEY (productoId) REFERENCES Productos(id)
        ON DELETE CASCADE 
        ON UPDATE CASCADE

);
