--lab 3
--ex 1
DECLARE
  CURSOR joburi IS (SELECT job_id, job_title FROM jobs);
  CURSOR angajati (jid jobs.job_id%TYPE) IS 
        (SELECT first_name, last_name FROM employees WHERE job_id = jid);
BEGIN
  FOR i IN joburi LOOP
    DBMS_OUTPUT.NEW_LINE;
    DBMS_OUTPUT.PUT_LINE(i.job_title);
    DBMS_OUTPUT.PUT_LINE('--------------');
    FOR j IN angajati(i.job_id) LOOP
       DBMS_OUTPUT.PUT_LINE(angajati%ROWCOUNT || ' ' || j.first_name || ' ' || j.last_name);
    END LOOP;
  END LOOP;
END;
/

--ex 2
DECLARE
  CURSOR joburi IS (SELECT job_id, job_title FROM jobs);
  CURSOR angajati (jid jobs.job_id%TYPE) IS 
        (SELECT first_name, last_name, salary, commission_pct FROM employees WHERE job_id = jid);
   nr_ang NUMBER(10);
   sum_venituri NUMBER(10);
   nr_total NUMBER(10) := 0;
   sum_total NUMBER(10) := 0;
BEGIN
  FOR i IN joburi LOOP
    DBMS_OUTPUT.NEW_LINE;
    DBMS_OUTPUT.PUT_LINE(i.job_title);
    DBMS_OUTPUT.PUT_LINE('--------------');
    nr_ang := 0;
    sum_venituri := 0;
    FOR j IN angajati(i.job_id) LOOP
       DBMS_OUTPUT.PUT_LINE(angajati%ROWCOUNT || ' ' || j.first_name || ' ' || j.last_name);
       nr_ang := angajati%ROWCOUNT;
       nr_total := nr_total + nr_ang;
       sum_venituri := sum_venituri + (j.salary + j.salary * NVL(j.commission_pct,0));
       sum_total := sum_total + sum_venituri;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('Nr angajati = ' || nr_ang);
    DBMS_OUTPUT.PUT_LINE('Venitul lunar = ' || sum_venituri);
    DBMS_OUTPUT.PUT_LINE('Valoarea medie = ' || sum_venituri / nr_ang);
  END LOOP;
   DBMS_OUTPUT.NEW_LINE;
   DBMS_OUTPUT.PUT_LINE('--------------');
   DBMS_OUTPUT.PUT_LINE('Nr angajati total = ' || nr_total);
   DBMS_OUTPUT.PUT_LINE('Venitul total = ' || sum_total);
   DBMS_OUTPUT.PUT_LINE('Valoarea medie totala = ' || ROUND(sum_total / nr_total, 2));
END;
/

--ex 3
DECLARE
  CURSOR joburi IS (SELECT job_id, job_title FROM jobs);
  CURSOR angajati (jid jobs.job_id%TYPE) IS 
        (SELECT first_name, last_name, salary, commission_pct FROM employees WHERE job_id = jid);
   nr_ang NUMBER(10);
   sum_venituri NUMBER(10);
   nr_total NUMBER(10) := 0;
   sum_total NUMBER(10) := 0;
   val_lun NUMBER(10) := 0;
