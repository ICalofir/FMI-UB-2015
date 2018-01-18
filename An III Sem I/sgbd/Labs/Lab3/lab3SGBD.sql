--1

--b)

declare
  cursor joburi is (select job_id, job_title from jobs);
  cursor angajati(jid jobs.job_id%type) is (
                      select first_name, last_name
                      from employees
                      where job_id = jid);
begin
  for i in joburi loop
    dbms_output.new_line;
    dbms_output.put_line(i.job_title);
    dbms_output.put_line('------------------');
    
    for j in angajati(i.job_id) loop
      dbms_output.put_line(angajati%rowcount || ' ' || j.first_name ||' '|| j.last_name);
    end loop;
  end loop;
end;
/

--2

declare
  cursor joburi is (select job_id, job_title from jobs);
  cursor angajati(jid jobs.job_id%type) is (
                      select first_name, last_name, salary, commission_pct
                      from employees
                      where job_id = jid);
  nr_angajati number(10);
  salariu_lunar number(10);
  nr_total_angajati number(10) := 0;
  salariu_lunar_total number(10) := 0;
begin
  for i in joburi loop
    nr_angajati := 0;
    salariu_lunar := 0;
    dbms_output.new_line;
    dbms_output.put_line(i.job_title);
    dbms_output.put_line('------------------');
    
    for j in angajati(i.job_id) loop
      dbms_output.put_line(angajati%rowcount || ' ' || j.first_name ||' '|| j.last_name);
      nr_angajati := angajati%rowcount;
      salariu_lunar := salariu_lunar + j.salary + j.salary * nvl(j.commission_pct,0);
    end loop;
    dbms_output.put_line('Numar angajati: ' || nr_angajati);
    dbms_output.put_line('Salariu lunar: ' || salariu_lunar);
    dbms_output.put_line('Valoarea medie lunara: ' || salariu_lunar / nr_angajati);
    nr_total_angajati := nr_total_angajati + nr_angajati;
    salariu_lunar_total := salariu_lunar_total + salariu_lunar;
  end loop;
  dbms_output.put_line('Numar total de angajati: ' || nr_total_angajati);
  dbms_output.put_line('Salariu total lunar: ' || salariu_lunar_total);
  dbms_output.put_line('Valoarea medie totala lunara: ' || round(salariu_lunar_total / nr_total_angajati, 2));
end;
/

--3

declare
  cursor joburi is (select job_id, job_title from jobs);
  cursor angajati(jid jobs.job_id%type) is (
                      select first_name, last_name, salary, commission_pct
                      from employees
                      where job_id = jid);
  nr_angajati number(10);
  salariu_lunar number(10);
  nr_total_angajati number(10) := 0;
  salariu_lunar_total number(10) := 0;
  suma_totala_alocata number(10) := 0;
begin
  for i in joburi loop
    salariu_lunar := 0;
    for j in angajati(i.job_id) loop
      salariu_lunar := salariu_lunar + j.salary + j.salary * nvl(j.commission_pct,0);
    end loop;
    salariu_lunar_total := salariu_lunar_total + salariu_lunar;
  end loop;
  
  suma_totala_alocata := round(salariu_lunar_total / 12, 2);
  
  for i in joburi loop
    nr_angajati := 0;
    salariu_lunar := 0;
    dbms_output.new_line;
    dbms_output.put_line(i.job_title);
    dbms_output.put_line('------------------');
    
    for j in angajati(i.job_id) loop
      dbms_output.put_line(angajati%rowcount || ' ' || j.first_name ||' '|| j.last_name);
      nr_angajati := angajati%rowcount;
      salariu_lunar := salariu_lunar + j.salary + j.salary * nvl(j.commission_pct,0);
          dbms_output.put_line('Procentaj alocat: ' || round((j.salary + j.salary * nvl(j.commission_pct,0)) / suma_totala_alocata, 2) * 100 || '%');
    end loop;
    dbms_output.put_line('Numar angajati: ' || nr_angajati);
    dbms_output.put_line('Salariu lunar: ' || salariu_lunar);
    dbms_output.put_line('Valoarea medie lunara: ' || salariu_lunar / nr_angajati);
    nr_total_angajati := nr_total_angajati + nr_angajati;
    salariu_lunar_total := salariu_lunar_total + salariu_lunar;
  end loop;
  dbms_output.put_line('Numar total de angajati: ' || nr_total_angajati);
  dbms_output.put_line('Salariu total lunar: ' || salariu_lunar_total);
  dbms_output.put_line('Valoarea medie totala lunara: ' || round(salariu_lunar_total / nr_total_angajati, 2));
  dbms_output.put_line('Suma totala alocata: ' || suma_totala_alocata);
