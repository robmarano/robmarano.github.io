# ECE 251: Cumulative Final Exam Study Guide
**Spring 2026 | Prof. Rob Marano**

Welcome to the end of the semester! Over the last 14 weeks, we have bridged the gap from fundamental boolean logic all the way up to the complex memory management and pipelined architectures of modern microprocessors. 

This final exam is **cumulative** and covers all non-SystemVerilog material from our course, specifically targeting Patterson & Hennessy textbook (*Computer Organization and Design*), along with our supplemental hardware analyses. 

You are new to computer architecture, but you have been pushed to analyze problems at the logic and software levels. To succeed on this exam, you must demonstrate a cohesive understanding of how a high-level program translates down to machine code, propagates through a 5-stage pipelined datapath, survives pipeline hazards, accesses the multi-level cache hierarchy, and translates virtual addresses to physical DRAM.

---

## 🕒 Exam Strategy & Logistics
1.  **Format:** Expect a combination of quantitative problems (Iron Law, AMAT, IEEE 754), architectural tracing (Pipeline diagrams, TLB tracing), and hardware design reasoning.
2.  **Environment:** This is an **in-class, closed-book** exam. No notes, textbooks, internet access, or generative AI tools are permitted.
3.  **Show Your Work:** Full credit requires explicitly showing your mathematical steps, identifying assumptions, and **boxing your final answers**. A correct answer with no supporting logic will lose points.

---

## 🎯 Chapter 1 & 2: MIPS Architecture & Assembly (Weeks 1-7)
*The hardware/software interface and execution mechanics.*

### Key Concepts to Master:
*   **The 5 Components of a Computer:** Datapath, Control, Memory, Input, Output.
*   **The Iron Law of Performance:** The foundational equation stating that CPU execution time is fundamentally limited by three factors: the number of instructions, the architectural efficiency (cycles per instruction), and the physical physics of the clock speed.
    $$\text{CPU Time} = \text{Instruction Count (IC)} \times \text{Cycles Per Instruction (CPI)} \times \text{Clock Cycle Time}$$
*   **MIPS Load/Store Architecture:** Memory is only accessed via `lw` and `sw`. All other arithmetic operations happen strictly within the 32 general-purpose registers (`$zero`, `$s0-$s7`, `$t0-$t9`).
*   **Memory & Endianness:** Endianness dictates byte ordering in memory. **Big-Endian** stores the most significant byte at the lowest address, while **Little-Endian** stores the least significant byte first.
*   **Procedures and the Stack:** How `jal` saves the return address to `$ra`. How the stack pointer `$sp` moves (grows downward) to save registers for nested/recursive procedure calls, and how to restore them before `jr $ra`.

### 📝 Practice Checklist:
- [ ] I can manually translate a high-level `while` loop or `if/else` block into MIPS assembly.
- [ ] I can trace the recursive calls of a procedure and map exactly what is pushed and popped onto the Stack at each level.

---

## 🎯 Chapter 3: Floating-Point Architecture (Week 8)
*Breaking out of the integer boundary.*

### Key Concepts to Master:
*   **The Decimal Dilemma:** Why Fixed-Point logic fails (lack of dynamic range for macro and micro scales).
*   **IEEE 754 Floating Point Protocol:** A standardized representation that dynamically "floats" the decimal point to maximize both scale range and fractional precision within 32 bits.
    *   Representation: $(-1)^{\text{Sign}} \times (1 + \text{Fraction}) \times 2^{(\text{Exponent} - \text{Bias})}$
    *   Single Precision (32-bit): 1 bit sign, 8 bits exponent (Bias 127), 23 bits fraction.
    *   Double Precision (64-bit): 1 bit sign, 11 bits exponent (Bias 1023), 52 bits fraction.

### 📝 Practice Checklist:
- [ ] I can convert a fractional decimal number into its 32-bit IEEE 754 hexadecimal representation.
- [ ] I understand how the hardware "floats" the decimal point to maximize both range and precision.

---

## 🎯 Chapter 4: The Datapath and Control (Weeks 9-12)
*Building the CPU from logic gates.*

