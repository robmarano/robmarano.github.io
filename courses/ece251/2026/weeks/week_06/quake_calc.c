#include <stdio.h>

float Q_rsqrt( float number )
{
    long i;
    float x2, y;
    const float threehalfs = 1.5F;

    x2 = number * 0.5F;
    y  = number;
    i  = * ( long * ) &y;                       // evil floating point bit level hacking
    i  = 0x5f3759df - ( i >> 1 );               // Initial approximation using magic number and bit shift
    y  = * ( float * ) &i;
    y  = y * ( threehalfs - ( x2 * y * y ) );   // 1st iteration (Newton-Raphson method)
    y  = y * ( threehalfs - ( x2 * y * y ) );   // 2nd iteration (Newton-Raphson method), this can be removed

    return y;
}

void main(void) {
    float n = 88492774839537494;
    float result;

    result = Q_rsqrt(n);
    printf("inverse sqrt of %f = %f\n", n, result);
}