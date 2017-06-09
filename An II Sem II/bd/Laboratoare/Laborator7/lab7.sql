--1

create table EMP_DHO as select* from employees;
create table DEPT_DHO as select* from departments;

desc emp_dho;
desc employees;

select * from emp_dho;

alter table emp_dho add constraint pk_emp_dho primary key(employee_id);

desc emp_dho


alter table dept_dho add constraint pk_dept_dho primary key(department_id);


alter table emp_dho add constraint fk_emp_dept_dho foreign key(department_id) references dept_dho(department_id);

alter table dept_dho add constraint fk_dept_emp_dho foreign key(manager_id) references emp_dho(employee_id);

alter table emp_dho add constraint fk_emp_emp_dho foreign key(manager_id) references emp_dho(employee_id);

--5

--a) nu merge
insert into dept_dho
values(300, 'Programare');

--b) merge
INSERT INTO DEPT_dho (department_id, department_name)
VALUES (300, 'Programare');

rollback;

--c) nu merge

INSERT INTO DEPT_pnu (department_name, department_id)
VALUES (300, ‘Programare’);

--d) merge

INSERT INTO DEPT_dho (department_id, department_name, location_id)
VALUES (300, 'Programare', null);

rollback;

--e) nu merge

NSERT INTO DEPT_dho (department_name, location_id)
VALUES ('Programare', null);

--6

desc emp_dho;

insert into emp_dho
values(250,'Gigle','Vasile','gigel@gmail.com',null,sysdate,'ID_PROG',null,null,null,300);
commit;

--7

insert into emp_dho(employee_id, first_name, last_name, email, hire_date, job_id, department_id)
values(251,'Gheorghe','Joe','joe@gmail.com',sysdate,'ID_PROG',300);
commit;

--8

insert into emp_dho(employee_id, last_name, email, hire_date, job_id, salary, commission_pct)
values(252,'Nume252','nume252@gmail.com',sysdate,'SA_REP',5000,null);

rollback;

insert into(select employee_id, last_name, email, hire_date, job_id, salary, commission_pct
            from emp_dho)
values(252,'Nume252','nume252@gmail.com',sysdate,'SA_REP',5000,null);

commit;

insert into emp_dho(employee_id, last_name, email, hire_date, job_id, salary, commission_pct)
values((select max(employee_id) + 1 from emp_dho),'Nume252','nume252@gmail.com',sysdate,'SA_REP',5000,null);

commit;

--9

CREATE TABLE emp1_dho AS SELECT * FROM employees
where 1 = 0;

INSERT INTO emp1_dho
  SELECT *
  FROM employees
  WHERE commission_pct > 0.25;

SELECT employee_id, last_name, salary, commission_pct
FROM emp1_dho;

ROLLBACK;

--10

INSERT INTO emp_dho
  SELECT 0,USER,USER, 'TOTAL', 'TOTAL',SYSDATE,
        'TOTAL', SUM(salary), ROUND(AVG(commission_pct)), null, null
FROM employees;

select * from emp_dho
order by employee_id;

--11

accept p_cod prompt 'Introduceti codul'
accept p_nume prompt 'Introduceti nume'
accept p_prenume prompt 'Introduceti prenumele'
accept p_salariu prompt 'Introduceti salariul'
insert into emp_dho(employee_id, first_name, last_name,hire_date, email, job_id, salary,department_id)
values(&p_cod, '&p_nume', '&p_prenume',sysdate, concat(substr('&p_prenume',1,1),substr('&p_nume',1,8)) ,'ID_PROG',&p_salariu,300);

select * from emp_dho where employee_id = 254;

--12


CREATE TABLE emp2_dho AS SELECT * FROM employees
where 1 = 0;


CREATE TABLE emp3_dho AS SELECT * FROM employees
where 1 = 0;

INSERT ALL
  WHEN salary < 5000 THEN
    INTO emp1_dho
  WHEN salary > = 5000 AND salary <= 10000 THEN
    INTO emp2_dho
  ELSE
    INTO emp3_dho
SELECT * FROM employees;

SELECT * FROM emp1_dho;
SELECT * FROM emp2_dho;
SELECT * FROM emp3_dho;
DELETE FROM emp1_dho;
DELETE FROM emp2_dho;
DELETE FROM emp3_dho;

--13

CREATE TABLE emp0_dho AS SELECT * FROM employees
where 1 = 0;

INSERT FIRST
  WHEN department_id = 80 THEN
    INTO emp0_dho
  WHEN salary < 5000 THEN
    INTO emp1_dho
  WHEN salary > = 5000 AND salary <= 10000 THEN
    INTO emp2_dho
  ELSE
    INTO emp3_dho
