--1

create view viz_emp30_dho
as select employee_id, last_name, email, salary
   from emp_dho
   where department_id = 30;

--nu merge
insert into viz_emp30_dho
values (270, 'Gigel', 'GigleGheorghe', 10000);
   
--2

create or replace view viz_emp30_dho
as select employee_id, last_name, email, salary, hire_date, job_id
   from emp_dho
   where department_id = 30;
   
  
--va merge 
insert into viz_emp30_dho
values (270, 'Gigel', 'GigleGheorghe', 10000, sysdate, 'ID_PROG');
   
select *
from viz_emp30_dho;

UPDATE viz_emp30_dho
SET hire_date=hire_date-15
WHERE employee_id=270;

UPDATE emp_dho
SET department_id=30
WHERE employee_id=270;

UPDATE viz_emp30_dho
SET hire_date=hire_date-15
WHERE employee_id=270;

delete from viz_emp30_dho
where employee_id = 270;

--3


create view viz_empsal50_dho
as select employee_id cod_angajat, last_name nume, email, job_id functie, hire_date data_angajare, salary * 12 salarius_anual
          from emp_dho
          where department_id = 50;

--4

select * from viz_empsal50_dho;

--nu va merge
insert into viz_empsal50_dho
values (301, 'Gigel', 'GigleGheorghe', 'IT_PROG', sysdate, 10000);
   
   
insert into viz_empsal50_dho(cod_angajat, nume, email, functie, data_angajare)
values (301, 'Gigel', 'GigleGheorghe', 'IT_PROG', sysdate);


desc user_updatable_columns;

select *
from user_updatable_columns
where lower(table_name) = 'viz_empsal50_dho';

--5

desc emp_dho;
--a)
select *
from user_updatable_columns
where lower(table_name) = 'viz_dep30_dho';

select * from viz_dep30_dho;


SELECT constraint_name, uc.table_name, column_name, constraint_type
FROM user_cons_columns ucc join user_constraints uc using(constraint_name)
WHERE lower(uc.table_name) IN ('emp_dho');

--b)

insert into viz_dep30_dho
values (302, 'Gigel', 'GigleGheorghe', 10000, sysdate, 'IT_PROG', 30, 'Purchasing');

--c)

select *
from user_updatable_columns
where lower(table_name) = 'viz_dep30_dho';

insert into viz_dep30_dho(id_e, nume, mail, slariu, data_ang, job)
values (302, 'Gigel', 'GigleGheorghe', 10000, sysdate, 'IT_PROG');


create or replace view viz_dep30_dho
as select employee_id id_e, last_name nume, email mail, salary slariu, hire_date data_ang, job_id job, d.department_id id_dept, department_name nume_dep
   from emp_dho e join dept_dho d on(e.department_id = d.department_id)
   where d.department_id = 30;
   
   
--6
create or replace view viz_dept_sum_dho
as select department_id, min(salary) sal_min, max(salary) max_sal, avg(salary) media
   from emp_dho
   group by department_id;
   
select * from viz_dept_sum_dho;

select *
from user_updatable_columns
where lower(table_name) = 'viz_dept_sum_dho';

--7

create or replace view viz_emp30_dho
as select employee_id, last_name, email, salary, hire_date, job_id
   from emp_dho
   where department_id = 30
with check option constraint ck_dep30_dho;

insert into viz_emp30_dho
values (303, 'Gigel', 'GigleGheorghe', 10000, sysdate, 'ID_PROG');


SELECT constraint_name, uc.table_name, column_name, constraint_type
FROM user_cons_columns ucc right join user_constraints uc using(constraint_name)
WHERE lower(uc.table_name) IN ('viz_emp30_dho');

--8

--a)

create or replace view  viz_emp_s_dho
as select employee_id, last_name, email, hire_date, job_id, department_id, department_name
   from emp_dho join dept_dho using(department_id)
   where department_name like 'S%';

insert into viz_emp_s_dho
values (305, 'Gigel', 'GigleGheorghe', sysdate, 'ID_PROG', 30, 'Sales');

insert into viz_emp_s_dho(employee_id, last_name, email, hire_date, job_id)
values (305, 'Gigel', 'GigleGheorghe', sysdate, 'ID_PROG');

