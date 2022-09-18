CREATE DATABASE songsDB;
CREATE SCHEMA Country;
CREATE SCHEMA Songs;


CREATE TABLE IF NOT EXISTS Country.Countries(
    CountryId INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    NameCountry VARCHAR(100) 
);


CREATE TABLE IF NOT EXISTS Songs.Authors(
    AuthorId INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	NameAuthor VARCHAR(100),
	GenderAuthor VARCHAR(7),
	CountryId INT,
	BirthDateAuthor DATE,
	FOREIGN KEY (CountryId) REFERENCES Country.Countries(CountryId)
);

CREATE TABLE IF NOT EXISTS Songs.Users(
    UserId INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	NameUser VARCHAR(100),
	BirthDateUser DATE,
	NumberUser INT,
	StartSubscriptionUser VARCHAR(100),
	TariffUser VARCHAR(100)
);

CREATE TABLE IF NOT EXISTS Songs.Services(
    ServiceId INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	NameService VARCHAR(100),
	SupportedDeviceService VARCHAR(100),
	NumberService INT,
	CompanyService VARCHAR(100),
	CountryId INT,
	PhoneService INT,
	DirectorService VARCHAR(100), 
	FOREIGN KEY (CountryId) REFERENCES Country.Countries(CountryId)
);

CREATE TABLE IF NOT EXISTS Songs.Tariff(
    TariffId INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	TitleTariff VARCHAR(100),
	ServiceTariff VARCHAR(100),
	DeadlineTariff DATE,
	PriceTariff INT,
	CountOfUsersTariff INT,
	OfflineModeTariff VARCHAR(3)
);

CREATE TABLE IF NOT EXISTS Songs.Songs(
    SongId INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	NameSong VARCHAR(100),
	AuthorSong VARCHAR(100),
	CountryId INT,
	ReleaseSong DATE,
	GenreSong VARCHAR(100),
	DurationSong FLOAT,
	FOREIGN KEY (CountryId) REFERENCES Country.Countries(CountryId)
);

-- some commands
select * from songs.songs limit(20)
select * from songs.tariff where priceTariff < 100
select genderauthor from songs.authors
select * from Songs.Tariff where OfflineModeTariff like 'No'
select count(*) from songs.services where nameservice like 'T%'
select sum(priceTariff) from songs.tariff where priceTariff < 100
select * from Songs.Authors order by BirthDateAuthor asc 
