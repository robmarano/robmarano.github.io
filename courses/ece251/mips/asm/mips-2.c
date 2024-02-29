#include <stdio.h>

int n = 4;

int main(void) {
    int fact_val = fact(n);
    printf("Factorial of %d is %d\n", n, fact_val);
    return 0;
}

int fact(int n) {
    // L1
    if (n < 1) {
        return 1;
    // L2
    } else {
        return n * fact(n - 1);
    }
}