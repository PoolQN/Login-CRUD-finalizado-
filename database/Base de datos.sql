CREATE DATABASE senati;
USE senati;

CREATE TABLE cursos
(
	idcurso			INT AUTO_INCREMENT PRIMARY KEY,
	nombrecurso		VARCHAR(50)		NOT NULL,
	especialidad 	VARCHAR(70) 	NOT NULL,
	complejidad 	CHAR(1)			NOT NULL DEFAULT 'B',
	fechainicio		DATE 				NOT NULL,
	precio			DECIMAL(7,2)	NOT NULL,
	fechacreacion	DATETIME 		NOT NULL DEFAULT NOW(),
	fechaupdate 	DATETIME 		NULL,
	estado 			CHAR(1)			NOT NULL DEFAULT '1'
)ENGINE = INNODB;

INSERT INTO cursos (nombrecurso, especialidad, complejidad, fechainicio, precio) VALUES
	('Java', 'ETI', 'M', '2023-05-10', 180),
	('Desarrollo Web', 'ETI', 'B', '2023-04-20', 190),
	('Excel financiero', 'Administración', 'A', '2023-05-14', 250),
	('ERP SAP', 'Administración', 'A', '2023-05-11', 400),
	('Inventor', 'Mecánica', 'M', '2023-04-29', 380);

SELECT * FROM cursos;
UPDATE cursos SET estado = '1';

-- STORE PROCEDURE
-- Un procedimiento almacenado es un PROGRAMA que se ejecuta desde el
-- motor de BD, y que permite recibir valores de entrada, realizar
-- diferentes tipos de cálculos y entregar una salida.

-- DROP PROCEDURE spu_cursos_listar;
DELIMITER $$
CREATE PROCEDURE spu_cursos_listar()
BEGIN
	SELECT	idcurso,
				nombrecurso,
				especialidad,
				complejidad,
				fechainicio,
				precio
		FROM cursos
		WHERE estado = '1'
		ORDER BY idcurso DESC;
END $$

CALL spu_cursos_listar();

-- Procedimiento registrar cursos
DELIMITER $$
CREATE PROCEDURE spu_cursos_registrar
(
	IN _nombrecurso	VARCHAR(50),
	IN _especialidad	VARCHAR(70),
	IN _complejidad	CHAR(1),
	IN _fechainicio	DATE,
	IN _precio			DECIMAL(7,2)
)
BEGIN
	INSERT INTO cursos (nombrecurso, especialidad, complejidad, fechainicio, precio) VALUES
		(_nombrecurso, _especialidad, _complejidad, _fechainicio, _precio);
END $$

CALL spu_cursos_registrar('Python para todos', 'ETI', 'B', '2023-05-10', 120);
CALL spu_cursos_registrar('C# para la Web', 'ETI', 'A', '2023-05-11', 320);
CALL spu_cursos_listar();


-- Procedimiento eliminación lógica (solo lo inhabilitará)
DELIMITER $$
CREATE PROCEDURE spu_cursos_eliminar(IN _idcurso INT)
BEGIN
	UPDATE cursos 
		SET estado = '0' 
		WHERE idcurso = _idcurso;
END $$

CALL spu_cursos_eliminar(4);
SELECT * FROM cursos;

-- Lunes 10 abril 2023
DELIMITER $$
CREATE PROCEDURE spu_cursos_recuperar_id(IN _idcurso INT)
BEGIN
	SELECT * FROM cursos WHERE idcurso = _idcurso;
END $$

CALL spu_cursos_recuperar_id(3);




DELIMITER $$
CREATE PROCEDURE spu_cursos_actualizar
(
	IN _idcurso			INT,
	IN _nombrecurso	VARCHAR(50),
	IN _especialidad	VARCHAR(70),
	IN _complejidad 	CHAR(1),
	IN _fechainicio	DATE,
	IN _precio 			DECIMAL(7,2)
)
BEGIN
	UPDATE cursos SET
		nombrecurso = _nombrecurso,
		especialidad = _especialidad,
		complejidad = _complejidad,
		fechainicio = _fechainicio,
		precio = _precio,
		fechaupdate = NOW()
	WHERE idcurso = _idcurso;
END $$

SELECT * FROM cursos WHERE idcurso = 3;
CALL spu_cursos_actualizar(3, 'java', 'ETI', 'A', '2023-06-21', 320);
	

