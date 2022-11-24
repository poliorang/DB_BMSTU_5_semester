--lab03

--1
--Скалярная функция
--Количество тарифов, стоимость которых больше CurrentPriceTariff
create or replace function public.priceTariff (CurrentPriceTariff INT)
returns int as
	'select count(CountOfUsersTariff)
	from Songs.Tariff
	where PriceTariff > CurrentPriceTariff'
language SQL

select public.priceTariff(1000)


--2
--Подставляемная табличная функция
--Название, поддерживаемые устройста и страна сервиса, поддерживаемые устройства которого соответствуют заданному
create or replace function supportedDevicesFunc(Divices varchar(10) = 'Phone')
returns table
(
	NameService varchar(100),
	SupportedDeviceService varchar(10),
	NameCountry varchar(100)
)
as 
	'select NameService, SupportedDeviceService, NameCountry
	from Songs.Services s join Country.Countries c on s.CountryId = c.CountryId
	where SupportedDeviceService like Divices'
language SQL

select * from supportedDevicesFunc()
select * from supportedDevicesFunc('PC')


--3
--Многооператорная табличная функция
--Песни, продолжительность которых меньше, чем заданная, и дата создания более ранняя, чем заданная
create or replace function durationSongForDate(duration float, dateRelease date)
returns table
(
	NameSong varchar(100),
	AuthorSong varchar(100),
	ReleaseSong date,
	DurationSong float
) as 
'begin
	return query
	select s.NameSong, s.AuthorSong, s.ReleaseSong, s.DurationSong
	from Songs.Songs s
	where s.DurationSong < duration;

	return query
	select s.NameSong, s.AuthorSong, s.ReleaseSong, s.DurationSong
	from Songs.Songs s
	where s.ReleaseSong < dateRelease;
end;' 
language plpgsql

select * from durationSongForDate(3.0, '01-01-2000');


--4
--Рекурсивная функция
--Числа Фиббоначчи
create or replace function fib(first INT, second INT,max INT)
returns table (fibonacci INT)
as 
'begin
	return query
	select  first;
    if second <= max then
        return query
        select *
        from fib(second, first + second, max);
    end if;
end' 
language plpgsql

select * from fib(1, 1, 13)


--5
--Хранимая процедура без параметров или с параметрами
--Увеличить стоимость тарифа в данное количество раз, если количество пользователей больше определенного
create or replace procedure changePrice
(
	coeff float,
	CountOfUser int	
)
as 
'begin
	update Songs.Tariff
    set PriceTariff = (PriceTariff * coeff)
    where CountOfUsersTariff > CountOfUser;
end;' 
language plpgsql
   
call changePrice(1.5, 90000)
select * from Songs.Tariff where CountOfUsersTariff > 90000 order by CountOfUsersTariff


--6
--Рекурсивная хранимая процедура или хранимая процедура с рекурсивным ОТВ
--Числа Фибоначчи
create or replace procedure fib_index
(
	res inout int,
	index_ int,
	start_ int default 1, 
	end_ int default 1
)
as 
'BEGIN
	IF index_ > 0 THEN
		res = start_ + end_;
		CALL fib_index(res, index_ - 1, end_, start_ + end_);
	END IF;
END;' 
language plpgsql

call fib_index(1, 5)


--7
--Хранимая процедура с курсором
--Названия тарифов, которые начинаются на заданную подстроку
create or replace procedure TariffTitle
(
	inputText varchar(100)
)
as 
'declare
	title varchar(100);
    myCursor cursor 
	for
        select TitleTariff
		from Songs.Tariff t
		where TitleTariff like inputText;
begin
    open myCursor;
    loop
        fetch myCursor
        into title;
        exit when not found;
        raise notice ''Tariff Title =  %'', title;
    end loop;
    close myCursor;
end;'
language plpgsql;

call TariffTitle('A%');


--8
--Хранимая процедура доступа к метаданным
--Информация о типах полей заданной таблицы
create or replace procedure metaData
(
	tablename varchar(100)
)
as 
'declare
	buf record;
    myCursor cursor 
	for
        select column_name, data_type
		from information_schema.columns
        where table_name = tablename;
begin
    open myCursor;
    loop
		fetch myCursor
        into buf;
		exit WHEN NOT FOUND;
        raise notice ''column = %; data type = %'', buf.column_name, buf.data_type;
    end loop;
	close myCursor;
end;' 
language plpgsql;

call metaData('services');


--9
--Триггер AFTER

--Создаем временную таблицы
select * 
into countryTmp
from Country.Countries

