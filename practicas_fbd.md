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
a continuación ejecutar el fichero. Mediante esta sentencia hemos creado una tabla vacía
llamada prueba2 con dos atributos, cad1 y num. Para comprobarlo, es necesario consultar el
catálogo de la base de datos o ejecutar un comando describe, como veremos a continuación.**

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
está formada por un solo atributo, las palabras reservadas `PRIMARY KEY`, `UNIQUE` y `REFERENCES`, respectivamente, se podrán incluir a continuación de la definición del atributo
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
sobre todos los atributos de las tablas relacionadas en al cláusula FROM. Para proyectar campos
individuales, se debe ejecutar la siguiente sentencia:
`SQL> SELECT campo1, campo2, .... FROM nombre-tabla;`
Para conocer qué tablas tenemos creadas hasta este momento, podemos consultar una vista
del catálogo del SGBD denominada user_tables, en la forma que sigue:
`SQL> SELECT table_name FROM user_tables;`































#
