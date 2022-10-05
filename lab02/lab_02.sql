-- lab 02


--1. Инструкция SELECT, использующая предикат сравнения. 
-- Пользователи тарифа, чьи номера меньше 500
select t.numberuser as "Number of user", 
	   t.nameuser as "Name of user", 
	   t.tariffuser as "Name of tariff" 
from Songs.Users as t
where t.numberuser < 500


--2. Инструкция SELECT, использующая предикат BETWEEN. 
-- Тарифы, цена которых от 200 до 400
select t.titletariff, t.servicetariff, t.PriceTariff 
from Songs.Tariff as t
where PriceTariff between 200 and 400


--3. Инструкция SELECT, использующая предикат LIKE. 
-- Тарифные планы, не работающие в онлайн режиме
select *
from Songs.Tariff
where OfflineModeTariff like 'No'


--4. Инструкция SELECT, использующая предикат IN с вложенным подзапросом. 
-- Авторы из Испании и Армении
select t1.nameauthor as "Name of author", 
	   t1.countryid as "Name of country"
from Songs.Authors as t1
where countryid in (
	select t2.countryid 
	from Country.Countries as t2
	where namecountry = 'Armenia' or namecountry = 'Spain'
)


--5. Инструкция SELECT, использующая предикат EXISTS с вложенным подзапросом.
-- Песни, продолжительность которых больше 2 минут и выпущены они после 2000 года
select t1.namesong as "Name of song", 
	   t1.durationsong as "Duration of song", 
	   t1.releasesong as "Date of release"
from Songs.Songs as t1
where durationsong > 2.0 and 
exists (
	select t2.namesong, t2.releasesong, t2.durationsong 
	from Songs.Songs as t2
	where DATE(releasesong) > '2000-01-01'
) 
order by releasesong asc


--6. Инструкция SELECT, использующая предикат сравнения с квантором
-- Список песен, выпущенных после 2000 года, продолжительность которых больше 2 минут
select t1.namesong as "Name of song", 
	   t1.durationsong as "Duration of song", 
	   t1.releasesong as "Date of release"
from Songs.Songs as t1
where durationsong > all (
	select t2.durationsong 
	from Songs.Songs as t2
	where durationsong = 2.0
) and DATE(releasesong) > '2000-01-01'
order by durationsong asc


--7. Инструкция SELECT, использующая агрегатные функции в выражениях столбцов
-- Количество песен, название которых начинается на букву T
select count(nameservice) as "Count of songs"
from songs.services
where nameservice like 'T%'

	
--8. Инструкция SELECT, использующая скалярные подзапросы в выражениях столбцов.
-- Количество авторов 
select t.countryid as "ID of Country", 
	   t.namecountry as "Name of Country",
	(
		select count(*)
		from Songs.Authors as t1
		where t1.authorid in 
		(
			select authorid 
			from Songs.Authors
			where countryid = t.countryid 
		)
	) as "Count of authors"
from Country.Countries as t
where countryid in 
(
	select countryid
	from Country.Countries
	where namecountry = 'Spain'
)
	

--9. Инструкция SELECT, использующая простое выражение CASE. 
-- Сервисы, поддерживаемые на разных устройствах
select nameservice as "Name of service", 
	   supporteddeviceservice as "Supported devices", 
	CASE supporteddeviceservice 
		when 'PC' then 'Only for PC'
		when 'Phone' then 'Only for phone'
		else 'For PC and phone'
	end as "Mode"
from Songs.services
order by serviceid  


--10. Инструкция SELECT, использующая поисковое выражение CASE.
-- Типизация песен по продолжительности
select NameSong as "Name of song", DurationSong as "Duration oа Song",
	case 
		when DurationSong < 0.5 then 'Short'
		when DurationSong < 2.0 then 'Middle'
		when DurationSong < 4.0 then 'Long'
		else 'Very long'
	end as "Duration"		
from songs.songs 


--11. Создание новой временной локальной таблицы из результирующего набора данных инструкции SELECT. 
-- Тарифы, срок истечения которых позже 01.01.2022
select tariffid as "Id", 
	   titletariff as "Name of tariff", 
	   deadlinetariff as "Deadline of tariff"
into DeadlineTariffTable
from Songs.Tariff 
where tariffid  in 
(
	select tariffid
	from songs.tariff 
	where tariffid in 
	(
		select countryid
		from Country.Countries
		where Date(deadlinetariff) > '2022-01-01'
		)
)
order by deadlinetariff asc

select * from DeadlineTariffTable
drop table DeadlineTariffTable


--12. Инструкция SELECT, использующая вложенные коррелированные подзапросы в качестве производных таблиц в предложении FROM. 
-- Тарифы с максимальнымой и минимальной стоимостью
select 'MAX' as Criteria, t.servicetariff, summaryPrice, t.tariffid
from songs.tariff as t join 
	(
		select t1.tariffid, SUM(pricetariff * countofuserstariff) as summaryPrice
		from songs.tariff as t1
		group by t1.tariffid 
		order by pricetariff desc
	) as od on od.tariffid = t.tariffid 
union 
select 'MIN' as Criteria, t.servicetariff, summaryPrice, t.tariffid
from songs.tariff as t join 
	(
		select t1.tariffid, SUM(pricetariff * countofuserstariff) as summaryPrice
		from songs.tariff as t1
		group by t1.tariffid 
		order by pricetariff asc
	) as od on od.tariffid = t.tariffid 


