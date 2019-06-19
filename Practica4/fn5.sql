CREATE OR REPLACE FUNCTION fn05
    (xidcli mi_pedidos.idcliente%type, 
    xfechaentrega VARCHAR2,
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
    IF xfechaentrega < SYSDATE THEN 
        RAISE error_fecha;
    END IF;
    
    
    INSERT INTO mi_pedidos VALUES (100, xidcliente, SYSDATE, xfechaentrega, xdirentrega, xemp);
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