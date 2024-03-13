# ECE 251 Spring 2024 Weekly Course Notes

[<- back to syllabus](/courses/ece251/2024/ece251-syllabus-spring-2024.html)

---

|                               Weeks |                                         Dates | Topic                                                                            |
| ----------------------------------: | --------------------------------------------: | :------------------------------------------------------------------------------- |
|                         [1](#week1) |                                [1/17](#week1) | Computer Abstraction, and Software Modeling                                      |
| [2](#week2),[3](#week3),[4](#week4) | [1/24](#week2), [1/31](#week3), [2/7](#week4) | Software Modeling Using Verilog                                                  |
|             [5](#week5),[6](#week6) |                [2/14](#week5), [2/21](#week6) | Instructions &mdash;The Language & Grammar of Computers                          |
|             [7](#week7),[8](#week8) |                 [2/28](#week7), [3/6](#week8) | Intro to Assembly Language Programming &mdash; MIPS CPU                          |
|           [9](#week9),[10](#week10) |               [3/13](#week9), [3/27](#week10) | Arithmetic for Computers &mdash; Adders, Multipliers, Dividers; **Midterm Exam** |
|         [11](#week11),[12](#week12) |               [4/3](#week11), [4/10](#week12) | The Processor &mdash; Data Path and Control                                      |
|         [13](#week13),[14](#week14) |              [4/17](#week13), [4/24](#week14) | Memory Hierarchies                                                               |
|                       [15](#week15) |                                [5/8](#week15) | **Final Exam**; Group CPU Final Project due                                      |

Follow the link above to the respective week's materials below.

<br>

# <a id="week1">Week 1 &mdash; 1/17 &mdash; Computer Abstraction, and Software Modeling</a>

## Presentations

- Patterson-Hennessy: [Chapter 1](../books/patterson-hennessey/Patterson6e_MIPS_Ch01_PPT.ppt)

## Topics

- intro to computers and the architectures which drive their designs
- the mental model for a computer and its five core parts

## Readings & Subject Information

- Chapter 1 of our textbook (Patterson-Hennessy)
- none this week

# <a id="week2">Week 2 &mdash; 1/24 &mdash; Software Modeling Using Verilog</a>

## Topics

- chip wafer process technology and its economics (yield); some examples
- computer performance definition and its metrics; some examples
- intro to Verilog as a hardware description language
- data types
- timescale

## Readings & Subject Information

- [The Free Lunch Is Over: A Fundamental Turn Toward Concurreny in Software](./No%20Free%20Lunch%20-%20Computer%20Architecture%20Progress%20and%20Constraints.pdf)

# <a id="week3">Week 3&mdash; 1/31 &mdash; Software Modeling Using Verilog</a>

## Topics

- Verilog
- file format (testbench and module files)
- data types
- designing digital logic circuits (combinational and sequential) using Verilog
- defining and running simulations

## Readings & Subject Information

- [Prof Marano's notes on Verilog & SystemVerilog](./verilog.md)
- [David Harris' Structural Design with Verilog](./Structural%20Design%20with%20Verilog%20--%20David%20Harris.pdf)
- [Mentor Graphics Verilog Training Manual](./Comprehensive%20Verilog%20Training%20Manual.pdf)
- [SystemVerilog Tutorial from IBM](./system_verilog_overview-ibm-symposium-johny_srouji.pdf)
- [SystemVerilog Overview](./SysVerilog_Tutorial.pdf)
- [Intro to SystemVerilog from SUNY Stonybrook](./03-systemverilog.pdfs)

# <a id="week4">Week 4 &mdash; 2/7 &mdash; Software Modeling Using Verilog</a>

## Topics

- Review of basic digital logic modules modeled in Verilog.
  - [templates for working with Verilog on Windows and Linux/MacOS](./using_verilog_locally.md)
  - modules
    - combinational logic
      - [multiplexer](./catalog/mux.md)
        - for parameterized n-bit input / output
    - sequential logic
      - [D Flip Flop](./catalog/dff.md)
      - [Clock](./catalog/clock.md)
      - [Clock Dividers](./catalog/clock_dividers.md)
- A selection of combinational logic modules to build your computer architecture components catalog
  - [parameterized counter (up/down)](./catalog/counter.md)

## Readings & Subject Information

- [Prof Marano's notes on Verilog & SystemVerilog](./verilog.md)
- [ChipVerify's SystemVerilog Tutorial](https://www.chipverify.com/tutorials/systemverilog)
- [Icarus Verilog Documentation link](https://steveicarus.github.io/iverilog/index.html)
- [Directions to install Icarus Verilog and GTKwave on Windows, MacOS, or Linux](./installing_verilog_locally.md)

# <a id="week5">Week 5 &mdash; 2/14 &mdash; Instructions &mdash;The Language & Grammar of Computers</a>

## Presentations

- Patterson-Hennessey: [Chapter 2](../books/patterson-hennessey/Patterson6e_MIPS_Ch02_PPT.ppt)

## Topics

- Textbook sections
  - 2.2 &mdash; Operations of Computer Hardware
  - 2.3 &mdash; Operands of Computer Hardware
  - 2.4 &mdash; Signed and Unsigned Numbers
  - 2.5 &mdash; Representing Instructions in the Computer (ISA)
  - 2.6 &mdash; Logical Operations
- [MIPS Green Sheet](../books/patterson-hennessey/MIPS_Green_Sheet.pdf)

## Readings & Subject Information

# <a id="week6">Week 6 &mdash; 2/21 &mdash; Instructions &mdash;The Language & Grammar of Computers</a>

## Presentations

- Patterson-Hennessey: [Chapter 2](../books/patterson-hennessey/Patterson6e_MIPS_Ch02_PPT.ppt)

## Topics

- Textbook sections
  - 2.7 &mdash; Instructions for Making Decisions
- [MIPS Green Sheet](../books/patterson-hennessey/MIPS_Green_Sheet.pdf)

## Readings & Subject Information

# <a id="week7">Week 7 &mdash; 2/28 &mdash; Intro to Assembly Language Programming &mdash; MIPS CPU</a>

## Topics

- [Intro to MIPS Assembly Programming](../mips/mips.md) and programming on a MIPS emulator.
- [Working with `spim` &mdash; the MIPS32 emulator](./spim.md)
- Textbook sections
  - 2.8 &mdash; Supporting Procedures in Computer Hardware
  - 2.9 &mdash; Communicating with People
  - 2.10 &mdash; MIPS Addressing for 32-bit Immediates and Addresses
  - 2.12 &mdash; Translating and Starting a Program
  - 2.13 &mdash; A C Sort Example to Put It All Together
  - 2.14 &mdash; Arrays versus Pointers
- [MIPS Green Sheet](../books/patterson-hennessey/MIPS_Green_Sheet.pdf)

## Readings & Subject Information

# <a id="week8">Week 8 &mdash; 3/6 &mdash; Intro to Assembly Language Programming &mdash; MIPS CPU</a>

## Topics

- Programming arrays, conditional loops, conditional statements, leaf procedures in MIPS32.
- [MIPS Green Sheet](../books/patterson-hennessey/MIPS_Green_Sheet.pdf)

## Readings & Subject Information

# <a id="week9">Week 9 &mdash; 3/13 &mdash; Arithmetic for Computers &mdash; Adders, Multipliers, Dividers</a>

## Presentations

- Patterson-Hennessey: [Chapter 3](../books/patterson-hennessey/Patterson6e_MIPS_Ch03_PPT.ppt)
- Patterson-Hennessey: [Chapter 4](../books/patterson-hennessey/Patterson6e_MIPS_Ch04_PPT.ppt)

## Topics

## Readings & Subject Information

# <a id="week10">Week 10 &mdash; 3/27 &mdash; **Midterm Exam** &mdash; Arithmetic for Computers &mdash; Adders, Multipliers, Dividers</a>

## Presentations

- Patterson-Hennessey: [Chapter 3](../books/patterson-hennessey/Patterson6e_MIPS_Ch03_PPT.ppt)

## Topics

## Readings & Subject Information

# <a id="week11">Week 11&mdash; 4/3 &mdash; The Processor &mdash; Data Path and Control</a>

## Presentations

- Patterson-Hennessey: [Chapter 4](../books/patterson-hennessey/Patterson6e_MIPS_Ch04_PPT.ppt)

## Topics

## Readings & Subject Information

# <a id="week12">Week 12 &mdash; 4/10 &mdash; The Processor &mdash; Data Path and Control</a>

## Presentations

- Patterson-Hennessey: [Chapter 4](../books/patterson-hennessey/Patterson6e_MIPS_Ch04_PPT.ppt)

## Topics

## Readings & Subject Information

# <a id="week13">Week 13 &mdash; 4/17 &mdash; Memory Hierarchies</a>

## Presentations

- Patterson-Hennessey: [Chapter 5](../books/patterson-hennessey/Patterson6e_MIPS_Ch05_PPT.ppt)

## Topics

## Readings & Subject Information

# <a id="week14">Week 14 &mdash; 4/24 &mdash; Memory Hierarchies</a>

## Presentations

- Patterson-Hennessey: [Chapter 5](../books/patterson-hennessey/Patterson6e_MIPS_Ch05_PPT.ppt)

## Topics

## Readings & Subject Information

# <a id="week15">Week 15 &mdash; 5/8 &mdash; **Final Exam**; Submit MVP project</a>

## Topics

## Readings & Subject Information
