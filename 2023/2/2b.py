file_path = 'input.txt'

game_power_sum = 0

with open(file_path, 'r') as file1:
    for line in file1.readlines():
        game_id = int(line.split(': ')[0].split(' ')[1])
        min_cubes = {'red': 0, 'green': 0, 'blue': 0}
        matches = line.split(': ')[1].split('; ')
        for match in matches:
            cubes = match.split(', ')
            for cube in cubes:
                count, colour = cube.split(' ')
                colour = colour.strip()
                min_cubes[colour] = max(int(count), min_cubes[colour])
        game_power = min_cubes['red'] * min_cubes['green'] * min_cubes['blue']
        game_power_sum += game_power
        print(f'Power: {game_power} = RED({min_cubes['red']}) * GREEN({min_cubes['green']}) * BLUE({min_cubes['blue']}). Sum power: {game_power_sum}')

print(f'{game_power_sum}')