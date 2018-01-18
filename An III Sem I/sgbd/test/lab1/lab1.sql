SET SERVEROUTPUT ON;

-- ex3
BEGIN
  DBMS_OUTPUT.PUT_LINE('Invat PL/SQL');
END;
/

-- ex4
DECLARE
  v_dep departments.department_name%TYPE;
BEGIN
  SELECT department_name
  INTO v_dep
FROM
  employees e, departments d
  WHERE e.department_id=d.department_id
  GROUP BY department_name
  HAVING COUNT(*) = (SELECT MAX(COUNT(*))
                     FROM employees
                     GROUP BY department_id);
  DBMS_OUTPUT.PUT_LINE('Departamentul '|| v_dep);
END;
/

-- ex5
VARIABLE rezultat VARCHAR(25)
BEGIN
  SELECT department_name
  INTO :rezultat
FROM
  employees e, departments d
  WHERE e.department_id=d.department_id
  GROUP BY department_name
  HAVING COUNT(*) = (SELECT MAX(COUNT(*))
                     FROM employees
                     GROUP BY department_id);
  DBMS_OUTPUT.PUT_LINE('Departamentul '|| :rezultat);
END;
/
PRINT :rezultat;

-- ex6
DECLARE
  v_dep departments.department_name%TYPE;
  v_ang INT;
BEGIN
  SELECT department_name, COUNT(*)
  INTO v_dep, v_ang
FROM
  employees e, departments d
  WHERE e.department_id=d.department_id
  GROUP BY department_name
  HAVING COUNT(*) = (SELECT MAX(COUNT(*))
                     FROM employees
                     GROUP BY department_id);
  DBMS_OUTPUT.PUT_LINE('Departamentul '|| v_dep || ' si angajati ' || v_ang);
END;
/

-- ex8
SET VERIFY OFF;
DECLARE
  v_cod employees.employee_id%TYPE:=&p_cod;
  v_bonus NUMBER(8);
  v_salariu_anual NUMBER(8);
BEGIN
  SELECT salary*12 INTO v_salariu_anual
  FROM employees
  WHERE employee_id = v_cod;
  IF v_salariu_anual>=20001
    THEN v_bonus:=2000;
  ELSIF v_salariu_anual BETWEEN 10001 AND 20000
    THEN v_bonus:=1000;
  ELSE v_bonus:=500;
  END IF;
  DBMS_OUTPUT.PUT_LINE('Bonusul este ' || v_bonus);
END;
/
SET VERIFY ON;

DECLARE
  v_cod employees.employee_id%TYPE:=&p_cod;
  v_bonus NUMBER(8);
  v_salariu_anual NUMBER(8);
BEGIN
  SELECT salary*12 INTO v_salariu_anual
  FROM employees
  WHERE employee_id = v_cod;
  CASE WHEN v_salariu_anual>=20001
    THEN v_bonus:=2000;
  WHEN v_salariu_anual BETWEEN 10001 AND 20000
    THEN v_bonus:=1000;
  ELSE v_bonus:=500;
  END CASE;
  DBMS_OUTPUT.PUT_LINE('Bonusul este ' || v_bonus);
END;
/

-- ex9
DEFINE p_cod_sal= 200;
DEFINE p_cod_dept = 80;
DEFINE p_procent = 20;
-- UNDEFINE p_cod_sal;
DECLARE
  v_cod_sal emp_dho.employee_id%TYPE:= &p_cod_sal;
  v_cod_dept emp_dho.department_id%TYPE:= &p_cod_dept;
  v_procent NUMBER(8):=&p_procent;
BEGIN
  UPDATE emp_dho
  SET department_id = v_cod_dept,
      salary = salary + (salary* v_procent/100)
  WHERE employee_id= v_cod_sal;
  IF SQL%ROWCOUNT =0 THEN
    DBMS_OUTPUT.PUT_LINE('Nu exista un angajat cu acest cod');
  ELSE DBMS_OUTPUT.PUT_LINE('Actualizare realizata');
  END IF;
END;
/
ROLLBACK;

-- ex10
CREATE TABLE zile_cal(
  id NUMBER,
  data DATE,
  nume_zi VARCHAR2(20)
);

SELECT SYSDATE FROM DUAL;

DECLARE
  contor NUMBER(6) := 1;
  v_data DATE;
  maxim  NUMBER(2) := LAST_DAY(SYSDATE)-SYSDATE;
