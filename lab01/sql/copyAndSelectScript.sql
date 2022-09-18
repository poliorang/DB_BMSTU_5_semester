copy Songs.Authors(NameAuthor, GenderAuthor, CountryId, BirthDateAuthor) from '/Users/poliorang/Desktop/DB/DB_BMSTU_5_semester/lab01/authors.csv' delimiter ';';
select * from Songs.Authors

copy Songs.Users(NameUser, BirthDateUser, NumberUser, StartSubscriptionUser, TariffUser) from '/Users/poliorang/Desktop/DB/DB_BMSTU_5_semester/lab01/users.csv' delimiter ';';
select * from Songs.Users

copy Songs.Services(NameService, SupportedDeviceService, NumberService, CompanyService, CountryId, PhoneService, DirectorService) from '/Users/poliorang/Desktop/DB/DB_BMSTU_5_semester/lab01/services.csv' delimiter ';';
select * from Songs.Services

copy Songs.Tariff(TitleTariff, ServiceTariff, DeadlineTariff, PriceTariff, CountOfUsersTariff, OfflineModeTariff) from '/Users/poliorang/Desktop/DB/DB_BMSTU_5_semester/lab01/tariffs.csv' delimiter ';';
select * from Songs.Tariff

copy Songs.Songs(NameSong, AuthorSong, CountryId, ReleaseSong, GenreSong, DurationSong) from '/Users/poliorang/Desktop/DB/DB_BMSTU_5_semester/lab01/songs.csv' delimiter ';';
select * from Songs.Songs

copy Country.Countries(NameCountry) from '/Users/poliorang/Desktop/DB/lab01/countries.csv' delimiter ';';
select * from Country.Countries
