--1
--select employee_id, s/salary from employees,
--(select max(salary) s from employees) a

--2
--select a.employee_id, (a.avg_salary)/(a.salary) from
--(select employee_id, salary, avg(salary)
--over (partition by department_id) as avg_salary from employees) a

--3
--select employee_id, department_id, salary,
--avg(salary) over (partition by department_id) as asd,
--avg(salary) over (partition by job_id) as asj,
--(avg(salary) over (partition by department_id)) / (avg(salary) over (partition by job_id)) as asd_on_asj
--from employees order by department_id, job_id 

--4
--select e.employee_id, e.salary, e.rn from 
--(select employee_id, salary, 
--row_number() over (partition by department_id order by salary, last_name) as rn,
--min(salary) over (partition by department_id) as ms
--from employees) e
--where e.rn = 1

--5


--6


--7






































