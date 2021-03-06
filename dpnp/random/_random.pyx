# cython: language_level=3
# -*- coding: utf-8 -*-
# *****************************************************************************
# Copyright (c) 2016-2020, Intel Corporation
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
# - Redistributions of source code must retain the above copyright notice,
#   this list of conditions and the following disclaimer.
# - Redistributions in binary form must reproduce the above copyright notice,
#   this list of conditions and the following disclaimer in the documentation
#   and/or other materials provided with the distribution.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
# ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
# LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
# CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
# SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
# INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
# CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
# ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF
# THE POSSIBILITY OF SUCH DAMAGE.
# *****************************************************************************

"""Module Backend

This module contains interface functions between C backend layer
and the rest of the library

"""


import dpnp.config as config

from dpnp.backend cimport *
from dpnp.dparray cimport dparray
from dpnp.dpnp_utils cimport *
import numpy
cimport numpy


__all__ = [
    "dpnp_beta",
    "dpnp_binomial",
    "dpnp_chisquare",
    "dpnp_exponential",
    "dpnp_gamma",
    "dpnp_geometric",
    "dpnp_gumbel",
    "dpnp_laplace",
    "dpnp_lognormal",
    "dpnp_negative_binomial",
    "dpnp_poisson",
    "dpnp_randn",
    "dpnp_random",
    "dpnp_rayleigh",
    "dpnp_srand",
    "dpnp_standard_cauchy",
    "dpnp_standard_normal",
    "dpnp_uniform",
    "dpnp_weibull"
]


ctypedef void(*fptr_custom_rng_beta_c_1out_t)(void *, double, double, size_t) except +
ctypedef void(*fptr_custom_rng_binomial_c_1out_t)(void *, int, double, size_t) except +
ctypedef void(*fptr_custom_rng_chi_square_c_1out_t)(void *, int, size_t) except +
ctypedef void(*fptr_custom_rng_exponential_c_1out_t)(void *, double, size_t) except +
ctypedef void(*fptr_custom_rng_gamma_c_1out_t)(void *, double, double, size_t) except +
ctypedef void(*fptr_custom_rng_geometric_c_1out_t)(void *, float, size_t) except +
ctypedef void(*fptr_custom_rng_gaussian_c_1out_t)(void *, double, double, size_t) except +
ctypedef void(*fptr_custom_rng_gumbel_c_1out_t)(void *, double, double, size_t) except +
ctypedef void(*fptr_custom_rng_laplace_c_1out_t)(void *, double, double, size_t) except +
ctypedef void(*fptr_custom_rng_lognormal_c_1out_t)(void *, double, double, size_t) except +
ctypedef void(*fptr_custom_rng_negative_binomial_c_1out_t)(void *, double, double, size_t) except +
ctypedef void(*fptr_custom_rng_poisson_c_1out_t)(void *, double, size_t) except +
ctypedef void(*fptr_custom_rng_rayleigh_c_1out_t)(void *, double, size_t) except +
ctypedef void(*fptr_custom_rng_standard_cauchy_c_1out_t)(void *, size_t) except +
ctypedef void(*fptr_custom_rng_standard_normal_c_1out_t)(void *, size_t) except +
ctypedef void(*fptr_custom_rng_uniform_c_1out_t)(void *, long, long, size_t)
ctypedef void(*fptr_custom_rng_weibull_c_1out_t)(void *, double, size_t) except +


cpdef dparray dpnp_beta(double a, double b, size):
    """
    Returns an array populated with samples from beta distribution.
    `dpnp_beta` generates a matrix filled with random floats sampled from a
    univariate beta distribution.
    """

    # convert string type names (dparray.dtype) to C enum DPNPFuncType
    cdef DPNPFuncType param1_type = dpnp_dtype_to_DPNPFuncType(numpy.float64)

    # get the FPTR data structure
    cdef DPNPFuncData kernel_data = get_dpnp_function_ptr(DPNP_FN_RNG_BETA, param1_type, param1_type)

    result_type = dpnp_DPNPFuncType_to_dtype( < size_t > kernel_data.return_type)
    # ceate result array with type given by FPTR data
    cdef dparray result = dparray(size, dtype=result_type)

    cdef fptr_custom_rng_beta_c_1out_t func = <fptr_custom_rng_beta_c_1out_t > kernel_data.ptr
    # call FPTR function
    func(result.get_data(), a, b, result.size)

    return result


