/*Problema 12*/
SELECT COUNT(idcurso) AS cant_cursos
FROM V_CURSOS
WHERE to_char(fechahora, 'MM') = '08';

/*Problema 13*/
SELECT to_char(fechahora, 'MM') AS mes, COUNT(idcurso) AS cant_curso
FROM V_CURSOS
GROUP BY to_char(fechahora, 'MM');


/*Problema 14*/
SELECT DISTINCT e.nombre, e.apellidos, COUNT(c.idcurso)
FROM V_EMPLEADOS e JOIN V_CURSOS c ON e.idempleado = c.instructor
GROUP BY e.nombre, e.apellidos
HAVING COUNT(c.idcurso) > 3;


/*Problema 15*/
SELECT DISTINCT e.nombre, e.apellidos, e.salario
FROM V_EMPLEADOS e JOIN V_CURSOS c ON e.idempleado = c.instructor
WHERE e.salario > (SELECT DISTINCT AVG(e.salario)
                    FROM V_EMPLEADOS e JOIN V_CURSOS c ON e.idempleado = c.instructor);

/*Problema 16*/
SELECT *
FROM V_PEDIDOS
WHERE to_char(fechaentrega, 'YY') = '17';

/*Problema 17*/
SELECT DISTINCT e.nombre, e.apellidos, e.salario - ( e.salario * .2) AS salario_neto
FROM V_EMPLEADOS e JOIN V_CURSOS c ON e.idempleado = c.instructor
WHERE c.titulo LIKE '%GATOS%' OR c.titulo LIKE '%gatos%';

/*Problema 18*/
SELECT tipoanimal, MIN(precio) AS precio_minimo, MAX(precio) AS precio_maximo, ROUND(AVG(precio)) AS precio_medio 
FROM V_CURSOS
GROUP BY tipoanimal;

/*Problema 19*/
SELECT *
FROM  V_CLIENTES 
WHERE ciudad = 'Burjassot'
ORDER BY apellido, nombre;

/*Problema 20*/
SELECT trabajo, count(nombre) 
FROM V_EMPLEADOS e
WHERE e.salario > (SELECT avg(salario)
                    FROM V_EMPLEADOS)
GROUP BY trabajo;

/*Problema 21*/
SELECT to_char(fechahora, 'MM') AS mes, COUNT(idcurso) AS cant_curso
FROM V_CURSOS
WHERE to_char(fechahora, 'YY') = '17'
GROUP BY to_char(fechahora, 'MM');

/*Problema 22*/
SELECT nombre
FROM V_PROVEEDORES
WHERE idproveedor NOT IN
    (SELECT idproveedor 
     FROM V_PRODUCTOS);
    
/*Problema 23*/
SELECT DISTINCT e.nombre, e.apellidos, COUNT(c.idcurso) AS cursos_impartidos
FROM V_EMPLEADOS e JOIN V_CURSOS c ON e.idempleado = c.instructor
GROUP BY e.nombre, e.apellidos
HAVING COUNT(c.idcurso) > 3;

/*Problema 24*/
SELECT nombre, salario
FROM V_EMPLEADOS
WHERE salario > (SELECT salario FROM V_EMPLEADOS WHERE nombre = 'Jose') 
    AND salario < (SELECT salario FROM V_EMPLEADOS WHERE nombre = 'Clara');

/*Problema 25*/
SELECT nombre, salario
FROM V_EMPLEADOS
WHERE salario > (SELECT salario FROM V_EMPLEADOS WHERE nombre = 'Jose') 
    AND salario < (SELECT MAX(salario) FROM V_EMPLEADOS WHERE email LIKE '%gmail%');
    
/*Problema 26*/
SELECT nombre, salario
FROM V_EMPLEADOS
WHERE salario = (SELECT MAX(salario)
                 FROM V_EMPLEADOS);
                 
/*Problema 27*/
SELECT nombre, salario, trabajo
FROM V_EMPLEADOS emp1
WHERE salario = (SELECT MAX(salario)
                 FROM V_EMPLEADOS emp2
                 WHERE emp1.trabajo = emp2.trabajo
                 GROUP BY trabajo);
            


/*Problema 28*/
SELECT c.nombre, c.direccionpostal, c.ciudad
FROM V_PEDIDOS p JOIN V_CLIENTES c ON p.idcliente = c.idcliente
WHERE p.fechaentrega IS NULL AND p.FECHAPEDIDO < SYSDATE - 15;


/*Problema 29*/
/*Productos Pedidos en mayo 2017*/
SELECT pp.idproducto, pr.descripcion, pr.precio_venta
FROM (V_PEDIDOS p JOIN V_PEDIDOS_PRODUCTOS pp ON p.idpedido = pp.idpedido) JOIN V_PRODUCTOS pr ON pp.idproducto = pr.idproducto 
WHERE to_char(p.fechapedido, 'mm/yyyy') = '05/2017' AND pp.precioreal < pr.precio_venta;


