# Task:
# - Find the first and last digits OR words that spell out a digit in each string.
# - Append them together to create a two-digit number.
# - Sum all such numbers into a single total.
# - This total is the answer to the puzzle.

import re

file1 = open('input.txt', 'r')
lines = file1.readlines()

digits = {
    "one": 1,
    "two": 2,
    "three": 3,
    "four": 4,
    "five": 5,
    "six": 6,
    "seven": 7,
    "eight": 8,
    "nine": 9,
    "zero": 0,
    1: 1,
    2: 2,
    3: 3,
    4: 4,
    5: 5,
    6: 6,
    7: 7,
    8: 8,
    9: 9,
    0: 0,
}

coordinate_sum = 0
for line in lines:
    first_index, second_index = -1, -1
    first_num, second_num = None, None
    for num in digits.keys():
        try:
            index = line.index(str(num))
            if index < first_index or first_index == -1:
                first_index = index
                first_num = digits[num]
        except ValueError:
            # index not found
            continue

        try:
            index = line.rindex(str(num))
            if index > second_index or second_index == -1:
                second_index = index
                second_num = digits[num]
        except ValueError:
            # index not found
            continue
    coordinate = int(f'{first_num}{second_num}')
    coordinate_sum += coordinate
    print(f'Line: {line}  Digits: {coordinate}  Sum: {coordinate_sum}')
