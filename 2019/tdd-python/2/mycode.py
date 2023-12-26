def run_intcode(intcode):
    position = 0
    while True:
        instruction = intcode[position]
        print(f'{instruction=}')
        if instruction == 99:
            break
        elif instruction == 1:
            add_values_and_store(intcode, position+1, position+2, position+3)
        elif instruction == 2:
            multiply_values_and_store(intcode, position+1, position+2, position+3)
        position += 4
    return intcode[0]


def add_values_and_store(intcode, position1, position2, position3):
    loc1 = intcode[position1]
    val1 = intcode[loc1]
    loc2 = intcode[position2]
    val2 = intcode[loc2]
    dest = intcode[position3]
    value = val1 + val2
    print(f'Adding: {val1=}, {val2=}, {dest=}, {value=}')
    intcode[dest] = value


def multiply_values_and_store(intcode, position1, position2, position3):
    loc1 = intcode[position1]
    val1 = intcode[loc1]
    loc2 = intcode[position2]
    val2 = intcode[loc2]
    dest = intcode[position3]
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


def main():
    pass


if __name__ == '__main__':
    main()
