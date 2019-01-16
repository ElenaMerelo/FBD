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
eliminan son aquellas que hacen cierta la expresión <condición>. Su sintaxis es la siguiente:
`DELETE [FROM] nombre_tabla [WHERE <condición>];`
Donde [] nuevamente indica opcionalidad y condición es cualquier expresión lógica.

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
por defecto. Esta sentencia devuelve en el formato día-mes-año las fechas de alta que constan en plantilla.

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

AR : π cod pro (σ codpj= 'J1' (Ventas))

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
`select * from pieza where peso >= ALL (select peso from pieza);` o `select MAX(peso) from pieza;`

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
`select nompro, cantidad from proveedor s, (select codpro from ventas where cantidad >= 800) y where s.codpro= y.codpro`.
O: `select nompro, cantidad from proveedor s, ventas v where v.cantidad >= 800 and s.codpro= v.codpro`

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
`select codpie from ventas v, (select * from proveedor where ciudad= 'Madrid') p where v.codpro= p.codpro`

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
Solución que consta en el cuaderno de prácticas, usando el operador exists:
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
select codpie from pieza where peso > ALL (select peso from pieza where nombre like '_ornillo');
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
De forma intuitiva, la manera de proceder para obtener el código de los proveedores que suministran todas las piezas sería:
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
Haciéndolo con reunión natural, join on y producto cartesiano:
~~~sql
select codpie, nompie, AVG(cantidad)
from ventas natural join pieza
group by codpie, nompie;

select AVG(cantidad), v.codpie, nompie from ventas v JOIN (select nompie, codpie from pieza p) ON p.codpie= v.codpie group by codpie, nompie;

select AVG(cantidad), v.codpie, nompie from ventas v, pieza p where p.codpie= v.codpie group by codpie, nompie;

~~~

**Ejercicio 3.32 Encontrar la cantidad media de ventas de la pieza ’P1’ realizadas por cada
proveedor.**
~~~sql
select AVG(cantidad) from ventas where codpie= 'P1' group by codpro;
~~~

**Ejercicio 3.33 Encontrar la cantidad total de cada pieza enviada a cada proyecto.**
~~~sql
select SUM(cantidad), codpie from ventas group by codpro;
~~~

#### Seleccionando grupos
Hasta ahora cuando se definían los grupos, todos formaban parte del resultado. Sin
embargo, es posible establecer condiciones sobre los grupos mediante la cláusula HAVING junto
con una <condición>, de forma parecida a cómo se hace con la cláusula WHERE sobre tuplas.
Esto es, la condición se aplica sobre los grupos y determina que grupos aparecen como resultado
de la consulta. La <condición> a satisfacer por lo grupos se elabora utilizando alguna de las
funciones de agregación vistas y componiendo una expresión booleana con los operadores ya
conocidos.
~~~sql
SELECT [ DISTINCT | ALL]
expresion [alias_columna_expresion]
{,expresion [alias_columna_expresion]}
FROM [esquema.]tabla|vista [alias_tabla_vista]
[WHERE <condicion>]
GROUP BY expresion {,expresion}
[HAVING <condicion>]
~~~

**Ejemplo 3.21 Hallar la cantidad media de ventas realizadas por cada proveedor, indicando
solamente los códigos de proveedores que han hecho más de 3 ventas.**
~~~sql
select AVG(cantidad) from ventas group by codpro having count(*) > 3;
~~~

Para integrar los nuevos conceptos de selección de grupos con los antiguos de selección de
tuplas vamos a plantear una consulta donde se combinan las cláusulas where y having.

**Ejemplo 3.22 Mostrar la media de unidades vendidas de la pieza ’P1’ realizadas por cada
proveedor, indicando solamente la información de aquellos proveedores que han hecho entre 2 y
10 ventas.**
~~~sql
select codpro, codpie, AVG(cantidad) from ventas where
codpie='P1' group by
codpro, codpie having
count(*) between 2 and 10;
~~~

**Ejemplo 3.23 Encuentra los nombres de proyectos y cantidad media de piezas que recibe por
proveedor.**

Haciéndolo con reunión natural, producto cartesiano y join on respectivamente:
~~~sql
select nompj, avg(cantidad), codpro from ventas natural join proyecto group by codpro, nompj;

select nompj, avg(cantidad), codpro from ventas v, proyecto j where v.codpj= j.codpj group by codpro, nompj;

select nompj, avg(cantidad), codpro from ventas v join(select * from proyecto j) on v.codpj= j.codpj group by codpro, nompj;
~~~

En el cuaderno de prácticas la solución que da es:
~~~sql
SQL> Select v.codpro, v.codpj, j.nompj, AVG(v.cantidad)
from ventas v, proyecto j
where v.codpj=j.codpj
group by (v.codpj, j.nompj,v.codpro);
~~~

**Ejercicio 3.34 Comprueba si es correcta la solución anterior.**
Primero que solo nos piden nompj y avg, luego lo demás podríamos quitarlo, y nompj, cantidad
no dan lugar a ambiguedades, por lo que no haría falta el uso de alias, ídem con el codpro, pero por lo demás es correcta.

**Ejercicio 3.35 Mostrar los nombres de proveedores tales que el total de sus ventas superen
la cantidad de 1000 unidades.**
~~~sql
select nompro from proveedor NATURAL JOIN ventas where sum(cantidad) > 1000;
~~~

Otra opción:
~~~sql
select nompro from proveedor p NATURAL JOIN ventas v group by (p.codpro, nompro) having sum(cantidad) > 1000;
~~~

**IMPORTANTE**: todos los campos que usemos en el _select_, deben aparecer en el _group by_, en caso contrario, dará error.

#### Subconsultas en la cláusula HAVING
Ya hemos visto cómo una consulta compleja se puede fragmentar en varias subconsultas
anidadas introduciendo una subconsulta en la cláusula WHERE y combinando los resultados. No
es éste el único lugar dónde se pueden utilizar subconsultas, también puede hacerse en la cláusula
HAVING.

**Ejemplo 3.24 Mostrar el proveedor que más ha vendido en total.**
~~~sql
SQL> Select codpro, sum(cantidad)
from ventas
group by codpro
having sum(cantidad) = (select max(sum(V1.cantidad))
from ventas V1
group by V1.codpro);
~~~

**Ejercicio 3.36 Mostrar para cada pieza la máxima cantidad vendida.**
~~~sql
select nompie, v.codpie, MAX(cantidad) from pieza natural join ventas v group by (codpie, nompie);

select codpie, MAX(cantidad) from ventas group by codpie;
~~~

