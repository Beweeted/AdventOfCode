import unittest
from mycode import *


class MyTests(unittest.TestCase):

    def test_fuel(self):
        self.assertEqual(get_fuel(12), 2)
        self.assertEqual(get_fuel(14), 2)
        self.assertEqual(get_fuel(1969), 654)
        self.assertEqual(get_fuel(100756), 33583)

    def test_import(self):
        self.assertEqual(len(get_input('sample.txt')), 4)
        self.assertEqual(get_input('sample.txt')[2], 1969)

    def test_fuel_sum(self):
        self.assertEqual(sum_fuel(get_input('sample.txt')), 34241)

    def test_main(self):
        self.assertEqual(main('sample.txt'), 'Total fuel required: 34241')