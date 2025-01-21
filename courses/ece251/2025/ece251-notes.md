# ECE 251 Spring 2025 Weekly Course Notes

[<- back to syllabus](/courses/ece251/2025/ece251-syllabus-spring-2025.html)

---

|                                     Week(s) |                                            Dates | Topic                                                   |
| ------------------------------------------: | -----------------------------------------------: | :------------------------------------------------------ |
|                    [1](#week1), [2](#week2) |                   [1/21](#week1), [1/28](#week2) | Hardware Modeling with Software (Verilog HDL) HDL       |
|                                 [3](#week3) |                                    [2/4](#week3) | Computer Abstraction & Stored Program Concept           |
|                    [4](#week4), [5](#week5) |                   [2/11](#week4), [2/18](#week5) | Instructions &mdash;The Language & Grammar of Computers |
|                    [6](#week6), [7](#week7) |                    [2/25](#week6), [3/4](#week7) | Intro to Assembly Language Programming &mdash; MIPS CPU |
|                                 [8](#week8) |                                   [3/11](#week8) | **Midterm Exam**                                        |
|                                [9](#week9), |                                   [3/18](#week9) | Arithmetic for Computers                                |
| [10](#week10), [11](#week11), [12](#week12) | [3/25](#week10), [4/1](#week11), [4/22](#week12) | The Processor &mdash; Data Path & Control               |
|                [13](#week13), [14](#week14) |                  [4/29](#week13), [5/6](#week14) | Interrupts; Memory Hierarchies (Caching)                |
|                               [15](#week15) |                                  [5/13](#week15) | **Final Exam**                                          |
|                               [15](#week15) |                                  [5/16](#week15) | Group Final Project due no later than 5pm ET this day   |

Follow the link above to the respective week's materials below.
<br>

---

# <a id="week1">Week 1 &mdash; 1/21 &mdash; Hardware Modeling with Verilog HDL &mdash; Part 1</a>

## Topics

1. Intro to logic design using Verilog HDL
1. Logic elements
1. Expressions
1. Modules and ports

## Software Installation

- Verilog
  - Follow instructions [here](./installing_verilog_locally.md)

## Homework Assignment

See [hw-01.md](./assignments/hw-01.md)

## Topic Deep Dive

### Gate-Level Modeling

**Introduction:**

- Introduction to SystemVerilog and its benefits for hardware description.
- Basic syntax, data types (e.g., `wire`, `reg`, `logic`), and operators.
- Simple gate primitives (e.g., and, or, not, xor).
- Modeling combinational logic circuits using gate primitives.
- Hands-on lab: Implement basic gates and simple combinational circuits (e.g., half-adder, full-adder).

**SystemVerilog for testbench development:**

- Generating input stimuli using random variables.
- Monitoring and checking output signals.
- Using scoreboards for data comparison.
- Hands-on lab: Develop a basic testbench for a design

**What is bit swizzling?**

- Bit swizzling is a technique for rearranging the order of bits within a binary data structure, such as a byte, word, or vector.
- It involves extracting specific bits from their original positions and placing them into new positions within another data structure.

Here's a breakdown of bit swizzling:

**Purpose:**

- **Data Reorganization:** Bit swizzling is often used to reorganize data to match specific hardware requirements or to optimize data structures for certain algorithms.
- **Endianness Conversion:** Converting between big-endian and little-endian representations of data involves swizzling bits.
- **Cryptography:** Swizzling bits can be used in cryptographic operations to obscure data patterns.
- **Image Processing:** Manipulating individual bits in image data for tasks like color transformations or image filtering.
- **Error Correction:** Rearranging bits for error detection and correction codes.

**Techniques:**

- **Shifting:** Shifting bits left or right (<<, >>) to move them to new positions.
- **Masking:** Using bitwise AND (&) to isolate specific bits.
- **Concatenation:** Combining bits from different sources using concatenation operators ({ }).
- **Replication:** Repeating specific bits or patterns.

**For Example:**

Let's say you have a 4-bit data structure `1011` and you want to swap the two middle bits.

You could achieve this through swizzling:

1. Isolate the middle bits:
   1. Mask the first and last bits with `0011` to get `0011`.
1. Swap the middle bits:
   1. Shift the isolated bits left by one (`0110`) and right by one (`0011`).
   1. Combine the shifted results using OR (`|`) to get `0111`.
1. Combine with the original outer bits:
   1. Mask the original data with `1001` to get `1001`.
      1. Combine this with the swapped middle bits using OR (`|`) to get the final result `1111`.

**SystemVerilog Support:**

SystemVerilog provides powerful bit swizzling capabilities:

- **Concatenation:** Use the concatenation operator { and } to combine bits in any desired order.
- **Replication:** Specify the number of times to repeat a bit or pattern within the concatenation.
- **Indexed Part-Select:** Extract a specific range of bits using indexed part-select (`[start_bit:end_bit]`).

**Example in SystemVerilog:**

```verilog
logic [7:0] data = 8'b10110100;
logic [7:0] swizzled_data;

swizzled_data = {data[6:7], data[2:3], data[4:5], data[0:1]}; // Swizzle specific bits
```

Bit swizzling is a fundamental technique in computer architecture and digital design, enabling efficient data manipulation and optimization at the bit level.

**More complex gate-level modeling:**

- Using assign statements for continuous assignments.
- Hierarchical design and module instantiation.
- Introduction to testbenches and basic verification concepts.
- Hands-on lab: Build a more complex combinational circuit (e.g., multiplexer, decoder) using hierarchy.

**Introduction to sequential logic:**

- Flip-flops (e.g., DFF, JKFF) and latches.
- Modeling simple sequential circuits (e.g., counters, shift registers).
- Understanding the concept of clocking and timing in simulations.
- Hands-on lab: Implement a simple counter or shift register.

**Advanced gate-level modeling:**

- User-defined primitives (UDPs) for custom gate definitions.
- Delays in gate-level modeling (#delay).
- Introduction to always blocks for procedural assignments.
- Hands-on lab: Design a sequential circuit with custom gate delays and verify its behavior.

# <a id="week2">Week 2 &mdash; 1/28 &mdash; Hardware Modeling &mdash; Part 2</a>

## Topics

1. Built-in primitives
1. User-defined primitives
1. Dataflow modeling

### Behavioral Modeling

**Introduction to behavioral modeling:**

- always blocks for sequential and combinational logic.
- Blocking vs. non-blocking assignments (= vs. <=).
- Conditional statements (if, else, case).
- Looping statements (for, while).
- Hands-on lab: Implement a simple combinational circuit using behavioral modeling.

**Advanced behavioral modeling:**

- Functions and tasks for code reusability.
- Introduction to arrays and memories.
- Modeling finite state machines (FSMs) using behavioral constructs.
- Hands-on lab: Implement a simple FSM using behavioral modeling.

**Introduction to advanced verification concepts:**

- Assertions for design verification.
- Functional coverage groups.
- Basic concepts of constrained random verification.
- Hands-on lab: Write simple assertions to verify a design.

## Homework Assignment

# <a id="week3">Week 3 &mdash; 2/4 &mdash; Computer Abstraction & Stored Program Concept</a>

## Presentations

## Topics

## Homework Assignment

# <a id="week4">Week 4 &mdash; 2/11 &mdash; Instructions &mdash;The Language & Grammar of Computers &mdash; Part 1</a>

## Presentations

## Topics

## Homework Assignment

# <a id="week5">Week 5 &mdash; 2/18 &mdash; Instructions &mdash;The Language & Grammar of Computers &mdash; Part 2</a>

## Presentations

## Topics

## Homework Assignment

# <a id="week6">Week 6 &mdash; 2/25 &mdash; Intro to Assembly Language Programming &mdash; MIPS CPU &mdash; Part 1</a>

## Presentations

## Topics

## Homework Assignment

# <a id="week7">Week 7 &mdash; 3/4 &mdash; Intro to Assembly Language Programming &mdash; MIPS CPU &mdash; Part 2</a>

## Presentations

## Topics

## Homework Assignment

# <a id="week8">Week 8 &mdash; 3/11 &mdash; **Midterm Exam**</a>

## Presentations

## Topics

## Homework Assignment

# <a id="week9">Week 9 &mdash; 3/18 &mdash; Arithmetic for Computers </a>

## Presentations

## Topics

## Homework Assignment

# <a id="week10">Week 10 &mdash; 3/25 &mdash; The Processor &mdash; Data Path & Control &mdash; Part 1</a>

**Midterm Exam**

## Presentations

## Topics

## Homework Assignment

# <a id="week11">Week 11 &mdash; 4/1 &mdash; The Processor &mdash; Data Path & Control &mdash; Part 2</a>

## Presentations

## Topics

## Homework Assignment

# <a id="week12">Week 12 &mdash; 4/22 &mdash; The Processor &mdash; Data Path & Control &mdash; Part 3</a>

## Presentations

## Topics

## Homework Assignment

# <a id="week13">Week 13 &mdash; 4/29 &mdash; Interrupts; Memory Hierarchies (Caching) &mdash; Part 1</a>

## Presentations

## Topics

## Homework Assignment

# <a id="week14">Week 14 &mdash; 5/6 &mdash; Interrupts; Memory Hierarchies (Caching) &mdash; Part 2</a>

## Presentations

## Topics

## Homework Assignment

# <a id="week15">Week 15 &mdash; 5/13 &mdash; **Final Exam** & **Final Project** due</a>

**Final Exam**

**Final Project Due**
