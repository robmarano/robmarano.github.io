# Study Guide for Arrays and Pointers in C
## CS 102 Section M
Fall 2022 <BR>
The Cooper Union

# Topics

## What is an array?
An array is a fixed-size sequential collection of elements of the same type stored in memory; for example
```c
#include <stdio.h>

#define ARRAY_SIZE 8

int main(void) {
    /* declaration of the variable "a" is an integer array */
    int a[ARRAY_SIZE];
    /* declaration of the variable "b" is an integer array; it is initialized with values */
    int b[ARRAY_SIZE] = { 0, 1, 2, 3, 4, 5, 6, 7 };

    /* declaration of the variable "c" is a char array, aka a "string" */
    char c[ARRAY_SIZE];
    /* declaration of the variable "b" is an integer array; it is initialized with values */
    char d[ARRAY_SIZE] = "station";


    /* set myArray's elements equal to those of myOtherArray */
    for (int i = 0; i < ARRAY_SIZE; i++) {
        a[i] = b[i];
        c[i] = d[i];
    }

    /* print values of both arrays */
    for (int j = 0; j < ARRAY_SIZE; j++) {
        printf("a[%d] = %d; b[%d] = %d\t\tc[%d] = %c; d[%d] = %c\n",
            j, a[j], j, b[j], j, c[j], j, d[j]);
    }

    printf("c = %s\n", c);
    printf("d = %s\n", d);

    return(0);
}
```

The output would be:
```bash
a[0] = 0; b[0] = 0              c[0] = s; d[0] = s
a[1] = 1; b[1] = 1              c[1] = t; d[1] = t
a[2] = 2; b[2] = 2              c[2] = a; d[2] = a
a[3] = 3; b[3] = 3              c[3] = t; d[3] = t
a[4] = 4; b[4] = 4              c[4] = i; d[4] = i
a[5] = 5; b[5] = 5              c[5] = o; d[5] = o
a[6] = 6; b[6] = 6              c[6] = n; d[6] = n
a[7] = 7; b[7] = 7              c[7] = ; d[7] = 
c = station
d = station
```

## What is a pointer?
In C a pointer is a variable that stores the memory address, which usually stores the address of another variable. Programmers find pointers very useful since they allow for the dynamic creation and manipulation of data structures. As powerful as pointers are, they can be unwieldy if you're not careful and precise.

Pointers are denoted with an asterisk, also called a "dereference operator" and the ampersand denotes "reference operator" i.e.,
```c
int aNumber = 9;
int *myPointer = &aNumber;
```
This statement declaration means "myPointer is a pointer variable that points to an integer, whose value is the value in the memory address of variable aNumber." Simply put, "myPointer points to an integer whose value is whatever value of aNumber.

For example,
```c
#include <stdio.h>

int main(void) {
    int aNumber = 9;
    int *aPointer = &aNumber;

    printf("aNumber = %d\taPointer = %p\t which stores value = %d\n",
        aNumber, aPointer, *aPointer);
    
    *aPointer = 99;
    printf("aNumber = %d\taPointer = %p\t which stores value = %d\n",
        aNumber, aPointer, *aPointer);

    return(0);d
}
```
The output would be:
```bash
aNumber = 9     aPointer = 0x7ffe658dcc04        which stores value = 9
aNumber = 99    aPointer = 0x7ffe658dcc04        which stores value = 99
```

You can use pointers with character arrays, or strings, in C. Remember that C strings are NULL-terminated, meaning the last character in the string must have a NULL (\0) value and counts as the element of the very last index. If you use the array operator ([]) you do not have to create the memory for the array. If you just use the pointer deference operator, then you need to create the memory to store the string, use it, then free up the memory when you're done.

