-- pentru functii
CREATE OR REPLACE FUNCTION f2_nmcc(
    v_nume employees.last_name%TYPE DEFAULT 'Bell' )
  RETURN NUMBER
IS
  salariu employees.salary%type;
  catelinii NUMBER;
  eroare    VARCHAR2(200);
BEGIN
  SELECT salary,
    COUNT(*)
  INTO salariu,
    catelinii
  FROM employees
  WHERE last_name = v_nume
  GROUP BY salary;
  -- inseram informatiile in cazul in care nu avem erori
  INSERT INTO informatii
  SELECT USER, sysdate, 'f2_nmcc', catelinii, 'Nu s-au produs erori' FROM dual;
  RETURN salariu;
EXCEPTION
WHEN NO_DATA_FOUND THEN
  eroare := SQLERRM;
  INSERT INTO informatii
  SELECT USER, sysdate, 'f2_nmcc', 0, eroare FROM dual;
  --  RAISE_APPLICATION_ERROR(-20000, 'Nu exista angajati cu numele dat');
  RETURN salariu;
WHEN TOO_MANY_ROWS THEN
  SELECT COUNT(*) INTO catelinii FROM employees WHERE LAST_NAME = v_nume;
  eroare := SQLERRM;
  INSERT INTO informatii
  SELECT USER, sysdate, 'f2_nmcc', catelinii, eroare FROM dual;
  --  RAISE_APPLICATION_ERROR(-20001, 'Exista mai multi angajati cu numele dat');
  RETURN salariu;
WHEN OTHERS THEN
  SELECT COUNT(*) INTO catelinii FROM employees WHERE LAST_NAME = v_nume;
  INSERT INTO informatii
  SELECT USER, sysdate, 'f2_nmcc', catelinii, 'Nu s-au produs erori' FROM dual;
  -- RAISE_APPLICATION_ERROR(-20002,'Alta eroare!');
  RETURN salariu;
END f2_nmcc;
/
BEGIN
  DBMS_OUTPUT.PUT_LINE('Salariul este '|| f2_nmcc('some'));-- 'king'
END;
/
SELECT * FROM informatii;
-- pentru proceduri
CREATE OR REPLACE PROCEDURE p4_nmcc(
      v_nume employees.last_name%TYPE)
  IS
    salariu employees.salary%TYPE;
    catelinii NUMBER;
    eroare    VARCHAR2(200);
  BEGIN
    SELECT salary,
      COUNT(*)
    INTO salariu,
      catelinii
    FROM employees
    WHERE last_name = v_nume
    GROUP BY salary;
    DBMS_OUTPUT.PUT_LINE('Salariul este '|| salariu);
    -- inseram informatiile in cazul in care nu avem erori
    INSERT INTO informatii
    SELECT USER, sysdate, 'p4_nmcc', catelinii, 'Nu s-au produs erori' FROM dual;
  EXCEPTION
  WHEN NO_DATA_FOUND THEN
    eroare := SQLERRM;
    INSERT INTO informatii
    SELECT USER, sysdate, 'p4_nmcc', 0, eroare FROM dual;
    --  RAISE_APPLICATION_ERROR(-20000, 'Nu exista angajati cu numele dat');
  WHEN TOO_MANY_ROWS THEN
    eroare := SQLERRM;
    SELECT COUNT(*) INTO catelinii FROM employees WHERE LAST_NAME = v_nume;
    INSERT INTO informatii
    SELECT USER, sysdate, 'p4_nmcc', catelinii, eroare FROM dual;
    --  RAISE_APPLICATION_ERROR(-20001, 'Exista mai multi angajati cu numele dat');
  WHEN OTHERS THEN
    eroare := SQLERRM;
    SELECT COUNT(*) INTO catelinii FROM employees WHERE LAST_NAME = v_nume;
    INSERT INTO informatii
    SELECT USER, sysdate, 'p4_nmcc', catelinii, eroare FROM dual;
    --  RAISE_APPLICATION_ERROR(-20002,'Alta eroare!');
  END p4_nmcc;
/
BEGIN
  p4_nmcc(initcap('king'));-- 'king'
END;
/
SELECT * FROM informatii;
/
-- ex3 
CREATE OR REPLACE FUNCTION fang(
    oras LOCATIONS.CITY%type)
  RETURN NUMBER
AS
  nr NUMBER(3) := 0;
  ok NUMBER(2) := 0;
BEGIN
  -- exista orasul?
  SELECT COUNT(*) INTO ok FROM locations WHERE CITY = oras;
  IF ok <> 0 THEN
    SELECT COUNT(*)
    INTO nr
    FROM
      (SELECT first_name,
        last_name
      FROM employees,
        locations,
        departments
      WHERE EMPLOYEES.DEPARTMENT_ID = DEPARTMENTS.DEPARTMENT_ID
      AND DEPARTMENTS.LOCATION_ID   = LOCATIONS.LOCATION_ID
      AND LOCATIONS.CITY            = oras
      INTERSECT
      SELECT first_name,
        last_name
      FROM employees ,
        job_history
      WHERE EMPLOYEES.EMPLOYEE_ID = JOB_HISTORY.EMPLOYEE_ID
      );
    IF nr = 0 THEN
      INSERT INTO informatii
      SELECT USER, sysdate, 'p4_nmcc', nr, 'nu exista angajati' FROM dual;
    ELSE
      INSERT INTO informatii
      SELECT USER, sysdate, 'p4_nmcc', nr, 'nu a fost eroare' FROM dual;
    END IF;
  ELSE
    INSERT INTO informatii
    SELECT USER, sysdate, 'p4_nmcc', ok, 'nu exista orasul dat' FROM dual;
  END IF;
