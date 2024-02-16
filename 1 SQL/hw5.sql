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
--create table scores_257
--as select employee_id man_id, department_id division, salary score from employees

--select e.man_id, e.score, e.division, e.rn from 
--(select man_id, score, division,
--row_number() over (partition by division order by score desc) as rn
--from scores_257) e
--where e.rn in (1, 2, 3)

--6
--select b.last_name, b.employee_id, b.salary, b.gr,
--round(b.salary - avg(salary) over (partition by b.gr)) as ans from
--(select r.last_name, r.employee_id, r.salary,
--round((row_number() over (partition by r.cnt)) * 5 / (r.cnt + 1)) gr from
--(select last_name, employee_id, salary, c.cnt cnt from employees,
--(select count(employee_id) cnt from employees) c) r) b

--7
--select k.id1, k.ans1, u.ans2 from (select d.id1, count(*) ans1 from
--	(select b.id1 from
--		(select tau.employee_id id1, tau.hire_date hire1, tau.dt dt1, tau2.employee_id id2 , tau2.hire_date hire2, tau2.dt dt2
--		from (select employee_id, hire_date, extract(year from hire_date) dt from employees) tau
--		    cross join (select employee_id, hire_date, extract(year from hire_date) dt from employees) tau2) b
--	where abs(b.hire1 - b.hire2) <= 365) d
--group by d.id1) k inner join (
--	select z.id1, count(*) ans2 from
--	(select b.id1 from
--		(select tau.employee_id id1, tau.hire_date hire1, tau.dt dt1, tau2.employee_id id2 , tau2.hire_date hire2, tau2.dt dt2
--		from (select employee_id, hire_date, extract(year from hire_date) dt from employees) tau
--		    cross join (select employee_id, hire_date, extract(year from hire_date) dt from employees) tau2) b
--	where abs(b.hire1 - b.hire2) <= 0 and b.dt1 = b.dt2) z
--	group by z.id1) u
--on k.id1 = u.id1


--create table test (
--	id int primary key,
--	firstname varchar(255) not null,
--	birthday date,
--	
--)

--select hire_date, extract(year from hire_date), extract(month from hire_date), extract(day from hire_date) from employees


--Задание 1
create table users_257 (
	user_id int primary key,
	email varchar(255) unique,
	birthday timestamp
);

create table forecasts_257 (
	forecasts_id int primary key,
	name varchar(255) not null,
	price numeric(10, 2) not null
);

create table subscriptions_257 (
	sub_id int primary key,
	user_id int,
	forecasts_id int,
	started date,
	duration int,
	foreign key user_id references users_257(user_id),
	foreign key forecasts_id references forecasts_257(forecasts_id)
);

--Задание 2
select a.login as login, sum(month_number * a.price) as summary from (
	select u.email as login, f.price as price,
		((s.duration + extract(month from s.started)) - (1 + 12 * (2023 - extract(year from s.started)))) as month_number
		from subscriptions_257 s
		inner join forecasts_257 f on f.forecasts_id = s.forecasts_id
		inner join users_257 u on u.user_id = s.user_id
		where ((s.duration + extract(month from s.started)) > 1 + 12 * (2023 - extract(year from s.started)))
			and ((s.duration + extract(month from s.started)) - (1 + 12 * (2023 - extract(year from s.started)))) < 12) a
group by a.login;

--Задание 3
select distinct us1.email as userlogin1, us2.email as userlogin2 from (
	select c.id1 as id1, c.id2 as id2, c.f_id as f_id, sum(c.month_num) as summary from (
		select b.id1 as id1, b.id2 as id2, - b.starting + b.ending as month_num, b.f_id as f_id from (
			select a.id1 as id1, a.id2 as id2,
			(SELECT MIN(x) FROM (VALUES (a.ends1),(a.ends2)) AS value(x)) as ending,
			(SELECT MAX(x) FROM (VALUES (a.starts1),(a.starts2)) AS value(x)) as starting,
			a.f_id as f_id
			from (
				select s1.sub_id as id1, s2.sub_id as id2,
				((extract(month from s1.started)) + (12 * (- 1970 + extract(year from s1.started)))) starts1,
				((s1.duration + extract(month from s1.started)) + (12 * (- 1970 + extract(year from s1.started)))) - 1 ends1,
				((extract(month from s2.started)) + (12 * (- 1970 + extract(year from s2.started)))) starts2,
				((s2.duration + extract(month from s2.started)) + (12 * (- 1970 + extract(year from s2.started)))) - 1 ends2,
				s1.forecasts_id as f_id
				from subscriptions_257 s1
				cross join subscriptions_257 s2
				where s1.forecasts_id = s2.forecasts_id) a) b
		where b.starting - b.ending < 0) c
	group by c.id1, c.id2, c.f_id) d
inner join users_257 us1 on us1.user_id = d.id1
inner join users_257 us2 on us2.user_id = d.id2
where d.summary > 0;

--Задание 4 (точь-в-точь задание 3, только последняя строчка отличается)
select distinct us1.email as userlogin1, us2.email as userlogin2 from (
	select c.id1 as id1, c.id2 as id2, c.f_id as f_id, sum(c.month_num) as summary from (
		select b.id1 as id1, b.id2 as id2, - b.starting + b.ending as month_num, b.f_id as f_id from (
			select a.id1 as id1, a.id2 as id2,
			(SELECT MIN(x) FROM (VALUES (a.ends1),(a.ends2)) AS value(x)) as ending,
			(SELECT MAX(x) FROM (VALUES (a.starts1),(a.starts2)) AS value(x)) as starting,
			a.f_id as f_id
			from (
				select s1.sub_id as id1, s2.sub_id as id2,
				((extract(month from s1.started)) + (12 * (- 1970 + extract(year from s1.started)))) starts1,
				((s1.duration + extract(month from s1.started)) + (12 * (- 1970 + extract(year from s1.started)))) - 1 ends1,
				((extract(month from s2.started)) + (12 * (- 1970 + extract(year from s2.started)))) starts2,
				((s2.duration + extract(month from s2.started)) + (12 * (- 1970 + extract(year from s2.started)))) - 1 ends2,
				s1.forecasts_id as f_id
				from subscriptions_257 s1
				cross join subscriptions_257 s2
				where s1.forecasts_id = s2.forecasts_id) a) b
		where b.starting - b.ending < 0) c
	group by c.id1, c.id2, c.f_id) d
inner join users_257 us1 on us1.user_id = d.id1
inner join users_257 us2 on us2.user_id = d.id2
where d.summary >= 2;