BEGIN
  FOR i IN joburi LOOP
    DBMS_OUTPUT.NEW_LINE;
    DBMS_OUTPUT.PUT_LINE(i.job_title);
    DBMS_OUTPUT.PUT_LINE('--------------');
    nr_ang := 0;
    sum_venituri := 0;
    FOR j IN angajati(i.job_id) LOOP
       DBMS_OUTPUT.PUT_LINE(angajati%ROWCOUNT || ' ' || j.first_name || ' ' || j.last_name);
       nr_ang := angajati%ROWCOUNT;
       nr_total := nr_total + 1;
       sum_venituri := sum_venituri + (j.salary + j.salary * NVL(j.commission_pct,0));
       sum_total := sum_total + sum_venituri;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('Nr angajati = ' || nr_ang);
    DBMS_OUTPUT.PUT_LINE('Venitul lunar = ' || sum_venituri);
    DBMS_OUTPUT.PUT_LINE('Valoarea medie = ' || sum_venituri / nr_ang);
  END LOOP;
   DBMS_OUTPUT.NEW_LINE;
   DBMS_OUTPUT.PUT_LINE('--------------');
   DBMS_OUTPUT.PUT_LINE('Nr angajati total = ' || nr_total);
   DBMS_OUTPUT.PUT_LINE('Venitul total = ' || sum_total);
   val_lun := ROUND(sum_total / nr_total, 2);
   DBMS_OUTPUT.PUT_LINE('Valoarea medie totala = ' || val_lun);
   
   DBMS_OUTPUT.NEW_LINE;
   DBMS_OUTPUT.PUT_LINE('--------------');
   DBMS_OUTPUT.PUT_LINE('Venitul total alocat lunar = ' || ROUND(sum_total / 12, 2));
   
    FOR i IN joburi LOOP
      FOR j IN angajati(i.job_id) LOOP
         DBMS_OUTPUT.PUT_LINE(angajati%ROWCOUNT || ' ' || j.first_name || ' ' || j.last_name || ' castiga lunar ' || ROUND((j.salary + j.salary * NVL(j.commission_pct,0)) * 100/ val_lun, 2) || '%');
      END LOOP;
    END LOOP;
END;
/

--ex 4
DECLARE
  CURSOR joburi IS (SELECT job_id, job_title FROM jobs);
  CURSOR angajati (jid jobs.job_id%TYPE) IS 
        (SELECT first_name, last_name, salary, commission_pct FROM employees WHERE job_id = jid);
  CURSOR top_cinci (jid jobs.job_id%TYPE) IS
        (SELECT * 
        FROM(SELECT  first_name, last_name, salary FROM employees WHERE job_id = jid ORDER BY salary DESC)
        WHERE ROWNUM <= 5); 
   nr_ang NUMBER(10);
   sum_venituri NUMBER(10);
   nr_total NUMBER(10) := 0;
   sum_total NUMBER(10) := 0;
   val_lun NUMBER(10) := 0;
BEGIN
  FOR i IN joburi LOOP
    DBMS_OUTPUT.NEW_LINE;
    DBMS_OUTPUT.PUT_LINE(i.job_title);
    DBMS_OUTPUT.PUT_LINE('--------------');
    nr_ang := 0;
    sum_venituri := 0;
    FOR j IN angajati(i.job_id) LOOP
       DBMS_OUTPUT.PUT_LINE(angajati%ROWCOUNT || ' ' || j.first_name || ' ' || j.last_name);
       nr_ang := angajati%ROWCOUNT;
       nr_total := nr_total + 1;
       sum_venituri := sum_venituri + (j.salary + j.salary * NVL(j.commission_pct,0));
       sum_total := sum_total + sum_venituri;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('Nr angajati = ' || nr_ang);
    DBMS_OUTPUT.PUT_LINE('Venitul lunar = ' || sum_venituri);
    DBMS_OUTPUT.PUT_LINE('Valoarea medie = ' || sum_venituri / nr_ang);
  END LOOP;
   DBMS_OUTPUT.NEW_LINE;
   DBMS_OUTPUT.PUT_LINE('--------------');
   DBMS_OUTPUT.PUT_LINE('Nr angajati total = ' || nr_total);
   DBMS_OUTPUT.PUT_LINE('Venitul total = ' || sum_total);
   val_lun := ROUND(sum_total / nr_total, 2);
   DBMS_OUTPUT.PUT_LINE('Valoarea medie totala = ' || val_lun);
   
   DBMS_OUTPUT.NEW_LINE;
   DBMS_OUTPUT.PUT_LINE('--------------');
   DBMS_OUTPUT.PUT_LINE('Venitul total alocat lunar = ' || ROUND(sum_total / 12, 2));
   
    FOR i IN joburi LOOP
      FOR j IN angajati(i.job_id) LOOP
         DBMS_OUTPUT.PUT_LINE(angajati%ROWCOUNT || ' ' || j.first_name || ' ' || j.last_name || ' castiga lunar ' || ROUND((j.salary + j.salary * NVL(j.commission_pct,0)) * 100/ val_lun, 2) || '%');
      END LOOP;
    END LOOP;
    
    FOR i IN joburi LOOP
      DBMS_OUTPUT.NEW_LINE;
      DBMS_OUTPUT.PUT_LINE(i.job_title);
      DBMS_OUTPUT.PUT_LINE('--------------');
      FOR j IN top_cinci(i.job_id) LOOP
         DBMS_OUTPUT.PUT_LINE(top_cinci%ROWCOUNT || ' ' || j.first_name || ' ' || j.last_name || ' ' || j.salary);
      END LOOP;
    END LOOP; 
