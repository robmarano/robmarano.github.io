# ECE 251 Computer Architecture - Spring 2026 Development Log

This document serves to record decisions, architectural structure, and recent development work for the ECE 251 course repository.

## Course Structure
*   **Root**: `courses/ece251/2026/`
*   **Syllabus**: `ece251-syllabus-spring-2026.md` / `.pdf`
*   **Weekly Notes**: `weeks/week_XX/` (e.g., `notes_week_04.md`)
*   **Assignments**: `assignments/hw-0X.md`
*   **Code Examples**: MIPS Assembly (`.asm`), SystemVerilog (`.sv`), Makefiles

### Markdown & MathJax Invariants
*   **MathJax Subscripts**: To prevent GitHub Pages' Markdown parser from aggressively swallowing underscores and converting them into HTML italics (which breaks KaTeX/MathJax rendering), **ALL mathematical subscripts must use a single space after the underscore**. 
    *   *Incorrect:* `$P_{dynamic}$` (Markdown reads `_` as an italic bracket).
    *   *Correct:* `$P_ {dynamic}$` (The space escapes the italic parser but is natively ignored by MathJax, rendering a perfect subscript).

## Recent Updates: Week 04

### 1. ISA Review enhancements (`notes_week_04.md`)
*   **Structure**: Grouped MIPS architecture principles, Memory Layout, Load/Store architecture, and Instruction Types (R/I/J).
*   **Memory Usage**: Explained PC-Relative vs. Base Addressing.
*   **Emulation**: Added section detailing Supervisory CPU Control and `spim` usage (loading, executing, stepping).

### 2. MIPS Assembly Examples (Created in `weeks/week_04/`)
*   **`hello_world.asm`**: Basic I/O `syscall` usage.
*   **`leaf_proc.asm`**: Simple procedure without nested calls ($ra handling).
*   **`nested_proc.asm`**: Procedure calling another procedure (stack management for $ra).
*   **`recursive_proc.asm`**: Factorial calculation, demonstrating deep stack frame management.
*   **Verification**: All examples successfully executed in `spim` locally.

### 3. "Fast Inverse Square Root" Algorithm
*   Included the famous *Quake III Arena* C code implementation.
*   Added an equivalent **MIPS32 Assembly** implementation using floating-point registers (`$f12`, `$f0`), integer bit-hacking (`mfc1`, `mtc1`), and the magic constant `0x5f3759df`.
*   Explained the Newton-Raphson approximation technique utilized in the code.

### 4. SystemVerilog Introduction (`notes_week_04.md`)
*   **Toolchain**: Introduced `iverilog`, `vvp`, and `gtkwave`.
*   **Makefiles**: Showed automation of the simulation workflow.
*   **Hardware Modeling**: Differentiated Structural, Dataflow (`assign`), and Behavioral (`always_ff`, `always_comb`) code styles.
*   **Components**: Examples provided for Logic Gates, Multiplexors, Clock Dividers, PWM generators, Flip-flops vs Latches, Register Files, and Adders/Multipliers.
*   **Repository Cleanup**: Added `*.vcd` and `*.vvp` to root `.gitignore` to keep simulation artifacts out of version control.

### 5. Supplemental Materials
*   **Slide Deck**: `ece251_week_04_slides.md` was generated directly from the notes for a 3-hour lecture.
*   **Homework**: `hw-04.md` created matching the style of previous assignments. Features 3 ISA problems (Machine code translation, Endianness, Stack frames) and 2 SV problems (Multiplexor design, Program Counter state logic).

## Recent Updates: Week 05

### 1. SystemVerilog Deep Dive (`notes_week_05.md`)
*   **Primitives**: Added instruction on Built-in Primitives (gates, buffers, delays) and User-Defined Primitives (Combinational and Sequential UDPs with state tables).
*   **Dataflow Modeling**: Expanded upon continuous assignments, ternary selections, concatenation, and explicit operator precedence tables.
*   **Assignment Rules**: Clarified the "Golden Rules" dividing continuous `assign`, blocking `=`, and non-blocking `<=` logic to prevent simulation and synthesis mismatch. 

### 2. MIPS Textbook Integration (`notes_week_05.md`)
*   **Procedures (Sec 2.8)**: Added detailed notes on caller/callee-saved registers, nested versus leaf procedures, and using the `$sp` stack pointer.
*   **Addressing (Sec 2.10)**: Explained PC-Relative addressing for branching and Pseudodirect addressing for jumping, highlighting the utility of `jr`.
*   **Synchronization (Sec 2.11)**: Introduced data races and mapped out MIPS atomic instructions (`ll` and `sc`) for implementing spin-locks.

### 3. Comprehensive Problem Set
*   Incorporated 18 new graded practice problems (Easy/Medium/Hard) covering all 6 topics recorded in `notes_week_05.md`, supplemented by a hidden (Kramdown-compatible) Answer Key.

### 4. MIPS32 ALU SystemVerilog Project (`mips32_alu/`)
*   **`alu.sv`**: Defined a fully parameterized, clockless (combinational) Arithmetic Logic Unit processing MIPS32 standard `opcode` and `funct` inputs.
*   **Supported logic**: Directly handles standard R-Type signals (`ADD`, `ADDU`, `SUB`, `SUBU`, `AND`, `OR`, `XOR`, `NOR`, signed `SLT`, and unsigned `SLTU`), driving the target `$rd` value and computing a boolean `zero` flag.
*   **`tb_alu.sv`**: Wrote an execution testbench checking combinational limits, mask calculations, and signed arithmetic logic. Documented testing and simulation in `README.md`.

### 5. Repository Maintenance
*   Cleaned and extracted topics from the Week 4 transcript (`2026-02-12.txt`) and placed them within `notes_week_04.md`.
*   Created reusable `module_template.sv` and `testbench_template.sv` files for fast prototyping.
*   Removed the accidentally staged `2026-02-12.txt` from Git tracking via `.gitignore`.

## Recent Updates: Homework Validation 

### 1. Assignment Solutions Generation
*   **`hw-02-solution.md`**: Authored rigorous solutions for Textbook Chapter 2. Mapped C-pointer structures natively into MIPS pointer increments (`addi $t0, $s6, 4`), and structurally modeled instruction architecture (Opcodes, `rs`, `rt`, `funct`) cleanly inside markdown tables.
*   **`hw-04-solution.md`**: Developed specific solutions covering MIPS Machine code (Hexadecimal translations), Endianness bounds, Procedure Call Stack Prologues (saving `$ra` and `$s0`), and explicitly coded SystemVerilog modules capturing dataflow 2-to-1 Multiplexors and Sequential edge-triggered PC registers.
*   **Formatting Compliance**: Validated that all generated `.md` documents strongly mirror the structural taxonomy, rubrics, and explicit mathematical typesetting requirements utilized natively within `hw-01-solution.md`.
 