CREATE TABLE usuarios
(
	idusuario			INT AUTO_INCREMENT PRIMARY KEY,
	nombreusuario		VARCHAR(30)			NOT NULL,
	claveacceso			VARCHAR(90)			NOT NULL,
	apellidos			VARCHAR(30)			NOT NULL,
	nombres				VARCHAR(30)			NOT NULL,
	nivelacceso			CHAR(1)				NOT NULL DEFAULT 'A',
	estado				CHAR(1)				NOT NULL DEFAULT '1',
	fecharegistro		DATETIME				NOT NULL DEFAULT NOW(),
	fechaupdate 		DATETIME 			NULL,
	CONSTRAINT uk_nombreusuario_usa UNIQUE (nombreusuario)
)ENGINE = INNODB;

INSERT INTO usuarios (nombreusuario, claveacceso, apellidos, nombres) VALUES
	('POOL', '123456', 'Quesada Nolasco', 'Pool'),
	('JOSE', '123456', 'Marcos Perez', 'Jose');

SELECT * FROM usuarios;

-- Actualizando por la clave incriptada
-- Defecto: SENATI
UPDATE usuarios SET
claveacceso = '$2y$10$HRK9czgpbr9vyIPJMl2R0Ob7pMontFy5NdSn0Jdhy1kksMYNsy4LG'
WHERE idusuario = 1;

UPDATE usuarios SET
claveacceso = '$2y$10$qWHt2TJCxtXdEyAQPP/Jde0GmwuN3PgIwogvUTPt5FSD.ygWGIzRK'
WHERE idusuario = 2;

SELECT * FROM usuarios;

DELIMITER $$
CREATE PROCEDURE spu_usuarios_login(IN _nombreusuario VARCHAR(30))
BEGIN	
	SELECT idusuario, nombreusuario, claveacceso,
						apellidos, nombres, nivelacceso
	FROM usuarios
	WHERE nombreusuario = _nombreusuario AND estado = '1';
END $$
	
CALL spu_usuarios_login('POOL');


-- Registrar usuario
DELIMITER $$
CREATE PROCEDURE spu_usuarios_registrar
(
	IN _nombreusuario			VARCHAR(30),
	IN _claveacceso			VARCHAR(90),
	IN _apellidos				VARCHAR(30),
	IN _nombres					VARCHAR(30)
)
BEGIN
	INSERT INTO usuarios (nombreusuario, claveacceso, apellidos, nombres) VALUES
								(_nombreusuario, _claveacceso, _apellidos, _nombres);
END $$

CALL spu_usuarios_registrar('PEDRO', '789456', 'Perez Gomez','Raul');
CALL spu_usuarios_registrar('LUIS', '147852', 'Campos Bautista','Luis');

-- Mostrar Usuarios
DELIMITER $$
CREATE PROCEDURE spu_usuarios_mostrar()
BEGIN
	SELECT 	*
		FROM usuarios
		WHERE estado = '1'
		ORDER BY idusuario DESC;
END $$

CALL spu_usuarios_mostrar()

-- Eliminar Usuarios
DROP PROCEDURE spu_usuarios_eliminar
DELIMITER $$
CREATE PROCEDURE spu_usuarios_eliminar(IN _idusuario INT)
BEGIN
	UPDATE usuarios
		SET estado = '0' 
		WHERE idusuario = _idusuario;
END $$

CALL spu_usuarios_eliminar(3);
SELECT * FROM usuarios;

-- Actualizar Usuarios
DELIMITER $$
CREATE PROCEDURE spu_usuarios_actualizar
(
	IN _idusuario				INT,
	IN _nombreusuario			VARCHAR(30),
	IN _claveacceso			VARCHAR(90),
	IN _apellidos				VARCHAR(30),
	IN _nombres					VARCHAR(30)
)
BEGIN
	UPDATE usuarios SET
		nombreusuario = _nombreusuario,
		claveacceso = _claveacceso,
		apellidos = _apellidos,
		nombres = _nombres
	WHERE idusuario = _idusuario;
END $$

SELECT * FROM usuarios WHERE idusuario = 3;
CALL spu_usuarios_actualizar(3, 'MAX', '852963', 'Sarmiento Paredes', 'Maximo');



