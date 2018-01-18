--ex1

create sequence scv1_dho
start with 1;

create or replace package pack_dho
as
  --a)
  procedure addEmployee(nume employees.last_name%type,
                        prenume employees.first_name%type,
                        telefon employees.phone_number%type,
                        email employees.email%type,
                        numeDept departments.department_name%type,
                        numeJob jobs.job_title%type,
                        numeMan employees.last_name%type,
                        prenumeMan employees.first_name%type);
                        
  --b)
  procedure moveEmployee(nume employees.last_name%type,
                        prenume employees.first_name%type,
                        numeDept departments.department_name%type,
                        numeJob jobs.job_title%type,
                        numeMan employees.last_name%type,
                        prenumeMan employees.first_name%type);
end pack_dho;
/

-------------- BODY -------------

create or replace package body pack_dho
as
  --Salariul minim
  function getSal(codJob employees.job_id%type,
                  codDepartament employees.department_id%type)
  return employees.salary%type
  is
    salMin employees.salary%type;
  begin
    select min(salary)
    into salMin
    from employees
    where department_id = codDepartament
    and job_id = codJob;
    
    return salMin;
  end getSal;
  
  --Cod manager
  function getCodManager(numeMan employees.last_name%type,
                        prenumeMan employees.first_name%type)
  return employees.employee_id%type
  is
    manID employees.employee_id%type;
  begin
    select employee_id
    into manID
    from employees
    where first_name = prenumeMan
    and last_name = numeMan;
    
    return manID;
  end getCodManager;
  
  --Cod departament
  function getCodDept(numeDept departments.department_name%type)
  return departments.department_id%type
  is
    codDept departments.department_id%type;
  begin
    select department_id
    into codDept
    from departments
    where department_name = numeDept;
    
    return codDept;
  end getCodDept;
  
  --Cod job
  function getCodJob(numeJob jobs.job_title%type)
  return jobs.job_id%type
  is
    codJob jobs.job_id%type;
  begin
    select job_id
    into codJob
    from jobs
    where job_title = numeJob;
    
    return codJob;
  end getCodJob;
  
  --a)
  procedure addEmployee(nume employees.last_name%type,
                        prenume employees.first_name%type,
                        telefon employees.phone_number%type,
                        email employees.email%type,
                        numeDept departments.department_name%type,
                        numeJob jobs.job_title%type,
                        numeMan employees.last_name%type,
                        prenumeMan employees.first_name%type)
  is
    salMin employees.salary%type;
    manID employees.employee_id%type;
    codDept departments.department_id%type;
    codJob jobs.job_id%type;
  begin
    codJob := getCodJob(numeJob);
    codDept := getCodDept(numeDept);
    salMin := getSal(codJob, codDept);
    manID := getCodManager(numeMan, prenumeMan);
    
    dbms_output.put_line(scv1_dho.nextval || ' ' || codDept || ' ' || codJob || ' ' || salMin || ' ' || manID);
    
  end addEmployee;
  
  --Comision minim
  function getComMin( codDept departments.department_id%type,
                      codJob jobs.job_id%type)
  return EMPLOYEES.COMMISSION_PCT%type
  is
    comMin EMPLOYEES.COMMISSION_PCT%type;
  begin
    select min(commission_pct)
    into comMin
    from employees
    where department_id = codDept
    and job_id = codJob;
    
    return comMin;
  end getComMin;
  
  --b)
   procedure moveEmployee(nume employees.last_name%type,
                        prenume employees.first_name%type,
                        numeDept departments.department_name%type,
                        numeJob jobs.job_title%type,
                        numeMan employees.last_name%type,
                        prenumeMan employees.first_name%type)
  is
    salMin employees.salary%type;
    manID employees.employee_id%type;
    codDept departments.department_id%type;
    codJob jobs.job_id%type;
    comMin EMPLOYEES.COMMISSION_PCT%type;
  begin
    codJob := getCodJob(numeJob);
    codDept := getCodDept(numeDept);
    salMin := getSal(codJob, codDept);
    manID := getCodManager(numeMan, prenumeMan);
    comMin := getComMin(codDept, codJob);
    
    select salary
    into salMin
    from employees
    where nume = last_name
    and prenume = first_name
    and salary > salMin;
    
    dbms_output.put_line(scv1_dho.nextval || ' ' || codDept || ' ' || codJob || ' ' || salMin || ' ' || comMin || ' ' || manID || sysdate);
    
  end moveEmployee;
end pack_dho;
/

--Apeluri

begin
  --pack_dho.addEmployee('Gigel', 'Ghorghe', '0744444444', 'cineva@ceva.com', 'Executive', 'Administration Vice President', 'King', 'Steven');
  pack_dho.moveEmployee('Gigel', 'Ghorghe', 'Executive', 'Administration Vice President', 'King', 'Steven');
end;
/






