BEGIN
  LOOP
    v_data := sysdate+contor;
    INSERT INTO zile_cal VALUES(contor,v_data,TO_CHAR(v_data,'Day'));
    contor := contor + 1;
    EXIT WHEN contor > maxim;
  END LOOP;
END;
/

-- ex11
DECLARE
  contor NUMBER(6) := 1;
  v_data DATE;
  maxim NUMBER(2) := LAST_DAY(SYSDATE)-SYSDATE;
BEGIN
  WHILE contor <= maxim LOOP
    v_data := sysdate+contor;
    INSERT INTO zile_cal
    VALUES (contor,v_data,to_char(v_data,'Day'));
    contor := contor + 1;
  END LOOP;
END;
/

-- ex12
DECLARE
  v_data DATE;
  maxim NUMBER(2) := LAST_DAY(SYSDATE)-SYSDATE;
BEGIN
  FOR contor IN 1..maxim LOOP
    v_data := sysdate+contor;
    INSERT INTO zile_cal
    VALUES (contor,v_data,to_char(v_data,'Day'));
  END LOOP;
END;
/

-- ex13

-- var1
DECLARE
  i POSITIVE:=1;
  max_loop CONSTANT POSITIVE:=10;
BEGIN
  LOOP
    i:=i+1;
    IF i>max_loop THEN
      DBMS_OUTPUT.PUT_LINE('in loop i=' || i);
      GOTO urmator;
    END IF;
  END LOOP;
  <<urmator>>
  i:=1;
  DBMS_OUTPUT.PUT_LINE('dupa loop i=' || i);
END;
/

-- var2
DECLARE
  i POSITIVE:=1;
  max_loop CONSTANT POSITIVE:=10;
BEGIN
  LOOP
    i:=i+1;
    DBMS_OUTPUT.PUT_LINE('in loop i=' || i);
    EXIT WHEN i>max_loop;
  END LOOP;
  i:=1;
  DBMS_OUTPUT.PUT_LINE('dupa loop i=' || i);
END;
/

-- exercitii

-- ex1
DECLARE
  numar number(3):=100;
  mesaj1 varchar2(255):='text 1';
  mesaj2 varchar2(255):='text 2';
BEGIN
  DECLARE
    numar number(3):=1;
    mesaj1 varchar2(255):='text 2';
    mesaj2 varchar2(255):='text 3';
  BEGIN
    numar:=numar+1;
    mesaj2:=mesaj2||' adaugat in sub-bloc';
    DBMS_OUTPUT.PUT_LINE('Val numar subloc: ' || numar);
    DBMS_OUTPUT.PUT_LINE('Val mesaj1 subloc: ' || mesaj1);
    DBMS_OUTPUT.PUT_LINE('Val mesaj2 subloc: ' || mesaj2);
  END;
  numar:=numar+1;
  mesaj1:=mesaj1||' adaugat un blocul principal';
  mesaj2:=mesaj2||' adaugat in blocul principal';
  DBMS_OUTPUT.PUT_LINE('Val numar bloc: ' || numar);
  DBMS_OUTPUT.PUT_LINE('Val mesaj1 bloc: ' || mesaj1);
  DBMS_OUTPUT.PUT_LINE('Val mesaj2 bloc: ' || mesaj2);
END;
/

-- ex2
CREATE TABLE octombrie_dho (
  id NUMBER,
  data DATE
);
DECLARE
  contor NUMBER(6) := 0;
  v_data DATE;
  first_date DATE := TO_DATE('2017-10-01', 'YYYY-MM-DD');
  maxim NUMBER(2) := 30;
BEGIN
  LOOP
    v_data := first_date + contor;
    contor := contor + 1;
    INSERT INTO octombrie_dho VALUES (contor, v_data );
    EXIT WHEN contor > maxim;
  END LOOP;
END;
/

-- a
SELECT oct.data, count (rr.book_date) numar_imprumuturi
FROM rental rr
RIGHT JOIN octombrie_dho oct ON(to_char(rr.book_date, 'dd/mm/yyyy') = to_char(oct.data, 'dd/mm/yyyy'))
GROUP BY oct.data;

-- b
declare
  zi_din_luna date := '01-oct-2017';
  cate_imprumuturi number(3);
