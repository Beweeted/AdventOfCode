import math


def main(mass_file, recursive=True):
    mass_input = get_mass_input(mass_file)
    total_fuel = sum_fuel(mass_input, recursive)
    output = 'Recursive' if recursive else 'Simple'
    output += f' fuel required: {total_fuel}'
    return output


def get_fuel(mass, recursive=True):
    total_fuel = calculate_fuel_for_mass(mass)
    if recursive:
        extra_fuel = calculate_fuel_for_mass(total_fuel)
        while extra_fuel != 0:
            total_fuel += extra_fuel
            extra_fuel = calculate_fuel_for_mass(extra_fuel)
    return total_fuel


def calculate_fuel_for_mass(mass):
    fuel = math.floor(mass / 3)-2
    fuel = max(fuel, 0)  # Can't require negative fuel
    return fuel


def sum_fuel(mass_list, recursive=True):
    fuel_sum = 0
    for mass in mass_list:
        fuel_sum += get_fuel(mass, recursive)
    return fuel_sum


def get_mass_input(filename):
    with open(filename, 'r') as file1:
        import_contents = []
        for line in file1.readlines():
            import_contents.append(int(line.strip()))
        return import_contents


if __name__ == '__main__':
    input_file = 'input.txt'
    main(input_file, False)
    main(input_file, True)
