import unittest
from mycode import *


class MyTestCase(unittest.TestCase):
    def test_loading_intcode(self):
        intcode = get_intcode('sample.txt')
        self.assertEqual(len(intcode), 13)
        self.assertEqual(intcode[4], 2)
        self.assertEqual(intcode[10], 40)

    def test_intcode_add_and_store(self):
        intcode = get_intcode('sample.txt')
        add_values_and_store(intcode, 5)
        self.assertEqual(intcode[0], 53)

    def test_intcode_multiply_and_store(self):
        intcode = get_intcode('sample.txt')
        multiply_values_and_store(intcode, 5)
        self.assertEqual(intcode[0], 150)

    def test_run_intcode_program(self):
        intcode = get_intcode('sample.txt')
        self.assertEqual(run_intcode(intcode), 3500)

    def test_run_main(self):
        intcode = get_intcode('sample.txt')
        self.assertEqual(main(intcode), 100)
        intcode = parse_intcode('2,0,0,0,99,8,9'+',0'*800)
        self.assertEqual(main(intcode, 72, True), 'noun=5, verb=6, magic_number=72')

    def test_unit_tests(self):
        intcode = parse_intcode('1,0,0,0,99')
        self.assertEqual(run_intcode(intcode), 2)
        intcode = parse_intcode('2,3,0,3,99')
        self.assertEqual(run_intcode(intcode), 2)
        intcode = parse_intcode('2,4,4,5,99,0')
        self.assertEqual(run_intcode(intcode), 2)
        intcode = parse_intcode('1,1,1,4,99,5,6,0,99')
        self.assertEqual(run_intcode(intcode), 30)

    def test_inject_values(self):
        intcode = parse_intcode('1,0,0,0,99')
        inject_values(intcode, 4, 4)
        self.assertEqual(intcode[1] + intcode[2], 8)
        inject_values(intcode, 562, 111)
        self.assertEqual(intcode[1] + intcode[2], 673)

    def test_injection_search(self):
        intcode = parse_intcode('1,0,0,0,99')
        result = search_injection_range(intcode, 100)
        self.assertEqual(result, 'noun=0, verb=4, magic_number=100')


if __name__ == '__main__':
    unittest.main()
