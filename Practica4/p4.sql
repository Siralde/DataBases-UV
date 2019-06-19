create table mi_clientes as select * from v_clientes;
create table mi_mascotas as select * from v_mascotas;
create table mi_animales as select * from v_animales;
create table mi_cursos as select * from v_cursos;
create table mi_cursos_clientes as select * from v_cursos_clientes;
create table mi_empleados as select * from v_empleados;
create table mi_pedidos as select * from v_pedidos;
create table mi_pedidos_productos as select * from v_pedidos_productos;
create table mi_productos as select * from v_productos;
create table mi_proveedores as select * from v_proveedores; 





/* Ejemplo 1 */

SET SERVEROUTPUT ON;

DECLARE
 v_salario number;
BEGIN
 select avg(salario) into v_salario from mi_empleados;
 if v_salario > 1000 then
 dbms_output.put_line ('El salario medio de mis empleados NO es milieurista');
 else
 dbms_output.put_line ('El salario medio de mis empleados es milieurista');
 end if;
END; 



/* Ejercicio 1 */

DECLARE
    cant_productos number;
BEGIN
    select count(idproducto) into cant_productos from mi_productos;
    dbms_output.put_line ('La cantidad de productos en stocks es: ' || to_char(cant_productos));
END; 




/* Ejemplo 2b */


CREATE OR REPLACE PROCEDURE PR02 IS
    xparcial number := 0;
    xtotal number := 0;
BEGIN
    select count(*) into xparcial from mi_clientes;
    xtotal := xtotal + xparcial;
    select count(*) into xparcial from mi_mascotas;
    xtotal := xtotal + xparcial;
    select count(*) into xparcial from mi_animales;
    xtotal := xtotal + xparcial;
    select count(*) into xparcial from mi_cursos;
    xtotal := xtotal + xparcial;
    select count(*) into xparcial from mi_cursos_clientes;
    xtotal := xtotal + xparcial;
    select count(*) into xparcial from mi_empleados;
    xtotal := xtotal + xparcial;
    select count(*) into xparcial from mi_pedidos;
    xtotal := xtotal + xparcial;
    select count(*) into xparcial from mi_pedidos_productos;
    xtotal := xtotal + xparcial;
    select count(*) into xparcial from mi_productos;
    xtotal := xtotal + xparcial;
    select count(*) into xparcial from mi_proveedores;
    xtotal := xtotal + xparcial;
    dbms_output.put_line('en total hay ' || to_char(xtotal) ||' registros');
END PR02;

BEGIN
    Pr02;
END;

EXEC Pr02;

CALL Pr02(); 

/* Ejercicio 2 */

CREATE OR REPLACE PROCEDURE PR02A IS
    xparcial number := 0;
    xtotal number := 0;
BEGIN
    select count(*) into xparcial from mi_clientes;
    xtotal := xtotal + xparcial;
    dbms_output.put_line('Clientes: ' || to_char(xparcial) || ' filas');
    select count(*) into xparcial from mi_mascotas;
    xtotal := xtotal + xparcial;
    dbms_output.put_line('Mascotas: ' || to_char(xparcial) || ' filas');
    select count(*) into xparcial from mi_animales;
    xtotal := xtotal + xparcial;
    dbms_output.put_line('Animales: ' || to_char(xparcial) || ' filas');
    select count(*) into xparcial from mi_cursos;
    xtotal := xtotal + xparcial;
    dbms_output.put_line('Cursos: ' || to_char(xparcial) || ' filas');
    select count(*) into xparcial from mi_cursos_clientes;
    xtotal := xtotal + xparcial;
    dbms_output.put_line('Cursos_Clientes: ' || to_char(xparcial) || ' filas');
    select count(*) into xparcial from mi_empleados;
    xtotal := xtotal + xparcial;
    dbms_output.put_line('Empleados: ' || to_char(xparcial) || ' filas');
    select count(*) into xparcial from mi_pedidos;
    xtotal := xtotal + xparcial;
    dbms_output.put_line('Pedidos: ' || to_char(xparcial) || ' filas');
    select count(*) into xparcial from mi_pedidos_productos;
    xtotal := xtotal + xparcial;
    dbms_output.put_line('Pedidos_Productos: ' || to_char(xparcial) || ' filas');
    select count(*) into xparcial from mi_productos;
    xtotal := xtotal + xparcial;
    dbms_output.put_line('Productos: ' || to_char(xparcial) || ' filas');
    select count(*) into xparcial from mi_proveedores;
    xtotal := xtotal + xparcial;
    dbms_output.put_line('en total hay ' || to_char(xtotal) ||' registros');
