import unittest

import dpnp as inp

import numpy


class TestMatMul(unittest.TestCase):

    def test_matmul(self):
        array_data = [1., 2., 3., 4.]
        size = 2

        # DPNP
        array1 = inp.array(array_data, dtype=inp.float64).reshape((size, size))
        array2 = inp.array(array_data, dtype=inp.float64).reshape((size, size))
        result = inp.matmul(array1, array2)
        # print(result)

        # original
        array_1 = numpy.array(array_data, dtype=numpy.float64).reshape((size, size))
        array_2 = numpy.array(array_data, dtype=numpy.float64).reshape((size, size))
        expected = numpy.matmul(array_1, array_2)
        # print(expected)

        # passed
        numpy.testing.assert_array_equal(expected, result)
        # still failed
        # self.assertEqual(expected, result)

    def test_matmul2(self):
        array_data1 = [1., 2., 3., 4., 5., 6.]
        array_data2 = [1., 2., 3., 4., 5., 6., 7., 8.]

        # DPNP
        array1 = inp.array(array_data1, dtype=inp.float64).reshape((3, 2))
        array2 = inp.array(array_data2, dtype=inp.float64).reshape((2, 4))
        result = inp.matmul(array1, array2)
        # print(result)

        # original
        array_1 = numpy.array(array_data1, dtype=numpy.float64).reshape((3, 2))
        array_2 = numpy.array(array_data2, dtype=numpy.float64).reshape((2, 4))
        expected = numpy.matmul(array_1, array_2)
        # print(expected)

        numpy.testing.assert_array_equal(expected, result)


if __name__ == '__main__':
    unittest.main()
