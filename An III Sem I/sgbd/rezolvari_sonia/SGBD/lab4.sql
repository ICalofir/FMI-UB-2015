/*-- Exemple
-- I. variabile locale
-- 1. 
Declare
	FN varchar2(40);
	--	LN  FN%type;
	LN  employees.last_name%type;
Begin
	Select first_name, last_name INTO FN, LN  from employees where employee_id = 100;

	dbms_output.put_line('Valoarea variabilei FN este: '|| FN || ' iar LN este: '|| LN );
End;
/

-- 2. 
DECLARE
  totul employees%rowtype;
BEGIN 
  SELECT *
  INTO totul 
  FROM employees 
  WHERE employee_id = 101;
  
  dbms_output.put_line(totul.first_name ||' '|| totul.salary );
END;
/

-- II. variabile BIND(globale)
VARIABLE glob NUMBER;
BEGIN
  :glob := 103;
END;
/
--afisare var globale in afara blocurilor
PRINT glob;

DECLARE
  totul employees%rowtype;
BEGIN
  SELECT *
  INTO totul
  FROM employees
  WHERE employee_id = :glob;
  dbms_output.put_line(totul.first_name ||' '|| totul.salary );
END;
/
*/

--Exercitii antrenament
--- ex 2
<<principal>>
DECLARE
  v_client_id NUMBER(4):= 1600;
  v_client_nume VARCHAR2(50):= 'N1';
  v_nou_client_id NUMBER(3):= 500;
BEGIN
  <<secundar>>
  DECLARE
    v_client_id NUMBER(4) := 0;
    v_client_nume VARCHAR2(50) := 'N2';
    v_nou_client_id NUMBER(3) := 300;
    v_nou_client_nume VARCHAR2(50) := 'N3';
  BEGIN
    v_client_id:= v_nou_client_id;
    principal.v_client_nume:=v_client_nume ||' '|| v_nou_client_nume;
    --poziţia 1
     dbms_output.put_line('Poz1 v_client_id '||v_client_id);
     dbms_output.put_line('Poz1 v_client_nume '||v_client_nume);
     dbms_output.put_line('Poz1 v_nou_client_id '||v_nou_client_id);
     dbms_output.put_line('Poz1 v_nou_client_nume '||v_nou_client_nume);
  END;
  v_client_id:= (v_client_id *12)/10;
  --poziţia 2
  dbms_output.put_line('Poz2 v_client_id '||v_client_id);
  dbms_output.put_line('Poz2 v_client_nume '||v_client_nume);
END;
/

--ex 3
--varianta 1
VARIABLE g_mesaj VARCHAR2(50) 
BEGIN 
  :g_mesaj := 'Invat PL/SQL';
END; 
/ 
PRINT g_mesaj

--varianta 2
BEGIN 
  DBMS_OUTPUT.PUT_LINE('Invat PL/SQL'); 
END; 
/

--ex 4
DECLARE 
  v_dep departments.department_name%TYPE; 
BEGIN 
  SELECT department_name 
  INTO v_dep FROM employees e, departments d 
  WHERE e.department_id=d.department_id 
  GROUP BY department_name 
  HAVING COUNT(*) = (SELECT MAX(COUNT(*)) 
                    FROM employees
                    GROUP BY department_id);
  DBMS_OUTPUT.PUT_LINE('Departamentul '|| v_dep);
END; 
/

--ex 5 la fel

--ex 6
DECLARE 
  v_dep departments.department_name%TYPE; 
  v_nr NUMBER;
BEGIN 
  SELECT department_name, COUNT(*)
  INTO v_dep, v_nr 
  FROM employees e, departments d 
  WHERE e.department_id=d.department_id 
  GROUP BY department_name 
  HAVING COUNT(*) = (SELECT MAX(COUNT(*)) 
                    FROM employees
                    GROUP BY department_id);
  DBMS_OUTPUT.PUT_LINE('Departamentul '|| v_dep||' cu '||v_nr||' angajati.');
