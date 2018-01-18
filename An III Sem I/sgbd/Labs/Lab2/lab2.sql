--ex1

declare
  type arr is varray(5) of employees.employee_id%type;
  vector arr := arr();
begin
  select employee_id
  bulk collect into vector
  from employees
  where rownum <= 5
  order by salary desc;
  
  for i in vector.first..vector.last loop
    update emp_dho
    set salary = salary * 0.05 + salary
    where employee_id = vector(i);
  end loop;
end;
/

select * from emp_dho
order by salary desc;

--ex2

create or replace type tip_orase_dho is table of varchar2(50);
/
create table excursie_dho(
  cod_excursie number(2),
  denumire varchar2(50),
  orase tip_orase_dho,
  status varchar2(30)
)
nested table orase store as orase_dho;

--a)
begin
  insert into excursie_dho values(1, 'some excursion1', tip_orase_dho('Bucuresti', 'Timisoara', 'Vaslui'), 'disponibil');
  insert into excursie_dho values(2, 'some excursion2', tip_orase_dho('Stucuresti', 'Timisoara', 'Vaslui'), 'disponibil');
  insert into excursie_dho values(3, 'some excursion3', tip_orase_dho('Ucuresti', 'Timisoara', 'Vaslui'), 'disponibil');
  insert into excursie_dho values(4, 'some excursion4', tip_orase_dho('Bucuresti', 'Soara', 'Vaslui'), 'disponibil');
  insert into excursie_dho values(5, 'some excursion5', tip_orase_dho('Bucuresti', 'Timisoara', 'Slui'), 'disponibil');
end;
/

select * from excursie_dho;

--b)
update excursie_dho
set orase = tip_orase_dho('Iasi', 'Cluj')
where cod_excursie = 4;

--c)
declare
  setOrase tip_orase_dho := tip_orase_dho();
begin
  select orase 
  into setOrase
  from excursie_dho
  where cod_excursie = &p_cod;
  
  dbms_output.put_line(setOrase.count);
  
  for i in setOrase.first..setOrase.last loop
    dbms_output.put_line(setOrase(i));
  end loop;
end;
/

--d)
declare
  setOrase tip_orase_dho := tip_orase_dho();
  type tab_indexat is table of excursie_dho.cod_excursie%type index by binary_integer;
  coduri tab_indexat;
begin
  select cod_excursie
  bulk collect into coduri
  from excursie_dho;
  
  for i in coduri.first..coduri.last loop
    select orase 
    into setOrase
    from excursie_dho
    where cod_excursie = coduri(i);
    
    dbms_output.put_line(setOrase.count);
    
    for j in setOrase.first..setOrase.last loop
      dbms_output.put_line(setOrase(j));
    end loop;
  end loop;
end;
/

--e)

declare
  setOrase tip_orase_dho := tip_orase_dho();
  type tab_indexat is table of excursie_dho.cod_excursie%type index by binary_integer;
  coduri tab_indexat;
  minim number(5) := 50000;
  codMinim excursie_dho.cod_excursie%type;
begin
  select cod_excursie
  bulk collect into coduri
  from excursie_dho;
  
  for i in coduri.first..coduri.last loop
    select orase 
    into setOrase
    from excursie_dho
    where cod_excursie = coduri(i);
    
    if setOrase.count < minim then
      minim := setOrase.count;
      codMinim := coduri(i);
    end if;
  end loop;
  
  update excursie_dho
  set status = 'Anulat'
  where cod_excursie = codMinim;
  
end;
/


--ex3)


create or replace type tip_orase2_dho is varray(30) of varchar2(50);
/
create table excursie2_dho(
  cod_excursie number(2),
  denumire varchar2(50),
  orase tip_orase2_dho,
  status varchar2(30)
)

--a)
begin
  insert into excursie2_dho values(1, 'some excursion1', tip_orase2_dho('Bucuresti', 'Timisoara', 'Vaslui'), 'disponibil');
  insert into excursie2_dho values(2, 'some excursion2', tip_orase2_dho('Stucuresti', 'Timisoara', 'Vaslui'), 'disponibil');
  insert into excursie2_dho values(3, 'some excursion3', tip_orase2_dho('Ucuresti', 'Timisoara', 'Vaslui'), 'disponibil');
  insert into excursie2_dho values(4, 'some excursion4', tip_orase2_dho('Bucuresti', 'Soara', 'Vaslui'), 'disponibil');
  insert into excursie2_dho values(5, 'some excursion5', tip_orase2_dho('Bucuresti', 'Timisoara', 'Slui'), 'disponibil');
end;
/

select * from excursie2_dho;

--b)
update excursie2_dho
set orase = tip_orase2_dho('Iasi', 'Cluj')
where cod_excursie = 4;

--c)
declare
  setOrase tip_orase2_dho := tip_orase2_dho();
begin
  select orase 
  into setOrase
  from excursie2_dho
  where cod_excursie = &p_cod;
  
  dbms_output.put_line(setOrase.count);
  
  for i in setOrase.first..setOrase.last loop
    dbms_output.put_line(setOrase(i));
  end loop;
end;
/

--d)
declare
  setOrase tip_orase2_dho := tip_orase2_dho();
  type tab_indexat is table of excursie2_dho.cod_excursie%type index by binary_integer;
  coduri tab_indexat;
begin
  select cod_excursie
  bulk collect into coduri
  from excursie2_dho;
  
  for i in coduri.first..coduri.last loop
    select orase 
    into setOrase
    from excursie2_dho
    where cod_excursie = coduri(i);
    
    dbms_output.put_line(setOrase.count);
    
    for j in setOrase.first..setOrase.last loop
      dbms_output.put_line(setOrase(j));
    end loop;
  end loop;
end;
/

--e)

declare
  setOrase tip_orase2_dho := tip_orase2_dho();
  type tab_indexat is table of excursie2_dho.cod_excursie%type index by binary_integer;
  coduri tab_indexat;
  minim number(5) := 50000;
  codMinim excursie2_dho.cod_excursie%type;
begin
  select cod_excursie
  bulk collect into coduri
  from excursie2_dho;
  
  for i in coduri.first..coduri.last loop
    select orase 
    into setOrase
    from excursie2_dho
    where cod_excursie = coduri(i);
    
    if setOrase.count < minim then
      minim := setOrase.count;
      codMinim := coduri(i);
    end if;
  end loop;
  
  update excursie2_dho
  set status = 'Anulat'
  where cod_excursie = codMinim;
  
end;
/





