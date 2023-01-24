# ECE 251 - Computer Architecture (Spring 2023)

## General Course Information

**Instructor:** Prof. Rob Marano  
Email: rob@cooper.edu  
**Semester of the course:** Spring 2023  
**Dates of the course:** 24 JAN to 9 MAY (15 sessions, no class 14 MAR)
**Room:** 101 in NAB

[Weekly course notes](./ece251-notes.md)

## Course Description

Introduction to the design of computers and computer systems. Topics include: integer and floating-point representations and operations: ALU design; von Neumann and Harvard architectures; accumulator, general purpose register and stack-based processor design; RISC and CISC architectures; addressing modes; vector operations; microprogrammed and hard-wired controllers; machine language and assembly language programming; static and dynamics memory operation, timing and interfacing; cache; virtual memory; I/O systems: bus design and data transfer, DMA; interrupts and interrupt handling, polling; disk operation and organization; pipelined processor design. The course has a substantial project component that includes assembly language programming and the design and construction of systems that contain microcontrollers, programmable logic, and a variety of I/O devices.

3 credits. 4 hours per week (45 total hours). Link to [course catalog](https://cooper.edu/engineering/courses/electrical-and-computer-engineering-undergraduate/ece-251)

## Course Prerequisites

ECE 150 &mdash; [Digital Logic Design](https://cooper.edu/engineering/courses/electrical-and-computer-engineering-undergraduate/ece-150)

### Course Structure/Method

**Lectures and SW-based Labs:** This class meets in person on 1/24, 1/31, 2/7, 2/14, 2/28, 3/7, 3/21, 3/28, 4/4, 4/11, 4/18, 4/25, 5/2, and 5/9, for a total of 15 sessions. **Note:** 3/14 we do not meet due to spring break. The class meets from 6:00-8:50pm on class days. Office hours are held Tuesdays 5:00-6:00pm in the Engineering Adjunct's Office on the 2nd floor of the NAB at 41 Cooper Square. Appointments held remotely will be scheduled upon request in increments of 20 minutes. Please contact me on Microsoft Teams chat via rob.marano@cooper.edu.

The course will use expand your knowledge of digital logic design to understand the design of computers systems down to the fundamental internals of a processor, that is, a central processing unit (CPU), and its associated memory systems. The following topic areas will be covered:

1. Logic, Computer Abstraction, and Software Modeling Using Veril <br>(aka Bits, Gates, and Clocks &mdash; The Alphabet of Computers)
2. Instructions &mdash;The Language & Grammar of Computers
3. Assembly Language Programming &mdash; MIPS
4. Arithmetic for Computers &mdash; Adders on Up
5. The Processor &mdash; Data Path and Control
6. Memory Hierarchies

## Anticipated Schedule (at class pace)

|      Dates | Topic                                                   |
| ---------: | :------------------------------------------------------ |
| 1/24, 1/31 | Computer Abstraction, and Software Modeling             |
|  2/7, 2/14 | Software Modeling Using Verilog                         |
| 2/21, 2/28 | Instructions &mdash;The Language & Grammar of Computers |
|  3/7, 3/21 | Assembly Language Programming &mdash; MIPS              |
|  3/28, 4/4 | Arithmetic for Computers &mdash; Adders on Up           |
| 4/11, 4/18 | The Processor &mdash; Data Path and Control             |
|  4/25, 5/2 | Memory Hierarchies                                      |
|        5/9 | CPU Final Project Presentations                         |

Weekend lab sessions will be scheduled throughout the semester in order to work on your final project designs.

## Course Learning Outcomes

Upon successful completion of this course, each student will be able to:

1. Design basic and intermediate RISC pipelines, including the instruction set, data paths, control units and mechanisms to resolve pipeline hazards;
2. Understand memory hierarchy design, memory access time formula, performance improvement techniques, and trade-offs;
3. Design a functioning RISC-based CPU with a capable instruction set architecture using Verilog to emulate the design using the gate and the behaviorial models;
4. Write a simple assembler using a programming language of their choice (preferably Python for coding ease) to translate the ISA-based assembly code into machine code for the designed RISC-based processor;
5. By understanding the key interactions and dependencies between the processor and the hierarchy of memory, one would be able to include this knowledge to designing and implementing software code that demonstrates improved performance on the platform for which it's written.

## Communication Policy

The best way to contact me is via chat on Microsoft Teams then email. I will do my best to respond within 24 hours. Communication and participation in class is not only encouraged, but required. I seek to understand your individual understanding of the material each class. Advocate for yourself, early and often. Make time to meet with me should you need more explanation and assistance.

## Course Expectations

### Class Preparation

Depending upon the week's topic, each session will consist of two components: class discussion and hands-on lab, using your computers. Come prepared with your laptop and a Linux environment. Ensure you have access to the ICE Lab computers should you need it; check with jacob.koziej@cooper.edu.

Each class discussion consists of a mix of lectures, programming/simulations, and question-driven group analysis of one or more large programming problems. Lab will consist of either group or individual work on exercises or projects. Questions arising during lab time in class may be used to prompt additional discussion as time permits.

### Attendance

Success as a student begins with attendance. Class time serves not only for learning new concepts and skills but also for practicing what you have learned with active feedback. Some assignments and demos may be completed in class, but practice and study are required outside of class. Students are expected to attend classes regularly, arrive on time, and participate. I take attendance during every session, and it forms part of your grade. Students are encouraged to e-mail me when they are absent. Students are responsible for all academic work missed as a result of absences. It is at my discretion to work with students outside of class time in order to make-up any missed work.

## Materials

### Reference Books

Required access to these:

- [Computer Organization and Design &mdash; The Hardware/Software Interface MIPS, 6th Edition](https://www.elsevier.com/books/computer-organization-and-design-mips-edition/patterson/978-0-12-820109-1) by David Patterson & John Hennessy, ISBN 9780128201091

### Software

All software used during this course will be open source-based. We will be using various tools during our class, including but not limited to:

- Verilog (design and emulation of combinational and sequential logic)
- MIPS emulator (assembly programming)
- Python 3 (to write your CPU's assembler)

## Assessment Strategy and Grading Policy

All assignments must be completed by the end of this course in order to receive at least a passing grade. _Individual_ homework ssignments, referred to as "HW{1..5}", will be handed-in electronically (scanned) via Microsoft Teams Assignments for this course. Quizzes will be held at the end of class as scheduled. On those days, offices hours will be canceled unless otherwise noted. Final group-based projects will be handed-in via your team's GitHub respository per project. We will discuss in class how to create each repository.

| Assessment | Title               | Points | Given On | Due Date             |
| ---------: | :------------------ | :----: | :------- | :------------------- |
|          1 | HW 1                |   10   | 1/24     | 1/31 @ 11:59:59pm ET |
|          2 | HW 2                |   10   | 1/31     | 2/7 @ 11:59:59pm ET  |
|          3 | HW 3                |   10   | 2/7      | 2/14 @ 11:59:59pm ET |
|          4 | HW 4                |   10   | 2/14     | 2/21 @ 11:59:59pm ET |
|          5 | Quiz 1              |   20   | -        | 2/21 quiz in class   |
|          6 | HW 5                |   10   | 2/21     | 2/28 @ 11:59:59pm ET |
|          7 | HW 6                |   10   | 2/28     | 3/7 @ 11:59:59pm ET  |
|          8 | Quiz 2              |   20   | -        | 3/7 quiz in class    |
|          9 | HW 7                |   10   | 3/7      | 3/21 @ 11:59:59pm ET |
|         10 | HW 8                |   10   | 3/21     | 3/28 @ 11:59:59pm ET |
|         11 | Quiz 3              |   20   | -        | 3/28 quiz in class   |
|         12 | HW 9                |   10   | 3/28     | 4/4 @ 11:59:59pm ET  |
|         13 | HW 10               |   10   | 4/4      | 4/11 @ 11:59:59pm ET |
|         14 | Quiz 4              |   20   | -        | 4/11 quiz in class   |
|         15 | HW 11               |   10   | 4/11     | 4/18 @ 11:59:59pm ET |
|         16 | HW 12               |   10   | 4/18     | 4/26 @ 11:59:59pm ET |
|         17 | Quiz 5              |   20   | -        | 4/25 quiz in class   |
|         18 | HW 13               |   10   | 4/25     | 5/2 @ 11:59:59pm ET  |
|         19 | HW 14               |   10   | 5/2      | 5/9 @ 11:59:59pm ET  |
|         20 | Quiz 6              |   20   | -        | 5/9 quiz in class    |
|         21 | Final Group Project |  100   | -        | 5/12 @ 11:59:59pm ET |

## Final Projects as Minimal Lovable Product (MLP)

You will choose a partner with whom to jointly design a processor and simple memory that work together to run programs. These programs will be written in assembly language using your newly designed instruction set architecture (ISA). You will also write a simple assembler that will convert the assembly code to your CPU's machine code. Your computer (CPU plus memory) will only run one program at a time. Hence, since you do not have an operating system, you will not need to link your code.

- Collaborate on teams of 2 people, not less, not more.
- Source code to be maintained in a GitHub repository per team.
- Design files and documentation files (in markdown) will be stored in the repo; include images and photos, link them to your markdown documentation.
- Breakdown the MLP design in manageable sets of tasks and track these tasks &mdash; who does what by when, how long did it take.
- Demonstrate the MLP as part of your team's final presentation that you will record and post to YouTube. Your README.md file MUST include the link to the YouTube presentation, which will not be more than 5 minutes.

# Your Comp Arch Portfolio

Before you leave for break, ensure that you clean up your personal GitHub respository so that you can showcase the work you have developed. Like an artist, you know have a portfolio of software you have designed and implemented. No matter what you decide in your career, work and life is better through coding!

## Research, tinker, automate so you have more time for the fun stuff in life!

Enjoy the course.
