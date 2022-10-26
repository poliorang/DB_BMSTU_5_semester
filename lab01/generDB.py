from faker import Faker
from random import randint, choice, uniform
import requests

MAX_N = 1000

company_suffix = ['. Inc', '. Co', '. Corp', '. LLC', '. Ltd']
gender = ['male', 'female']
genre = ['classic', 'soul', 'blues', 'country', 'rock', 'r&b', 'pop', 'jazz', 'hip-hop', 'electronic', 'folk']
supported_devices = ['PC', 'Phone', 'PC+Phone']


def get_words(https):
    word_site = https
    response = requests.get(word_site)
    words = response.content.splitlines()

    return words

WORDS = get_words("https://www.mit.edu/~ecprice/wordlist.10000")


def generate_country():
    faker = Faker()
    f = open('countries.csv', 'w')
    for i in range(MAX_N):
        line = "{0}\n".format(faker.country())
        f.write(line)
    f.close()


def generate_songs():
    faker = Faker()
    f = open('songs.csv', 'w')
    for i in range(MAX_N):
        names = [str(choice(WORDS))[2:-1], str(choice(WORDS))[2:-1] + ' ' + str(choice(WORDS))[2:-1], str(choice(WORDS))[2:-1] + ' ' + str(choice(WORDS))[2:-1] + ' ' + str(choice(WORDS))[2:-1]]
        line = "{0};{1};{2};{3};{4};{5}\n".format(
            choice(names).title(),
            faker.name(),
            randint(1, 999),
            str(faker.date_time_between(start_date='-30y', end_date='now'))[:-9],
            choice(genre),
            round(uniform(1.5, 5.5), 2))
        f.write(line)
    f.close()


def generate_authors():
    faker = Faker()
    f = open('authors.csv', 'w')
    for i in range(MAX_N):
        line = "{0};{1};{2};{3}\n".format(
            faker.name(),
            choice(gender),
            randint(1, 999),
            str(faker.date_time_between(start_date='-80y', end_date='-20y'))[:-9])
        f.write(line)
    f.close()


def generate_services():
    faker = Faker()
    f = open('services.csv', 'w')
    for i in range(MAX_N):
        names = [str(choice(WORDS))[2:-1], str(choice(WORDS))[2:-1] + ' ' + str(choice(WORDS))[2:-1], str(choice(WORDS))[2:-1]]
        line = "{0};{1};{2};{3};{4};{5};{6}\n".format(
            choice(names).title(),
            choice(supported_devices),
            randint(0, 100000),
            str(choice(WORDS))[2:-1].title() + choice(company_suffix),
            randint(1, 999),
            '+' + str(randint(10000000000, 79999999999)),
            'Dir' + faker.name())
        f.write(line)
    f.close()


def generate_users():
    faker = Faker()
    f = open('users.csv', 'w')
    for i in range(MAX_N):
        names = [str(choice(WORDS))[2:-1], str(choice(WORDS))[2:-1] + ' ' + str(choice(WORDS))[2:-1],
                 str(choice(WORDS))[2:-1]]
        line = "{0};{1};{2};{3};{4}\n".format(
            faker.name(),
            str(faker.date_time_between(start_date='-70y', end_date='-18y'))[:-9],
            randint(1, 100000),
            str(faker.date_time_between(start_date='-5y', end_date='now'))[:-9],
            choice(names).title())
        f.write(line)
    f.close()


def generate_tariff():
    faker = Faker()
    f = open('tariffs.csv', 'w')
    for i in range(MAX_N):
        names = [str(choice(WORDS))[2:-1], str(choice(WORDS))[2:-1] + ' ' + str(choice(WORDS))[2:-1],
                 str(choice(WORDS))[2:-1]]
        line = "{0};{1};{2};{3};{4};{5}\n".format(
            choice(names).title(),
            choice(names).title(),
            str(faker.date_time_between(start_date='now', end_date='+2y'))[:-9],
            randint(50, 1500),
            randint(0, 10 ** 5),
            choice(["Yes", "No"]))
        f.write(line)
    f.close()


if __name__ == "__main__":
    # generate_country()
    # generate_songs()
    generate_services()
    # generate_authors()
    # generate_users()
    # generate_tariff()