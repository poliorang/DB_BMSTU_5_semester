create extension plpython3u;


-- 1 -- Определяемая пользователем скалярная функция
-- Больше ли, чем 1000, цена тарифа - да/нет
create or replace function is_expensive(price INT)
returns varchar as
$$
    if (price > 1000):
        return "Yes"
    else:
        return "No"
$$ language plpython3u;

select TitleTariff, PriceTariff, is_expensive(PriceTariff)
from songs.tariff


-- 2 -- Пользовательская агрегатная функция
-- Выведет количество тарифов, id которых больше, чем заданный параметр
create or replace function count_tariffs_in_order(id INT)
returns int as
$$
	plan = plpy.prepare("SELECT * FROM Songs.Tariff WHERE tariffid > $1", ["int"])
	res = plpy.execute(plan, [id])
	count_products = 0
	if res is not None:
		for i in res:
			count_products += 1
	return count_products
$$ language plpython3u;

select TariffId, count_tariffs_in_order(TariffId)
from Songs.Tariff;


-- 3 - Определяемая пользователем табличная функция 
-- Тарифы, цена которых меньше заданного параметра
create or replace function orders_with_price(price INT)
returns table (Tariffid int, TitleTariff varchar, PriceTariff int, DeadlineTariff date) as
$$
	plan = plpy.prepare("SELECT * FROM Songs.Tariff WHERE PriceTariff < $1", ["int"])
	res = plpy.execute(plan, [price])
	res_table = list()
	if res is not None:
		for i in res:
			res_table.append(i)
	return res_table
$$ language plpython3u;

select * from orders_with_price(100);


-- 4 - Хранимая процедура
-- Изменить цену тарифа на заданную, если количесто пользователей тарифа равно заданному 
create or replace procedure update_tariff_price(price int, id int) as 
$$
    plan = plpy.prepare("update Songs.Tariff set PriceTariff = $1 where CountOfUsersTariff = $2", ["int", "int"])
    plpy.execute(plan, [price, id])
$$ language plpython3u;

call update_tariff_price(20, 60345);

select * from Songs.Tariff
where CountOfUsersTariff = 60345;


-- 5 - Триггер
-- Реакция на изменение цены тарифа с определенным id
create or replace function update_trigger()
returns trigger as
$$
	plpy.notice("Some tariffs changed")
$$ language plpython3u;

drop trigger update_my on songs.tariff;

create  trigger update_my
after update on songs.tariff 
for each row
execute procedure update_trigger();

update songs.tariff  
set PriceTariff = 100
where tariffid = 9;

select * from Songs.Tariff
where tariffid = 9;


-- 6 - Определяемый пользователем тип данных
-- Тип - ид, цена и количество пользователей тарифа, вывести по id 
create type tariff_base_info as
(
    Tariffid int,
    PriceTariff int,
    countOfUsersTariff int
);

--setof для множества параметров
create or replace function tariff_base_info(id int)
returns setof tariff_base_info as
$$
	plan = plpy.prepare("SELECT Tariffid, PriceTariff, countOfUsersTariff FROM songs.tariff WHERE Tariffid = $1", ["int"])
	res = plpy.execute(plan, [id])
	if res is not None:
		return res
$$ language plpython3u;

select * from tariff_base_info(2);