### Consultas adicionales
#### Consultas con el tipo DATE
> Uso de fechas en la cláusula SELECT.

Para ello utilizamos la función de conversión to_char(), para la conversión de una fecha a una cadena
en un formato determinado por los parámetros que están en la tabla 2.3 del cuaderno.

**Ejemplo 3.25 Lista las fechas de las ventas en un formato día, mes y año con 4 dígitos.**
`select to_date(fecha, 'dd-mm-yyyy') from ventas;`

>Uso de fechas en la cláusula WHERE.

Hacemos uso de la función de conversión to_date() para hacer comparaciones entre fechas
en formato interno.

**Ejemplo 3.26 Encontrar las ventas realizadas entre el 1 de enero de 2002 y el 31 de diciembre de 2004.**
~~~sql
select * from ventas where
fecha between to_date('dd-mm-yyyy', 01-01-2002) and
fecha < to_date('dd-mm-yyyy', 31-12-2004);
~~~

**Ejercicio 3.37 Comprueba que no funciona correctamente si las comparaciones de fechas se
hacen con cadenas.**

**Ejemplo 3.27 Mostrar las piezas que nunca fueron suministradas después del año 2001.**
La primera opción que se me ocurre es seleccionar las piezas cuyo código no está en una venta posterior a 2001,
en la segunda lo pongo expresado de otra manera, pero hace lo mismo: selecciona piezas
cuyo código está en una venta anterior a 2001, y por último otra forma es seleccionar las piezas para
las que no existe una venta que tenga su código y se posterior a 2001.
~~~sql
select * from pieza where codpie not in (
  select codpie from ventas where fecha > to_date('yyyy', 2001)
);

select * from pieza where codpie in(
  select codpie from ventas where fecha < to_date('yyyy', 2001)
);

select * from pieza p where not exists (
  select * from ventas v where v.codpie= p.codpie and fecha > to_date('yyyy', 2001)
);
~~~

Como está resuelto en el cuaderno:
~~~sql
SQL> (select distinct codpie from pieza)
minus
(select distinct codpie from ventas
where to_number(to_char(fecha,’YYYY’)) > 2001);
~~~

ó

~~~sql
select p.codpie from pieza p where not exists
(select * from ventas v where to_number(to_char(v.fecha,’YYYY’)) > 2001
and v.codpie=p.codpie);
~~~

> Uso de fechas en la cláusula GROUP BY.

**Ejemplo 3.28 Agrupar los suministros de la tabla de ventas por años y sumar las cantidades
totales anuales.**
~~~sql
SQL> Select to_char(fecha,’YYYY’), SUM(cantidad)
from ventas
group by to_char(fecha,’YYYY’);
~~~

**Ejercicio 3.38 Encontrar la media de productos suministrados cada mes.**
~~~SQL
select AVG(cantidad), to_char(fecha, 'MM') from ventas group by to_char(fecha, 'MM');
~~~

#### Otras consultas sobre el catálogo
Ya podemos consultar con cierto detalle algunas de las vistas del catálogo.

**Ejemplo 3.29 Mostrar la información de todos los usuarios del sistema; la vista que nos
interesa es ALL_USERS.**
~~~sql
SQL> Select *
from ALL_USERS;
~~~

Puede interesar primero ver el esquema de tal vista mediante `DESCRIBE ALL_USERS` para hacer
una proyección más selectiva.

**Ejemplo 3.30 Queremos saber qué índices tenemos definidos sobre nuestras tablas, pero en
esta ocasión vamos a consultar al propio catálogo para que nos muestre algunas de las vistas que
contiene (así ya no necesitamos chuleta).**
~~~sql
SQL> DESCRIBE DICTIONARY;
SQL> select * from DICTIONARY
where table_name like ’%INDEX%’
~~~

**Ejercicio 3.39 ¿ Cuál es el nombre de la vista que tienes que consultar y qué campos te
pueden interesar?**

**Ejercicio 3.40 Muestra las tablas ventas a las que tienes acceso de consulta junto con el
nombre del propietario y su número de identificación en el sistema.**

**Ejercicio 3.41 Muestra todos tus objetos creados en el sistema. ¿Hay algo más que tablas?**

Estos ejercicios habría que hacerlos en el ordenador del aula.


#### Ejercicios adicionales

**Ejercicio 3.42 Mostrar los códigos de aquellos proveedores que hayan superado las ventas
totales realizadas por el proveedor ’S1’.**
~~~sql
select codpro from ventas where sum(count(*)) > sum(select (count *) from ventas where codpro= 'S1');
~~~

**Ejercicio 3.43 Mostrar los mejores proveedores, entendiéndose como los que tienen mayores
cantidades totales.**
~~~sql
select * from proveedor where codpro in (
  select codpro from ventas where cantidad= max(sum(cantidad))
);
~~~

**Ejercicio 3.44 Mostrar los proveedores que venden piezas a todas las ciudades de los
proyectos a los que suministra ’S3’, sin incluirlo.**
Para ello mostramos los proveedores para los que no existe una pieza que vendan a una ciudad que no
sea de un proyecto al que suministra s3:
~~~sql
select * from proveedor s where s.codpro != 'S3' and s.codpro in (
  select v.codpro from ventas v where not exists(
    select * from pieza p where not exists(
      select j.ciudad from proyecto j where j.codpj= v.codpj and p.codpie= v.codpie and v.codpro= 'S3'
    )
  )
);
~~~

**Ejercicio 3.45 Encontrar aquellos proveedores que hayan hecho al menos diez pedidos.**
~~~sql
select * from proveedor where count(*) >= 10;
~~~
Usando el group by y having:
~~~sql
select codpro
from ventas
group by codpro
having count(*) >= 10;
~~~

**Ejercicio 3.46 Encontrar aquellos proveedores que venden todas las piezas suministradas
por S1.**
~~~sql
select * from proveedor t where not exists(
  select * from pieza p where exists(
    select * from ventas v where v.codpie= p.codpie and v.codpro='S1'
  )
  AND
  not exists (select * from ventas v where v.codpie=p.codpie and v.codpro=t.codpro)
);
~~~

Así nos quedamos con los proveedores para los que no existe una pieza suministrada por S1 que sea suministrada por ese proveedor,
no existe una pieza suministrada por S1 que no sea vendida por ellos.

