import unittest
from mycode import *


class MyTests(unittest.TestCase):

    def test_simple_fuel(self):
        self.assertEqual(get_fuel(12, False), 2)
        self.assertEqual(get_fuel(14, False), 2)
        self.assertEqual(get_fuel(1969, False), 654)
        self.assertEqual(get_fuel(100756, False), 33583)

    def test_recursive_fuel(self):
        self.assertEqual(get_fuel(12, True), 2)
        self.assertEqual(get_fuel(14, True), 2)
        self.assertEqual(get_fuel(1969, True), 966)
        self.assertEqual(get_fuel(100756, True), 50346)

    def test_import(self):
        self.assertEqual(len(get_mass_input('sample.txt')), 4)
        self.assertEqual(get_mass_input('sample.txt')[2], 1969)

    def test_fuel_sum(self):
        test_input = get_mass_input('sample.txt')
        self.assertEqual(sum_fuel(test_input, False), 34241)
        self.assertEqual(sum_fuel(test_input, True), 51316)

    def test_main(self):
        self.assertEqual(main('sample.txt', False), 'Simple fuel required: 34241')
        self.assertEqual(main('sample.txt', True), 'Recursive fuel required: 51316')
