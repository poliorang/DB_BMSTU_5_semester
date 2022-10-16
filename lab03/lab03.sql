drop function authorCountry(author varchar(100))

--------Скалярная функция--------

--Количество тарифов, стоимость которых больше CurrentPriceTariff
create or replace function public.priceTariff (CurrentPriceTariff INT)
returns int as
	'select count(CountOfUsersTariff)
	from Songs.Tariff
	where PriceTariff > CurrentPriceTariff'
language SQL

select public.priceTariff(1000)

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



--------Подставляемная табличная функция--------

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



--------Многооператорная табличная функция--------

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



--------Рекурсивная функция--------

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



--Рекурсивная хранимая процедура или хранимая процедура с рекурсивным ОТВ
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






