---
title: ECE 251 Cheat Sheet (Chapters 1-4)
subtitle: Computer Architecture & Datapath Design
---

# Architecture Cheat Sheet (Chapters 1-4)

This reference consolidates the critical mathematical equations, instructional formats, logic limits, and hardware abstractions mapping Chapters 1 through 4 of *Computer Organization and Design* (MIPS Edition).

---

## Chapter 1: Performance & Abstractions

### Core Performance Equations
*   **Execution Time (CPU Time)**: 
    *   `CPU Time = Instruction Count x CPI x Clock Cycle Time`
    *   `CPU Time = (Instruction Count x CPI) / Clock Rate`
*   **Cycles Per Instruction (CPI)**:
    *   `CPI = Total Clock Cycles / Instruction Count`
*   **Relative Performance**:
    *   `Performance(A) / Performance(B) = Execution Time(B) / Execution Time(A)`

### Dynamic Power Limit
Power is traditionally constrained by switching properties in CMOS transistors:
*   `Power = 1/2 x Capacitive Load x Voltage^2 x Frequency Switching`

---

## Chapter 2: The MIPS Instruction Set Architecture (ISA)

### Universal Register File
| Name | Number | Usage | Preservation Constraint |
| :--- | :--- | :--- | :--- |
| `$zero` | 0 | Hardwired Constant Logic `0` | N/A |
| `$v0-$v1` | 2-3 | Results and expression evaluations | Not preserved |
| `$a0-$a3` | 4-7 | Procedure arguments | Not preserved |
| `$t0-$t9` | 8-15, 24-25 | Temporary variables | Not preserved |
| `$s0-$s7` | 16-23 | Saved variables | **Saved across calls** |
| `$sp` | 29 | System Stack Pointer | **Saved (Restored)** |
| `$ra` | 31 | Return Address (linked jumps) | **Saved** |

### Machine Code Formats (32-bit Array)

**1. R-Type (Register Math)** `add, sub, and, or, slt`
`[ Opcode (6) | rs (5) | rt (5) | rd (5) | shamt (5) | funct (6) ]`

**2. I-Type (Immediate/Offset)** `lw, sw, beq, bne, addi`
`[ Opcode (6) | rs (5) | rt (5) | Immediate (16) ]`

**3. J-Type (Jump Alignment)** `j, jal`
`[ Opcode (6) | Target Address (26) ]`

### Byte Alignment
MIPS memory is byte-addressed. Word addresses (32-bits) MUST be multiples of 4 (e.g., `0, 4, 8, 12`).

---

## Chapter 3: Arithmetic & Data Representation

### Two's Complement Integer Representation
*   **Range**: `-2^(N-1)` to `+2^(N-1) - 1`
*   **Inversion Strategy**: To manually convert an integer sign, invert all logical binary bits ($\sim x$), then mathematically add $1$.
*   **Overflow**: Occurs mathematically when addition or subtraction logic exceeds the positive or negative hardware bounding limit. Hardware detects this via the `XOR` of the mathematical carry-in and carry-out of the final physical sign bit.

---

## Chapter 4: The Processor Datapath & Control

### Implementation 1: The Single-Cycle Datapath
*   **Concept**: Maps the entire physical instruction process inside one massive clock pulse.
*   **CPI Limit**: By definition, $CPI = 1$.
*   **Frequency Limit**: The structural Clock Cycle Time ($T_c$) is forcibly determined by the most complicated instruction delay (The `lw` instruction: `I-Mem -> Reg -> ALU -> D-Mem -> Reg`).

### Implementation 2: The Multicycle Datapath
*   **Concept**: Breaks an instruction into 3-5 distinct logic phases. Bounded by independent internal staging registers (`IR`, `MDR`, `A`, `B`, `ALUOut`).
*   **CPI Limit**: Average $CPI \approx 3.5 - 4.0$.
*   **Frequency Limit**: Clock period ($T_c$) drops to match only the longest hardware step (e.g., matching the latency limit of the `Memory read` or `ALU compute`).
*   **FSM Stages**: 
    1.  `Fetch`: Extract instruction from RAM.
    2.  `Decode`: Read Register values, prepare branch target offsets.
    3.  `Execute`: Fire physical ALU calculation.
    4.  `Memory`: Read/Write physical RAM storage.
    5.  `Write Back`: Log updated math back into the targeted Register.

### Implementation 3: Pipelining
*   **Concept**: The "Laundry Analogy" style of execution overlap. Starts a new instruction traversal constantly.
*   **CPI Limit**: Mathematically targets a throughput $CPI = 1.0$, while retaining the ultra-fast clock frequency of Multicycle hardware.
*   **Architectural Drawback**: Firing sequential physical steps rapidly generates timing wait-state **Hazards** (Structural missing logic paths, Data conflicts missing Write Back stages, or Control conflicts disrupting the PC target).

[ &larr; back to syllabus](/courses/ece251/2026/ece251-syllabus-spring-2026.html)
