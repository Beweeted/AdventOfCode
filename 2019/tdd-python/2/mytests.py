import unittest
from mycode import *


class MyTestCase(unittest.TestCase):
    def test_loading_intcode(self):
        self.assertEqual(len(get_intcode('sample.txt')), 12)  # add assertion here


if __name__ == '__main__':
    unittest.main()
