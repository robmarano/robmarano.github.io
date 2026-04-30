# Pull Request Summary: Week 13 & 14 Memory Hierarchy Curriculum & SV Implementation

## Objective
To finalize the Memory Hierarchy curriculum by implementing a cycle-accurate L1/L2 Multi-Level Cache SystemVerilog simulation for Week 13, and to generate comprehensive educational documentation (LaTeX Slides, Speaking Notes, and Homework Assignments) for Week 14.

## Changes Implemented
* **Week 13 SystemVerilog Caches:**
    * Implemented `cache_direct_mapped.sv`, `cache_fully_associative.sv`, and `cache_set_associative.sv` controllers.
    * Integrated L1 and L2 caches into the existing 5-stage MIPS datapath via a `cpu_stall` handshake protocol to mathematically demonstrate the Effective CPI reduction (4.34 to 1.89).
    * Validated execution via `iverilog` testbenches.
* **Week 14 Curriculum (Memory Hierarchy Part 2):**
    * Injected 9 official textbook problems (from COaD Chapter 5) into `notes_week_14.md` and `ece251_week_14_slides.tex`.
    * Synthesized the **Homework 14 Primer**, breaking down Hamming Code math, Virtual Memory logic, and Page Table sizing.
    * Authored `hw-14.md` and the official solution key `hw-14-solution.md` mirroring the formatting of previous weeks.
    * Generated `week_14_speaking_notes.md` containing a timed, 165-minute lecture script aligned with the LaTeX slide deck.
* **Documentation Polish:** Recompiled all LaTeX decks and validated the Cooper Union brand identity rendering without overflow errors.

## Verification
* SV Simulations run flawlessly with cycle-accurate hazard resolution.
* Official textbook math (e.g. CPI formulas and Hamming Code Bit 5 Syndrome) was rigorously cross-referenced against the `Solution 5_Secured.pdf` manual to correct existing typos.
* All LaTeX files compile to PDF securely.
