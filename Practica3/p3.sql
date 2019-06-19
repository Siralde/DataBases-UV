/*Ejercicio 1*/
CREATE TABLE EMPLEADOS(
    idempleado NUMBER,
    nombre VARCHAR2(30),
    apellido VARCHAR2(50),
    email VARCHAR2(30),
    direccionpostal VARCHAR(40),
    telefono VARCHAR(9),
    trabajo VARCHAR(20),
    salario NUMBER,
    CONSTRAINT empleados_pk PRIMARY KEY(idempleado));

/*Ejercicio 2*/
/*A*/
ALTER TABLE EMPLEADOS
    ADD CONSTRAINT empleados_ck_email CHECK (email like '%@%');

/*B*/
ALTER TABLE EMPLEADOS
    ADD CONSTRAINT empleados_ck_telefonos CHECK (telefono like '%[6|9]........%');
    
/*C*/
ALTER TABLE EMPLEADOS
    ADD CONSTRAINT empleados_ck_trabajos  CHECK (trabajo IN ('Instructor', 'Administrativo', 'Comercial', 'Vendedor', 'Veterinario'));
    
/*D*/
ALTER TABLE EMPLEADOS
    ADD CONSTRAINT empleados_ck_salario CHECK (salario > 655.20);
    
/*E*/
ALTER TABLE EMPLEADOS
    ADD CONSTRAINT empleados_ck_telefonos2 UNIQUE(telefono);

/*F*/
ALTER TABLE EMPLEADOS
    ADD CONSTRAINT empleados_ck_email2 UNIQUE(email);
    
    
/*Ejercicio 3*/

CREATE TABLE CLIENTES (
    idcliente NUMBER,
    nombre VARCHAR2(30),
    apellido VARCHAR2(50),
    email VARCHAR2(30),
    direccionpostal VARCHAR2(40),
    ciudad VARCHAR(30),
    CONSTRAINT clientes_pk PRIMARY KEY (idcliente),
    CONSTRAINT clientes_ck_email CHECK (email LIKE '%@%'));

ALTER TABLE CLIENTES
    ADD CONSTRAINT CHECK (nombre = upper(nombre) AND apellido = upper(apellido) );
    
SELECT *
FROM CLIENTES;
    
    
/*Ejercicio 4*/
/*FALTA VER SI LA PARTE A ESTA BIEN, NO SE CUAL ES LA RESPUESTA*/

CREATE TABLE ANIMALES (
    tipoanimal NUMBER,
    nombre VARCHAR(30) NOT NULL,
    CONSTRAINT animales_pk PRIMARY KEY (tipoanimal));

CREATE TABLE CURSOS (
    idcurso NUMBER,
    titulo VARCHAR(30),
    descripcion VARCHAR2(100),
    max_num NUMBER,
    precio NUMBER,
    tipoanimal NUMBER,
    fecha DATE,
    hora DATE,
    lugar VARCHAR2(30),
    instructor NUMBER,
    CONSTRAINT cursos_pk PRIMARY KEY (idcurso),
    CONSTRAINT cursos_empleados_fk FOREIGN KEY (instructor)
        REFERENCES EMPLEADOS(idempleado),
    CONSTRAINT cursos_animales_fk FOREIGN KEY (tipoanimal)
        REFERENCES ANIMALES(tipoanimal));
        
/*Ejercicio 5*/

ALTER TABLE CURSOS
    ADD CONSTRAINT cursos_ck_max_num CHECK (max_num >= 10 AND max_num <= 30);

ALTER TABLE CURSOS  
    ADD CONSTRAINT cursos_ck_fecha CHECK (to_char(fecha, 'dd-mm' )BETWEEN '01-07' AND '30-09');
    
ALTER TABLE CURSOS  
    ADD CONSTRAINT cursos_ck_hora CHECK (to_number(to_char( hora, 'HH24')) >= 15);


/*Ejercicio 6*/

CREATE TABLE MASCOTAS (
    idmascota NUMBER,
    idcliente NUMBER,
    CONSTRAINT mascotas_pk PRIMARY KEY (idmascota),
    CONSTRAINT mascotas_clientes_fk FOREIGN KEY (idcliente)
        REFERENCES CLIENTES(idcliente));
        
/*Ejercicio 7*/

CREATE TABLE CURSOS_CLIENTES (
    idcurso NUMBER,
    idcliente NUMBER,
    CONSTRAINT cucl_pk PRIMARY KEY (idcusos,idcliente),
    CONSTRAINT cucl_cursos_fk FOREIGN KEY (idcurso)
        REFERENCES CURSOS(idcurso),
    CONSTRAINT cucl_cliente_fk FOREIGN KEY (idcliente)
        REFERENCES CLIENTES(idcliente));

