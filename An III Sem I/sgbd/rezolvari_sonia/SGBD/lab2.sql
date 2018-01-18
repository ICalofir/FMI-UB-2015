Exercitii
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
FROM rental r JOIN octombrie_sho oct ON(oct.data = r.act_ret_date); 
