import math


def get_fuel(mass):
    fuel = math.floor(mass / 3)-2
    return fuel


def get_input(filename):
    with open(filename, 'r') as file1:
        import_contents = []
        for line in file1.readlines():
            import_contents.append(int(line.strip()))
        return import_contents


def sum_fuel(mass_list):
    fuel_sum = 0
    for mass in mass_list:
        fuel_sum += get_fuel(mass)
    return fuel_sum


def main(mass_file):
    mass_input = get_input(mass_file)
    total_fuel = sum_fuel(mass_input)
    output = f'Total fuel required: {total_fuel}'
    return output


if __name__ == '__main__':
    input_file = 'input.txt'
    print(main(input_file))