**Ejercicio 3.47 Encontrar la cantidad total de piezas que ha vendido cada proveedor que
cumple la condición de vender todas las piezas suministradas por S1.**
~~~sql
select codpro, sum(cantidad) from ventas where codpro in (
  select * from proveedor t where not exists(
    select * from pieza p where exists(
      select * from ventas v where v.codpie= p.codpie and v.codpro='S1'
    )
    AND
    not exists (select * from ventas v where v.codpie=p.codpie and v.codpro=t.codpro)
  )
) group by codpro;
~~~
Es coger la consulta de antes y calcular la suma total y quedarnos con el codpro.

**Ejercicio 3.48 Encontrar qué proyectos están suministrados por todos lo proveedores que
suministran la pieza P3.**


**Ejercicio 3.49 Encontrar la cantidad media de piezas suministrada a aquellos proveedores
que venden la pieza P3.**

**Ejercicio 3.50 Queremos saber los nombres de tus índices y sobre qué tablas están montados,
indica además su propietario.**

**Ejercicio 3.51 Implementar el comando DESCRIBE para tu tabla ventas a través de una
consulta a las vistas del catálogo.**

**Ejercicio 3.52 Mostrar para cada proveedor la media de productos suministrados cada año.**

**Ejercicio 3.53 Encontrar todos los proveedores que venden una pieza roja.**

**Ejercicio 3.54 Encontrar todos los proveedores que venden todas las piezas rojas.**

**Ejercicio 3.55 Encontrar todos los proveedores tales que todas las piezas que venden son
rojas.**

**Ejercicio 3.56 Encontrar el nombre de aquellos proveedores que venden más de una pieza
roja.**

**Ejercicio 3.57 Encontrar todos los proveedores que vendiendo todas las piezas rojas cumplen
la condición de que todas sus ventas son de más de 10 unidades.**

**Ejercicio 3.58 Coloca el status igual a 1 a aquellos proveedores que sĺo suministran la pieza
P1.**

**Ejercicio 3.59 Encuentra, de entre las piezas que no se han vendido en septiembre de 2009,
las ciudades de aquéllas que se han vendido en mayor cantidad durante Agosto de ese mismo
año.**

## El esquema externo en un SGBD
### Creación y manipulación de vistas
Una vista es una presentación de datos procedentes de una o más tablas, hecha a la medida
de un usuario. Básicamente, consiste en asignar un nombre a la salida de una consulta y utilizarla
como si de una tabla almacenada se tratara. De hecho, en general, pueden usarse en lugar de
cualquier nombre de tabla en las sentencias del DML. La vista es la estructura de más alto nivel
dentro del nivel lógico y, de hecho, es el mecanismo básico de implementación del nivel externo.
Salvo que se especifique lo contrario, las vistas no contienen datos; su definición se almacena
en el diccionario y los datos que representan se reconstruyen cada vez que se accede a ellos.
A pesar de esto, en Oracle se pueden aplicar restricciones de integridad mediante el uso de
disparadores de tipo “INSTEAD OF” , que interceptan operaciones DML sobre las vistas para
programar sus efectos sobre las tablas de las que se derivan.
Gracias a las vistas, podemos establecer niveles de seguridad adicionales a los que ofrezca el
sistema, ya que se puede ocultar cierta información y hacer visible a los usuarios sólo la parte de
la BD que necesiten para realizar sus tareas. Además, simplifican el aspecto la BD y el uso de
algunos comandos. Como hemos comentado anteriormente, el catálogo de la BD es una porción
de la misma que usa las vistas para mostrar a cada usuario la información que le concierne de la
estructura de la BD.

En SQL, la creación de una vista se hace mediante el comando CREATE VIEW, según se
muestra en el siguiente ejemplo:

**Ejemplo 4.1 Extraer el conjunto de suministros realizados sólo con integrantes procedentes
de Paris.**
~~~sql
CREATE VIEW VentasParis (codpro,codpie,codpj,cantidad,fecha) AS
SELECT codpro,codpie,codpj,cantidad,fecha
FROM ventas
WHERE (codpro,codpie,codpj) IN
(SELECT codpro,codpie,codpj
FROM proveedor,pieza,proyecto
WHERE proveedor.ciudad=’Paris’ and
pieza.ciudad=’Paris’ and
proyecto.ciudad=’Paris’);
~~~
En la cláusula AS se especifica la consulta que determina qué filas y columnas de la tabla o tablas
almacenadas forman parte de la vista.
La ejecución de esta sentencia básicamente produce la inserción de una fila en el catálogo.
La información registrada puede consultarse a través de la vista `all_views`, cuyos atributos más
relevantes son :
`all_views(owner,view_name,text)`, donde owner es el propietario de la vista, view_name el nombre que se le ha asignado y text
la sentencia select que permite reconstruirla.

#### Consulta de vistas
A partir de este momento, cualquier usuario autorizado podrá hacer uso de la vista VentasParis
como si de cualquier tabla se tratara. Así por ejemplo, podemos consultar la relación VentasParis
y de ella mostrar los códigos de proveedores que suministran al proyecto J4.
~~~sql
SELECT distinct codpro
FROM VentasParis
WHERE codpj=’J4’;
~~~

#### Actualización de vistas
Por su carácter virtual, existen fuertes restricciones a la hora de insertar o actualizar datos en
una vista debido principalmente a que no siempre cada fila de una vista se corresponde con una
fila de una tabla concreta. Cuando esto sucede, puede resultar imposible aplicar una modificación
sobre una fila o un campo de una vista al no poderse encontrar el origen ni la ubicación real de
la información a modificar. Por ello, los comandos DELETE, INSERT, UPDATE sólo se podrán
utilizar en determinadas ocasiones.
Algunas de las restricciones más relevantes son:
La definición de la vista no podrá incluir cláusulas de agrupamiento de tuplas (GROUP
BY) o funciones de agregación (MAX, COUNT, AVG,. . . ).
La definición de la vista no podrá incluir la cláusula DISTINCT, para evitar que una misma
fila en la vista se corresponda con más de una fila de la tabla base.
La definición de la vista no podrá incluir operaciones de reunión ni de conjuntos, esto es,
deberá construirse sobre una única tabla base.
Todos los atributos que deban tomar siempre valor (NOT NULL y PRIMARY KEY) han
de estar incluidos necesariamente en la definición de la vista.
Como puede verse, todas estas restricciones van encaminadas a evitar la ambigüedad que
pudiera surgir si el sistema no encontrara una correspondencia única entre una tupla de la vista
y una tupla de una tabla base, que es, en definitiva, donde se van a reflejar las modificaciones
hechas sobre la vista. Como hemos mencionado, el uso de disparadores “INSTEAD OF”, puede
ayudar a solventar algunas de estas restricciones.

