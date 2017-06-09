--exemplu

--metoda 1

SELECT distinct employee_id
FROM works_on a
WHERE NOT EXISTS (SELECT 1
                  FROM project p
                  WHERE budget=10000
                  AND NOT EXISTS (SELECT 'x'
                                  FROM works_on b
                                  WHERE p.project_id=b.project_id
                                  AND b.employee_id=a.employee_id));
                                  
--metoda2

SELECT employee_id
FROM works_on
WHERE project_id IN (SELECT project_id
                     FROM project
                     WHERE budget=10000)
GROUP BY employee_id
HAVING COUNT(project_id)= (SELECT COUNT(*)
                            FROM project
                            WHERE budget=10000);
                            
--metoda2 - scrisa la lab (nu copiata)

select employee_id
from works_on join project using(project_id)
where budget = 10000
group by employee_id
having count(project_id) = (select count(*)
                            from project
                            where budget = 10000);
                            
--metoda4

select distinct employee_id
from works_on w
where not exists ((select project_id
                  from project p
                  where budget = 10000)
                  minus
                  (select project_id
                   from works_on
                   where employee_id = w.employee_id));
                   
--metoda3

select employee_id
from works_on
minus
select employee_id
from (select employee_id, project_id
      from (select distinct employee_id from works_on),
           (select project_id from project where budget = 10000)
minus
select employee_id, project_id
from works_on);

--1

--metoda 1

SELECT distinct employee_id, last_name
FROM employees a
WHERE NOT EXISTS (SELECT 1
                  FROM project p
                  WHERE to_char(start_date,'yyyy') = 2006
                  and to_char(start_date,'mm') >=1
                  and to_char(start_date,'mm') <=6
                  AND NOT EXISTS (SELECT 'x'
                                  FROM works_on b
                                  WHERE p.project_id=b.project_id
                                  AND b.employee_id=a.employee_id));

--metoda2

select employee_id
from works_on w join project p on(p.project_id = w.project_id)
where to_char(p.start_date,'yyyy') = 2006
and to_char(p.start_date,'mm') >=1
and to_char(p.start_date,'mm') <=6
group by employee_id
having count(p.project_id) = (select count(*)
                              from project
                              where to_char(start_date,'yyyy') = 2006
                              and to_char(start_date,'mm') >=1
                              and to_char(start_date,'mm') <=6);
                              
--metoda4

select distinct employee_id
from works_on w
where not exists ((select project_id
                  from project p
                  where to_char(start_date,'yyyy') = 2006
                  and to_char(start_date,'mm') >=1
                  and to_char(start_date,'mm') <=6)
                  minus
                  (select project_id
                   from works_on
                   where employee_id = w.employee_id));


--metoda3

select employee_id
from works_on
minus
select employee_id
from (select employee_id, project_id
      from (select distinct employee_id from works_on),
           (select project_id from project where to_char(start_date,'yyyy') = 2006
                                           and to_char(start_date,'mm') >=1
                                           and to_char(start_date,'mm') <=6)
minus
select employee_id, project_id
from works_on);

--2

--metoda 1

with t as (select employee_id
                  from job_history
                  group by employee_id
                  having count(*) = 2)
select distinct project_id
from works_on w
where not exists (select employee_id
                  from t
                  where not exists (select 1
                                    from works_on
                                    where project_id = w.project_id
                                    and employee_id = t.employee_id));

--metoda2

select project_id
from works_on w join (select employee_id
                      from job_history
                      group by employee_id
                      having count(*) = 2) t using(employee_id)
group by project_id
having count(employee_id) = (select count(count(*))
                             from job_history
                             group by employee_id
                             having count(*) = 2);
                              
--metoda4

select distinct project_id
from works_on w
where not exists ((select employee_id
                   from job_history
                   group by employee_id
                   having count(*) = 2)
                  minus
                  (select employee_id
                   from works_on
                   where project_id = w.project_id));


--3

select count(*)
from(select employee_id
      from (select employee_id, job_id
            from employees
            union
            select employee_id, job_id
            from job_history)
      group by employee_id
      having count(distinct job_id) >= 3);

