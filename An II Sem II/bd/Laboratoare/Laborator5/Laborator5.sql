--1--
select
  d.department_name,
  j.job_title,
  avg(e.salary)
from
  employees e
right outer join
  departments d on (e.department_id = d.department_id)
join
  jobs j on (e.job_id = j.job_id)
group by rollup(
  d.department_name,
  j.job_title);
  
select
  d.department_name,
  j.job_title,
  avg(e.salary),
  grouping(d.department_name),
  grouping(j.job_title)
from
  employees e
right outer join
  departments d on (e.department_id = d.department_id)
join
  jobs j on (e.job_id = j.job_id)
group by rollup(
  d.department_name,
  j.job_title);
  
--2--
select
  d.department_name,
  j.job_title,
  avg(e.salary),
  decode(grouping(d.department_name), 0, 'Dep', '-'),
  decode(grouping(j.job_title), 0, 'Job', '-')
from
  employees e
right outer join
  departments d on (e.department_id = d.department_id)
join
  jobs j on (e.job_id = j.job_id)
group by cube(
  d.department_name,
  j.job_title);
  
--3--
select
  d.department_name,
  j.job_title,
  sum(e.salary),
  max(e.salary),
  e.manager_id
from
  employees e
right outer join
  departments d on (e.department_id = d.department_id)
join
  jobs j on (e.job_id = j.job_id)
group by grouping sets
  ((d.department_name, j.job_title), (j.job_title, e.manager_id), ());
  
--4--
select
  max(salary)
from
  employees
having (max(salary)) > 15000;

--5--
select
  last_name,
  salary,
  department_id
from
  employees e
where
  salary > (select
            avg(salary)
          from
            employees
          where
            e.department_id = department_id);
            
select
  e.last_name,
  e.salary,
  e.department_id,
  d.department_name,
  sal_med,
  nr_sal
from
  employees e
join
  departments d on (e.department_id = d.department_id)
join
  (select
    department_id,
    avg(salary) sal_med,
    count(*) nr_sal
  from
    employees
  group by
    department_id) sm on (d.department_id = sm.department_id)
where
  salary > (select
            avg(salary)
          from
            employees
          where
            e.department_id = department_id);
            
select
  e.last_name,
  e.salary,
  e.department_id,
  d.department_name,
  (select
    avg(salary)
  from
    employees
  group by
    department_id
  having
    department_id = e.department_id) "salariu mediu",
  (select
    count(*)
  from
    employees
  group by
    department_id
  having
    department_id = e.department_id) "nr angajati"
from
  employees e
join
  departments d on (e.department_id = d.department_id)
where
  salary > (select
            avg(salary)
          from
            employees
          where
            e.department_id = department_id);
            
--6--
select
  last_name,
  salary
from
  employees
where
  salary > all(select
                avg(salary)
              from
                employees
              group by
                department_id);
                
select
  last_name,
  salary
from
  employees
where
  salary > (select
              max(avg(salary))
            from
              employees
            group by
              department_id);
              
--7--
select
  last_name,
  salary
from
  employees e
where
  salary = (select
              min(salary)
            from
              employees
            where
              e.department_id = department_id);
              
select
  last_name,
  salary
from
  employees e
where
  (salary, department_id) in (select
                                min(salary),
                                department_id
                              from
                                employees
                              group by
                                department_id);
                                
select
  last_name,
  salary
from
  employees e
join (select
        min(salary) min_sal,
        department_id
      from
        employees
      group by
        department_id) d on (e.department_id = d.department_id)
where
  salary = d.min_sal;
  
--8--
select
  d.department_name,
  ee.last_name,
  ee.hire_date
from
  departments d
join
  (select
    department_id,
    min(hire_date) min_date
  from
    employees
  group by
    department_id) e on (e.department_id = d.department_id)
join
  (select
    department_id,
    last_name,
    hire_date
  from
    employees) ee on (e.department_id = ee.department_id and e.min_date = ee.hire_date)
order by
  d.department_name;
  
--9--
select
  last_name
from
  employees e
where
  exists (select
            1
          from
            employees
          where
            e.department_id = department_id
            and
            salary = (select
                        max(salary)
                      from
                        employees
                      where
                        department_id = 30));
                        
--10--
select
  last_name,
  salary
from
  employees e
where
  (select
    count(*)
  from
    employees
  where
    salary > e.salary) <= 2;

select
  last_name,
  salary
from
  employees e
where
  rownum <= 3
order by
  salary DESC;
  
select
  last_name,
  salary
from
  employees
where
  salary in (select
              salary
            from
              (select distinct
                salary
              from
                employees
              order by
                salary desc)
              where
                rownum <= 3)
order by 2;

select
  *
from
  (select
    last_name,
    salary
  from
    employees
  where
    rowid in (select
                max(rowid)
              from
                employees
              group by
                salary)
  order by
    salary DESC)
where
  rownum <= 3;

--11--
select
  last_name,
  first_name,
  employee_id
from
  employees e
where
  (select
    count(employee_id)
  from
    employees
  where
    e.employee_id = manager_id) >= 2;
    
--12--
select
  *
from
  locations
where
  location_id in (select
                    location_id
                  from
                    departments);
                    
--13--
select
  department_id,
  department_name
from
  departments
where
  department_id not in (select
                          nvl(department_id, 0)
                        from
                          employees);
                          
--14--
select
  employee_id,
  last_name,
  hire_date,
  salary,
  manager_id
from
  employees
where
  manager_id = (select
                  employee_id
                from
                  employees
                where
                  lower(last_name) = 'de haan');
                  
select
  employee_id,
  last_name,
  hire_date,
  salary,
  manager_id,
  level
from
  employees