**Ejemplo 4.2 Extraer el conjunto de piezas procedentes de Londres, prescindiendo del atributo
ciudad de la tabla original.**
Para ello creamos una vista que contiene el conjunto de piezas procedentes de Londres sin poner la ciudad, y luego las mostramos
con `select * from ventasLondres`.
~~~sql
create view ventasLondres(codpie, nompie, color, peso) as
  select codpie, nompie, color, peso from pieza where ciudad= 'Londres';
~~~

Sobre la vista anterior hacemos una inserción del tipo:
~~~sql
INSERT INTO PiezasLondres
VALUES(’P9’,’Pieza 9’,’rojo’,90);
~~~

La vista PiezasLondres cumple las condiciones para actualizar la tabla Piezas, pero
inserta NULL como valor para Ciudad, ya que este atributo no pertenece a la vista.

#### Eliminación de vistas
El comando para borrar una vista es :
`DROP VIEW <vista>`.
Si lo que se pretende es cambiar la definición de una vista existente, es mejor utilizar la
sentencia:
`CREATE OR REPLACE VIEW ...<vista>`,
de esta forma redefiniremos una vista existente sin perder todos los privilegios de acceso
otorgados sobre la misma.
Para eliminar la vista de nuestro ejemplo la sentencia será:
`DROP VIEW VentasParis;`

#### Ejercicios de vistas
**Ejercicio 4.1 Crear una vista con los proveedores de Londres. ¿Qué sucede si insertamos
en dicha vista la tupla (’S7’,’Jose Suarez’,3,’Granada’)?. (Buscar en [7] la cláusula52
El esquema externo en un SGBD
WITH CHECK OPTION ).**
~~~sql
create view proveedoresLondres(codpro, nompro, status) as
  select codpro, nompro, status from proveedor where ciudad= 'Londres';
~~~
Al insertar una nueva tupla que tenga el campo ciudad con valor _Granada_ estaríamos insertando una tupla errónea en la tupla. Para asegurar la consistencia de la vista usamos la cláusula `WITH CHECK OPTION`.
~~~sql
create view proveedoresLondres (codpro, nompro, status, ciudad) AS
    select codpro, nompro, status, ciudad
    from proveedor
    where ciudad='Londres' with check option;
~~~

**Ejercicio 4.2 Crear una vista con los nombres de los proveedores y sus ciudades. Inserta
sobre ella una fila y explica cuál es el problema que se plantea. ¿Habría problemas de
actualización?**
~~~sql
create view proveedoresYciudades(nompro, ciudad) as
  select nompro, ciudad from proveedor;
~~~
No habría problemas dado que aunque nompro debe ser no nulo, al estar dentro de la
vista podemos modificarlo.

**Ejercicio 4.3 Crear una vista donde aparezcan el código de proveedor, el nombre de provee-
dor y el código del proyecto tales que la pieza suministrada sea gris. Sobre esta vista realiza
alguna consulta y enumera todos los motivos por los que sería imposible realizar una inserción.**
~~~sql
create view piezasGrises(codpro, nompro, codpj) as
  select codpro, nompro, codpj from ventas NATURAL JOIN proveedor NATURAL JOIN pieza
  where color= 'Gris';
~~~
No se pueden insertar tuplas ya que estamos usando operaciones sobre conjuntos y estamos dejando campos con condiciones `not null` y `primary key` sin especificar en la vista.

### Información acerca de la base de datos: las vistas del catálogo
Una vez que conocemos el funcionamiento de las vistas, vamos a estudiar en este apartado el
catálogo o diccionario de datos de un sistema gestor de bases de datos. El catálogo de la base de
datos está formado por una serie de tablas y vistas que almacenan datos sobre todos los objetos
que hay en nuestra base de datos (tablas, restricciones, usuarios, roles, privilegios, ...). Para poder
ver las vistas en su totalidad hacen falta privilegios especiales, y para modificarlas también. Por
esta razón, hay definidas una serie de vistas para las consultas más habituales que nos permiten
acceder a nuestra información.

#### Algunas vistas relevantes del catálogo de la base de datos
La Tabla 4.1 muestra algunas vistas relevantes que podemos consultar en el catálogo. Una de
las más útiles es la vista USER_TABLES, que contiene información sobre las tablas de las que
el usuario es propietario. Algunos de los atributos que el usuario puede consultar son: el nombre
de la tabla (atributo TABLE_NAME) y el espacio de tablas donde se encuentra almacenada
(atributo TABLESPACE_NAME). Además, podemos encontrar información estadística sobre su
tamaño (NUM_ROWS, AVG_SPACE), y muchas otras cosas más.
**Ejercicio 4.4 Ver la descripción de la vista del catálogo USER_TABLES.**
`describe user_tables;`

### Gestión de privilegios
El objetivo de este apartado es identificar los distintos tipos de privilegios que se pueden
gestionar en Oracle, distinguiendo entre privilegios sobre el sistema y sobre los objetos.
También haremos algunos ejercicios sobre cómo otorgar y retirar privilegios.

#### Privilegios del sistema
Permiten al usuario llevar a cabo acciones particulares en la base de
datos. Existen más de 80 privilegios, y su número continúa aumentando con
cada nueva versión del SGBD Oracle. Sólo usuarios con privilegios de administración pueden
gestionar este tipo de privilegios, que pueden clasificarse como sigue:
+ Privilegios que autorizan operaciones de alto nivel en el sistema (como por ejemplo
CREATE SESSION y CREATE TABLESPACE).

+ Privilegios que autorizan la gestión de objetos en el propio esquema de usuario (como por
ejemplo CREATE TABLE).

+ Privilegios que autorizan la gestión de objetos en cualquier esquema (como por ejemplo
CREATE ANY TABLE).

Vistas relevantes del catálogo:
+ `DICTIONARY`
Descripciones de las tablas y vistas del diccionario de datos.

+ `USER_CATALOG`
Tablas, vistas, clusters, índices, sinónimos
y secuencias propiedad del usuario.

+ `USER_CONSTRAINTS`
Definiciones de restricciones sobre las tablas del usuario.

+ `USER_CONS_COLUMNS`
Columnas propiedad del usuario y que se han especificado en la
definición de restricciones.

+ `USER_ROLE_PRIVS`
Roles autorizados al usuario (de administrador, usuario por defecto, ...).

+ `USER_SYS_PRIVS`
Privilegios del sistema concedidos al usuario.

+ `USER_TAB_COLUMNS`
Descripción de las columnas de las tablas, vistas y clusters pertenecientes
al usuario.

+ `USER_TABLES`
Tablas del usuario con su nombre, número de columnas,
información relativa al almacenamiento, estadísticas, ...

