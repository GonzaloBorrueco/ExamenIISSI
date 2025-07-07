DROP TABLE IF EXISTS Garantias;

CREATE TABLE Garantias (
    id INT PRIMARY KEY AUTO_INCREMENT,
    fechaInicio DATE UNIQUE NOT NULL,
    fechaFin DATE UNIQUE NOT NULL CHECK (fechaInicio <= fechaFin),
    garantiaExtendida BOOLEAN NOT NULL
);