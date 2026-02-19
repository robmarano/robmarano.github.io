# ECE 251 Computer Architecture - Spring 2026 Development Log

This document serves to record decisions, architectural structure, and recent development work for the ECE 251 course repository.

## Course Structure
*   **Root**: `courses/ece251/2026/`
*   **Syllabus**: `ece251-syllabus-spring-2026.md` / `.pdf`
*   **Weekly Notes**: `weeks/week_XX/` (e.g., `notes_week_04.md`)
*   **Assignments**: `assignments/hw-0X.md`
*   **Code Examples**: MIPS Assembly (`.asm`), SystemVerilog (`.sv`), Makefiles

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
