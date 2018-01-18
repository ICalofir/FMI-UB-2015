--ex 1

create table info_dho(
  utilizator varchar2(40),
  data date,
  comanda varchar2(40),
  nr_linii number(2),
  eroare varchar2(200)
);

select * from info_dho;

--ex2

CREATE OR REPLACE FUNCTION f2_dho 
  (v_nume employees.last_name%TYPE DEFAULT 'Bell')
RETURN NUMBER IS
  salariu employees.salary%type;
  mesajErr varchar2(200);
  nrGasiti number(2);
BEGIN
  SELECT salary INTO salariu
  FROM employees
  WHERE last_name = v_nume;
  RETURN salariu;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    mesajErr := SQLERRM;
    insert into info_dho
    select user, sysdate, 'f2_dho', 0, mesajErr
    from dual;
    
    return 0;
    --RAISE_APPLICATION_ERROR(-20000, 'Nu exista angajati cu numele dat');
  WHEN TOO_MANY_ROWS THEN
    mesajErr := SQLERRM;
    select count(*)
    into nrGasiti
    from employees
    where last_name = v_nume;
    
    insert into info_dho
    select user, sysdate, 'f2_dho', nrGasiti, mesajErr
    from dual;
    
    return 0;
    --RAISE_APPLICATION_ERROR(-20001, 'Exista mai multi angajati cu numele dat');
  WHEN OTHERS THEN
    mesajErr := SQLERRM;
    select count(*)
    into nrGasiti
    from employees
    where last_name = v_nume;
    
    insert into info_dho
    select user, sysdate, 'f2_dho', nrGasiti, mesajErr
    from dual;
    
    return 0;
    --RAISE_APPLICATION_ERROR(-20002,'Alta eroare!');
END f2_dho;
/

declare
  sal employees.salary%type;
begin
  sal := f2_dho('King');
end;
/

select * from employees;
select * from info_dho;


--ex3

create or replace procedure pex3(oras locations.city%type)
is
  type rec is record(eid employees.employee_id%type,
                     fn employees.first_name%type,
                     ln employees.last_name%type);
  type colectie is table of rec;
  angajati colectie;
  mesajErr varchar2(200);
begin
  select employee_id, first_name, last_name
  bulk collect into angajati
  from(
    select e.employee_id, e.first_name, e.last_name, count(e.employee_id)
    from employees e join job_history j on(e.employee_id = j.employee_id)
                   join departments d on(e.department_id = d.department_id)
                   join locations l on(d.location_id = l.location_id)
    where upper(oras) = upper(l.city)
    group by e.first_name, e.last_name, e.employee_id
    having count(e.employee_id) = 2);
  
  for i in angajati.first..angajati.last loop
    dbms_output.put_line(angajati(i).eid ||' '|| angajati(i).fn || ' ' || angajati(i).ln);
  end loop;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    mesajErr := SQLERRM;
    dbms_output.put_line(mesajErr);
        
    --RAISE_APPLICATION_ERROR(-20000, 'Nu exista angajati cu numele dat');
  WHEN OTHERS THEN
    mesajErr := SQLERRM;
    dbms_output.put_line(mesajErr);

    --RAISE_APPLICATION_ERROR(-20002,'Alta eroare!');
end;
/

declare
  type orase_c is table of locations.city%type;
  orase orase_c;
begin
  select city
  bulk collect into orase
  from locations;
  
  for i in orase.first..orase.last loop
    dbms_output.put_line(orase(i));
    pex3(orase(i));
  end loop;
end;
/