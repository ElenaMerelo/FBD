Creamos primero el directorio FBD en :U para que no se me borre al apagar el ordenador, y me meto dentro de �l con `cd u:\FBD`, o si no, cada vez que quiera ejecutar algo, por ejemplo fichero.sql, tendría que poner `@U:\FBD\fichero.sql`, equivalente a `start U:\FBD\fichero.sql`.
Luego creamos la tabla `prueba1`:
~~~sql
create table prueba1(cad char(3),
n int,
xfloat);
~~~

+ Para ver que se ha creado correctamente basta con poner `describe prueba1`. Para ver todas las tablas que hemos creado hemos de
escribir `select table_name from user_tables;`

Luego hemos creado otras tablas en archivos de extensión `.sql`, para ejecutarlos hacemos `@nombre.sql`.

+ Para borrar una tabla: `drop prueba1`

+ Para modificar el esquema de la tabla plantilla añadiendo un nuevo atributo llamado fechabaja de tipo date (ejer 2.6): `alter
table plantilla add (fechabaja date);`

Explicación del profesor en clase. Herramientas para hacer consultas:
+ select == pi (proyección). Si ponemos `select distinct` no pone las tablas duplicadas
+ from == x (poducto cartesiano)
+ where == sigma (selección)

Ejemplo: `select codpro from proveedor where ciudad= 'Londres'` para ver los proveedores que son de Londres.

Para conjuntos: union (all si queremos que nos muestre los elementos que están más de una vez), minus, intersect, select.
Si no queremos proyectar ponemos asterisco: `select *` .
Más ejemplos:

+ Ventas que tienen algún proveedor: `select * from ventas v, ventas v2 where v.codpro= 'si';`

+ `select * from proveedor order by ciudad desc;` para dar un criterio de ordenación a las tuplas, si las queremos en orden por ciudad descendente.
+ `select * from proveedor order by ciudad, status;` ordena por ciudad, si hay igualdad mira status.

Por defecto  se ordena ascendentemente.

Tipo de dato fecha: `to_date(cadena, formato)` por ejemplo `cadena= '22/07/2018'`, `formato= 'dd/mm/yyyy'`, pasa la fecha a un
formato que él entiende. `to_char(fecha, formato)` hace lo contrario.
`select sysdate from dual` nos la fecha del día en el formato por defecto del sistema. `select to_char(sysdate, 'yyyy') from dual`
nos dice el año en el que estamos.

Es muy habitual que cometamos el error de comparar en el dominio de las cadenas, y eso a veces puede no funcionar. Si vamos
a comparar fechas, lo hacemos en el dominio de las fechas.

+ `select sysdate-to_date('23/06/1998' 'DD/MM/YYYY') from dual;` dice los días que hace desde que nací.
+ `select (sysdate-to_date('23/06/1998', 'dd/mm/yyyy'))/365 from dual;` dice los años que tengo.

sql convierte la aritmética de fechas en aritmética real.

`select sysdate from ventas` por cada tupla de ventas me saca lo que he puesto en el select, me repite la fecha del sistema tantas
veces como tuplas haya.

`select cantidad*3-5 from ventas` multiplica cantidad de la tabla ventas por 3, le resta 5.

`select nompro, codpie, cantidad from ventas.proveedor where ventas.codpro=proveedor.codpro`

Fin de la Explicación del profesor en clase. Continuamos en el cuaderno de prácticas.


Utilizando la sentencia `ALTER TABLE`, descrita anteriormente, vamos a modificar el esquema de la tabla Ventas añadiendo un nuevo atributo llamado fecha de tipo date.

**Ejercicio 2.7**. Comprobar que se ha cambiado correctamente el esquema de la tabla Ventas.
Para añadir la nueva fila escribimos `alter table ventas add(fecha date);` y para ver si se ha hecho correctamente simplemente escribimos `describe ventas`.

> El * equivale a proyectar sobre todos los atributos de las tablas relacionadas en al cláusula FROM.

**Ejercicio 2.8** Ejecuta la sentencia SELECT para mostrar el contenido de las tablas PRUEBA2 y PLANTILLA. Intenta mostrar sólo algunos campos de las mismas:
~~~SQL
select * from prueba2;
select cad1 from prueba2;

select * from plantilla;
select fechaalta from plantilla;
~~~

Para modificar los datos de una tabla introducidos con anterioridad, hemos de utilizar la sentencia `UPDATE`, cuya forma general es la siguiente:
~~~SQL
UPDATE nombre_tabla
SET nombre_atributo = nuevovalor
[, nombre_atributo2 = nuevovalor2...]
[WHERE  <condicion> ];
~~~

*Ejemplo 2.4* Ejecuta la sentencia UPDATE sobre la tabla plantilla y cambia el estado civil de Juan a divorciado
~~~sql
update plantilla
set estadocivil = 'divorciado'
where nombre='Juan';
~~~

**Ejercicio 2.9** Ejecuta la sentencia UPDATE sobre la tabla plantilla y cambia el nombre del trabajador con dni 12345678 a 'Luis'.

`update plantilla set nombre= 'Luis' where dni= '12345678';`

