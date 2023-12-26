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
        add_values_and_store(intcode, 9, 10, 2)
        self.assertEqual(intcode[10], 70)



if __name__ == '__main__':
    unittest.main()
