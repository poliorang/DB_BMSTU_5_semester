from task1 import *
from task2 import *
from task3 import *

MENU = """
0. Exit
1. Task 1
2. Task 2
3. Task 3
"""


def get_action(action_number: int):
    if action_number == 0:
        return exit(0)
    elif action_number == 1:
        return task_1()
    elif action_number == 2:
        return task_2()
    elif action_number == 3:
        return task_3()
    else:
        print('Please repeat')


def main_cycle():

    while True:
        print(MENU)
        try:
            selected = int(input(">> "))
            get_action(selected)
        except Exception as e:
            print(f'Error occurred: {e}')


def main():
    main_cycle()


if __name__ == "__main__":
    main()