select * from viz_emp_s_dho
where employee_id not in (select nvl(manager_id, 0)
                          from emp_dho);

delete from viz_emp_s_dho
where employee_id = 162;

rollback;


select *
from user_updatable_columns
where lower(table_name) = 'viz_emp_s_dho';

--b)

create or replace view  viz_emp_s_dho
as select employee_id, last_name, email, hire_date, job_id, department_id, department_name
   from emp_dho join dept_dho using(department_id)
   where department_name like 'S%'
with read only;


--9

SELECT view_name, text
FROM user_views
WHERE view_name LIKE '%DHO';

--10

select last_name, salary, department_id, salariu
from employees e left outer join (SELECT department_id, max(salary) salariu
                     from employees
                     group by department_id)
                using(department_id);
                
--11

create or replace view  viz_sal_dho
as select last_name, department_name, salary, city
   from employees join departments using(department_id)
                 join locations using(location_id);
                 
select *
from user_updatable_columns
where lower(table_name) = 'viz_sal_dho';

--12

--a)

CREATE or replace VIEW viz_emp_dho (employee_id, first_name, last_name,
                         email UNIQUE DISABLE NOVALIDATE, phone_number,
CONSTRAINT pk_viz_emp_pnu PRIMARY KEY (employee_id) DISABLE NOVALIDATE)
AS SELECT employee_id, first_name, last_name, email, phone_number
FROM emp_dho;

--b)

create or replace view  viz_emp_s_dho(employee_id, last_name, email, hire_date, job_id, department_id, department_name,
constraint pk_viz_emp_s_dho primary key(employee_id) disable novalidate)
as select employee_id, last_name, email, hire_date, job_id, department_id, department_name
   from emp_dho join dept_dho using(department_id)
   where department_name like 'S%';
   
--13

ALTER TABLE emp_dho
ADD CONSTRAINT ck_name_emp_dho
CHECK (UPPER(last_name) NOT LIKE 'WX%');

CREATE OR REPLACE VIEW viz_emp_wx_dho
AS SELECT *
FROM emp_dho
WHERE UPPER(last_name) NOT LIKE 'WX%'
WITH CHECK OPTION CONSTRAINT ck_name_emp_dho2;

UPDATE viz_emp_wx_dho
SET last_name = 'Wxyz'
WHERE employee_id = 150;


--14

create sequence seq_dept_dho
start with 400
increment by 10
maxvalue 10000
nocache;

select seq_dept_dho.currval
from dual;

--15

desc user_sequences;
select * from user_sequences
where sequence_name = 'SEQ_DEPT_DHO';

--16

create sequence seq_emp_dho
start with 1;

drop sequence seq_emp_dho;

--17

update emp_dho
set emp_id_tmp = seq_emp_dho.nextval;

alter table emp_dho
add (emp_id_tmp number(6));

select emp_id_tmp from emp_dho;

SELECT constraint_name, uc.table_name, column_name, constraint_type
FROM user_cons_columns ucc right join user_constraints uc using(constraint_name)
WHERE lower(uc.table_name) IN ('emp_dho');

alter table dept_dho
disable constraint fk_dept_emp_dho;

update dept_dho e
set manager_id = (select emp_id_tmp
                  from emp_dho
                  where employee_id = e.manager_id);
                  
alter table emp_dho
disable constraint fk_emp_emp_dho;
                  
update emp_dho e
set manager_id = (select emp_id_tmp
                  from emp_dho
                  where employee_id = e.manager_id);

update emp_dho e
set employee_id = emp_id_tmp;

alter table emp_dho
enable constraint fk_emp_emp_dho;

alter table dept_dho
enable constraint fk_dept_emp_dho;

alter table emp_dho
drop column emp_id_tmp;

select * from emp_dho;

--18

desc dept_dho;

insert into dept_dho
values (seq_dept_dho.nextval, 'Ceva',null, null);

--19

SELECT seq_emp_dho.currval
FROM dual ;

SELECT seq_dept_dho.currval
FROM dual ;

--20

drop sequence seq_dept_dho;

--21

create index idx_emp_last_name_dho
on emp_dho(last_name);

--27

create synonym emp_public_dho
for emp_dho;

select  * from emp_dho;
select * from emp_public_dho;