RETURN nr;
END fang;
/
BEGIN
  DBMS_OUTPUT.PUT_LINE(fang('asd'));-- 'king'
END;
/
SELECT * FROM informatii;



-- ex4
CREATE OR REPLACE type tipcolectie IS   TABLE OF varchar2(200);
  /
  -------
CREATE OR REPLACE FUNCTION functiecolectie(   emp employees.employee_id%type)
  RETURN tipcolectie 
AS
  colectie_emp tipcolectie := tipcolectie();
  nr number(2);
BEGIN
  SELECT count(*)
  INTO nr
  FROM employees
  WHERE manager_id = emp;
  dbms_output.put_line(nr);
if nr <> 0 then
      SELECT EMPLOYEE_ID bulk collect
      INTO colectie_emp
      FROM employees
      WHERE manager_id = emp;
      dbms_output.put_line('sda');
      RETURN colectie_emp;
else
    colectie_emp.extend; colectie_emp(1):=0;
    dbms_output.put_line('here');    
    return colectie_emp;
end if;
END functiecolectie;
/
-------
CREATE OR REPLACE PROCEDURE pmarire(
      cod_manager employees.manager_id%type)
  AS
    colectie_emp tipcolectie := tipcolectie();
  BEGIN
    colectie_emp := functiecolectie(cod_manager);
    if colectie_emp(1) <> 0 then 
              dbms_output.put_line('ok');
              
              for i in colectie_emp.first..colectie_emp.last loop
                dbms_output.put_line(colectie_emp(i));
                dbms_output.put_line('recurs');
                UPDATE employees  SET salary = salary+1 WHERE employee_id = colectie_emp(i);
                pmarire(colectie_emp(i));
              end loop;
    end if;
  END pmarire;
/
SELECT * FROM employees;

begin
  pmarire(100);
end;
/

rollback;

-- ex 5
create or replace procedure pex5
as
    type rec is record(dptname varchar2(200), hired varchar2(50), cate number(3));
    type tp is table of rec;
    dept tp := tp();
    
    type recf is record(nume varchar2(200), vechime number(3), salariu number(10));
    type tpf is table of recf;
    varfin tpf := tpf();
begin
      select d.DEPARTMENT_NAME dep, to_char(e.hire_date, 'day') days, count(to_char(e.hire_date, 'day')) asd
      bulk collect into dept
      FROM DEPARTMENTS d, employees e
      where e.department_id = d.department_id
      group by d.department_name, to_char(e.hire_date, 'day'), d.department_id
      having
           count(to_char(e.hire_date, 'day')) = 
                                                (select max(count(to_char(ee.hire_date, 'day'))) 
                                                from employees ee
                                                where ee.department_id = d.department_id
                                                group by to_char(ee.hire_date, 'day'), ee.department_id, d.department_name)
      order by dep;
  for i in dept.first..dept.last loop
    select first_name,  round(round(sysdate - hire_date)/365), e.salary+(e.salary*nvl(e.commission_pct,1))
    bulk collect into varfin
    from employees e, departments dpp
    where to_char(hire_date, 'day') = dept(i).hired
    and e.department_id = dpp.department_id
    and dpp.department_name = dept(i).dptname;
    dbms_output.put_line('.........................');
    dbms_output.put_line(dept(i).dptname || '      '||dept(i).hired || '      ' || dept(i).cate);
    dbms_output.put_line('.........................');
    for ind in varfin.first..varfin.last loop
      dbms_output.put_line(ind||' '||varfin(ind).nume|| '   ' || varfin(ind).salariu||'   '||varfin(ind).vechime);
    end loop;
  end loop;

end pex5;
/

begin
  pex5;
end;
/


--ex6

create or replace procedure pex6
as
    type rec is record(dptname varchar2(200), hired varchar2(50), cate number(3));
    type tp is table of rec;
    dept tp := tp();
    
    type recf is record(nume varchar2(200), vechime number(3), salariu number(10));
    type tpf is table of recf;
    varfin tpf := tpf();
    
    var1 number(2);
    var2 number(2);
begin
      select d.DEPARTMENT_NAME dep, to_char(e.hire_date, 'day') days, count(to_char(e.hire_date, 'day')) asd
      bulk collect into dept
      FROM DEPARTMENTS d, employees e
      where e.department_id = d.department_id
      group by d.department_name, to_char(e.hire_date, 'day'), d.department_id
      having
           count(to_char(e.hire_date, 'day')) = 
                                                (select max(count(to_char(ee.hire_date, 'day'))) 
                                                from employees ee
                                                where ee.department_id = d.department_id
                                                group by to_char(ee.hire_date, 'day'), ee.department_id, d.department_name)
      order by dep;
  for i in dept.first..dept.last loop
    select first_name,  round(round(sysdate - hire_date)/365) vechime, e.salary+(e.salary*nvl(e.commission_pct,1))
    bulk collect into varfin
    from employees e, departments dpp
    where to_char(hire_date, 'day') = dept(i).hired
    and e.department_id = dpp.department_id
    and dpp.department_name = dept(i).dptname
    order by vechime desc;
    dbms_output.put_line('.........................');
    dbms_output.put_line(dept(i).dptname || '      '||dept(i).hired || '      ' || dept(i).cate);
    dbms_output.put_line('.........................');
    var1 := 1;
    var2 := varfin(1).vechime;
    for ind in varfin.first..varfin.last loop
      if var2 <> varfin(ind).vechime then
        var2 :=   varfin(ind).vechime;
        var1 := var1 + 1;
      end if;
      dbms_output.put_line(var1||' '||varfin(ind).nume|| '   ' || varfin(ind).salariu||'   '||varfin(ind).vechime);
    end loop;
  end loop;

end pex6;
/

begin
  pex6;
end;
/