begin
  for i in 1..31 loop
    select count(*)
    into cate_imprumuturi
    from rental
    where to_char(book_date, 'dd/mm/yyyy') = to_char(zi_din_luna, 'dd/mm/yyyy');
    
    dbms_output.put_line('In ziua ' || zi_din_luna || ' au fost imprumutate ' || cate_imprumuturi);
    zi_din_luna := zi_din_luna + 1;
  end loop;
end;
/


-- ex3
DECLARE
  nume member.last_name%TYPE := '&v_subs';
  cati number(2);
  cate_imprumuturi number(3);
BEGIN
  SELECT COUNT(*)
  INTO cati
  FROM member
  WHERE upper(last_name) = upper(nume);

  if cati > 1 then
    dbms_output.put_line('Sunt mai mult');
  elsif cati = 0 then
    dbms_output.put_line('Nu e niciunul!');
  else
    SELECT COUNT(unique(title_id))
    INTO cate_imprumuturi
    FROM member, rental
    WHERE upper(last_name) = upper(nume)
          AND
          member.member_id = rental.member_id;

    dbms_output.put_line('Membrul ' || nume || ' a imprumutat ' ||
                         cate_imprumuturi || ' titluri.');
  end if;
END;
/

-- ex4
DECLARE
  nume member.last_name%TYPE := '&v_subs';
  cati number(2);
  cate_imprumuturi number(3);
  numar_titluri number(3);
BEGIN
  SELECT COUNT(*)
  INTO cati
  FROM member
  WHERE upper(last_name) = upper(nume);

  SELECT COUNT(*)
  INTO numar_titluri
  FROM title;

  if cati > 1 then
    dbms_output.put_line('Sunt mai mult');
  elsif cati = 0 then
    dbms_output.put_line('Nu e niciunul!');
  else
    SELECT COUNT(unique(title_id))
    INTO cate_imprumuturi
    FROM member, rental
    WHERE upper(last_name) = upper(nume)
          AND
          member.member_id = rental.member_id;

    dbms_output.put_line('Membrul ' || nume || ' a imprumutat ' ||
                         cate_imprumuturi || ' titluri.');
  end if;

  if cate_imprumuturi > numar_titluri * 75 / 100 then
    dbms_output.put_line('Categoria 1');
  elsif cate_imprumuturi > numar_titluri * 50 / 100 then
    dbms_output.put_line('Categoria 2');
  elsif cate_imprumuturi > numar_titluri * 25 / 100 then
    dbms_output.put_line('Categoria 3');
  else
    dbms_output.put_line('Categoria 4');
  end if;
END;
/

-- ex5
CREATE TABLE member_cal
AS SELECT *
FROM member;

ALTER TABLE member_cal
ADD discount NUMBER(2);

DECLARE
  nume member.last_name%TYPE := '&v_subs';
  cati number(2);
  cate_imprumuturi number(3);
  numar_titluri number(3);
BEGIN
  SELECT COUNT(*)
  INTO cati
  FROM member
  WHERE upper(last_name) = upper(nume);

  SELECT COUNT(*)
  INTO numar_titluri
  FROM title;

  if cati > 1 then
    dbms_output.put_line('Sunt mai mult');
  elsif cati = 0 then
    dbms_output.put_line('Nu e niciunul!');
  else
    SELECT COUNT(unique(title_id))
    INTO cate_imprumuturi
    FROM member, rental
    WHERE upper(last_name) = upper(nume)
          AND
          member.member_id = rental.member_id;

    dbms_output.put_line('Membrul ' || nume || ' a imprumutat ' ||
                         cate_imprumuturi || ' titluri.');
  end if;

  if cate_imprumuturi > numar_titluri * 75 / 100 then
    UPDATE member_cal
    SET discount = 10
    WHERE upper(last_name) = upper(nume);
  elsif cate_imprumuturi > numar_titluri * 50 / 100 then
    UPDATE member_cal
    SET discount = 5
    WHERE upper(last_name) = upper(nume);
  elsif cate_imprumuturi > numar_titluri * 25 / 100 then
    UPDATE member_cal
    SET discount = 3
    WHERE upper(last_name) = upper(nume);
  else
    UPDATE member_cal
    SET discount = 0
    WHERE upper(last_name) = upper(nume);
  end if;
END;
/

SELECT * FROM member_cal;
