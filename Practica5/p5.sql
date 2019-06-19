

/*SET SERVEROUTPUT ON*/


/* Ejemplo 6a */ 

DECLARE
    CURSOR c1 IS
        SELECT idcurso, titulo, precio, TO_CHAR (fechahora, 'MONTH') mes
        FROM v_cursos
        WHERE TO_CHAR (fechahora, 'YYYY') = 2017
        ORDER BY fechahora;
    m_fecha varchar2 (100) := 'S/M';
    v_idcurso v_cursos.idcurso%type;
    v_titulo v_cursos.titulo%type;
    v_precio v_cursos.precio%type;
    v_mes varchar2(100);
 BEGIN
    OPEN c1;
    DBMS_OUTPUT.put_line ('Listado de cursos por fechas:');
    LOOP
        EXIT WHEN c1%NOTFOUND;
        FETCH C1 into v_idcurso, v_titulo, v_precio, v_mes;
        IF v_mes <> m_fecha THEN
            m_fecha := v_mes;
            DBMS_OUTPUT.put_line (' ');
            DBMS_OUTPUT.put_line ('Cursos del mes de ' || v_mes);
            DBMS_OUTPUT.put_line ('============================');
        END IF;
        DBMS_OUTPUT.put (v_idcurso || ': ' || v_titulo || '(');
        DBMS_OUTPUT.put_line (v_precio || ' euros).');
    END LOOP;
    CLOSE c1;
    EXCEPTION
        WHEN OTHERS THEN
        DBMS_OUTPUT.put_line ('Error: ' || SQLCODE || ': ' || SQLERRM);
END;


/* Ejemplo 6b */ 


DECLARE
    CURSOR c1 IS
        SELECT idcurso, titulo, precio, TO_CHAR (fechahora, 'MONTH') mes
        FROM v_cursos
        WHERE TO_CHAR (fechahora, 'YYYY') = 2017
        ORDER BY fechahora;
    m_fecha varchar2 (100) := 'S/M';
BEGIN
    DBMS_OUTPUT.put_line ('Listado de cursos por fechas:');
    FOR reg IN c1 LOOP
        IF reg.mes <> m_fecha THEN
            m_fecha := reg.mes;
            DBMS_OUTPUT.put_line (' ');
            DBMS_OUTPUT.put_line ('Cursos del mes de ' || reg.mes);
            DBMS_OUTPUT.put_line ('============================');
        END IF;
            DBMS_OUTPUT.put (reg.idcurso || ': ' || reg.titulo || '(');
            DBMS_OUTPUT.put_line (reg.precio || ' euros).');
    END LOOP;
    
    EXCEPTION
    
        WHEN OTHERS THEN
        DBMS_OUTPUT.put_line ('Error: ' || SQLCODE || ': ' || SQLERRM);
END;



/* Ejercicio 7 */

DECLARE
    cursor c1 is
        select tipoanimal, count(*), avg(precio)
        from mi_cursos
        group by tipoanimal;
    xtotal_cursos number;
    xtipoanimal mi_cursos.tipoanimal%type;
    xcuenta_curso_animal number;
    xprecio_medio_curso_animal number;
    total_porcentaje number; 
BEGIN
    SELECT count(*) into xtotal_cursos 
        FROM mi_cursos;
    
    dbms_output.put_line(rpad('TipoAnimal', 10,' ') || rpad('Curso', 10,' ') || 
    rpad('Porcentaje', 10,' ') || rpad('Precio', 10,' '));
    
    OPEN C1;
    LOOP
        exit when c1%NOTFOUND;  --se trata los datos recuperados
        FETCH C1 into xtipoanimal, xcuenta_curso_animal, xprecio_medio_curso_animal;
        
        total_porcentaje:= xcuenta_curso_animal/xtotal_cursos*100;
        
        dbms_output.put_line(rpad(xtipoanimal,10,' ')
        ||lpad(to_char(xcuenta_curso_animal,'999999'),10,' ') ||
        lpad(to_char(total_porcentaje,'99999.99'),10,' ') ||
        lpad(to_char(xprecio_medio_curso_animal,'999999'),10,' '));
    END LOOP;
    CLOSE c1;