END; 
/

--ex 7
SET VERIFY OFF 
DECLARE 
  v_cod employees.employee_id%TYPE:=&p_cod;
  v_bonus NUMBER(8);
  v_salariu_anual NUMBER(8);
BEGIN 
  SELECT salary*12 
  INTO v_salariu_anual 
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
SET VERIFY ON

--ex 8 la fel, dar cu CASE

--ex 9
CREATE TABLE emp_sho
AS SELECT * FROM employees;

DEFINE p_cod_sal = 200 
DEFINE p_cod_dept = 80
DEFINE p_procent = 20 
DECLARE 
  v_cod_sal emp_sho.employee_id%TYPE:= &&p_cod_sal;
  v_cod_dept emp_sho.department_id%TYPE:= &&p_cod_dept;
  v_procent NUMBER(8):=&&p_procent;
BEGIN 
  UPDATE emp_sho
  SET department_id = v_cod_dept,
    salary=salary + (salary * v_procent/100) 
  WHERE employee_id= v_cod_sal; 
  IF SQL%ROWCOUNT = 0 THEN 
    DBMS_OUTPUT.PUT_LINE('Nu exista un angajat cu acest cod');
  ELSE DBMS_OUTPUT.PUT_LINE('Actualizare realizata');
  END IF; 
END; 
/ 
ROLLBACK;

--ex 10
CREATE TABLE zile_sho(
    id NUMBER,
    data DATE,
    nume_zi VARCHAR2(20)
  );

DECLARE
  contor NUMBER(6) := 1;
  v_data DATE;
  maxim  NUMBER(2) := LAST_DAY(SYSDATE)-SYSDATE;
BEGIN
  LOOP
    v_data := sysdate+contor;
    INSERT INTO zile_sho VALUES(contor,v_data,TO_CHAR(v_data,'Day'));
    contor := contor + 1;
    EXIT WHEN contor > maxim;
  END LOOP;
END;
/

SELECT * FROM zile_sho;

--ex 11 aceesi chestie cu WHILE

--ex 12 aceeasi cheste cu FOR
DECLARE
  v_data DATE;
  maxim  NUMBER(2) := LAST_DAY(SYSDATE)-SYSDATE;
BEGIN
  FOR contor IN 1..maxim LOOP
    v_data := sysdate+contor;
    INSERT INTO zile_*** VALUES (contor,v_data,TO_CHAR(v_data,'Day'));
  END LOOP;
END;
/

--ex 13
DECLARE
  i POSITIVE                :=1;
  max_loop CONSTANT POSITIVE:=10;
BEGIN
  LOOP
    i  :=i+1;
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


--Exercitii
--ex 1
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
    numar := numar + 1;
    mesaj2 := mesaj2 || ' adaugat in sub-bloc';
    DBMS_OUTPUT.PUT_LINE('Valoarea variabilei numar în subbloc este: '||numar);
    DBMS_OUTPUT.PUT_LINE('Valoarea variabilei mesaj1 în subbloc este: '||mesaj1);
    DBMS_OUTPUT.PUT_LINE('Valoarea variabilei mesaj2  în subbloc este: '||mesaj2);
  END;
numar := numar + 1;
mesaj1:=mesaj1||' adaugat un blocul principal'; 
mesaj2:=mesaj2||' adaugat in blocul principal';
DBMS_OUTPUT.PUT_LINE('Valoarea variabilei numar în bloc este: '||numar);
DBMS_OUTPUT.PUT_LINE('Valoarea variabilei mesaj1 în bloc este: '||mesaj1);
DBMS_OUTPUT.PUT_LINE('Valoarea variabilei mesaj2  în bloc este: '||mesaj2);
END;
/