+ `USER_INDEXES`
Información de los índices del usuario.

+ `USER_CLUSTERS`
Información de los clústers del usuario.

+ `USER_TABLESPACES`
Espacios de tablas a los que puede acceder el usuario.

+ `USER_USERS`
Información sobre el usuario actual.

+ `ALL_USERS`
Información sobre los usuarios del sistema.

+ `ALL_TABLES`
Información de aquellas tablas a los que tenemos acceso
porque el propietario lo haya especificado así.

+ `ALL_VIEWS`
Información de aquellas vistas a las que tenemos acceso.

Hay dos comandos del DDL que se encargan de controlar los privilegios: GRANT y REVOKE. Estos permiten otorgar y retirar privilegios a un usuario o a un “role”.

> Concesión de privilegios de sistema

~~~sql
GRANT {system_priv | role} [,{system_priv | role}] ... TO {user | role | PUBLIC} [,{user | role |
PUBLIC}]...
[WITH ADMIN OPTION]
~~~

+ PUBLIC se refiere a todos los usuarios.

+ WITH ADMIN OPTION permite que el usuario autorizado pueda otorgar a su vez el
privilegio a otros.

> Derogación de privilegios de sistema

~~~sql
REVOKE {system_priv | role} [,{system_priv | role}] ... FROM {user | role | PUBLIC} [,{user | role
| PUBLIC}]...
~~~

Sólo permite derogar privilegios que hayan sido explícitamente concedidos mediante el
uso de GRANT.
Hay que vigilar los efectos sobre otros privilegios al derogar uno dado.
No hay efecto de cascada aunque se haya usado en el GRANT la opción WITH ADMIN
OPTION.
Para gestionar los privilegios del sistema desde SQL Developer A, el usuario debe poseer
el “role dba” y, en ese caso, podrá acceder a esta herramienta como “DBA” a partir del menú
Ver|DBA, tras autentificarse en una conexión con privilegios de administración, podrá desplegar
la lista de usuarios, seleccionar el usuario deseado, desplegar el menú contextual con el botón
derecho del ratón y seleccionar la opción “Editar”. A través del formulario que aparecerá podrá,
entre otras acciones, otorgar y revocar, privilegios y “roles” del sistema.

#### Privilegios sobre los objetos
La concesión de este tipo de privilegios autoriza la realización de ciertas operaciones sobre
objetos concretos. La Tabla 4.2 muestra los distintos privilegios que se pueden utilizar en
relación con los diferentes objetos de la base de datos.

> Concesión de privilegios sobre objetos