SELECT * FROM employees;
SELECT * FROM emp0_dho;

--14

UPDATE emp_dho
SET salary = salary * 1.05;
SELECT * FROM emp_dho;
ROLLBACK;

--15

update emp_dho
set job_id = 'SA_REP'
where department_id = 80;

select * from emp_dho;
rollback;

--16

update emp_dho
set salary = salary + 1000
where lower(last_name) = 'grant' and lower(first_name) = 'douglas';

update dept_dho
set manager_id = (select employee_id
                  from emp_dho
                  where lower(last_name) = 'grant' and lower(first_name) = 'douglas')
where department_id = 80;

rollback;

--17

update emp_dho e
set e.salary = (select salary
                from emp_dho
                where e.manager_id = employee_id),
e.commission_pct = (select commission_pct
                        from emp_dho
                        where e.manager_id = employee_id)
where e.salary = (select min(salary)
                  from emp_dho);
                  
--sau

update emp_dho e
set (salary, commission_pct) = (select salary, commission_pct
                                from emp_dho
                                where employee_id = e.manager_id)
where salary = (select min(salary)
                from emp_dho);
                
                
                
--18

update emp_dho e
set email = substr(last_name,1,1) || nvl(first_name,'.')
where salary = (select max(salary)
                from emp_dho
                where e.department_id = department_id);
rollback;

--19

update emp_dho e
set salary = (select avg(nvl(salary, 0)) 
              from emp_dho
              where e.department_id = department_id)
where hire_date = (select min(hire_date)
                   from emp_dho
                   where e.department_id = department_id);

--20

update emp_dho
set (job_id, department_id) = (select job_id, department_id
                               from emp_dho
                               where employee_id = 205)
where employee_id = 114;

--21

accept p_cod prompt 'Introduceti codul departamentului'
select * from dept_dho
where department_id = &p_cod;
accept p_nume prompt 'Introduceti numele departamentului'
accept p_loc prompt 'Introduceti codul locatiei'
accept p_manager prompt 'Introduceti codul managerului'
update dept_dho
set department_name = '&p_nume', location_id = nvl('&p_loc', null), manager_id = &p_manager
where department_id = &p_cod;


--22

delete from dept_dho
where department_id not in (select nvl(department_id, -1) 
                            from emp_dho);
rollback;

--23

delete from emp_dho e
where commission_pct is null
and employee_id not in (select nvl(manager_id, 0)
                        from dept_dho
                        where e.employee_id = manager_id)
and employee_id not in (select nvl(manager_id, 0)
                        from emp_dho);
                        
rollback;

--24 (e ca 22)

--25

accept p_cod prompt 'Introduceti codul angajatului'
select * from emp_dho
where employee_id = &p_cod;
delete from emp_dho
where employee_id = &p_cod;

--26

commit;

--27

accept p_cod prompt 'Introduceti codul'
accept p_nume prompt 'Introduceti nume'
accept p_prenume prompt 'Introduceti prenumele'
accept p_salariu prompt 'Introduceti salariul'
insert into emp_dho(employee_id, first_name, last_name,hire_date, email, job_id, salary,department_id)
values(&p_cod, '&p_nume', '&p_prenume',sysdate, concat(substr('&p_prenume',1,1),substr('&p_nume',1,8)) ,'ID_PROG',&p_salariu,300);

--28

savepoint p;

--29

delete from emp_dho
where employee_id not in (select nvl(manager_id, -1)
                          from dept_dho)
and employee_id not in (select nvl(manager_id, -1)
                        from emp_dho);
                        
select * from emp_dho;

--30

rollback to p;

--31

select * from emp_dho
where employee_id = 254;

commit;

--32

delete from emp_dho e
where commission_pct is not null
and employee_id not in (select nvl(manager_id, 0)
                        from dept_dho
                        where e.employee_id = manager_id)
and employee_id not in (select nvl(manager_id, 0)
                        from emp_dho);
 

select count(*)
from emp_dho;

MERGE INTO emp_dho x
USING employees e
ON (x.employee_id = e.employee_id)
WHEN MATCHED THEN
  UPDATE SET
    x.first_name=e. first_name,
    x.last_name=e.last_name,
    x.email=e.email,
    x.phone_number=e.phone_number,
    x.hire_date= e.hire_date,
    x.job_id= e.job_id,
    x.salary = e.salary,
    x.commission_pct = e.commission_pct,
    x.manager_id= e.manager_id,
    x.department_id= e.department_id
WHEN NOT MATCHED THEN
INSERT VALUES (e.employee_id, e.first_name, e.last_name, e.email,
               e.phone_number, e.hire_date, e.job_id, e.salary, e.commission_pct, e.manager_id,
               e.department_id);