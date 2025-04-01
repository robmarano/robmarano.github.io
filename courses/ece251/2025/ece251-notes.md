# ECE 251 Spring 2025 Weekly Course Notes

[<- back to syllabus](/courses/ece251/2025/ece251-syllabus-spring-2025.md)

---

|                                     Week(s) |                                            Dates | Topic                                                          |
| ------------------------------------------: | -----------------------------------------------: | :------------------------------------------------------------- |
|                    [1](#week1), [2](#week2) |                   [1/21](#week1), [1/28](#week2) | Hardware Modeling with Software (Verilog HDL) HDL              |
|                                 [3](#week3) |                                    [2/4](#week3) | Wrap-up Verilog; Computer Abstraction & Stored Program Concept |
|                    [4](#week4), [5](#week5) |                   [2/11](#week4), [2/18](#week5) | Instructions &mdash;The Language & Grammar of Computers        |
|                    [6](#week6), [7](#week7) |                    [2/25](#week6), [3/4](#week7) | Intro to Assembly Language Programming &mdash; MIPS CPU        |
|                                 [8](#week8) |                                   [3/11](#week8) | Arithmetic for Computers; **Midterm Exam**                     |
|                                [9](#week9), |                                   [3/18](#week9) | Floating Point Numbers & Arithmetic                            |
| [10](#week10), [11](#week11), [12](#week12) | [3/25](#week10), [4/1](#week11), [4/22](#week12) | The Processor &mdash; Data Path & Control                      |
|                [13](#week13), [14](#week14) |                  [4/29](#week13), [5/6](#week14) | Interrupts; Memory Hierarchies (Caching)                       |
|                               [15](#week15) |                                  [5/13](#week15) | **Final Exam**                                                 |
|                               [15](#week15) |                                  [5/16](#week15) | Group Final Project due no later than 5pm ET this day          |

Follow the link above to the respective week's materials below.
<br>

---

# <a id="week1">Week 1</a> &mdash; Jan 21 &mdash; Hardware Modeling with Verilog HDL &mdash; Part 1

## Topics

1. Intro to logic design using Verilog HDL
1. Logic elements
1. Expressions
1. Modules and ports

## Topic Deep Dive

See [notes_week_01](/courses/ece251/2025/weeks/week_01/notes_week_01.html)

## Software Installation

- Verilog
  - Follow instructions [here](/courses/ece251/2025/installing_verilog_locally.html)
- Build files <br>
  - Unix (MacOS, Linux)
    - [Makefile](/courses/ece251/2025/catalog/templates/Makefile)
  - Windows
    - [makefile.ps1](/courses/ece251/2025/catalog/templates/makefile.ps1)

## Homework Assignment

See [hw-01](/courses/ece251/2025/assignments/hw-01.html); [solution](/courses/ece251/2025/assignments/hw-01-solution.html)

# <a id="week2">Week 2 &mdash; 1/28 &mdash; Hardware Modeling &mdash; Part 2</a>

## Topics

1. Built-in primitives
1. User-defined primitives
1. Dataflow modeling

## Topic Deep Dive

See [notes_week_02](/courses/ece251/2025/weeks/week_02/notes_week_02.html)

## Homework Assignment

See [hw-02.md](/courses/ece251/2025/assignments/hw-02.html); [solution](/courses/ece251/2025/assignments/hw-02-solution.html)

# <a id="week3">Week 3 &mdash; 2/4 &mdash; Verilog; Computer Abstraction & Stored Program Concept</a>

## Topics

1. Verilog: Parameterization; Built-in primitives; User-defined primitives; Dataflow modeling
2. Stored Program Concept
3. History of computer architecture and modern advancements

## Topic Deep Dive

See [notes_week_03](/courses/ece251/2025/weeks/week_03/notes_week_03.html)

## Reading Assignment

- Read sections Chap 2.1-2.7 in the [textbook handout for chapter 2](https://cooperunion.sharepoint.com/:b:/s/Section_ECE-251-A-2025SP/Ed8wNobvQCVPozj701I4bOABAZtXH7rlL6rjFgUkqp_0Vg?e=BPbInD), along with my summary notes handout [Prof's Notes on Comp Arch](https://cooperunion.sharepoint.com/:b:/s/Section_ECE-251-A-2025SP/EaFcET5zxcBHsS529aI4YmEBnUJnbvjWv2R6XsQfFwzC5w?e=2BFfUf)

# <a id="week4">Week 4 &mdash; 2/11 &mdash; Instructions &mdash;The Language & Grammar of Computers &mdash; Part 1</a>

## Topics

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

## Topic Deep Dive

See [notes_week_04](/courses/ece251/2025/weeks/week_04/notes_week_04.html)

## Reading Assignment

- Read sections Chap 2.1-2.7 in my notes handout [Prof's Notes on Comp Arch](https://cooperunion.sharepoint.com/:b:/s/Section_ECE-251-A-2025SP/EaFcET5zxcBHsS529aI4YmEBnUJnbvjWv2R6XsQfFwzC5w?e=2BFfUf), and these notes follow exactly from the [MIPS textbook's](https://cooperunion.sharepoint.com/:b:/s/Section_ECE-251-A-2025SP/EfW8ouRjnFNNn7E7K5rvkWoBPWU0tDLednaJ95eaJWXx8Q?e=Ar9Pmf) Chapter 2 and its 22 sections. I suggest reading the textbook sections too.
- Follow along with our [textbook's Chapter 2 slide deck](/courses/ece251/2025/weeks/week_05/Patterson6e_MIPS_Ch02_PPT.ppt)

# <a id="week5">Week 5 &mdash; 2/18 &mdash; Instructions &mdash;The Language & Grammar of Computers &mdash; Part 2</a>

## Topics

1. Instructions for making decisions
2. Supporting procedures (aka functions) in computer hardware
3. Begin converting our instructions to control logic for computation and memory storage.

## Topic Deep Dive

See [notes_week_05](/courses/ece251/2025/weeks/week_05/notes_week_05.html)

## Software Installation

- Install the MIPS emulator [SPIM](https://spimsimulator.sourceforge.net/) on your computer, either the SPIM GUI called "QtSPIM" or the CLI program `spim`. Here is the installation [for the GUI program](/courses/ece251/2025/weeks/week_05/Installing%20the%20SPIM%20Simulator%20on%20Your%20Laptop.pdf) and [for the CLI program](/courses/ece251/2025/weeks/week_05/SPIM_command-line.pdf)

## Reading Assignment

- Read [Prof's CPU Design Guide](/courses/ece251/2025/weeks/week_05/CPU%20Design%20Guide.pdf)
- Read sections Chap 2.7 through Chap 2.10 in my notes handout [Prof's Notes on Comp Arch](https://cooperunion.sharepoint.com/:b:/s/Section_ECE-251-A-2025SP/EaFcET5zxcBHsS529aI4YmEBnUJnbvjWv2R6XsQfFwzC5w?e=2BFfUf), and these notes follow exactly from the [MIPS textbook's](https://cooperunion.sharepoint.com/:b:/s/Section_ECE-251-A-2025SP/EfW8ouRjnFNNn7E7K5rvkWoBPWU0tDLednaJ95eaJWXx8Q?e=Ar9Pmf) Chapter 2 and its 22 sections. I suggest reading the textbook sections too.
- Read Chapters 3 and 4 in [Introduction to MIPS Assembly Language Programming](/courses/ece251/2025/weeks/week_05/Introduction%20To%20MIPS%20Assembly%20Language%20Programming.pdf)
- Continue to follow along with our [textbook's Chapter 2 slide deck](/courses/ece251/2025/weeks/week_05/Patterson6e_MIPS_Ch02_PPT.ppt)

NOTE: Check our [shared Teams drive](https://cooperunion.sharepoint.com/:f:/s/Section_ECE-251-A-2025SP/EujI9o0hInpGmHtZhWVN_PIBCw4GRYTWunYcmy94tx3LrA?e=BVZ9Uy) for these files too as well as the installation for our software.

# <a id="week6">Week 6 &mdash; 2/25 &mdash; Intro to Assembly Language Programming — MIPS CPU; Part 1</a>

## Topics

1. Programming MIPS assembly language, using MIPS emulator (`spim`)

## Topic Deep Dive

See [notes_week_06](/courses/ece251/2025/weeks/week_06/notes_week_06.html)

## Reading Assignment

- Read sections Chap 2.12 through Chap 2.14 in my notes handout [Prof's Notes on Comp Arch](https://cooperunion.sharepoint.com/:b:/s/Section_ECE-251-A-2025SP/EaFcET5zxcBHsS529aI4YmEBnUJnbvjWv2R6XsQfFwzC5w?e=2BFfUf)
- Read [class notes on MIPS assembly programming](/courses/ece251/mips/mips.html)

# <a id="week7">Week 7 &mdash; 3/4 &mdash; Intro to Assembly Language Programming — MIPS CPU; Part 2</a>

## Topics

1. Programming MIPS assembly language, using MIPS emulator (`spim`)

## Topic Deep Dive

See [notes_week_07](/courses/ece251/2025/weeks/week_07/notes_week_07.html)

## Reading Assignment

- Read sections Chap 2.12 through Chap 2.14 in my notes handout [Prof's Notes on Comp Arch](https://cooperunion.sharepoint.com/:b:/s/Section_ECE-251-A-2025SP/EaFcET5zxcBHsS529aI4YmEBnUJnbvjWv2R6XsQfFwzC5w?e=2BFfUf)
- Read [class notes on MIPS assembly programming](/courses/ece251/mips/mips.html)

# <a id="week8">Week 8 &mdash; 3/11 &mdash; Arithmetic for Computers</a>

## Topics

1. Reviewing what it means for a computer to perform arithmetic
2. Addition and Subtraction
3. Multiplication
4. Division
5. Floating Point

## Topic Deep Dive

See [notes_week_08](/courses/ece251/2025/weeks/week_08/notes_week_08.html)

## Reading Assignment

- Read sections [Chap 3.1 through Chap 3.5 of CODmips textbook](TBD)

# <a id="week9">Week 9 &mdash; 3/18 &mdash; Floating Point Numbers & Artihmetic</a>

## Topics

1. A better system to handle very small and very large numbers &mdash floating point numbers through the IEEE 754 standard.

## Topic Deep Dive

1.
2.
3.

See [notes_week_09](/courses/ece251/2025/weeks/week_09/notes_week_09.html)

# <a id="week10">Week 10 &mdash; 3/25 &mdash; The Processor &mdash; Data Path & Control (Part 1 of 3)</a>

## Topics

1. How to create the digital architecture from ISA instructions, component by component
2.
3.

See [notes_week_10](/courses/ece251/2025/weeks/week_10/notes_week_10.html)

# <a id="week11">Week 11 &mdash; 4/1 &mdash; The Processor &mdash; Data Path & Control (Part 2 of 3)</a>

## Topics

1.
2.
3.

See [notes_week_11](/courses/ece251/2025/weeks/week_11/notes_week_11.html)

# <a id="week12">Week 12 &mdash; 4/22 &mdash; The Processor &mdash; Data Path & Control (Part 3 of 3)">

## Topics

1.
2.
3.

See [notes_week_12](/courses/ece251/2025/weeks/week_12/notes_week_12.html)

[<- back to syllabus](/courses/ece251/2025/ece251-syllabus-spring-2025.html)