--ex 2
--b)
CREATE TABLE octombrie_sho (
  id NUMBER,
  data DATE
);
/*
DECLARE
  id NUMBER := 0;
BEGIN
  SELECT DT
  FROM(
  SELECT TRUNC (last_day(SYSDATE) - ROWNUM + 1) dt
    FROM DUAL CONNECT BY ROWNUM < 32
    )
    where DT >= trunc(sysdate,'mm');
END;
/
*/

DECLARE
  contor NUMBER(6) := 0;
  v_data DATE;
  first_date DATE := TO_DATE('2017-10-01', 'YYYY-MM-DD');
  maxim NUMBER(2) := 30;
BEGIN
  LOOP
    v_data := first_date + contor;
    contor := contor + 1;
    INSERT INTO octombrie_sho VALUES (contor, v_data );
    EXIT WHEN contor > maxim;
  END LOOP;
END;
/

--nu merge inca
SELECT oct.data, COUNT(*) numar_imprumuturi
FROM rental r JOIN octombrie_sho oct ON(TO_CHAR(oct.data, 'dd/mm/yyyy') = TO_CHAR(r.book_date, 'dd/mm/yyyy'))
GROUP BY oct.data;


--altfel
DECLARE
  zi_din_luna DATE := '01-oct-2017';
  cate_imprumuturi number(3);
BEGIN 
  FOR i in 1..31 LOOP
    SELECT COUNT(*)
    INTO cate_imprumuturi
    FROM rental
    WHERE TO_CHAR(book_date, 'dd/mm/yyyy') = TO_CHAR(zi_din_luna, 'dd/mm/yyyy');
    DBMS_OUTPUT.PUT_LINE('In ziua '||zi_din_luna||' au fost imprumutate '||cate_imprumuturi);
    zi_din_luna := zi_din_luna + 1;
  END LOOP;
END; 
/

-- ex 3
DECLARE
  nume member.last_name%TYPE := '&v_subs';
  cati NUMBER(2);
  cate_imprumuturi NUMBER(3);
BEGIN
  SELECT COUNT(*)
  INTO cati
  FROM member
  WHERE UPPER(last_name) = UPPER(nume);
  IF cati > 1 THEN
    DBMS_OUTPUT.PUT_LINE('Sunt mai multi');
  ELSIF cati = 0 THEN 
    DBMS_OUTPUT.PUT_LINE('Nu e niciunul');
  ELSE 
    SELECT COUNT(UNIQUE(title_id))
    INTO cate_imprumuturi
    FROM member, rental
    WHERE UPPER(last_name) = UPPER(nume)
    AND member.member_id = rental.member_id;
    DBMS_OUTPUT.PUT_LINE('Membrul '||nume||' a imprumutat '||cate_imprumuturi||' titluri.');
  END IF;
END;
/

--ex 4
DECLARE
  nume member.last_name%TYPE := '&v_subs';
  cati NUMBER(2);
  cate_imprumuturi NUMBER(3);
  numar_titluri NUMBER(2);
BEGIN
  SELECT COUNT(*)
  INTO cati
  FROM member
  WHERE UPPER(last_name) = UPPER(nume);
  IF cati > 1 THEN
    DBMS_OUTPUT.PUT_LINE('Sunt mai multi');
  ELSIF cati = 0 THEN 
    DBMS_OUTPUT.PUT_LINE('Nu e niciunul');
  ELSE 
    SELECT COUNT(UNIQUE(title_id))
    INTO cate_imprumuturi
    FROM member, rental
    WHERE UPPER(last_name) = UPPER(nume)
    AND member.member_id = rental.member_id;
    DBMS_OUTPUT.PUT_LINE('Membrul '||nume||' a imprumutat '||cate_imprumuturi||' titluri.');
    SELECT COUNT(UNIQUE(title_id))
    INTO numar_titluri
    FROM title;
    IF cate_imprumuturi > numar_titluri * 75/100 THEN
       DBMS_OUTPUT.PUT_LINE('Categoria 1');
    ELSIF cate_imprumuturi > numar_titluri * 50/100 THEN
        DBMS_OUTPUT.PUT_LINE('Categoria 2');
    ELSIF cate_imprumuturi > numar_titluri * 25/100 THEN
        DBMS_OUTPUT.PUT_LINE('Categoria 3');
    ELSE 
        DBMS_OUTPUT.PUT_LINE('Categoria 4');
    END IF;
  END IF;
