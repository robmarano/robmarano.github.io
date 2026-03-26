# ECE 251 Spring 2026 Weekly Course Notes

[<- back to syllabus](/courses/ece251/2026/ece251-syllabus-spring-2026.md)

---

## Course Schedule

|                                     Week(s) |                                            Dates | Topic                                                          |
| ------------------------------------------: | -----------------------------------------------: | :------------------------------------------------------------- |
|                                 [1](#week1) |                                   [1/22](#week1) | Computer Abstraction & Stored Program Concept                  |
|                    [2](#week2), [3](#week3) |                   [1/29](#week2), [2/5](#week3)  | Instructions &mdash;The Language & Grammar of Computers        |
|                    [4](#week4), [5](#week5) |                   [2/12](#week4), [2/19](#week5) | Hardware Modeling with Software (Verilog HDL)                  |
|                    [6](#week6), [7](#week7) |                    [2/26](#week6), [3/5](#week7) | Intro to Assembly Language Programming &mdash; MIPS CPU        |
|                                 [8](#week8) |                                   [3/12](#week8) | Arithmetic and Floating Point Numbers; **Midterm Exam**        |
|                                 [9](#week9) |                                   [3/26](#week9) | Intro to Data Path & Control                            |
| [10](#week10), [11](#week11), [12](#week12) |  [4/2](#week10), [4/9](#week11), [4/16](#week12) | The Processor &mdash; Data Path & Control; Interrupts                     |
|                [13](#week13), [14](#week14) |                 [4/23](#week13), [4/30](#week14) | Memory Hierarchies (Caching)                       |
|                               [15](#week15) |                                  [5/14](#week15) | **Final Exam**                                                 |
|                               [15](#week15) |                                  [5/15](#week15) | Group Final Project due no later than 5pm ET this day          |

Follow the link above to the respective week's materials below.
<br>

---

# <a id="week1">Week 1 &mdash; 1/22 &mdash; Verilog; Computer Abstraction & Stored Program Concept</a>

## Let's begin
Have a read of our opening [prologue](/courses/ece251/2026/textbook-notes.html), and then let's get started with why we are taking this class...

## Topics

1. Computer Abstraction
1. Stored Program Concept
1. History of computer architecture and modern advancements

## Topic Deep Dive

See [notes_week_01](/courses/ece251/2026/weeks/week_01/notes_week_01.html)

## Reading Assignment

- Read sections Chap 2.1-2.7 in the [textbook handout for chapter 2](https://cooperunion.sharepoint.com/:b:/s/Section_ECE-251-A-2025SP/Ed8wNobvQCVPozj701I4bOABAZtXH7rlL6rjFgUkqp_0Vg?e=BPbInD), along with my summary notes handout [Prof's Notes on Comp Arch](https://cooperunion.sharepoint.com/:b:/s/Section_ECE-251-A-2025SP/EaFcET5zxcBHsS529aI4YmEBnUJnbvjWv2R6XsQfFwzC5w?e=2BFfUf)

## Homework Assignment

See [hw-01](/courses/ece251/2026/assignments/hw-01.html); [solution](/courses/ece251/2026/assignments/hw-01-solution.html)

# <a id="week2">Week 2 &mdash; 1/29 &mdash; Instructions &mdash;The Language & Grammar of Computers &mdash; Part 1</a>

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

See [notes_week_02](/courses/ece251/2026/weeks/week_02/notes_week_02.html)

## Reading Assignment

- Read sections Chap 2.1-2.7 in my notes handout [Prof's Notes on Comp Arch](https://cooperunion.sharepoint.com/:b:/s/Section_ECE-251-A-2025SP/EaFcET5zxcBHsS529aI4YmEBnUJnbvjWv2R6XsQfFwzC5w?e=2BFfUf), and these notes follow exactly from the [MIPS textbook's](https://cooperunion.sharepoint.com/:b:/s/Section_ECE-251-A-2025SP/EfW8ouRjnFNNn7E7K5rvkWoBPWU0tDLednaJ95eaJWXx8Q?e=Ar9Pmf) Chapter 2 and its 22 sections. I suggest reading the textbook sections too.
- Follow along with our [textbook's Chapter 2 slide deck](/courses/ece251/2026/weeks/week_05/Patterson6e_MIPS_Ch02_PPT.ppt)

## Homework Assignment

See [hw-02](/courses/ece251/2026/assignments/hw-02.html); [solution](TBD)


# <a id="week3">Week 3 &mdash; 2/5 &mdash; Instructions &mdash;The Language & Grammar of Computers &mdash; Part 2</a>

## Topics

1. Instructions for making decisions
2. Supporting procedures (aka functions) in computer hardware
3. Begin converting our instructions to control logic for computation and memory storage.

## Topic Deep Dive

See [notes_week_03](/courses/ece251/2026/weeks/week_03/notes_week_03.html)

## Software Installation

- Install the MIPS emulator [SPIM](https://spimsimulator.sourceforge.net/) on your computer, either the SPIM GUI called "QtSPIM" or the CLI program `spim`. Here is the installation [for the GUI program](/courses/ece251/2026/weeks/week_05/Installing%20the%20SPIM%20Simulator%20on%20Your%20Laptop.pdf) and [for the CLI program](/courses/ece251/2026/weeks/week_05/SPIM_command-line.pdf)

## Reading Assignment

- Read [Prof's CPU Design Guide](/courses/ece251/2026/weeks/week_05/CPU%20Design%20Guide.pdf)
- Read sections Chap 2.7 through Chap 2.10 in my notes handout [Prof's Notes on Comp Arch](https://cooperunion.sharepoint.com/:b:/s/Section_ECE-251-A-2025SP/EaFcET5zxcBHsS529aI4YmEBnUJnbvjWv2R6XsQfFwzC5w?e=2BFfUf), and these notes follow exactly from the [MIPS textbook's](https://cooperunion.sharepoint.com/:b:/s/Section_ECE-251-A-2025SP/EfW8ouRjnFNNn7E7K5rvkWoBPWU0tDLednaJ95eaJWXx8Q?e=Ar9Pmf) Chapter 2 and its 22 sections. I suggest reading the textbook sections too.
- Read Chapters 3 and 4 in [Introduction to MIPS Assembly Language Programming](/courses/ece251/2026/weeks/week_05/Introduction%20To%20MIPS%20Assembly%20Language%20Programming.pdf)
- Continue to follow along with our [textbook's Chapter 2 slide deck](/courses/ece251/2026/weeks/week_05/Patterson6e_MIPS_Ch02_PPT.ppt)

NOTE: Check our [shared Teams drive](https://cooperunion.sharepoint.com/:f:/s/Section_ECE-251-A-2025SP/EujI9o0hInpGmHtZhWVN_PIBCw4GRYTWunYcmy94tx3LrA?e=BVZ9Uy) for these files too as well as the installation for our software.

## Homework Assignment

See [hw-03](/courses/ece251/2026/assignments/hw-03.html); [solution](TBD)


# <a id="week4">Week 4 &mdash; 2/12 &mdash; Hardware Modeling with Verilog HDL &mdash; Part 1</a>

## Topics

1. Verilog: Parameterization; Built-in primitives; User-defined primitives; Dataflow modeling
1. Intro to logic design using Verilog HDL
1. Logic elements
1. Expressions
1. Modules and ports

## Topic Deep Dive

See [notes_week_04](/courses/ece251/2026/weeks/week_04/notes_week_04.html)

## Software Installation

- Verilog
  - Follow instructions [here](/courses/ece251/2026/installing_verilog_locally.html)
- Build files <br>
  - Unix (MacOS, Linux)
    - [Makefile](/courses/ece251/2026/catalog/templates/Makefile)
  - Windows
    - [makefile.ps1](/courses/ece251/2026/catalog/templates/makefile.ps1)

## Homework Assignment

See [hw-04](/courses/ece251/2026/assignments/hw-04.html); [solution](TBD)

# <a id="week5">Week 5 &mdash; 2/19 &mdash; Hardware Modeling &mdash; Part 2</a>

## Topics

1. Built-in primitives
1. User-defined primitives
1. Dataflow modeling

## Topic Deep Dive

See [notes_week_05](/courses/ece251/2026/weeks/week_05/notes_week_05.html)

## Homework Assignment

See [hw-05.md](/courses/ece251/2026/assignments/hw-05.html); [solution](TBD)

# <a id="week6">Week 6 &mdash; 2/26 &mdash; Intro to Assembly Language Programming — MIPS CPU; Part 1</a>

## Topics

1. Programming MIPS assembly language, using MIPS emulator (`spim`)

## Topic Deep Dive

See [notes_week_06](/courses/ece251/2026/weeks/week_06/notes_week_06.html)

## Reading Assignment

- Read sections Chap 2.12 through Chap 2.14 in my notes handout [Prof's Notes on Comp Arch](https://cooperunion.sharepoint.com/:b:/s/Section_ECE-251-A-2025SP/EaFcET5zxcBHsS529aI4YmEBnUJnbvjWv2R6XsQfFwzC5w?e=2BFfUf)
- Read [class notes on MIPS assembly programming](/courses/ece251/mips/mips.html)


# <a id="week7">Week 7 &mdash; 3/5 &mdash; Intro to Assembly Language Programming — MIPS CPU; Part 2</a>

## Topics

1. Programming MIPS assembly language, using MIPS emulator (`spim`)

## Topic Deep Dive

See [notes_week_07](/courses/ece251/2026/weeks/week_07/notes_week_07.html)

## Reading Assignment

- Read sections Chap 2.12 through Chap 2.14 in my notes handout [Prof's Notes on Comp Arch](https://cooperunion.sharepoint.com/:b:/s/Section_ECE-251-A-2025SP/EaFcET5zxcBHsS529aI4YmEBnUJnbvjWv2R6XsQfFwzC5w?e=2BFfUf)
- Read [class notes on MIPS assembly programming](/courses/ece251/mips/mips.html)

# <a id="week8">Week 8 &mdash; 3/12 &mdash; Arithmetic and Floating Point Numbers; Midterm Exam</a>

## Topics

1. Reviewing what it means for a computer to perform arithmetic
2. Addition and Subtraction
3. Multiplication
4. Division
5. A better system to handle very small and very large numbers &mdash; floating point numbers (IEEE 754 standard).
6. Arithmetic of floating point numbers.

## Topic Deep Dive

See [notes_week_08](/courses/ece251/2026/weeks/week_08/notes_week_08.html)

## Reading Assignment

- Read Chapter 3, Sections 3.1 through 3.5 in *Computer Organization and Design - MIPS Edition*.

# <a id="week9">Week 9 &mdash; 3/26 &mdash; Intro to Data Path & Control (Part 1 of 3)</a>

## Topics

1. Introduction to the basic MIPS processor implementation (Section 4.1).
2. Logic design conventions and clocking methodology (Section 4.2).
3. Building a simple single-cycle datapath and the Control Unit (Section 4.3).
4. Retrospective: SystemVerilog behavioral modeling of the datapath logic.

## Topic Deep Dive

See [notes_week_09](/courses/ece251/2026/weeks/week_09/notes_week_09.html)

## Reading Assignment

- Read Chapter 4, Sections 4.1 through 4.3 in *Computer Organization and Design - MIPS Edition*.

# <a id="week10">Week 10 &mdash; 4/2 &mdash; The Processor &mdash; Datapath & Control (Part 2 of 3)</a>

## Topics

1. The limitations of single-cycle implementation.
2. Transitioning to multicycle implementations.
3. Introduction to Pipelining.

See [notes_week_10](/courses/ece251/2026/weeks/week_10/notes_week_10.html)

# <a id="week11">Week 11 &mdash; 4/9 &mdash; The Processor &mdash; Datapath & Control (Part 3 of 3)</a>


See [notes_week_11](/courses/ece251/2026/weeks/week_11/notes_week_11.html)

# <a id="week12">Week 12 &mdash; 4/16 &mdash; The Processor &mdash; Interrupts</a>


See [notes_week_12](/courses/ece251/2026/weeks/week_12/notes_week_12.html)

# <a id="week13">Week 13 &mdash; 4/23 &mdash; Interrupts; Memory Hierarchies (Caching) Part 1</a>


See [notes_week_13](/courses/ece251/2026/weeks/week_13/notes_week_13.html)

# <a id="week14">Week 14 &mdash; 4/30 &mdash;Interrupts; Memory Hierarchies (Caching) Part 2</a>


See [notes_week_14](/courses/ece251/2026/weeks/week_14/notes_week_14.html)

[<- back to syllabus](/courses/ece251/2026/ece251-syllabus-spring-2026.html)
