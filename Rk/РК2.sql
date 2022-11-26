-- Вариант 3

-- 1.1
create database rk2;

-- Создать таблицы
create table if not exists department
(
	department_id int generated always as identity primary key,
	department_name varchar(100),
	description varchar(100)
);


create table if not exists discipline
(
	discipline_id int generated always as identity primary key,
	discipline_name varchar(100),
	hours int, 
	semester int,
	rating int
);


create table if not exists teacher
(
	teacher_id int generated always as identity primary key,
	fio varchar(100),
	teacher_degree varchar(100),
	post varchar(100),
	
	department_id int
);


-- Связка таблиц teacher и discipline (многие ко мноким)
create table teacher_discipline(
    id int generated always as identity primary key,
    teacher_id int not null,
    discipline_id int not null
);

-- Добавить foreign keys
alter table teacher
    add constraint for_key foreign key (department_id) references department(department_id);


alter table teacher_discipline
    add constraint for_key_1 foreign key (teacher_id) references teacher(teacher_id),
    add constraint for_key_2 foreign key (discipline_id) references discipline(discipline_id);
   

-- Заполнить данными
insert into department(department_name, description)
values ('IU1', 'ps'),
		('IU2', 'ps'),
		('IU3', 'network'),
		('IU4', 'chemistry'),
		('IU5', 'evm'),
		('IU6', 'evm'),
		('IU7', 'pe'),
		('IU8', 'is'),
		('IU9', 'math'),
		('IU10', 'is')
		
		
insert into discipline(discipline_name, hours, semester, rating)
values ('Diffury', 150, 2, 2),		
		('Integrals', 140, 1, 3),	
		('CG', 200, 4, 1),
		('DB', 180, 5, 5),
		('AA', 120, 5, 5),
		('TV', 200, 2, 3),
		('OOP', 140, 3, 4),
		('LITA', 90, 4, 4),
		('MA', 190, 2, 3),
		('CA', 80, 4, 2)
		

insert into teacher(fio, teacher_degree, post, department_id)
values ('Егоров А.А.', 'Профессор', 'Доцент', 7),
       ('Вагапов С.А.', 'Доцент', 'Декан', 1),
       ('Гуров Е.П.', 'Консультант', 'Аспирант', 3),
       ('Альметьев З.П.', 'Консультант', 'Доцент', 6),
       ('Петров С.А.', 'Аспирант', 'Зам. декана', 5),
       ('Винокуршин С.А.', 'Профессор', 'Лаборант', 4),
       ('Шабанова С.А.', 'Старший Лаборант', 'Старший преподаватель', 8),
       ('Сапожков К.В.', 'Аспирант', 'Старший Лаборант', 2),
       ('Чепиго Р.У.', 'Доцент', 'Консультант', 10),
       ('Янг И.Ш.', 'Старший Лаборант', 'Аспирант', 9)
       

insert into teacher_discipline(teacher_id, discipline_id)
values (1, 2),
		(2, 5),
		(3, 5),
		(4, 3),
		(5, 1),
		(6, 8),
		(7, 9),
		(8, 10),
		(9, 7),
		(10, 4)
       
-- Проверить содержимое     
select * from department
select * from discipline
select * from teacher
select * from teacher_discipline



-- 2.1 - select, использующая предикат сравнния с квантором
-- Выводит название и количество часов дисциплин, количество часов которых меньше 200

select discipline_name, hours
from discipline
where hours < 200


-- 2.2 -- select, использующая агрегатные функции в выражениях столбцов
-- Количество доцентов

select count(post)
from teacher
where post like 'Доцент'
		

-- 2.3 -- Создание новой временной локальной таблицы из результирующего набора данных инструкций select
-- В новую таблицу помещается название дисциплины и номер семестра, в котором она идет

select discipline_name, semester
into new_table
from discipline
where discipline_name in 
(
	select discipline_name
	from discipline
	where discipline_name in 
	(
		select discipline_name
		from discipline
		where semester < 3
	)
)
order by semester asc	
	
	
select * from new_table
		


-- 3
-- Хранимая процедура, которая удаляет дубликаты записей 
-- из указанной таблицы в текущей БД, с входным параметром "Имя таблицы"

create or replace procedure remove_duplicate(current_table varchar(100))
as '
begin
    execute ''
        create table table_for_proc as
        select distinct *
        from '' || current_table;
    execute ''
        drop table '' || current_table;
    execute ''
    alter table table_for_proc rename to '' || current_table;
end;
' language plpgsql;

-- тестирование

-- тестовая таблица
create table if not exists test
(
	id int,
    num int
)

insert into test(id, num) 
values (1, 1),
		(2, 2),
		(3, 3),
		(4, 4),
		(2, 2)

-- применить процедуру к таблице
call remove_duplicate('test')

-- проверить работу процедуры
select * from test

