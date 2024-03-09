# In-Class problem set for converting C code into MIPS assembly code.

The two problems are as follows. Chance to earn 20 points.

# Problem 1 <10 points>
⁠Assume that the variables f, g, h, i, and j are assigned to registers $s0, $s1, $s2, $s3, and $s4, respectively. Assume that the base address of the arrays A and B are in registers $s6 and $s7, respectively. Convert the following C code to its corresponding MIPS assembly code:
```c
f = g - A[B[4]];
```

# Problem 2 <10 points>
 
Convert the following C procedure, swap(a,b): this takes the original value of a and stores in b, and the original value of b is stored in a.

```c
void swap(int *a, int *b) {
  int temp = *a;
  *a = *b;
  *b = temp;
}
```
 
These links will help you.

⁠https://vbrunell.github.io/docs/C%20to%20MIPS.pdf
⁠https://cseweb.ucsd.edu/classes/sp14/cse141-a/Slides/01_ISA-Part%20I-0410.pdf
THIS IS OPEN BOOK.