file_path = 'input.txt'

MAX_CUBES = {
    'red': 12,
    'green': 13,
    'blue': 14,
}
game_id_sum = 0

with open(file_path, 'r') as file1:
    for line in file1.readlines():
        game_id = int(line.split(': ')[0].split(' ')[1])
        matches = line.split(': ')[1].split('; ')
        possible = True
        for match in matches:
            cubes = match.split(', ')
            for cube in cubes:
                count, colour = cube.split(' ')
                colour = colour.strip()
                if int(count) > MAX_CUBES[colour]:
                    possible = False
                    print(f'BREAK: Game ID: {game_id}, Colour: {colour}, Count: {count}')
                    break
            else:
                continue
            break
        if possible:
            game_id_sum += game_id

print(f'{game_id_sum}')