END PR02A;

BEGIN
    PR02A;
END;



/* Ejemplo 3 */

CREATE OR REPLACE PROCEDURE PR03 IS
BEGIN
    UPDATE mi_productos
    SET precio_compra = precio_compra * 0.95
        WHERE idproveedor =
            (SELECT idproveedor FROM mi_proveedores
            WHERE nombre LIKE 'ProdAnimal%');
    COMMIT;
    dbms_output.put_line ('Se ha realizado el commit');
EXCEPTION
    when others then
        rollback;
        dbms_output.put_line ('No se ha realizado el commit');
END PR03;

BEGIN
    PR03;
END;



/* Ejercicio 3 */
CREATE OR REPLACE PROCEDURE PR03A IS
BEGIN
    DELETE FROM mi_proveedores
        WHERE idproveedor NOT IN 
        (SELECT DISTINCT p.idproveedor
         FROM MI_PROVEEDORES p JOIN MI_PRODUCTOS pr 
            ON p.idproveedor = pr.idproveedor);
    COMMIT;
    dbms_output.put_line ('Se ha realizado el commit y se ha elimado los proveedores');
EXCEPTION
    when others then
        rollback;
        dbms_output.put_line ('No se ha realizado el commit');
END PR03A;

BEGIN
    PR03A;
END;


/* Ejercicio 4a*/
CREATE OR REPLACE PROCEDURE pr04
    (xcodcurs IN mi_cursos_clientes.idcurso%type, xtotal IN OUT number) IS
BEGIN
 SELECT count(idcliente) INTO xtotal
 FROM mi_cursos_clientes where idcurso = xcodcurs;
 dbms_output.put_line ('Alumnos inscritos: ' || xtotal);
END pr04;

DECLARE
    xcodcurs mi_cursos_clientes.idcurso%type := 2;
    xtotal number;
BEGIN
    PR04(xcodcurs, xtotal);
    dbms_output.put_line ('TOTAL: ' || xtotal);
END;
/* 
1. ¿Por qué usamos una variable "OUT"? 
    Se utiliza para obtener el conteo de los clientes y para devolver el resultado de la funcion
Cambia el tipo de parámetro y prueba el código. ¿Qué ocurre? 
    Si lo cambiamos a IN no se nos devuelve el resultado ya que sobre las variables de lectura no se puede guardar informacion solo leer
    (expression 'XTOTAL' cannot be used as an INTO-target of a SELECT/FETCH statement)
    Si lo cambiamos a IN OUT funciona tanto como de lectura y escritura 
*/


/*
2. ¿Qué ocurre si ejecutamos el procedimiento para un código de curso que no existe? 
    Devuelve el valor de salida a 0
*/
DECLARE
    xcodcurs mi_cursos_clientes.idcurso%type := 100;
    xtotal number;
BEGIN
    PR04(xcodcurs, xtotal);
    dbms_output.put_line ('TOTAL: ' || xtotal);
END;
/*
    ¿Es correcto el codigo es correcto? 
        En este caso depende de lo que se quiera, se podria implementar una excepcion
*/


/*
Añade el tratamiento de excepciones de forma adecuada. 
*/

create or replace PROCEDURE pr04excp
(xcodcurs IN mi_cursos_clientes.idcurso%type, xtotal OUT number) IS
    no_hay_cursos EXCEPTION;
    no_hay_clientes EXCEPTION;
    existe_curso NUMBER;