end;
/

--4 

declare
  cursor joburi is (select job_id, job_title from jobs);
  cursor angajati(jid jobs.job_id%type) is (
                      select first_name, last_name, salary, commission_pct
                      from employees
                      where job_id = jid);
  cursor angajati5(jid jobs.job_id%type) is (
                      select *
                      from (select first_name, last_name, salary, commission_pct
                            from employees
                            where job_id = jid
                            order by salary + salary * nvl(commission_pct, 0) desc)
                      where rownum <= 5);                  
  nr_angajati number(10);
  salariu_lunar number(10);
  nr_total_angajati number(10) := 0;
  salariu_lunar_total number(10) := 0;
  suma_totala_alocata number(10) := 0;
  nr_angajati5 number(2);
begin
  for i in joburi loop
    salariu_lunar := 0;
    for j in angajati(i.job_id) loop
      salariu_lunar := salariu_lunar + j.salary + j.salary * nvl(j.commission_pct,0);
    end loop;
    salariu_lunar_total := salariu_lunar_total + salariu_lunar;
  end loop;
  
  suma_totala_alocata := round(salariu_lunar_total / 12, 2);
  
  for i in joburi loop
    nr_angajati := 0;
    salariu_lunar := 0;
    dbms_output.new_line;
    dbms_output.put_line(i.job_title);
    dbms_output.put_line('------------------');
    
    for j in angajati(i.job_id) loop
      dbms_output.put_line(angajati%rowcount || ' ' || j.first_name ||' '|| j.last_name);
      nr_angajati := angajati%rowcount;
      salariu_lunar := salariu_lunar + j.salary + j.salary * nvl(j.commission_pct,0);
      dbms_output.put_line('Procentaj alocat: ' || round((j.salary + j.salary * nvl(j.commission_pct,0)) / suma_totala_alocata, 2) * 100 || '%');
    end loop;
    dbms_output.put_line('Numar angajati: ' || nr_angajati);
    dbms_output.put_line('Salariu lunar: ' || salariu_lunar);
    dbms_output.put_line('Valoarea medie lunara: ' || salariu_lunar / nr_angajati);
    nr_total_angajati := nr_total_angajati + nr_angajati;
    salariu_lunar_total := salariu_lunar_total + salariu_lunar;
    
    for j in angajati5(i.job_id) loop
      dbms_output.put_line(angajati5%rowcount || ' ' || j.first_name ||' '|| j.last_name);
      nr_angajati5 := angajati5%rowcount;
    end loop;
    
    if nr_angajati5 < 5 then
      dbms_output.put_line('Sunt mai putin de 5 angajati!!');
    end if;
    
  end loop;
  dbms_output.put_line('Numar total de angajati: ' || nr_total_angajati);
  dbms_output.put_line('Salariu total lunar: ' || salariu_lunar_total);
  dbms_output.put_line('Valoarea medie totala lunara: ' || round(salariu_lunar_total / nr_total_angajati, 2));
  dbms_output.put_line('Suma totala alocata: ' || suma_totala_alocata);
end;
/

--5


