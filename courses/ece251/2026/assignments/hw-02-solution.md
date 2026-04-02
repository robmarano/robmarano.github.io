# Assignment 2 - Solution Key

< 5 points >

<details>
<summary>Homework Pointing Scheme</summary>

| Total points | Explanation |
| -----------: | :--- |
| 0 | Not handed in |
| 1 | Handed in late |
| 2 | Handed in on time, not every problem fully worked through and clearly identifying the solution |
| 3 | Handed in on time, each problem answered a boxed answer, each problems answered with a clearly worked through solution, and **less than majority** of problems answered correctly |
| 4 | Handed in on time, **majority** of problems answered correctly, each solution boxed clearly, and each problem fully worked through |
| 5 | Handed in on time, every problem answered correctly, every solution boxed clearly, and every problem fully worked through. |

</details>

---

## Textbook Problem Solutions (Chapter 2)

### Problem 1 
**For the C statement,**
`f = g + (h - 5);`
**what is the corresponding MIPS assembly code?**

The MIPS architecture mandates that arithmetic instructions process exactly two operands. Therefore, we must formally decompose the complex C statement into a two-step mathematical sequence using a temporary register (`$t0`). Because we are subtracting a constant, we logically utilize the `addi` (Add Immediate) instruction employing a negative literal.

**MIPS Translation:**
```mips
addi $t0, $s2, -5     # Step 1: Calculate (h - 5) and securely store the result into temporary register $t0
add  $s0, $s1, $t0    # Step 2: f = g + $t0 -> Calculate the final sum and store it directly into $s0
```

---

### Problem 2
**Translate the following MIPS code to C:**
```mips
addi $t0, $s6, 4
add $t1, $s6, $0
sw $t1, 0($t0)
lw $t0, 0($t0)
add $s0, $t1, $t0
```

To translate this gracefully back into C, we must structurally track what each register physically maps to inside the system's memory array.
*   `$s6` rigidly holds the absolute base address pointer for integer array `A` (i.e., `&A[0]`). Since integers are 4 bytes long in memory, adding `4` to the base address cleanly targets the second element `A[1]`.

**Line-by-Line Breakdown:**
1.  `addi $t0, $s6, 4` $\rightarrow$ Temporarily set `$t0` to the specific address of the second element (`&A[1]`).
2.  `add $t1, $s6, $0` $\rightarrow$ Temporarily set `$t1` precisely to the base address of `A` (`&A[0]`).
3.  `sw $t1, 0($t0)` $\rightarrow$ Structurally Store the pointer value circulating in `$t1` into the RAM memory slot targeted by `$t0`. In C, this is assigning a value: `A[1] = (int)&A[0];`
4.  `lw $t0, 0($t0)` $\rightarrow$ Overwrite `$t0` by Loading the Word residing physically at location `$t0`. Since we just put `&A[0]` into `A[1]`, `$t0` now captures `&A[0]`.
5.  `add $s0, $t1, $t0` $\rightarrow$ Compute `$s0 = $t1 + $t0`. Because both registers structurally contain `&A[0]`, we are adding the base address pointer to itself.

**Complete C Statement:**
```c
A[1] = (int)A; 
f = (int)A + A[1];     // Or simply f = (int)A + (int)A;
```

---

### Problem 3
**For each MIPS instruction in Problem #2 above, show the value of the opcode (op), source register (rs) and funct field, and destination register (rd) fields.**

*   **Register Mapping Protocol:** `$0 = 0`, `$t0 = 8`, `$t1 = 9`, `$s0 = 16`, `$s6 = 22`.
*   **R-Type Instruction Structure:** Opcode is identically `0`. The specific math algorithm is explicitly defined purely by the `funct` tracking field (e.g., `add` = 32). They lack an immediate value.
*   **I-Type Instruction Structure:** Utilizes an integrated Opcode, completely lacks `rd`, `shamt`, and `funct` fields, and terminates with a 16-bit physical immediate offset limit.

| Instruction | Type | Opcode (Decimal) | rs | rt | rd | Funct | Immed |
| :--- | :---: | :---: | :---: | :---: | :---: | :---: | :---: |
| `addi $t0, $s6, 4` | **I** | 8 | 22 (`$s6`) | 8 (`$t0`) | N/A | N/A | 4 |
| `add $t1, $s6, $0` | **R** | 0 | 22 (`$s6`) | 0 (`$0`) | 9 (`$t1`) | 32 | N/A |
| `sw $t1, 0($t0)` | **I** | 43 | 8 (`$t0`) | 9 (`$t1`) | N/A | N/A | 0 |
| `lw $t0, 0($t0)` | **I** | 35 | 8 (`$t0`) | 8 (`$t0`) | N/A | N/A | 0 |
| `add $s0, $t1, $t0`| **R** | 0 | 9 (`$t1`) | 8 (`$t0`) | 16 (`$s0`)| 32 | N/A |