cpdef dparray dpnp_binomial(int ntrial, double p, size):
    """
    Returns an array populated with samples from binomial distribution.
    `dpnp_binomial` generates a matrix filled with random floats sampled from a
    univariate binomial distribution for a given number of independent trials and
    success probability p of a single trial.
    """

    dtype = numpy.int32
    cdef dparray result
    cdef DPNPFuncType param1_type
    cdef DPNPFuncData kernel_data
    cdef fptr_custom_rng_binomial_c_1out_t func

    if ntrial == 0 or p == 0.0:
        result = dparray(size, dtype=dtype)
        result.fill(0.0)
    elif p == 1.0:
        result = dparray(size, dtype=dtype)
        result.fill(ntrial)
    else:
        # convert string type names (dparray.dtype) to C enum DPNPFuncType
        param1_type = dpnp_dtype_to_DPNPFuncType(dtype)

        # get the FPTR data structure
        kernel_data = get_dpnp_function_ptr(DPNP_FN_RNG_BINOMIAL, param1_type, param1_type)

        result_type = dpnp_DPNPFuncType_to_dtype( < size_t > kernel_data.return_type)
        # ceate result array with type given by FPTR data
        result = dparray(size, dtype=result_type)

        func = <fptr_custom_rng_binomial_c_1out_t > kernel_data.ptr
        # call FPTR function
        func(result.get_data(), ntrial, p, result.size)

    return result


cpdef dparray dpnp_chisquare(int df, size):
    """
    Returns an array populated with samples from chi-square distribution.
    `dpnp_chisquare` generates a matrix filled with random floats sampled from a
    univariate chi-square distribution for a given number of degrees of freedom.
    """

    # convert string type names (dparray.dtype) to C enum DPNPFuncType
    cdef DPNPFuncType param1_type = dpnp_dtype_to_DPNPFuncType(numpy.float64)

    # get the FPTR data structure
    cdef DPNPFuncData kernel_data = get_dpnp_function_ptr(DPNP_FN_RNG_CHISQUARE, param1_type, param1_type)

    result_type = dpnp_DPNPFuncType_to_dtype( < size_t > kernel_data.return_type)
    # ceate result array with type given by FPTR data
    cdef dparray result = dparray(size, dtype=result_type)

    cdef fptr_custom_rng_chi_square_c_1out_t func = <fptr_custom_rng_chi_square_c_1out_t > kernel_data.ptr
    # call FPTR function
    func(result.get_data(), df, result.size)

    return result


cpdef dparray dpnp_exponential(double beta, size):
    """
    Returns an array populated with samples from exponential distribution.
    `dpnp_exponential` generates a matrix filled with random floats sampled from a
    univariate exponential distribution of `beta`.
    """

    dtype = numpy.float64
    # convert string type names (dparray.dtype) to C enum DPNPFuncType
    cdef DPNPFuncType param1_type = dpnp_dtype_to_DPNPFuncType(dtype)

    # get the FPTR data structure
    cdef DPNPFuncData kernel_data = get_dpnp_function_ptr(DPNP_FN_RNG_EXPONENTIAL, param1_type, param1_type)

    result_type = dpnp_DPNPFuncType_to_dtype( < size_t > kernel_data.return_type)
    # ceate result array with type given by FPTR data
    cdef dparray result = dparray(size, dtype=dtype)

    cdef fptr_custom_rng_exponential_c_1out_t func = <fptr_custom_rng_exponential_c_1out_t > kernel_data.ptr
    # call FPTR function
    func(result.get_data(), beta, result.size)

    return result


