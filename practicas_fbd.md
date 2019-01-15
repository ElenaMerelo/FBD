### Introducción
Para la creación de una tabla denominada prueba1:
~~~sql
SQL> CREATE TABLE prueba1 (
cad char(3),
n int,
x float);
~~~
Si todo ha ido bien, devolverá el mensaje `TABLA CREADA;` en caso contrario dará un mensaje
de error adecuado, en ocasiones se indica con un subrayado la palabra
responsable del error.

#### Desde un fichero
Otra alternativa para trabajar es editar y lanzar ficheros de comandos que se
pueden guardar y volver a relanzar desde SQL*Plus. Estos ficheros de comandos SQL se pueden
crear con cualquier editor (conviene dejarlos en un directorio de Bases de Datos preparado a tal
efecto), que deberían tener extensión .sql. Para ello tenemos que hacer:

1. `edit nombre-de-fichero` siendo éste un fichero no creado previamente y
escribiendo en él antes de abandonar el editor.

2. `save nombre-de-fichero`. De esta forma se copia el contenido del buffer al
fichero en cuestión.

Para ejecutar un fichero desde SQL*Plus, basta poner `start camino\nombre-de-fichero`
o bien `@camino\nombre-de-fichero`. Donde camino es el camino absoluto o relativo desde
el que se ejecuta SQL*Plus (por defecto está en el directorio de instalación `Home\_Oracle\bin`).
Por simplicidad se recomienda establecer el directorio de trabajo, en el entorno, al directorio
donde están nuestros archivos sql. Para ello basta con seleccionar en la ventana de SQL*Plus
la opción OPEN del menú FILE y navegar hasta la carpeta donde están nuestros archivos para
después pulsar el botón CANCEL.

**Ejercicio 2.1 Editar el fichero pp.sql en el directorio de trabajo, debe contener las instruc-
ciones:
~~~sql
CREATE TABLE prueba2(
cad1 char(8),
num int);
~~~
a continuación ejecutar el fichero.** Mediante esta sentencia hemos creado una tabla vacía
llamada prueba2 con dos atributos, cad1 y num. Para comprobarlo, es necesario consultar el
catálogo de la base de datos o ejecutar un comando describe, como veremos a continuación.

Para ello desde sqlplus ponemos `edit pp.sql`, se abre dicho archivo, escribimos lo
anterior y lo guardamos con `save pp.sql`. Finalmente, para ejecutarlo simplemente
hacemos `@pp.sql`.

Una vez creada una tabla, podemos consultar su esquema y conocer algunas restricciones
básicas asociadas a cada atributo. Para ello, es necesario utilizar la siguiente sentencia:
`DESCRIBE nombre-tabla;`

**Ejercicio 2.2 Ver la descripción de las tablas prueba1, prueba2.**
`describe prueba1`, `describe prueba2`.

#### Creación de tablas
Como ya hemos visto en ejercicios anteriores, la creación de una tabla se realiza mediante la
sentencia `CREATE TABLE`. La versión básica de dicha sentencia incluye la definición de los
atributos y sus tipos de datos correspondientes, el valor por defecto que toma un atributo cuando
no se especifica su valor al insertar una nueva tupla (cláusula DEFAULT), así como las claves
primaria, candidatas y externas. A continuación se introduce la forma básica de su sintaxis:
~~~sql
CREATE TABLE nombre-tabla(
nombre-atributo1 tipo-atributo1 [DEFAULT expr],
nombre-atributo2 tipo-atributo2 [DEFAULT expr],...
[PRIMARY KEY(nombre-atributo1, nombre-atributo2...),]
[UNIQUE (nombre-atributo1, nombre-atributo2...),]
[FOREIGN KEY(nombre-atributo1, nombre-atributo2...)
REFERENCES nombre-tabla(nombre-atributo, ...),]
[CHECK(condicion)]
);
~~~
Además, cabe destacar que cuando la clave primaria, la clave candidata o la clave externa
están formadas por un solo atributo, las palabras reservadas `PRIMARY KEY`, `UNIQUE` y `REFERENCES`, respectivamente, se podrán incluir a continuación de la definición del atributo
correspondiente, tal y como se muestra a continuación:
~~~sql
CREATE TABLE nombre-tabla1(
nombre-atributo1 tipo-atributo1 PRIMARY KEY,
nombre-atributo2 tipo-atributo2 UNIQUE,
nombre-atributo3 tipo-atributo3
REFERENCES nombre-tabla2(nombre-atributo3));
~~~
La cláusula tipo-atributo3 puede omitirse, en cuyo caso el atributo será del mismo tipo
que el atributo al que hace referencia.

**Ejemplo 2.1 Como ejemplo, vamos a considerar la tabla plantilla, donde vamos a almacenar
el dni, nombre y fecha de alta de los trabajadores de una empresa, considerando dni como clave
primaria.**
~~~sql
CREATE TABLE plantilla(
dni char(8),
nombre varchar2(15),
estadocivil varchar(10)
CHECK (estadocivil IN (’soltero’, ’casado’, ’divorciado’, ’viudo’)),
fechaalta date,
PRIMARY KEY (dni));
~~~

Obsérvese que estamos delimitando el rango de valores para el atributo estadocivil median-
te la sentencia `CHECK`.

Además de definir reglas de integridad específicas sobre determinados campos, se pueden
definir reglas de integridad genéricas tales como la regla de integridad de entidad y la regla de
integridad referencial. Por ejemplo, si queremos almacenar la relación entre jefes y subordinados
a partir de la tabla plantilla, podremos crear otra tabla con la siguiente estructura:
~~~sql
SQL> CREATE TABLE serjefe(
dnijefe REFERENCES plantilla(dni),
dnitrabajador REFERENCES plantilla(dni),
PRIMARY KEY (dnitrabajador)
);
~~~

#### Eliminación de tablas
Se puede eliminar una tabla con todas las tuplas que contiene, liberando el espacio con la
sentencia: `DROP TABLE nombre-tabla;`

**Ejercicio 2.5 Borrar la tabla prueba1 y comprobar las tablas que quedan.**
Para ello ponemos `drop prueba1` seguido de `select table_name from user_tables`.

