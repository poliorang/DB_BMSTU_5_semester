-- songs

create table if not exists songs_json
(
    songid int GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	namesong varchar(100),
	authorsong varchar(100),
	countryid int,
	releasesong varchar(15),
	genresong varchar(100),
	durationsong float
);

copy
(
	select row_to_json(ss) result from songs.songs ss
)
to '/Users/poliorang/Desktop/DB/DB_BMSTU_5_semester/lab07/songs.json'

create table import_songs(
    doc json
);

copy import_songs from '/Users/poliorang/Desktop/DB/DB_BMSTU_5_semester/lab07/songs.json';

select * from import_songs

insert into songs_json(namesong, authorsong, countryid, releasesong, genresong, durationsong)
select doc->>'namesong', doc->>'authorsong', (doc->>'countryid')::int, doc->>'releasesong', doc->>'genresong', (doc->>'durationsong')::float from import_songs

select * from songs_json



-- countries

create table if not exists countries_json
(
    countryid int GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    namecountry varchar(100) 
);

copy
(
	select row_to_json(c) result from country.countries c 
)
to '/Users/poliorang/Desktop/DB/DB_BMSTU_5_semester/lab07/countries.json'


create table import_countries(
    doc json
);

copy import_countries from '/Users/poliorang/Desktop/DB/DB_BMSTU_5_semester/lab07/countries.json';

select * from import_countries

insert into countries_json(namecountry)
select doc->>'namecountry' from import_countries

select * from countries_json


-- процедура
create or replace procedure changeDuration
(
	coeff float,
	duration float	
)
as 
'begin
	update songs_json
	set durationsong = (durationsong * coeff)
	where durationsong > duration;
end;' 
language plpgsql

call changeDuration(1.1, 0.0)
select * from songs_json order by durationsong desc