cpdef dparray dpnp_gamma(double shape, double scale, size):
    """
    Returns an array populated with samples from gamma distribution.
    `dpnp_gamma` generates a matrix filled with random floats sampled from a
    univariate gamma distribution of `shape` and `scale`.
    """

    dtype = numpy.float64
    cdef dparray result
    cdef DPNPFuncType param1_type
    cdef DPNPFuncData kernel_data
    cdef fptr_custom_rng_gamma_c_1out_t func

    if shape == 0.0 or scale == 0.0:
        result = dparray(size, dtype=dtype)
        result.fill(0.0)
    else:
        # convert string type names (dparray.dtype) to C enum DPNPFuncType
        param1_type = dpnp_dtype_to_DPNPFuncType(dtype)

        # get the FPTR data structure
        kernel_data = get_dpnp_function_ptr(DPNP_FN_RNG_GAMMA, param1_type, param1_type)

        result_type = dpnp_DPNPFuncType_to_dtype( < size_t > kernel_data.return_type)
        # ceate result array with type given by FPTR data
        result = dparray(size, dtype=result_type)

        func = <fptr_custom_rng_gamma_c_1out_t > kernel_data.ptr
        # call FPTR function
        func(result.get_data(), shape, scale, result.size)

    return result


cpdef dparray dpnp_geometric(float p, size):
    """
    Returns an array populated with samples from geometric distribution.
    `dpnp_geometric` generates a matrix filled with random floats sampled from a
    univariate geometric distribution for a success probability p of a single
    trial.

    """

    dtype = numpy.int32
    cdef dparray result
    cdef DPNPFuncType param1_type
    cdef DPNPFuncData kernel_data
    cdef fptr_custom_rng_geometric_c_1out_t func

    if p == 1.0:
        result = dparray(size, dtype=dtype)
        result.fill(1)
    else:
        # convert string type names (dparray.dtype) to C enum DPNPFuncType
        param1_type = dpnp_dtype_to_DPNPFuncType(dtype)

        # get the FPTR data structure
        kernel_data = get_dpnp_function_ptr(DPNP_FN_RNG_GEOMETRIC, param1_type, param1_type)

        result_type = dpnp_DPNPFuncType_to_dtype( < size_t > kernel_data.return_type)
        # ceate result array with type given by FPTR data
        result = dparray(size, dtype=result_type)

        func = <fptr_custom_rng_geometric_c_1out_t > kernel_data.ptr
        # call FPTR function
        func(result.get_data(), p, result.size)

    return result


cpdef dparray dpnp_gumbel(double loc, double scale, size):
    """
    Returns an array populated with samples from beta distribution.
    `dpnp_gumbel` generates a matrix filled with random floats sampled from a
    univariate Gumbel distribution.

    """

    dtype = numpy.float64
    cdef dparray result
    cdef DPNPFuncType param1_type
    cdef DPNPFuncData kernel_data
    cdef fptr_custom_rng_gumbel_c_1out_t func

    if scale == 0.0:
        result = dparray(size, dtype=dtype)
        result.fill(loc)
    else:
        # convert string type names (dparray.dtype) to C enum DPNPFuncType
        param1_type = dpnp_dtype_to_DPNPFuncType(dtype)

        # get the FPTR data structure
        kernel_data = get_dpnp_function_ptr(DPNP_FN_RNG_GUMBEL, param1_type, param1_type)

        result_type = dpnp_DPNPFuncType_to_dtype( < size_t > kernel_data.return_type)
        # ceate result array with type given by FPTR data
        result = dparray(size, dtype=result_type)

        func = <fptr_custom_rng_gumbel_c_1out_t > kernel_data.ptr
        # call FPTR function
        func(result.get_data(), loc, scale, result.size)

    return result


cpdef dparray dpnp_negative_binomial(double a, double p, size):
    """
    Returns an array populated with samples from negative binomial distribution.

    `negative_binomial` generates a matrix filled with random floats sampled from a
    univariate negative binomial distribution for a given parameter of the distribution
    `a` and success probability `p` of a single trial.

    """

    dtype = numpy.int32
    cdef dparray result
    cdef DPNPFuncType param1_type
    cdef DPNPFuncData kernel_data
    cdef fptr_custom_rng_negative_binomial_c_1out_t func

    if p == 0.0:
        filled_val = numpy.iinfo(dtype).min
        result = dparray(size, dtype=dtype)
        result.fill(filled_val)
    elif p == 1.0:
        result = dparray(size, dtype=dtype)
        result.fill(0)
    else:
        # convert string type names (dparray.dtype) to C enum DPNPFuncType
        param1_type = dpnp_dtype_to_DPNPFuncType(dtype)

        # get the FPTR data structure
        kernel_data = get_dpnp_function_ptr(DPNP_FN_RNG_NEGATIVE_BINOMIAL, param1_type, param1_type)

        result_type = dpnp_DPNPFuncType_to_dtype( < size_t > kernel_data.return_type)
        # ceate result array with type given by FPTR data
        result = dparray(size, dtype=result_type)

        func = <fptr_custom_rng_negative_binomial_c_1out_t > kernel_data.ptr
        # call FPTR function
        func(result.get_data(), a, p, result.size)

    return result