EXCEPTION
    WHEN OTHERS THEN
    dbms_output.put_line('Error -10: error no conocido');
    dbms_output.put_line('Error Oracle ' || TO_CHAR(SQLCODE) ||
    'Mensaje: ' || SUBSTR(SQLERRM, 1, 200));
END; 



/*Ejercicio 9*/

/* Anadir a la tabla empleados fecha_nac y actualizar sus valores
ALTER TABLE mi_empleados
        ADD fechanac date;
        
SELECT *
FROM mi_empleados;

UPDATE mi_empleados 
    SET fechanac = to_date( '01/01/1998', 'dd/mm/yyyy') + ROWNUM;

*/


/* Query para obtener al instructor con menor numero de cursos y fecha de nacimiento

SELECT e.idempleado, COUNT(c.idcurso), e.fechanac
FROM mi_empleados e JOIN mi_cursos c ON e.idempleado = c.instructor
GROUP BY e.idempleado, e.fechanac
ORDER BY COUNT(c.idcurso), e.fechanac;

*/

CREATE OR REPLACE PROCEDURE ej9 (
    id_curso IN mi_cursos.idcurso%type,
    titulo_curso IN mi_cursos.titulo%type,
    descripcion_curso IN mi_cursos.descripcion%type,
    maxnum_curso IN mi_cursos.max_num%type,
    precio_curso IN mi_cursos.precio%type,
    tipoanimal_curso IN mi_cursos.tipoanimal%type,
    fechahora_curso IN mi_cursos.fechahora%type,
    lugar_curso IN mi_cursos.lugar%type ) IS
    
    instructor_curso mi_cursos.instructor%type;
    insertado_dentro_bucle number;
    titulo mi_cursos.titulo%type;

    CURSOR C1 IS 
        SELECT titulo FROM mi_cursos;

    CURSOR C3 IS SELECT e.idempleado
        FROM mi_empleados e JOIN mi_cursos c ON e.idempleado = c.instructor
        GROUP BY e.idempleado, e.fechanac
        ORDER BY COUNT(c.idcurso), e.fechanac;


BEGIN

    insertado_dentro_bucle := 0;

    /* Obtengo al instructor con menor numero de cursos y fecha de nacimiento */

    FOR item IN C3 LOOP
        instructor_curso := item.idempleado;
        EXIT;
    END LOOP;

    /*  Modifica el procedimiento de tal forma que si ya existe el curso 
        (es decir, si existe con el mismo nombre), 
        borre sus datos e introduzca de nuevo sus datos modificados.
    */
    
    FOR item IN C1 LOOP
        
        IF item.titulo = titulo_curso THEN
            
            insertado_dentro_bucle := 1;
            
            DELETE 
                FROM mi_cursos c 
                WHERE c.titulo = item.titulo;

            INSERT INTO mi_cursos(idcurso, titulo, descripcion, max_num, precio, tipoanimal, fechahora, lugar, instructor) 
                VALUES (id_curso, titulo_curso, descripcion_curso, maxnum_curso, precio_curso, 
                        tipoanimal_curso, fechahora_curso, lugar_curso, instructor_curso);
            
            DBMS_OUTPUT.PUT_LINE('Se elimno el mismo curso con el mismo nombre y se anadio correctamente');
                
            EXIT;
        END IF;
    END LOOP;
    

    IF insertado_dentro_bucle = 0 THEN
        
        INSERT INTO mi_cursos(idcurso, titulo, descripcion, max_num, precio, tipoanimal, fechahora, lugar, instructor)
            VALUES (id_curso, titulo_curso, descripcion_curso, maxnum_curso, precio_curso, 
            tipoanimal_curso, fechahora_curso, lugar_curso, instructor_curso);
        
        DBMS_OUTPUT.PUT_LINE('Se anadio correctamente');
        
    END IF;

    EXCEPTION
        WHEN OTHERS THEN 
            DBMS_OUTPUT.PUT_LINE('Error -10: error no conocido');
            DBMS_OUTPUT.PUT_LINE('Error Oracle ' || TO_CHAR(SQLCODE) || 'Mensaje: ' || SUBSTR(SQLERRM, 1, 200));
END ej9;

/*Ejercicio 10*/

/* Calculamos pedidos pendientes */

select *
FROM mi_pedidos
WHERE fechaentrega IS NULL;

