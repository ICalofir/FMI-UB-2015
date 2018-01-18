--lab 4
-- ex 1
CREATE TABLE info_sho(
    utilizator VARCHAR2(40),
    data DATE,
    comanda VARCHAR2(40),
    nr_linii NUMBER(2),
    eroare VARCHAR2(200)
);


-- ex 2
CREATE OR REPLACE FUNCTION f2_sho(
    v_nume employees.last_name%TYPE DEFAULT 'Bell')
  RETURN NUMBER
IS
  salariu employees.salary%type;
  mesajErr VARCHAR2(200);
  nrLinii  NUMBER(3);
BEGIN
  SELECT salary INTO salariu FROM employees WHERE last_name = v_nume;
  RETURN salariu;
EXCEPTION
WHEN NO_DATA_FOUND THEN
  mesajErr := SQLERRM;
  INSERT INTO info_sho
  SELECT USER, SYSDATE, 'f2_sho', 0, mesajErr FROM dual;
  return 0;
WHEN TOO_MANY_ROWS THEN
  mesajErr := SQLERRM;
  SELECT COUNT(*) INTO nrLinii FROM employees WHERE last_name = v_nume;
  INSERT INTO info_sho
  SELECT USER, SYSDATE, 'f2_sho',nrLinii, mesajErr FROM dual;
  return 0;
WHEN OTHERS THEN
  mesajErr := SQLERRM;
  SELECT COUNT(*) INTO nrLinii FROM employees WHERE last_name = v_nume;
  INSERT INTO info_sho
  SELECT USER, SYSDATE, 'f2_sho',nrLinii, mesajErr FROM dual;
  return 0;
END f2_sho;
/

DECLARE
  sal employees.salary%TYPE;
BEGIN
  sal := f2_sho('GIGI');
END;
/

SELECT * FROM info_sho;


--ex 3
CREATE OR REPLACE FUNCTION fun_ex3(mycity locations.city%TYPE)
RETURN NUMBER
IS
  nr_angajati NUMBER(3);
BEGIN
  SELECT COUNT(*)
  INTO nr_angajati
  FROM(
    SELECT e.last_name, e.first_name, COUNT(e.employee_id), l.city
    FROM employees e JOIN job_history j ON(e.job_id = j.job_id)
                     JOIN departments d ON(d.department_id = e.department_id)
                     JOIN locations l ON(l.location_id = d.location_id)
    WHERE Upper(l.city) = Upper(mycity)
    GROUP BY e.last_name, e.first_name, l.city
    HAVING COUNT(e.employee_id) = 2);
  RETURN nr_angajati;
END fun_ex3;
/

DECLARE
  nr_angajati NUMBER(3);
BEGIN
  nr_angajati := fun_ex3('South San Francisco');
  dbms_output.put_line(nr_angajati);
END;
/

--ex3 b
CREATE OR REPLACE Procedure proc_ex3(oras locations.city%TYPE)
IS
 TYPE rec IS RECORD(eid employees.employee_id%type,
                     fn employees.first_name%type,
                     ln employees.last_name%type);
  TYPE colectie IS TABLE OF rec;
  angajati colectie;
  mesajErr VARCHAR2(200);
BEGIN
  SELECT employee_id, first_name, last_name
  BULK COLLECT INTO angajati
  FROM(
     select e.employee_id, e.first_name, e.last_name, count(e.employee_id)
    from employees e join job_history j on(e.employee_id = j.employee_id)
                   join departments d on(e.department_id = d.department_id)
                   join locations l on(d.location_id = l.location_id)
    where oras = l.city
    group by e.first_name, e.last_name, e.employee_id
    having count(e.employee_id) = 2);
  
    FOR i in angajati.FIRST..angajati.LAST LOOP
       dbms_output.put_line(angajati(i).eid ||' '|| angajati(i).fn || ' ' || angajati(i).ln);
    END LOOP;
    
  EXCEPTION
  WHEN NO_DATA_FOUND THEN
    mesajErr := SQLERRM;
    dbms_output.put_line(mesajErr); 
  --  RAISE_APPLICATION_ERROR(-20000, 'Nu exista angajati cu numele dat');
  WHEN OTHERS THEN
    mesajErr := SQLERRM;
    dbms_output.put_line(mesajErr);
  --  RAISE_APPLICATION_ERROR(-20002,'Alta eroare!');
END proc_ex3;
/
DECLARE
 TYPE cities IS TABLE OF locations.city%TYPE;
 orase cities;
BEGIN
  SELECT city
  BULK COLLECT INTO orase
  FROM locations;
  FOR i IN orase.FIRST..orase.LAST LOOP
    DBMS_OUTPUT.PUT_LINE(orase(i));
    proc_ex3(orase(i));
  END LOOP;
END;
/
