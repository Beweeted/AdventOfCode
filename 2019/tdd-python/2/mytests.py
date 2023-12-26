import unittest
from mycode import *


class MyTestCase(unittest.TestCase):
    def test_loading_intcode(self):
        intcode = get_intcode('sample.txt')
        self.assertEqual(len(intcode), 12)  # add assertion here
        self.assertEqual(intcode[4], 2)

    def test_intcode_addition(self):
        intcode = get_intcode('sample.txt')
        self.assertEqual(add_values(intcode, 4, 8), 101)
        self.assertEqual(add_values(intcode, 1, 10), 49)


if __name__ == '__main__':
    unittest.main()
