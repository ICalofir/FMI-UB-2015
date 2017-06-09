--1

--a)

create table angajati_dho(cod_ang number(4), nume varchar2(20), prenume varchar2(20), email
char(15), data_ang date, job varchar2(10), cod_sef number(4), salariu number(8, 2), cod_dep
number(2));

drop table angajati_dho;

--b)

create table angajati_dho(cod_ang number(4) primary key, nume varchar2(20) not null, prenume varchar2(20), email
char(15), data_ang date, job varchar2(10), cod_sef number(4), salariu number(8, 2) not null, cod_dep
number(2));

drop table angajati_dho;


--c)

create table angajati_dho(
cod_ang number(4),
nume varchar2(20) not null,
prenume varchar2(20),
email char(15),
data_ang date default sysdate,
job varchar2(10),
cod_sef number(4),
salariu number(8, 2) not null,
cod_dep number(2),
primary key(cod_ang));

drop table angajati_dho;

--2

insert into angajati_dho
values(100,'Nume1','Prenume1',null,null,'Director',null,20000,10);

insert into angajati_dho
values(101,'Nume2','Prenume2','Nume2',to_date('02-02-2004','dd-mm-yyyy'),'Inginer',100,10000,10);

insert into angajati_dho
values(102,'Nume3','Prenume3','Nume3',to_date('05-06-2000','dd-mm-yyyy'),'Analist',101,5000,20);

insert into angajati_dho
values(103,'Nume4','Prenume4',null,null,'Inginer',100,9000,20);

insert into angajati_dho
values(104,'Nume5','Prenume5','Nume5',null,'Analist',101,3000,30);

--3

create table angajati10_dho
as (select *
    from angajati_dho
    where cod_dep = 10);

select * from angajati10_dho;

desc angajati10_dho;


--4

alter table angajati_dho
add(comision number(4,2));


--5
--Nu merge

alter table angajati_dho
modify(salariu number(6,2));

--6

alter table angajati_dho
modify(salariu default 1000);

--7

alter table angajati_dho
modify(comision number(2,2), salariu number(10,2));

--8

update angajati_dho
set comision = 0.1
where job like 'A%';

select * from angajati_dho;

--9

alter table angajati_dho
modify(email varchar2(15));

--10

alter table angajati_dho
add(nr_telefon char(10) default '0000000000');

select nr_telefon from angajati_dho;

--11

alter table angajati_dho
drop(nr_telefon);

select * from angajati_dho;

--12

rename angajati_dho to angajati3_dho;

--13

select * from tab;

rename angajati3_dho to angajati_dho;


--14

select * from angajati10_dho;
truncate table angajati10_dho;

--15

create table departamente_dho(
cod_dept number(2),
nume varchar2(15) not null,
cod_director number(4));

--16

insert into departamente_dho
values(10,'Administrativ',100);


insert into departamente_dho
values(20,'Proiectare',101);


insert into departamente_dho
values(30,'Programare',null);

select * from departamente_dho;


--17

alter table departamente_dho
add constraint cod_dept_pk primary key(cod_dept);

desc departamente_dho;

--18

--a)
alter table angajati_dho
add constraint fk_ang_dep foreign key(cod_dep) references departamente_dho(cod_dept);


--b)

drop table angajati_dho;

create table angajati_dho(
cod_ang number(4) constraint pk_ang_dho primary key,
nume varchar2(20) constraint nn_nume_ang_dho not null,
prenume varchar2(20),
email char(15) constraint u_email_ang_dho unique,
data_ang date default sysdate,
job varchar2(10),
cod_sef number(4) constraint fk_ang_ang references angajati_dho(cod_ang),
salariu number(8, 2) constraint nn_salariu_ang_dho not null,
cod_dep number(2) constraint fk_ang_dep_dho references departamente_dho(cod_dept) constraint ck_cod_dep_dho check(cod_dep > 0),
comision number(2,2),
constraint nume_prenume_dho unique(nume, prenume),
constraint ck_sal_com_dho check(salariu > comision * 100));

desc angajati_dho;

--19

drop table angajati_dho;