#### Modificación del esquema de una tabla
Para una tabla existente podemos utilizar la sentencia `ALTER TABLE` para modificar
su estructura, por ejemplo añadiéndole una nueva columna, modificando la definición o las
restricciones de alguno de sus atributos, o bien, eliminando algún atributo.
El tipo de alteración de la tabla dependerá del modificador que incluyamos. Por ejemplo,
para añadir un atributo nuevo a una tabla se utiliza el modificador `ADD` del siguiente modo:
`ADD(atributo [tipo] [DEFAULT expresion] [restriccion_atributo]);`

**Ejercicio 2.6 Modifica el esquema de la tabla plantilla añadiendo un nuevo atributo llamado
fechabaja de tipo date.**

`alter table plantilla add (fechabaja date)`.

#### Ejemplos de creación de tablas
Se pide crear el archivo proveedor.sql con la información que se muestra a continuación. Destacar
la palabra reservada `constraint` que permite dar nombre a restricciones impuestas a los atributos.
~~~SQL
SQL> create table proveedor(
codpro char(3) constraint codpro_no_nulo not null
constraint codpro_clave_primaria primary key,
nompro varchar2(30) constraint nompro_no_nulo not null,
status number constraint status_entre_1_y_10
check(status>=1 and status<=10),
ciudad varchar2(15));
~~~
Como resultado de la ejecución de este archivo, se crea la tabla de proveedores definiendo
“codpro” como clave primaria y con una restricción de integridad sobre el valor de “status”.

Editamos ventas.sql con el contenido:
~~~sql
SQL> create table ventas (
codpro constraint codpro_clave_externa_proveedor
references proveedor(codpro),
codpie constraint codpie_clave_externa_pieza
references pieza(codpie),
codpj constraint codpj_clave_externa_proyecto
references proyecto(codpj),
cantidad number(4),
constraint clave_primaria primary key (codpro,codpie,codpj));
~~~
almacenamos, salimos del editor y ejecutamos.
Como puede verse hemos definido ventas con tres llaves externas a proveedor, pieza y
proyecto y con llave primaria incluyendo tres de sus atributos.

**Ejercicio 2.7: Utilizando la sentencia ALTER TABLE, descrita anteriormente, vamos a modificar el esque-
ma de la tabla Ventas añadiendo un nuevo atributo llamado fecha de tipo date.**
`alter table ventas add (fecha date)`.

#### Inserción de tuplas en las tablas
Una vez creadas las tablas, es preciso introducir tuplas en ellas. Para ello se hará un uso
intensivo de la sentencia insert de SQL. Vamos a mostrar un ejemplo de introducción y
visualización sencilla de datos en la tabla prueba2.
La forma general de la sentencia insert es la siguiente:
~~~sql
INSERT INTO nombre_tabla [(column1, column2,...)]
VALUES(valor1, valor2,...);
~~~
También podemos insertar tuplas en una tabla a partir de otra tabla de la base de datos. En
este caso, la forma general de la sentencia sería:
~~~SQL
INSERT INTO nombre_tabla [(column1, column2,...)]
(SELECT column1, column2,...
FROM nombre_tabla2);
~~~

**Ejemplo 2.2 Utiliza la sentencia INSERT para introducir valores en la tabla PRUEBA2. Para
hacerlo, vamos a editar el fichero introducir_datos.sql cuyo contenido debe ser:**
~~~sql
INSERT INTO prueba2 VALUES (’aa’,1);
INSERT INTO prueba2 VALUES(’Aa’,2);
INSERT INTO prueba2 VALUES (’aa’,1);
~~~

almacenar y salir del editor. Ejecutar
`SQL> start introducir_datos;`
Si la tupla es correcta (número y tipos de datos acordes, etc.) devolverá: 3 filas creadas. En
caso contrario dará el correspondiente mensaje de error por cada tupla introducida errónea y se
desestimará la inserción.

**Ejemplo 2.3 Utiliza la sentencia INSERT para introducir valores en las tablas plantilla y
serjefe del siguiente modo:**
~~~sql
INSERT INTO plantilla (dni,nombre,estadocivil,fechaalta)
VALUES (’12345678’,’Pepe’,’soltero’, SYSDATE);
INSERT INTO plantilla (dni,nombre,estadocivil,fechaalta)
VALUES (’87654321’,’Juan’, ’casado’, SYSDATE);
INSERT INTO serjefe VALUES (’87654321’,’12345678’);
INSERT INTO plantilla (dni, estadocivil) VALUES (’11223344’,’soltero’);
~~~
donde `SYSDATE` indica la fecha y hora del sistema.

#### Mostrar el contenido de una tabla
Una vez que hemos introducido los datos en las tablas de nuestro ejemplo, podemos ver el
contenido de las mismas ejecutando la sentencia de consulta:
`SQL> SELECT * FROM nombre-tabla;`
La lista de atributos entre la cláusula SELECT y la cláusula FROM equivale en SQL a la
operación de proyección de Álgebra Relacional. En este caso particular, el ∗ equivale a proyectar
sobre todos los atributos de las tablas relacionadas en la cláusula FROM. Para proyectar campos
individuales, se debe ejecutar la siguiente sentencia:
`SQL> SELECT campo1, campo2, .... FROM nombre-tabla;`
Para conocer qué tablas tenemos creadas hasta este momento, podemos consultar una vista
del catálogo del SGBD denominada user_tables, en la forma que sigue:
`SQL> SELECT table_name FROM user_tables;`

**Ejercicio 2.8 Ejecuta la sentencia SELECT para mostrar el contenido de las tablas PRUEBA2
y PLANTILLA. Intenta mostrar sólo algunos campos de las mismas.**

~~~sql
select * from prueba2;
select * from plantilla;
select dni from plantilla;
~~~

#### Modificar el contenido de una tabla
Para modificar los datos de una tabla introducidos con anterioridad, hemos de utilizar la
sentencia UPDATE, cuya forma general es la siguiente:
~~~sql
UPDATE nombre_tabla
SET nombre_atributo = ’nuevovalor’
[, nombre_atributo2 = ’nuevovalor2’...]
[WHERE <condicion> ];
~~~
Esta sentencia modifica la/s tupla/s que se ajustan al criterio especificado en la cláusula
WHERE. Hay que destacar que [] indica opcionalidad. Así, se puede modificar un atributo o
más de un atributo simultáneamente. La sintaxis de la cláusula WHERE se basa en la expresión lógica
recogida en <condicion>.

