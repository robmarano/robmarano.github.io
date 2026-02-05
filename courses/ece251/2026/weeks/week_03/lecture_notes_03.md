# Lecture Notes: ECE 251 – Session 03
**Topic:** Instructions — The Language & Grammar of Computers (Part 2)
**Date:** Thursday, Feb 5, 2026
**Time:** 6:00 PM – 8:50 PM

---

## I. Administrative & Warm-Up (6:00 – 6:15 PM)

**1. Housekeeping**
*   **Homework 2:** Due Sunday, Feb 8 before midnight.
*   **Homework 3:** Released today, due next Thursday (2/12).
*   **Software Check:** By now, everyone needs the MIPS emulator installed (SPIM/QtSPIM). We are going to start looking at code execution today. I'll cover that later in the lecture.

**2. Recap: The Grammar of the Machine**
*   *Last week/Review:* We covered **Arithmetic** (`add`, `sub`), **Memory** (`lw`, `sw`), and **Logic** (`sll`, `and`, `or`).
*   We learned how to translate these into **Machine Language** (the 32-bit binary) using **R-Type** and **I-Type** formats.
*   *Critical Concept:* **The Stored Program Concept**. Instructions are just data numbers. The processor doesn't know the difference between a number representing "Add" and a number representing the value "35". It relies on *us* (the programmers/compilers) to point the PC (Program Counter) to the right place.

---

## II. Making Decisions (Section 2.7) (6:15 – 7:00 PM)

**1. The Difference Between a Calculator and a Computer**
*   A calculator does fixed arithmetic. A computer makes **decisions**.
*   In C/Java, we use `if`, `else`, `while`, `for`.
*   In MIPS, we use **Conditional Branches**.

**2. Conditional Branch Instructions**
*   **`beq register1, register2, L1`**: Branch if Equal.
    *   Go to statement labeled `L1` if `reg1 == reg2`.
*   **`bne register1, register2, L1`**: Branch if Not Equal.
    *   Go to statement labeled `L1` if `reg1 != reg2`.
*   *Note:* These use **I-Type format**. The address is an offset.

**3. Unconditional Jumps**
*   **`j L1`**: Jump. Go to label `L1` no matter what.
*   *Example:* Building an `if/else` structure.
    *   C Code: `if (i == j) f = g + h; else f = g - h;`
    *   MIPS Logic:
        1.  `bne $s3, $s4, Else` (If i!=j, skip the "then" part).
        2.  `add $s0, $s1, $s2` (The "then" part: f = g + h).
        3.  `j Exit` (Skip the "else" part).
        4.  `Else: sub $s0, $s1, $s2` (The "else" part).
        5.  `Exit:`.

**4. Loops**
*   A `while` loop is just a decision (branch) that points back to a previous label.
*   **Basic Block:** A sequence of instructions without branches (except at the end) and without branch targets (except at the start). Compilers love these for optimization.

**5. Inequalities (Set Less Than)**
*   What about `if (a < b)`?
*   MIPS does not have a `blt` (branch less than) instruction. *Why?*
    *   **Design Principle 3: Make the Common Case Fast.** Complex comparisons slow down the clock cycle.
*   Instead, we use **`slt` (Set Less Than)**.
    *   `slt $t0, $s1, $s2`: If `$s1 < $s2`, set `$t0` to 1. Else 0.
    *   Then we use `bne $t0, $zero, Label` to branch.
*   *Signed vs. Unsigned:* `slt` treats numbers as Two's Complement. `sltu` treats them as unsigned (useful for array bounds checking).

### Using the Assembler (`spim`)

---

## III. Supporting Procedures (Section 2.8) (7:00 – 7:45 PM)

**1. The Function Call Abstraction**
*   In programming, functions allow code reuse. In hardware, this requires a strict protocol.
*   **The Six Steps of Execution:**
    1.  Put parameters where the procedure can access them.
    2.  Transfer control to the procedure.
    3.  Acquire storage resources (memory) for the procedure.
    4.  Perform the task.
    5.  Put result values where the calling program can access them.
    6.  Return control to the point of origin.

**2. MIPS Register Conventions**
*   To make this fast, we dedicate specific registers (Simplicity favors regularity):
    *   **$a0 – $a3:** Four argument registers to pass inputs.
    *   **$v0 – $v1:** Two value registers to return results.
    *   **$ra:** Return Address register (31).

**3. Instructions for Linking**
*   **`jal ProcedureAddress` (Jump and Link):**
    *   Jumps to the address.
    *   *Simultaneously* saves `PC + 4` into `$ra` (so the procedure knows where to go back to).
*   **`jr $ra` (Jump Register):**
    *   Unconditional jump to the address stored in `$ra`. This is your `return` statement.

---

## IV. BREAK (7:45 – 7:55 PM)

---

## V. The Stack & Memory Layout (7:55 – 8:30 PM)

**1. Spilling Registers**
*   *Problem:* What if my function needs more than 4 arguments? Or needs to calculate complex things using `$s0` (which belongs to the caller)?
*   *Solution:* We spill to **Memory**. specifically, the **Stack**.
*   **The Stack:** A Last-In-First-Out (LIFO) queue.
    *   **$sp (Stack Pointer):** Register 29. Points to the most recently allocated address.
    *   In MIPS, the stack grows **down** (from high addresses to low addresses).
    *   *Push:* Subtract from `$sp`, then `sw` (store word).
    *   *Pop:* `lw` (load word), then add to `$sp`.

**2. Nested Procedures**
*   What happens if function A calls function B?
*   If A calls B, `jal` will overwrite `$ra`. A will forget how to get home!
*   *Rule:* The caller must save `$ra` on the stack before calling another function, and restore it after the callee returns.

**3. Memory Map of a Program**
*   **Text Segment:** Where the machine code lives.
*   **Static Data:** Global variables / constants.
*   **Heap:** Dynamic data (malloc/new) grows *up*.
*   **Stack:** Local variables/saved registers grows *down*.

---

## VI. Addressing & Large Constants (Section 2.10) (8:30 – 8:50 PM)

**1. 32-Bit Constants**
*   I-Type instructions only have 16 bits for constants (`addi`, `lw`). What if we need a 32-bit constant?
*   **`lui $t0, constant` (Load Upper Immediate):** Loads the top 16 bits.
*   **`ori $t0, $t0, constant`:** Loads the bottom 16 bits.
*   The assembler often handles this using the reserved register `$at`.

**2. Addressing Modes Summary**
*   We now know all 5 ways MIPS finds operands:
    1.  **Immediate addressing:** (operand is in the instruction).
    2.  **Register addressing:** (operand is in a register).
    3.  **Base addressing:** (operand is in memory at `Register + Offset`).
    4.  **PC-relative addressing:** (branches `beq`: `PC + 4 + Offset`).
    5.  **Pseudodirect addressing:** (jump `j`: absolute address combined with PC).

**3. Wrap Up**
*   Next week (Week 4): We stop talking about instructions abstractly and start building hardware models using **Verilog**.
*   **Reading:** Start looking at the Verilog notes.
*   **Homework:** Do HW 3. Practice tracing the stack in your head—it's where most bugs happen in assembly!