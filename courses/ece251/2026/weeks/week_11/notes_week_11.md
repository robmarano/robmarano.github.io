# Notes for Week 11
[ &larr; back to syllabus](/courses/ece251/2026/ece251-syllabus-spring-2026.html) [ &larr; back to notes](/courses/ece251/2026/ece251-notes.html)

> **[🗂️ Download Week 11 Slides (PDF)](./ece251_week_11_slides.pdf)**
>
> **[🔥 MIPS Architecture & Math Cheat Sheet (Ch 1-4) ](./mips_cheatsheet_ch1_4.html)**
>
> **[📘 Download Textbook Chapter 4 Slides (PPT)](/courses/ece251/books/patterson-hennessey/Patterson6e_MIPS_Ch04_PPT.ppt)**

# The Processor: Pipelining and Hazard Resolution (Part 3 of 3)

## Reading Assignment
*   Read Chapter 4, Sections 4.6, 4.7, 4.8, and 4.9 in the textbook (*Computer Organization and Design - MIPS Edition*).
*   Reference *Digital Design and Computer Architecture - 2nd Edition (Harris)*: Chapter 7.3 for specific SystemVerilog hardware implementations of pipeline registers and hazard units.
*   Reference *Computer Organization and Embedded Systems (Hamacher)* for additional hazard trace analogies.

## High-Level Topic Coverage

This week introduces **Pipelining**, an implementation technique whereby multiple instructions are overlapped in execution. Unlike the Single-Cycle architecture (which bottlenecks clock speed) or the Multi-Cycle architecture (which isolates states but processes one instruction at a time), a pipelined processor isolates states *and* processes multiple instructions simultaneously.

The theoretical goal of a pipeline is to execute $N$ instructions in $N$ clock cycles, pulling the Cycles Per Instruction (CPI) down to $1.0$ while maintaining the fastest possible clock frequency.

However, forcing instructions to overlap introduces physical violations called **Hazards**. We will physically mitigate these mathematically through SystemVerilog hardware logic.

### The Amdahl's Law Boundary
How does Amdahl's Law govern pipelining? Amdahl's formula $\text{Speedup} = \frac{1}{(1 - p) + \frac{p}{k}}$ dictates that system speedup is strictly limited by the sequential fraction of execution ($1-p$) that *cannot* be optimized. 

In a $k$-stage pipeline, the parallelizable fraction $p$ represents instructions executing flawlessly without delays. The sequential fraction $1-p$ represents the **Hazards** (pipeline stalls, memory wait states, and branch flushes). Even if we build an infinitely deep super-pipeline ($k \to \infty$), the maximum theoretical hardware speedup perfectly asymptotes at $\frac{1}{1-p}$. Therefore, Hazards form the absolute physical performance ceiling of any processor; you cannot achieve a perfect $CPI = 1.0$ if hazards continuously force the pipeline to stall.

---

## Topic Deep Dive

### 4.6 Pipelined Datapath and Control

To pipeline a processor, we must ensure that no two instructions attempt to use the same physical hardware resource simultaneously. We physically isolate the 5 steps of the MIPS execution cycle by inserting **Pipeline Registers** across the datapath boundaries.

<p align="center">
  <img src="../../../../../Image Bank/ch004-9780128201091/jpg-9780128201091/004035.jpg" width="600" alt="Pipelined Datapath with Registers">
</p>

These boundary registers lock in the output data of one stage on the rising clock edge and provide it as stable input to the next stage during the cycle. The pipeline registers are designated by the adjacent stages they separate:

1.  **`IF/ID`** (Instruction Fetch / Instruction Decode)
2.  **`ID/EX`** (Instruction Decode / Execute)
3.  **`EX/MEM`** (Execute / Memory Access)
4.  **`MEM/WB`** (Memory Access / Write Back)

#### SystemVerilog Implementation: Pipeline Registers
In a local SystemVerilog environment, pipeline stages are instantiated as wide $D$-flip-flop (`dff`) registers. For example, tracking the `Write Register` destination across the `EX/MEM` boundary requires logging the targeted 5-bit address:

```systemverilog
// EX/MEM Pipeline Register
module ex_mem_reg (input  logic        clk, reset,
                   input  logic        RegWriteE, MemWriteE, // Control signals
                   input  logic [31:0] ALUOutE, WriteDataE,  // Datapath outputs
                   input  logic [4:0]  WriteRegE,            // Target register
                   output logic        RegWriteM, MemWriteM,
                   output logic [31:0] ALUOutM, WriteDataM,
                   output logic [4:0]  WriteRegM);

  always_ff @(posedge clk or posedge reset) begin
    if (reset) begin
      RegWriteM <= 0;
      MemWriteM <= 0;
      // Reset remaining signals...
    end else begin
      RegWriteM <= RegWriteE;
      MemWriteM <= MemWriteE;
      ALUOutM   <= ALUOutE;
      WriteDataM <= WriteDataE;
      WriteRegM <= WriteRegE; // Passed to the next stage
    end
  end
endmodule
```

### 4.7 Data Hazards: Forwarding vs. Stalling

**Data Hazards** occur when the pipeline must be paused because a target instruction depends on the result of a previous instruction that has not yet completed its `Write Back` (WB) phase.
This is known mathematically as a **Read-After-Write (RAW)** hazard.

```mips
add $s0, $t0, $t1   # $s0 is written
sub $t2, $s0, $t3   # $s0 is read immediately
```

#### The Solution: Operand Forwarding (Bypassing)
Rather than waiting for `$s0` to be written back to the Register File in stage 5, the physical data is already calculated by the ALU at the end of the `add` instruction's `EX` stage. We can physically wire a pathway from the `EX/MEM` pipeline register directly back into the ALU inputs using a Multiplexer.

<p align="center">
  <img src="../../../../../Image Bank/ch004-9780128201091/jpg-9780128201091/004053.jpg" width="600" alt="Data Hazard Forwarding Logic">
</p>

#### SystemVerilog Implementation: The Hazard Unit
We design a standalone continuous assignment module (`hazard_unit.sv`) to control the forwarding MUXes. The logic formula calculates: *If the Write Register from an older instruction matches the Read Register of the current instruction, trigger the forwarding MUX.* 

```systemverilog
module hazard_unit (input  logic [4:0] RsE, RtE,         // Current Execution Source Regs
                    input  logic [4:0] WriteRegM,        // Previous Instruction Destination (in MEM)
                    input  logic       RegWriteM,        // Is previous instruction actually writing?
                    output logic [1:0] ForwardAE, ForwardBE);

  // Forwarding Logic for ALU Input A (RsE)
  always_comb begin
    // Check EX hazard (Memory stage calculation forwarded to Execute stage)
    if ((RegWriteM) && (WriteRegM != 0) && (WriteRegM == RsE)) begin
        ForwardAE = 2'b10; // Trigger MUX to route ALUOutM to ALU Input A
    end else begin
        ForwardAE = 2'b00; // Trigger MUX to use standard RegFile read data
    end
  end
endmodule
```

If the data isn't available yet (e.g., an `lw` instruction reading from Memory, which happens *after* the ALU), forwarding is physically impossible in time. The processor MUST **Stall** by inserting algorithmic "bubbles" into the pipeline.

#### Theory and Mechanism of a "Bubble"
Theory-wise, a **Bubble** is a dynamically generated `No-Op` (No Operation) state that flows down the pipeline identically to a real instruction, except it is mathematically inert (it writes to register `$0`, disables `MemWrite`, and disables `RegWrite`). It acts to delay the execution stream by 1 physical clock pulse without damaging the CPU's memory or register state.

Technically, in SystemVerilog, generating a bubble requires two simultaneous hardware actions orchestrated by the `hazard_unit`:
1.  **Freeze the Front End (`Stall`)**: We disable the `Enable` pin on the `PC` register and the `IF/ID` pipeline register. This locks the current instruction address in place so it is not accidentally skipped while the processor waits.
2.  **Clear the Execution Boundary (`Flush`)**: We trigger the synchronous `Clear` pin on the `ID/EX` register. On the next clock pulse, all the legitimate control signals inside that register drop to `0` (e.g., `RegWrite = 0`), creating the harmless bubble that travels downstream.

```systemverilog
// SystemVerilog Load-Use Stall Logic inside Hazard Unit
always_comb begin
  // If the instruction in Execute stage is an 'lw' (MemReadE == 1) 
  // AND its target destination matches our current Decode sources:
  if (MemReadE && ((RtE == RsD) || (RtE == RtD))) begin
    StallF = 1; // Freeze the Program Counter
    StallD = 1; // Freeze the IF/ID boundary register
    FlushE = 1; // Inject the Bubble into the ID/EX boundary register
  end else begin
    StallF = 0;
    StallD = 0;
    FlushE = 0;
  end
end
```