**Ejemplo 2.4 Ejecuta la sentencia UPDATE sobre la tabla plantilla y cambia el estado civil de
Juan a divorciado.**
~~~sql
SQL> update plantilla
set estadocivil = ’divorciado’
where nombre=’Juan’;
~~~

**Ejercicio 2.9 Ejecuta la sentencia UPDATE sobre la tabla plantilla y cambia el nombre del
trabajador con dni ’12345678’ a ’Luis’.**
~~~sql
SQL> update plantilla
set nombre= `Luis`
where dni= '12345678';
~~~

#### Borrado de tuplas
La instrucción DELETE se utiliza para eliminar tuplas de una tabla. Las tuplas que se
eliminan son aquellas que hacen cierta la expresión <condicion>. Su sintaxis es la siguiente:
`DELETE [FROM] nombre_tabla [WHERE <condicion>];`
Donde [] nuevamente indica opcionalidad y condicion es cualquier expresión lógica.

**Ejemplo 2.5 Borra todas las tuplas de la tabla prueba2.**
`SQL> DELETE FROM prueba2;`

**Ejercicio 2.10 Borra todas las tuplas de la tabla plantilla.**
`SQL> DELETE FROM plantilla;`

**En este caso da un mensaje de error (¿por qué?). Aunque sí podríamos borrar las tuplas
de la tabla serjefe.** Esto ocurre ya que la tabla serjefe referencia a plantilla, y no al revés.

#### Particularidades del tipo de dato DATE
El tipo DATE sirve para almacenar información relativa a fechas. Está expresado en Juliano
y su rango va del 1 de Enero de 4712 “Antes de Cristo” al 31 de Diciembre de 9999. Un
determinado valor de este tipo almacena los segundos transcurridos desde el 1 de Enero de 4712
“Antes de Cristo”. Este formato de fecha permite, por tanto, disponer de un referencial contínuo
para el almacenamiento y la manipulación de fechas.
Oracle permite sumar y restar valores constantes y otras fechas a los datos de tipo fecha.
Para ello, la fecha se representa internamente como un único número (número de días); así, por
ejemplo, SYSDATE + 1 es mañana , SYSDATE - 7 es hace una semana y SYSDATE + (10/1440)
es dentro de diez minutos.

**Ejemplo 2.6 Ejecuta la sentencia UPDATE sobre la tabla plantilla y cambia la fecha de alta
de Juan al día siguiente.**

~~~sql
SQL> UPDATE plantilla
SET fechaalta = fechaalta+1
WHERE nombre=’Juan’;
~~~

Aunque los datos de fecha podrían representarse mediante los tipos VARCHAR y NUMBER,
el tipo DATE ofrece funciones específicas para su manejo que tienen en cuenta su
semántica.
##### Introducción de fechas mediante la función TO_DATE
Con esta función se genera un valor de tipo date a partir del valor suministrado por la
primera cadena pasada a la función usando como formato la segunda cadena proporcionada.
Por ejemplo:
~~~sql
SQL> insert into plantilla
values (’11223355’,’Miguel’,’casado’,
TO_DATE(’22/10/2005’,’dd/mm/yyyy’),null);
~~~

**Ejemplo 2.7** `SQL> select TO_CHAR(fechaalta,’dd-mon-yyyy’) from plantilla;`

Si se omite la función TO_CHAR en la sentencia select, el formato aplicado será el que haya
por defecto. Esta sentencia devuelve en el formato día-mes-año las fechasaltas que constan en plantilla.

**Ejercicio 2.12 Actualizar la fecha del proveedor S5 al año 2005’**
~~~sql
SQL> UPDATE ventas
SET fecha = TO_DATE(2005,’YYYY’)
WHERE codpro=’S5’;
~~~

**Ejercicio 2.13 Para mostrar la columna FECHA con un formato específico e imprimirla,
utilizar la siguiente sentencia:**
~~~sql
SQL> select codpro,codpie,
to_char(fecha,’"Dia" day,dd/mm/yy’) from ventas;
~~~
donde el texto que se quiere incluir como parte de la fecha debe ir entre comillas dobles.

> EXPLICACIÓN PROFESOR
select == pi (proyección). Si ponemos select distinct no pone las tablas duplicadas
from == X (poducto cartesiano)
where == sigma (selección)

>Ejemplo: `select codpro from proveedor where ciudad= 'Londres'` para ver los proveedores que son de Londres.

>Para conjuntos: union (all si queremos que nos muestre los elementos que están más de una vez), minus, intersect, select.
Si no queremos proyectar ponemos asterisco: select \*.

> `select * from ventas v, ventas v2 where v.codpro= 'S5'`

> `select * from proveedor order by ciudad desc` para dar un criterio de ordenación a las tuplas, si las queremos en orden por ciudad descendente.

> `select * from proveedor order by ciudad, status;` ordena por ciudad, si hay igualdad mira status. Por defecto ordena
ascendentemente.

> Tipo de dato fecha: `to_date(cadena, formato)` por ejemplo cadena= '22/07/2018', formato= 'dd/mm/yyyy', pasa la fecha a un
formato que él entiende. `to_char(fecha, formato)` hace lo contrario, esto es, coge la fecha como él la tiene representada
internamente y la muestra poniéndola en el formato especificado, para que nosotros podamos entenderla.

> `select sysdate from dual` nos la fecha del día en el formato por defecto del sistema. `select to_char(sysdate, 'yyyy') from dual`
dice el año en el que estamos.

> Es muy habitual que cometamos el error de comparar en el dominio de las cadenas, y eso a veces puede no funcionar. Si vamos
a comparar fechas, lo hacemos en el dominio de las fechas.

> `select sysdate-to_date('23/06/1998' 'DD/MM/YYYY') from dual;` dice los días que han pasado desde que nací.

> `select (sysdate-to_date('23/06/1998', 'dd/mm/yyyy'))/365 from dual;` dice los años que tengo.

> sql convierte la aritmética de fechas en aritmética real.

> `select sysdate from ventas` por cada tupla de ventas me saca lo que he puesto en el select, me repite la fecha del sistema tantas
veces como tuplas haya.

> `select cantidad*3-5 from ventas` multiplica cantidad de la tabla ventas por 3, le resta 5.


