insert into prueba2 values ('aa', 1);
insert into prueba2 values ('Aa', 2);
insert into prueba2 values ('aa', 1);
insert into plantilla (dni, nombre, estadocivil, fechaalta) values ('12345678', 'Pepe', 'soltero', SYSDATE); 
insert into plantilla (dni, nombre, estadocivil, fechaalta) values('87654321', 'Juan', 'casado', SYSDATE);
insert into serjefe values ('87654321', '12345678'); 
insert into plantilla (dni,estadocivil) values ('11223344', 'soltero');

insert into proveedor values('S1','Jose Fernandez', 2, 'Madrid');

insert into proveedor values('S2','Manuel Vidal', 1, 'Londres');

insert into proveedor values('S3','Luisa Gomez', 3, 'Lisboa');

insert into proveedor values('S5','Maria Reyes', 5, 'Roma');

insert into proveedor values('S4','Pedro Sanchez', 4, 'Paris');


insert into pieza values('P1','Tuerca', 'Gris', 2.5, 'Madrid');
insert into pieza values('P2','Tornillo', 'Rojo', 1.25, 'Paris');
insert into pieza values('P3','Arandela', 'Blanco', 3, 'Londres');
insert into pieza values('P4','Clavo', 'Gris', 5.5, 'Lisboa');
insert into pieza values('P5','Alcayata', 'Blanco', 10, 'Roma');

insert into proyecto values('J1','Proyecto 1', 'Londres');
insert into proyecto values('J2','Proyecto 2', 'Londres');
insert into proyecto values('J3','Proyecto 3', 'Paris');
insert into proyecto values('J4','Proyecto 4', 'Roma');

