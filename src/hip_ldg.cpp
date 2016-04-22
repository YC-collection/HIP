/*
Copyright (c) 2015-2016 Advanced Micro Devices, Inc. All rights reserved.
Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:
The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
*/

#include"hcc_detail/hip_ldg.h"

__device__ char __ldg(const char* ptr)
{
    return *ptr;
}

__device__ signed char __ldg(const signed char* ptr)
{
    return ptr[0];
}

__device__ short __ldg(const short* ptr)
{
    return ptr[0];
}

__device__ int __ldg(const int* ptr)
{
    return ptr[0];
}

__device__ long long __ldg(const long long* ptr)
{
    return ptr[0];
}


__device__ int2 __ldg(const int2* ptr)
{
    return ptr[0];
}

__device__ int4 __ldg(const int4* ptr)
{
    return ptr[0];
}

__device__ float __ldg(const float* ptr)
{
    return ptr[0];
}