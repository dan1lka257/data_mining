--Задание 1
--select lastname from reader where address like '%Москва%'

--Задание 2
--select b.title, b.author from book b
--inner join publisher p on b.pubname = p.pubname
--where p.pubkind in ('Science', 'Reference')

--Задание 3
--select b.title, b.author from book b
--where exists (select 1 from borrowing bor
--where bor.isbn = b.isbn and bor.readernr in 
--(select id from reader where lastname = 'Иванов' and firstname = 'Иван'))

--Задание 4
--select b.isbn from book b
--	inner join bookcat bc on bc.isbn = b.isbn 
--	where categoryname = 'Mountains'
--except 
--select b.isbn from book b
--	inner join bookcat bc on bc.isbn = b.isbn 
--	where categoryname = 'Travel'

--Задание 5
--select distinct r.lastname, r.firstname from reader r
--inner join borrowing bor on r.id = bor.readernr
--where bor.returndate is not null

--Задание 6
--select distinct r.lastname, r.firstname from reader r
--inner join borrowing bor on bor.readernr = r.id 
--where bor.isbn in (select isbn from borrowing bor where bor.readernr in 
--(select id from reader where lastname = 'Иванов' and firstname = 'Иван'))
--and r.lastname != 'Иванов' and r.firstname != 'Иван'