/* Calculamos el precio promedio de los pedidos pendintes */ 
select pe.idpedido, pe.idcliente,SUM(pepr.cantidad * pepr.precioreal) AS IMPORTE
FROM mi_pedidos pe JOIN mi_pedidos_productos pepr ON pe.idpedido = pepr.idpedido
WHERE pe.fechaentrega IS NULL
GROUP BY pe.idpedido, pe.idcliente;

SELECT ROUND(AVG(SUM(CANTIDAD*PRECIOREAL)), 2)
FROM MI_PEDIDOS p JOIN MI_PEDIDOS_PRODUCTOS pp ON p.idpedido = pp.idpedido
WHERE p.fechaentrega IS NULL
GROUP BY p.idpedido;


CREATE OR REPLACE PROCEDURE ej10 () IS
    
    id_cliente mi_clientes.idcliente%type;
    nombre_cliente mi_clientes.nombre%type;
    apellido_cliente mi_clientes.apellido%type;
    id_pedido mi_pedidos.idpedido%type;

    media number;
        
    CURSOR C1(round) IS 
        SELECT cl.idcliente, cl.nombre, cl.apellido, p.idpedido
            FROM mi_clientes cl JOIN mi_pedidos p ON cl.idcliente = p.idcliente
                JOIN mi_pedidos_productos pepr ON p.idpedido=pepr.idpedido
            WHERE pepr.cantidad*pepr.precioreal < round;
BEGIN
    
    SELECT ROUND(AVG(SUM(CANTIDAD*PRECIOREAL)), 2) INTO media
        FROM MI_PEDIDOS p JOIN MI_PEDIDOS_PRODUCTOS pp ON p.idpedido = pp.idpedido
        WHERE p.fechaentrega IS NULL
        GROUP BY p.idpedido;
    
    OPEN C1(media);
    LOOP
        EXIT WHEN c1%NOTFOUND; 
        FETCH C1 INTO id_cliente, nombre_cliente, apellido_cliente, id_pedido;
        DBMS_OUTPUT.PUT_LINE('Cliente: ' || '(' || id_cliente || ') ' || nombre_cliente || ' ' || apellido_cliente || '. Pedido: ' || id_pedido);
    END LOOP;
    CLOSE c1;
    
    EXCEPTION
        WHEN OTHERS THEN 
            DBMS_OUTPUT.PUT_LINE('Error -10: error no conocido');
            DBMS_OUTPUT.PUT_LINE('Error Oracle ' || TO_CHAR(SQLCODE) || 'Mensaje: ' || SUBSTR(SQLERRM, 1, 200));
END ej10;


/*Ejercicio 12*/


/*
 * Anadir un atributo a la tabla CURSOS_CLIENTES y actualizar con el precio real que deberia pagar
 */

ALTER TABLE CURSOS_CLIENTES 
    ADD precio NUMBER;


CREATE OR REPLACE PROCEDURE ej12 () IS
    


    /*SACAMOS LA VARIABLE CLIENTE CON PEDIDOS PENDIENTES POR SERVIR*/        
    CURSOR C1 IS 
        SELECT cl.idcliente
            FROM mi_clientes cl JOIN mi_pedidos p ON cl.idcliente = p.idcliente
                JOIN mi_pedidos_productos pepr ON p.idpedido=pepr.idpedido
            WHERE pepr.cantidad*pepr.precioreal >= 50 AND (SYSDATE-p.fechapedido) <= 30;

    /*SACAMOS LOS PEDIDOS PARA CAMBIARLE EL PRECIO */
    CURSOR C2(idcliente) 


    /*Hayar que clientes tengan mas de un curso*/
    CURSOR C3 IS 
        SELECT idcliente 
        FROM mi_cursos_clientes 
        GROUP BY idcliente
        HAVING COUNT(idcliente) > 1;


    clienteID cursosclientes.idcliente%type;

    UPDATE CURSOS_CLIENTE 
        SET precio = precio * 0,85  
        WHERE idcliente = clienteID 
            AND idcurso  = (SELECT mi)


BEGIN
    

    EXCEPTION
        WHEN OTHERS THEN 
            DBMS_OUTPUT.PUT_LINE('Error -10: error no conocido');
            DBMS_OUTPUT.PUT_LINE('Error Oracle ' || TO_CHAR(SQLCODE) || 'Mensaje: ' || SUBSTR(SQLERRM, 1, 200));
