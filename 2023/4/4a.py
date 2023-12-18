file_path = 'input.txt'

score = 0
with open(file_path, 'r') as file1:
    for line in file1:
        line = line.replace('  ', ' ')
        print(f'{line=}')
        descriptor = line.split(': ')[0]
        winning_numbers = line.split(': ')[1].split(' | ')[0].split(' ')
        your_numbers = line.split(': ')[1].split(' | ')[1].strip().split(' ')
        matches = 0
        for your_num in your_numbers:
            if your_num in winning_numbers:
                if matches == 0:
                    matches = 1
                else:
                    matches *= 2
        print(f'{matches=}')
        score += matches

print(f'{score=}')