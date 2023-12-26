import math


def get_fuel(mass):
    fuel = math.floor(mass / 3)-2
    fuel = max(fuel, 0)
    return fuel


def get_recursive_fuel(mass):
    total_fuel = get_fuel(mass)
    extra_fuel = get_fuel(total_fuel)
    while extra_fuel != 0:
        total_fuel += extra_fuel
        extra_fuel = get_fuel(extra_fuel)
    return total_fuel


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


def sum_fuel_recursive(mass_list):
    fuel_sum = 0
    for mass in mass_list:
        fuel_sum += get_recursive_fuel(mass)
    return fuel_sum


def main(mass_file, recursive=True):
    mass_input = get_input(mass_file)
    if recursive:
        total_fuel = sum_fuel_recursive(mass_input)
        output = f'Recursive fuel required: {total_fuel}'
    else:
        total_fuel = sum_fuel(mass_input)
        output = f'Simple fuel required: {total_fuel}'
    return output


if __name__ == '__main__':
    input_file = 'input.txt'
    main(input_file, False)
    main(input_file, True)
