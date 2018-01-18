SET SERVEROUTPUT ON;

-- ex1
DECLARE
  x NUMBER(1) := 5;
  y x%TYPE := NULL;
BEGIN
  IF x <> y THEN
    DBMS_OUTPUT.PUT_LINE ('valoare <> null este = true');
  ELSE
    DBMS_OUTPUT.PUT_LINE ('valoare <> null este != true');
  END IF;
  x := NULL;
  IF x = y THEN
    DBMS_OUTPUT.PUT_LINE ('null = null este = true');
  ELSE
    DBMS_OUTPUT.PUT_LINE ('null = null este != true');
  END IF;
END;
/

-- ex2

-- a
DECLARE
  TYPE emp_record IS RECORD
        (cod employees.employee_id%TYPE,
         salariu employees.salary%TYPE,
         job employees.job_id%TYPE);
  v_ang emp_record;
BEGIN
  v_ang.cod:=700;
  v_ang.salariu:= 9000;
  v_ang.job:='SA_MAN';
  DBMS_OUTPUT.PUT_LINE ('Angajatul cu codul '|| v_ang.cod ||
    ' si jobul ' || v_ang.job || ' are salariul ' || v_ang.salariu);
END;
/

-- b
DECLARE
  TYPE emp_record IS RECORD
        (cod employees.employee_id%TYPE,
         salariu employees.salary%TYPE,
         job employees.job_id%TYPE);
  v_ang emp_record;
BEGIN
  SELECT employee_id, salary, job_id
  INTO v_ang
  FROM employees
  WHERE employee_id = 101;
  DBMS_OUTPUT.PUT_LINE ('Angajatul cu codul '|| v_ang.cod ||
      ' si jobul ' || v_ang.job || ' are salariul ' || v_ang.salariu);
END;
/

-- c
DECLARE
  TYPE emp_record IS RECORD
        (cod employees.employee_id%TYPE,
         salariu employees.salary%TYPE,
         job employees.job_id%TYPE);
  v_ang emp_record;
BEGIN
  DELETE FROM emp_***
  WHERE employee_id=100
  RETURNING employee_id, salary, job_id INTO v_ang;
  DBMS_OUTPUT.PUT_LINE ('Angajatul cu codul '|| v_ang.cod ||
      ' si jobul ' || v_ang.job || ' are salariul ' || v_ang.salariu);
END;
/
ROLLBACK;

-- ex3
DECLARE
  v_ang1 employees%ROWTYPE;
  v_ang2 employees%ROWTYPE;
BEGIN
  -- sterg angajat 100 si mentin in variabila linia stearsa
  DELETE FROM emp_dho
  WHERE employee_id = 102
  RETURNING employee_id, first_name, last_name, email, phone_number,
            hire_date, job_id, salary, commission_pct, manager_id,
            department_id
  INTO v_ang1;
  -- inserez in tabel linia stearsa
  INSERT INTO emp_dho
  VALUES v_ang1;
  -- sterg angajat 101
  DELETE FROM emp_dho
  WHERE employee_id = 101;
  -- obtin datele din tabelul employees
  SELECT *
  INTO v_ang2
  FROM employees
  WHERE employee_id = 101;
  -- inserez o linie oarecare in emp_***
  INSERT INTO emp_dho
  VALUES(1000,'FN','LN','E',null,sysdate, ' AD_VP',1000, null,100,90);
  -- modific linia adaugata anterior cu valorile variabilei v_ang2
  UPDATE emp_dho
  SET ROW = v_ang2
  WHERE employee_id = 1000;
END;
/

-- ex4
DECLARE
  TYPE tablou_indexat IS TABLE OF NUMBER INDEX BY BINARY_INTEGER;
  t tablou_indexat;
BEGIN
-- punctul a
  FOR i IN 1..10 LOOP
    t(i):=i;
  END LOOP;
  DBMS_OUTPUT.PUT('Tabloul are ' || t.COUNT ||' elemente: ');
  FOR i IN t.FIRST..t.LAST LOOP
    DBMS_OUTPUT.PUT(t(i) || ' ');
  END LOOP;
  DBMS_OUTPUT.NEW_LINE;
