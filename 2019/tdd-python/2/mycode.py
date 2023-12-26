def add_values(intcode, position1, position2):
    return intcode[position1] + intcode[position2]


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