### Key Concepts to Master:
*   **Single-Cycle vs Multi-Cycle CPUs:**
    *   **Single-Cycle:** Uses a **Harvard Architecture** (physically separate Instruction and Data memories) to prevent structural hazards. Perfect IPC ($CPI = 1.0$), but the physical clock cycle is bottlenecked by the slowest instruction (usually `lw`).
    *   **Multi-Cycle:** Uses a **Von Neumann Architecture** (instructions and data share the same physical memory) and an **FSM (Finite State Machine)** to step through execution states iteratively using intermediate registers (`IR`, `MDR`, `A`, `B`, `ALUOut`).
*   **The 5-Stage Pipelined Datapath:**
    1.  **IF:** Instruction Fetch (PC update).
    2.  **ID:** Instruction Decode & Register Read.
    3.  **EX:** Execute (ALU operations, address calculation).
    4.  **MEM:** Data Memory access.
    5.  **WB:** Write Back to register file.
*   **Pipelining Hazards:** Physical violations caused by overlapping instructions.
    *   **Structural Hazards:** Hardware resource conflicts (e.g., trying to read and write memory simultaneously).
    *   **Data Hazards:** True dependency (RAW: Read-After-Write). Solved by **Forwarding** (bypassing registers to feed ALU out to ALU in) or **Stalling** (injecting bubbles for Load-Use hazards).
    *   **Control Hazards:** Branches disrupt the PC. Solved by flushing the pipeline on a misprediction and using **Branch Prediction** hardware.
*   **Exceptions & Interrupts:** How the hardware abruptly flushes the pipeline and saves the Program Counter to the `EPC` (Exception Program Counter) register when an asynchronous fault occurs.

### 📝 Practice Checklist:
- [ ] I can draw a multi-cycle pipeline diagram (Clock cycles 1-10 on the X-axis, Instructions on the Y-axis) and insert stalls/bubbles where Data Hazards occur.
- [ ] I understand exactly which pipeline registers (e.g., `EX/MEM`) hold data needed for forwarding.

---

## 🎯 Chapter 5: Exploiting Memory Hierarchy (Weeks 13-14)
*Defeating the Memory Wall.*

### Key Concepts to Master:
*   **The Principle of Locality:** The tendency of a processor to access the same set of memory locations repetitively over a short period of time (**Temporal Locality**) or adjacent locations (**Spatial Locality**).
*   **Cache Topologies:**
    *   Address splitting: `Tag | Index | Offset`.
    *   Direct-Mapped (1 comparator, high conflict miss rate).
    *   N-Way Set Associative (N comparators, lower miss rate).
    *   Fully Associative (Tag matches every block, used in TLBs).
*   **Performance Metrics:**
    *   **AMAT (Average Memory Access Time):** The average time it takes for a CPU to access data, factoring in the blazing speed of a cache hit and the massive delay of a cache miss.
    *   $$\text{AMAT} = \text{Hit Time} + (\text{Miss Rate} \times \text{Miss Penalty})$$
    *   Understand how an L2 cache geometrically reduces the L1 Miss Penalty, dropping the Effective CPI!
*   **Dependable Memory (Hamming Codes):**
    *   **SEC/DED (Single Error Correction / Double Error Detection):** A class of mathematical parity codes that allows hardware to actively fix a single flipped bit in RAM. Calculations: $2^p \ge p + d + 1$.
    *   Syndrome decoding: Constructing the overlapping even-parity equations (P1, P2, P4, P8) to locate the exact flipped bit.
*   **Virtual Memory:**
    *   Translating a Virtual Page Number (VPN) to a Physical Page Number (PPN).
    *   **The TLB (Translation Lookaside Buffer):** A specialized, extremely fast hardware cache inside the MMU that stores recent virtual-to-physical page table translations.
    *   **Page Faults:** Trapping to the OS when the Page Table Valid bit is 0, requiring a slow magnetic disk fetch.

### 📝 Practice Checklist:
- [ ] I can calculate the exact dimensions (Tag bits, Index bits, Offset bits) for a Cache given the Byte size, Block size, and Associativity.
- [ ] I can trace a CPU memory access and determine if it results in a TLB Hit, TLB Miss, Page Table Hit, or Page Fault.
- [ ] I can use the 4 Hamming parity equations to generate a binary Syndrome and correct a flipped bit in a hexadecimal word.

---
*Good luck with your studying! The goal of this exam is not memorization, but engineering synthesis. You must prove you know how the whole system connects.*