~~~sql
GRANT {object_priv [(column_list)] [,object_priv [(column_list)]] ... | ALL [PRIVILEGES]
ON [schema.]object
TO {user | role | PUBLIC} [,{user | role | PUBLIC}]... [WITH GRANT OPTION]
~~~
+ La lista de columnas sólo tiene sentido cuando se refieren a privilegios INSERT, REFE-
RENCES o UPDATE.

+ ALL se refiere a todos los privilegios que han sido concedidos sobre el objeto con WITH
GRANT OPTION.

+ WITH GRANT OPTION autoriza al usuario para conceder a su vez el privilegio. No se
puede usar al conceder privilegios a roles.

> Derogación de privilegios de objetos

~~~sql
REVOKE {object_priv [(column_list)] [,object_priv [(column_list)]]... | ALL [PRIVILEGES]} ON
[schema.]object FROM {user | role | PUBLIC} [,{user | role | PUBLIC}]... [CASCADE CONSTRAINTS]
~~~

CASCADE CONSTRAINTS propaga la derogación hacia restricciones de integridad
referencial relacionadas con el privilegio REFERENCES o ALL.
Un usuario sólo puede derogar aquellos privilegios que él mismo haya concedido mediante
GRANT a otro.
Siempre se hace derogación en cascada con respecto a la concesión con la opción WITH
GRANT OPTION.
Desde SQL Developer también se pueden otorgar y retirar privilegios sobre objetos, con
sólo marcar el objeto en cuestión y, tras desplegar el menú contextual con el botón derecho del
ratón, seleccionar la opción apropiada en el menú Privilegios (Otorgar o Revocar).

#### Ejercicios de gestión de privilegios

**Ejercicio 4.5 Complete la siguiente secuencia:**
+ Crear en la cuenta una tabla cualquiera.
`CREATE TABLE acceso (testigo number);`

+ Insertar algunas tuplas de prueba.
~~~sql
INSERT INTO acceso VALUES(1);
INSERT INTO acceso VALUES(2);
~~~

+ Autorizar al usuario de tu derecha para que pueda hacer consultas sobre esa tabla.
`GRANT SELECT ON acceso TO usuario_derecha;`

+ Comprobar que se puede acceder a la tabla del usuario de la izquierda.
`SELECT * FROM usuario_izquierda.acceso;`

+ Retirar el privilegio de consulta antes concedido.
`REVOKE SELECT ON acceso FROM usuario_derecha;`

+ Autorizar ahora al usuario de la derecha para que pueda hacer consultas sobre la tabla,
pero ahora con posibilidad de que este propague ese privilegio.
`GRANT SELECT ON acceso TO usuario_derecha WITH GRANT OPTION;`

+ Propagar el privilegio concedido por el usuario de la izquierda hacia el usuario de la
derecha.
`GRANT SELECT ON usuario_izquierda.acceso TO usuario_derecha;`

+ Comprobar que se pueden acceder a las tablas del usuario de la derecha y del anterior.
~~~sql
SELECT * FROM usuario_izquierda.acceso;
SELECT * FROM usuario_izquierda_del_usuario_izquierda.acceso;
~~~

+ Retira el privilegio antes concedido. ¿Qué ocurre con los accesos?
~~~sql
REVOKE SELECT ON acceso FROM usuario_derecha;
SELECT * FROM
usuario_izquierda.acceso;
SELECT * FROM usuario_izquierda_del_usuario_izquierda.acceso;
~~~

## El nivel interno de un SGBD
### Creación y manipulación de índices
En el mundo de las bases de datos relacionales, los índices son estructuras que se pueden crear
asociadas a tablas y “clusters”, con el objetivo de acelerar algunas sentencias SQL ejecutadas
sobre ellos.
La ausencia o presencia de un índice asociado a una tabla no influye en la sintaxis de las
sentencias SQL ejecutadas sobre esa tabla. El índice es un medio usado de forma automática por
un SGBD para acceder de forma rápida a la información de la tabla.
Un SGBD hace uso de los índices para incrementar el rendimiento cuando:
+ Busca registros con valores específicos en columnas indexadas
+ Accede a una tabla en el orden de las columnas del índice

#### Selección de índices
Los índices se crean para aumentar la eficiencia en los accesos a las tablas de la base de
datos, sin embargo ralentizan las actualizaciones y ocupan espacio en disco, ya que, cuando se
realizan actualizaciones de una tabla de la base de datos, cada uno de los índices basados en esa
tabla necesita también una actualización.
Antes de crear un índice se debe determinar si es necesario, es decir, se debe estimar si el
beneficio en el rendimiento que se obtendrá supera al costo derivado de su mantenimiento.
El usuario sólo debe crear aquellos índices que considere necesarios y el SGBD se encargará
de usarlos y mantenerlos automáticamente. El mantenimiento implica la modificación necesaria
del índice cuando se añaden, modifican o eliminan registros de la tabla.
Cuando creamos una tabla, Oracle crea automáticamente un índice asociado a la llave
primaria de la misma. Por tanto, no es necesario ni conveniente crear índices sobre la llave
primaria porque no sólo no se consigue mejorar el rendimiento sino que se empeora al tener que
mantener un índice más.
En esta unidad ejercitaremos el uso de índices basados en árboles B* y otro tipo de índices
que pueden resultar más útiles en determinadas situaciones.
Como conclusión, es importante utilizar los índices que se necesiten realmente y se deben
borrar si no resultan de utilidad frente a las operaciones de consulta habituales.

#### Creación de índices
Para la creación de índices usaremos la sentencia `CREATE INDEX` cuya sintaxis básica es:
~~~sql
CREATE INDEX nombre_del_indice
ON tabla(campo [ASC | DESC],...)
~~~

**Ejemplo 5.1 Si queremos acelerar las consultas cuando busquemos a un proveedor por su
nombre podemos crear un índice asociado al campo nompro de la tabla proveedor.**
`CREATE INDEX indice_proveedores ON proveedor(nompro);`

Cuando se crea una tabla es mejor insertar los registros antes de crear el índice. Si se crea
antes el índice, Oracle deberá actualizarlo cada vez que se inserte un registro.

**Ejemplo 5.2 Podemos comprobar la creación de este índice mediante la siguiente consulta al
catálogo.**
`SELECT * FROM user_indexes WHERE index_name like ’INDICE_PROVEEDORES’;`


#### Índices compuestos
Un índice compuesto es aquél creado sobre más de un campo de la tabla.
Los índices compuestos pueden acelerar la recuperación de información cuando la condición
de la consulta correspondiente referencie a todos los campos indexados o sólo a los primeros. Por
tanto, el orden de las columnas usado en la definición del índice es importante; generalmente, los
campos por los que se accede con mayor frecuencia se colocan antes en la creación del índice.
Supongamos que tenemos una tabla libros con los campos código, título, autor, editorial y
género y creamos un índice compuesto sobre los campos género, título y editorial :
`CREATE INDEX indicelibros ON libros(genero,titulo,editorial);`

Dicho índice acelerará la recuperación de información de las consultas cuya condición
incluya referencias al campo género, a los campos género y título o a los campos género, título y
editorial. Por ejemplo:
~~~sql
SELECT codigo FROM libros WHERE genero=’novela’ and
titulo=’Sin noticias de Gurb’;

SELECT codigo FROM libros WHERE genero=’novela’ and
titulo=’Sin noticias de Gurb’
and editorial=’Planeta’;
~~~

Sin embargo no mejorará el acceso cuando las consultas no incluyan referencias a los
primeros campos del índice. Por ejemplo:
~~~sql
SELECT codigo FROM libros WHERE titulo=’Sin noticias de Gurb’;

SELECT codigo FROM libros WHERE genero=’novela’ and
editorial=’Planeta’;
~~~

#### Estructura de los índices
Cuando se crea un índice, Oracle recupera los campos indexados de la tabla y los ordena.
A continuación almacena en una estructura especial los valores de los campos indexados junto
con un identificador (ROWID) del registro correspondiente.
Oracle usa árboles B* balanceados para igualar el tiempo necesario para acceder a cualquier
fila.
#### Eliminación de índices
Son varias las razones por las que puede interesar eliminar un índice:

+ El índice no se necesitará más

+ Por las características de la tabla el índice no mejora la eficiencia

+ Necesitamos cambiar los campos que se indexan
+ Necesitamos rehacer un índice muy fragmentado

Para eliminar un índice usaremos la sentencia:
`DROP INDEX nombre_del_indice;`
Se debe tener en cuenta que cuando se borra una tabla también se borran todos los índices
asociados.
Los índices que Oracle crea asociados a las llaves primarias sólo se pueden borrar elimi-
nando dichas restricciones.

#### Creación y uso de otros tipos de Índices
Existen otros tipos de índices cuyo uso está recomendado para determinadas circunstancias.
> Índices por clave invertida

Están basados en árboles B* e invierten el orden de los bytes de la clave para indizar las
tuplas. Mejoran el rendimiento en configuraciones paralelizadas de Oracle ((varias instancias
del RDBMS en ejecución sobre la misma BD) cuando se accede de forma secuencial a los valores
de la clave. Esto es así porque, para una indexación normal, si una instancia accede a un valor de
la clave y otra instancia al siguiente, se produce una contención de bloque de la primera instancia
con respecto a la segunda. En cambio, usando el índice invertido, los valores consecutivos de la
clave no estarán de forma consecutiva en el índice y, por tanto, no se producirá tal contención,
mejorando el rendimiento. La contrapartida por el uso de este tipo de índice es que las búsquedas
por rangos del valor de la clave no se pueden realizar en el conjunto secuencia, empeorando el
rendimiento. La sintaxis es la misma que la de los índices normales salvo que se usa la cláusula
REVERSE para indicar que son de este tipo de índice:
`CREATE INDEX nombre_del_indice ON tabla(campo [ASC | DESC], ...) REVERSE;`

>Índices BITMAP

Cuando los valores de la clave tiene una baja cardinalidad, el uso de este tipo de índice puede
ser apropiado. Se usa la cláusula BITMAP para indicar que son de este tipo de índice. Ejemplo
de uso frente a índice normal:
1. Crear tabla ejemplo: `CREATE TABLE Prueba_Bit (color Varchar2(10))`;

2. Insertar 50000 tuplas con valores de color aleatorios. Ejecutar:
~~~sql
BEGIN
FOR i IN 1..50000 LOOP
INSERT INTO Prueba_bit (
select decode(round(dbms_random.value(1,4)),1,’Rojo’,2,’Verde’,
3,’Amarillo’,4,’Azul’) from dual);
END LOOP;
END;
~~~

3. Crear un índice normal: `CREATE INDEX Prueba_IDX ON Prueba_Bit(color);`

4. Ejecutar:
~~~sql
SELECT count(*) FROM Prueba_Bit
WHERE color=’Amarillo’ OR color=’Azul’;
~~~

5. Apuntar el tiempo empleado.

6. Pinchar el botón “Explicación del Plan” (F10) para ver el plan seleccionado para ejecutar
esa consulta.

7. Borrar índice normal: `DROP INDEX Prueba_IDX;`

8. Crear índice BITMAP:
`CREATE BITMAP INDEX Prueba_BITMAP_IDX ON Prueba_Bit(color);`

9. Volver a ejecutar la consulta anterior.

> Tablas organizadas por Índice (IOT)

Este tipo de tablas organizan sus tuplas según el valor de la clave utilizando una estructura de
árbol B*. La diferencia respecto a un índice normal estriba en que en las hojas están las tuplas,
no los RID que apuntan a las tuplas. Para crear estas tablas se usa la cláusula ORGANIZATION
INDEX en la sentencia CREATE TABLE, normalmente utilizan los campos de la clave primaria
para ordenar la tabla. Una recuperación total devuelve los resultados ordenados por la clave. El
siguiente ejemplo ilustra su uso:

1. Crear la tabla:
`CREATE TABLE Prueba_IOT (id NUMBER PRIMARY KEY) ORGANIZATION INDEX;`

2. Carga de 2000 tuplas con id entre 1 y 2000, ordenadas de forma aleatoria. Abrir y ejecutar
el script SQL: Carga_prueba_iot.sql.

3. Ejecutar la consulta: `SELECT id FROM Prueba_IOT`. Observar el orden en que se obtie-
nen las tuplas en relación al campo id.

4. Pinchar el botón “Explicación del Plan” (F10) para ver el plan seleccionado para ejecutar
esa consulta.

5. Borrar tabla: DROP TABLE Prueba_IOT;

### “Clusters”
Un “cluster” proporciona un método alternativo de almacenar información en las tablas. Un
“cluster” lo forman un conjunto de tablas que se almacenan en los mismos bloques de datos
porque comparten campos comunes (clave del “cluster”) y se accede frecuentemente a ellas de
forma conjunta.
Por ejemplo, las tablas proveedor y ventas comparten el campo codpro. Si se incluyen las
dos tablas en el mismo “cluster”, Oracle físicamente almacena todas las filas de cada codpro
de ambas tablas en los mismos bloques de datos. No se deben usar “clusters” con tablas a las que
se accede frecuentemente de forma individual. Supongamos que se accede de forma conjunta a la información de cada proveedor junto
con los datos de sus suministros. En ese caso se incluirían ambas tablas en un mismo “cluster”,
compartiendo el campo codpro.

Como los “clusters” almacenan registros relacionados en los mismos bloques de datos, los
beneficios obtenidos son:

+ Se reduce el acceso a disco y se mejora el rendimiento en reuniones de las tablas del
clúster

+ La clave del “cluster” (columnas comunes entre las tablas del “cluster”) almacena cada
valor una sola vez de modo independiente al número de registros de las tablas que
contengan dicho valor

Después de crear un “cluster” se pueden crear las tablas que pertenecen al “cluster”.

#### Selección de tablas y clave del “cluster”
El “cluster” se debe usar para almacenar tablas que son principalmente consultadas y escasa-
mente modificadas. Además, dichas consultas deben reunir las tablas del clúster.
Si no se cumplen estos requisitos, el “cluster” resultante tendrá un efecto negativo sobre
el rendimiento porque no aprovechamos las ventajas que nos ofrece y sin embargo estamos
pagando el costo de su mantenimiento.
Se debe elegir la clave del “cluster” con cuidado. Si se usan varios campos en consultas que
reunen las tablas, se debe usar una llave compuesta.
Una buena clave del “cluster” debe tener un número adecuado de valores distintos para que
la información asociada a cada valor de la clave ocupe aproximadamente un bloque de datos.
Si la cantidad de valores distintos de la llave del “cluster” es muy pequeña se desperdicia
espacio y la mejora en el rendimiento es muy baja. Por ello es conveniente evitar claves de
“cluster” demasiado específicas.
Cuando la cantidad de valores distintos es demasiado alta, la búsqueda del registro a partir de
la clave del “cluster” es lenta. Por tanto, se deben evitar claves de “cluster” demasiado generales.
El acceso a los elementos del “cluster” a través de la clave puede mejorarse mediante el uso
de índices B* o mediante “Hash”. En este último caso, podemos crear un “cluster” que sólo
tenga asociada una tabla, de esta forma implementaremos el método de acceso “Hash” sobre esa
tabla.
Veremos, en primer lugar como se crea un “cluster” accedido mediante índices basado en
árboles B*, después veremos como se crea un “cluster Hash” y una tabla accedida mediante
“Hash”.

#### Creación de un “cluster” indizado
Para la creación de un “cluster” indizado se emplea la sentencia CREATE CLUSTER cuya
sintaxis básica es:
`CREATE CLUSTER nombre_del_cluster(campo tipo_de_dato);`

**Ejemplo 5.3 Para crear el “cluster” mostrado en la figura 5.1, que está sobre ventas y proveedor, usamos la siguiente sentencia:**
`CREATE CLUSTER cluster_codpro(codpro char(3));`

#### Creación de las tablas del “cluster” indizado
Una vez que se ha creado un “cluster” se pueden crear las tablas que contendrá. Para ello se
emplea la sentencia CREATE TABLE usando la opción CLUSTER en la que se indica el nombre
del “cluster” al que pertenecerá la tabla y, entre paréntesis, el nombre del campo o campos que
son la clave del “cluster”.
~~~sql
CREATE TABLE proveedor2(
codpro char(3) primary key,
nompro varchar2(30) not null,
status number(2) check(status>=1 and status<=10),
ciudad varchar2(15))
CLUSTER cluster_codpro(codpro);

CREATE TABLE ventas2(
codpro char(3) references proveedor2(codpro),
codpie references pieza(codpie),
codpj references proyecto(codpj),
cantidad number(4),
fecha date,
primary key (codpro,codpie,codpj))
CLUSTER cluster_codpro(codpro);
~~~

#### Creación del índice del “cluster”
Antes de que se pueda insertar información en las tablas del “cluster” es necesario que se
haya creado un índice. Esto se logra mediante la sentencia CREATE INDEX.

**Ejemplo 5.4 Para crear el índice del “cluster” de la figura 5.1 usaremos:**
`CREATE INDEX indice_cluster ON CLUSTER cluster_codpro;`

**Ejercicio 5.1 Rellena las tablas proveedor2 y ventas2 con los datos de sus homólogas
originales.**

**Ejercicio 5.2 Realiza alguna consulta a los datos contenidos en el “cluster” cluster_codpro.**

**Ejercicio 5.3 Consulta en el catálogo los objetos recién creados**

#### Creación de un “cluster hash”
Para la creación de un “cluster hash” se emplea la misma sentencia CREATE CLUSTER con
las cláusulas HASH IS, SIZE y HASKEYS.
~~~sql
CREATE CLUSTER nombre_del_cluster(campo tipo_de_dato)
[HASH IS campo] SIZE <tamaño>
HASKEYS <cant_valores_clave>;
~~~

La cláusula HASH IS se puede usar solamente si la clave del “cluster” está compuesta por
un único atributo de tipo NUMBER y contiene enteros uniformemente distribuidos. Si no se dan
esas condiciones, se omite esa cláusula y Oracle usará la función “hash” que tiene implementada
por defecto.
Mediante la cláusla SIZE debemos establecer cuanto espacio van a ocupar todas las tuplas
del “cluster” que tengan un mismo valor para la clave del “cluster”. Este valor debe estimarse a
partir del tamaño estimado de cada tupla y de la cantidad máxima de ellas que van a tomar un
mismo valor de la clave. Un valor escaso en esta estimación favorecerá la aparición de colisiones
(que haya mas tuplas para un valor de la clave del espacio habilitado para las mismas y deban
ubicarse en otro bloque distinto), lo que deteriorará el rendimiento. Si primamos el rendimiento
frente al uso óptimo del espacio de almacenamiento, debemos añadir un 15 % al valor estimado
de SIZE.
Mediante el parámetro HASHKEYS establecemos cuantos valores distintos va a tomar la
clave del “cluster”, Oracle calcula el número primo inmediatamente superior al valor que le
indicamos y ese el que usa para determinar en su función “hash” los valores distintos que va a
tomar la clave.

**Ejemplo 5.5 Crear el “cluster” mostrado en la figura 5.1, suponiendo que vamos a tener unos
50 proveedores y una media de 30 ventas por proveedor.**

En este ejemplo, nuevamente la clave del “cluster” sería codpro y, puesto que va a tener unos
50 valores distintos, HASHKEYS sería 50. El valor de SIZE lo estimaríamos, en función del
tamaño de las tuplas de la tabla proveedor y de la tabla ventas de la figura 5.1 y de la cantidad
media de ventas por valor de la clave (30), de esta manera 1 :
Tamaño de tupla de proveedor: codpro=3 bytes, nompro=30 bytes, status=2 bytes y
ciudad=15 bytes. Total=50 bytes.
Tamaño de tupla de ventas; codpie=3 bytes, codpj=3 bytes, cantidad=3 bytes y fecha=7
bytes. Total=16 bytes.
Como por cada proveedor (tamaño 50 bytes) tendremos una media de 30 ventas (tamaño 16
bytes por tupla). Entonces el valor de SIZE sería: 50+30*16=530 bytes a lo que añadimos
un 15 %, quedando: SIZE 610
Por lo que la sentencia de creación del “cluster” quedaría así:
CREATE CLUSTER cluster_codpro_hash(codpro char(3)) SIZE 610 HASHKEYS 50;
Después añadiríamos las tablas del “cluster” de la misma manera que hacíamos con el
“cluster” indizado.

#### Creación de un “cluster hash” de una sóla tabla
Si queremos utilizar acceso mediante “hash” para una tabla, en primer lugar hemos de crear
un “cluster hash” de la misma manera que hemos visto en el apartado anterior, sólo que hemos
de utilizar la cláusula SINGLE TABLE y, después la crear la tabla asociándola al “cluster”.
**Ejemplo 5.6 Crear la estructura necesaria para que la tabla proveedor sea accedida mediante
“hashing” a través del campo codpro, suponiendo que va a haber un máximo de 100 proveedores.**

Como hemos calculado, el tamaño de las tuplas de proveedor es de 50 bytes, por lo que
SIZE tomará ese valor (no es necesario incrementar ese tamaño, como en el ejemplo anterior) y
HASKEYS tomará el valor 100. Por lo que la sentencia de creación del “cluster” sería:
>Podemos usar la función VSIZE para calcular los bytes usados por cada tipo de dato, p.e. si status es un number(2),
para calcular su tamaño usamos: SELECT VSIZE(99) FROM dual; que devuelve 2 bytes de almacenamiento

~~~sql
CREATE CLUSTER cluster_codpro_single_hash(codpro char(3))
SIZE 50 SINGLE TABLE HASHKEYS 100;
~~~
y la sentencia de creación de la tabla sería:
~~~sql
CREATE TABLE proveedor_hash(
codpro char(3) primary key,
nompro varchar2(30) not null,
status number(2) check(status>=1 and status<=10),
ciudad varchar2(15))
CLUSTER cluster_codpro_single_hash(codpro);
~~~

#### Eliminación de “clusters”
Un “cluster” puede ser eliminado si las tablas del “cluster” no son necesarias. Cuando se
borra el “cluster” también se borra el índice del “cluster”.
Para la eliminación de un “cluster” se emplea la sentencia DROP CLUSTER cuya sintaxis
es:
~~~sql
DROP CLUSTER nombre_del_cluster
[INCLUDING TABLES [CASCADE CONSTRAINTS]];
~~~
Si un “cluster” contiene tablas no podrá ser eliminado a menos que se eliminen antes las
tablas o que se incluya en la sentencia la opción INCLUDING TABLES.
El “cluster” no podrá ser borrado si las tablas contienen campos que son referenciados por
claves externas localizadas en tablas externas al “cluster”. Para que se pueda borrar el “cluster”
se deben eliminar las referencias externas mediante la opción CASCADE CONSTRAINTS.

#### Eliminación de tablas del “cluster”
Se pueden eliminar tablas individuales de un “cluster” usando la sentencia DROP TABLE.
La eliminación de una tabla del “cluster” no afecta al “cluster” ni a las otras tablas ni al
índice del “cluster”.

#### Eliminación del índice del “cluster”
El índice de un “cluster” puede ser eliminado en cualquier momento sin afectar al “cluster”
ni a las tablas del mismo. Sin embargo no será posible acceder a la información contenida en las
tablas hasta que se reconstruya el índice. Para la eliminación del índice se emplea la sentencia
DROP INDEX.










#
