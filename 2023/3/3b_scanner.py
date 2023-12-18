# x-1:x+1, y-1:y+1
# Check for digits
# For each digit, scan for a number string
# for all number strings, remove duplicates (based on positions)
# if exactly 2 number strings remain, do gear_ratio stuff


import re

file_path = 'input.txt'


class Schematic:
    def __init__(self, strings):
        self.schematic = strings

    def get_neighbour_matches(self, x, y):
        neighbour_matches = []
        for ny in range(y - 1, y + 2):
            for nx in range(x - 1, x + 2):
                if self.schematic[ny][nx] in "0123456789":
                    new_match = self.get_number_match(nx, ny)
                    neighbour_matches.append(new_match)
        neighbour_matches = list(dict.fromkeys(neighbour_matches))
        return neighbour_matches

    def get_number_match(self, x, y):
        line = self.schematic[y]
        for match in re.finditer('[0-9]+', line):
            if match.start() <= x <= match.end():
                return match


def dedupe_match_list(match_list):
    new_match_list = []
    for match in match_list:
        matched = False
        for new_match in new_match_list:
            if (match.start() == new_match.start() and match.end() == new_match.end()
                    and match.group() == new_match.group()):
                matched = True
                break
        if not matched:
            new_match_list.append(match)

    return new_match_list


def main(path):
    with open(path, 'r') as file1:
        schematic = Schematic(file1.readlines())
        gear_ratio_sum = 0
        for line_idx, line in enumerate(schematic.schematic):
            for match in re.finditer('(\*)+', line):
                gear_neighbours = schematic.get_neighbour_matches(match.start(), line_idx)
                gear_neighbours = dedupe_match_list(gear_neighbours)
                print(f'{line_idx=}, {gear_neighbours=}')
                if len(gear_neighbours) == 2:
                    gear_ratio_sum += (int(gear_neighbours[0].group()) * int(gear_neighbours[1].group()))
        print(f'{gear_ratio_sum}')

if __name__ == "__main__":
    main(file_path)