--Создаем функцию для триггера
create or replace function updateTrigger()
returns trigger
as 
'begin
	raise notice ''New =  %'', new;
    raise notice ''Old =  %'', old; 
	update countryTmp
	set countryid = new.countryid
	where countryTmp.countryid = old.countryid;
	
	return new;
end;' 
language plpgsql;

--Создаем триггер
create trigger update_my
after update on countryTmp 
for each row 
execute procedure updateTrigger();

--Изменяем поле (при изменении сработает триггер)
update countryTmp 
set namecountry = 'bbbbb'
where countryid = 1

--Проверяем, что название страны с ид 1 не изменилось
select * from countryTmp order by countryid 


--10
--Триггер INSTEAD OF

--Делаем временную вью
create view songsTMP as 
select * 
from songs.songs
select * from songsTMP

--drop view songsTMP

--Создаем функцию для триггера
create or replace function deleteForCountry()
returns trigger 
as 
'begin
    raise notice ''New =  %'', new;
    update songsTMP
    set NameSong = ''none'' 
    where songsTMP.NameSong = old.NameSong;
    return new;
end;' 
language plpgsql;

--drop trigger deleteForCountryTrigger on songsTMP

--Создаем триггер
create trigger deleteForCountryTrigger
instead of delete on songsTMP
	for each row
	execute procedure deleteForCountry()

--Пытаемся удалить кортеж по условию
delete from songsTMP 
where songsTMP.countryid = 2

--Проверяем, что имена просто заменили на none, но не удалились
select * from songsTMP order by countryid





-- Защита
--Хранимая процедура доступа к метаданным
--По названию таблицы вывести количество записей
create or replace procedure metaData
(
	tablename varchar(100)
)
as 
'
begin
	select count(column_name)
	from information_schema.columns
    where table_name = tablename;
end;' 
language plpgsql;


create or replace function metaSongs(song varchar)
returns int as
'
begin
	select count(column_name)
	from information_schema.columns
    where table_name = tablename;
end;'
language plpgsql;

select metaSongs('songs');



create or replace procedure met
(
	tablename varchar(100)
)
as 
'declare
	buf record;
    myCursor cursor 
	for
        select count(*) as c
		from information_schema.columns 
        where table_name = tablename;
begin
    open myCursor;
    loop
		fetch myCursor
        into buf;
		exit WHEN NOT FOUND;
        raise notice ''% - column = %;'', tablename, buf.c;
    end loop;
	close myCursor;
end;' 
language plpgsql;

call met('songs');


create or replace function calcucale (tablename varchar)
returns int as
	'begin
		select count(*)
		from db[tablename];
	end;'
language plpgsql;

select calcucale("songs")


--Еще запросики
--Наименьшая длина песни, из множества песен, которые были написаны в заданный промежуток времени
create or replace function public.dateSong (minDate date, maxDate date)
returns float as
	'select min(durationSong)
	from Songs.Songs
	where ReleaseSong > minDate and ReleaseSong < maxDate'
language SQL

select public.dateSong('1-10-2022', '10-10-2022')

--Средняя продолжительность песен заданной страны
create or replace function public.avgDurationForCountry (id int)
returns float as
	'select avg(durationSong)
	from Songs.Songs s join Country.Countries c on s.CountryId = c.CountryId
	where s.CountryId = id'
language SQL

select public.avgDurationForCountry(1)


--Имена, гендер и дата рождения авторов, которые родились в указанный промежуток
create or replace function BirthDateAuthorFunc(minDate date, maxDate date)
returns table
(
	NameAuthor varchar(100),
	GenderAuthor varchar(7),
	BirthDateAuthor date
)
as 
	'select NameAuthor, GenderAuthor, BirthDateAuthor
	from Songs.Authors
	where BirthDateAuthor > minDate and BirthDateAuthor < maxDate'
language SQL

select * from BirthDateAuthorFunc('01-01-1980', '01-01-1990')

--Старны и их ID по заданному названию страны
create or replace function NameCountryFunc(name varchar(100))
returns table
(
	CountryId int,
	NameCountry varchar(100)
)
as 
	'select CountryId, NameCountry
	from Country.Countries
	where NameCountry like name'
language SQL
	
select * from NameCountryFunc('Spain')

--Авторы, чье имя начинается на заданную подстроку, и их страна
create or replace function authorCountry(author varchar(100))
returns table
(
	NameAuthor varchar(100),
	NameCountry varchar(100)
) as 
'begin
	return query
	select t.NameAuthor, t.NameCountry
	from (Songs.Authors s join country.countries c on s.countryid = c.countryid) as t
	where t.NameAuthor like author;
end;' 
language plpgsql

select * from authorCountry('J%')