cpdef dparray dpnp_laplace(double loc, double scale, size):
    """
    Returns an array populated with samples from beta distribution.
    `dpnp_laplace` generates a matrix filled with random floats sampled from a
    univariate laplace distribution.

    """

    dtype = numpy.float64
    cdef dparray result
    cdef DPNPFuncType param1_type
    cdef DPNPFuncData kernel_data
    cdef fptr_custom_rng_laplace_c_1out_t func

    if scale == 0.0:
        result = dparray(size, dtype=dtype)
        result.fill(0.0)
    else:
        # convert string type names (dparray.dtype) to C enum DPNPFuncType
        param1_type = dpnp_dtype_to_DPNPFuncType(dtype)

        # get the FPTR data structure
        kernel_data = get_dpnp_function_ptr(DPNP_FN_RNG_LAPLACE, param1_type, param1_type)

        result_type = dpnp_DPNPFuncType_to_dtype( < size_t > kernel_data.return_type)
        # ceate result array with type given by FPTR data
        result = dparray(size, dtype=result_type)

        func = <fptr_custom_rng_laplace_c_1out_t > kernel_data.ptr
        # call FPTR function
        func(result.get_data(), loc, scale, result.size)

    return result


cpdef dparray dpnp_lognormal(double mean, double stddev, size):
    """
    Returns an array populated with samples from beta distribution.
    `dpnp_lognormal` generates a matrix filled with random floats sampled from a
    univariate lognormal distribution.

    """

    dtype = numpy.float64
    cdef dparray result
    cdef DPNPFuncType param1_type
    cdef DPNPFuncData kernel_data
    cdef fptr_custom_rng_lognormal_c_1out_t func

    if stddev == 0.0:
        val = numpy.exp(mean + (stddev ** 2) / 2)
        result = dparray(size, dtype=dtype)
        result.fill(val)
    else:
        # convert string type names (dparray.dtype) to C enum DPNPFuncType
        param1_type = dpnp_dtype_to_DPNPFuncType(dtype)

        # get the FPTR data structure
        kernel_data = get_dpnp_function_ptr(DPNP_FN_RNG_LOGNORMAL, param1_type, param1_type)

        result_type = dpnp_DPNPFuncType_to_dtype( < size_t > kernel_data.return_type)
        # ceate result array with type given by FPTR data
        result = dparray(size, dtype=result_type)

        func = <fptr_custom_rng_lognormal_c_1out_t > kernel_data.ptr
        # call FPTR function
        func(result.get_data(), mean, stddev, result.size)

    return result


cpdef dparray dpnp_poisson(double lam, size):
    """
    Returns an array populated with samples from Poisson distribution.
    `dpnp_poisson` generates a matrix filled with random floats sampled from a
    univariate Poisson distribution for a given number of independent trials and
    success probability p of a single trial.
    """

    dtype = numpy.int32
    cdef dparray result
    cdef DPNPFuncType param1_type
    cdef DPNPFuncData kernel_data
    cdef fptr_custom_rng_poisson_c_1out_t func

    if lam == 0:
        result = dparray(size, dtype=dtype)
        result.fill(0)
    else:
        # convert string type names (dparray.dtype) to C enum DPNPFuncType
        param1_type = dpnp_dtype_to_DPNPFuncType(dtype)

        # get the FPTR data structure
        kernel_data = get_dpnp_function_ptr(DPNP_FN_RNG_POISSON, param1_type, param1_type)

        result_type = dpnp_DPNPFuncType_to_dtype( < size_t > kernel_data.return_type)
        # ceate result array with type given by FPTR data
        result = dparray(size, dtype=result_type)

        func = <fptr_custom_rng_poisson_c_1out_t > kernel_data.ptr
        # call FPTR function
        func(result.get_data(), lam, result.size)

    return result


