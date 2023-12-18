# Get locations of symbols in the schematic
# for each number, find if there is an adjacent symbol
#    if so, add the number to the sum

import re

file_path = 'sample.txt'


def count_symbols(symbol_locations):
    symbol_count = 0
    for row in symbol_locations:
        symbol_count += len(symbol_locations[row])
    print(f'{symbol_count=}')


def get_gear_locations(lines):
    gear_locations = {}
    for line_idx, line in enumerate(lines):
        for char_idx, char in enumerate(line):
            if char == '*':
                try:
                    gear_locations[line_idx] += [char_idx]
                except KeyError:
                    gear_locations[line_idx] = []
                    gear_locations[line_idx] += [char_idx]
                print(f'Symbol found! {char} at [{line_idx}, {char_idx}]')
    return gear_locations


def main():
    with open(file_path, 'r') as file1:
        lines = file1.readlines()
        part_numbers = []
        part_number_sum = 0
        gear_locations = get_gear_locations(lines)
        count_symbols(gear_locations)
        for line_idx, line in enumerate(lines):
            for match in re.finditer(r'[0-9]+', line):
                x1 = match.start() - 1
                x2 = match.end()
                has_symbol = False
                for y in range(line_idx - 1, line_idx + 2):
                    if y in gear_locations:
                        for symbol_x in gear_locations[y]:
                            if x1 <= symbol_x <= x2:
                                # print(f'Match: {match_str} - Symbol found at ({y},{symbol_x})')
                                has_symbol = True
                                part_numbers.append(int(match.group(0)))
                                part_number_sum += int(match.group(0))
                                print(f'Adding part number {match.group(0)} from {line_idx}. New total: {part_number_sum}')
                                break
                        if has_symbol:
                            break
                else:
                    print(f'No gear found: {match.group(0)} on line {line_idx}')
        print(f'Part number sum: {part_number_sum}')
        print(f'Sum of part numbers: {sum(part_numbers)}')
        print(f'Gear locations: {gear_locations}')


main()
