--1--
-- a) nu --
-- b) having - conditii pe grupuri, where - conditii pe linii --

--2--
select max(salary) "Maxim", min(salary) "Minim", sum(salary) "Suma", round(avg(salary)) "Medie" from employees;

--3--
select
  job_id,
  max(salary) "Maxim",
  min(salary) "Minim",
  sum(salary) "Suma",
  round(avg(salary)) "Medie"
from
  employees
group by
  job_id;

--4--
select
  job_id,
  count(*)
from
  employees
group by
  job_id;

--5--
select
  count(distinct manager_id) "Nr manageri"
from
  employees;
  
--6--
select
  max(salary) - min(salary) "Diferenta"
from
  employees;
  
--7--
select
  d.department_name,
  l.city,
  count(*) "Nr angajati",
  avg(e.salary) "Salariu mediu"
from
  employees e
join
  departments d on (e.department_id = d.department_id)
join
  locations l on (d.location_id = l.location_id)
group by
  department_name,
  l.city;
  
--8--
select
  employee_id,
  last_name
from
  employees
where
  salary > (select
              avg(salary)
            from
              employees)
order by
  salary DESC;
  
--9--
select
  manager_id,
  min(salary)
from
  employees
where
  manager_id is not null
group by
  manager_id
having
  min(salary) > 1000
order by
  min(salary);
  
--10--
select
  e.department_id,
  max(e.salary),
  d.department_name
from
  employees e
join
  departments d on (e.department_id = d.department_id)
group by
  e.department_id,
  d.department_name
having
  max(e.salary) > 3000;
  
--11--
select
  min(avg(salary))
from
  employees
group by
  job_id;
  
--12--
select
  d.department_id,
  d.department_name,
  nvl(sum(e.salary), 0)
from
  employees e
right outer join
  departments d on (e.department_id = d.department_id)
group by
  d.department_id,
  d.department_name;
  
--13--
select
  max(round(avg(salary)))
from
  employees
group by
  department_id;
  
--14--
select
  j.job_id,
  j.job_title,
  avg(e.salary)
from
  employees e
join  
  jobs j on (e.job_id = j.job_id)
group by
  j.job_id,
  j.job_title
having avg(e.salary) = (select
                          min(avg(salary))
                        from
                          employees
                        group by
                          job_id);

--15--                          
select
  avg(salary)
from
  employees
having avg(salary) > 2500;

--16--
select
  e.department_id,
  e.job_id,
  sum(salary)
from
  employees e
group by
  e.department_id,
  e.job_id;
  
select
  d.department_name,
  j.job_title,
  sum(salary)
from
  employees e
left outer join
  departments d on (e.department_id = d.department_id)
join
  jobs j on (e.job_id = j.job_id)
group by
  d.department_name,
  j.job_title;
  
--17--
select
  d.department_name,
  min(e.salary)
from
  employees e
join
  departments d on (e.department_id = d.department_id)
group by
  d.department_name
having avg(e.salary) = (select
                          max(avg(salary))
                        from
                          employees
                        group by
                          department_id);
                          
--18--
select
  d.department_name,
  d.department_id,
  count(e.employee_id)
from
  employees e
right outer join
  departments d on (e.department_id = d.department_id)
group by
  d.department_id,
  d.department_name
having count(e.employee_id) < 4;

select
  d.department_name,
  d.department_id,
  count(e.employee_id)
from
  employees e
right outer join
  departments d on (e.department_id = d.department_id)
group by
  d.department_id,
  d.department_name
having count(e.employee_id) = (select
                                max(count(employee_id))
                              from
                                employees
                              group by
                                department_id);
                                
--19--
select
  last_name
from
  employees
where
  to_char(hire_date, 'DD') = (select
                                to_char(hire_date, 'DD')
                              from
                                employees
                              group by
                                to_char(hire_date, 'DD')
                              having count(to_char(hire_date, 'DD')) = (select
                                                                          max(count(to_char(hire_date, 'DD')))
                                                                        from
                                                                          employees
                                                                        group by
                                                                          to_char(hire_date, 'DD')));

--20--
select
  count(count(department_id))
from
  employees
group by
  department_id
having count(department_id) > 15;

--21--
select
  department_id,
  sum(salary)
from
  employees
--where
--  department_id <> 30
group by
  department_id
having count(department_id) > 10 and department_id != 30;

--22--
select
  d.department_id,
  d.department_name,
  e.last_name,
  e.salary,
  e.job_id,
  count(ee.employee_id),
  avg(ee.salary)
