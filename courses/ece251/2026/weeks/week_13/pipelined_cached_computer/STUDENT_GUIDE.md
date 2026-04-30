# ECE 251: Pipelined MIPS CPU - Student Lab Guide

Welcome to the **5-Stage Pipelined MIPS32 CPU** lab! 

In this module, you will interact with a fully structural SystemVerilog implementation of a pipelined processor. This specific architecture includes a Hazard Unit (handling data forwarding and stalls) and an **Asynchronous Exception/Interrupt System**.

This guide will walk you through writing code, running simulations, and debugging your pipeline cycle-by-cycle.

---

## 1. Prerequisites

Before you begin, ensure you have the following installed on your machine:
*   **Icarus Verilog** (`iverilog` & `vvp`): The SystemVerilog compiler and simulator.
    *   *macOS*: `brew install icarus-verilog`
    *   *Ubuntu/Debian*: `sudo apt-get install iverilog`
*   **Python 3**: Required to run the custom assembler (`assembler.py`).
*   **A Waveform Viewer**: Required to view `.vcd` trace files.
    *   *Cross-Platform*: **VS Code** with the "WaveTrace" or "Waveform Viewer" extension.
    *   *Modern/Fast*: **Surfer** (`brew install surfer` or download from GitLab).
    *   *Legacy*: GTKWave (Not recommended for Apple Silicon macOS).

---

## 2. Writing Assembly for this CPU

The provided `assembler.py` script converts human-readable MIPS assembly (`.asm`) into a hexadecimal machine code executable (`.exe`) that the SystemVerilog RAM can read.

### Supported Instructions
Because this is an educational CPU, it only implements a specific subset of the MIPS ISA:
*   **Arithmetic/Logic (R-Type)**: `add`, `sub`, `and`, `or`, `slt`, `mult`, `mfhi`, `mflo`
*   **Immediate (I-Type)**: `addi`
*   **Memory (I-Type)**: `lw`, `sw`
*   **Control Flow (I/J-Type)**: `beq`, `j`

### The Memory-Mapped Halt (Important!)
Standard simulators like SPIM stop when there are no more instructions. Hardware CPUs do not stop; they run until power is cut. 
To tell our testbench to gracefully halt the simulation and stop generating logs, you **must** write to memory address `252` (`0xFC`) at the very end of your programs:
```assembly
# Place this at the end of every program
sw $zero, 252($zero)
```

### Writing Exception Handlers
If you are testing interrupts, the hardware will abruptly redirect the Program Counter (PC) to the Operating System's Kernel Vector. In this design, that vector is located at `0x180`. 

Use the `.org` directive to tell the assembler to place your handler exactly at that memory location:
```assembly
main:
    # Your normal program loop goes here
    addi $s0, $zero, 1
    # ...

# OS Exception Handler
.org 0x180
handler:
    # Hardware jumps here when the 'intr' pin goes HIGH!
    # Write your recovery or handler logic here.
    addi $k0, $zero, 999 
    j handler
```

---

## 3. Running Simulations

We have provided a `Makefile` to handle assembling the code, compiling the Verilog netlist, and running the simulation in one step.

### Running a Standard Program
To run a program (e.g., `prog1_simple_hazard.asm`), use the `make` command and specify the `ASM` variable (without the `.asm` extension):
```bash
make clean all ASM=prog1_simple_hazard
```

### Running the Exception Testbench
To test asynchronous interrupts, we use a slightly different testbench (`tb_exceptions.sv`) that forcefully triggers the interrupt pin mid-execution. We've made this incredibly easy:
```bash
make test_exceptions
```

---

## 4. Debugging Your Pipeline

Pipelined debugging can be tricky because up to 5 instructions are executing at the exact same time! You have two primary ways to debug your code:

### Method A: The Cycle-by-Cycle Text Log (Recommended for Logic)
Every time you run a standard `make` command, the output is saved to a file called `debug_output.txt`.

Open it in your terminal:
```bash
cat debug_output.txt
```

**🎨 Color Coded Output:**
To make this *so very easy on the eyes*, the output is heavily formatted using ANSI color codes:
*   **YELLOW `>> STALLED <<`**: Indicates a pipeline stall (e.g., waiting for a Load instruction to finish).
*   **RED `>> FLUSHED <<`**: Indicates an instruction was killed due to a bad branch prediction or an interrupt.
*   **GREEN `WRITE`**: Indicates actual data is being saved to Memory or the Register File.

Read the log from top to bottom. For each clock cycle, it shows exactly what is happening in all 5 stages of the CPU:
*   **`[IF]`**: Shows the Program Counter (`PC`). If `StallF` is 1, the PC is frozen.
*   **`[ID]`**: Shows the hex instruction. If `FlushD` is 1, an exception or branch prediction failure just squashed this instruction.
*   **`[EX]`**: Shows the ALU output. If an exception occurred, `EPC` will show the captured PC.
*   **`[MEM]`**: Shows RAM interactions (Memory writes).
*   **`[WB]`**: Shows exactly what value (`ResultW`) is being written back into which Register (`RegDst`).

### Method B: Digital Waveforms (Recommended for Timing & Hardware)
Every simulation generates a `.vcd` (Value Change Dump) file. 
* Standard runs create: `tb_computer.vcd`
* Exception runs create: `tb_exceptions.vcd`

Open the `.vcd` file in your preferred Waveform Viewer (e.g., Surfer or VS Code).
**Key Signals to trace:**
*   `clk` (System Clock)
*   `dut.mips_pipelined.dp.instrD` (Instruction in Decode stage)
*   `dut.mips_pipelined.dp.aluoutE` (Math result in Execute stage)
*   `dut.mips_pipelined.h.stallD` (Is the pipeline stalling due to a Load-Use hazard?)
*   `dut.mips_pipelined.dp.flushE` (Is the pipeline flushing due to a Branch or Interrupt?)

Good luck, and have fun visualizing computer architecture in action!
