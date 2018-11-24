create table plantilla(
dni char(8),
nombre varchar2(15),
estadocivil varchar(10) check(estadocivil in ('soltero', 'casado', 'divorciado', 'viudo')),
fechaalta date,
primary key(dni));

create table serjefe(
dnitrabajador char(8),
dnijefe references plantilla(dni),
primary key (dnitrabajador));