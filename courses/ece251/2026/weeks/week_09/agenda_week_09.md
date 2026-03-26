# ECE 251: Session 9 Teaching Agenda
**Date:** March 26, 2026
**Topic:** The Processor: Datapath, Control, and Single-Cycle Execution

---

## 1. Welcome & Midterm Debrief (10 mins)
*   **Check-in:** How did the Midterms feel? 
*   **Overview of Tonight:** We are officially migrating from pure software Assembly into structural Hardware Design. We will build a functional MIPS processor piece-by-piece.

## 2. Core MIPS Subset & Performance Limitations (15 mins)
*   **Concept:** What instructions are we physically wiring data-paths for today? (`lw`, `sw`, `add`, `sub`, `and`, `or`, `slt`, `beq`, `j`).
*   **The Equation:** CPU Time = $IC \times CPI \times Clock Cycle Time$.
*   **The Bottleneck:** Why forcing a Single-Cycle execution natively locks $CPI=1$, forcing the $Clock Cycle Time$ to brutally absorb the longest instruction's latency.

## 3. Logic Design & Clocking Rules (Hamacher Reference) (20 mins)
*   **Combinational vs. Sequential:** Differentiating memory-less math gates (ALU) from state-locked memory loops (Registers, PC).
*   **Edge vs. Level Triggering:**
    *   Explain the physics of **Setup Time** and **Hold Time**.
    *   Trace the 5-Stage physical flow: How the PC triggers on a positive-edge, but we physically split the Register File reads (level-high flow) against the writes (negative-edge/trailing-edge locking) to avoid reading/writing identical registers destructively.

## 4. Break (10 mins)

## 5. Building the Datapath (Step-by-Step) (40 mins)
*   **Infographic:** Put up the *Inside the MIPS Single-Cycle Processor* visual map.
*   **Phase 1 (Fetch):** Using the PC state to target I-Mem, while incrementing `PC+4`.
*   **Phase 2 (R-Type/Math):** Snatching operands exactly from the Register Read Ports directly into the ALU.
*   **Phase 3 (Load/Store Memory):** Introducing the **16-to-32 bit Sign-Extender**. Why the ALU calculates base offsets instead of raw math for variables.
*   **Phase 4 (Branch Target Constraints):** Evaluating equality via the ALU while physically Shifting-Left-2 to target distant `PC` blocks.
*   **Fusing the Independent Modules:** Why we deploy **Multiplexers (MUXes)** acting as traffic cops (ALUSrc, MemtoReg, PCSrc) controlled purely by the Control Unit logic.

## 6. SystemVerilog Emulation (15 mins)
*   **Bridging to the Final Project:** How we code this physical architecture natively using SystemVerilog structs.
*   **State Elements:** Modeling edge-triggering identically using `always_ff @(posedge clk)`.
*   **Combinational Logic:** Modeling Muxes and the ALU sequentially using `always_comb` and `assign` without clock constraints.

## 7. The 950ps Limitations & Assignment (10 mins)
*   **The Physical Reality:** 
    *   Show the latency math: `lw` = 950ps vs `add` = 700ps.
    *   Prove why an R-Type instruction must strictly sit idle for 250ps waiting for the rigid clock cycle. 
    *   *Next Week Teaser:* How we slice the single cycle aggressively into Pipelining arrays to dramatically boost clock frequencies!
*   **Homework 09:** Assigned via Microsoft Teams. Tracing component utilization, evaluating explicit MIPS 32-bit hardware hex traces, and formally calculating critical datapath latency paths.

---
*End of Session*
