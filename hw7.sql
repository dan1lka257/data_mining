-- Задание 1
-- Соедините любые две таблицы без указания условий соединения (иными словами, выполните декартово произведение таблиц).
-- Какой способ соединения будет выбран планировщиком?

--explain select * from airports cross join tickets
-- Он использовал вложенный цикл (nested loop)

-- Задание 2
-- Постройте таблицу расстояний между всеми аэропортами (так, чтобы каждая пара встречалась только один раз).
-- Какой способ соединения используется в таком запросе?

--explain select * from airports a1 join airports a2
--on a1.airport_code < a2.airport_code 
-- Также был использован вложенный цикл

-- Задание 3
-- Напишите запрос, показывающий занятые места в салоне для всех рейсов.
-- Какой способ соединения выбрал планировщик? Проверьте, хватило ли оперативной памяти для размещения хеш-таблиц.

--explain select f.flight_id, bp.seat_no
--from flights f join boarding_passes bp on bp.flight_id = f.flight_id 
-- Оперативной памяти хватило, планировщик использовал хэш-таблицы (Hash Join) 

-- Задание 4
-- Измените запрос, чтобы он выводил только общее количество занятых мест.
-- Как изменился план запроса? Почему планировщик не использовал аналогичный план для предыдущего запроса?

--explain select count(*) 
--from flights f join boarding_passes bp on bp.flight_id = f.flight_id
-- Из-за того, что используется метог агрегации, были использованы параллельные хэш-таблицы
-- (Parallel Hash Join)

-- Задание 5
-- Напишите запрос, показывающий имена пассажиров и номера рейсов, которыми они следуют.
-- Разберитесь по плану запроса, в какой последовательности выполняются операции.

--explain select t.passenger_name, f.flight_no from tickets t join boarding_passes bp on t.ticket_no = bp.ticket_no join flights f on f.flight_id = bp.flight_id
-- Планировщик использова хэш-таблицы, сначала для tickets, уже перебрав строки в boarding_passes, потом для flights

-- Задание 6
-- Проверьте план выполнения запроса, показывающего все места в салонах в порядке кодов самолетов, но оформленного в виде курсора.

--SELECT * FROM aircrafts a JOIN seats s ON a.aircraft_code = s.aircraft_code ORDER BY a.aircraft_code;

--explain DECLARE c CURSOR with hold FOR SELECT * FROM aircrafts a
--JOIN seats s ON a.aircraft_code = s.aircraft_code ORDER BY a.aircraft_code;
-- Был использован Merge Join, так же, как и без оформления в виде курсора

