Creo primero el directorio FBD en :u para que no se me borre al apagar el ordenador, y me meto dentro de él con `cd u:\FBD`.
Luego creo la tabla prueba1:
~~~sql
create table prueba1(cad char(3),
n int,
xfloat);
~~~
Para ver que se ha creado correctamente basta con poner `describe prueba1`. Para ver todas las tablas que hemos creado hemos de
escribir `select table_name from user_tables;`

Luego he creado otras tablas en archivos de extensión .sql, para ejecutarlos se hace `@nombre.sql`.
Para borrar una tabla: `drop prueba1`

Para modificar el esquema de la tabla plantilla añadiendo un nuevo atributo llamado fechabaja de tipo date (ejer 2.6): `alter
table plantilla add (fechabaja date);`

select == pi (proyecci�n). Si ponemos select distinct no pone las tablas duplicadas
from == x (poducto cartesiano)
where == sigma (selecci�n)
Ejemplo: select codpro from proveedor where ciudad= 'Londres' para ver los proveedores que son de Londres.

Para conjuntos: union (all si queremos que nos muestre los elementos que est�n m�s de una vez), minus, intersect, select.
Si no queremos proyectar ponemos asterisco: select *.

select * from ventas v, ventas v2 where v.codpro= 'si'

select * from proveedor order by ciudad desc para dar un criterio de ordenaci�n a las tuplas, si las queremos en orden por ciudad descendente.

select * from proveedor order by ciudad, status; ordena por ciudad, si hay igualdad mira status. Por defecto ordena
ascendentemente.

Tipo de dato fecha: to_date(cadena, formato) por ejemplo cadena= '22/07/2018', formato? 'dd/mm/yyyy', pasa la fecha a un
formato que �l entiende. to_char(fecha, formato) hace lo contrario.
select sysdate from dual nos la fecha del d�a en el formato por defecto del sistema. select to_char(sysdate, 'yyyy') from dual
te dice el a�o en el que estamos.

Es muy habitual que cometamos el error de comparar en el dominio de las cadenas, y eso a veces puede no funcionar. Si vamos
a comparar fechas, lo hacemos en el dominio de las fechas.

select sysdate-to_date('23/06/1998' 'DD/MM/YYYY') from dual; dice los d�as que hace desde que nac�.

select (sysdate-to_date('23/06/1998', 'dd/mm/yyyy'))/365 from dual; dice los a�os que tengo.

sql convierte la aritm�tica de fechas en aritm�tica real.

select sysdate from ventas por cada tupla de ventas me saca lo que he puesto en el select, me repite la fecha del sistema tantas
veces como tuplas haya.

select cantidad*3-5 from ventas multiplica cantidad de la tabla ventas por 3, le resta 5.

select nompro, codpie, cantidad from ventas.proveedor where ventas.codpro=proveedor.codpro

--------------------------------------------------------------------------------
Utilizando la sentencia ALTER TABLE, descrita anteriormente, vamos a modificar el esque-
ma de la tabla Ventas a�adiendo un nuevo atributo llamado
fecha
de tipo
date
.
Ejercicio 2.7
Comprobar que se ha cambiado correctamente el esquema de la tabla Ventas: para a�adir la nueva fila escribimos
alter table ventas add(fecha date); y para ver si se ha hecho correctamente simplemente escribimos describe ventas.

el * equivale a proyectar sobre todos los atributos de las tablas relacionadas en al cl�usula FROM.

Ejercicio 2.8
Ejecuta la sentencia SELECT para mostrar el contenido de las tablas PRUEBA2
y PLANTILLA. Intenta mostrar s�lo algunos campos de las mismas: select * from prueba2 para mostrar la tabla entera,
select cad1 from prueba2; muestra solo eso.

select * from plantilla;
select fechaalta from plantilla;

Para modificar los datos de una tabla introducidos con anterioridad, hemos de utilizar la
sentencia UPDATE, cuya forma general es la siguiente:
UPDATE nombre_tabla
SET nombre_atributo = �nuevovalor�
[, nombre_atributo2 = �nuevovalor2�...]
[WHERE  <condicion> ];

Ejemplo 2.4
Ejecuta la sentencia UPDATE sobre la tabla
plantilla
y cambia el estado civil de
Juan a
divorciado

SQL> update plantilla
set estadocivil = �divorciado�
where nombre=�Juan';

Ejercicio 2.9
Ejecuta la sentencia UPDATE sobre la tabla
plantilla
y cambia el nombre del
trabajador con dni �12345678� a �Luis�.

update plantilla set nombre= 'Luis' where dni= '12345678';

La instrucci�n DELETE se utiliza para eliminar tuplas de una tabla. Las tuplas que se
eliminan son aquellas que hacen cierta la expresi�n <condicion>. Su sintaxis es la siguiente:
DELETE [FROM] nombre_tabla [WHERE <condicion>];

Ejemplo 2.5
Borra todas las tuplas de la tabla prueba2.
SQL> DELETE FROM prueba2