--4

select count(employee_id), country_name
from employees left outer join departments using(department_id)
               right outer join locations using(location_id)
               right outer join countries using(country_id)
group by country_name;

--5

select employee_id, last_name
from employees join works_on using(employee_id)
               join project using(project_id)
where delivery_date > deadline
group by employee_id, last_name
having count(distinct project_id) >= 2;

--6

select employee_id, project_id
from employees left outer join works_on using(employee_id);

--7

select employee_id, last_name
from employees e
where exists (select 1
              from employees join project on(employee_id = project_manager)
              where department_id = e.department_id);
              
--8

select employee_id, last_name
from employees
where nvl(department_id, 0) not in (select nvl(department_id, 0)
                            from employees join project on(employee_id = project_manager));
                        
--sau

select employee_id, last_name
from employees e
where not exists (select 1
              from employees join project on(employee_id = project_manager)
              where department_id = e.department_id);

--9

select department_id, department_name
from employees join departments using(department_id)
group by department_id, department_name
having avg(salary) > &p;

--10

select employee_id, last_name, first_name, salary, (select count(project_id)
                                                    from works_on
                                                    where employee_id = e.employee_id) "Lucreaza"
from employees e join project on(e.employee_id = project_manager)
group by employee_id, last_name, first_name, salary
having count(project_id) = 2;

--11

select distinct e.employee_id, e.last_name
from employees e join works_on w on(e.employee_id = w.employee_id)
where not exists ((select project_id
                   from works_on 
                   where employee_id = e.employee_id)
                   minus
                   (select project_id
                   from project p
                   where project_manager = 102));
                   
--12

--a)

select distinct e.employee_id, e.last_name
from employees e join works_on w on(e.employee_id = w.employee_id)
where not exists ((select project_id
                   from works_on p
                   where employee_id = 200)
                   minus
                  (select project_id
                   from works_on 
                   where employee_id = e.employee_id));
                   
--b)

select distinct e.employee_id, e.last_name
from employees e join works_on w on(e.employee_id = w.employee_id)
where not exists ((select project_id
                   from works_on 
                   where employee_id = e.employee_id)
                   minus
                   (select project_id
                   from works_on p
                   where employee_id = 200));


--13

select distinct e.employee_id, e.last_name
from employees e join works_on w on(e.employee_id = w.employee_id)
where not exists ((select project_id
                   from works_on 
                   where employee_id = e.employee_id)
                   minus
                   (select project_id
                   from works_on p
                   where employee_id = 200))
and not exists ((select project_id
                   from works_on p
                   where employee_id = 200)
                   minus
                  (select project_id
                   from works_on 
                   where employee_id = e.employee_id));
                   
--14

--a)

select *
from job_grades;

--b)

select employee_id, last_name, first_name, salary, grade_level
from employees join job_grades on(salary between lowest_sal and highest_sal);

--17

SELECT employee_id, last_name, salary, department_id
FROM employees
WHERE employee_id = &p_cod;

set verify off
ACCEPT p_cod PROMPT “Introduceti codul de angajat “;
SELECT employee_id, last_name, salary, department_id
FROM employees
WHERE employee_id = &p_cod;

--20

SELECT &&p_coloana
FROM &p_tabel
ORDER BY &p_coloana;

undefine p_coloana;


--21

accept data_inceput prompt 'Introduceti data de inceput'
accept data_sfarsit prompt 'Introduceti data de sfarsit'
select last_name Angajat, hire_date
from employees
where hire_date between to_date('&data_inceput', 'mm/dd/yy')
                and to_date('&data_sfarsit', 'mm/dd/yy');
                
--22

accept locatie prompt 'Introduceti o locatie'
select last_name, job_id, salary, department_name
from employees join departments using(department_id)
               join locations using(location_id)
where lower(city) = lower('&locatie');


accept locatie prompt 'Introduceti o locatie'
select last_name, job_id, salary, department_name
from employees join departments using(department_id)
               join locations using(location_id)
where lower(city) like lower(concat('&locatie','%'));


--23 (TEMA)