END;
/

--ex 5
CREATE TABLE member_sho 
AS SELECT * FROM member;

ALTER TABLE member_sho
ADD discount NUMBER(2);

DECLARE
  nume member.last_name%TYPE := '&v_subs';
  cati NUMBER(2);
  cate_imprumuturi NUMBER(3);
  numar_titluri NUMBER(2);
BEGIN
  SELECT COUNT(*)
  INTO cati
  FROM member
  WHERE UPPER(last_name) = UPPER(nume);
  IF cati > 1 THEN
    DBMS_OUTPUT.PUT_LINE('Sunt mai multi');
  ELSIF cati = 0 THEN 
    DBMS_OUTPUT.PUT_LINE('Nu e niciunul');
  ELSE 
    SELECT COUNT(UNIQUE(title_id))
    INTO cate_imprumuturi
    FROM member, rental
    WHERE UPPER(last_name) = UPPER(nume)
    AND member.member_id = rental.member_id;
    DBMS_OUTPUT.PUT_LINE('Membrul '||nume||' a imprumutat '||cate_imprumuturi||' titluri.');
    SELECT COUNT(UNIQUE(title_id))
    INTO numar_titluri
    FROM title;
    IF cate_imprumuturi > numar_titluri * 75/100 THEN
       UPDATE member_sho
       SET discount = 10
       WHERE UPPER(last_name) = UPPER(nume);
    ELSIF cate_imprumuturi > numar_titluri * 50/100 THEN
         UPDATE member_sho
         SET discount = 5
         WHERE UPPER(last_name) = UPPER(nume);
    ELSIF cate_imprumuturi > numar_titluri * 25/100 THEN
        UPDATE member_sho
        SET discount = 3
        WHERE UPPER(last_name) = UPPER(nume);
    ELSE 
        UPDATE member_sho
        SET discount = 0
        WHERE UPPER(last_name) = UPPER(nume);
    END IF;
  END IF;
END;
/

SELECT * FROM emp_sho;


--lab 3
DECLARE
  TYPE angajati IS VARRAY(5) OF employees.employee_id%TYPE;
  vector angajati := angajati();
BEGIN
  SELECT employee_id
  BULK COLLECT INTO vector
  FROM employees
  WHERE ROWNUM <= 5
  ORDER BY salary DESC;
  for i in vector.FIRST..vector.LAST LOOP
    UPDATE emp_sho
    SET salary = salary * 0.05 + salary
    WHERE employee_id = vector(i);
  END LOOP;

END;
/

SELECT * FROM employees;

--ex 2
CREATE OR REPLACE TYPE tip_orase_sho IS TABLE OF VARCHAR2(50);
/
CREATE TABLE excursie_sho(
        cod_excursie NUMBER(4),
        denumire VARCHAR2(20),
        orase tip_orase_sho,
        status VARCHAR2(30)
)
NESTED TABLE orase STORE AS orase_sho;

--a)
BEGIN
INSERT INTO excursie_sho VALUES(1, 'Predeal-Sighisoara', tip_orase_sho('Bucuresti', 'Timisoara', 'Sibiu', 'Sighisoara'), 'Dispoibil');
INSERT INTO excursie_sho VALUES(2, 'Litoral 2015', tip_orase_sho('Bucuresti', 'Constanta', 'Mamaia'), 'Anulat');
INSERT INTO excursie_sho VALUES(3, 'Bucuresti-Oradea', tip_orase_sho('Bucuresti', 'Oradea'), 'Dispoibil');
INSERT INTO excursie_sho VALUES(4, 'Revelion 2011', tip_orase_sho('Bucuresti', 'Iasi'), 'Dispoibil');
INSERT INTO excursie_sho VALUES(5, 'Sibiu', tip_orase_sho('Sibiu', 'Sighisoara'), 'Dispoibil');
END;
/

