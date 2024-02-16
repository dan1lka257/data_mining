--1.1
--SELECT title, pubname FROM book s

--1.2
--select title from book where pagesnum in (select max(pagesnum) from book)

--1.3
--select author from book
--group by author
--having count(isbn) > 5

--1.4
--select isbn from book where pagesnum >= 2*(select avg(pagesnum) from book)

--1.5
--select distinct  parentcat from category
--where parentcat notnull 

--1.6
--select b.author from book b
--group by author 
--having count(isbn) >= all(select count(isbn) from book group by author)

--1.7
--select distinct br.readernr from borrowing br
--join book bk on bk.isbn = br.isbn
--where bk.author in ('Марк Твен')

--1.8
--select isbn from copy
--group by isbn
--having count(copynumber) > 1

--1.9
--select title, pubyear from book
--where pubyear < (select pubyear from book
--order by pubyear asc limit 1 offset 10)

--1.10
--select c.categoryname from category c
--where c.parentcat = 'Sports'


--2.1
--insert into borrowing (readernr, isbn, copynumber)
--values ((select distinct id from reader
--where lastname = 'Johnson' and firstname = 'John'), 123456, 4)

--2.2
--delete from book
--where pubyear > 2000

--2.3
--update borrowing b
--set returndate = returndate + 30
--where returndate > '01.01.2022' and isbn in (select isbn from bookcat where categoryname = 'Databases')



--Student( !StudID!, Name, Semester )
--Test( !StudID!, LectNr, ProfNr, Grade )
--Lecture( !LectNr!, Title, Credit, ProfNr )
--Professor( !ProfNr!, Name, Room )

--3.1
--SELECT s.Name, s.StudID FROM Student s
--WHERE NOT EXISTS (
--SELECT * FROM Test c WHERE c.StudID = s.StudID AND c.Grade >= 4.0 ) 
--Выводятся имена и ID студентов, оценка которых меньше 4, или тех, кто не писал тест

--3.2
--( SELECT p.ProfNr, p.Name, sum(lec.Credit)
--FROM Professor p, Lecture lec
--WHERE p.ProfNr = lec.ProfNr
--GROUP BY p.ProfNr, p.Name)
--UNION
--( SELECT p.ProfNr, p.Name, 0
--FROM Professor p
--WHERE NOT EXISTS (
--SELECT * FROM Lecture lec WHERE lec.ProfNr = p.ProfNr ))
--Выводятся номера, имена и сумма кредитов прочитанных лекций профессоров. Если он лекций не читал, то выводится 0

--3.3
--SELECT s.Name, с.Grade
--FROM Student s, Lecture lec, Test c
--WHERE s.StudID = c.StudID AND lec.LectNr = c.LectNr AND c.Grade >= 4
--AND c.Grade >= ALL (
--SELECT c1.Grade FROM Test c1 WHERE c1.StudID = c.StudID )
--Выводятся имена и оценки студентов за конкретный тест, оценка которых >= 4 и является самой большой у этого студента вообще






















