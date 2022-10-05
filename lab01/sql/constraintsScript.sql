alter table Songs.Authors add constraint Gender_constraint check (GenderAuthor like 'male' or GenderAuthor like 'female');
alter table Songs.Authors add constraint Country_constraint check (CountryId >= 1 and CountryId <= 1010);

alter table Songs.Services add constraint Country_constraint check (CountryId >= 1 and CountryId <= 999);

alter table Songs.Tariff add constraint check (PriceTariff >= 0 and PriceTariff <= 1500);

alter table Songs.Songs add constraint Country_constraint check (CountryId >= 1 and CountryId <= 999);