-- punctul b
  FOR i IN 1..10 LOOP
    IF i mod 2 = 1 THEN
      t(i):=null;
    END IF;
  END LOOP;
  DBMS_OUTPUT.PUT('Tabloul are ' || t.COUNT ||' elemente: ');
  FOR i IN t.FIRST..t.LAST LOOP
    DBMS_OUTPUT.PUT(nvl(t(i), 0) || ' ');
  END LOOP;
  DBMS_OUTPUT.NEW_LINE;
-- punctul c
  t.DELETE(t.first);
  t.DELETE(5,7);
  t.DELETE(t.last);
  DBMS_OUTPUT.PUT_LINE('Primul element are indicele ' || t.first ||
      ' si valoarea ' || nvl(t(t.first),0));
  DBMS_OUTPUT.PUT_LINE('Ultimul element are indicele ' || t.last ||
    ' si valoarea ' || nvl(t(t.last),0));
  DBMS_OUTPUT.PUT('Tabloul are ' || t.COUNT ||' elemente: ');
  FOR i IN t.FIRST..t.LAST LOOP
    IF t.EXISTS(i) THEN
      DBMS_OUTPUT.PUT(nvl(t(i), 0)|| ' ');
    END IF;
  END LOOP;
  DBMS_OUTPUT.NEW_LINE;
-- punctul d
  t.delete;
  DBMS_OUTPUT.PUT_LINE('Tabloul are ' || t.COUNT ||' elemente.');
END;
/

-- ex5
DECLARE
  TYPE tablou_indexat IS TABLE OF emp_dho%ROWTYPE INDEX BY BINARY_INTEGER;
  t tablou_indexat;
BEGIN
  -- stergere din tabel si salvare in tablou
  DELETE FROM emp_dho
  WHERE ROWNUM<= 2
  RETURNING employee_id, first_name, last_name, email, phone_number,
            hire_date, job_id, salary, commission_pct, manager_id,
            department_id
  BULK COLLECT INTO t;
  --afisare elemente tablou
  DBMS_OUTPUT.PUT_LINE (t(1).employee_id ||' ' || t(1).last_name);
  DBMS_OUTPUT.PUT_LINE (t(2).employee_id ||' ' || t(2).last_name);
  --inserare cele 2 linii in tabel
  INSERT INTO emp_dho VALUES t(1);
  INSERT INTO emp_dho VALUES t(2);
END;
/

-- ex6
DECLARE
  TYPE tablou_imbricat IS TABLE OF NUMBER;
  t tablou_imbricat := tablou_imbricat();
BEGIN
  -- punctul a
  FOR i IN 1..10 LOOP
    t.extend; t(i):=i;
  END LOOP;
  DBMS_OUTPUT.PUT('Tabloul are ' || t.COUNT ||' elemente: ');
  FOR i IN t.FIRST..t.LAST LOOP
    DBMS_OUTPUT.PUT(t(i) || ' ');
  END LOOP;
  DBMS_OUTPUT.NEW_LINE;
-- punctul b
  FOR i IN 1..10 LOOP
    IF i mod 2 = 1 THEN t(i):=null;
    END IF;
  END LOOP;
  DBMS_OUTPUT.PUT('Tabloul are ' || t.COUNT ||' elemente: ');
  FOR i IN t.FIRST..t.LAST LOOP
    DBMS_OUTPUT.PUT(nvl(t(i), 0) || ' ');
  END LOOP;
  DBMS_OUTPUT.NEW_LINE;
-- punctul c
  t.DELETE(t.first);
  t.DELETE(5,7);
  t.DELETE(t.last);
  DBMS_OUTPUT.PUT_LINE('Primul element are indicele ' || t.first ||
    ' si valoarea ' || nvl(t(t.first),0));
  DBMS_OUTPUT.PUT_LINE('Ultimul element are indicele ' || t.last ||
    ' si valoarea ' || nvl(t(t.last),0));
  DBMS_OUTPUT.PUT('Tabloul are ' || t.COUNT ||' elemente: ');
  FOR i IN t.FIRST..t.LAST LOOP
    IF t.EXISTS(i) THEN
      DBMS_OUTPUT.PUT(nvl(t(i), 0)|| ' ');
    END IF;
  END LOOP;
  DBMS_OUTPUT.NEW_LINE;
-- punctul d
  t.delete;
  DBMS_OUTPUT.PUT_LINE('Tabloul are ' || t.COUNT ||' elemente.');
END;
/

