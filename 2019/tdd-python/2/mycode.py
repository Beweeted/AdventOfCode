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
    print(f'Adding: {val1=}, {val2=}, {dest=}, {store=}')
    intcode[dest] = store


def multiply_values_and_store(intcode, idx):
    val1 = intcode[intcode[idx]]
    val2 = intcode[intcode[idx+1]]
    dest = intcode[idx+2]
    value = val1 * val2
    print(f'Multiplying: {val1=}, {val2=}, {dest=}, {value=}')
    intcode[dest] = value


def get_intcode(filename):
    with (open(filename, 'r') as file1):
        intcode = []
        codes = file1.readline().split(',')
        for code in codes:
            intcode.append(int(code))
        return intcode


def main(filename):
    intcode = get_intcode(filename)
    result = run_intcode(intcode)
    print(f'{result=}')
    return result


if __name__ == '__main__':
    main('input.txt')