from
  employees e
right outer join
  departments d on (e.department_id = d.department_id)
left outer join
  employees ee on (d.department_id = ee.department_id)
group by
  d.department_id,
  d.department_name,
  e.last_name,
  e.salary,
  e.job_id;
  
select
  d.department_id,
  d.department_name,
  e.last_name,
  e.salary,
  e.job_id,
  count(ee.employee_id),
  avg(ee.salary)
from
  employees e
right outer join
  (departments d
   left outer join
    employees ee on (d.department_id = ee.department_id)) on (e.department_id = d.department_id)
group by
  d.department_id,
  d.department_name,
  e.last_name,
  e.salary,
  e.job_id;
  
--23--
select
  d.department_id,
  j.job_id,
  l.city,
  sum(salary)
from
  employees e
right outer join
  departments d on (e.department_id = d.department_id)
left outer join
  jobs j on (e.job_id = j.job_id)
left join
  locations l on (d.location_id = l.location_id)
group by
  d.department_id,
  j.job_id,
  l.city
having d.department_id > 80;

--24--
select
  e.last_name
from
  employees e
join
  job_history j on (e.employee_id = j.employee_id)
group by
  e.last_name
having count(e.last_name) >= 2;

--25--
select
  avg(commission_pct)
from
  employees;
  
select
  round(avg(nvl(commission_pct, 0)), 2)
from
  employees;
  
select
  round(sum(commission_pct) / count(*), 2)
from
  employees;
  
--26--
SELECT
  department_id, TO_CHAR(hire_date, 'yyyy'),
  SUM(salary)
FROM
  employees
WHERE
  department_id < 50
GROUP BY
  ROLLUP(department_id, TO_CHAR(hire_date, 'yyyy'));
  
SELECT
  department_id, TO_CHAR(hire_date, 'yyyy'),
  SUM(salary)
FROM
  employees
WHERE
  department_id < 50
GROUP BY
  CUBE(department_id, TO_CHAR(hire_date, 'yyyy'));
  
--27--
select
  job_id "Job",
  sum(decode(department_id, 30, salary, 0)) "Dep30",
  sum(decode(department_id, 50, salary, 0)) "Dep50",
  sum(decode(department_id, 80, salary, 0)) "Dep80",
  sum(salary) "Total"
from
  employees
group by
  job_id;
  
--28--
select
  count(employee_id) "Total angajati",
  count(decode(to_char(hire_date, 'YYYY'), '1997', employee_id, null)) "Angajati in 97",
  count(decode(to_char(hire_date, 'YYYY'), '1998', employee_id, null)) "Angajati in 98",
  count(decode(to_char(hire_date, 'YYYY'), '1999', employee_id, null)) "Angajati in 99",
  count(decode(to_char(hire_date, 'YYYY'), '2000', employee_id, null)) "Angajati in 2000"
from
  employees;
  
--29--
select
  d.department_id,
  d.department_name,
  sum(e.salary)
from
  employees e
join
  departments d on (e.department_id = d.department_id)
group by
  d.department_id,
  d.department_name;
  
select
  d.department_id,
  department_name,
  a.suma
from
  departments d,
  (select
    department_id,
    sum(salary) suma
  from
    employees
  group by
    department_id) a
where
  d.department_id = a.department_id;
  
--30--
select
  e.last_name,
  e.salary,
  e.department_id,
  s.avg_salary
from
  employees e
right outer join
  (select
    department_id,
    avg(salary) avg_salary
  from
    employees
  group by
    department_id) s on (e.department_id = s.department_id);
    
--31--
select
  e.last_name,
  e.salary,
  e.department_id,
  s.avg_salary,
  s.nr_angj
from
  employees e
right outer join
  (select
    department_id,
    count(employee_id) nr_angj,
    avg(salary) avg_salary
  from
    employees
  group by
    department_id) s on (e.department_id = s.department_id);
    
--32--
select distinct
  d.department_name,
  e.department_id,
  ee.min_salary,
  eee.min_last_name
from
  employees e
right outer join
  departments d on (e.department_id = d.department_id)
left outer join
  (select
    department_id,
    min(salary) min_salary
  from
    employees
  group by
    department_id) ee on (e.department_id = ee.department_id)
left outer join
  (select
    department_id,
    last_name min_last_name,
    salary
  from
    employees) eee on (e.department_id = eee.department_id and eee.salary = ee.min_salary);