Ejercicio 2.10
Borra todas las tuplas de la tabla
plantilla
.
SQL> DELETE FROM plantilla;
En este caso da un mensaje de error (�por qu�?). Aunque s� podr�amos borrar las tuplas
de la tabla
serjefe
.
SQL> DELETE FROM serjefe;

No podemos borrar todas las tuplas de la tabla plantilla ya que la tabla serjefe la referencia.

Ejemplo 2.6
Ejecuta la sentencia UPDATE sobre la tabla
plantilla
y cambia la fecha de alta
de Juan al d�a siguiente.
SQL> UPDATE plantilla
SET fechaalta = fechaalta+1
WHERE nombre=�Juan�;

Introducci�n de fechas mediante la funci�n TO_DATE
Con esta funci�n se genera un valor de tipo
date
a partir del valor suministrado por la
primera cadena pasada a la funci�n usando como formato la segunda cadena proporcionada.
Un ejemplo de uso de la funci�n
TO_DATE
es el siguiente:
SQL> insert into plantilla
values (�11223355�,�Miguel�,�casado�,
TO_DATE(�22/10/2005�,�dd/mm/yyyy�),null);

Mostrar fechas mediante la funci�n TO_CHAR
Para la recuperaci�n de datos de tipo fecha en
un formato concreto
3
, la funci�n que debe
utilizarse es
TO_CHAR
, que transforma un valor de fecha (en su formato interno) a una cadena
de caracteres imprimible seg�n el formato fecha especificado.

Ejemplo 2.7
SQL> select TO_CHAR(fechaalta,�dd-mon-yyyy�) from plantilla;

Para introducir todas las tuplas de una tabla que ya existe y
est� creada otra nuestra, ambas con el mismo esquema:
SQL> insert into ventas select * from opc.ventas;

Ejercicio 2.11
A continuaci�n vamos a tratar de insertar algunas tuplas nuevas en
ventas
.
Comprueba que se introducen correctamente y, en caso contrario, razona por qu� da error.
insert into ventas values (�S3�, �P1�, �J1�, 150, �24/12/05�);
Da error de que la clave primaria �nica no se cumple
insert into ventas (codpro, codpj) values (�S4�, �J2�);
insert into ventas values(�S5�,�P3�,�J6�,400,TO_DATE(�25/12/00�));

---- SUBCONSULTAS-------

calcular la venta que tiene la cantidad m�s peque�a: se puede plantear haciendo una consulta,
nos vamos a la tabla de ventas, miramos las cantidades y disponiendo de ese conjunto de valores
podr�amos intentar tener un comparador que mi cantidad sea menor o igual que esas que aparecen.

Eso se puede plantear directamente en sql: select * from ventas where cantidad <= (select cantidad from ventas);
la subconsulta es la consulta uqe est� entre par�ntesis. Da error por usar un operador que �l supone es de comparaci�n
para un solo elemento. Ponemos entonces select * from ventas where cantidad <= ALL (select cantidad from ventas);

As� se hace el operador verdadero, con ALL resuelve la consulta interior una vez, sustituye y hace la exterior.

Proveedores que son de la misma ciudad que s1: select * from proveedor where ciudad=(select ciudad from proveedor where codpro= 'S1');

no hace falta any porque cuando la subconsulta devuelve un solo valor los operadores relacionales no dan error, any o all se ponen si se
pueden devolver m�s cosas, al haber hecho en este caso una consulta por clave primaria no pasa nada.