cpdef dparray dpnp_randn(dims):
    """
    Returns an array populated with samples from standard normal distribution.
    `dpnp_randn` generates a matrix filled with random floats sampled from a
    univariate normal (Gaussian) distribution of mean 0 and variance 1.
    """
    cdef double mean = 0.0
    cdef double stddev = 1.0

    # convert string type names (dparray.dtype) to C enum DPNPFuncType
    cdef DPNPFuncType param1_type = dpnp_dtype_to_DPNPFuncType(numpy.float64)

    # get the FPTR data structure
    cdef DPNPFuncData kernel_data = get_dpnp_function_ptr(DPNP_FN_RNG_GAUSSIAN, param1_type, param1_type)

    result_type = dpnp_DPNPFuncType_to_dtype( < size_t > kernel_data.return_type)
    # ceate result array with type given by FPTR data
    cdef dparray result = dparray(dims, dtype=result_type)

    cdef fptr_custom_rng_gaussian_c_1out_t func = <fptr_custom_rng_gaussian_c_1out_t > kernel_data.ptr
    # call FPTR function
    func(result.get_data(), mean, stddev, result.size)

    return result


cpdef dparray dpnp_random(dims):
    """
    Create an array of the given shape and populate it
    with random samples from a uniform distribution over [0, 1).
    """
    cdef long low = 0
    cdef long high = 1

    # convert string type names (dparray.dtype) to C enum DPNPFuncType
    cdef DPNPFuncType param1_type = dpnp_dtype_to_DPNPFuncType(numpy.float64)

    # get the FPTR data structure
    cdef DPNPFuncData kernel_data = get_dpnp_function_ptr(DPNP_FN_RNG_UNIFORM, param1_type, param1_type)

    result_type = dpnp_DPNPFuncType_to_dtype( < size_t > kernel_data.return_type)
    # ceate result array with type given by FPTR data
    cdef dparray result = dparray(dims, dtype=result_type)

    cdef fptr_custom_rng_uniform_c_1out_t func = <fptr_custom_rng_uniform_c_1out_t > kernel_data.ptr
    # call FPTR function
    func(result.get_data(), low, high, result.size)

    return result


cpdef dparray dpnp_rayleigh(double scale, size):
    """
    Returns an array populated with samples from Rayleigh distribution.
    `dpnp_rayleigh` generates a matrix filled with random floats sampled from a
    univariate Rayleigh distribution of `scale`.

    """

    dtype = numpy.float64
    cdef dparray result
    cdef DPNPFuncType param1_type
    cdef DPNPFuncData kernel_data
    cdef fptr_custom_rng_rayleigh_c_1out_t func

    if scale == 0.0:
        result = dparray(size, dtype=dtype)
        result.fill(0.0)
    else:
        # convert string type names (dparray.dtype) to C enum DPNPFuncType
        param1_type = dpnp_dtype_to_DPNPFuncType(dtype)

        # get the FPTR data structure
        kernel_data = get_dpnp_function_ptr(DPNP_FN_RNG_RAYLEIGH, param1_type, param1_type)

        result_type = dpnp_DPNPFuncType_to_dtype( < size_t > kernel_data.return_type)
        # ceate result array with type given by FPTR data
        result = dparray(size, dtype=result_type)

        func = <fptr_custom_rng_rayleigh_c_1out_t > kernel_data.ptr
        # call FPTR function
        func(result.get_data(), scale, result.size)

    return result


cpdef dpnp_srand(seed):
    """
    Initialize basic random number generator.
    """
    dpnp_srand_c(seed)