-- ex7
DECLARE
  TYPE tablou_imbricat IS TABLE OF CHAR(1);
  t tablou_imbricat := tablou_imbricat('m', 'i', 'n', 'i', 'm');
  i INTEGER;
BEGIN
  i := t.FIRST;
  WHILE i <= t.LAST LOOP
    DBMS_OUTPUT.PUT(t(i));
    -- i := t.NEXT(i);
    i := i + 1;
  END LOOP;
  DBMS_OUTPUT.NEW_LINE;
  i := t.LAST;
  WHILE i >= t.FIRST LOOP
    DBMS_OUTPUT.PUT(t(i));
    i := t.PRIOR(i);
  END LOOP;
  DBMS_OUTPUT.NEW_LINE;
  t.delete(2);
  t.delete(4);
  i := t.FIRST;
  WHILE i <= t.LAST LOOP
    DBMS_OUTPUT.PUT(t(i));
    i := t.NEXT(i);
  END LOOP;
  DBMS_OUTPUT.NEW_LINE;
  i := t.LAST;
  WHILE i >= t.FIRST LOOP
    DBMS_OUTPUT.PUT(t(i));
    i := t.PRIOR(i);
  END LOOP;
  DBMS_OUTPUT.NEW_LINE;
END;
/

-- ex8
DECLARE
  TYPE vector IS VARRAY(10) OF NUMBER;
  t vector:= vector();
BEGIN
  -- punctul a
  FOR i IN 1..10 LOOP
    t.extend; t(i):=i;
  END LOOP;
  DBMS_OUTPUT.PUT('Tabloul are ' || t.COUNT ||' elemente: ');
  FOR i IN t.FIRST..t.LAST LOOP
    DBMS_OUTPUT.PUT(t(i) || ' ');
  END LOOP;
  DBMS_OUTPUT.NEW_LINE;
-- punctul b
  FOR i IN 1..10 LOOP
    IF i mod 2 = 1 THEN t(i):=null;
    END IF;
  END LOOP;
  DBMS_OUTPUT.PUT('Tabloul are ' || t.COUNT ||' elemente: ');
  FOR i IN t.FIRST..t.LAST LOOP
    DBMS_OUTPUT.PUT(nvl(t(i), 0) || ' ');
  END LOOP;
  DBMS_OUTPUT.NEW_LINE;
-- punctul c
-- metodele DELETE(n), DELETE(m,n) nu sunt valabile pentru vectori!!!
-- din vectori nu se pot sterge elemente individuale!!!
-- punctul d
  t.delete;
  DBMS_OUTPUT.PUT_LINE('Tabloul are ' || t.COUNT ||' elemente.');
END;
/

-- ex9
CREATE OR REPLACE TYPE subordonati_cal AS VARRAY(10) OF NUMBER(4);
/
CREATE TABLE manageri_cal (cod_mgr NUMBER(10),
                           nume VARCHAR2(20),
                           lista subordonati_cal);
DECLARE
  v_sub subordonati_cal:= subordonati_cal(100,200,300);
  v_lista manageri_cal.lista%TYPE;
BEGIN
  INSERT INTO manageri_cal
  VALUES (1, 'Mgr 1', v_sub);
  INSERT INTO manageri_cal
  VALUES (2, 'Mgr 2', null);
  INSERT INTO manageri_cal
  VALUES (3, 'Mgr 3', subordonati_cal(400,500));
  SELECT lista
  INTO v_lista
  FROM manageri_cal
  WHERE cod_mgr=1;
  FOR j IN v_lista.FIRST..v_lista.LAST loop
    DBMS_OUTPUT.PUT_LINE (v_lista(j));
  END LOOP;
END;
/
SELECT * FROM manageri_cal;
DROP TABLE manageri_cal;
DROP TYPE subordonati_cal;

-- ex10
CREATE TABLE emp_test_cal AS
        SELECT employee_id, last_name FROM employees
        WHERE ROWNUM <= 2;
CREATE OR REPLACE TYPE tip_telefon_cal IS TABLE OF VARCHAR(12);
/
ALTER TABLE emp_test_cal
ADD (telefon tip_telefon_cal)
NESTED TABLE telefon STORE AS tabel_telefon_cal;

INSERT INTO emp_test_cal
VALUES (500, 'XYZ',tip_telefon_cal('074XXX', '0213XXX', '037XXX'));

update emp_test_cal
SET telefon = tip_telefon_cal('073XXX', '0214XXX')
WHERE employee_id=100;