END ej12;



/*Ejercicio 14: 
Realiza un procedimiento/función PL/SQL al que se le pase como parámetro el nombre de un cliente 
Muestre información de cada uno de los pedidos realizados, indicando que productos
incluye ese pedido, cuánto costó cada producto del pedido, la cantidad de ese producto en el pedido
y el precio total. Se le puede pasar también un periodo de tiempo, de forma que muestre solo esos
pedidos. Se muestra un ejemplo de ejecución:*/

CREATE OR REPLACE PROCEDURE ej14 (nombre_cliente IN mi_clientes.nombre%type, apellido_cliente IN mi_clientes.apellido%type, fecha_minima IN DATE, fecha_maxima IN DATE) IS
    
    id_cliente mi_clientes.idcliente%type;
    numero_pedidos number;
    precio_pedido number;
    precio_todos_pedidos number;
    
    /*Pedidos realizados por cada cliente*/        
    CURSOR C1(idcliente mi_clientes.idcliente%type) IS 
        SELECT p.idpedido
            FROM mi_pedidos p 
            WHERE p.fechapedido BETWEEN fecha_minima AND fecha_maxima;
    
    CURSOR C2(idpedido mi_pedidos.idpedidos%type) IS
        SELECT p.descripcion, pp.cantidad, pp.precioreal, (pp.cantidad * pp.precioreal) AS total
            FROM mi_pedidos_productos pp JOIN mi_pedidos p ON pp.idproducto = p.idproducto
            WHERE pp.idpedido = idpedido;

BEGIN
    numero_pedidos := 0;
    precio_pedido := 0;
    
    DBMS_OUTPUT.PUT_LINE('Pedidos de' || nombre_cliente || ' ' apellido_cliente || 'entre el ' || fecha_minima || ' al ' || fecha_maxima);
    DBMS_OUTPUT.PUT_LINE('Nombre Producto Precio Unitario Cantidad Total');
    
    SELECT idcliente INTO id_cliente
        FROM mi_clientes
        WHERE nombre = nombre_cliente AND apellido = apellido_cliente;
        
    FOR cliente IN c1(id_cliente) LOOP
        
        numero_pedido := numero_pedido + 1;
        DBMS_OUTPUT.PUT_LINE('Pedido Numero ' || numero_pedido);
        
        FOR pedido IN c2(cliente.idpedido)
            precio_pedido := precio_pedido + pedido.total;
            DBMS_OUTPUT.PUT_LINE(pedido.descripcion ||'   '|| pedido.precioreal || '   ' || pedido.cantidad || '   ' || pedido.total);
        END LOOP
            DBMS_OUTPUT.PUT_LINE('Precio Pedido: ' || precio_pedido);
            
        /*
            Pedidos de Juan Martínez entre el 01/02/2012 al 31/03/2012:
            Nombre Producto Precio Unitario Cantidad Total
            Código 1:
            Comida Loros 30,0 3 90
            Comida Perros 22,0 1 22,0
            Precio Pedido: 112,0
            Código 2:
            Comida Loros 30,0 2 60
            Precio Pedido: 60
            Total pedidos: 150 euros
        */
    END LOOP;
    
    
    EXCEPTION
        WHEN OTHERS THEN 
            DBMS_OUTPUT.PUT_LINE('Error -10: error no conocido');
            DBMS_OUTPUT.PUT_LINE('Error Oracle ' || TO_CHAR(SQLCODE) || 'Mensaje: ' || SUBSTR(SQLERRM, 1, 200));
END ej14;


DECLARE
    xnombre_cliente mi_clientes.nombre%type;
    xapellido_cliente mi_clientes.apellido%type;
    xfecha_minima DATE;
    xfecha_maxima DATE;
BEGIN

    xfecha_minima := TO_DATE('27/04/2016');
    xfecha_max := SYSDATE;
    
    xnombre_cliente := 'JUAN';
    xapellido_cliente := 'LÓPEZ';
    
     Valor := FN05 (XIDCLI, XFECHAENTREGA, XDIRENTREGA, XEMP, XPRODUCTO,
     XCANTIDAD, XPVPREAL);
     DBMS_OUTPUT.PUT_LINE(' Valor = '||valor);
END;