BEGIN
    SELECT count(idcurso) INTO existe_curso
        FROM mi_cursos where idcurso = xcodcurs;

    IF existe_curso > 0 THEN
        SELECT count(idcliente) INTO xtotal
            FROM mi_cursos_clientes WHERE idcurso = xcodcurs;
        IF xtotal <= 0 THEN
            RAISE no_hay_clientes;
        ELSE
            dbms_output.put_line ('Alumnos inscritos: ' || xtotal);
        END IF;
    ELSE 
        RAISE no_hay_cursos;
    END IF;
    
 EXCEPTION
    WHEN no_hay_cursos THEN
        dbms_output.put_line ('No hay cursos con ese codigo');
    WHEN no_hay_clientes THEN
        dbms_output.put_line ('No hay clientes');
    WHEN OTHERS THEN
        dbms_output.put_line ('Se produjo una excepcion');
END pr04excp;

DECLARE
    xcodcurs mi_cursos_clientes.idcurso%type := 1000;
    xtotal number;
BEGIN
    PR04excp(xcodcurs, xtotal);
END;
/*

¿Es entonces correcto el código anterior?
*/




/* Ejercicio 4b */

CREATE OR REPLACE FUNCTION fn04 (xcodcurs mi_cursos_clientes.idcurso%type) 
RETURN number IS
    xtotal number;
BEGIN
    SELECT count(idcliente) INTO xtotal
        FROM mi_cursos_clientes 
        WHERE idcurso = xcodcurs;
    RETURN xtotal;
END fn04;


select idempleado, fn04(idempleado) as cursos from mi_empleados; /*Poner en Universidad WorkSheet*/

/* Ejercicio 5 */

create or replace FUNCTION fn05
    (xidcli mi_pedidos.idcliente%type, 
    xfechaentrega mi_pedidos.fechaentrega%type,
    xdirentrega mi_pedidos.direccionentrega%type,
    xemp mi_pedidos.empleadoventa%type,
    xproducto mi_productos.idproducto%type,
    xcantidad mi_pedidos_productos.cantidad%type,
    xpvpreal mi_pedidos_productos.precioreal%type) return number is
    
    hoy DATE := SYSDATE;
    wcliente number;
    wempventa number;
    wstock number;
    wproducto number;
    error_cliente exception;
    error_empleado exception;
    error_producto exception;
    error_stock exception;
    error_fecha exception;
BEGIN
    select count ( * ) into wcliente 
        from mi_clientes
        where idcliente = xidcli;
    select count ( * ) into wempventa 
        from mi_empleados
        where idempleado = xemp;
    select stock into wstock 
        from mi_productos
        where idproducto=xproducto;
    if wcliente= 0 then --excepcion de cliente
        raise error_cliente;
    end if ;
    if wempventa = 0 then --excepcion de empleado inexistente
        raise error_empleado;
    end if ;
    if wproducto = 0 then -- excepción de producto
        raise error_producto;
    end if;
    if wstock < xcantidad then --excepción de stock
        raise error_stock;
    end if;
    IF xfechaentrega < hoy THEN 
        RAISE error_fecha;
    END IF;


    INSERT INTO mi_pedidos VALUES (100, xidcli, hoy, xfechaentrega, xdirentrega, xemp);
    INSERT INTO mi_pedidos_productos VALUES (100, xproducto, xcantidad, xpvpreal);

    commit;
    dbms_output.put_line( 'Pedido grabado correctamente en el sistema') ;
    return 1;


    EXCEPTION
    when error_cliente then
        dbms_output.put_line('Error- 1: El cliente no existe. Primero debe registrarse en el sistema' ) ; 
    return - 1;
    when error_producto then
        dbms_output.put_line('Error - 2: Producto desconocido o inexistente' );
    return - 2;
    when error_stock then
        dbms_output.put_line('Error -3: Fecha de entrega anterior a fecha pedido');
    return - 3;
    when error_fecha then
        dbms_output.put_line('Error -4: Fecha de entrega anterior a fecha pedido');
    return - 4;
    WHEN OTHERS THEN
        dbms_output.put_line ('Error - 10: error no conocido');
        dbms_output.put_line ('Error Oracle'|| TO_CHAR( SQLCODE)|| 'Mensaje: '||SUBSTR (SQLERRM, 1, 200));
        ROLLBACK;
    return - 10;