END;
/

--ex 5
DECLARE
  CURSOR joburi IS (SELECT job_id, job_title FROM jobs);
  CURSOR angajati (jid jobs.job_id%TYPE) IS 
        (SELECT first_name, last_name, salary, commission_pct FROM employees WHERE job_id = jid);
  CURSOR top_cinci (jid jobs.job_id%TYPE) IS
        (SELECT * FROM
         (SELECT  first_name, last_name, salary
         FROM employees WHERE job_id = jid 
         ORDER BY salary DESC)); 
   nr_ang NUMBER(10);
   sum_venituri NUMBER(10);
   nr_total NUMBER(10) := 0;
   sum_total NUMBER(10) := 0;
   val_lun NUMBER(10) := 0;
   diferite NUMBER (3) := 0;
   ultim employees.salary%TYPE := 0;
BEGIN
  FOR i IN joburi LOOP
    DBMS_OUTPUT.NEW_LINE;
    DBMS_OUTPUT.PUT_LINE(i.job_title);
    DBMS_OUTPUT.PUT_LINE('--------------');
    nr_ang := 0;
    sum_venituri := 0;
    FOR j IN angajati(i.job_id) LOOP
       DBMS_OUTPUT.PUT_LINE(angajati%ROWCOUNT || ' ' || j.first_name || ' ' || j.last_name);
       nr_ang := angajati%ROWCOUNT;
       nr_total := nr_total + 1;
       sum_venituri := sum_venituri + (j.salary + j.salary * NVL(j.commission_pct,0));
       sum_total := sum_total + sum_venituri;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('Nr angajati = ' || nr_ang);
    DBMS_OUTPUT.PUT_LINE('Venitul lunar = ' || sum_venituri);
    DBMS_OUTPUT.PUT_LINE('Valoarea medie = ' || sum_venituri / nr_ang);
  END LOOP;
   DBMS_OUTPUT.NEW_LINE;
   DBMS_OUTPUT.PUT_LINE('--------------');
   DBMS_OUTPUT.PUT_LINE('Nr angajati total = ' || nr_total);
   DBMS_OUTPUT.PUT_LINE('Venitul total = ' || sum_total);
   val_lun := ROUND(sum_total / nr_total, 2);
   DBMS_OUTPUT.PUT_LINE('Valoarea medie totala = ' || val_lun);
   
   DBMS_OUTPUT.NEW_LINE;
   DBMS_OUTPUT.PUT_LINE('--------------');
   DBMS_OUTPUT.PUT_LINE('Venitul total alocat lunar = ' || ROUND(sum_total / 12, 2));
   
    FOR i IN joburi LOOP
      FOR j IN angajati(i.job_id) LOOP
         DBMS_OUTPUT.PUT_LINE(angajati%ROWCOUNT || ' ' || j.first_name || ' ' || j.last_name || ' castiga lunar ' || ROUND((j.salary + j.salary * NVL(j.commission_pct,0)) * 100/ val_lun, 2) || '%');
      END LOOP;
    END LOOP;
    
    DBMS_OUTPUT.PUT_LINE('____________________________________');
    FOR i IN joburi LOOP
      DBMS_OUTPUT.NEW_LINE;
      DBMS_OUTPUT.PUT_LINE(i.job_title);
      DBMS_OUTPUT.PUT_LINE('--------------');
      diferite := 0;
      FOR j IN top_cinci(i.job_id) LOOP
        IF ultim != j.salary THEN
          diferite := diferite + 1;
        END IF;
        EXIT WHEN diferite > 5;
        ultim := j.salary;
         DBMS_OUTPUT.PUT_LINE(top_cinci%ROWCOUNT || ' ' || j.first_name || ' ' || j.last_name || ' ' || j.salary);
      END LOOP;
    END LOOP; 
END;
/