### La sentencia de consulta SELECT
La sentencia SELECT permite consultar las tablas seleccionando datos en tuplas y columnas
de una o varias tablas. La sintaxis general de la sentencia con sus múltiples cláusulas se detalla a
continuación:
~~~sql
SELECT [ DISTINCT | ALL]
expresion [alias_columna_expresion]
{,expresion [alias_columna_expresion]}
FROM [esquema.]tabla|vista [alias_tabla_vista]
[WHERE <condicion>]
[GROUP BY expresion {,expresion}]
[{UNION | UNION ALL | INTERSECT | MINUS} <SELECT instruccion>]
[HAVING <condicion>]
[ORDER BY {expresion} [ASC | DESC]]
~~~
Seguidamente iremos viendo con detalle algunas de sus principales cláusulas.

#### La consulta en SQL y su relación con los operadores del AR
En este apartado ejercitaremos los siguientes componentes de la sentencia SELECT:
~~~sql
SELECT [ DISTINCT | ALL]
<expresion> [alias_columna_expresion]
{,<expresion> [alias_columna_expresion]}
FROM [esquema.]tabla|vista [alias_tabla_vista]
[ WHERE <condicion>]
~~~

##### La proyección AR en SQL
La proyección del Álgebra Relacional se expresa en la sentencia SELECT mediante la lista
de campos, denominados “select list” que se relacionan entre la cláusula SELECT y la cláusula
FROM. Se utiliza el ∗ para determinar que se proyecte sobre todos los campos de las tablas
listadas en la cláusula FROM.

**Ejemplo 3.1 Muestra las ciudades donde hay un proyecto.**

AR: `π ciudad (Proyecto)`

`SQL> Select ciudad from proyecto;`

No sale lo mismo que en AR, porque salen tuplas repetidas. Para solucionarlo:

`SQL> Select distinct ciudad from proyecto;`

**Ejemplo 3.2 Muestra la información disponible acerca de los proveedores.**

`SQL> Select * from proveedor;` * muestra el esquema completo, o bien proyectando
uno a uno los atributos
`SQL> Select codpro, nompro, status, ciudad from proveedor;`

**Ejercicio 3.2 Muestra los suministros realizados (tan solo los códigos de los componentes
de una venta). ¿Es necesario utilizar DISTINCT?**

`select codpro, codpie, codpj from ventas`. Sí es necesario emplear distinct ya que aunque la tripleta sea única el atributo fecha nos indica que la misma venta puede haberse realizado en distintas fechas.

#### La selección AR en SQL
Para realizar la selección Algebraica σ en SQL se emplea la cláusula WHERE seguida de una expresión booleana
<condición>, aunque siempre será necesario especificar la cláusula SELECT de la instrucción
de consulta.

**Ejemplo 3.3 Muestra los códigos de los proveedores que suministran al proyecto ’J1’.**

AR : π cod pro (σ cod p j= 0 J1 0 (Ventas))

`SQL> Select codpro from ventas where codpj=’J1’;`

**Ejercicio 3.3 Muestra las piezas de Madrid que son grises o rojas.**

`select * from ventas where (color='rojo' or color='gris') and (ciudad='Madrid');`

**Ejercicio 3.4 Encontrar todos los suministros cuya cantidad está entre 200 y 300, ambos
inclusive.**

`select * from ventas where cantidad >= 200 and cantidad <= 300;`

> Construcción de expresiones lógicas: operadores adicionales. El operador `like` y los caracteres comodín `_` y `%`

El operador `like` se emplea para comparar cadenas de caracteres mediante el uso de patrones. Cuando se emplea el carácter
comodín `%`, éste se sustituye por cualquier cadena de 0 ó más caracteres:

**Ejemplo 3.4 Mostrar los proveedores cuyo nombre de ciudad empieza por ’L’.**

`SQL> Select codpro, nompro from proveedor where ciudad LIKE ’L%’;`

El carácter comodín `_` sustituye un sólo carácter.

**Ejercicio 3.5 Mostrar las piezas que contengan la palabra tornillo con la t en
mayúscula o en minúscula.**
`select * from pieza where nompie like 'tornillo' or nompie like 'Tornillo';`
Otra opción sería:
`select * from pieza where nompie like '_ornillo'`

**Ejemplo 3.15 Describe la cantidad de cada venta expresada en docenas, sólo de las
ventas cuyo número de piezas es mayor de diez docenas.**

`select cantidad/12 from ventas where (cantidad/12) > 10;`

> Comparación con el valor nulo. El operador IS [NOT] NULL

**Ejemplo 3.6 Encontrar los proveedores que tienen su status registrado en la base de
datos.**

`select nompro,codpro from proveedor where status is not null;`

#### Consultas sobre el catálogo

**Ejemplo 3.7 Mostrar la información de todas las tablas denominadas ventas a las que tienes
acceso.**
~~~sql
SQL> Select table_name
from ALL_TABLES
where TABLE_NAME like ’%ventas’;
~~~

**Ejercicio 3.6 Comprueba que no devuelve ninguna. Pero SÍ que hay!!!**

No devuelve ninguna dado que en el catálogo en el que se guardan todas las tablas
que declaramos están almacenadas en mayúsculas, y las búsquedas son *case sensitive*. Escribiendo pues `select table_name from all_tables where table_name like '%VENTAS';` obtenemos lo deseado.

#### Operadores AR sobre conjuntos en SQL
~~~SQL
<SELECT instrucción>
UNION | UNION ALL | INTERSECT | MINUS
<SELECT instrucción>
~~~
Estos operadores tienen una restricción similar a sus correspondientes del AR para poder
llevarse a cabo: los esquemas de las tablas resultantes de cada sentencia SELECT han de ser
iguales en tipo, esto es, los atributos no tienen por qué llamarse igual, aunque sí han de coincidir
en número, posición en el “select list” y tipo. Tras la operación, el esquema del resultado coincide
con el esquema del primer operando.

**Ejemplo 3.8 Ciudades donde viven proveedores con status mayor de 2 en las que no se fabrica
la pieza ’P1’.**
`select distinct ciudad from proveedor where status > 2 MINUS select distinct ciudad from pieza where codpie = 'P1';`

Nótese que los operadores UNION, MINUS e INTERSECT implementan en SQL las operaciones U , −, ∩ del AR, respectivamente y por tanto, consideran los argumentos como
relaciones (sin tuplas repetidas) y devuelven el resultado como una relación (sin tuplas repetidas).
Por consiguiente, la sentencia SQL que resuelve el ejercicio anterior podría prescindir de las
cláusulas distinct. Sin embargo el operador UNION ALL devuelve todas las tuplas incluidas en
las tablas argumento, sin eliminar tuplas duplicadas.