Podr�amos haber hecho: select * from pieza where color=(select color from pieza where codpie=''P3');
devuelve P3 y P5, podemos hacer pues la comparaci�n simple porque me devuelve una tupla. Cuando devolvemos un conjunto de valores se
puede usar el operador de conjunto in, que es lo mismo que =ANY. Se pueden anidar consultas. Se puede relacionar la subconsulta con la consulta
principal, los datos que se usan fuera se pueden usar para plantear restricciones.
Operador exist se puede usar negado o normal, espera una subconsulta y devuelve verdadero si la
subconsulta devuelve tuplas, false si es vac�a: select nompro from proveedor where exists(select * from ventas where ventas.codpro=proveedor.codpro);
nombre de los proveedores que tienen alguna venta. Es pues una subconsulta que enlaza con la consulta de fuera.
Hay que tener cuidado con la eficiencia. Proveedores que no han vendido la pieza a p3:
select nompro from proveedor where codpro not in (select codpro from ventas where codpie='P3');
Con �lgebra se har�a producto cartesiano y resta. En los ejemplos vistos no se devuelven parejas, tripletas,... Tambi�n se puede hacer.
Los modificadores all y any son para cuando la sem�ntica de la subconsulta hace que pueda devolver m�s de un valor.
Tambi�n se pueden poner subconsultas en el from:
select * from (select * from proveedor where ciudad= 'Madrid') prov, pieza;
Coge el proveedor que hay de madrir y combina con la pieza p1, p2,... Solo el de Madrid. Primero resuelve la tabla virtual
que crea llamada prod y la combina con las piezas. Para evitar ambiguedad usar alias.
-----------------------------

Ejercicio 2.12: Ejercicio 2.12
Actualizar la fecha del proveedor S5 al a�o 2005�
SQL> UPDATE ventas
SET fecha = TO_DATE(2005,�YYYY�)
WHERE codpro=�S5�;

Ejercicio 2.13
Para mostrar la columna FECHA con un formato espec�fico e imprimirla,
utilizar la siguiente sentencia:
SQL> select codpro,codpie,
to_char(fecha,�"Dia" day,dd/mm/yy�) from ventas;
donde el texto que se quiere incluir como parte de la fecha debe ir entre comillas dobles.

Antes de salir...
Por �ltimo, antes de terminar la sesi�n, se pide dejar �nicamente las tablas necesarias y las
tuplas definitivas para las pr�ximas sesiones. Para ello:
1.  Comprobar las tablas de usuario: select table_name from user_tables;
2.  Borrar el resto de tablas excepto las tablas
proveedor, pieza, proyecto y ventas: drop table prueba2;
drop table prueba3;
drop table serjefe;
drop table plantilla;
3.
Si has ejecutado alguno de los ejercicios 2.11 o 2.12 ejecuta el comando ROLLBACK
que restituye la base de datos al estado anterior. Esto es, deshace los �ltimos cambios
realizados desde el �ltimo commit.
4.  Ejecutar COMMIT antes de abandonar la sesi�n.

Como ejercicios adicionales se deja al alumno trasladar al sistema el esquema de la base de
datos de la Gesti�n docente universitaria utilizada en clase de teor�a. Finalmente, rellenar todas
las tablas de la base de datos con algunas tuplas.

** Hacer ejers adicionales de las p�ginas 26 y 27**

3------ Consultas

La sentencia
SELECT
permite consultar las tablas seleccionando datos en tuplas y columnas
de una o varias tablas. La sintaxis general de la sentencia con sus m�ltiples cl�usulas se detalla a
continuaci�n:
SELECT [ DISTINCT | ALL]
expresion [alias_columna_expresion]
{,expresion [alias_columna_expresion]}
FROM [esquema.]tabla|vista [alias_tabla_vista]
[WHERE <condicion>]
[GROUP BY expresion {,expresion}]
[{UNION | UNION ALL | INTERSECT | MINUS}  <SELECT instruccion>]
[HAVING <condicion>]
[ORDER BY {expresion} [ASC | DESC]]

La proyecci�n del �lgebra Relacional se expresa en la sentencia SELECT mediante la lista
de campos, denominados �select list� que se relacionan entre la cl�usula SELECT y la cl�usula
FROM. Se utiliza el
*
para determinar que se proyecte sobre todos los campos de las tablas
listadas en la cl�usula FROM.

Ejemplo 3.1
Muestra las ciudades donde hay un proyecto.

AR:
pciudad(Proyecto)

SQL> Select ciudad from proyecto;

Ejercicio 3.1
Comprueba el resultado de la proyecci�n. �Es �ste conforme a lo que se obtiene
en el AR? S�, al ejecutarlo resulta: ciudad--- londres, londres, paris, roma. Vemos entonces que salen repeticiones,
algo que no ocurr�a con el �lgebra relacional, para solucionarlo: select distinct ciudad from proyecto;

Ejemplo 3.2
Muestra la informaci�n disponible acerca de los proveedores.

SQL> Select * from proveedor;
* muestra el esquema completo, o bien proyectando
uno a uno los atributos
SQL> Select codpro, nompro, status, ciudad from proveedor;

Sale lo mismo.

Ejercicio 3.2
Muestra los suministros realizados (tan solo los c�digos de los componentes de una venta). �Es necesario utilizar DISTINCT?
select codpro, codpie, codpj from ventas;

Para realizar la selecci�n Algebr�ica
s
en SQL se emplea la cl�usula
WHERE
seguida de
<condicion>
, aunque siempre ser� necesario especificar la cl�usula
SELECT
de la instrucci�n
de consulta.
<condicion>
es una expresi�n booleana que implica cualquiera de los atributos de
la tabla que figura en la cl�usula
FROM
de la instrucci�n.

Ejemplo 3.3
Muestra los c�digos de los proveedores que suministran al proyecto �J1�.

AR :pcod pro(scod pj='J1'(ventas))
SQL> Select codpro from ventas where codpj=�J1�;

Ejercicio 3.3
Muestra las piezas de Madrid que son grises o rojas.

select codpie from pieza where (ciudad= 'Madrid') and (color= 'Gris' or color= 'Rojo');

Devuelve P1, como deber�a ser.

Ejercicio 3.4
Encontrar todos los suministros cuya cantidad est� entre 200 y 300, ambos
inclusive: select codpie from ventas where cantidad <= 300 and cantidad >= 200;

Construcci�n de expresiones l�gicas: operadores adicionales
El operador
like
y los caracteres comod�n _ y %
El operador
like
se emplea para
comparar cadenas de caracteres mediante el uso de patrones. Cuando se emplea el car�cter
comod�n %, �ste se sustituye por cualquier cadena de 0 � m�s caracteres:

Ejemplo 3.4
Mostrar los proveedores cuyo nombre de ciudad empieza por �L�.

SQL> Select codpro, nompro from proveedor where ciudad LIKE �L%�;
El car�cter comod�n _ sustituye un s�lo car�cter.

Explicaci�n profesor
---- DIVISION CON SQL--------
proveedores que hayn suministrado todas las piezas: encontramos aquellos proveeedores para los que no existe una pieza 	que no hayan vendido
encontrar proveedorees para los que no exista una venta de ese proveedor y esa pieza:
select * from proveedor where not exists(select * from pieza where not exists (select * from ventas where ventas.codpro= proveedor.codpro and ventas.codpie= pieza.codpie));
asi nos fijamos en los proveedores, para ese miramos las piezas para los que no existe una ventas de ese proveedor y esa pieza, si no hay ninguna esa venta la sacamos.

proveedores de londres que han suministrado todas las piezas: como afecta al candidato tenemos que poner fuera el que sea de londres, lo dem�s igual. condiciones que afecten a la relaci�n candidato-cada elemento del divisor lo
ponemos en la ultima parte.

todas las piezas rojas que solo hay una:
select * from proveedor where not exists (select * from pieza where color= 'Rojo' and not exists( select * from ventas where  ventas.codpro= proveedor.codpro and ventas.codpie= pieza.codpie));


select codpro from ventas where codpie= 'P2'; todos los que han tenido una venta de p2.

encontrar los proveedores para los que no existe una pieza para los que no exista una venta de ese proveedor y esa pieza era lo que hemos hecho arriba.

proveedor que haya suministrado todas las piezas= proveedor para el que no encontramos una pieza que no haya vendido �l.

otra estrategia: repasamos los proveedores pero ahora construimos una consulta en la que sacamos una lista de todas las piezas y quitamos el conjunto de las piezas que ha vendido ese proveedor, si es vac�o es lo que busc�bamos:
select * from proveedor where not exists(select codpie from pieza minus select codpie from ventas where ventas.codpro= proveedor.codpro);

para cada proveedor sacamos la lista de piezas y quitamos las que ha vendido, si sale vac�o es poruqe las ha vendido todas.
---------------------------------

Ejercicio  3.5
Mostrar  las  piezas  que  contengan  la  palabra
tornillo
con  la  t  en
may�scula o en min�scula: select nompie, codpie from pieza where nompie like '_ornillo';

Uso de operadores aritm�ticos.

Ejemplo 3.5
Describe la cantidad de cada venta expresada en docenas, s�lo de las
ventas cuyo n�mero de piezas es mayor de diez docenas.

SQL> Select cantidad/12 from ventas where (cantidad/12)>10;
Comparaci�n con el valor nulo.
El operador
IS [NOT] NULL

Ejemplo 3.6
Encontrar los proveedores que tienen su status registrado en la base de
datos.

SQL> Select codpro, nompro from proveedor where status IS NOT NULL;

Ejemplo 3.7
Mostrar la informaci�n de todas las tablas denominadas
ventas
a las que tienes
acceso: SQL> Select table_name
from ALL_TABLES
where TABLE_NAME like �%ventas�;

Ejercicio 3.6
Comprueba que no devuelve ninguna. Pero SI que hay!!! No devuelve ninguna dado que en el cat�logo en el que se guardan todas las tablas
que declaramos est�n almacenadas en may�sculas, y las b�squedas son case sensitive. Escribiendo pues select table_name from all_tables where table_name like '%VENTAS';

Operadores AR sobre conjuntos en SQL
<SELECT instruccion>
UNION | UNION ALL | INTERSECT | MINUS
<SELECT instruccion>

Estos operadores tienen una restricci�n similar a sus correspondientes del AR, para poder
llevarse a cabo: los esquemas de las tablas resultantes de cada sentencia
SELECT
han de ser
iguales en tipo, esto es, los atributos no tienen porqu� llamarse igual, aunque s� han de coincidir
en n�mero, posici�n en el �select list� y tipo. Tr�s la operaci�n, el esquema del resultado coincide
con el esquema del primer operando.

Ejemplo 3.8
Ciudades donde viven proveedores con status mayor de 2 en las que no se fabrica
la pieza �P1�.

AR :pciudad(sstatus>2(proveedor))-pciudad(scod pie='P1'(pieza))

SQL> (select distinct ciudad from proveedor where status>2)
MINUS
(select distinct ciudad from pieza where codpie=�P1�);

N�tese que los operadores
UNION, MINUS e INTERSECT
implementan en SQL las operaciones uni�n, resta e intersecci�n del AR, respectivamente y que, por tanto, consideran los argumentos como
relaciones (sin tuplas repetidas) y devuelven el resultado como una relaci�n (sin tuplas repetidas).
Por consiguiente, la sentencia SQL que resuelve el ejercicio anterior podr�a prescindir de las
cl�usulas
distinct
. Sin embargo el operador
UNION ALL
devuelve todas las tuplas incluidas en
las tablas argumento, sin eliminar tuplas duplicadas.

Ejercicio 3.7
Resolver la consulta del ejemplo 3.8 utilizando el operador n.

(select distinct ciudad from proveedor where status > 2) intersect (select distinct ciudad from pieza where codpie != 'P1');

Sale lo mismo!

Ejercicio 3.8
Encontrar los c�digos de aquellos proyectos a los que s�lo abastece �S1�.

select codpj from proyecto where not exists (select codpro from proveedor where codpro != 'S1');

Ejercicio 3.9
Mostrar todas las ciudades de la base de datos. Utilizar
UNION

select ciudad from pieza union select ciudad from proveedor union select ciudad from proyecto;

Ejercicio 3.10 Mostrar todas las ciudades de la base de datos. Utilizar UNION ALL

Igual que el anterior pero poniendo union all, la diferencia con union es que no elimina duplicados.

-------------- FUNCIONES DE AGREGACI�N-------
Permite calcular determinados estadisticos sobre conjuntos de tuplas:
select min(cantidad) from ventas; dice la m�nima cantidad que hay en ventas

hay sumatorio, m�nimo, maximo, media,... select avg(cantidad) from ventas; dice la media de la cantidad. Se puede poner
el nombre de la columna o distinct en los operadores que tenga sentido, para que no aparezcan duplicados.

selec avg(distinct cantidad) from ventas; no considera duplicados, y sale un valor distinto.
El conteo se puede hacer sobre tuplas: select count(*) from ventas;
o sobre una columna, que cuenta valores distintos de nulos: select count(fecha) from ventas;
y si ponemos distinct cuentas las que hay distintas (select count(distinct(fecha) from ventas;
en el momento en el que uso una funcion de agregacion las tuplas pierden su identidad:

no podemos hacer select codpro, min(cantidad) from ventas; no nos dice el codigo del proveedor asociado a la minima venta,
nos da error de que se ha perdido la identidad. Si queremos hacerlo debemos tirar de subconsulta:

select codpro from ventas where cantidad=(select min(cantidad) from ventas);

podemos pedir que agrupe las tuplas en base a el codigo de proveedor y por cada grupo de tuplas decir cua es el minimo:
select min(cantidad) from ventas group by codpro;

en el momento en que usamos group  by todo lo que sea comun a un grupo de tuplas se puede usar en el select, ya no da error:
select codpro, min(cantidad) from ventas group by codpro;

en el select se pueden poner funciones de agregacion y atributos que hayamos puesto en el group by.

select codpro, codpie, min(cantidad) from ventas group by codpie, codpro; calcula para cada pareja codpro codpie la cantidad
minima de ventas que hay. Si pusieramos where hay que ponerlo antes de hacer los grupos, estos ultimos se hacen sobre la
consulta tradicional que hayamos hecho:

select codpro, codpie, min(cantidad) from ventas where codpro in ('S1','S2') group by codpro, codpie;

podemos establecer restricciones tambien sobre los grupos, con la clausula having. La consulta anterior podriamos
haberla formulado: select codpro, codpie, min(cantidad) from ventas group by codpro, codpie having codpro in ('S1','S2');
y sale exactamente lo mismo, mejor hacer todo lo posible en el where porque asi reducimos lo que llega al group, filtramos
antes de hacer los grupos. Podemos anidar las funciones de agregacion:

select min(avg(cantidad)) from ventas group by codpro;

coge las ventas ordenadas por codpro y se queda con el minimo de la media de las cantidades, pero da error ya que nos hemos
cargado otra vez la identidad. Lo solucionamos haciendolo por subconsultas:

select codpro, avg(cantidad) from ventas group by codpro having avg(cantidad)<= all(select avg(cantidad) from ventas group by codpro);
mostramos parejas codpro, avg que cumplan que ese avg es menor igual que todas las dem�s.

select _ from _ where _ group by _ having _ order by _

es el orden en el que hay que ponerlas.

select codpro, min(cantidad) no va porque estamos con una propiedad que es de tupla y otra que es de conjunto, no se pueden emparejar.

Con min sql como que crea una entidad de la cual solo se saben sus estadisticas, ya no se tiene informacion
sobre sus tuplas, sus propiedades.

-------------------------------------------------

El producto cartesiano AR en SQL
En la cl�usula FROM de una sentencia de consulta puede aparecer una lista de tablas en lugar
de una sola. En este caso, el sistema realiza el producto cartesiano de todas las tablas incluidas
en dicha lista para, posteriormente, seleccionar aquellas tuplas que hacen verdad la condici�n de
la cl�usula WHERE (en el caso de que se haya establecido) mostr�ndolas como resultado de ese
producto cartesiano.

Ejercicio 3.11 Comprueba cu�ntas tuplas resultan del producto cartesiano aplicado a ventas
y proveedor: select * from ventas, proveedor;

Resultado: 115 filas seleccionadas.

Ejemplo 3.9 Muestra las posibles ternas (codpro,codpie,codpj) tal que, todos los implicados
sean de la misma ciudad.

Select codpro, codpie, codpj
from proveedor, proyecto, pieza
where Proveedor.ciudad=Proyecto.ciudad
and Proyecto.ciudad=Pieza.ciudad;

Ejemplo 3.10 Mostrar las ternas (codpro,codpie,codpj) tal que todos los implicados son de
Londres.

Select codpro,codpie,codpj
from proveedor, proyecto, pieza
where Proveedor.ciudad=�Londres� and Proyecto.ciudad=�Londres�
and Pieza.ciudad=�Londres�;

Ejercicio 3.12 Mostrar las ternas que son de la misma ciudad pero que hayan realizado
alguna venta.( que entre ellos haya alguna venta):

select Proveedor.codpro, Pieza.codpie, Proyecto.codpj
from proveedor, proyecto, pieza, ventas
where Proveedor.ciudad= Proyecto.ciudad
and Proyecto.ciudad= Pieza.ciudad
and Ventas.codpro= Proveedor.codpro
and Ventas.codpie= Pieza.codpie
and Ventas.codpj= Proyecto.codpj;

Ejercicio 3.13 Encontrar parejas de proveedores que no viven en la misma ciudad.
select p1.nompro, p2.nompro from proveedor p1, proveedor p2 where p1.ciudad != p2.ciudad;

Ejercicio 3.14 Encuentra las piezas con m�ximo peso.
select * from pieza where peso >= ALL (select peso from pieza);

-------La equi-reuni�n y la reuni�n natural AR en SQL
Llegado este punto, disponemos de todos los elementos SQL para expresar el operador
equi-reuni�n y la reuni�n natural. Para la reuni�n natural se usa la cl�usula NATURAL JOIN
dentro de la cl�usula FROM entre las tablas o subconsultas participantes. EL SGBD aplica la
reuni�n natural sobre aquellos campos que se llamen de igual forma en las tablas o subconsultas
intervinientes, si no coincidieran en tipo, devolver�a error.

Ejemplo 3.12 Mostrar los nombres de proveedores y cantidad de aquellos que han realizado
alguna venta en cantidad superior a 800 unidades.

Select nompro, cantidad
from proveedor s, (select * from ventas where cantidad>800) v
where s.codpro= v.codpro;

Devuelve Manuel Vidal--4500, Pedro S�nchez--1500, Pedro S�nchez 1700

Observe el resultado que se obtiene de la reuni�n natural cuando se proyecta sobre todos
los atributos. Si se quiere reunir en base a campos que no tienen el mismo nombre, se pueden
usar dos alternativas: producto cartesiano junto a condici�n de reuni�n en la cl�usula WHERE
o la equi-reuni�n expresada mediante cl�usula JOIN ... ON en la forma que se indica a
continuaci�n:
SQL> Select nompro, cantidad
from proveedor s JOIN (select * from ventas where cantidad>800) v
ON (s.codpro=v.codpro);

Devuelve lo mismo.

Ejercicio 3.15 Mostrar las piezas vendidas por los proveedores de Madrid.

select v.codpie
from ventas v, proveedor p
where v.codpro= p.codpro and p.ciudad= 'Madrid';

select v.codpie
from ventas v
join (select * from proveedor
where ciudad= 'Madrid') pr
on v.codpro= pr.codpro;

Ejercicio 3.16 Encuentra la ciudad y los c�digos de las piezas suministradas a cualquier
proyecto por un proveedor que est� en la misma ciudad donde est� el proyecto.

select pi.ciudad, pi.codpie
from pieza pi, ventas v, proveedor pr, proyecto pj
where v.codpie= pi.codpie and v.codpro= pr.codpro and v.codpj= pj.codpj and pj.ciudad= pr.ciudad;

select pi.ciudad, pi.codpie
from pieza pi join(select codpie from ventas v, proveedor pr, proyecto pj
where v.codpro= pr.codpro and v.codpj= pj.codpj and pj.ciudad= pr.ciudad) c
on pi.codpie= c.codpie;

Ordenaci�n de resultados
Ya sabemos que en el modelo relacional no existe orden entre las tuplas ni entre los atributos,
aunque s� es posible indicar al SGBD que ordene los resultados seg�n alg�n criterio, mediante la
cl�usula ORDER BY. Caso de emplearse �sta, el orden por defecto es creciente (ASC).
SELECT [DISTINCT | ALL] expresion [alias_columna_expresion]
{,expresion [alias_columna_expresion]}
FROM [esquema.]tabla|vista [alias_tabla_vista]
[WHERE <condicion>]
ORDER BY expresion [ASC | DESC]{,expresion [ASC | DESC]}
 Ejemplo 3.13 Encontrar los nombres de proveedores ordenados alfab�ticamente. 
SQL> Select nompro
from proveedor
order by nompro;

�ndices-------------------------------------------------------------
create index... libros(genero, titulo,editorial) acelerar� consultas sobre genero, genero y titulo
y genero, titulo y editorial, pero no sobre solo editorial.

�ndice bitmap-> para acelerar las consultas de tipo or.
cluster->agrupamiento intraarchivo, para que de alguna manera se tenga precalculada la reunion,
cuando nos traemos bloques de disco tenemos la reuni�n hecha, al tener al lado del bloque del
proveedor su c�digo. Esto tiene sentido si hay un n�mero razonable de c�digos de proveedor,
de n�meros de proveedor,... El cl�ster va antes de crear las tablas, y las tablas las
asociamos a ese cl�ster. Primero creamos el cl�ster y le decimos sobre que campo queremos organizarlo,
para que sepa el sistema saber sobre qu� campo pivotar. Al final, al poner clus cluster_codpro(codpro)
le decimos qeu esa tabla no va suelta, sino que est� asociada al cl�ster.

En los cl�ster hash, el size es una estimaci�n del bloque, cuanto ocupar� por ejemplo la fila
codpro,... de la tabla en bytes, haskeys estimaci�n de la cantidad de valores numero
aproximado de valores distintos de clave.
------------------------------------------------------------------------------------------------

Ejercicio 3.17 Comprobar la salida de la consulta anterior sin la cl�usula ORDER BY.

select nompro from proveedor;

No lo devuelve alfab�ticamente.

Ejercicio 3.18 Listar las ventas ordenadas por cantidad, si algunas ventas coinciden en la
cantidad se ordenan en funci�n de la fecha de manera descendente.

select cantidad from ventas order by fecha DESC;


------Subconsultas en SQL
Existen en SQL distintos operadores que permiten operar sobre el resultado de una consulta,
esto se hace incorporando una subconsulta en la cl�usula WHERE de la consulta principal. La
raz�n de proceder de esta forma es que se fragmenta la consulta original en varias consultas m�s
sencillas, evitando en muchas ocasiones numerosas reuniones.
SELECT <expresion>
FROM tabla
WHERE <expresion> OPERADOR <SELECT instruccion>
D�nde OPERADOR es cualquiera de los que se presentan en esta secci�n y, la cl�usula
SELECT a la derecha de OPERADOR puede contener a su vez otra subconsulta, que puede, a su
vez, anidar un determinado numero de subconsultas. El m�ximo n�mero de anidamientos permitido
depende de cada sistema. Para su resoluci�n el sistema procede resolviendo la subconsulta
anidada a un mayor nivel de profundidad y sigue resolviendo todas las instrucciones SELECT en
orden inverso de anidamiento.

-----IN, el operador de pertenencia
Un uso muy frecuente del operador de pertenencia a un conjunto IN consiste en obtener
mediante una subconsulta los elementos de dicho conjunto.
 Ejemplo 3.14 Encontrar las piezas suministradas por proveedores de Londres. (Sin usar el
operador de reuni�n.)
SQL> Select codpie
from ventas
where codpro IN
(select codpro from proveedor where ciudad = �Londres�);

Ejercicio 3.19 Mostrar las piezas vendidas por los proveedores de Madrid. (Fragmentando
la consulta con ayuda del operador IN.) Compara la soluci�n con la del ejercicio


select codpie from ventas where codpro in (select codpro from proveedor where ciudad= 'Madrid';

Ejercicio 3.20 Encuentra los proyectos que est�n en una ciudad donde se fabrica alguna
pieza.

select codpj from proyecto where ciudad in (select ciudad from pieza);

Ejercicio 3.21 Encuentra los c�digos de aquellos proyectos que no utilizan ninguna pieza
roja que est� suministrada por un proveedor de Londres.

select distinct codpj from ventas where codpie  not in (select codpie from pieza where color = 'Rojo')
intersect select codpro from proveedor where ciudad = 'Londres');

----EXISTS, el operador de comprobaci�n de existencia
Este operador devuelve verdadero cuando existe alguna tupla en la relaci�n sobre la que se
aplica. El operador EXISTS puede interpretarse tambi�n como de comprobaci�n de conjunto no
vac�o.

Ejemplo 3.15 Encontrar los proveedores que suministran la pieza �P1�.
SQL> Select codpro
from proveedor
where EXISTS (select * from ventas
where ventas.codpro = proveedor.codpro
AND ventas.codpie=�P1�);

-----Otros operadores, los comparadores sobre conjuntos
Cualquiera de los operadores relacionales < j <= j > j >= j <> junto con alguno de los
cuantificadores [ANY|ALL] pueden servir para conectar una subconsulta con la consulta principal.
 Ejemplo 3.16 Muestra el c�digo de los proveedores cuyo estatus sea igual al del proveedor
�S3�.
SQL> Select codpro
from proveedor
where status = (select status from proveedor where codpro=�S3�);
Ejemplo 3.17 Muestra el c�digo de las piezas cuyo peso es mayor que el peso de alguna pieza
�tornillo�.
SQL> Select codpie
from pieza
where peso > ANY
(select peso from pieza where nompie like �Tornillo%�);

Ejercicio 3.22 Muestra el c�digo de las piezas cuyo peso es mayor que el peso de cualquier
�tornillo�.

SQL> select codpie from pieza where peso > ALL (select peso
from pieza where nompie like 'Tornillo%');
As�, si quisi�ramos por ejemplo saber el c�digo de las pieza cuyo peso es mayor que el peso
de cualquier otra pieza ser�a especificar:
SQL> select codpie from pieza where peso >= ALL (selec peso from pieza);

------ Divisi�n AR en SQL
Para mostrar el c�digo de los proveedores que suministran todas las piezas:

Una forma es seleccionar el c�digo de los proveedores y quitarles el c�digo de los proveedores tales que
el c�digo de los proveedores y c�digo de piezas de la tabla pieza a las que le he restado el c�digo de proveedor
y c�digo de pieza. As�, a todos los proveedores les estamos quitando los que no suministran ninguna pieza, con lo que
tenemos los proveedores que suministran todas las piezas. s

Aproximaci�n usando expresi�n equivalente en AR
Relacion1%Relacion2 = piA(Relacion1)-piA((piA(Relacion1)xRelacion2)-Relacion1)
siendo A = (AtributosRelacion1)- (AtributosRelacion2)
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
Aproximaci�n basada en el C�lculo Relacional
De forma intuitiva, la manera de proceder ser�a:
Seleccionar proveedores tal que (
no exista (una pieza (para la que no exista un suministro de ese proveedor))

SQL> Select codpro
from proveedor
where not exists (
(select * from pieza
where not exists (select * from ventas
where pieza.codpie= ventas.codpie
and proveedor.codpro=ventas.codpro)));

Aproximaci�n mixta usando not exists y la diferencia relacional
De forma intuitiva, la manera de proceder ser�a:
Seleccionar proveedores tal que
(el conjunto de todas las piezas)
menos
(el conjunto de la piezas suministradas por ese proveedor)
sea vac�o.
Es decir, no exista ninguna tupla en la diferencia de esos conjuntos.

SQL> Select codpro
from proveedor
where not exists (
(select distinct codpie from pieza)
minus
(select distinct codpie from ventas where proveedor.codpro=ventas.codpro)
);


Ejercicio 3.24 Encontrar los c�digos de las piezas suministradas
a todos los proyectos localizados en Londres.

Esto es equivalente a encontrar los c�digos de las piezas tales que no existe un proyecto de
Londres que no tenga esa pieza. Hacemos pues: proveedores tales que no existe ( proyecto para el cual no existe
un suministro de esa pieza a ese proyecto). Con esto obtendr�amos los c�digos de las piezas suministradas a todos los
proyectos:
select codpie from pieza where not exists (
select * from proyecto where not exists ( select * from ventas where ventas.codpj= proyecto.codpj and
ventas.codpie=pieza.codpie));

Para especificar que los proyectos han de ser de Londres:
select codpie from pieza where not exists (
select * from proyecto where not exists ( select * from ventas where ventas.codpj= proyecto.codpj and
ventas.codpie=pieza.codpie) and proyecto.ciudad = 'Londres');

Esto es entonces de la forma segunda (aproximaci�n basada en el c�lculo relacional). De la forma primera (usando expresi�n
equivalente en AR): picodpie,codpj(ventas)%picodpj(proyecto que es de londres). Empleando la f�rmulilla eso ser�a igual a:
picodpj(picodpie,codpj(ventas)) - picodpj((picodpj(picodpj,codpie(ventas) x picodpj(proyecto de londres) - picodpj, codpie(ventas)

select codpie from ventas
minus
(select codpie from (
(select p.codpj, v.codpie from
(select distinct codpie from ventas) v,
(select codpj from proyecto where ciudad='Londres') p)
minus
(select codpj, codpie from ventas)));

En lo primero que viene despu�s del primer minus creamos parejas proyecto de londres pieza y a eso le quito lo que tengo, todas las dem�s, para crear
el dividendo perfecto, con eso me salen las piezas no suministradas a los proyectos de londres. De esta manera, al quitarle a todas las piezas las
que no son suministradas a todos los proyectos localizados en londres CONTINUAR

Por �ltimo, para hacerlo mediante la aproximaci�n mixta usando
not exists y la diferencia relacional:

tenemos que seleccionar piezas tales que
(el conjunto de todos los proyectos de londres)
menos
(el conjunto de los proyectos de londres a los que se ha suministrado esas
piezas) es vac�o.

select codpie from pieza where not exists (
(select distinct codpj from proyecto where ciudad='Londres')
minus
(select distinct codpj from ventas where ventas.codpie=pieza.codpie));


(c�digo de los proveedores que suministran todas las piezas)
vs
c�digos de las piezas suministradas
a todos los proyectos localizados en Londres
