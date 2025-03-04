#include <stdio.h>

int main(void)
{
    int k = 0; // use $t0
    int i = 0; // use $t1
    int save[8] = {1, 0, 2, 3, 4, 5, 6, 7};
    int a;

    // while (save[i] == k)
    a = save[0];
    while (a == k)
    {
        i += 1;
        a = save[i];
    }
    i--;
    printf("k = %d\n", k);
    printf("save = %p\n", save);
    printf("i = %d\n", i);
}