<p align="center">
  <img src="../../../../../Image Bank/ch004-9780128201091/jpg-9780128201091/004056.jpg" width="600" alt="Load-Use Hazard Stalling Output">
</p>

### 4.8 Control Hazards and Exceptions

**Control Hazards** arise from branch instructions (`beq`). When a branch is fetched, the pipeline does not know the mathematically correct next instruction to fetch until the branch condition is calculated in the `EX` stage.

By default, the processor **predicts** the branch is not taken and fetches sequentially (`PC + 4`). If the branch evaluates as Taken, the instructions already loaded into the `IF` and `ID` stages are completely incorrect.

We flush these erroneous instructions by clearing the `IF/ID` and `ID/EX` control signals to `0` using a `Flush` pin on the pipeline registers, effectively converting the instructions into No-Ops (`NOP`s). This clearing mechanism is an unavoidable performance penalty inherent to pipelining.

<p align="center">
  <img src="../../../../../Image Bank/ch004-9780128201091/jpg-9780128201091/004060.jpg" width="600" alt="Branch Hazard Pipeline Flush">
</p>

---

## Chapter 4 Problem Walkthroughs (Pipelining)

### Problem 1: Easy (Pipeline Performance Math)
**Question**: A processor has 5 stages with execution times of $250\text{ps}$, $350\text{ps}$, $150\text{ps}$, $400\text{ps}$, and $200\text{ps}$. What is the clock period for a Single-Cycle implementation versus a Pipelined implementation?

**Walkthrough**:
1.  **Single-Cycle**: The clock must accommodate the sum of all serial operations. 
    Time = $250 + 350 + 150 + 400 + 200 = 1350\text{ps}$.
2.  **Pipelined**: The clock is restricted identically by the single slowest, indivisible hardware stage.
    Slowest stage = $400\text{ps}$ (Memory Access). The Pipelined clock period must be **$400\text{ps}$**.

### Problem 2: Medium (Data Forwarding Trace)
**Question**: Given the following MIPS code, manually detect the Read-After-Write (RAW) data hazards and trace the required forwarding endpoints.
```mips
lw  $s2, 20($s1)
sub $s4, $s2, $s3
add $s5, $s4, $s2
```

**Walkthrough**:
1.  **Hazard 1 (`$s2`)**: The `lw` instruction writes into `$s2` at the end of the `WB` stage. The `sub` rapidly reads `$s2` in the `ID` stage. This is a RAW hazard. However, memory retrieval doesn't exist until the `MEM` stage completes. This invokes a mandatory 1-cycle pipeline **stall**. 
2.  **Hazard 2 (`$s4`)**: The `sub` computes `$s4` inside the `EX` stage. The `add` instruction immediately requires `$s4` as an input. The `hazard_unit` detects `$s4` matches, triggering `ForwardA` to bypass the `sub`'s `EX/MEM` pipeline register directly back backwards logically into the `add`'s `EX` ALU.

### Problem 3: Hard (Hardware Logic Evaluation)
**Question**: The `ID/EX` pipeline register must be flushed during a branch taken. Explain how this is evaluated at the hardware layer in SystemVerilog.

**Walkthrough**:
1.  A standard `dff` register updates on `posedge clk`. To flush a pipeline stage dynamically, the unit must have a synchronous `clear` pin wired to the main `hazard_unit`.
2.  The `hazard_unit` monitors the `PcSrcD` flag (computed by the ALU determining a `Branch Taken` equality result).
3.  If `PcSrcD == 1`, the hazard unit outputs a logical high to the `FlushE` signal.
4.  `FlushE` is physically wired to the `reset` pin of the `IF/ID` and `ID/EX` registers. On the next clock pulse, all control signals inside that register collapse down to `0x0`, rendering the instruction a No-Op and saving the processor from executing wrong-path data.

---

## Resources & Materials

*   **Textbook**: *Computer Organization and Design* (6th Ed.) - Chapter 4 (4.6 - 4.9).
*   **Textbook**: *Digital Design and Computer Architecture* - Chapter 7.

[ &larr; back to syllabus](/courses/ece251/2026/ece251-syllabus-spring-2026.html) [ &larr; back to notes](/courses/ece251/2026/ece251-notes.html)