For example,
```c
#include <stdio.h>
#define ARRAY_SIZE 32

int main(void) {
    char s1[ARRAY_SIZE] = "Hello, World!"; /* this string is 32 bytes (char) long, even though you see only "Hello, World!" */
    char *s2 = "Goodbye, World!"; /* memory to store just this string and its NULL termination is created for you. *

    printf("s1 = %s\n",s1);
    printf("s2 = %s\n",s2);

    /* let's find out the length of each string */
    int s1_length = 0;
    while (s1[s1_length] != NULL) {
        s1_length++;
    }
    s1_length++; // account for NULL termination
    printf("length of string s1 = %d\n", s1_length);
    printf("Value of one more than length = %x\n", s1[s1_length]);
    printf("That value is NULL, because strings are NULL-terminated.\n");

    int s2_length = 0;
    while (s2[s2_length] != NULL) {
        s2_length++;
    }
    s2_length++; // account for NULL termination
    printf("length of string s2 = %d\n", s2_length);
    printf("Value of one more than length = %x\n", s2[s2_length]);
    printf("That value is NULL, because strings are NULL-terminated.\n");

    return(0);
}
```
The output would be:
```bash
s1 = Hello, World!
s2 = Goodbye, World!
length of string s1 = 13
Value of one more than length = 0
That value is NULL, because strings are NULL-terminated.
length of string s2 = 15
Value of one more than length = 0
That value is NULL, because strings are NULL-terminated.
```
Note that there is unused memory space allocated to s1. We can improve the memory efficiency by using pointers.
```c
#include <stdio.h>
#include <string.h>

#define S1_STRING "Hello, World!\0"
#define S1_LENGTH 14 /* remember to count for NULL termination */
#define S2_STRING "Goodbye, World!\0"
#define S2_LENGTH 16 /* remember to count for NULL termination */

int main(void) {
    char *s1;
    char *s2;

    /* create the memory space to store s1 */
    s1 = (char *) malloc(S1_LENGTH * sizeof(char));

    /* copy the string value into s1's memory location */
    strncpy(s1, S1_STRING, S1_LENGTH);

    /* create the memory space to store s2 */
    s2 = (char *) malloc(S2_LENGTH * sizeof(char));
    strncpy(s2, S2_STRING, S2_LENGTH);

    /* copy the string value into s2's memory location */

    printf("s1 = %s\n",s1);
    printf("s2 = %s\n",s2);

    /* let's find out the length of each string */
    int s1_length = 0;
    while (s1[s1_length] != NULL) {
        s1_length++;
    }
    s1_length++; // account for NULL termination
    printf("length of string s1 = %d\n", s1_length);
    printf("Value of one more than length = %x\n", s1[s1_length]);
    printf("That value is NULL, because strings are NULL-terminated.\n");

    int s2_length = 0;
    while (s2[s2_length] != NULL) {
        s2_length++;
    }
    s2_length++; // account for NULL termination
    printf("length of string s2 = %d\n", s2_length);
    printf("Value of one more than length = %x\n", s2[s2_length]);
    printf("That value is NULL, because strings are NULL-terminated.\n");

    /* whatever you malloc(), you must free() */
    free(s1);
    free(s2);
    return(0);
}
```
The output would be:
```bash
s1 = Hello, World!
s2 = Goodbye, World!
length of string s1 = 14
Value of one more than length = 0
That value is NULL, because strings are NULL-terminated.
length of string s2 = 16
Value of one more than length = 0
That value is NULL, because strings are NULL-terminated.
```

## Pointers and Data Structures

Now let's say we wanted to create a data structure and work with variables of this data structure using pointers. Let's take an example of how to create a data structure of cartesian points and lines. See the next code snippet. Unlike using header and source files, let's just keep everthing in one file for demonstration purposes only.

```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define NUM_POINTS 3

typedef struct point {
    double x, y;
} Point;

typedef struct line {
    Point point1, point2;
    double slope, y_intercept;
} Line;

Point make_point(double x, double y);

/* we will create several "Points" and store in a pointer array, which can be written as "Point **points" or "Point *points[]" */
int main(void) {
    /* create array of Points */
    Point **points = (Point **) malloc(NUM_POINTS * sizeof(Point*));
    Point *temp_p;
    int ptr_loc = 0; /* acts like index in array */

    /* create 3 Points manually */
    /* (0,0), (15,10), (30, 20) */
    temp_p = (Point *) malloc(sizeof(Point));
    temp_p->x = 0; /* or, (*temp_p).x = 0; */
    temp_p->y = 0; /* or, (*temp_p).y = 0; */
    *(points+ptr_loc) = temp_p; /* point at index (ptr_loc) gets the new point */

    ptr_loc++; /* move to next consecutive index */
    temp_p = (Point *) malloc(sizeof(Point));
    temp_p->x = 15; /* or, (*temp_p).x = 15; */
    temp_p->y = 10; /* or, (*temp_p).y = 10; */
    *(points+ptr_loc) = temp_p; /* point at index (ptr_loc) gets the new point */

    ptr_loc++; /* move to next consecutive index */
    temp_p = (Point *) malloc(sizeof(Point));
    temp_p->x = 30; /* or, (*temp_p).x = 30; */
    temp_p->y = 20; /* or, (*temp_p).y = 20; */
    *(points+ptr_loc) = temp_p; /* point at index (ptr_loc) gets the new point */

    // loop through the points
    for (int k = 0; k < NUM_POINTS; k++) {
        Point *p1 = *(points+k);
        printf("Point %d (%f,%f)\n", k, p1->x, p1->y);
    }

    if (points != NULL) {
        free(points);
    }

    return(0);
}

Point make_point(double x, double y) {
    Point p;
    p.x = x;
    p.y = y;
    return(p);
}
```