# Formalize ECE 251 Week 12 Curriculum (Exceptions, Interrupts, and Architecture Synthesis)

## Intended Changes
* Establish the complete reading assignments, pedagogical breakdown, and SystemVerilog implementation notes for the transition into Exceptions and Interrupts (Section 4.9).
* Anchor Week 12 inside the root index (`ece251-notes.md`).
* Draft the comprehensive `notes_week_12.md` integrating SystemVerilog mapping logic, easy/medium/hard problems for `EPC` fault resolution, and the Von Neumann Retrospective.
* Author and compile `ece251_week_12_slides.tex`.
* Provide mapping logic for `hw-12.md` and `hw-12-solution.md` covering Exception hardware handling.

## Implementation Details
* **Pipelined Datapath Exceptions**: Upgraded the Chapter 4 5-Stage Pipelined Architecture to natively support asynchronous external interrupts and trap routing via an inherently wired `Exception_Flag` mapping to flush logic across IF/ID and ID/EX registers.
* **EPC & Hazard Resolution**: Implemented PC back-tracking via the `EPC` register mapping to precisely trap `pcplus4D - 4` preventing duplicate trace execution. Completely decoupled 4-bit ALU control codes to gracefully allocate independent binary hashes for Multiplication (`MULT`, 4'b1001), Division (`DIV`, 4'b1000), `MFHI` (4'b0101) and native ALU operators to prevent sequential overriding collisions.
* **Deepened System Memory**: Scaled the Instruction and Data memory boundaries from parameters `r=6` to `r=8` to safely map structural vector limits preventing index aliasing upon mapping physical vectors to OS addresses (`.org 0x180`).
* **Comprehensive Assembly Tracking**: Injected 7 custom test simulation files spanning standard execution, hazards, control barriers, procedures, and exceptions. Natively loaded the RTL payload block into a robust `README.md` containing dynamic green instruction layouts, sequenced execution Mermaid diagrams organically, and step-by-step CLI simulation startup tests targeting the `iverilog` testbenches.
* **Slide Decks & Documentation**: Regenerated structured `.tex` slide frameworks mapping out course execution, embedded dynamically synthesized `markdown` bounds wrapping actual execution code into `notes_week_12.md`, and sealed testing pipelines natively via python assembler upgrades providing seamless `#`, `.org`, and address mapping mechanics.
