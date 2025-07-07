/*
	Theory triggers	triggers.sql
	C Arévalo, Nov/2023
*/
USE theory;
/* RN_1: Un jefe como máximo tiene 4 empleados dependientes */
DELIMITER //
CREATE OR REPLACE TRIGGER RN_1_Max_Employees_ins
BEFORE INSERT ON employees FOR EACH ROW
BEGIN
	SELECT COUNT(*) INTO @nE FROM employees WHERE bossId=NEW.bossId; -- Hay uno menos que el insertado ahora
	IF (@nE>=4) THEN
		SIGNAL SQLSTATE '45000' SET message_text = 
			'RN_1_Max_Employees_ins: No puede haber más de 4 empleados con el mismo jefe';
	END IF;
END//
DELIMITER ;

DELIMITER //
CREATE OR REPLACE TRIGGER RN_1_Max_Employees_upd
AFTER UPDATE ON employees FOR EACH ROW
BEGIN
	SELECT COUNT(*) INTO @nE FROM employees WHERE bossId=NEW.bossId; -- Hay uno menos que el insertado ahora
	IF (@nE>4) THEN
		SIGNAL SQLSTATE '45000' SET message_text = 
			'RN_1_Max_Employees_upd: No puede haber más de 4 empleados con el mismo jefe';
	END IF;
END//

-- Ejemplo de Trigger para comprobar que un Departamento no tiene más
-- de 5 Employees.
DELIMITER //
CREATE OR REPLACE TRIGGER RN_3_tMaxEmployeesDepartment_ins 
BEFORE INSERT ON Employees FOR EACH ROW 
BEGIN 
	SELECT COUNT(*) INTO @n FROM Employees WHERE departmentId = new.departmentId; 
	IF (@n > 4) THEN 
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 
			'RN_3_tMaxEmployeesDepartment_ins: Un departamento no puede tener más de 5 Employees'; 
	END IF; 
END //
DELIMITER ;
DELIMITER //
CREATE OR REPLACE TRIGGER RN_3_tMaxEmployeesDepartment_upd
AFTER UPDATE ON Employees FOR EACH ROW 
BEGIN 
	SELECT COUNT(*) INTO @n FROM Employees WHERE departmentId = new.departmentId; 
	IF (@n > 5) THEN 
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 
			'RN_3_tMaxEmployeesDepartment_upd: Un departamento no puede tener más de 5 Employees'; 
	END IF; 
END //
DELIMITER ;

DELIMITER //
/* RN-2: 	Si la comisión es nula se establece a 5% por defecto
				No puede aumentar ni disminuir más de un 20%
*/
CREATE OR REPLACE TRIGGER RN_2_fee_ins
BEFORE INSERT ON employees FOR EACH ROW
BEGIN
	IF (NEW.fee IS NULL ) THEN 
		SET NEW.fee=0.05; -- Valor por defecto, aunque el atributo aparezca en la lista del insert
	END IF;
END//
delimiter //
CREATE OR REPLACE TRIGGER RN_2_fee_upd
BEFORE UPDATE ON employees FOR EACH ROW
BEGIN
	IF (NEW.fee IS NULL ) THEN 
		SET NEW.fee=0.05; -- Valor por defecto, aunque el atributo aparezca en la lista del insert
	END IF;
	IF ( ABS(NEW.fee - OLD.fee)>0.2 ) THEN 
		SIGNAL SQLSTATE '45000' SET message_text = 
			'RN_2_fee_upd: No puede incrementarse la comisión más de un 20%';
	END IF;
END//
/*
	Prueba de triggers
*/
SET FOREIGN_KEY_CHECKS = 0; -- Desactiva la verificación de integridad referencial 
TRUNCATE Employees;
TRUNCATE Departments;
SET FOREIGN_KEY_CHECKS = 1; -- Activa la verificación de integridad referencial 

INSERT INTO Departments (nameDep, city) VALUES 
	('Historia', NULL), ('Informática', 'Sevilla'), ('Arte', 'Cádiz')
;

-- OK
INSERT INTO Employees(employeeId,departmentId, bossId, nameEmp, salary, startDate, endDate, fee) VALUES 
	(10,1, NULL, 'El Jefe', 2300.00, '2017-09-15', NULL, 0.2),
	(11,1, 10, 'Emp-1', 1300.00, '2018-08-15', '2018-11-15', 0),
	(12,1, 10, 'Emp-2', 1300.00, '2018-08-15', '2018-11-15', 0),
	(13,1, 10, 'Emp-3', 1300.00, '2018-08-15', '2018-11-15', 0),
	(14,1, 10, 'Emp-4', 1300.00, '2018-08-15', '2018-11-15', 0)
;

-- NOK Trigger RN_1_Max_Employees_ins
INSERT INTO Employees(employeeId,departmentId, bossId, nameEmp, salary, startDate, endDate, fee) VALUES 
	(15,1, 10, 'Emp-5', 1300.00, '2018-08-15', '2018-11-15', 0)
;

-- NOK RN_1_Max_Employees_upd
UPDATE employees SET bossId=10 WHERE employeeId=15;

-- NOK: RN_3_tMaxEmployeesDepartment_ins 
INSERT INTO Employees(employeeId,departmentId, bossId, nameEmp, salary, startDate, endDate, fee) VALUES 
	(99,1, Null, 'Emp-5', 1300.00, '2018-08-15', '2018-11-15', 0)
;

INSERT INTO Employees(employeeId,departmentId, bossId, nameEmp, salary, startDate, endDate, fee) VALUES 
	(99,Null, Null, 'Emp-5', 1300.00, '2018-08-15', '2018-11-15', 0)
;
-- NOK: RN_3_tMaxEmployeesDepartment_upd
UPDATE employees SET departmentId=1 WHERE employeeId=99;

-- Comisión por defecto (5%) al actualizarla a NULL
SELECT * FROM employees; 
UPDATE employees SET fee=NULL WHERE employeeId=99; -- OK
SELECT * FROM employees; 

UPDATE employees SET fee=fee+0.05 WHERE employeeId=99; -- OK