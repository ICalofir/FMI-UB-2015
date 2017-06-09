--1--
select e.last_name, to_char(e.hire_date, 'MON'), to_char(e.hire_date, 'YYYY') from employees e, employees g where lower(g.last_name) = 'gates' and e.department_id = g.department_id and lower(e.last_name) like ('%a%') and lower(e.last_name) != 'gates';

select
  e.last_name,
  to_char(e.hire_date,'MONTH'),
  to_char(e.hire_date, 'YYYY')
from
  employees e
join
  employees g on (e.department_id = g.department_id)
where
  lower(e.last_name) like ('%a%')
  and
  lower(e.last_name) != 'gates'
  and
  lower(g.last_name) = 'gates';
  
--2--
select distinct
  e.employee_id,
  e.last_name,
  d.department_id,
  d.department_name
from
  employees e
join
  employees a on (e.department_id = a.department_id)
join
  departments d on (e.department_id = d.department_id)
where
  lower(a.last_name) like ('%t%')
order by
  e.last_name;
  
--3--
select
  e.last_name,
  e.salary,
  j.job_title,
  l.city,
  c.country_name
from
  employees e
join
  employees k on (e.manager_id = k.employee_id)
left outer join
  jobs j on (e.job_id = j.job_id)
left outer join
  departments d on (e.department_id = d.department_id)
left outer join
  locations l on (d.location_id = l.location_id)
left outer join
  countries c on (l.country_id = c.country_id)
where
  lower(k.last_name) like ('king');
  
--4--
select
  e.department_id,
  e.last_name,
  j.job_title,
  d.department_name,
  to_char(salary, '$99,999.00') "Salariu"
from
  employees e
join
  jobs j on (e.job_id = j.job_id)
join
  departments d on (e.department_id = d.department_id)
where
  lower(d.department_name) like ('%ti%')
order by
  d.department_name ASC,
  e.last_name;
  
--5--
select
  e.last_name,
  e.department_id,
  d.department_name,
  l.city,
  j.job_title
from
  employees e
join
  jobs j on (e.job_id = j.job_id)
join
  departments d on (e.department_id = d.department_id)
join
  locations l on (d.location_id = l.location_id)
where
  lower(l.city) like ('oxford');
  
--6--
select distinct
  e.employee_id,
  e.last_name,
  e.salary
from
  employees e
join
  employees a on (e.department_id = a.department_id)
join
  departments d on (e.department_id = d.department_id)
join
  jobs j on (e.job_id = j.job_id)
where
  lower(a.last_name) like ('%t%')
  and
  e.salary > (j.min_salary + j.max_salary) / 2;
  
--7--
select
  e.last_name,
  d.department_name
from
  employees e
left outer join
  departments d on (e.department_id = d.department_id);
  
select
  e.last_name,
  d.department_name
from
  departments d
right outer join
  employees e on (e.department_id = e.department_id);
  
--9--
select
  e.last_name,
  d.department_name
from
  departments d
left outer join
  employees e on (d.department_id = e.department_id);
  
select
  e.last_name,
  d.department_name
from
  employees e
right outer join
  departments d on (e.department_id = d.department_id);
  
--10--
select distinct
  e.last_name,
  d.department_name
from
  employees e
full outer join
  departments d on (e.department_id = d.department_id);
  
select
  e.last_name,
  d.department_name
from
 employees e
left outer join
  departments d on (e.department_id = d.department_id)
union
select
  e.last_name,
  d.department_name
from
 employees e
right outer join
  departments d on (e.department_id = d.department_id);
  
--11--
select
  d.department_id
from
  departments d
where 
  lower(d.department_name) like ('%re%')
union
select
  e.department_id
from
  employees e
where
  upper(e.job_id) = 'SA_REP';

--12--
select
  d.department_id
from
  departments d
where 
  lower(d.department_name) like ('%re%')
union all
select
  e.department_id
from
  employees e
where
  e.job_id = 'SA_REP';
  
--13--
select
  d.department_id
from
  departments d
minus
select
  e.department_id
from
  employees e;
  