start with
  employee_id = (select
                  employee_id
                from
                  employees
                where
                  lower(last_name) = 'de haan')
connect by
  prior employee_id = manager_id;
  
select
  employee_id,
  last_name,
  hire_date,
  salary,
  manager_id,
  level
from
  employees
start with
  employee_id = (select
                  employee_id
                from
                  employees
                where
                  lower(last_name) = 'de haan')
connect by
  prior manager_id = employee_id;
  
--15--
select
  employee_id,
  last_name,
  hire_date,
  salary,
  manager_id,
  level
from
  employees
start with
  employee_id = 114
connect by
  prior employee_id = manager_id;
  
--16--
select
  employee_id,
  manager_id,
  last_name,
  level
from
  employees
where
  level = 3
start with
  lower(last_name) = 'de haan'
connect by
  prior employee_id = manager_id;
  
--17--
select
  employee_id,
  manager_id,
  last_name,
  level,
  lpad(last_name, length(last_name) + 2 * (level - 1), '_')
from
  employees
connect by
  prior manager_id = employee_id;
  
--18--
select
  employee_id,
  manager_id,
  last_name,
  level
from
  employees
start with
  salary = (select
              max(salary)
            from
              employees)
connect by
  prior employee_id = manager_id and salary > 5000;
  
--19--
with
  val_dep as (select
                d.department_name,
                sum(e.salary) total
              from
                departments d
              join
                employees e on (e.department_id = d.department_id)
              group by
                department_name),
  val_medie as (select
                  sum(total) / count(*) as medie
                from
                  val_dep)
select
  *
from
  val_dep;
where
  total > (select
            medie
          from 
            val_medie)
order by
  department_name;
  
select
  d.department_id,
  d.department_name,
  sum(e.salary)
from
  departments d
join
  employees e on (e.department_id = d.department_id)
group by
  d.department_name,
  d.department_id
having
  sum(e.salary) > (select
                    avg(sum(salary))
                  from
                    employees
                  where
                    department_id is not null
                  group by
                    department_id);
                    
--20--
select
  employee_id || ', ' || first_name || ' ' || last_name "Angajat",
  job_id,
  hire_date
from
  employees
where
  to_char(hire_date, 'YYYY') != '1970'
start with
  employee_id in (select
                    employee_id
                  from
                    employees
                  where
                    manager_id in (select
                                    employee_id
                                  from
                                    employees
                                  where
                                    lower(first_name || ' ' || last_name) = 'steven king')
                    and
                    hire_date = (select
                                  min(hire_date)
                                from
                                  (select
                                    hire_date
                                  from
                                    employees
                                  where
                                    manager_id in(select
                                                    employee_id
                                                  from
                                                    employees
                                                  where
                                                    lower(first_name || ' ' || last_name) = 'steven king'))))
connect by prior employee_id = manager_id;

with
  sk as (select
          employee_id 
        from
          employees
        where
          lower(first_name||' '||last_name) = 'steven king'),
  sub_sk as (select
              employee_id,
              hire_date
            from
              employees
            where
              manager_id in (select
                              employee_id
                            from
                              sk)),
  oldest_sub_sk as (select
                      employee_id
                    from
                      sub_sk
                    where
                      hire_date = (select
                                    min(hire_date)
                                  from
                                    sub_sk))
select
  employee_id,
  first_name||' '||last_name "Nume",
  job_id,
  hire_date
from
  employees
where
  to_char(hire_date,'yyyy') != '1970'
start with
  employee_id in (select
                    employee_id
                  from
                    oldest_sub_sk)
connect by prior employee_id = manager_id;

--21--
select
  *
from
  (select
    *
  from
    employees
  order by
    salary DESC)
where
  rownum < 11;
  
--22--
select
  job_id,
  "avg_sal"
from
  (select
    job_id,
    avg(salary) "avg_sal"
  from
    employees
  group by
    job_id
  order by
    avg(salary) ASC)
where
  rownum <= 3;
  
--23--
select
  'Departamentul ' || d.department_name || ' este condus de ' || nvl(to_char(d.manager_id), 'nimeni') || ' si ' || decode(count(e.employee_id), 0, 'nu are salariati', 'are ' || count(e.employee_id) || ' salariati')
from
  departments d
left outer join
  employees e on (e.department_id = d.department_id)
group by
  department_name,
  d.manager_id;
  
--24--
select
  first_name,
  last_name,
  length(last_name)
from
  employees
where
  first_name is not null
  and
  last_name is not null
  and
  length(first_name) != length(last_name)
union
select
  first_name,
  last_name,
  length(last_name)
from
  employees
where
  first_name is null
  or
  last_name is null;
  
--25--
select
  last_name,
  hire_date,
  salary,
  decode(to_char(hire_date, 'YYYY'),
          '1989', salary + salary * 20 / 100,
          '1990', salary + salary * 15 / 100,
          '1991', salary + salary * 10 / 100,
          salary)
from
  employees;
  
select
  last_name,
  hire_date,
  salary,
  case to_char(hire_date, 'YYYY')
    when '1989' then salary * 1.2
    when '1990' then salary * 1.15
    when '1991' then salary * 1.1
    else salary
  end
from
  employees;
  
--26--
select distinct
  job_id,
  case
    when job_id like ('S%') then (select
                                    sum(salary)
                                  from
                                    employees
                                  where
                                    job_id = e.job_id)
    when job_id in (select
                    job_id
                  from
                    employees
                  where
                    salary in (select
                                max(salary)
                              from
                                employees)) then (select
                                                    avg(salary)
                                                  from
                                                    employees)
    else (select
            min(salary)
          from
            employees)
  end "Calcul"
from employees e;