/*Ejercicio 9*/

CREATE TABLE ANIMALES
    AS SELECT * FROM V_ANIMALES;
    
ALTER TABLE ANIMALES
    ADD CONSTRAINT animales_pk PRIMARY KEY (tipoanimal);


/*Ejercicio 10*/

CREATE TABLE PEDIDOS
    AS SELECT * FROM V_PEDIDOS;
    
ALTER TABLE PEDIDOS
    ADD CONSTRAINT pedidos_pk PRIMARY KEY (idpedido);
    
CREATE TABLE PRODUCTOS
    AS SELECT * FROM V_PRODUCTOS;
    
ALTER TABLE PRODUCTOS
    ADD CONSTRAINT productos_pk PRIMARY KEY (idproducto);
    
CREATE TABLE PEDIDOS_PRODUCTOS
    AS SELECT * FROM V_PEDIDOS_PRODUCTOS;
    
ALTER TABLE PEDIDOS_PRODUCTOS
    ADD CONSTRAINT pepr_pk PRIMARY KEY (idpedido, idproducto);

/*Ejercicio 11*/
ALTER TABLE PEDIDOS_PRODUCTOS    
    ADD CONSTRAINT pepr_fk FOREIGN KEY (idpedido)
        REFERENCES PEDIDOS(idpedido);

ALTER TABLE PEDIDOS_PRODUCTOS    
    ADD CONSTRAINT pepr_fk FOREIGN KEY (idpedido)
        REFERENCES PEDIDOS(idpedido);

/*Ejercicio 12*/
ALTER TABLE PEDIDOS_PRODUCTOS    
    ADD CONSTRAINT idpedido NOT NULL;

ALTER TABLE PEDIDOS_PRODUCTOS  
    ADD CONSTRAINT idproducto NOT NULL;

/*Ejercicio 13*/

CREATE INDEX idx_animales_tipoanimal ON ANIMALES(tipoanimal);
CREATE INDEX idx_pedidos_idpedido ON PEDIDOS(idpedido);
CREATE INDEX idx_productos_idpedido ON PRODUCTOS(idproducto);
CREATE INDEX idx_pedidos_productos_idpedido ON PEDIDOS_PRODUCTOS(idpedido);
CREATE INDEX idx_pedidos_productos_idproducto ON PEDIDOS_PRODUCTOS(idproducto);

/*Ejercicio 14*/

SELECT *
FROM V_CLIENTES;

SELECT *
FROM CLIENTES;

INSERT INTO CLIENTES
    SELECT idcliente, nombre, apellido, email, direccionpostal, ciudad
    FROM V_CLIENTES;

/* Ejercicio 15: 
Inserta un nuevo cliente en la tabla CLIENTES que Ana María Fernández Morales,
que vive en Plaza del Ayuntamiento, nº 1 de Valencia. Su email amfm@gmail.com y no tiene
teléfono. */
INSERT INTO CLIENTES VALUES ('15','Ana', 'Fernandez Morales', 'amfm@gmail.com', 'Plaza del Ayuntamiento 1', 'Burjassot');


/*
Ejercicio 16: 
El cliente con nombre ‘SARA’ y apellido ‘ALBERTO’ se quiere matricular del curso
con título ‘Como tratar una mascota’. Inserta una tupla en la tabla CURSOS_CLIENTES que dé
cuenta de ello.
NOTA: Se debe insertar la tupla sin consultar el código del cliente y el código del curso. 
Utiliza la sentencia del ejemplo anterior como base.
*/
INSERT INTO MI_CURSOS_CLIENTES (idcurso, idcliente)
SELECT idcurso, (SELECT idcliente
                    FROM MI_CLIENTES
                    WHERE nombre = 'SARA ' AND apellido LIKE 'ALBERTO')
FROM MI_CURSOS
WHERE titulo = 'Como tratar una mascota';

SELECT *
FROM MI_CURSOS_CLIENTES;
/* Ejercicio 17
El curso titulado ‘Higiene de gatos especiales’ no se va a impartir por no llegar al
mínimo número de alumnos necesarios. Borra todas las matrículas de alumnos de ese curso.
¿Cuántas matrículas de alumnos se han borrado?
*/

