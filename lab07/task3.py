from peewee import *
import config

con = PostgresqlDatabase(
    database=config.db_name,
    user=config.db_user,
    password=config.ds_pass,
    host=config.db_host,
    port=config.db_port,
)


class BaseModel(Model):
    class Meta:
        database = con


class Songs(BaseModel):
    songid = PrimaryKeyField(column_name='songid')
    namesong = CharField(column_name='namesong')
    authorsong = CharField(column_name='authorsong')
    countryid = IntegerField(column_name='countryid')
    releasesong = CharField(column_name='releasesong')
    genresong = IntegerField(column_name='genresong')
    durationsong = FloatField(column_name='durationsong')

    class Meta:
        table_name = 'songs_json'


class Countires(BaseModel):
    countryid = PrimaryKeyField(column_name='countryid')
    namecountry = CharField(column_name='namecountry')

    class Meta:
        table_name = 'countries_json'


def query_1():
    print("\nQuery 1:")

    query = Songs.select(Songs.songid, Songs.namesong, Songs.durationsong).\
        limit(5).order_by(Songs.songid.desc()).where(Songs.durationsong > 3.0)

    print("Songs with duration > 3.0:")
    for elem in query.dicts().execute():
        print(elem)


def query_2():
    print("\nQuery 2:")

    print("Join songs and countries:")
    query = Songs.select(Songs.songid, Songs.namesong, Countires.namecountry).join(Countires, on=(
                Songs.countryid == Countires.countryid)).order_by(Songs.songid).limit(5)

    for elem in query.dicts().execute():
        print(elem)


def add_song(namesong, authorsong, countryid, releasesong, genresong, durationsong):
    Songs.create(namesong=namesong, authorsong=authorsong, countryid=countryid,
                 releasesong=releasesong, genresong=genresong, durationsong=durationsong)
    print(">> Added")


def update_name(songid, new_name):
    song = Songs.get(songid=songid)
    song.namesong = new_name
    song.save()
    print(">> Updated")


def del_songs(songid):
    try:
        songs = Songs.get(songid=songid)
        songs.delete_instance()
        print(">> Deleted")
    except:
        print(">> Record does not exist")


def query_3():
    print("\nQuery 3:")
    print_last_five_fields()

    print("Add song:")
    add_song("AA", "BB", 111, "2000-01-01", "pop", 4.4)
    print_last_five_fields()

    print("Update song:")
    update_name(3010, 'aaa')
    print_last_five_fields()

    print("Delete song:")
    del_songs(3010)
    print_last_five_fields()


def query_4():
    cursor = con.cursor()

    print("\nQuery 4:")
    print_last_five_fields_on_duration_desc()

    print("Increase the duration of songs in 1.1 with current duration > 3.0:")
    cursor.execute("call changeDuration(1.1, 3.0)")
    con.commit()

    print_last_five_fields_on_duration_desc()
    print(">> Procedure is completed")
    cursor.close()


def print_last_five_fields():
    query = Songs.select().limit(5).order_by(Songs.songid.desc())
    for elem in query.dicts().execute():
        print(elem)
    print()


def print_last_five_fields_on_duration_desc():
    query = Songs.select(Songs.songid, Songs.namesong, Songs.durationsong).limit(5).order_by(Songs.durationsong.desc())
    for elem in query.dicts().execute():
        print(elem)
    print()


def task_3():
    global con

    query_1()
    query_2()
    # query_3()
    query_4()

    con.close()