SELECT a.employee_id, b.*
FROM emp_test_cal a, TABLE (a.telefon) b;

DROP TABLE emp_test_cal;
DROP TYPE tip_telefon_cal;

-- ex11

-- var1
DECLARE
  TYPE tip_cod IS VARRAY(5) OF NUMBER(3);
  coduri tip_cod := tip_cod(205,206);
BEGIN
  FOR i IN coduri.FIRST..coduri.LAST LOOP
    DELETE FROM emp_dho
    WHERE employee_id = coduri (i);
  END LOOP;
END;
/

SELECT employee_id FROM emp_dho;
ROLLBACK;

-- var2
DECLARE
  TYPE tip_cod IS VARRAY(20) OF NUMBER;
  coduri tip_cod := tip_cod(205,206);
BEGIN
  FORALL i IN coduri.FIRST..coduri.LAST
    DELETE FROM emp_***
    WHERE employee_id = coduri (i);
  END;
/

SELECT employee_id FROM emp_***;
ROLLBACK;

-- exercitii

-- ex1
DECLARE
  type arr is VARRAY(5) of employees.employee_id%TYPE;
  vector arr := arr();
BEGIN
  SELECT employee_id
  BULK COLLECT INTO vector
  FROM employees
  WHERE rownum <= 5
  ORDER BY salary DESC;

  for i in vector.first..vector.last loop
    UPDATE emp_dho
    SET salary = salary * 0.5 + salary
    WHERE employee_id = vector(i);
  end loop;
END;
/

SELECT * from emp_dho
ORDER BY salary DESC;

-- ex2
CREATE OR REPLACE TYPE tip_orase_cal is TABLE of VARCHAR(20);
/

CREATE TABLE excursie_cal(
  cod_excursie NUMBER(4),
  denumire VARCHAR(20),
  orase tip_orase_cal,
  status varchar2(20)
)
NESTED TABLE orase STORE AS orase_cal;

-- a
BEGIN
  INSERT INTO excursie_cal VALUES(1, 'ex1',
      tip_orase_cal('Bucuresti', 'Severin'), 'disponibil');
  INSERT INTO excursie_cal VALUES(2, 'ex2',
      tip_orase_cal('Bucuresti', 'Severin'), 'disponibil');
  INSERT INTO excursie_cal VALUES(3, 'ex3',
      tip_orase_cal('Bucuresti', 'Severin'), 'disponibil');
  INSERT INTO excursie_cal VALUES(4, 'ex4',
      tip_orase_cal('Bucuresti', 'Severin'), 'disponibil');
  INSERT INTO excursie_cal VALUES(5, 'ex5',
      tip_orase_cal('Bucuresti', 'Severin'), 'disponibil');
END;
/
SELECT * FROM excursie_cal;

-- b
UPDATE excursie_cal
SET orase = tip_orase_cal('Bucuresti', 'Craiova')
WHERE cod_excursie = 4;

-- c
DECLARE
  o tip_orase_cal := tip_orase_cal();
  no NUMBER(2);
  cod NUMBER(4) := &cood;
BEGIN
  SELECT orase
  INTO o
  FROM excursie_cal
  WHERE cod_excursie = cod;

  DBMS_OUTPUT.PUT_LINE('Numar orase: ' || o.COUNT);
  for i in o.first..o.last loop
    DBMS_OUTPUT.PUT(o(i) || ' ');
  end loop;
  DBMS_OUTPUT.NEW_LINE;
END;
/

-- d
DECLARE
  o tip_orase_cal := tip_orase_cal();
  TYPE tab_indexat IS TABLE of excursie_cal.cod_excursie%TYPE INDEX BY BINARY_INTEGER;
  coduri tab_indexat;
BEGIN
  SELECT cod_excursie
  BULK COLLECT INTO coduri
  FROM excursie_cal;

  for i in coduri.first..coduri.last loop
    SELECT orase
    INTO o
    FROM excursie_cal
    WHERE cod_excursie = coduri(i);

    DBMS_OUTPUT.PUT_LINE(o.count);

    for j in o.first..o.last loop
      DBMS_OUTPUT.PUT_LINE(o(j));
    end loop;
  end loop;
END;
/

