---
title: ECE 251 Hardware Assignment 12 Solution Key
subtitle: Pipelined Exceptions & Interrupts
---

# HW-12 Solution Key

## Part 1: Distinguishing Interrupts and Exceptions

### Problem 1.1: Functional Differences
**Solution**:
*   **Exception**: Synchronous electrical faults evaluated sequentially generated internally across the structural processor executing instructions (e.g., Division by Zero math limits, Arithmetic Overflow).
*   **Interrupt**: Asynchronous electrical conditions natively injected externally into processor boundaries (e.g., physical keyboard typing signals, Network I/O controller packet triggers).

---

## Part 2: EPC Memory Tracking Arrays

### Problem 2.1: Extracting the EPC Boundary Log
**Solution**:
The internal `EPC` (Exception Program Counter) must correctly identify the physical absolute origin sequence triggering the error natively. The specific operation causing the logical exception mathematically evaluates to the `add` payload executing identically mapped sequentially at `0x00400038`.
**EPC Target Evaluated: `0x00400038`**.

### Problem 2.2: The Vector Target
**Solution**:
The hardware mechanism natively aborts sequential logic algorithms explicitly remapping the logic trace directly up into the localized OS handlers logic structure evaluated structurally.
**MIPS OS Execution Target Routing: `0x80000180`**.

---

## Part 3: Modifying SystemVerilog Synthesized Datapaths

### Problem 3.1: Expanding the PC SystemVerilog Matrix
**Solution**:
The `NextPC` combinational multiplex logic mandates hierarchical constraints. Exception flags definitively hold maximal priority overrides globally, followed consecutively by physical Control hazard loops, and cascading uniformly backwards toward strictly sequential logic mapping paths.

```systemverilog
always_comb begin
  if (Exception_Flag) 
    NextPC = 32'h8000_0180; // Absolute priority mapping target OS handler
  else if (PCSrcE)    
    NextPC = PCBranchE;     // Branch Taken resolved path
  else                
    NextPC = PCPlus4F;      // Sequential logic
end
```

### Problem 3.2: Clearing the Pipeline Log States
**Solution**:
The processor dynamically suppresses the sequential operations lingering temporally trailing behind the executed internal error structurally. The exact instructions trapped directly across the preceding stages (`IF`, `ID`) must evaluate explicitly directly as logic hardware clears mapping natively to explicit `NOP` triggers:
The Hazard logic dynamically targets the precise sequential boundaries natively routing an active electrical **Clear / Flush** target flag straight across the `IF/ID` and `ID/EX` latch matrices electrically zeroing processing structures immediately natively.

---

## Part 4: Conceptual Synthesis of HDL Mechanics

### Problem 4.1: Retrospective on Von Neumann HDL Constraints
**Solution**: 
The stored-program von Neumann algorithm assumes a physical sequence of data fetch mechanisms mapping explicitly alongside hardware ALU computations natively evaluated across central memory arrays directly. Utilizing **SystemVerilog (HDL)** permits a dual-axis execution mapping system:
1.  **Simulation Verification**: Utilizing explicitly evaluated logical `testbench.sv` files mechanically proves overlapping combinations mapping software loops functionally output explicit integer values dynamically prior to deployment testing structures.
2.  **Silicon Synthesis**: HDL is not just coding software algorithms; it translates uniformly mapping behavioral logical statements natively transforming structural syntax precisely across massive digital combinatorial nets generating the photolithography blueprints converting structural hardware natively into pure transistor physical layouts logically.
