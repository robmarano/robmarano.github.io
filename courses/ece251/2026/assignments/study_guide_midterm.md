# ECE 251: Midterm Study Guide (Spring 2026)

This comprehensive study guide encompasses the foundational curriculum introduced during Weeks 01-07, aligning intimately with Chapters 1 and 2 of the formal textbook. 

To best prepare for the Midterm Examination, students must be capable of bridging physical mathematics (latency, clock cycles) with logic design (K-Maps, Boolean Expansion), and software compilation (C arrays mapped to raw MIPS Machine Code).

---

## Table of Contents
1. [Chapter 1: Computer Abstractions and Technology](#chapter-1-computer-abstractions-and-technology)
2. [Chapter 2: Instructions (Language of the Computer)](#chapter-2-instructions-language-of-the-computer)

---

## Chapter 1: Computer Abstractions and Technology

### Key Concepts
- **The Power Wall:** The phenomenon where clock frequencies peaked near 2004 due to exponential thermal dissipation limits, forcing the industry to shift from single-core uniprocessors to multi-core architectures.
- **CPU Execution Time:** The fundamental benchmark of true hardware performance.
  $$\text{CPU Time} = \text{Instruction Count} \times \text{CPI} \times \text{Clock Cycle Time}$$
  $$\text{CPU Time} = \frac{\text{Instruction Count} \times \text{CPI}}{\text{Clock Rate}}$$

### Worked Example 1.1: Clock Rate Optimization
**Problem:** Our favorite program runs in 25 seconds on $Computer_A$, which has a 2 GHz clock. We are trying to help a computer designer build a $Computer_B$, which will run this program in 5 seconds. The designer has determined that a substantial increase in the clock rate is possible, but this increase will affect the rest of the CPU design, causing $Computer_B$ to require 1.2 times as many clock cycles as $Computer_A$ for this program. What clock rate should we tell the designer to target?

**Solution:**
1. Calculate the raw number of structural clock cycles required for Computer A:
   $$\text{CPU Time}_A = \frac{\text{Clock Cycles}_A}{\text{Clock Rate}_A}$$
   $$25 \text{ s} = \frac{\text{Clock Cycles}_A}{2 \times 10^9 \text{ Hz}}$$
   $$\text{Clock Cycles}_A = 25 \times 2 \times 10^9 = 50 \times 10^9 \text{ cycles}$$
2. Calculate the required clock cycles allocated for Computer B:
   $$\text{Clock Cycles}_B = 1.2 \times \text{Clock Cycles}_A = 1.2 \times 50 \times 10^9 = 60 \times 10^9 \text{ cycles}$$
3. Determine the target clock rate necessary for Computer B to finish processing in exactly 5 seconds:
   $$\text{CPU Time}_B = \frac{\text{Clock Cycles}_B}{\text{Clock Rate}_B}$$
   $$5 \text{ s} = \frac{60 \times 10^9 \text{ cycles}}{\text{Clock Rate}_B}$$
   $$\text{Clock Rate}_B = \frac{60 \times 10^9}{5} = 12 \times 10^9 \text{ Hz} = 12 \text{ GHz}$$

### Worked Example 1.2: CPI and Compiling Code Sequences
**Problem:** A compiler designer is trying to decide between compiling two specific hardware code sequences. They evaluate three unique instruction architectures:
| Metric | Class A | Class B | Class C |
| --- | --- | --- | --- |
| Hardware CPI | 1 | 2 | 3 |

*   **Code Sequence 1 requires:** 2 (Class A), 1 (Class B), 2 (Class C).
*   **Code Sequence 2 requires:** 4 (Class A), 1 (Class B), 1 (Class C).

Which code sequence executes the most instructions? Which will be faster? What is the CPI for each sequence?

**Solution:**
1. **Total Instruction Counts:**
   - Sequence 1: $2 + 1 + 2 = 5$ instructions natively.
   - Sequence 2: $4 + 1 + 1 = 6$ instructions natively.
   - **Answer:** *Sequence 2 executes the most hardware instructions.*
2. **Execution Latency (in physical Clock Cycles):**
   - Cycles for Sequence 1 = $(2 \times 1) + (1 \times 2) + (2 \times 3) = 2 + 2 + 6 = 10 \text{ clock cycles}$.
   - Cycles for Sequence 2 = $(4 \times 1) + (1 \times 2) + (1 \times 3) = 4 + 2 + 3 = 9 \text{ clock cycles}$.
   - **Answer:** *Sequence 2 is physically faster (9 cycles vs 10 cycles), despite having more instructions!*
3. **Average CPI Mapping:**
   - $\text{CPI}_1 = \frac{\text{Total Cycles}_1}{\text{Instruction Count}_1} = \frac{10}{5} = 2.0$
   - $\text{CPI}_2 = \frac{\text{Total Cycles}_2}{\text{Instruction Count}_2} = \frac{9}{6} = 1.5$


---

## Chapter 2: Instructions (Language of the Computer)

### Key Concepts & ISA Basics
- **MIPS Registers:** `$t0-$t9` (temporary), `$s0-$s7` (saved across calls), `$a0-$a3` (arguments), `$v0-$v1` (return values), `$ra` (return address), `$sp` (stack pointer).
  - *From the Green Sheet:* Registers `$s0-$s7` must be structurally saved/restored by the callee if modified, whereas `$t0-$t9` are caller-saved.
- **Assembly Language Structure:**
  - `.data`: Physical memory section for declaring global data and static variables in RAM.
  - `.text`: Executive section for code instructions. The `main:` label designates the mainline execution entry point.
- **Instruction Formats & bit-wise Decoding:** Every MIPS instruction decodes into a strict 32-bit pattern, divided into control definitions:
  - **R-Type:** `opcode(6) | rs(5) | rt(5) | rd(5) | shamt(5) | funct(6)`
    - *Decoding:* Used for arithmetic/logical operations between hardware registers. `opcode` is inherently 0; `funct` dictates the exact physical operation to route to the ALU. `shamt` determines the shift amount.
  - **I-Type:** `opcode(6) | rs(5) | rt(5) | immediate(16)`
    - *Decoding:* Used for loads/stores, branching relative addresses, and arithmetic with constants. The 16-bit immediate is mathematically mapped (usually via 2s-complement) to determine structural offsets.
  - **J-Type:** `opcode(6) | address(26)`
    - *Decoding:* Used for unconditional jumps. The native 26-bit target address shifted left by 2 bytes maps the absolute jump destination.
- **Procedures and Stack Execution (`$sp`):**
  - **Leaf Procedures:** Functions that do not natively call other functions. They allocate physical stack space by moving `$sp` downward (`addi $sp, $sp, -X`), store any utilized `$s0-$s7` registers out of harm's way, execute logical manipulations, pop them back symmetrically, and structurally return using `jr $ra`.
  - **Nested Procedures:** Functions that call other isolated functions. Because the internal `jal` (Jump and Link) permanently overwrites `$ra` with a new return address, a nested procedure *must* save its primary `$ra` physically onto the stack. After the internal `jal` concludes, it carefully restores that original `$ra` off the stack before finalizing its own return via `jr $ra`.

### Worked Example 2.1: Binary & Two's Complement Constraints
**Problem:** Determine the two's complement constraint integer for the raw binary address `11100111`.
**Solution:**
*(Note: This concept is mathematically critical for understanding MIPS Branch offsets and calculating Signed Immediate addresses).*
1. Invert the independent bits: `00011000`
2. Add physical 1 to the logic: `00011001` (representing `25` decimal).

### Worked Example 2.2: Instruction Compilation & Addressing
**Problem:** Convert the following MIPS instruction into its corresponding 32-bit hexadecimal machine code representation: `lw $t1, -4($s3)`
**Solution:**
1. Analyze the format natively: I-Type (`opcode rs rt immediate`)
2. `lw` opcode: `0x23` or $35$ decimal (`100011` binary)
3. `rs` (base register): `$s3` maps to array register $19$ (`10011` binary)
4. `rt` (destination register): `$t1` maps to array register $9$ (`01001` binary)
5. `immediate`: The integer `-4` written mathematically in 16-bit two's complement.
   - Positive $4$: `0000 0000 0000 0100` -> Invert to: `1111 1111 1111 1011` -> Add 1: `1111 1111 1111 1100` (`0xFFFC`)
6. Construct the raw 32-bit binary layout:
   `100011` | `10011` | `01001` | `1111 1111 1111 1100`
7. Combine and calculate hexadecimal sequence:
   `1000 1110 0110 1001 1111 1111 1111 1100`
   **`0x8E69FFFC`**

### Worked Example 2.3: Virtual Memory Layout & Row-Major Storage
**Problem:** Consider the C language declaration `char x[8][3];`. If `x[0][2]` happens to be stored at memory address `0x20c`, at which memory address would `x[2][1]` physically be stored? Assume little-endian memory and row-major array storage methodologies.
**Solution:**
1. Array indices are explicitly 0-based. The array generates 8 rows of 3 columns, where each physical `char` takes exactly 1 byte.
2. The distance from the origin `x[0][0]` to any offset `x[i][j]` equals `(i * 3) + j` independent bytes.
3. Therefore, `x[0][2]` sits at structural index 2 ($0 \times 3 + 2$). Its base address `x[0][0]` must logically be `0x20c - 2 = 0x20a`.
4. We need to find `x[2][1]`. Its raw offset from the base integer is `(2 * 3) + 1 = 7` bytes.
5. Final Memory Address = `0x20a + 7` = **`0x211`**.

### Worked Example 2.4: Translating C Arrays directly to MIPS Assembly
**Problem:** Hand-compile the following C `for` loop iteration into structural MIPS assembly. Assume `$s0 = &arr[0]` and `$s1 = size = 10`. The variables `sum`, `pos`, and `neg` represent `$t0`, `$t1`, and `$t2` respectively (all natively initialized to $0$). `$t3` operates iteratively as variable `i`.

```c
for (i = 0; i < size; i++) {
    sum += arr[i];
    if (arr[i] > 0)
        pos += arr[i];
    if (arr[i] < 0)
        neg += arr[i];
}
```

**Solution:**
```mips
# Initialize working variables iteratively
    add $t0, $0, $0   # sum = 0
    add $t1, $0, $0   # pos = 0
    add $t2, $0, $0   # neg = 0
    add $t3, $0, $0   # i = 0

FOR_LOOP:
    slt $t4, $t3, $s1 # Evaluate: $t4 = 1 if i < size
    beq $t4, $0, DONE # IF i >= size implies $t4 == 0, break loop sequentially
    
    # Calculate physical address for array extraction: arr[i]
    sll $t5, $t3, 2   # $t5 = i * 4 (shifting 2 bytes extracts Word offsets)
    add $t5, $s0, $t5 # $t5 = base address origin + mathematical offset
    lw  $t6, 0($t5)   # Register $t6 structurally now holds arr[i]
    
    add $t0, $t0, $t6 # Evaluate integer logic: sum += arr[i]
    
    # if (arr[i] > 0)
    slt $t7, $0, $t6  # $t7 = 1 if (0 < arr[i]) translating directly to (arr[i] > 0)
    beq $t7, $0, CHECK_NEG
    add $t1, $t1, $t6 # Implement logic: pos += arr[i]
    
CHECK_NEG:
    # if (arr[i] < 0)
    slt $t7, $t6, $0  # $t7 = 1 if (arr[i] < 0)
    beq $t7, $0, NEXT_ITER
    add $t2, $t2, $t6 # Implement logic: neg += arr[i]
    
NEXT_ITER:
    addi $t3, $t3, 1  # Iterate counter: i++
    j FOR_LOOP        # Jump structurally to repeat evaluation block

DONE:
    # Function successfully routed and finalized natively
```

---

## 3. SystemVerilog Basics (Hardware Construction)
**Course Coverage:** Weeks 01-05

Replacing abstract block diagrams from our older syllabus, we now enforce explicit SystemVerilog (IEEE 1800) descriptions. You must be able to design, simulate, and analyze hardware circuits programmatically.

### Simulation and Module Construction
*   **Combinational vs Sequential Logic:** Pure functional pipelines without memory vs. clock-driven edge-triggered state machines.
*   **Standard Modules:** Be prepared to draft the SV code for Multiplexors, Decoders, Encoders, D Flip-Flops, and Clock Dividers.
*   **Execution Verification (Testbenches):** Understand the structure of `tb_module.sv`. You must know how to instantiate a Device Under Test (DUT), initialize vectors inside `initial` blocks, apply delays (`#10`), and trap asserts using `$display` or `$monitor`.
*   **8-bit Conditional ALU:** Recall your homework involving the parameterized ALU. Be able to analyze a combinational `always_comb` block that drives logic based off a switch statement checking an operation code.

### Worked Example 3.1: Karnaugh Map Logic Simplification (CSCI 155 Fall 2014, Exam 1)
**Problem:**
Design a three-input minimal AND-OR (minimal sum form) circuit implementing the following truth table for $F(A, B, C)$:

| A | 0 | 0 | 0 | 0 | 1 | 1 | 1 | 1 |
|:-:|:-:|:-:|:-:|:-:|:-:|:-:|:-:|:-:|
| B | 0 | 0 | 1 | 1 | 0 | 0 | 1 | 1 |
| C | 0 | 1 | 0 | 1 | 0 | 1 | 0 | 1 |
| **F** | **1** | **1** | **0** | **0** | **1** | **1** | **0** | **1** |

Please provide the detailed design calculations, including the Karnaugh map simplification.

**Solution:**
1. Identify the minterms where $F = 1$. The truth table rows (enumerating $A,B,C$ as binary strings $000$ to $111$) yield minterms: $m_ {0}, m_ {1}, m_ {4}, m_ {5}, m_ {7}$.
2. Map these into a 3-variable K-Map where the columns denote $AB$ (00, 01, 11, 10) and the rows denote $C$ (0, 1):
   - $m_ {0} (000) \rightarrow 1$
   - $m_ {1} (001) \rightarrow 1$
   - $m_ {4} (100) \rightarrow 1$
   - $m_ {5} (101) \rightarrow 1$
   - $m_ {7} (111) \rightarrow 1$
3. Group the 1s to simplify the logic:
   - Group 1: The entire block when $B=0$ ($m_ {0}, m_ {1}, m_ {4}, m_ {5}$) yields the term $\overline{B}$.
   - Group 2: The block combining $m_ {5}$ and $m_ {7}$ when $A=1$ and $C=1$ yields the term $AC$.
4. **Final Minimized Logic:**  
   $$F(A,B,C) = \overline{B} + AC$$

### Worked Example 3.2: Boolean Expansion (CSCI 155 Fall 2014, Exam 1)
**Problem:**
Express $F(x,y,z) = \overline{(\overline{x}+y)} + \overline{x}y$ in complete sum-of-products form using variables $x$, $y$, and $z$.

**Solution:**
1. **Apply DeMorgan's Theorem** to the first complex term: $\overline{(\overline{x}+y)} = \overline{\overline{x}} \cdot \overline{y} = x\overline{y}$.
2. The intermediate function is now: $F = x\overline{y} + \overline{x}y$. (Notice this is an explicit XOR gate $x \oplus y$).
3. **Expand to complete sum-of-products (minterms)** by multiplying the isolated terms by $(z + \overline{z})$, as substituting $1$ mathematically changes nothing:
   - $F = x\overline{y}(z + \overline{z}) + \overline{x}y(z + \overline{z})$
   - $F = x\overline{y}z + x\overline{y}\overline{z} + \overline{x}yz + \overline{x}y\overline{z}$
4. **Final Complete Form:**
   $$F(x,y,z) = x\overline{y}z + x\overline{y}\overline{z} + \overline{x}yz + \overline{x}y\overline{z}$$
