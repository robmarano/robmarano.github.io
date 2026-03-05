# ECE 251: Session 7 Teaching Agenda
**Date:** March 5, 2026
**Topic:** The Culmination of Assembly, Hardware Reality, and Project Kickoff

---

## 1. Welcome & Introduction (10 mins)
*   **Check-in:** How is everyone feeling about MIPS assembly so far?
*   **Overview of Tonight:** We are bridging the gap between isolated MIPS instructions and real-world software, launching the final project, and prepping for next week's Midterm.

## 2. SPIM OS-like Library Calls (Syscalls) (20 mins)
*   **Concept:** SPIM acts as a mini-OS. How do we do actual I/O?
*   **Convention:** Load Service Code into `$v0`, Arguments into `$a0`/`$f12`, then `syscall`.
*   **Walkthrough 1:** Interactive I/O (Prompting user for Name/Age, reading integers and strings).
*   **Walkthrough 2:** File I/O (Opening a file, reading raw ASCII buffer, closing the file).
*   **Discussion:** SPIM Exceptions (`exceptions.s`). What happens when we crash? (Address unaligned, division by zero).

## 3. Advanced Assembly Patterns (25 mins)
*   **Iterating Arrays:** 
    *   Explain the `addi $t0, $t0, 4` shift for Word arrays versus `addi $t0, $t0, 1` for ASCII strings (`.asciiz`).
*   **Deep Dive: Recursive Procedures:**
    *   Trace `fib(3)` on the whiteboard.
    *   Show how the Stack (`$sp`) grows downwards and how `$ra` and `$a0` must be natively saved/restored to prevent catastrophic looping failures.

## 4. Break (10 mins)

## 5. Real-World Application: Hardware vs. Software (25 mins)
*   **The Quake 3 Fast Inverse Square Root:**
    *   Show the algorithm. Explain why they hacked hardware bits (`mfc1`/`mtc1`) to approximate $1/\sqrt{x}$ instead of using standard floating-point division.
    *   *Upcoming Topic Teaser:* Mention Chapter 3 (IEEE 754 Floating-Point protocol and the FPU Coprocessor 1).
*   **The Pedagogical Blind Spot (Emulator Abstraction):**
    *   Show the terminal benchmark: 2 software steps (Standard IEEE) vs 14 software steps (Quake). The emulator thinks the 2-step is faster!
    *   **The Physical Reality:** Bring back the Chapter 1 CPU Performance Equation: $\text{IC} \times \text{CPI} \times \text{Timer}$.
    *   Explain that on 1999 silicon, Floating Point Division took up to 54 clock cycles (CPI=27.5), while integer bit-shifts took exactly 1 clock cycle (CPI=1.0). The 14-step Quake method was physically 4x faster on hardware!

## 6. The Final Group Project Launch (20 mins)
*   **The Goal:** Build a von Neumann CPU natively from scratch using SystemVerilog.
*   **Logistics:** Teams of exactly 2. Submitted via GitHub repo + Microsoft Teams.
*   **The Rubric Breakdown (100 Points):**
    *   ISA Design (Instruction formats, Memory reference).
    *   Memory Design (Inst/Data layouts, Program loading).
    *   Processor Design (Datapath, Control, Sign Extender, ALU multiplexing).
    *   Software Validation (Running actual code on their simulated CPU).
*   **Extra Credit:** Pipelining, L1 Cache, or building a custom Python/C Assembler (Up to 30 EC points!).

## 7. Assignment & Midterm Logistics (10 mins)
*   **Tonight's Assignment (Ideation):** Find a partner, pick a classic architecture for inspiration (Intel 4004, 8086, MOS 6502, etc.), and submit a 1-page write-up proposal uniformly on Teams.
*   **Midterm Next Week (Session 8):**
    *   Remind them of the Midterm Study Guide (`study_guide_midterm.md`).
    *   Topics: Logic Gates, Karnaugh Maps, SystemVerilog Modules, MIPS Architecture, and translating C to Assembly with Stack tracing.
    *   *Call to Action:* Come to office hours!

---
*End of Session*