/*Problema 30*/
/*Primero calculo el pedido mas caro*/
SELECT MAX(SUM(pp.cantidad * pp.precioreal))
FROM V_PEDIDOS_PRODUCTOS pp JOIN V_PEDIDOS p ON pp.idpedido = p.idpedido
GROUP BY pp.idpedido;



/*Calculo la compra de cada cliente */
SELECT c.idcliente, SUM(pp.cantidad * pp.precioreal)
FROM V_PEDIDOS_PRODUCTOS pp JOIN (V_PEDIDOS p JOIN V_CLIENTES c ON p.idcliente = c.idcliente) ON pp.idpedido = p.idpedido
GROUP BY c.idcliente, pp.idpedido
HAVING SUM(pp.cantidad * pp.precioreal) = 
    (SELECT MAX(SUM(pp.cantidad * pp.precioreal))
     FROM V_PEDIDOS_PRODUCTOS pp JOIN V_PEDIDOS p ON pp.idpedido = p.idpedido
     GROUP BY pp.idpedido);

/*Problema 31*/

/* Pedidos con comida gatos y comida periquitos*/
SELECT p.idpedido
FROM V_PRODUCTOS pr JOIN (V_PEDIDOS p JOIN V_PEDIDOS_PRODUCTOS pp on p.idpedido = pp.idpedido) ON pr.idproducto = pp.idproducto
WHERE (descripcion LIKE '%Comida Gatos%' OR descripcion LIKE '%Comida Periquitos%') 
AND p.idpedido NOT IN 
    (SELECT p.idpedido
     FROM V_PRODUCTOS pr JOIN (V_PEDIDOS p JOIN V_PEDIDOS_PRODUCTOS pp on p.idpedido = pp.idpedido) ON pr.idproducto = pp.idproducto
     WHERE descripcion LIKE '%Amoxicilina%' )
ORDER BY p.idpedido;


/* Pedidos con amoxicilina */
SELECT p.idpedido
FROM V_PRODUCTOS pr JOIN (V_PEDIDOS p JOIN V_PEDIDOS_PRODUCTOS pp on p.idpedido = pp.idpedido) ON pr.idproducto = pp.idproducto
WHERE descripcion LIKE '%Amoxicilina%'
ORDER BY p.idpedido;

/*Problema 32*/
SELECT c.idcurso
FROM (V_CURSOS_CLIENTES c JOIN V_CLIENTES cl ON c.idcurso = cl.idcurso) JOIN V_CLIENTE 
GROUP BY c.idcurso;



/*EXAMEN*/

/*1*/
SELECT MIN(precio) AS precio_minimo, MAX(precio) AS precio_maximo, ROUND(AVG(precio),2) AS precio_medio 
FROM V_CURSOS;

/*2*/

SELECT cli.idcliente, pe.idpedido, SUM(pepr1.cantidad * pepr1.precioreal) AS importe
FROM V_CLIENTES cli JOIN (V_PEDIDOS pe JOIN V_PEDIDOS_PRODUCTOS pepr1 ON pe.idpedido = pepr1.idpedido) ON cli.idcliente = pe.idcliente
WHERE pepr1.idpedido = (
    SELECT pepr.idpedido
    FROM V_PEDIDOS_PRODUCTOS pepr 
    WHERE pepr1.idpedido = pepr.idpedido
    GROUP BY pepr.idpedido
    HAVING COUNT(pepr.idproducto) > 2)
GROUP BY cli.idcliente, pe.idpedido;

/*Pedidos con mas de 3 o mas productos*/

SELECT pepr.idpedido, COUNT(pepr.idproducto)
FROM V_PEDIDOS_PRODUCTOS pepr 
GROUP BY pepr.idpedido
HAVING COUNT(pepr.idproducto) > 2;

/*3*/
SELECT *
FROM V_CLIENTES cli1
WHERE cli1.idcliente = (SELECT cli.idcliente
FROM V_CURSOS cu JOIN (V_CLIENTES cli JOIN V_CURSOS_CLIENTES cucl ON cli.idcliente = cucl.idcliente) ON cu.idcurso = cucl.idcurso
WHERE cli.ciudad = 'Valencia' AND cli.idcliente = cli1.idcliente
GROUP BY cli.idcliente
HAVING COUNT(cucl.idcurso) > 1);

SELECT cli.idcliente
FROM V_CURSOS cu JOIN (V_CLIENTES cli JOIN V_CURSOS_CLIENTES cucl ON cli.idcliente = cucl.idcliente) ON cu.idcurso = cucl.idcurso
WHERE cli.ciudad = 'Valencia'
GROUP BY cli.idcliente
HAVING COUNT(cucl.idcurso) > 1;
