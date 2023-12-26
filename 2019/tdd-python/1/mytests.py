import unittest
from mycode import *


class MyTests(unittest.TestCase):

    def test_fuel(self):
        self.assertEqual(get_fuel(12), 2)
        self.assertEqual(get_fuel(14), 2)
        self.assertEqual(get_fuel(1969), 654)
        self.assertEqual(get_fuel(100756), 33583)

    def test_recursive_fuel(self):
        self.assertEqual(get_recursive_fuel(12), 2)
        self.assertEqual(get_recursive_fuel(14), 2)
        self.assertEqual(get_recursive_fuel(1969), 966)
        self.assertEqual(get_recursive_fuel(100756), 50346)

    def test_import(self):
        self.assertEqual(len(get_input('sample.txt')), 4)
        self.assertEqual(get_input('sample.txt')[2], 1969)

    def test_fuel_sum(self):
        self.assertEqual(sum_fuel(get_input('sample.txt')), 34241)
        self.assertEqual(sum_fuel_recursive(get_input('sample.txt')), 51316)

    def test_main(self):
        self.assertEqual(simple_main('sample.txt'), 'Simple fuel required: 34241')
        self.assertEqual(recursive_main('sample.txt'), 'Recursive fuel required: 51316')