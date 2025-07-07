- Scripts de apoyo para Compound Statements 
-- Este script contiene los procedimientos, funciones, disparadores y cursores
-- vistos en teoría

-- Al final de este script encontrará un conjunto de consultas e instrucciones para comprobar los resultados 

-- Activar BD: Cambiar al nombre que haya puesto a su BD y descomentar la siguiente línea
-- USE <NOMBRE DE SU BD>;

-- Procedimiento para insertar un nuevo Departamento
DELIMITER //
CREATE OR REPLACE PROCEDURE pInsertDepartment(n VARCHAR(32), c VARCHAR(64)) 
BEGIN
	INSERT INTO Departments (nameDep, city) VALUES (n, c); 
END//
DELIMITER ;

-- Insertar un nuevo Empleado.
-- Si la startDate es null, poner la fecha actual del sistema
DELIMITER //
CREATE OR REPLACE PROCEDURE pInsertEmployee (e INT,d INT, b INT, n VARCHAR(64), s DECIMAL, sd DATE, ed DATE,
  f DOUBLE) 
BEGIN 
	INSERT INTO Employees	(employeeId, departmentId, bossId, nameEmp, salary, startDate, endDate, fee) VALUES 
							(e, d, b, n, s, IFNULL(sd,sysdate()), ed, f); 
END //
DELIMITER ;

-- Aplicar un aumento dado a la comisión de empleado concreto
DELIMITER //
CREATE OR REPLACE PROCEDURE pRaiseFee(id INT, amount DOUBLE) 
BEGIN 
	/* DECLARE eR ROW TYPE OF Employees; 
	DECLARE newFee DOUBLE;
	SELECT * INTO eR -- el resultado del select lo almacena en la variable Row
		FROM Employees
		WHERE employeeId = id; 
	SET newFee = eR.fee + amount; */
	UPDATE Employees 
		SET fee = fee + amount
		WHERE employeeId = id; 
END //
DELIMITER ;

-- Devuelve el numero de Employees de una localidad
DELIMITER //
CREATE OR REPLACE FUNCTION fNumEmployees(c VARCHAR(64)) RETURNS INT 
BEGIN 
	RETURN (
		SELECT COUNT(*)FROM Employees E NATURAL JOIN Departments D
		WHERE D.city = c
	); 
END//
DELIMITER ;

-- Ejemplo de uso de funciones dentro de procedimientos
-- deben almacenarse en variables
DELIMITER //
CREATE OR REPLACE FUNCTION fAvgFee() RETURNS DOUBLE 
BEGIN 
	RETURN ( SELECT AVG(fee) FROM Employees ); 
END //
DELIMITER ;

-- Procedimiento para igualar las feees de todos los Employees a 
-- la media de las fees.
DELIMITER //
CREATE OR REPLACE PROCEDURE pEquateFees() 
BEGIN 
	SET @avgFee = fAvgFee();
	UPDATE Employees SET fee = @avgFee; 
END //
DELIMITER ;