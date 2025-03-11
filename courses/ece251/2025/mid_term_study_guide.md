# ECE 251 Spring 202 &mdash; Study Guide

Mid-term exam scheduled for Tuesday, March 11th, as a take-home, closed-book exam.

Topic Guide for our mid-term exam:

1. Definition of computer architecture
   1. von Neumann, aka Princeton, architecture
   2. Harvard architecture
   3. store program concept
   4. machine code represents both instructions and data
   5. types of computers
      1. CISC
         1. variable length instructions
      2. RISC
         1. fixed length instructions
2. Design principles of computer architecture
3. The design of a modern, von Neumann-based digital computer

   1. the definition
   2. the components
   3. the relationships among the components
   4. the diagram connecting the components together

4. MIPS32 instruction set architecture (ISA)

   1. Registers

      1. User available aka "General Purpose Registers (GPR)"
      2. R0 through R31
      3. bit width (32-bit CPU) as operand width

   2. CPU-only accessible
      1. Program Counter (PC)
   3. Endian-ness
      1. Big Endian &mdash; by MIPS32 definition
      2. Little Endian
   4. Memory addressability
      1. Byte-addressable &mdash; by MIPS32 definition
   5. Instruction types
      1. Register-based
      2. Immediate-based
      3. Jump-based
   6. Core instructions
      1. Arithmetic and logic
      2. Memory
      3. Branch
   7. Pseudo instructions
      1. Memory
      2. Branch
   8. Memory layout
      1. Stack
      2. Dynamic data
      3. Static data
      4. Text
      5. Reserved

5. MIPS32 Assembly Programming

   1. each line of MIPS assembly represents an instruction, 32-bits
   1. Arithmetic
   1. Memory access
   1. Conditional statements
   1. Branching (conditional vs absolute, looping, recursion)
   1. Convert C to Assembly
   1. Convert Assembly to unlinked MIPS32 machine code (binary)
   1. Convert MIPS32 machine code to assembly
   1. Convert MIPS32 assembly code to C code
   1. Procedural programming
      1. Leaf procedure
      2. Nested procedure
   1. Recursion &mdash; implement recursive algorithms like Fibonacci, factorial, etc.
   1. `syscall`, a kernel call for a simple OS on MIPS (QtSpim, MARS)

6. SystemVerilog
   1. module and test bench coding
   2. timing definition
   3. use of parameters
   4. implement digital circuits
      1. full adder (ripple carry)
      2. clock
      3. registers (implemented using DFFs)
      4. register file
      5. shift logical right and left
      6. program counter
