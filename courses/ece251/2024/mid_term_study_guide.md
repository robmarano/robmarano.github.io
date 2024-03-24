# ECE 251 Spring 2024 &mdash; Study Guide

Mid-term exam scheduled for Wednesday, April 3rd 6:15-7:45pm ET. Please arrive on-time at 6:00pm ET.

Topic Guide for our mid-term exam:
1. Design principles of computer architecture
2. The design of a modern, von Neumann-based digital computer
    1. the definition
    2. the components
    3. the relationships among the components
    4. the diagram connecting the components together
3. Performance of computers
    1. Performance theory
        1. execution, or response, time
        2. throughput, or bandwidth
        3. relationship between throughput and response time
        4. relative performance
    2. Measuring performance
        1. Relationship between performance and execution time
            1. $$ Performance_\text{computer X} = \left(1 \over ExecutionTime_\text{of program running on computer X} \right) $$
            2. Computer X is "n" times faster than Computer Y
            <br> $$ n = \left (Performance_\text{computer X} \over Performance_\text{computer Y} \right) = \left ( ExecutionTime_\text{of program running on computer Y} \over ExecutionTime_\text{of program running on computer X} \right)$$
        2. CPU performance and its factors
            1. CPU execution time, or CPU time
        <br> NOTE: Htere is a distinction between performance based on elapsed time and, separately, on CPU time. _System performance_ refers to elapsed time on an **unloaded** system. _CPU performance_ refers to user CPU time. For this section, we focus on _CPU performance_.
                1. user CPU time
                2. system (kernel) CPU time
                3. $$ CPU_\text{exec time for prog} = \left(CPU_\text{clock cycles for prog} \right) * \left(time_\text{clock cycle} \right)$$
                <br> or
                <br> $$ CPU_\text{exec time for prog} = \left (CPU_\text{clock cycles for prog}  \over freq_\text{clock} \right)$$
        3. Instruction performance
            1. Execution time is equal to the number of instructions multiplied by the average time per instruction.
            2. Number of clock cycles required for a program; note CPI means "Clock cycles per instruction (CPI)"
            <br> $$ \text{Clock Cycles}_\text{a program} = Count_\text{of instructions for program} * CPI_\text{average} $$
        4. Classic CPU performance equation
            1. The basic performance equation in terms of **instruction count** (which is the number of instructions executed by the program), CPI, and clock cycle.
            <br> $$ CPU_\text{time} = Count_\text{instructions of program} * CPI * CycleTime_\text{of clock} $$
            <br> or
            <br> $$ CPU_\text{time} = \left (Count_\text{instructions of program} * CPI \over freq_\text{clock} \right) $$


4. MIPS32 instruction set architecture (ISA)
    1. Registers
        1. User available aka "General Purpose Registers (GPR)"
            1. R0 through R31
        2. CPU-only accessible
            1. Program Counter (PC)
    2. Endian-ness
        1. Big Endian &mdash; MIPS32 defined
        2. Little Endian
    3. Memory addressability
        1. Byte-addressable &mdash; MIPS32 defined
    4. MIPS basic instruction formats
        1. Register-based
        2. Immediate-based
        3. Jump-based
    5. Memory layout
        1. Stack
        2. Dynamic data
        3. Static data
        4. Text
        5. Reserved
    6. Core instructions
        1. Arithmetic and logic
        2. Memory
        3. Branch
    7. Pseudo instructions
        1. Memory
        2. Branch
    8. Coprocessor instructions (floating point)
        1. Floating point coprocessor
            1. Single-precision vs double-precision
            2. Instruction formats
                1. Register-based
                2. Immediate-based
            3. Core instructions
                1. Arithmetic
                2. Memory
                    1. into coprocessor FP registers (FPRs) from GPRs
                    2. into GPRs from FPRs
5. MIPS32 Assembly Programming
    1. Arithmetic
    2. Memory access
    3. Conditional statements
    4. Branching (conditional vs absolute, looping, recursion)
    5. Convert C to Assembly
    6. Convert Assembly to unlinked MIPS32 machine code (binary)
    7. Convert MIPS32 machine code to assembly
    8. Convert MIPS32 assembly code to C code
    9. Procedural programming
        1. Leaf procedure
        2. Nested procedure
    10. Recursion &mdash; implement recursive algorithms like Fibonacci, factorial, etc.
6. Floating Point Math in MIPS32
    1. Convert a decimal number to IEEE 754-based floating point number in binary
        1. Single precision
        2. Double precision
    2. Convert an IEEE 754-based floating point number (in binary) to a decimal number
    3. Determine if the floating point binary number is +/- infinity, not a number, or a floating point number in decimal.
    4. Simple add, subtract, multiply, divide floating point numbers in MIPS32 assembly using the coprocessor instructions
        1. how to load number in from ```.data``` into the FP registers and back to GPRs
7. SystemVerilog
    1. module and test bench coding
    2. timing definition
    3. use of parameters
    4. implement digital circuits
        1. full adder
        2. clock
        3. registers (D-FF)
        4. shift logical right and left
        
