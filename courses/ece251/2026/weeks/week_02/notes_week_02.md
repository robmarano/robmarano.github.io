# Notes for Week 2
[ &larr; back to syllabus](/courses/ece251/2026/ece251-syllabus-spring-2026.html) [ &larr; back to notes](/courses/ece251/2026/ece251-notes.html)

# Topics

1. Recap: Stored Program Concept, and the history of computer architecture and modern advancements
2. The alphabet, vocabulary, grammar of computers
   1. `1`s and `0`s as the **alphabet**
   2. compute and memory **instructions** as the **vocabulary**
   3. **implementation** of compute and memory instructions as the **grammar**
3. Introducing the **instructions** of a computer delivered by the architecture
   1. Operations of the computer hardware
   2. Operands of the computer hardware
   3. Signed and unsigned numbers
   4. Representing instructions in the computer
   5. Logical operations

# Topics Deep Dive

## Instructions: The Language of the Computer

### Operations of the Computer Hardware
Every computer must be able to perform arithmetic. The MIPS instruction set includes:
- `add a, b, c`  # The sum of b and c is placed in a.
- `sub a, b, c`  # The difference of b and c is placed in a.

### Operands of the Computer Hardware
- **Register Operands**: Arithmetic instructions usage register operands. MIPS has a 32 x 32-bit register file.
- **Memory Operands**: Data transfer instructions (`lw`, `sw`) move data between memory and registers.
- **Constant or Immediate Operands**: Arithmetic instructions can use constants for the second source operand (e.g., `addi`).

### Signed and Unsigned Numbers
- Representation of numbers in binary (Two's Complement).

### Representing Instructions in the Computer
- **R-Type** (Register)
- **I-Type** (Immediate)
- **J-Type** (Jump)

### Logical Operations
- `sll`, `srl`
- `and`, `or`, `nor`, `xor`

[ &larr; back to syllabus](/courses/ece251/2026/ece251-syllabus-spring-2026.md) [ &larr; back to notes](/courses/ece251/2026/ece251-notes.md)
