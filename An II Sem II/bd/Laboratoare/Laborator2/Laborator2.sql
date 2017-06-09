--1--
select concat(concat(last_name, ' '), first_name) || ' castiga ' || salary || ' lunar, dar doreste ' || 3 * salary "Salariu ideal" from employees;

--2--
select initcap(first_name), upper(last_name), length(last_name) from employees where last_name like ('J%') or last_name like ('M%') or upper(last_name) like ('__A%') order by length(last_name) DESC;
select initcap(first_name), upper(last_name), length(last_name) from employees where substr(last_name, 1, 1) = 'J' or substr(last_name, 1, 1) = 'M' or upper(substr(last_name, 3, 1)) = 'A' order by length(last_name) DESC;
select initcap(first_name), upper(last_name), length(last_name) from employees where substr(last_name, 1, 1) in ('J', 'M') or upper(substr(last_name, 3, 1)) = 'A' order by length(last_name) DESC;

--3--
select employee_id, last_name from employees where trim(both from upper(first_name)) = 'STEVEN';

--4--
select employee_id "Cod", last_name "Nume", length(last_name) "Lungimea numelui", instr(lower(last_name), 'a') "Pozitia a" from employees where last_name like ('%e');

--5--
select employees.*, to_char(hire_date, 'day') from employees where mod(round(sysdate - hire_date), 7) = 0;

--6--
select employee_id, first_name, salary, round(salary * 1.15, 2) "Salariu nou", round(salary * 1.15 / 100, 2) "Numar sute" from employees where mod(salary, 1000) != 0;

--7--
select last_name as "Nume angajat", rpad(to_char(hire_date), 20, ' ') from employees where commission_pct is not null;

--8--
select to_char(sysdate + 30, 'MONTH DD YYYY HH24:MI:SS') "Data" from dual;

--9--
select to_number(to_date(concat('31-DEC-', to_char(sysdate, 'YYYY')), 'DD-MON-YYYY') - trunc(sysdate)) "Zile pana la sfarsitul anului" from dual;

--10--
select to_char(sysdate + 12/24, 'DD/MM HH24:MI:SS') "Data" from dual;
select to_char(sysdate + 5/(60 * 24), 'DD/MM HH24:MI:SS') "Data" from dual;

--11--
select last_name || ' ' || first_name "Nume si prenume", hire_date, next_day(add_months(hire_date, 6), 'Monday') from employees;

--12--
select last_name, round(months_between(sysdate, hire_date)) "Luni lucrate" from employees order by months_between(sysdate, hire_date) ASC;
select last_name, round(months_between(sysdate, hire_date)) "Luni lucrate" from employees order by "Luni lucrate" ASC;
select last_name, round(months_between(sysdate, hire_date)) "Luni lucrate" from employees order by 2 ASC;

--13--
select last_name, hire_date, to_char(hire_date, 'DAY') "Zi" from employees order by to_char(hire_date - 1, 'D');

--14--
select last_name, nvl(to_char(commission_pct), 'Fara comision') "Comision" from employees;

--15--
select last_name, salary, commission_pct, salary + salary * nvl(commission_pct, 0) venit_lunar from employees where salary + salary * nvl(commission_pct, 0) > 10000;

--16--
select
  last_name,
  job_id,
  salary,
  decode(job_id,
         'IT_PROG', salary * 1.2,
         'SA_REP', salary * 1.25,
         'SA_MAN', salary * 1.35,
         salary) "Salariu renegociat"
from
  employees;
    

select
  last_name,
  job_id,
  salary,
  case job_id
    when 'IT_PROG' then salary * 1.2
    when 'SA_REP' then salary * 1.25
    when 'SA_MAN' then salary * 1.35
    else salary
  end "Salariu renegociat"
from
  employees;

--17--
select e.last_name, e.department_id, d.department_name from employees e, departments d where e.department_id = d.department_id;

--18--
select distinct e.job_id, j.job_id, j.job_title from jobs j, employees e where e.job_id = j.job_id and e.department_id = 30;

--19--
select e.last_name, d.department_name, l.city from employees e, departments d, locations l where e.department_id = d.department_id and d.location_id = l.location_id and e.commission_pct is not null;

--20--
select e.last_name, d.department_name from employees e, departments d where e.department_id = d.department_id and lower(e.last_name) like ('%a%');

--21--
select e.last_name, j.job_title, d.department_name from employees e, departments d, jobs j, locations l where e.department_id = d.department_id and e.job_id = j.job_id and d.location_id = l.location_id and l.city = 'Oxford';

--22--
select e.employee_id Ang#, e.last_name Angajat, e.manager_id Mgr#, m.last_name Manager from employees e, employees m where e.manager_id = m.employee_id;

--23--
select e.employee_id Ang#, e.last_name Angajat, e.manager_id Mgr#, m.last_name Manager from employees e, employees m where e.manager_id = m.employee_id(+);

--24--
select e.last_name, e.department_id, c.last_name "Coleg" from employees e, employees c where e.department_id = c.department_id and e.employee_id != c.employee_id order by 2 ASC, 1 ASC, 3 ASC;

--25--
select e.last_name, e.job_id, e.salary, j.job_title, d.department_name from employees e, jobs j, departments d where e.job_id = j.job_id and e.department_id = d.department_id(+);

--26--
select e.last_name, e.hire_date from employees e, employees g where lower(g.last_name) = 'gates' and e.hire_date > g.hire_date;

--27--
select e.last_name Angajat, e.hire_date Data_ang, m.last_name Manager, m.hire_date Data_mgr from employees e, employees m where e.manager_id = m.employee_id and e.hire_date < m.hire_date;