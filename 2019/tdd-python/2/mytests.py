import unittest
from mycode import *


class MyTestCase(unittest.TestCase):
    def test_loading_intcode(self):
        intcode = get_intcode('sample.txt')
        self.assertEqual(len(intcode), 12)  # add assertion here
        self.assertEqual(intcode[4], 2)
        self.assertEqual(intcode[10], 40)

    def test_intcode_add_and_store(self):
        intcode = get_intcode('sample.txt')
        add_values_and_store(intcode, 5, 6, 2)
        self.assertEqual(intcode[10], 53)

    def test_intcode_multiply_and_store(self):
        intcode = get_intcode('sample.txt')
        multiply_values_and_store(intcode, 5, 6, 2)
        self.assertEqual(intcode[10], 150)

    def test_run_intcode_program(self):
        intcode = get_intcode('sample.txt')
        self.assertEqual(run_intcode(intcode), 3500)


if __name__ == '__main__':
    unittest.main()
