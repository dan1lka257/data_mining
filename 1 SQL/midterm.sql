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