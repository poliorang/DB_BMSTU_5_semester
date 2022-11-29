import psycopg2

db_name = 'postgres'
db_user = 'postgres'
ds_pass = 'postgres'
db_host = 'localhost'
db_port = '5432'


def start_connection():
    try:
        connection = psycopg2.connect(
            database=db_name,
            user=db_user,
            password=ds_pass,
            host=db_host,
            port=db_port,
        )
        return connection
    except Exception as e:
        print(f'Error occurred: {e}')


def stop_task(connection, cursor):
    connection.close()
    cursor.close()