La instrucción `DELETE` se utiliza para eliminar tuplas de una tabla. Las tuplas que se
eliminan son aquellas que hacen cierta la expresión <condicion>. Su sintaxis es la siguiente:
`DELETE [FROM] nombre_tabla [WHERE <condicion>];`

*Ejemplo 2.5* Borra todas las tuplas de la tabla prueba2.
`DELETE FROM prueba2`

**Ejercicio 2.10** Borra todas las tuplas de la tabla plantilla.
`DELETE FROM plantilla;`
`DELETE FROM serjefe;`

No podemos borrar todas las tuplas de la tabla plantilla ya que la tabla serjefe la referencia.

*Ejemplo 2.6* Ejecuta la sentencia UPDATE sobre la tabla plantilla y cambia la fecha de alta de Juan al día siguiente.
~~~SQL
UPDATE plantilla
SET fechaalta = fechaalta+1
WHERE nombre='Juan';
~~~

Introducción de fechas mediante la función TO_DATE:

Con esta función se genera un valor de tipo date a partir del valor suministrado por la primera cadena pasada a la función usando como formato la segunda cadena proporcionada. Un ejemplo de uso es el siguiente:
~~~SQL
insert into plantilla
values ('11223355','Miguel','casado',
TO_DATE('22/10/2005','dd/mm/yyyy'),null);
~~~

Mostrar fechas mediante la función TO_CHAR:
Para la recuperación de datos de tipo fecha en un formato concreto, la función que debe utilizarse es `TO_CHAR`, que transforma un valor de fecha (en su formato interno) a una cadena de caracteres imprimible según el formato fecha especificado.

*Ejemplo 2.7*
`select TO_CHAR(fechaalta,'dd-mon-yyyy') from plantilla;`

Para introducir todas las tuplas de una tabla que ya existe y
está creada otra nuestra, ambas con el mismo esquema:

`insert into ventas select * from opc.ventas;`

**Ejercicio 2.11**
A continuación vamos a tratar de insertar algunas tuplas nuevas en ventas.
Comprueba que se introducen correctamente y, en caso contrario, razona por qué da error.
`insert into ventas values ('S3', 'P1', 'J1', 150, '24/12/05');`
Da error porque la clave primaria no es única, y debería de serlo.
~~~sql
insert into ventas (codpro, codpj) values ('S4', 'J2');
insert into ventas values('S5','P3','J6',400,TO_DATE('25/12/00'));
~~~

### SUBCONSULTAS

calcular la venta que tiene la cantidad más pequeña: se puede plantear haciendo una consulta,
nos vamos a la tabla de ventas, miramos las cantidades y disponiendo de ese conjunto de valores
podríamos intentar tener un comparador que mi cantidad sea menor o igual que esas que aparecen.

Eso se puede plantear directamente en sql: `select * from ventas where cantidad <= (select cantidad from ventas);`
la subconsulta es la consulta que está entre paréntesis. Da error por usar un operador que él supone es de comparación
para un solo elemento. Ponemos entonces `select * from ventas where cantidad <= ALL (select cantidad from ventas);`

Así se hace el operador verdadero, con `ALL` resuelve la consulta interior una vez, sustituye y hace la exterior.

+ Proveedores que son de la misma ciudad que s1: `select * from proveedor where ciudad=(select ciudad from proveedor where codpro= 'S1');`

No hace falta any ó all porque cuando la subconsulta devuelve un solo valor los operadores relacionales no dan error, any o all se ponen si se
pueden devolver más cosas, al haber hecho en este caso una consulta por clave primaria no pasa nada.

Podríamos haber hecho: `select * from pieza where color=(select color from pieza where codpie=''P3');`
devuelve P3 y P5, podemos hacer pues la comparación simple porque me devuelve una tupla. Cuando devolvemos un conjunto de valores se
puede usar el operador de conjunto in, que es lo mismo que =ANY. Se pueden anidar consultas. Se puede relacionar la subconsulta con la consulta
principal, los datos que se usan fuera se pueden usar para plantear restricciones.

Operador exist: se puede usar negado o normal, espera una subconsulta y devuelve verdadero si la
subconsulta devuelve tuplas, false si es vacía: `select nompro from proveedor where exists(select * from ventas where ventas.codpro=proveedor.codpro);`
nombre de los proveedores que tienen alguna venta. Es pues una subconsulta que enlaza con la consulta de fuera.
Hay que tener cuidado con la eficiencia.

Proveedores que no han vendido la pieza a p3:
`select nompro from proveedor where codpro not in (select codpro from ventas where codpie='P3');`

Con álgebra relacional se haría producto cartesiano y resta. En los ejemplos vistos no se devuelven parejas, tripletas,... También se puede hacer.
Los modificadores all y any son para cuando la semántica de la subconsulta hace que pueda devolver más de un valor.
También se pueden poner subconsultas en el from:
`select * from (select * from proveedor where ciudad= 'Madrid') prov, pieza;`
Coge el proveedor que hay de madrir y combina con la pieza p1, p2,... Solo el de Madrid. Primero resuelve la tabla virtual
que crea llamada prod y la combina con las piezas. Para evitar ambigÜedad usar alias.
