SET SERVEROUTPUT ON;

-- ex1

DECLARE
  v_nr NUMBER(4);
  V_nume departments.department_name%TYPE;
  CURSOR c IS
    SELECT d.department_name nume, COUNT(e.employee_id) nr
    FROM departments d, employees e
    WHERE d.department_id=e.department_id(+)
    GROUP BY d.department_name;
BEGIN
  OPEN c;
  LOOP
    FETCH c INTO v_nume, v_nr;
    EXIT WHEN c%NOTFOUND;
    if v_nr=0 then
      DBMS_OUTPUT.PUT_LINE('In departamentul ' || v_nume || ' nu lucreaza
                            angajati');
    elsif v_nr=1 then
      DBMS_OUTPUT.PUT_LINE('In departamentul ' || v_nume || ' lucreaza
                            un angajat');
    else
      DBMS_OUTPUT.PUT_LINE('In departamentul ' || v_nume || ' lucreaza '
                            || v_nr || ' angajati');
    end if;
  END LOOP;
  CLOSE c;
END;
/

-- ex2
DECLARE
  CURSOR c IS
    SELECT d.department_name nume, COUNT(e.employee_id) nr
    FROM departments d, employees e
    WHERE d.department_id=e.department_id(+)
    GROUP BY d.department_name;
  TYPE tab_nume IS TABLE OF departments.department_name%TYPE;
  TYPE tab_nr IS TABLE OF NUMBER(4);
  v_nr tab_nr;
  v_nume tab_nume;
BEGIN
  OPEN c;
  FETCH c BULK COLLECT INTO v_nume, v_nr;
  CLOSE c;
  for i in v_nume.first..v_nume.last loop
    if v_nr(i)=0 then
      DBMS_OUTPUT.PUT_LINE('In departamentul ' || v_nume(i) || ' nu lucreaza
                            angajati');
    elsif v_nr(i)=1 then
      DBMS_OUTPUT.PUT_LINE('In departamentul ' || v_nume(i) || ' lucreaza
                            un angajat');
    else
      DBMS_OUTPUT.PUT_LINE('In departamentul ' || v_nume(i) || ' lucreaza '
                            || v_nr(i) || ' angajati');
    end if;
  end loop;
END;
/


-- ex3
DECLARE
  CURSOR c IS
    SELECT d.department_name nume, COUNT(e.employee_id) nr
    FROM departments d, employees e
    WHERE d.department_id=e.department_id(+)
    GROUP BY d.department_name;
BEGIN
  FOR i in c LOOP
    IF i.nr=0 THEN
      DBMS_OUTPUT.PUT_LINE('In departamentul '|| i.nume||
          ' nu lucreaza angajati');
    ELSIF i.nr=1 THEN
      DBMS_OUTPUT.PUT_LINE('In departamentul '|| i.nume ||
          ' lucreaza un angajat');
    ELSE
      DBMS_OUTPUT.PUT_LINE('In departamentul '|| i.nume||
          ' lucreaza '|| i.nr||' angajati');
    END IF;
  END LOOP;
END;
/

-- ex4
BEGIN
  FOR i in (SELECT d.department_name nume, COUNT(e.employee_id) nr
            FROM departments d, employees e
            WHERE d.department_id=e.department_id(+)
            GROUP BY d.department_name) LOOP
    IF i.nr=0 THEN
      DBMS_OUTPUT.PUT_LINE('In departamentul '|| i.nume||
          ' nu lucreaza angajati');
    ELSIF i.nr=1 THEN
      DBMS_OUTPUT.PUT_LINE('In departamentul '|| i.nume ||
          ' lucreaza un angajat');
    ELSE
      DBMS_OUTPUT.PUT_LINE('In departamentul '|| i.nume||
          ' lucreaza '|| i.nr||' angajati');
    END IF;
  END LOOP;
END;
/