SELECT * FROM excursie_sho;

--b)
UPDATE excursie_sho
SET orase = tip_orase_sho('Bucuresti', 'Constanta', 'Mamaia', 'Costinesti')
WHERE cod_excursie = 2;

--c)
DECLARE
  set_orase tip_orase_sho := tip_orase_sho(); 
BEGIN
  SELECT orase
  INTO set_orase
  FROM excursie_sho
  WHERE cod_excursie = &p_cod;
  DBMS_OUTPUT.PUT_LINE(set_orase.count);
  FOR i IN set_orase.FIRST..set_orase.LAST LOOP
     DBMS_OUTPUT.PUT_LINE(set_orase(i));
  END LOOP;
END;
/

--d)
DECLARE
  set_orase tip_orase_sho := tip_orase_sho(); 
  TYPE tab_indexat IS TABLE OF excursie_sho.cod_excursie%TYPE INDEX BY BINARY_INTEGER;
  coduri tab_indexat;
BEGIN
  SELECT cod_excursie
  BULK COLLECT INTO coduri
  FROM excursie_sho;
  
  FOR i in coduri.FIRST..coduri.LAST LOOP
      DBMS_OUTPUT.PUT_LINE(coduri(i));
      SELECT orase
      INTO set_orase
      FROM excursie_sho
      WHERE cod_excursie = coduri(i);
      DBMS_OUTPUT.PUT_LINE(set_orase.count);
      FOR ii IN set_orase.FIRST..set_orase.LAST LOOP
         DBMS_OUTPUT.PUT_LINE(set_orase(ii));
      END LOOP;
  END LOOP;

END;
/

--e)
DECLARE
  numar_minim NUMBER(10) := 100000;
  cod_excursie excursie_sho.cod_excursie%TYPE;
  TYPE tab_indexat IS TABLE OF excursie_sho.cod_excursie%TYPE INDEX BY BINARY_INTEGER;
  coduri tab_indexat;
  set_orase tip_orase_sho := tip_orase_sho();
BEGIN
  SELECT cod_excursie
  BULK COLLECT INTO coduri
  FROM excursie_sho;
  FOR i in coduri.FIRST..coduri.LAST LOOP
      SELECT orase
      INTO set_orase
      FROM excursie_sho
      WHERE cod_excursie = coduri(i);
      IF set_orase.count < numar_minim THEN
        numar_minim := set_orase.count;
        cod_excursie := coduri(i);
      END IF;  
  END LOOP;
  DBMS_OUTPUT.PUT_LINE(cod_excursie);
  UPDATE excursie_sho s
  SET status = 'Anulat'
  WHERE s.cod_excursie = cod_excursie;
END;
/

--ex 3
CREATE OR REPLACE TYPE tip_orase_sho2 IS VARRAY(30) OF VARCHAR(30);
/
CREATE TABLE excursie_sho2(
        cod_excursie NUMBER(4),
        denumire VARCHAR2(20),
        orase tip_orase_sho2,
        status VARCHAR2(30)
);

