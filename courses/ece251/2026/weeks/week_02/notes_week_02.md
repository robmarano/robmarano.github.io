# Notes for Week 2
[ &larr; back to syllabus](/courses/ece251/2026/ece251-syllabus-spring-2026.html) [ &larr; back to notes](/courses/ece251/2026/ece251-notes.html)

[Slides for Class 02](https://cooperunion.sharepoint.com/:p:/s/Section_ECE-251-B-2026SP/IQB6icCVVOt9TKTRI2o1_hKWAR404UBPO9HyD9GYTg3HWm8?e=SFLWPW)

# Topics
1. Recap Computer Architecture and the Stored Program Concept
2. Introducing the **instructions** of a computer delivered by the architecture
   1. Operations of the computer hardware
   2. Operands of the computer hardware
   3. Signed and unsigned numbers
   4. Representing instructions in the computer
   5. Logical operations
   
# Topics Deep Dive

## Recap: What is Computer Architecture?

Computer architects define the fundamental organization and behavior of a computer system, enabling both hardware implementation and software execution.

## Recap:The Five Classic Components of a Computer

These five components are interconnected by data, address, and control buses, which are sets of wires that carry data and control signals.

<img src="../../images/computer_5_parts.jpg" alt="Five Parts of a Computer" width="50%" />

## Recap:The Stored Program Concept

The stored program concept is the idea of storing both the instructions (the program) and the data in the computer's memory.  This allows for:

* **Flexibility:**  Changing programs becomes as simple as loading a new set of instructions into memory.
* **Automation:**  The computer can fetch and execute instructions sequentially without human intervention.
* **Efficiency:**  Data and instructions can be accessed and manipulated quickly from memory.

This concept is fundamental to how all modern computers operate.

## Recap: von Neumann vs. Harvard Architectures

<img src="../../images/von_neumann_vs_harvard.jpg" alt="Von Neumann vs. Harvard Architectures" width="70%" />

Remember, the **von Neumann bottleneck** arises because both instructions and data must travel over the same bus to and from memory.  This can limit performance, especially when the CPU needs to fetch instructions and data frequently.  The Harvard architecture mitigates this by allowing parallel access to instruction and data memories.

## Recap: Performance of a Computer

Here's a breakdown of key aspects of computer performance:

**1. Execution Time:**
**2. Throughput:**
**3. Latency:**
**4. Resource Utilization:**
**5. Power Consumption:**
**6. Cost:**

and don't forget the **Power Wall** in computer architecture fabrication.

The "Power Wall" refers to the increasing difficulty and impracticality of continuing to increase processor clock speeds to achieve performance gains.  For many years, increasing clock speed was the primary driver of improved CPU performance.  However, this approach has run into **fundamental physical limitations**, leading to the "power wall."

## Instructions: The Language of the Computer (Instruction Set Architecture (ISA))

Today, we've laid the foundation for understanding the basic components and principles of computer architecture.  Our next lecture will delve into the *Instruction Set Architecture (ISA)*.

The ISA defines the set of instructions that a particular processor can understand and execute.  It's the interface between the hardware and the software.  We'll explore:

* **Instruction formats:** How instructions are encoded and represented in memory.
* **Addressing modes:** How the processor accesses data in memory.
* **Instruction types:** Arithmetic, logical, data transfer, control flow, etc.
* **ISA design considerations:**  How ISA choices impact performance, complexity, and programmability.

Understanding the ISA is crucial for writing efficient code, optimizing compiler design, and designing new processors.  It's the bridge between the high-level world of programming and the low-level world of hardware.

## 

Read [Textbook Chapter 2 notes by professor](../../Prof%20Rob%20Marano%20Course%20Notes%20on%20Intro%20to%20Computer%20Architecure.pdf)

## Introduction (Textbook &sect;2.1)
*   **Instruction Set**: The vocabulary of commands understood by a computer.
*   **Stored-Program Concept**: The fundamental idea that instructions and data are both stored in memory as numbers. This allows computers to run different programs by simply loading new numbered instructions into memory.

## Operations of the Computer Hardware (Textbook &sect;2.2)
*   **Arithmetic**: Every computer must perform arithmetic. MIPS provides operations like `add` and `sub`.
*   **Design Principle 1: Simplicity favors regularity**. MIPS arithmetic instructions always have exactly three operands (e.g., `add a, b, c` creates `a = b + c`). This regularity simplifies the hardware implementation.

Every computer must be able to perform arithmetic. The MIPS instruction set includes:
- `add a, b, c`  # The sum of b and c is placed in a.
- `sub a, b, c`  # The difference of b and c is placed in a.

## Operands of the Computer Hardware (Textbook &sect;2.3)
*   **Registers**: Hardware primitives used for storing variables. MIPS has 32 32-bit registers. Groups of 32 bits are called a **word**.
*   **Design Principle 2: Smaller is faster**. A smaller number of registers generally allows for faster clock cycles than a very large number of registers.
*   **Memory Operands**: Since there are only a few registers, complex data structures (arrays, structs) are kept in memory.
    *   **Data Transfer Instructions**: Commands to move data between memory and registers.
    *   `lw` (load word): Copied from memory to register.
    *   `sw` (store word): Copied from register to memory.
*   **Alignment**: MIPS requires words to start at addresses that are multiples of 4.
*   **Constant/Immediate Operands**: Frequently used constants are embedded directly into instructions (e.g., `addi`).
*   **Design Principle 3: Make the common case fast**. Handling constants immediately is faster than loading them from memory.

## Signed and Unsigned Numbers (Textbook &sect;2.4)
*   **Two's Complement**: The standard representation for signed integers in computers. Looking at the sign bit (MSB) determines if the number is positive (0) or negative (1).
    *   Negating a number: Invert all bits and add 1.

## Representing Instructions in the Computer (Textbook &sect;2.5)
Instructions are represented as binary numbers. MIPS uses a 32-bit fixed-length format.
*   **R-type (Register)**: Used for arithmetic (op, rs, rt, rd, shamt, funct).
*   **I-type (Immediate)**: Used for data transfer and immediates (op, rs, rt, constant/address).
*   **J-type (Jump)**: Used for jumps (op, address).

## Logical Operations (Textbook &sect;2.6)
*   Operations to manipulate bits within valid words.
*   **Shift**: `sll` (shift left logical) and `srl` (shift right logical) move bits, effectively multiplying or dividing by powers of 2.
*   **Bitwise**: `and`, `or`, `nor`, `xor` operate bit-by-bit, useful for masking and setting bits.


[ &larr; back to syllabus](/courses/ece251/2026/ece251-syllabus-spring-2026.html) [ &larr; back to notes](/courses/ece251/2026/ece251-notes.html)