**Ejercicio 3.7 Resolver la consulta del ejemplo 3.8 utilizando el operador ∩.**

`select ciudad from proveedor where status > 2 ∩ select ciudad from pieza where codpie <> 'P1';`

**Ejercicio 3.8 Encontrar los códigos de aquellos proyectos a los que sólo abastece ’S1’.**

`select codpj from ventas where codpro= 'S1' - select codpj from ventas where codpro <> 'S1';`

Esto es, a aquellos proyectos a los que abastece S1 le quitamos los proyectos a los que
abastecen otros proveedores que no son S1, de manera que si a J2 le abastece S1 y otro
que no sea S1 no aparece, se quedan sólo los de S1, como queríamos.

Otra opción es: `select codpj from proyecto where not exists (select codpro from proveedor where codpro <> 'S1');`, es decir,
seleccionamos el código de los proyectos en los que no exista un proveedor que sea distinto de S1; nos
quedamos con los códigos de los proyectos en los que el único proveedor es S1, no puede
existir otro que no sea él.

**Ejercicio 3.9 Mostrar todas las ciudades de la base de datos. Utilizar UNION**

`select ciudad from proyecto UNION select ciudad from pieza UNION select ciudad from proveedor;`

**Ejercicio 3.10 Mostrar todas las ciudades de la base de datos. Utilizar UNION ALL**
Igual que el anterior pero poniendo union all, la diferencia con union es que no elimina duplicados,
por lo que a la hora de hacer select habría que poner distinct.


#### El producto cartesiano AR en SQL
En la cláusula FROM de una sentencia de consulta puede aparecer una lista de tablas en lugar
de una sola. En este caso, el sistema realiza el producto cartesiano de todas las tablas incluidas
en dicha lista para, posteriormente, seleccionar aquellas tuplas que hacen verdad la condición de
la cláusula WHERE (en el caso de que se haya establecido) mostrándolas como resultado de ese
producto cartesiano.
**Ejercicio 3.11 Comprueba cuántas tuplas resultan del producto cartesiano aplicado a ventas
y proveedor.**
`select (count *) from ventas, proveedor;`. Más adelante está explicado el count.

**Ejemplo 3.9 Muestra las posibles ternas (codpro,codpie,codpj) tal que, todos los implicados
sean de la misma ciudad.**
~~~sql
select codpro, codpie, codpj from proveedor, proyecto, pieza
where proyecto.ciudad = pieza.ciudad and pieza.ciudad = proveedor.ciudad;
~~~

**Ejemplo 3.10 Mostrar las ternas (codpro,codpie,codpj) tal que todos los implicados son de
Londres.**

~~~sql
select codpro, codpie, codpj from proveedor, proyecto, pieza
where proyecto.ciudad = 'Londres' and pieza.ciudad= 'Londres' and proveedor.ciudad= 'Londres';
~~~

**Ejercicio 3.12 Mostrar las ternas que son de la misma ciudad pero que hayan realizado
alguna venta( que entre ellos haya alguna venta).**

~~~sql
select codpro, codpie, codpj from proveedor, proyecto, pieza
where proyecto.ciudad = pieza.ciudad and pieza.ciudad = proveedor.ciudad INTERSECT
select codpro, codpie, codpj from ventas;
~~~

Otra opción sería:

~~~sql
select s.codpro, p.codpie, j.codpj
from proveedor s, proyecto j, pieza p, ventas v
where s.ciudad= j.ciudad
and j.ciudad= p.ciudad
and v.codpro= s.codpro
and v.codpie= p.codpie
and v.codpj= j.codpj;
~~~

También:

~~~sql
select s.codpro, p.codpie, j.codpj from proveedor s, proyecto j, pieza p where
s.ciudad= p.ciudad and p.ciudad= j.ciudad and EXISTS (select codpro, codpj, codpie from ventas v where
v.codpro= s.codpro and v.codpie= p.codpie and v.codpj= j.codpj )
~~~

#### El renombramiento o alias en SQL
El empleo de alias puede ser útil para abreviar texto cuando es necesario prefijar atributos
para eliminar ambigÜedades, sin embargo, es estrictamente necesario cuando se hace un producto
cartesiano de una tabla consigo misma o cuando hay que hacer referencia a los campos de una
consulta incluida en la cláusula FROM. Los alias se definen asociándolos a aquellas tablas o
consultas presentes en la cláusula FROM que se deseen redefinir.

**Ejemplo 3.11 (Ligeramente variado) Muestra las posibles ternas (codpro,codpie,codpj) tal que todos los implicados
sean de la misma ciudad y entre ellos haya alguna venta.**

~~~sql
select s.codpro, p.codpie, j.codpj
from proveedor s, proyecto j, pieza p, ventas spj
where s.ciudad= j.ciudad
and j.ciudad= p.ciudad
and spj.codpro= s.codpro
and spj.codpie= p.codpie
and spj.codpj= j.codpj;
~~~

**Ejercicio 3.13 Encontrar parejas de proveedores que no viven en la misma ciudad.**

`select x.codpro, y.codpro from proveedor x, proveedor y where x.ciudad <> y.ciudad;`

**Ejercicio 3.14 Encuentra las piezas con máximo peso.**
Para ello cogemos todas las piezas y les quitamos aquellas con mínimo peso:
`select nompie, codpie, peso from pieza MINUS select x.nompie, x.codpie, x.peso from pieza x, pieza y where x.peso < y.peso`
Otra opción, usando las funciones de agregación que veremos más adelante, es:
`select * from pieza where peso >= ALL (select peso from pieza);`

#### La equi-reunión y la reunión natural AR en SQL
Llegado este punto, disponemos de todos los elementos SQL para expresar el operador
equi-reunión y la reunión natural. Para la reunión natural se usa la cláusula NATURAL JOIN
dentro de la cláusula FROM entre las tablas o subconsultas participantes. EL SGBD aplica la
reunión natural sobre aquellos campos que se llamen de igual forma en las tablas o subconsultas
intervinientes, si no coincidieran en tipo, devolvería error.