END fn05;

/* Opcion 1 */
DECLARE
    XIDCLI NUMBER;
    XFECHAENTREGA DATE;
    XDIRENTREGA VARCHAR2(40);
    XEMP NUMBER;
    XPRODUCTO NUMBER;
    XCANTIDAD NUMBER;
    XPVPREAL NUMBER;
    v_Return NUMBER;
    Valor NUMBER;
BEGIN
    XIDCLI := 1; XFECHAENTREGA := TO_DATE('01/12/2020', 'DD/MM/YYYY'); XDIRENTREGA := 'nada';
    XEMP := 2; XPRODUCTO := 5; XCANTIDAD := 8; XPVPREAL := 10.2;
    
    
    
    Valor := FN05 (XIDCLI, XFECHAENTREGA, XDIRENTREGA, XEMP, XPRODUCTO,
    XCANTIDAD, XPVPREAL);
    DBMS_OUTPUT.PUT_LINE(' Valor = '||valor);
END;

/*
Opción 2
Que es FROM DUAL
*/
SELECT FN05(1, TO_DATE('01/12/2020', 'DD/MM/YYYY'), 'ALDEMARO LAND', 2, 5, 8, 10.2) FROM DUAL;


/* Ejercicio 6 */

CREATE OR REPLACE PROCEDURE pr10 (
    id_emp IN mi_empleados.idempleado%type,
    nombre_emp IN mi_empleados.nombre%type,
    apellidos_emp IN mi_empleados.apellidos%type,
    email_emp IN mi_empleados.email%type,
    direccion_emp IN mi_empleados.direccion%type,
    telefono_emp IN mi_empleados.telefono%type,
    trabajo_emp IN mi_empleados.trabajo%type,
    salario_emp IN mi_empleados.salario%type,
    exito OUT number) IS
BEGIN
    INSERT INTO mi_empleados 
        VALUES (id_emp, nombre_emp, apellidos_emp, email_emp, direccion_emp, telefono_emp, trabajo_emp, salario_emp);

    DBMS_OUTPUT.PUT_LINE('Si se introdujo el nuevo empleado');

    exito := 1;

    EXCEPTION
        WHEN OTHERS THEN 
            DBMS_OUTPUT.PUT_LINE('Se produjo una excepcion');
END pr10;


/*Ejercicio 7 */ 

create or replace PROCEDURE pr10mod (
    id_emp IN mi_empleados.idempleado%type,
    nombre_emp IN mi_empleados.nombre%type,
    apellidos_emp IN mi_empleados.apellidos%type,
    email_emp IN mi_empleados.email%type,
    direccion_emp IN mi_empleados.direccion%type,
    telefono_emp IN mi_empleados.telefono%type,
    trabajo_emp IN mi_empleados.trabajo%type,
    salario_emp IN mi_empleados.salario%type,
    exito OUT number) IS
    
    num_emp mi_empleados.idempleado%type;
BEGIN

    SELECT count(*) INTO num_emp
        FROM mi_empleados e
        WHERE nombre_emp = e.nombre AND apellidos_emp = e.apellidos;

    IF num_emp > 0 THEN 
        DELETE FROM mi_empleados e
            WHERE nombre_emp = e.nombre AND apellidos_emp = e.apellidos;
    END IF;

    INSERT INTO mi_empleados 
        VALUES (id_emp, nombre_emp, apellidos_emp, email_emp, direccion_emp, telefono_emp, trabajo_emp, salario_emp);

    DBMS_OUTPUT.PUT_LINE('Si se introdujo el nuevo empleado');

    exito := 1;

    EXCEPTION
        WHEN OTHERs THEN 
            DBMS_OUTPUT.PUT_LINE('Se produjo una excepcion');
            exito := 0;
END pr10mod;