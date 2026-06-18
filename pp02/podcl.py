from psycopg2 import connect,Error

class Connect:
    def __init__(self):
        self.con = None
        self.cur = None

        try:
            self.con = connect(
                host = 'localhost',
                user = 'postgres',
                password = 'postgres',
                dbname = 'practica',
                port = '5432'
            )
            print('Подключение успешно')

            self.cur = self.con.cursor()
        except Error as e:
            print('Ошибка соединения')
            print(e)

