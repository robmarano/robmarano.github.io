# Homework 6 Solution Guide

These are the official solutions and mathematical breakdowns for **Homework 6**. Please review the concepts of the Program Counter's offset logic explicitly, as these foundational ideas will heavily dictate our understanding of Pipelined architectures moving forward into Chapter 4!

## 🔑 Answer Key: Solutions for Exercises 1-4

Below is the complete solution set and mathematical reasoning for all four exercises.

### Problem 1: Assessing CPU Performance

**A) Calculating the Classic Execution Time Equation**

Our textbook defines CPU Performance using the classic equation:
`Execution Time = Instruction Count (IC) * Cycles Per Instruction (CPI) * Clock Cycle Time`

We are given a 3-instruction assembly block:
*   **Instruction Count (IC):** 3
*   **CPI:** 1
*   **Clock Cycle Time:** 800ps

**Execution Time = 3 * 1 * 800ps = 2400ps**

**Why is CPI strictly 1?**
In a single-cycle datapath, the CPU completes fetching, decoding, executing, and writing back memory for exactly **one instruction per clock cycle**. Because every distinct command resolves entirely before the next clock edge, the Cycles Per Instruction ratio is intrinsically, absolutely `1`. No instruction takes 2 clock cycles, and no instruction can finish early in half a clock cycle to speed things up. It is rigidly 1:1.

---

### Problem 2: The MIPS Memory Layout

This problem verifies your structural understanding of the physical memory map the OS assigns to your executable process (`0x0040` upwards to `0x7FFF`).

*   **A.** The binary machine code (0s and 1s) representing compiled logic instructions -> **Text Segment (`0x00400000`)**
*   **B.** A dynamically requested block of memory allocated while the program actively runs (`malloc()`) -> **Heap** (growing upwards)
*   **C.** A static hard-coded ASCIZ string mathematically compiled into the source -> **Data Segment (`0x10000000`)**
*   **D.** The manually preserved caller-saved variables and Return Address breadcrumbs -> **Stack Segment (`0x7FFFFFFF`)** (growing downwards)

---

### Problem 3: Procedure Calls and the Stack

**The Overwritten `$ra` Vulnerability**

When you trigger a `jal` (Jump and Link) instruction to enter your *first* function, MIPS automatically overwrites the `$ra` (Return Address) register with the address of the *next* instruction (`PC + 4`) so it knows how to return to `main`. 

However, if your function attempts to call a helper function by natively executing a *second* `jal`, **the hardware overwrites `$ra` again!** The original address `main` gave you is completely erased from silicon memory, and you are permanently trapped in the nested depth of your code. 

**The Fix:**
You must manually *spill* (save) the value of `$ra` into the Stack before attempting to execute another `jal`.
1.  **Allocate space:** `addi $sp, $sp, -4` (expand the stack downwards by 1 word)
2.  **Save the integer address:** `sw $ra, 0($sp)` (store the link value)

When the nested function finishes, simply pop it back:
1.  **Retrieve:** `lw $ra, 0($sp)`
2.  **Deallocate:** `addi $sp, $sp, 4`

---

### Problem 4: Branching and The Pipelining Teaser

**A) The Relative `PC` Value**

Immediately right after fetching a branch or jump instruction, the hardware natively automatic increments the logic pointer. Therefore, inside the "branch delay slot" (during the execution of that specific conditional instruction), the relative value of the Program Counter evaluates strictly to **`PC + 4`**, pointing cleanly at the memory address of the very next consecutive line of generic instruction code.

**B) Addressing Paradigms (PC-Relative vs. Pseudodirect)**

While both branches and jumps utilize that same `PC + 4` origin momentarily, they calculate their final target offsets fundamentally differently:

*   **Branches (`beq`, `bne`) use *PC-Relative* Addressing:** A conditional branch simply adds its embedded 16-bit offset directly to the internal `PC+4` baseline. It strictly jumps *relative* to where it currently sits in code. 
*   **Jumps (`j`, `jal`) use *Pseudodirect* Addressing:** Unconditional Jumps do not mathematically *add* anything to the PC. Instead, they explicitly *replace* the lower 28 bits of the Program Counter register blindly with the absolute 26-bit specific address number embedded aggressively into the instruction format (after concatenating the uppermost 4 bits of the current `PC`). 

---

If your calculation in Problem 1 did not yield 2400ps, make sure you did not multiply instructions by themselves! The CPI locks our performance scaling tightly.