declare
  cursor joburi is (select job_id, job_title from jobs);
  cursor angajati(jid jobs.job_id%type) is (
                      select first_name, last_name, salary, commission_pct
                      from employees
                      where job_id = jid);
  cursor angajati5(jid jobs.job_id%type) is (
                      select *
                      from (select first_name, last_name, salary, commission_pct
                            from employees
                            where job_id = jid
                            order by salary + salary * nvl(commission_pct, 0) desc)
                      where rownum <= 5);
  cursor angajati_top(jid jobs.job_id%type) is (
                      select *
                      from (select first_name, last_name, salary, commission_pct
                            from employees
                            where job_id = jid
                            order by salary + salary * nvl(commission_pct, 0) desc));             
  nr_angajati number(10);
  salariu_lunar number(10);
  nr_total_angajati number(10) := 0;
  salariu_lunar_total number(10) := 0;
  suma_totala_alocata number(10) := 0;
  nr_angajati5 number(2);
  top number(2);
  salariu_angajat  number(10);
  salariu_anterior number(10);
begin
  for i in joburi loop
    salariu_lunar := 0;
    for j in angajati(i.job_id) loop
      salariu_lunar := salariu_lunar + j.salary + j.salary * nvl(j.commission_pct,0);
    end loop;
    salariu_lunar_total := salariu_lunar_total + salariu_lunar;
  end loop;
  
  suma_totala_alocata := round(salariu_lunar_total / 12, 2);
  
  for i in joburi loop
    nr_angajati := 0;
    salariu_lunar := 0;
    dbms_output.new_line;
    dbms_output.put_line(i.job_title);
    dbms_output.put_line('------------------');
    
    for j in angajati(i.job_id) loop
      dbms_output.put_line(angajati%rowcount || ' ' || j.first_name ||' '|| j.last_name);
      nr_angajati := angajati%rowcount;
      salariu_lunar := salariu_lunar + j.salary + j.salary * nvl(j.commission_pct,0);
      dbms_output.put_line('Procentaj alocat: ' || round((j.salary + j.salary * nvl(j.commission_pct,0)) / suma_totala_alocata, 2) * 100 || '%');
    end loop;
    dbms_output.put_line('Numar angajati: ' || nr_angajati);
    dbms_output.put_line('Salariu lunar: ' || salariu_lunar);
    dbms_output.put_line('Valoarea medie lunara: ' || salariu_lunar / nr_angajati);
    nr_total_angajati := nr_total_angajati + nr_angajati;
    salariu_lunar_total := salariu_lunar_total + salariu_lunar;
    
    for j in angajati5(i.job_id) loop
      dbms_output.put_line(angajati5%rowcount || ' ' || j.first_name ||' '|| j.last_name);
      nr_angajati5 := angajati5%rowcount;
    end loop;
    
    if nr_angajati5 < 5 then
      dbms_output.put_line('Sunt mai putin de 5 angajati!!');
    end if;
    
    top := 1;
    salariu_anterior := 0;
    dbms_output.put_line('Topul angajailor:');
    for j in angajati_top(i.job_id) loop
      exit when top > 5;
      salariu_angajat := j.salary + j.salary * nvl(j.commission_pct,0);
      if salariu_anterior = 0 then
        salariu_anterior := salariu_angajat;
      end if;
      
      if salariu_angajat = salariu_anterior then
        dbms_output.put_line(top || ' ' || j.first_name ||' '|| j.last_name);
      else
        top := top + 1;
        if top <= 5 then
          dbms_output.put_line(top || ' ' || j.first_name ||' '|| j.last_name);
        end if;
      end if;
      salariu_anterior := salariu_angajat;
    end loop;
    
  end loop;
  dbms_output.put_line('Numar total de angajati: ' || nr_total_angajati);
  dbms_output.put_line('Salariu total lunar: ' || salariu_lunar_total);
  dbms_output.put_line('Valoarea medie totala lunara: ' || round(salariu_lunar_total / nr_total_angajati, 2));
  dbms_output.put_line('Suma totala alocata: ' || suma_totala_alocata);
end;
/