select
  d.department_id
from
  departments d
where
 d.department_id not in (select
                          nvl(e.department_id, 0)
                         from
                          employees e);
                          
--14--
select
  d.department_id
from
  departments d
where
  lower(d.department_name) like ('%re%')
intersect
select
  e.department_id
from
  employees e
where
  upper(e.job_id) = 'HR_REP';
  
--15--
select
  e.employee_id,
  e.job_id,
  e.last_name
from
  employees e
where
  e.salary > 3000
union
select
  e.employee_id,
  e.job_id,
  e.last_name
from
  employees e
join
  jobs j on (e.job_id = j.job_id)
where
  e.salary = (j.min_salary + j.max_salary) / 2;
  
--16--
select
  last_name,
  hire_date
from
  employees
where hire_date > (select
                    hire_date
                   from
                    employees
                   where
                    lower(last_name) = 'gates');
                    
select
  e.last_name,
  e.hire_date
from
  employees e
cross join
  employees g
where
  e.hire_date > g.hire_date
  and
  lower(g.last_name) = 'gates';
  
--17--
select
  last_name,
  salary
from
  employees
where
  department_id in (select
                      department_id
                    from
                      employees
                    where
                      lower(last_name) = 'gates')
  and
  lower(last_name) <> 'gates';
  
--18--
select
  last_name,
  salary
from
  employees
where
  manager_id in (select
                  employee_id
                from
                  employees
                where
                  manager_id is null);
                  
--19--
select
  last_name,
  department_id,
  salary
from
  employees e
where
  department_id in (select
                      department_id
                    from
                      employees ee
                    where
                      commission_pct is not null
                      and
                      e.last_name <> ee.last_name)
  and
  salary in (select
              salary
            from
              employees ee
            where
              commission_pct is not null
              and
              e.last_name <> ee.last_name);
              
select
  last_name,
  department_id,
  salary
from
  employees e
where
  (department_id, salary) in (select
                                department_id,
                                salary
                              from
                                employees ee
                              where
                                commission_pct is not null
                                and
                                e.last_name <> ee.last_name);
                                
--20--
select
  employee_id,
  salary,
  last_name
from
  employees e
where
  salary > (select
              (min_salary + max_salary) / 2
            from
              jobs
            where
              e.job_id = job_id)
  and
  department_id in (select
                      department_id
                    from
                      employees
                    where
                      lower(last_name) like ('%t%'));
                      
--21--
select
  last_name
from
  employees
where
  salary > (select
              max(salary)
            from
              employees
            where
              lower(job_id) like ('%clerk%'));

select
  last_name
from
  employees
where
  salary > all(select
                salary
              from
                employees
              where
                lower(job_id) like ('%clerk%'));
                
select
  last_name
from
  employees
where
  salary > any(select
                salary
              from
                employees
              where
                lower(job_id) like ('%clerk%'));
                
--22--
select
  e.last_name,
  d.department_name,
  e.salary
from
  employees e
join
  departments d on (e.department_id = d.department_id)
where
  e.commission_pct is null
  and
  e.manager_id in (select
                    employee_id
                  from
                    employees
                  where
                    commission_pct is not null);
                    
--23--
select
  e.last_name,
  e.salary,
  d.department_name,
  j.job_title
from
  employees e
join
  departments d on (e.department_id = d.department_id)
join
  jobs j on (e.job_id = j.job_id)
where
  (salary, nvl(commission_pct, -1)) in (select
                                          salary,
                                          nvl(commission_pct, -1)
                                        from
                                          employees
                                        where
                                          department_id = (select
                                                            department_id
                                                          from
                                                            departments
                                                          where
                                                            location_id = (select
                                                                            location_id
                                                                          from
                                                                            locations
                                                                          where
                                                                            lower(city) like ('oxford'))));
                                                                            
--24--
select
  last_name,
  department_id,
  job_id
from
  employees
where
  department_id = (select
                    department_id
                  from
                    departments
                  where
                    location_id = (select
                                    location_id
                                  from
                                    locations
                                  where
                                    lower(city) like ('toronto')));