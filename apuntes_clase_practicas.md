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
Si no queremos proyectar ponemos asterisco: select \*.

select \* from ventas v, ventas v2 where v.codpro= 'si'

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

-------------- FUNCIONES DE AGREGACI�N-------
Permite calcular determinados estadisticos sobre conjuntos de tuplas:
select min(cantidad) from ventas; dice la m�nima cantidad que hay en ventas

hay sumatorio, m�nimo, maximo, media,... select avg(cantidad) from ventas; dice la media de la cantidad. Se puede poner
el nombre de la columna o distinct en los operadores que tenga sentido, para que no aparezcan duplicados.

selec avg(distinct cantidad) from ventas; no considera duplicados, y sale un valor distinto.
El conteo se puede hacer sobre tuplas: select count(* ) from ventas;
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
