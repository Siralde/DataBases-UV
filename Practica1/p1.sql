/*Problema 1*/
SELECT *
FROM V_CLIENTES;

/*Problema 2*/
SELECT *
FROM V_CLIENTES
WHERE ciudad='Burjassot';

/*Problema 3*/
SELECT * 
FROM V_PRODUCTOS
WHERE precio_venta > 20 AND stock < 10;

/*Problema 4*/
SELECT nombre, apellido, email AS direcciondeCorreoElectronico
FROM V_CLIENTES
WHERE apellido='GARCÍA';
/*PREGUNTA: Si tienen dos apellidos tambien los coges?*/

/*Problema 5*/
SELECT precio_venta-precio_compra AS beneficio
FROM V_PRODUCTOS;

/*Problema 6*/
SELECT *
FROM V_CLIENTES
WHERE email IS NULL;

/*Problema 7*/
SELECT *
FROM V_CLIENTES
WHERE email LIKE '%uv%';

/*Problema 8*/
SELECT nombremascota AS Nombre_Mascota, ROUND((SYSDATE-fechanac)/365) AS Edad
FROM V_MASCOTAS
WHERE tipoanimal = 1 OR tipoanimal = 2
ORDER BY fechanac DESC;

/*Problema 9*/
SELECT cl.idcliente AS num_cliente, cu.*
FROM V_CURSOS cu JOIN (V_CURSOS_CLIENTES cucl JOIN V_CLIENTES cl ON cucl.idcliente = cl.idcliente) ON cu.idcurso = cucl.idcurso
ORDER BY cl.idcliente;

/*Problema 10*/
SELECT pepr.idpedido
FROM V_PRODUCTOS pr JOIN V_PEDIDOS_PRODUCTOS pepr ON (pr.idproducto = pepr.idproducto AND pr.idproducto=1)


INTERSECT

SELECT pepr.idpedido
FROM V_PRODUCTOS pr JOIN V_PEDIDOS_PRODUCTOS pepr ON (pr.idproducto = pepr.idproducto AND pr.idproducto=2);


/*Problema 11
Encontrar los instructores que no han impartido el curso con código de curso
idcurso = 1
*/

SELECT DISTINCT instructor, emp.nombre, emp.apellidos
FROM V_CURSOS cu JOIN V_EMPLEADOS emp ON cu.instructor = emp.idempleado
WHERE cu.instructor NOT IN (SELECT instructor
                            FROM V_CURSOS
                            WHERE idcurso = 1);

SELECT instructor
FROM V_CURSOS cu 
WHERE cu.instructor NOT IN (SELECT instructor
                            FROM V_CURSOS
                            WHERE idcurso = 1);

SELECT instructor
FROM V_CURSOS
WHERE idcurso = 1;

/*Examen*/

/*1*/
SELECT idproveedor, descripcion, precio_compra, stock
FROM V_PRODUCTOS
WHERE idproveedor=1 AND (stock < 10 OR stock is NULL);

/*2*/
SELECT DISTINCT emp.nombre, emp.apellidos, cu.titulo
FROM V_CURSOS cu JOIN V_EMPLEADOS emp ON cu.instructor=emp.idempleado;

/*3*/
SELECT DISTINCT cl.nombre, cl.apellido
FROM V_CLIENTES cl JOIN V_CURSOS_CLIENTES cucl ON cl.idcliente=cucl.idcliente
ORDER BY cl.apellido, cl.nombre;

