--1. Из таблиц базы данных, созданной в первой лабораторной работе, извлечь
--данные в XML (MSSQL) или JSON(Oracle, Postgres). Для выгрузки в XML
--проверить все режимы конструкции FOR XML

select row_to_json(sa)
from Songs.Authors sa;

select row_to_json(su)
from Songs.Users su;

select row_to_json(st)
from Songs.Tariff st;

select row_to_json(ss)
from Songs.Songs ss;

select row_to_json(cc)
from Country.Countries cc;


--2. Выполнить загрузку и сохранение XML или JSON файла в таблицу.
--Созданная таблица после всех манипуляций должна соответствовать таблице
--базы данных, созданной в первой лабораторной работе.

create table if not exists Countries_copy(
    CountryId INT generated always as identity primary key,
    NameCountry VARCHAR(100) 
);

-- надо через терминал сделать комнду chmod uog+w <имя файла json>
copy
(
	select row_to_json(cc) from Country.Countries cc
)
to '/Users/poliorang/Desktop/DB/DB_BMSTU_5_semester/lab05/countries_copy.json'


create table import_table(
    doc json
);

--drop table import_table

copy import_table from '/Users/poliorang/Desktop/DB/DB_BMSTU_5_semester/lab05/countries_copy.json';

insert into Countries_copy(NameCountry)
select doc->>'namecountry' from import_table;

select * from Countries_copy


--3. Создать таблицу, в которой будет атрибут(-ы) с типом XML или JSON, или
--добавить атрибут с типом XML или JSON к уже существующей таблице.
--Заполнить атрибут правдоподобными данными с помощью команд INSERT
--или UPDATE.

create table if not exists task3_table(
	id int primary key,
	song varchar(40),
	info json
)

insert into task3_table(id, song) values
(1, 'Help'), (2, 'Hello'), (3, 'i dont care')

insert into task3_table(id, song) values
(4, 'aaa')

update task3_table
set info='{"country": "England", "author": "Beatles"}'::json
where id = 1;

update task3_table
set info='{"country": "USA", "author": "Adele"}'::json
where id = 2;

update task3_table
set info='{"country": "USA", "author": "Icona pop"}'::json
where id = 3;

select * from task3_table

--4. Выполнить следующие действия:
--4.1. Извлечь XML/JSON фрагмент из XML/JSON документа
select info as countryAndAuthor
from task3_table
where id = 2;


--4.2. Извлечь значения конкретных узлов или атрибутов XML/JSON документа
select info->>'country' as info
              from task3_table
              where id = 2;

             
--4.3. Выполнить проверку существования узла или атрибута jsonb
select *
from task3_table
where json_extract_path(info, 'author') is not null;
             

--4.4. Изменить XML/JSON документ
update task3_table
set info = info::jsonb || '{"author": "wwww"}'::jsonb
where id = 1

--4.5. Разделить XML/JSON документ на несколько строк по узлам
select
    json_extract_path(info, 'country') info,
    json_extract_path(info, 'author') colors
from task3_table
where info is not null;


