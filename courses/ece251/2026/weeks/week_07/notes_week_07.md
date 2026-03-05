# Notes for Week 7 (Session 7)
[ &larr; back to syllabus](/courses/ece251/2026/ece251-syllabus-spring-2026.html) [ &larr; back to notes](/courses/ece251/2026/ece251-notes.html)

# Today's Agenda: The Culmination of Assembly & Project Kickoff
1. **Advanced Assembly Patterns**
    *   Iterating Arrays and Strings
    *   Deep Dive: Tracing Recursive Procedures
2. **The Final Group Project Launch**
    *   Designing the Minimum Lovable Product (MLP)
    *   SystemVerilog CPU, Python Assembler, and Team Logistics
3. **Midterm Exam Preparation**

---

# Topic Deep Dive

## 1. Advanced Assembly Patterns

We've mastered the mechanical foundations of MIPS: the load-store architecture, memory layouts, control flow (`beq`/`j`), and basic procedure calling. Today, we bridge these isolated mechanics to write complex, algorithmic software natively in hardware.

### Iterating Arrays and Words
When we talk about "Arrays" in assembly, we are merely talking about a contiguous block of data sitting in Main Memory (usually the `.data` or Heap segments). Because MIPS memory is byte-addressed, and our standard integers ("words") are 32 bits (4 bytes) long, we cannot simply increment an array index by `1` to move to the next integer. We must increment our memory pointer by `4`.

**Example: Summing an Array of 5 Integers**
```assembly
    .data
myArray: .word 10, 20, 30, 40, 50   # 5 integers (20 bytes total)
length:  .word 5

    .text
    .globl main
main:
    la  $t0, myArray    # $t0 = Base address pointer of the array
    lw  $t1, length     # $t1 = Total elements (5)
    li  $t2, 0          # $t2 = Current index counter (starts at 0)
    li  $t3, 0          # $t3 = Running sum accumulator (starts at 0)
    
Loop_Start:
    beq $t2, $t1, Loop_End  # If counter == length, we're done! Exit loop.
    
    lw  $t4, 0($t0)         # Load the physical word at the current pointer address
    add $t3, $t3, $t4       # Add it to our running sum
    
    addi $t0, $t0, 4        # CRITICAL: Shift the memory pointer up by 4 bytes!
    addi $t2, $t2, 1        # Increment our logical loop counter by 1
    
    j   Loop_Start          # Unconditionally jump back up to evaluate the next loop

Loop_End:
    # ... Print $t3 and exit ...
```

### String Manipulation (Byte-by-Byte)
Strings (`.asciiz`) are handled differently than arrays of integers. Every ASCII character occupies exactly 1 byte (8 bits). 
Therefore, to iterate through a string, you **do not** shift your memory pointer by `4` (which would skip 3 characters). You shift your pointer by `1`. You also use `lb` (Load Byte) instead of `lw` (Load Word).

*Note:* `.asciiz` automatically appends a "Null Terminator" (a literal binary `0x00`) to the end of your string. Your loop condition simply searches for this zero byte to know when the string is entirely finished!

### Deep Dive: Tracing Recursive Procedures
Recursion is when a function calls *itself* back-to-back until it hits a base condition. It is the ultimate test of your **Stack Management** (`$sp`), because every single recursive layer aggressively overwrites the `$ra` (Return Address) tracker and the `$a0` arguments!

**The Factorial Example (`n!`)**
Let's trace how the CPU physically builds the stack frame when calculating `factorial(3)`.

1. `main` calls `factorial(3)`. `$a0 = 3`. The CPU saves `main`'s return address in `$ra`.
2. Inside `factorial`: The function pushes a "plate" onto the Stack (`addi $sp, $sp, -8`). It saves its current `$ra` and `$a0` values rigidly into memory. 
3. It subtracts 1 from `$a0` (`$a0 = 2`) and calls `jal factorial`.
4. The cycle repeats! A new layer is built. The Stack physically grows downwards inside the CPU representing `factorial(2)` inside `factorial(3)` inside `main`.

When the base case `factorial(1)` is finally breached, the recursion violently collapses *upwards*. 
The CPU systematically calculates the math, issues `lw` to pop the saved `$ra` and `$a0` values back off their respective stack plates, destroys the physical stack slot (`addi $sp, $sp, 8`), and utilizes `jr $ra` to seamlessly return up the chain of functions. If a single stack `push/pop` operation triggers out of order, the entire program fatally crashes into the void of memory.

---

## 2. The Final Group Project Launch

Today commemorates the official assignment of your **Final Group Project** (due May 15th)! This project encompasses the primary educational objective of ECE 251: you will organically build your own computer from scratch.

### The Problem Statement
You will choose a partner (Teams of 2). Together, you will design and implement a central processing unit (CPU) alongside a functional memory system that physically emulate execution via SystemVerilog software. You will define a custom Instruction Set Architecture (ISA), write an assembler tool in Python to translate text into binary, and run custom assembly programs directly on your silicon logic structure.

### The Minimum Lovable Product (MLP)
We aggressively model this project around the industry-standard concept of the Minimum Viable Product (MVP), or as Amazon Web Services calls it, the Minimum Lovable Product (MLP).

Do not attempt to build an enormously complex machine until your core foundation executes perfectly. 
1. Map out 8 core, mathematically distinct instructions.
2. Build the SystemVerilog Logic Gates to support just those 8. 
3. Write the Python tool to compile those 8 strings.
4. If it boots successfully, *then* begin adding advanced features (like pipelining or interrupts) for the remaining 30 Extra Credit points!

### Administrative Logistics
1. **GitHub Repository:** Teams will manage all source code and project documentation inside a highly organized GitHub structure.
2. **Task Management:** Break the MLP down into manageable tasks. Use GitHub Issues to cleanly document who is physically responsible for what deliverable and when.
3. **The Presentation:** The final demonstration will consist of a pre-recorded, 5-minute maximum YouTube technical presentation embedded directly into your `README.md`. 

Please immediately refer to the formal [Grading Rubric for Final Project](../assignments/grading_rubric_final_project.md) on the class portal.

---

## 3. Midterm Exam Preparation

Next week (Session 8: March 12th) represents the **Midterm Exam**. We have covered an immense amount of foundational computing architecture since January.

The Midterm will heavily assess the following comprehensive topics:
1. **Logic, Combinational, & Sequential Circuits:** Translating boolean equations into hardware logic gates. Truth tables, Karnaugh maps, Multiplexors, and Flip-Flops.
2. **Hardware Modeling (SystemVerilog):** Structuring `assign` dataflows, combinatorial block rules versus sequential `always_ff` edge-triggered operations, and the explicit differences between Blocking (`=`) and Non-Blocking (`<=`) assignments physically altering silicon synthesis.
3. **MIPS Architecture Overview:** Applying the 4 core design principles of MIPS, evaluating performance (IC x CPI x Clock time), and mapping memory out spatially (Text, Data, Heap, Stack).
4. **Assembly Programming:** Simulating code blocks tracing loops (`bne`/`beq`), array manipulations, translating standard C structures (`if/else/while`), and procedure tracking (`jal`, `$ra`, `$sp` execution chains).

Begin aggressively studying the posted [Midterm Study Guide](../assignments/study_guide_midterm.md). Office hours will dynamically switch to structured, review-oriented topic overviews!

---
[ &larr; back to syllabus](/courses/ece251/2026/ece251-syllabus-spring-2026.html) [ &larr; back to notes](/courses/ece251/2026/ece251-notes.html)