DELETE FROM MI_CURSOS_CLIENTES
WHERE idcurso = (SELECT idcurso
                    FROM MI_CURSOS
                    WHERE titulo = 'Higiene de gatos especiales');


/* Ejercicio 18
El curso titulado ‘Higiene de gatos especiales’ no se va a impartir por no llegar al
mínimo número de alumnos necesarios. Borra todas las matrículas de alumnos de ese curso.
¿Cuántas matrículas de alumnos se han borrado?
*/


/*Ejercicio 19: Añade dos atributos nuevos a la tabla EMPLEADOS para almacenar información
sobre posibles incentivos salariales por antigüedad.
Para ello se deberá crear un campo que refleje el
número de trienios que tiene y otro campo que indique el aumento salarial.*/

ALTER TABLE EMPLEADOS
    ADD (trienios NUMBER);

ALTER TABLE EMPLEADOS
    ADD (aumento_salarial NUMBER);


/*Ejercicio 20: 
Borra todos los campos extras creados en el ejercicio 19, y en el ejemplo 10.*/
ALTER TABLE EMPLEADOS
    DROP COLUMN aumento_salarial;

/*Ejercicio 21: 
La cliente ‘Ana María Fernández’ ha ejercido su derecho sobre LOPD y desea ser
borrada de nuestra BD. 
Realiza los cambios oportunos en los datos almacenados para dar cuenta de
este hecho.*/


DELETE FROM CLIENTES
WHERE nombre = 'ANA MARÍA' AND apellido LIKE 'FERNÁNDEZ';

/*Ejercicio 22*/

/*Empezamos haciendo la query*/
/*La cantidad de alumnos por cada curso es la subconsulta en el SELECT*/
SELECT idempleado, nombre, apellidos, salario, c.idcurso, (SELECT count(*) 
                                                            FROM cursos_clientes 
                                                            WHERE idcurso = c.idcurso), (SELECT SUM(cc.precio) 
                                                                                        FROM cursos_clientes cc JOIN cursos cc ON 
FROM empleados e JOIN cursos c ON c.instructor = e.idempleado;


/*EXAMEN*/

/* 1 */
CREATE TABLE RESUMEN_PEDIDOS(
    idpedido NUMBER,
    idcliente NUMBER,
    nombre VARCHAR2(50) NOT NULL,
    apellidos VARCHAR2(100) NOT NULL,
    email VARCHAR2(30) CHECK (email like '%@%'),
    importe NUMBER NOT NULL,
    CONSTRAINT resumen_pedidos_pk PRIMARY KEY(idcliente, idpedido),
    CONSTRAINT idpedido_fk  FOREIGN KEY(idpedido)
        REFERENCES PEDIDOS(idpedido),
    CONSTRAINT idcliente_fk FOREIGN KEY(idcliente)
        REFERENCES CLIENTES(idcliente)
    );
     
/*Pedidos del ano anterior al altual*/

SELECT c.idcliente, c.nombre, c.apellido, c.email, p.idpedido, SUM(pp.precioreal*pp.cantidad) AS importe
FROM V_CLIENTES c JOIN (V_PEDIDOS p JOIN V_PEDIDOS_PRODUCTOS pp ON p.idpedido = pp.idpedido) ON p.idcliente = c.idcliente
WHERE to_char(fechapedido, 'YY') ='17'
GROUP BY c.idcliente, c.nombre, c.apellido, c.email, p.idpedido;


SELECT c.idcliente, c.nombre, c.apellidos, c.email, p.idpedido, SUM(pp.precioreal*pp.cantidad) AS importe
FROM V_CLIENTES c JOIN (V_PEDIDOS p JOIN V_PEDIDOS_PRODUCTOS pp ON p.idpedido = pp.idpedido) ON p.idcliente = c.idcliente
WHERE to_char(fechapedido, 'YY') ='17',
GROUP BY c.idcliente, c.nombre, c.apellidos, c.email, p.idpedido;


SELECT p.idpedido, SUM(pp.precioreal*pp.cantidad) AS importe
FROM V_PEDIDOS p JOIN V_PEDIDOS_PRODUCTOS pp ON p.idpedido = pp.idpedido
WHERE to_char(fechapedido, 'YY') ='17' 
GROUP BY p.idpedido;


/*2*/


SELECT *
FROM pedidos;

ALTER TABLE pedidos
    ADD(FPEDIDO DATE);
    
ALTER TABLE pedidos
    ADD(FENTREGA DATE);
    
ALTER TABLE PEDIDOS
    ADD CONSTRAINT chk_fechas CHECK (FENTREGA >= FPEDIDO);