cpdef dparray dpnp_standard_cauchy(size):
    """
    Returns an array populated with samples from beta distribution.
    `dpnp_standard_cauchy` generates a matrix filled with random floats sampled from a
    univariate standard cauchy distribution.

    """

    # convert string type names (dparray.dtype) to C enum DPNPFuncType
    cdef DPNPFuncType param1_type = dpnp_dtype_to_DPNPFuncType(numpy.float64)

    # get the FPTR data structure
    cdef DPNPFuncData kernel_data = get_dpnp_function_ptr(DPNP_FN_RNG_STANDARD_CAUCHY, param1_type, param1_type)

    result_type = dpnp_DPNPFuncType_to_dtype( < size_t > kernel_data.return_type)
    # ceate result array with type given by FPTR data
    cdef dparray result = dparray(size, dtype=result_type)

    cdef fptr_custom_rng_standard_cauchy_c_1out_t func = < fptr_custom_rng_standard_cauchy_c_1out_t > kernel_data.ptr
    # call FPTR function
    func(result.get_data(), result.size)

    return result


cpdef dparray dpnp_standard_normal(size):
    """
    Returns an array populated with samples from beta distribution.
    `dpnp_standard_normal` generates a matrix filled with random floats sampled from a
    univariate standard normal(Gaussian) distribution.

    """

    # convert string type names (dparray.dtype) to C enum DPNPFuncType
    cdef DPNPFuncType param1_type = dpnp_dtype_to_DPNPFuncType(numpy.float64)

    # get the FPTR data structure
    cdef DPNPFuncData kernel_data = get_dpnp_function_ptr(DPNP_FN_RNG_STANDARD_NORMAL, param1_type, param1_type)

    result_type = dpnp_DPNPFuncType_to_dtype( < size_t > kernel_data.return_type)
    # ceate result array with type given by FPTR data
    cdef dparray result = dparray(size, dtype=result_type)

    cdef fptr_custom_rng_standard_normal_c_1out_t func = < fptr_custom_rng_standard_normal_c_1out_t > kernel_data.ptr
    # call FPTR function
    func(result.get_data(), result.size)

    return result


cpdef dparray dpnp_uniform(long low, long high, size, dtype=numpy.int32):
    """
    Returns an array populated with samples from standard uniform distribution.
    Generates a matrix filled with random numbers sampled from a
    uniform distribution of the certain left (low) and right (high)
    bounds.
    """
    # convert string type names (dparray.dtype) to C enum DPNPFuncType
    cdef DPNPFuncType param1_type = dpnp_dtype_to_DPNPFuncType(dtype)

    # get the FPTR data structure
    cdef DPNPFuncData kernel_data = get_dpnp_function_ptr(DPNP_FN_RNG_UNIFORM, param1_type, param1_type)

    result_type = dpnp_DPNPFuncType_to_dtype( < size_t > kernel_data.return_type)
    # ceate result array with type given by FPTR data
    cdef dparray result = dparray(size, dtype=result_type)

    cdef fptr_custom_rng_uniform_c_1out_t func = <fptr_custom_rng_uniform_c_1out_t > kernel_data.ptr
    # call FPTR function
    func(result.get_data(), low, high, result.size)

    return result


cpdef dparray dpnp_weibull(double a, size):
    """
    Returns an array populated with samples from beta distribution.
    `dpnp_weibull` generates a matrix filled with random floats sampled from a
    univariate weibull distribution.
    """

    dtype = numpy.float64
    cdef dparray result
    cdef DPNPFuncType param1_type
    cdef DPNPFuncData kernel_data
    cdef fptr_custom_rng_weibull_c_1out_t func

    if a == 0.0:
        result = dparray(size, dtype=dtype)
        result.fill(0.0)
    else:
        # convert string type names (dparray.dtype) to C enum DPNPFuncType
        param1_type = dpnp_dtype_to_DPNPFuncType(numpy.float64)

        # get the FPTR data structure
        kernel_data = get_dpnp_function_ptr(DPNP_FN_RNG_WEIBULL, param1_type, param1_type)

        result_type = dpnp_DPNPFuncType_to_dtype( < size_t > kernel_data.return_type)
        # ceate result array with type given by FPTR data
        result = dparray(size, dtype=result_type)

        func = <fptr_custom_rng_weibull_c_1out_t > kernel_data.ptr
        # call FPTR function
        func(result.get_data(), a, result.size)

    return result