create table angajati_dho(
cod_ang number(4),
nume varchar2(20) constraint nn_nume_ang_dho not null,
prenume varchar2(20),
email char(15),
data_ang date default sysdate,
job varchar2(10),
cod_sef number(4),
salariu number(8, 2) constraint nn_salariu_ang_dho not null,
cod_dep number(2),
comision number(2,2),
constraint nume_prenume_dho unique(nume, prenume),
constraint ck_sal_com_dho check(salariu > comision * 100),
constraint pk_ang_dho primary key(cod_ang),
constraint u_email_ang_dho unique(email),
constraint fk_ang_ang foreign key(cod_sef) references angajati_dho(cod_ang),
constraint fk_ang_dep_dho foreign key(cod_dep) references departamente_dho(cod_dept),
constraint ck_cod_dep_dho check(cod_dep > 0));


--20

insert into angajati_dho
values(100,'Nume1','Prenume1',null,null,'Director',null,20000,10,null);

insert into angajati_dho
values(101,'Nume2','Prenume2','Nume2',to_date('02-02-2004','dd-mm-yyyy'),'Inginer',100,10000,10,null);

insert into angajati_dho
values(102,'Nume3','Prenume3','Nume3',to_date('05-06-2000','dd-mm-yyyy'),'Analist',101,5000,20,null);

insert into angajati_dho
values(103,'Nume4','Prenume4',null,null,'Inginer',100,9000,20,null);

insert into angajati_dho
values(104,'Nume5','Prenume5','Nume5',null,'Analist',101,3000,30,null);

select * from angajati_dho;

--21

drop table departamente_dho;

--22

desc user_tables;
desc tab;
desc user_constraints;

--23

--a)

SELECT constraint_name, constraint_type, table_name
FROM user_constraints
WHERE lower(table_name) IN ('angajati_dho', 'departamente_dho');

--b)

SELECT table_name, constraint_name, column_name
FROM user_cons_columns
WHERE LOWER(table_name) IN ('angajati_dho', 'departamente_dho');


--24

alter table angajati_dho
add constraint nn_email_angajati_dho check(email is not null);

update angajati_dho
set email = 'unknown' || cod_ang
where email is null;

--varianta 2

alter table angajati_dho
modify (email not null);


--25
desc angajati_dho;

insert into angajati_dho
values(260,'Numerandom','Prenumerandom','Numeenmail',sysdate,'Analist',null,5000,50,null);

--26

desc departamente_dho;

insert into departamente_dho
values(60,'Analiza',null);

commit;

--27

delete from departamente_dho
where cod_dept = 20;

--28

delete from departamente_dho
where cod_dept = 60;

rollback;

--29
desc angajati_dho;
insert into angajati_dho
values(260,'Numerandom','Prenumerandom','Numeenmail',sysdate,'Analist',114,5000,60,null);


--30

insert into angajati_dho
values(114,'Numerandom','Prenumerandom','Numeenmail',sysdate,'Analist',null,5000,60,null);

insert into angajati_dho
values(260,'Numerandom11','Prenumerandom1','Numeenmail1',sysdate,'Analist',114,5000,60,null);


--31

SELECT constraint_name, uc.table_name, column_name, constraint_type
FROM user_cons_columns ucc join user_constraints uc using(constraint_name)
WHERE lower(uc.table_name) IN ('angajati_dho');

alter table angajati_dho
drop constraint fk_ang_dep_dho;

alter table angajati_dho
add constraint fk_ang_dep_dho foreign key(cod_dep) references departamente_dho(cod_dept)
on delete cascade;


--32

select * from angajati_dho
where cod_dep = 20;


delete departamente_dho
where cod_dept = 20;

rollback;


--33

SELECT constraint_name, uc.table_name, column_name, constraint_type
FROM user_cons_columns ucc join user_constraints uc using(constraint_name)
WHERE lower(uc.table_name) IN ('departamente_dho');


alter table departamente_dho
add constraint fk_dep_ang_dho foreign key(cod_director) references angajati_dho(cod_ang)
on delete set null;

--34

update departamente_dho
set cod_director = 102
where cod_dept = 30;

delete from angajati_dho
where cod_ang = 102;

select * from departamente_dho
where cod_dept = 30;

rollback;

delete from angajati_dho
where cod_ang = 101;

--35

alter table angajati_dho
add constraint ck_ang_sal_dho check(salariu < 30000);

--36

update angajati_dho
set salariu = 35000
where cod_ang = 100;

--37

alter table angajati_dho
disable constraint ck_ang_sal_dho;


alter table angajati_dho
enable constraint ck_ang_sal_dho;

rollback;
