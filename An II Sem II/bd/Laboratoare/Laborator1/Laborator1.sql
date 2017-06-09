--3--
desc employees;
desc jobs;

--4--
select * from employees;

--7--
select employee_id, last_name, job_id, hire_date from employees;

--8--
select employee_id as cod, last_name nume, job_id "cod job", hire_date "data angajarii" from employees;

--9--
select job_id from employees;
select distinct job_id from employees;

--10--
select last_name || ', ' || job_id "Angajat si titlu" from employees;

--11--
select employee_id || ', ' || first_name || ', ' || last_name || ', ' || email || ', ' || phone_number || ', ' || hire_date || ', ' || job_id || ', ' || salary || ', ' || commission_pct || ', ' || manager_id || ', ' || department_id "Informatii complete" from employees;

--12--
select last_name, salary from employees where salary > 2850;

--13--
select last_name, department_id from employees where employee_id = 104;

--14--
select last_name, salary from employees where salary < 1500 or salary > 2850;
select last_name, salary from employees where salary not between 1500 and 2850;

--15--
select last_name, job_id, hire_date from employees where hire_date between '20-FEB-1987' and '1-MAY-1989' order by hire_date;

--16--
select last_name, department_id from employees where department_id in (10, 30) order by last_name;
select last_name, department_id from employees where department_id = 10 or department_id = 30 order by last_name;

--17--
select last_name "Angajat", salary "Salariu lunar" from employees where salary > 1500 and department_id in (10, 30);

--18--
select sysdate from dual;
select to_char(sysdate, 'DD/MM/YYYY HH24:MI:SS-----SSSSS') "Data" from dual;

--19--
select last_name, hire_date from employees where hire_date like('%87%');
select last_name, hire_date from employees where to_char(hire_date, 'YYYY') = '1987';
select last_name, hire_date from employees where to_char(hire_date, 'YYYY') = 1987;

--20-
select last_name, job_id from employees where manager_id is NULL;

--21--
select last_name, salary, commission_pct from employees where commission_pct is not NULL order by salary DESC, commission_pct DESC;

--22--
select last_name, salary, commission_pct from employees order by salary DESC, commission_pct DESC;

--23--
select last_name from employees where lower(last_name) like ('__a%');

--24--
select last_name from employees where lower(last_name) like ('%l%l%') and (department_id = 30 or manager_id = 102);

--25--
select last_name, job_id, salary from employees where (job_id like ('%CLERK%') or job_id like ('%REP%')) and salary not in (1000, 2000, 3000);

--26--
select department_id from employees where manager_id is NULL;