--13. Инструкция SELECT, использующая вложенные подзапросы с уровнем вложенности 3. 
-- Информация о стоимости тарифов, оканчивающтхся позже  01.01.2022

select *
from Songs.Tariff as t1
where tariffid in (select t2.tariffid
				   from Songs.Tariff as t2
				   where pricetariff > all (select t3.tariffid
									  		from Songs.Tariff as t3
									  		where Date(deadlinetariff) > '2022-01-01'))


--14. Инструкция SELECT, консолидирующая данные с помощью предложения GROUP BY, но без предложения HAVING
-- Количество песен определенного жанра
select t.genresong as "Genre",
		count(*) as "Count"
from Songs.Songs as t
group by t.genresong

	
--15. Инструкция SELECT, консолидирующая данные с помощью предложения GROUP BY и предложения HAVING. 
-- Путевки, средняя цена которых больше средней цены общей
select t.genresong as "Genre",
		count(*) as "Count"
from Songs.Songs as t
group by t.genresong
having count(*) < 90



--16. Однострочная инструкция INSERT, выполняющая вставку в таблицу одной строки значений. 
-- Вставить Пола Маккартни в исполнителей
insert into Songs.Authors (NameAuthor, GenderAuthor, CountryId, BirthDateAuthor)
values ('Paul McCarthney', 'Male', 5, '1942-06-18')

select * from Songs.Authors
alter table Songs.Authors drop column 'column_name'
	

--17. Многострочная инструкция INSERT, выполняющая вставку в таблицу результирующего набора данных вложенного подзапроса. 
-- Вставить Jonh Lennon
insert into Songs.Authors (NameAuthor, GenderAuthor, CountryId, BirthDateAuthor)
select 'Jonh Lennon', t.genderauthor, t.countryid, '1940-10-09'
from Songs.Authors as t
where NameAuthor = 'Paul McCarthney'

select * from Songs.Authors
order by authorid desc


--18. Простая инструкция UPDATE. 
-- Умножить на 1.5 стоимость тарифа, стоимость которого меньше 100
select * from Songs.Tariff

update Songs.Tariff 
set pricetariff = pricetariff * 1.5
where pricetariff < 100


--19. Инструкция UPDATE со скалярным подзапросом в предложении SET. 
-- Вставить среднюю стоимость вместо тарифа, стоимость которого меньше 100
select * from Songs.Tariff

update Songs.Tariff 
set pricetariff = 
(
	select AVG(pricetariff)
	from Songs.Tariff
)
where pricetariff < 100


--20. Простая инструкция DELETE. 
-- Удалить все тарифы, неподдерживающие оффлайн режим
delete from Songs.Tariff 
where offlinemodetariff like 'No'


--21. Инструкция DELETE с вложенным коррелированным подзапросом в предложении WHERE. 
-- Удалить все сервисы, поддерживающие и телефоны, и пк
select * from Songs.services 

delete from songs.services 
where serviceid in 
(
	select serviceid
	from Songs.services 
	where SupportedDeviceService like '%+%'
	order by serviceid desc
)

	
--22. Инструкция SELECT, использующая простое обобщенное табличное выражение
-- Сколько тарифных планов заканчивается в каких годах
with CTE_tariffs(yeartariffs, yearcount) as
(
	select extract(year from DeadlineTariff) as yeartariffs, COUNT(t.tariffid)
	from Songs.Tariff AS t
	group by extract(year from DeadlineTariff)  
)
select * from CTE_tariffs
order by yeartariffs


--23. Инструкция SELECT, использующая рекурсивное обобщенное табличное выражение
-- Фигня какая-то
with recursive Recur(tariffid, pricetariff, countofuserstariff) as
(
    select t.tariffid, t.pricetariff, t.countofuserstariff
    from Songs.Tariff as t
    where t.tariffid = 1
    union all
    select t.tariffid, t.pricetariff, t.countofuserstariff
    from Songs.Tariff as t join Recur as rec on t.tariffid = rec.countofuserstariff
)

select *
from Recur


--24. Оконные функции. Использование конструкций MIN/MAX/AVG OVER() 
-- По жанрам песен минимальная, максимальная и средняя продолжительность
select T.songid, T.genresong,
		T.durationsong  as duration, 
		AVG(T.durationsong) over(partition by T.genresong) as AvgDuration,
		MIN(T.durationsong) over(partition by T.genresong) as MinDuration,
		MAX(T.durationsong) over(partition by T.genresong) as MaxDuration
into newTable
from Songs.Songs as T 
order by duration

select * from newtable 

drop table newtable 


--25. Оконные функции для устранения дублей
create table t ( namesong VARCHAR NOT NULL, authorname VARCHAR NOT NULL, country VARCHAR NOT NULL);
insert into t (namesong, authorname, country) VALUES 
('Imagine', 'Jonh Lennon', 'UK'), ('Yesterday', 'PaulMcCarthney', 'UK'), ('Imagine', 'Jonh Lennon', 'UK'), ('Shamless', 'Weeknd', 'USA');

select * from t 

with t_deleted as(delete from t returning *),
t_inserted as(select namesong, authorname, country, row_number() over(partition by namesong, authorname, country order by namesong, authorname, country) 
 				 rownum from t_deleted) insert into t select namesong, authorname, country
				 from t_inserted where rownum = 1;
				
select * from t
drop table t
