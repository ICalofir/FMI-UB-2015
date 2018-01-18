-- lab5
-- d)
CREATE OR REPLACE PACKAGE exd 
IS
  PROCEDURE promovare(idAng employees.employee_ID%TYPE);
  PROCEDURE foloseste;
END exd;
/

CREATE OR REPLACE PACKAGE BODY exd 
IS
  CURSOR ang(jid jobs.job_id%TYPE) IS 
    SELECT employee_id, first_name
    FROM employees
    WHERE job_id = jid;
    
  CURSOR locuri_munca IS 
    SELECT job_id, job_title
    FROM jobs;
    
   PROCEDURE foloseste 
   IS
   BEGIN
    FOR j IN locuri_munca LOOP 
      DBMS_OUTPUT.PUT_LINE(j.job_title);
      DBMS_OUTPUT.PUT_LINE('------------------');
      FOR an IN ang(j.job_id) LOOP
        DBMS_OUTPUT.PUT_LINE(an.first_name);
      END LOOP;
    END LOOP;
   END;


  FUNCTION getSal(manId employees.employee_ID%TYPE) 
  RETURN employees.salary%TYPE
  IS
    salariu employees.salary%TYPE;
  BEGIN
    SELECT salary
    INTO salariu
    FROM employees
    WHERE employee_id = manId;
    RETURN salariu;
    --tratare exceptii
    EXCEPTION 
      WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20000, 'Nu exista manager cu id-ul dat');
--sau RAISE_APPLICATION_ERROR(SQLCODE, SQLERRM);
--sau 
--   IS 
--      exceptie EXCEPTION;
--      nr NUMBER(2) := 0;
--   BEGIN
--      SELECT COUNT(*)
--      INTO nr
--      FROM employees
--      WHERE employee_id = manId; 
--      IF nr == 0 THEN
--        RAISE exceptie;
--      END IF;
--      -----
--    EXCEPTION
--      WHEN exceptie THEN
--         RAISE_APPLICATION_ERROR(-20000, 'Nu exista manager cu id-ul dat');
--      
  END getSal;
  
  FUNCTION getComision(manId employees.employee_ID%TYPE) 
  RETURN employees.commission_pct%TYPE
  IS
    comision employees.commission_pct%TYPE;
  BEGIN
    SELECT commission_pct
    INTO comision
    FROM employees
    WHERE employee_id = manId;
    RETURN comision;
  END getComision;
  
  FUNCTION getJobId(manId employees.employee_ID%TYPE) 
  RETURN employees.job_id%TYPE
  IS
    idJob employees.commission_pct%TYPE;
  BEGIN
    SELECT job_id
    INTO idJob
    FROM employees
    WHERE employee_id = manId;
    RETURN idJob;
  END getJobId;
  
  FUNCTION getDep(manId employees.employee_ID%TYPE) 
  RETURN employees.department_id%TYPE
  IS
    departament employees.department_id%TYPE;
  BEGIN
    SELECT department_id
    INTO departament
    FROM employees
    WHERE employee_id = manId;
    RETURN departament;
  END getDep;
  
  FUNCTION getManId(manId employees.employee_ID%TYPE) 
  RETURN employees.department_id%TYPE
  IS
    manager employees.department_id%TYPE;
  BEGIN
    SELECT manager_id
    INTO manager
    FROM employees
    WHERE employee_id = manId;
    RETURN manager;
  END getManId;

  PROCEDURE promovare(idAng employees.employee_ID%TYPE)
  IS
    comision employees.commission_pct%TYPE;
    salariu employees.salary%TYPE;
    idJob employees.commission_pct%TYPE;
    departament employees.department_id%TYPE;
    idMan employees.employee_id%TYPE;
    manager employees.department_id%TYPE;
  BEGIN
    SELECT manager_id
    INTO idMan
    FROM employees
    WHERE employee_id = idAng;
    
    comision := getComision(idMan);
    salariu := getSal(idMan);
    idJob := getJobId(idMan);
    manager := getManId(idMan);
    departament := getDep(idMan);
    
--    UPDATE employees
--    SET commission_pct = comision,
--        salary = salariu, 
--        job_id = idJob,
--        manager_id = manager,
--        department_id = departament
--    WHERE employee_id = idAng;
          
  END;
END exd;
/

-- lab 6
-- ex 1
CREATE OR REPLACE TRIGGER trig1
BEFORE DELETE 
ON dept_sho
BEGIN
  IF user <> 'SCOTT' THEN 
    RAISE_APPLICATION_ERROR(SQLCODE, SQLERRM);
  END IF;
END;
/
--ex 2
CREATE OR REPLACE TRIGGER trig2
BEFORE UPDATE OF commission_pct
ON employees
FOR EACH ROW
BEGIN
  IF :NEW.commission_pct >= 0.5 THEN
    RAISE_APPLICATION_ERROR(SQLCODE, SQLERRM);
  END IF;
END;
/
--ex 3
CREATE TABLE info_dept_sho 
AS SELECT department_id as id_dep, COUNT(employee_id) numar
  FROM employees 
  GROUP BY department_id;

SELECT * FROM info_dept_sho;


CREATE OR REPLACE TRIGGER trig3
BEFORE INSERT OR UPDATE OF department_id
ON employees
FOR EACH ROW
BEGIN
  IF INSERTING THEN
    UPDATE info_dept_sho
    SET numar = (SELECT numar 
                 FROM info_dept_sho
                 WHERE id_dep = :NEW.department_id) + 1
    WHERE id_dep = :NEW.department_id;
  ELSIF UPDATING THEN
    UPDATE info_dept_sho
    SET numar = (SELECT numar 
                 FROM info_dept_sho
                 WHERE id_dep = :OLD.department_id) - 1
     WHERE id_dep = :OLD.department_id;
         UPDATE info_dept_sho
    SET numar = (SELECT numar 
                 FROM info_dept_sho
                 WHERE id_dep = :NEW.department_id) + 1
     WHERE id_dep = :NEW.department_id;
  END IF;
END;
/


UPDATE employees
SET department_id = 110
WHERE employee_id = 120;