**Ejemplo 3.12 Mostrar los nombres de proveedores y cantidad de aquellos que han realizado
alguna venta en cantidad superior a 800 unidades.**
`select nompro, cantidad from proveedor NATURAL JOIN (select * from ventas where cantidad >= 800)`
Si no se hubiera hecho con reunión natural habría sido:
`select nompro, cantidad from proveedor s (select codpro from ventas where cantidad >= 800) y where s.codpro= y.codpro`.
O: `select nompro, cantida from proveedor s, ventas v where v.cantidad >= 800 and s.codpro= v.codpro`

Observe el resultado que se obtiene de la reunión natural cuando se proyecta sobre todos
los atributos. Si se quiere reunir en base a campos que no tienen el mismo nombre, se pueden
usar dos alternativas: producto cartesiano junto a condición de reunión en la cláusula WHERE
o la equi-reunión expresada mediante cláusula JOIN ... ON en la forma que se indica a
continuación:
~~~sql
SQL> Select nompro, cantidad
from proveedor s JOIN (select * from ventas where cantidad>800) v
ON (s.codpro=v.codpro);
~~~

**Ejercicio 3.15 Mostrar las piezas vendidas por los proveedores de Madrid.**
Si sólo quisiéramos saber el código de las piezas vendidas por los proveedores de Madrid:
`select codpie from ventas NATURAL JOIN (select codpro from proveedor where ciudad= 'Madrid')`

Sin usar reunión natural:
`select codpie from ventas v (select * from proveedor where ciudad= 'Madrid') p where v.codpro= p.codpro`

Equivalente a:
~~~sql
select v.codpie
from ventas v, proveedor p
where v.codpro= p.codpro and p.ciudad= 'Madrid';
~~~

Si quisiéramos obtener toda la información sobre la pieza:
`select * from pieza NATURAL JOIN (select * from ventas NATURAL JOIN (select codpro from proveedor where ciudad= 'Madrid'))`

Y haciéndolo normalis y corrientismente:
`select * from pieza p (select * from ventas v (select codpro from proveedor where ciudad= 'Madrid') m where v.codpro= m ) where p.codpie= v.codpie`

Usando el JOIN...ON:
~~~sql
select v.codpie
from ventas v
join (select * from proveedor
where ciudad= 'Madrid') pr
on v.codpro= pr.codpro;
~~~

**Ejercicio 3.16 Encuentra la ciudad y los códigos de las piezas suministradas a cualquier
proyecto por un proveedor que está en la misma ciudad donde está el proyecto.**
~~~sql
select p.ciudad, p.codpie from pieza p NATURAL JOIN
(select codpie from ventas NATURAL JOIN (select s.codpro, j.codpj from proveedor s, proyecto j where j.ciudad= s.ciudad ))
~~~
Otras formas:

~~~sql
select pi.ciudad, pi.codpie
from pieza pi, ventas v, proveedor pr, proyecto pj
where v.codpie= pi.codpie and v.codpro= pr.codpro and v.codpj= pj.codpj and pj.ciudad= pr.ciudad;

select pi.ciudad, pi.codpie
from pieza pi join(select codpie from ventas v, proveedor pr, proyecto pj
where v.codpro= pr.codpro and v.codpj= pj.codpj and pj.ciudad= pr.ciudad) c
on pi.codpie= c.codpie;

select distinct nompj
from proyecto j
where exists (
    select *
    from proveedor s natural join ventas v
    where j.codpj=v.codpj and s.ciudad!=j.ciudad
);

select ciudad, codpie
from
(select p.ciudad, p.codpro, j.codpj from proveedor p, proyecto j where p.ciudad=j.ciudad) natural join ventas
~~~

### Ordenación de resultados
Ya sabemos que en el modelo relacional no existe orden entre las tuplas ni entre los atributos,
aunque sí es posible indicar al SGBD que ordene los resultados según algún criterio, mediante la
cláusula `ORDER BY`. Caso de emplearse ésta, el orden por defecto es creciente (ASC).

~~~sql
SELECT [DISTINCT | ALL] expresion [alias_columna_expresion]
{,expresion [alias_columna_expresion]}
FROM [esquema.]tabla|vista [alias_tabla_vista]
[WHERE <condicion>]
ORDER BY expresion [ASC | DESC]{,expresion [ASC | DESC]}
~~~

**Ejemplo 3.13 Encontrar los nombres de proveedores ordenados alfabéticamente.**
~~~sql
SQL> Select nompro
from proveedor
order by nompro;
~~~

**Ejercicio 3.18 Listar las ventas ordenadas por cantidad, si algunas ventas coinciden en la
cantidad se ordenan en función de la fecha de manera descendente.**

`select * from ventas ORDER BY cantidad , fecha DESC;`

### Subconsultas en SQL
Existen en SQL distintos operadores que permiten operar sobre el resultado de una consulta,
esto se hace incorporando una subconsulta en la cláusula WHERE de la consulta principal. La
razón de proceder de esta forma es que se fragmenta la consulta original en varias consultas más
sencillas, evitando en muchas ocasiones numerosas reuniones.
~~~sql
SELECT <expresion>
FROM tabla
WHERE <expresion> OPERADOR <SELECT instruccion>
~~~
Dónde OPERADOR es cualquiera de los que se presentan en esta sección y, la cláusula
SELECT a la derecha de OPERADOR puede contener a su vez otra subconsulta, que puede, a su
vez, anidar un determinado número de subconsultas. El máximo número de anidamientos permi-
tido depende de cada sistema. Para su resolución el sistema procede resolviendo la subconsulta
anidada a un mayor nivel de profundidad y sigue resolviendo todas las instrucciones SELECT en
orden inverso de anidamiento.

#### IN, el operador de pertenencia
Un uso muy frecuente del operador de pertenencia a un conjunto IN consiste en obtener
mediante una subconsulta los elementos de dicho conjunto.

**Ejemplo 3.14 Encontrar las piezas suministradas por proveedores de Londres. (Sin usar el
operador de reunión.)**
~~~sql
SQL> Select codpie
from ventas
where codpro IN
(select codpro from proveedor where ciudad = ’Londres’);
~~~

Si quisiéramos saberlo todo de la pieza:

~~~sql
select * from pieza where codpie in (
  select codpie from ventas where codpro in(
    select codpro from proveedor where ciudad= 'Londres'
  )
)
~~~

Haciéndolo con el equivalente a producto cartesiano:

~~~sql
select * from pieza p, ventas v, proveedor s where p.codpie= v.codpie and s.codpro= v.codpro
and s.ciudad= 'Londres';
~~~

Con reunión natural:

~~~sql
select * from pieza NATURAL JOIN (select codpie from ventas NATURAL JOIN (select codpro from proveedor s where s.ciudad= 'Londres' ));
~~~

Y usando JOIN...ON:

~~~sql
select * from pieza p JOIN (
  select codpie from ventas v JOIN (
    select codpro from proveedor s where s.ciudad= 'Londres'
  ) ON s.codpro= v.codpro) ON p.codpie= v.codpie);
~~~

**Ejercicio 3.19 Mostrar las piezas vendidas por los proveedores de Madrid. (Fragmentando
la consulta con ayuda del operador IN.) Compara la solución con la del ejercicio 3.15.**

~~~sql
select nompie from pieza where codpie IN
  (select codpie from ventas where codpro IN
    (select codpro from proveedor where ciudad= 'Madrid')
);
~~~

**Ejercicio 3.20 Encuentra los proyectos que están en una ciudad donde se fabrica alguna
pieza.**
~~~sql
select nompj from proyecto where ciudad IN (
  select ciudad from pieza
);
~~~

**Ejercicio 3.21 Encuentra los códigos de aquellos proyectos que no utilizan ninguna pieza
roja que esté suministrada por un proveedor de Londres.**
Una manera es:
~~~sql
select distinct codpj from ventas where codpie  not in (select codpie from pieza where color = 'Rojo')
intersect select codpro from proveedor where ciudad = 'Londres');
~~~
Otra que se me ocurre es la siguiente:
~~~sql
select codpj from ventas MINUS
select codpj from ventas where codpie in (
  select codpie from pieza where color= 'Rojo' and codpro in (
  select codpro from proveedor where ciudad= 'Londres'
));
~~~

#### EXISTS, el operador de comprobación de existencia
Este operador devuelve verdadero cuando existe alguna tupla en la relación sobre la que se
aplica. El operador EXISTS puede interpretarse también como de comprobación de conjunto no
vacío.

**Ejemplo 3.15 Encontrar los proveedores que suministran la pieza ’P1’.**
Usando el operador IN:
~~~sql
select nompro from proveedor where codpro in (
  select codpro from ventas where codpie= 'P1'
);
~~~
Solución que consta en el cuaderno de prácticas:
~~~sql
SQL> Select codpro
from proveedor
where EXISTS (select * from ventas
where ventas.codpro = proveedor.codpro
AND ventas.codpie=’P1’);
~~~

#### Otros operadores, los comparadores sobre conjuntos
Cualquiera de los operadores relacionales < | <= | > | >= | <> junto con alguno de los
cuantificadores [ANY|ALL] pueden servir para conectar una subconsulta con la consulta principal.

**Ejemplo 3.16 Muestra el código de los proveedores cuyo status sea igual al del proveedor ’S3’.**
~~~sql
SQL> Select codpro
from proveedor
where status = (select status from proveedor where codpro=’S3’);
~~~

**Ejemplo 3.17 Muestra el código de las piezas cuyo peso es mayor que el peso de alguna pieza
’tornillo’.**
~~~sql
select codpie from pieza where peso > ANY (select peso from pieza where nombre like '_ornillo%');
~~~

**Ejercicio 3.22 Muestra el código de las piezas cuyo peso es mayor que el peso de cualquier
’tornillo’.**
~~~sql
select codpie from pieza where peso > ANY (select peso from pieza where nombre like '_ornillo');
~~~

**Ejercicio 3.23 Encuentra las piezas con peso máximo. Compara esta solución con la obtenida
en el ejercicio 3.14**
Es mucho más simple.
~~~sql
select nompie from pieza where peso > ALL (select peso from pieza)
~~~

### La división AR en SQL
Ya estamos en condiciones de trasladar el operador ÷ del AR a SQL. Para ello procederemos
a hacerlo de tres formas diferentes: utilizando una aproximación basada en el Álgebra Relacional,
otra basada en el Cálculo Relacional y otra usando un enfoque mixto.

**Ejemplo 3.18 Mostrar el código de los proveedores que suministran todas las piezas.**

AR : π cod pro,cod pie (ventas) ÷ π cod pie (pieza)

#### Aproximación usando expresión equivalente en AR
La división relacional no es un operador primitivo del Álgebra Relacional ya que se puede
expresar en combinación de los otros operadores primitivos de la siguiente forma:
Relacion1 ÷ Relacion2 = π A (Relacion1) − π A ((π A (Relacion1) × Relacion2) − Relacion1)
siendo A = {AtributosRelacion1} − {AtributosRelacion2}

Particularizando a la consulta propuesta la expresión algebraica quedaría así:
π cod pro (ventas) − π cod pro ((π cod pro (ventas) × π cod pie (pieza)) − π cod pro,cod pie (ventas))

Usando la expresión anterior podríamos expresar la consulta en SQL de la siguiente forma:
~~~sql
SQL> (Select codpro from ventas)
      MINUS
      (Select codpro
      From (
        (Select v.codpro,p.codpie From
          (Select distinct codpro From ventas) v,
          (Select codpie From pieza) p
      )
      MINUS
      (Select codpro,codpie From ventas)
      )
);
~~~

