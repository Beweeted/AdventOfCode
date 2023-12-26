def run_intcode(intcode):
    position = 0
    while True:
        instruction = intcode[position]
        print(f'{instruction=}')
        if instruction == 99:
            break
        elif instruction == 1:
            add_values_and_store(intcode, position+1)
        elif instruction == 2:
            multiply_values_and_store(intcode, position+1)
        position += 4
    return intcode[0]


def add_values_and_store(intcode, idx):
    val1 = intcode[intcode[idx]]
    val2 = intcode[intcode[idx+1]]
    dest = intcode[idx+2]
    store = val1 + val2
    print(f'Adding: {val1=}, {val2=}, {store=}, {dest=}')
    intcode[dest] = store


def multiply_values_and_store(intcode, idx):
    val1 = intcode[intcode[idx]]
    val2 = intcode[intcode[idx+1]]
    dest = intcode[idx+2]
    store = val1 * val2
    print(f'Multiplying: {val1=}, {val2=}, {store=}, {dest=}')
    intcode[dest] = store


def get_intcode(filename):
    with (open(filename, 'r') as file1):
        return parse_intcode(file1.readline())


def parse_intcode(program_string):
    intcode = []
    codes = program_string.split(',')
    for code in codes:
        intcode.append(int(code))
    return intcode


def inject_values(intcode, val1, val2):
    intcode[1] = val1
    intcode[2] = val2


def main(intcode, magic_number=0, search=False):
    if search:
        result = search_injection_range(intcode, magic_number)
    else:
        inject_values(intcode, 12, 2)
        result = run_intcode(intcode)
        print(f'{result}')
    return result


def search_injection_range(intcode, magic_number):
    for noun in range(0, 100):
        for verb in range(0, 100):
            print(f'New iteration: {noun} - {verb}')
            new_intcode = intcode.copy()
            inject_values(new_intcode, noun, verb)
            result = run_intcode(new_intcode)
            if result == magic_number:
                print(f'Search complete! {noun=} and {verb=} create magic number {magic_number}!')
                return f'{noun=}, {verb=}, {magic_number=}'


if __name__ == '__main__':
    myintcode = get_intcode('input.txt')
    main(myintcode, 19690720, True)