-- e
DECLARE
  o tip_orase_cal := tip_orase_cal();
  TYPE tab_indexat IS TABLE of excursie_cal.cod_excursie%TYPE INDEX BY BINARY_INTEGER;
  coduri tab_indexat;
  minim NUMBER(5) := 5000;
  codMinim excursie_cal.cod_excursie%TYPE;
BEGIN
  SELECT cod_excursie
  BULK COLLECT INTO coduri
  FROM excursie_cal;

  for i in coduri.first..coduri.last loop
    SELECT ORASE
    INTO o
    FROM excursie_cal
    WHERE cod_excursie = coduri(i);

    if o.count < minim then
      minim := o.count;
      codMinim := coduri(i);
    end if;
  end loop;

  UPDATE excursie_cal
  SET status = 'anulat'
  WHERE cod_excursie = codMinim;
END;
/
SELECT * FROM excursie_cal;

-- ex3
CREATE OR REPLACE TYPE tip_orase_cal2 is VARRAY(20) of VARCHAR(20);
/

CREATE TABLE excursie_cal2(
  cod_excursie NUMBER(4),
  denumire VARCHAR(20),
  orase tip_orase_cal2,
  status varchar2(20)
);

-- a
BEGIN
  INSERT INTO excursie_cal2 VALUES(1, 'ex1',
      tip_orase_cal2('Bucuresti', 'Severin'), 'disponibil');
  INSERT INTO excursie_cal2 VALUES(2, 'ex2',
      tip_orase_cal2('Bucuresti', 'Severin'), 'disponibil');
  INSERT INTO excursie_cal2 VALUES(3, 'ex3',
      tip_orase_cal2('Bucuresti', 'Severin'), 'disponibil');
  INSERT INTO excursie_cal2 VALUES(4, 'ex4',
      tip_orase_cal2('Bucuresti', 'Severin'), 'disponibil');
  INSERT INTO excursie_cal2 VALUES(5, 'ex5',
      tip_orase_cal2('Bucuresti', 'Severin'), 'disponibil');
END;
/
SELECT * FROM excursie_cal2;

-- b
UPDATE excursie_cal2
SET orase = tip_orase_cal2('Bucuresti', 'Craiova')
WHERE cod_excursie = 4;

-- c
DECLARE
  o tip_orase_cal2 := tip_orase_cal2();
  no NUMBER(2);
  cod NUMBER(4) := &cood;
BEGIN
  SELECT orase
  INTO o
  FROM excursie_cal2
  WHERE cod_excursie = cod;

  DBMS_OUTPUT.PUT_LINE('Numar orase: ' || o.COUNT);
  for i in o.first..o.last loop
    DBMS_OUTPUT.PUT(o(i) || ' ');
  end loop;
  DBMS_OUTPUT.NEW_LINE;
END;
/

-- d
DECLARE
  o tip_orase_cal2 := tip_orase_cal2();
  TYPE tab_indexat IS TABLE of excursie_cal2.cod_excursie%TYPE INDEX BY BINARY_INTEGER;
  coduri tab_indexat;
BEGIN
  SELECT cod_excursie
  BULK COLLECT INTO coduri
  FROM excursie_cal2;

  for i in coduri.first..coduri.last loop
    SELECT orase
    INTO o
    FROM excursie_cal2
    WHERE cod_excursie = coduri(i);

    DBMS_OUTPUT.PUT_LINE(o.count);

    for j in o.first..o.last loop
      DBMS_OUTPUT.PUT_LINE(o(j));
    end loop;
  end loop;
END;
/

-- e
DECLARE
  o tip_orase_cal2 := tip_orase_cal2();
  TYPE tab_indexat IS TABLE of excursie_cal2.cod_excursie%TYPE INDEX BY BINARY_INTEGER;
  coduri tab_indexat;
  minim NUMBER(5) := 5000;
  codMinim excursie_cal2.cod_excursie%TYPE;
BEGIN
  SELECT cod_excursie
  BULK COLLECT INTO coduri
  FROM excursie_cal2;

  for i in coduri.first..coduri.last loop
    SELECT ORASE
    INTO o
    FROM excursie_cal2
    WHERE cod_excursie = coduri(i);

    if o.count < minim then
      minim := o.count;
      codMinim := coduri(i);
    end if;
  end loop;

  UPDATE excursie_cal2
  SET status = 'anulat'
  WHERE cod_excursie = codMinim;
END;
/
SELECT * FROM excursie_cal2;
