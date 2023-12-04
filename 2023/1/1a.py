# Task:
# - Find the first and last digits in each string.
# - Append them together to create a two-digit number.
# - Sum all such numbers into a single total.
# - This total is the answer to the puzzle.

file1 = open('input.txt', 'r')
lines = file1.readlines()

coordinate_sum = 0
for line in lines:
    digits = [int(c) for c in line if c.isdigit()]
    coordinate = int(f'{digits[0]}{digits[-1]}')
    coordinate_sum += coordinate
    print(f'Coordinate: {coordinate} - Sum: {coordinate_sum}')
