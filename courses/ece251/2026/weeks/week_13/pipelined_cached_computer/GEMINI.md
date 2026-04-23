# GEMINI.md - Pipelined MIPS32 CPU with Exceptions

This document provides instructional context for the ECE 251 Pipelined MIPS32 Processor project, focusing on the implementation of exceptions and interrupts.

## Project Overview
A 5-stage MIPS32 Pipelined Processor implemented in SystemVerilog. Derived from Patterson & Hennessy (6th Ed), this implementation specifically adds support for **Asynchronous Pipeline Exceptions** and **External Interrupts**.

- **Tech Stack**: SystemVerilog, Python (Assembler), Icarus Verilog (`iverilog`), `vvp`, `gtkwave`/`surfer` (VCD visualization).
- **Architecture**: 5-stage pipeline (IF, ID, EX, MEM, WB).
- **Special Features**: 
  - Asynchronous interrupt pin (`intr`) triggers pipeline flushes and PC redirection.
  - Exception vector located at `32'h8000_0180`.
  - Hazard detection and data forwarding for RAW hazards and control hazards.

## Pipeline Architecture
1.  **IF (Instruction Fetch)**: Fetches from `imem`, increments PC. Redirection occurs here on branch/jump/exception.
2.  **ID (Instruction Decode)**: Reads `regfile`, resolves branches (using `eqcmp`), sign-extends immediates. Hazard unit triggers stalls/flushes here.
3.  **EX (Execute)**: ALU operations, address calculation, data forwarding via muxes. Captures `EPC` on exception.
4.  **MEM (Memory)**: Data memory (`dmem`) read/write.
5.  **WB (Writeback)**: Result written to `regfile` on negative clock edge.

## Building and Running
The project uses a `Makefile` to automate the assembly and simulation workflow.

- **Standard Run**: 
  ```bash
  make all ASM=test_prog
  ```
- **Interrupt Test**: 
  ```bash
  make all ASM=test_exceptions
  ```
- **Clean Artifacts**:
  ```bash
  make clean
  ```
- **Manual Assembly**:
  ```bash
  python3 assembler.py <input.asm> <output.exe>
  ```

## Development Conventions
- **Memory-Mapped I/O Halt**: Write to address `252` (`0xFC`) to gracefully terminate the simulation.
  ```assembly
  sw $zero, 252($zero)
  ```
- **Assembler**: Supports `.org` for memory placement and basic MIPS instructions (`add`, `sub`, `and`, `or`, `slt`, `mult`, `mfhi`, `mflo`, `lw`, `sw`, `beq`, `addi`, `j`).
- **Debugging**: Simulation logs cycle-by-cycle state to `debug_output.txt`.

## Known Issues & Architectural Status
The following issues previously identified in `TODO.md` have been successfully remediated:

1.  **[FIXED] EPC Logic Error**: `datapath.sv` now correctly captures the PC of the instruction in Decode (`pcplus4D - 4`) during an exception flush.
2.  **[FIXED] ALU Control Expansion**: `alucontrol` has been expanded to 4 bits. `MULT` (4'b1001) and `DIV` (4'b1000) are now unique and do not collide with `NOR` or `MFHI`.
3.  **[FIXED] Exception Vector Memory Aliasing**: Memory depths were increased to prevent aliasing, and handlers are correctly located at `0x180`.
4.  **[FIXED] Testbench Port Mismatch**: `tb_computer.sv` correctly instantiates the `intr` port.

## Remaining TODOs
- Further verify branch prediction/delay slot logic if implemented.
- Optimize cache performance for larger datasets.
- Implement additional MIPS instructions as needed.

## File Structure
- `cpu.sv`: Top-level CPU wrapper.
- `datapath.sv`: Pipelined datapath implementation.
- `hazard.sv`: Hazard unit (forwarding, stalls, flushes).
- `controller.sv`: Main and ALU decoders.
- `imem.sv` / `dmem.sv`: Instruction and Data memory.
- `assembler.py`: Python script to convert `.asm` to `.exe` (hex format for `$readmemh`).
- `tb_computer.sv`: Main system testbench.
- `tb_exceptions.sv`: Specialized testbench for interrupt verification.
