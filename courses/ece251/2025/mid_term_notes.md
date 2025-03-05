# Mid-Term Topics

definition of computer arch

- Princeton
- Harvard
- store program concept
  - machine code is both instructions and data
- 5 parts of a modern computer
- types of computers
  - CISC
    - variable length instructions
  - RISC
    - fixed length instructions

Verilog

- signed vs unsigned numbers
- register
- DFF
- catalog of modules
  - register file
  - clock
  - ALU
  - DFF
  - adder
    - carry...

ISA Design

- 4 design principles

MIPS ISA
-RISC

- bit width (32-bit CPU)
  - operand width
- instructions
  - types (R, I, J)
  - opcodes
  - operands
- memory layout
  - byte addressable
  - each instruction is 32-bits (1 word) wide
- little vs big endian
- registers (fast memory, closest to ALU)

Assembly Language Programming

- purpose of an assembler
  - convert assembly code and converts to machine code
- each line of assembly code represents an instruction, 32-bits in our MIPS case
- instructions
- data types (word, halfword, byte)
- procedures
  - leaf
  - nested
    - recursive
- syscall, a kernel call for a simple OS on MIPS (QtSPIM, MARS)
