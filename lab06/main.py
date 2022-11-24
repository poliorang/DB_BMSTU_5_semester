import config
import psycopg2


MENU = """
0. Exit;
1. Get max engine power;
2. Get service and supported devices by car state number;
3. Get young users;
4. Get meta information about table; 
5. Get tariffs more expensive than the specified cost;
6. Get services on supported devices;
7. Сhange the price by a coefficient and number of participants;
8. Print database info;
9. Create table song studios;
10. Insert new song studio.
"""


def start_connection():
    try:
        connection = psycopg2.connect(
            database=config.db_name,
            user=config.db_user,
            password=config.ds_pass,
            host=config.db_host,
            port=config.db_port,
        )
        return connection
    except Exception as e:
        print(f'Error occurred : {e}')


def stop_program(cursor):
    cursor.close()
    exit(0)


def find_max_price_tariff(cursor):
    cursor.execute("""
        select max(PriceTariff)
        from Songs.Tariff""")
    result = cursor.fetchone()[0]

    print(f'Max price of tariff is {result}')
    return float(result)


def find_song_and_country_by_genre(cursor):
    number = input('Enter number of service: ')

    cursor.execute(f"""
        select nameservice, supporteddeviceservice, numberservice
        from Songs.Services s join country.countries c on
        s.countryid = c.countryid
        where numberservice = '{number}'""")

    try:
        nameservice, devices, numberservice = cursor.fetchone()
    except Exception as e:
        print("Nothing found")
        return

    print(f'Service: {nameservice}\nNumber: {numberservice}\nDevices: {devices}')
# 6840

def get_younf_users(cursor):
    cursor.execute(f"""
            with young_users(name, birthday, tariff) 
                as (select NameUser, BirthDateUser, TariffUser
                    from Songs.Users)
            select
                young_users.name,
                young_users.birthday,
                young_users.tariff
            from young_users
            where birthday > '01-01-2004'
            order by birthday desc
    """)

    for name, birthday, tariff in cursor:
        print(f'Person {name} born on {birthday} uses "{tariff}" tariff')


def print_table_info(cursor):
    table_name = input('Enter table name: ')

    cursor.execute(f"""
        select column_name, data_type
        from information_schema.columns
        where table_name = '{table_name}'""")

    for name, data_type in cursor:
        print(f'{name} : {data_type}')
# services


def find_tariffs_more_expensive_price(cursor):
    price = input('Enter price: ')
    cursor.execute(f"""
        select priceTariff('{price}')""")

    count = cursor.fetchone()[0]
    print(f"Count of tariffs are more expensive than {price} is {count}")


def select_services_by_devices(cursor):
    device = input('Enter device(s) (PC/Phone/PC+Phone: ')
    cursor.execute(f"""
        select * from supportedDevicesFunc('{device}')""")

    for name, device, country in cursor:
        print(f'Service: {name} | Country: {country} | Devices: {device}')
# PC


def change_price_by_count_users(cursor):
    try:
        coeff = float(input("Enter coefficient of appreciation: "))
        count_of_users = input("Enter count of users: ")
    except ValueError as e:
        print("Incorrect input")
        return

    cursor.execute(f"""
        call changePrice({coeff}, '{count_of_users}')""")

    print("Done!")
# coeff - 1.2, count - 90000


def print_database_info(cursor):
    cursor.execute("""
        select current_database(), current_user""")
    db, user = cursor.fetchone()

    print(f"db : {db}; user : {user}")


def create_table_song_studio(cursor):
    cursor.execute("""
        create table if not exists song_studio(
            id int generated always as identity primary key,
            studio varchar(128)
    )""")

    print('Table create_table_song_studio with fields\n'
          '\tid bigint generated always as identity primary key\n'
          '\tstudio vatchar(128)\n'
          'has been created')


def insert_on_downloads_of_song(cursor):
    new_studio = input('Enter new studio: ')

    try:
        cursor.execute(f"""
            insert into song_studio (studio)
            values ('{new_studio}')""")
    except Exception as e:
        print(f'An error occurred : {e}')
        return

    print("Success!")


def get_action(action_number: int):
    if action_number == 0:
        return stop_program
    elif action_number == 1:
        return find_max_price_tariff
    elif action_number == 2:
        return find_song_and_country_by_genre
    elif action_number == 3:
        return get_younf_users
    elif action_number == 4:
        return print_table_info
    elif action_number == 5:
        return find_tariffs_more_expensive_price
    elif action_number == 6:
        return select_services_by_devices
    elif action_number == 7:
        return change_price_by_count_users
    elif action_number == 8:
        return print_database_info
    elif action_number == 9:
        return create_table_song_studio
    elif action_number == 10:
        return insert_on_downloads_of_song
    else:
        print('Please repeat')


def main_cycle(connection):
    cursor = connection.cursor()

    while True:
        print(MENU)
        try:
            selected = int(input())
            action = get_action(selected)
            action(cursor)
        except Exception as e:
            print(f'Error occurred : {e}')
        connection.commit()


def main():
    connection = start_connection()
    if connection is None:
        exit(1)

    main_cycle(connection)
    connection.close()


if __name__ == '__main__':
    main()

