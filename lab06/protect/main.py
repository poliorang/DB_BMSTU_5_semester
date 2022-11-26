import config
import psycopg2


MENU = """
0. Exit;
1. Get all fields;
2. Insert new value.
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


def get_all(cursor):
    cursor.execute("""
        select *
        from lab_06""")
    result = cursor.fetchone()
    for ind, value1, value2 in cursor:
        print(f'{ind} : {value1}, {value2}')
    # print(f'Result:\n{result}')

def insert_value(cursor):
    new_value1 = int(input('Enter value 1: '))
    new_value2 = int(input('Enter value 2: '))
    cursor.execute(f"""
        insert into lab_06 (value_1, value_2)
        values ('{new_value1}', '{new_value2}')""")

    print(f'Insert!')



def get_action(action_number: int):
    if action_number == 0:
        return stop_program
    elif action_number == 1:
        return get_all
    elif action_number == 2:
        return insert_value
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