#### Aproximación basada en el Cálculo Relacional
De forma intuitiva, la manera de proceder sería:
Seleccionar proveedores tal que (
no exista (una pieza (para la que no exista un suministro de ese proveedor))
~~~sql
select s.codpro from proveedor s where not exists (
  select * from pieza p where not exists (
    select * from ventas v where v.codpie= p.codpie and v.codpro= p.codpro
  )
);
~~~

#### Aproximación mixta usando not exists y la diferencia relacional
De forma intuitiva, la manera de proceder sería:
Seleccionar proveedores tal que
(el conjunto de todas las piezas)
menos
(el conjunto de la piezas suministradas por ese proveedor)
sea vacío.
Es decir, no exista ninguna tupla en la diferencia de esos conjuntos.
~~~sql
SQL> Select codpro
from proveedor
where not exists (
(select distinct codpie from pieza)
minus
(select distinct codpie from ventas where proveedor.codpro=ventas.codpro)
);
~~~

**Ejercicio 3.24 Encontrar los códigos de las piezas suministradas a todos los proyectos
localizados en Londres.**
En AR sería: pi codpie, codpj (ventas) % pi codpj(sigma ciudad= 'Londres' (proyectos))
En CRT: {p.codpie / pieza(p) and not exists

Esto es equivalente a encontrar los códigos de las piezas tales que no existe un proyecto de
Londres que no tenga esa pieza. Hacemos pues: proveedores tales que no existe ( proyecto para el cual no existe
un suministro de esa pieza a ese proyecto). Con esto obtendríamos los códigos de las piezas suministradas a todos los
proyectos:
~~~sql
select codpie from pieza where not exists (
select * from proyecto where not exists ( select * from ventas where ventas.codpj= proyecto.codpj and
ventas.codpie=pieza.codpie));
~~~

Para especificar que los proyectos han de ser de Londres:
~~~sql
select codpie from pieza where not exists (
select * from proyecto where not exists ( select * from ventas where ventas.codpj= proyecto.codpj and
ventas.codpie=pieza.codpie) and proyecto.ciudad = 'Londres');
~~~

Esto es entonces de la forma segunda (aproximación basada en el cálculo relacional). De la forma primera (usando expresión
equivalente en AR): picodpie,codpj(ventas)%picodpj(proyecto que es de londres). Empleando la formulilla eso sería igual a:
picodpj(picodpie,codpj(ventas)) - picodpj((picodpj(picodpj,codpie(ventas) x picodpj(proyecto de londres) - picodpj, codpie(ventas)

~~~sql
select codpie from ventas
minus
(select codpie from (
(select p.codpj, v.codpie from
(select distinct codpie from ventas) v,
(select codpj from proyecto where ciudad='Londres') p)
minus
(select codpj, codpie from ventas)));
~~~

Por último, para hacerlo mediante la aproximación mixta usando
not exists y la diferencia relacional:

tenemos que seleccionar piezas tales que
(el conjunto de todos los proyectos de londres)
menos
(el conjunto de los proyectos de londres a los que se ha suministrado esas
piezas) es vacío.

~~~sql
select codpie from pieza where not exists (
(select distinct codpj from proyecto where ciudad='Londres')
minus
(select codpj from ventas
where codpj IN (select codpj from proyecto where ciudad='Londres')));
~~~

**Ejercicio 3.25 Encontrar aquellos proveedores que envían piezas procedentes de todas las
ciudades donde hay un proyecto.**

Nos quedamos con los proveedores tales que no existe una ciudad de la que venga una pieza tal que sea la ciudad de un proyecto.
~~~sql
select * from proveedor where not exists(
  select * from pieza p where not exists(
    select * from proyecto j NATURAL JOIN ventas where j.ciudad= p.ciudad
  )
);
~~~

### Funciones de agregación
En ocasiones puede ser interesante resumir la información relativa a un determinado conjunto
de tuplas. SQL incorpora una serie de funciones estándares. A continuación se presentan algunas
de ellas:
SUM(), MIN(), MAX(), AVG(), COUNT(), STDDEV()..., que respectivamente calculan: la
suma, el mínimo, el máximo, la media, el cardinal y la desviación típica sobre el conjunto
de valores pasados como argumento de la función. Cuando se usa la cláusula DISTINCT
como argumento de la función, sólo tendrá en cuenta los valores distintos para realizar la
correspondiente agregación.
Vamos a ver ejemplos de utilización de estas funciones en la cláusula SELECT.

**Ejemplo 3.19 Mostrar el máximo, el mínimo y el total de unidades vendidas.**
~~~sql
SQL> Select MAX(cantidad), MIN(cantidad), SUM(cantidad) from ventas;
Comparar y justificar el resultado con el obtenido de:
SQL> Select MAX(DISTINCT cantidad), MIN(DISTINCT cantidad), SUM(DISTINCT cantidad)
from ventas;
~~~

Pueden salir valores distintos solo en la suma, ya que se meten valores repetidos,
mas en el máximo y el mínimo se sigue quedando con la cantidad mayor o menor, luego
no influye.

**Ejercicio 3.26 Encontrar el número de envíos con más de 1000 unidades.**
`select (count *) from ventas where cantidad > 1000);`

**Ejercicio 3.27 Mostrar el máximo peso.**
`select MAX(peso) from pieza;`

**Ejercicio 3.28 Mostrar el código de la pieza de máximo peso. Compara esta solución con
las correspondientes de los ejercicios 3.14 y 3.23.**
`select codpie from pieza where peso = (select MAX(peso) from pieza);`

**Ejercicio 3.29 Comprueba si la siguiente sentencia resuelve el ejercicio anterior.**
~~~sql
SQL> select codpie, MAX(peso)
from pieza;
~~~
Da error al ejecutarse ya que estamos usando una función de agrupación junto a un select (codpie) que no es de agrupación.

**Ejercicio 3.30 Muestra los códigos de proveedores que han hecho más de 3 envíos diferentes.**
~~~sql
select codpro from proveedor s where (select (count *) from ventas v where v.codpro= s.codpro) > 3;
~~~


#### Formando grupos
Hasta aquí, las funciones de agregación se han aplicado sobre todas las tuplas que devuelve
una consulta. Sin embargo es posible realizar un particionado sobre el conjunto de las tuplas
usando la cláusula GROUP BY. Mediante esta cláusula se indica el atributo o conjunto de atributos
por cuyos valores se quiere agrupar las tuplas y proceder así a aplicar las funciones de agregación
a cada uno de los grupos.
~~~sql
SELECT [ DISTINCT | ALL]
expresion [alias_columna_expresion]
{,expresion [alias_columna_expresion]}
FROM [esquema.]tabla|vista [alias_tabla_vista]
[WHERE <condicion>]
GROUP BY expresion {,expresion}
~~~

**Ejemplo 3.20 Para cada proveedor, mostrar la cantidad de ventas realizadas y el máximo de
unidades suministrado en una venta.**
~~~sql
SQL> Select codpro, count(*), max(cantidad)
from ventas
group by (codpro);
~~~

**Ejercicio 3.31 Mostrar la media de las cantidades vendidas por cada código de pieza junto
con su nombre.**


**Ejercicio 3.32 Encontrar la cantidad media de ventas de la pieza ’P1’ realizadas por cada
proveedor.**

**Ejercicio 3.33 Encontrar la cantidad total de cada pieza enviada a cada proyecto.**







#