--a)
BEGIN
INSERT INTO excursie_sho2 VALUES(1, 'Predeal-Sighisoara', tip_orase_sho2('Bucuresti', 'Timisoara', 'Sibiu', 'Sighisoara'), 'Dispoibil');
INSERT INTO excursie_sho2 VALUES(2, 'Litoral 2015', tip_orase_sho2('Bucuresti', 'Constanta', 'Mamaia'), 'Anulat');
INSERT INTO excursie_sho2 VALUES(3, 'Bucuresti-Oradea', tip_orase_sho2('Bucuresti', 'Oradea'), 'Dispoibil');
INSERT INTO excursie_sho2 VALUES(4, 'Revelion 2011', tip_orase_sho2('Bucuresti', 'Iasi'), 'Dispoibil');
INSERT INTO excursie_sho2 VALUES(6, 'Sibiu', tip_orase_sho2('Sibiu'), 'Dispoibil');
END;
/

SELECT * FROM excursie_sho2;

--b)
UPDATE excursie_sho2
SET orase = tip_orase_sho2('Bucuresti', 'Constanta', 'Mamaia', 'Costinesti')
WHERE cod_excursie = 2;

--c)
DECLARE
  set_orase tip_orase_sho2 := tip_orase_sho2(); 
BEGIN
  SELECT orase
  INTO set_orase
  FROM excursie_sho2
  WHERE cod_excursie = &p_cod;
  DBMS_OUTPUT.PUT_LINE(set_orase.count);
  FOR i IN set_orase.FIRST..set_orase.LAST LOOP
     DBMS_OUTPUT.PUT_LINE(set_orase(i));
  END LOOP;
END;
/

--d)
DECLARE
  set_orase tip_orase_sho2 := tip_orase_sho2(); 
  TYPE tab_indexat IS TABLE OF excursie_sho.cod_excursie%TYPE INDEX BY BINARY_INTEGER;
  coduri tab_indexat;
BEGIN
  SELECT cod_excursie
  BULK COLLECT INTO coduri
  FROM excursie_sho2;
  
  FOR i in coduri.FIRST..coduri.LAST LOOP
      DBMS_OUTPUT.PUT_LINE(coduri(i));
      SELECT orase
      INTO set_orase
      FROM excursie_sho
      WHERE cod_excursie = coduri(i);
      DBMS_OUTPUT.PUT_LINE(set_orase.count);
      FOR ii IN set_orase.FIRST..set_orase.LAST LOOP
         DBMS_OUTPUT.PUT_LINE(set_orase(ii));
      END LOOP;
  END LOOP;

END;
/

--e)
DECLARE
  numar_minim NUMBER(10) := 100000;
  cod_excursie excursie_sho.cod_excursie%TYPE;
  TYPE tab_indexat IS TABLE OF excursie_sho.cod_excursie%TYPE INDEX BY BINARY_INTEGER;
  coduri tab_indexat;
  set_orase tip_orase_sho2 := tip_orase_sho2();
BEGIN
  SELECT cod_excursie
  BULK COLLECT INTO coduri
  FROM excursie_sho2;
  FOR i in coduri.FIRST..coduri.LAST LOOP
      SELECT orase
      INTO set_orase
      FROM excursie_sho2
      WHERE cod_excursie = coduri(i);
      IF set_orase.count < numar_minim THEN
        numar_minim := set_orase.count;
        cod_excursie := coduri(i);
      END IF;  
  END LOOP;
  DBMS_OUTPUT.PUT_LINE(cod_excursie);
  UPDATE excursie_sho2 s
  SET status = 'Anulat'
  WHERE s.cod_excursie = cod_excursie;
END;
/


--lab4
DECLARE
  CURSOR job_si_titlu IS
    SELECT job_id, job_title
    FROM jobs;
  CURSOR ang (parametru employees.job_id%TYPE) IS  
    SELECT last_name, salary
    FROM employees 
    WHERE job_id = parametru;
BEGIN
  FOR j in job_si_titlu LOOP
    DBMS_OUTPUT.PUT_LINE(j.job_title);
    for emp in ang(j.job_id) LOOP
       DBMS_OUTPUT.PUT_LINE(emp.last_name || ' ' || emp.salary);
    END LOOP;
  DBMS_OUTPUT.PUT_LINE('------------------------');
  END LOOP;
END;
/