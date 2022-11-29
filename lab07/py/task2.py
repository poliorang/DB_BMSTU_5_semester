from songs import *
import json
import config

def read_table_json(cursor, count=5):
    cursor.execute("select * from songs_json")

    rows = cursor.fetchmany(count)
    array = list()
    for elem in rows:
        array.append(Songs(elem[0], elem[1], elem[2], elem[3],
                           elem[4], elem[5], elem[6]))

    print(f"{'id':<2} {'namesong':<30} {'authorsong':<28} {'countryid':<10} "
          f"{'releasesong':<13} {'genresong':<12} {'durationsong':<5}")
    print(*array, sep='\n')

    return array


def output_json(array):
    for elem in array:
        print(json.dumps(elem.get()))


def update_songs(songs, current_id, new_id):
    for elem in songs:
        if elem.countryid == current_id:
            elem.countryid = new_id
    output_json(songs)


def add_song(songs, new_song):
    songs.append(new_song)
    output_json(songs)


def task_2():
    connection = config.start_connection()
    cursor = connection.cursor()

    print("1. Read from JSON:")
    songs_array = read_table_json(cursor)

    print("\n2. Update JSON:")
    current_id = int(input("Input current country id: "))
    new_id = int(input("Input new country id: "))
    update_songs(songs_array, current_id, new_id)

    print("\n3. Write to JSON:")
    name = input("Song name: ")
    author = input("Author name: ")
    country_id = int(input("Country id (1-999): "))
    release = input("Date of release (yyyy-mm-dd): ")
    genre = input("Genre: ")
    duration = float(input("Duration: "))
    add_song(songs_array, Songs(21, name, author, country_id, release, genre, duration))

    config.stop_task(connection, cursor)