/* Ejercicio 1 */

DECLARE
    cant_productos number;
BEGIN
    select count(idproducto) into cant_productos from mi_productos;
    dbms_output.put_line ('La cantidad de productos en stocks es: ' || to_char(cant_productos));
END; 

