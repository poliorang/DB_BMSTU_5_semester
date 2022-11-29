from py_linq import *
from songs import *


def request_1(songs):
	result = songs.where(lambda x: x['durationsong'] > 1.0).order_by(lambda x: x['durationsong']).select(
		lambda x: {x['namesong'], x['authorsong'], x['durationsong']})
	return result


def request_2(songs):
	result = Enumerable([({songs.count(lambda x: x['authorsong'] > 'X')})])
	return result


def request_3(songs):
	result = Enumerable([{songs.min(lambda x: x['durationsong']), songs.max(lambda x: x['durationsong'])}])
	return result


def request_4(songs):
	result = songs.group_by(key_names=['countryid'], key=lambda x: x['countryid']).\
		select(lambda g: {'Country id': g.key.countryid, 'Count of fields': g.count()})
	return result


def request_5(songs, countries):
	result = songs.join(countries, lambda s: s['countryid'], lambda c: c['countryid'])
	return result


def print_first_requests(request, count=5):
	for i in range(0, count):
		if not request[i]:
			break
		print(request[i])


def task_1():
	songs = Enumerable(create_song('../csv/songs.csv'))
	countries = Enumerable(create_country('../csv/countries.csv'))

	print('\n1. Songs longer than 1 minute:')
	print_first_requests(request_1(songs))

	print(f'\n2. Count of authors whose last name begins with the letter > X:')
	print_first_requests(request_2(songs))

	print('\n3. Maximum and minimum song duration:')
	print_first_requests(request_3(songs))

	print('\n4.Group by country filed:')
	print_first_requests(request_4(songs))

	print('\n5. Connecting a song and a country:\n')
	print_first_requests(request_5(songs, countries))
