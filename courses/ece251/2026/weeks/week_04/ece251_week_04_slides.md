# ECE 251: Computer Architecture
## Week 4: ISA Review & Intro to SystemVerilog

**Rob Marano**
*Spring 2026*

---

# Agenda

1.  **ISA Review**: MIPS Architecture, Assembly, and Emulation
2.  **SystemVerilog**: Introduction to HDL
3.  **Logic Design**: Combinational and Sequential
4.  **Structure**: Modules, Ports, and Code Styles
5.  **Examples**: From Gates to Multipliers

---

# Part 1: ISA Review

---

## The Four Design Principles

1.  **Simplicity favors regularity**
    *   Fixed instruction size (32 bits) simplifies decoding.
2.  **Smaller is faster**
    *   Small register file (32 regs) is faster than large ones.
3.  **Make the common case fast**
    *   Optimize frequently used arithmetic and moves.
4.  **Good design demands good compromises**
    *   Balance versatility with uniformity (e.g., immediate formats).

---

## MIPS Memory Layout

*   **Reserved** (`0x0 - 0x00400000`): OS use.
*   **Text Segment** (`0x00400000`): Program Instructions.
*   **Static Data** (`0x10000000`): Global variables.
*   **Dynamic Data**:
    *   **Heap**: Grows **UP** from static data.
    *   **Stack**: Grows **DOWN** from top (`$sp`).

---

## Load/Store Architecture

*   Operations act **ONLY on registers**.
*   **ALU** cannot access memory directly.
*   **INVALID**: `add $t0, 0($a0), 0($a1)`
*   **VALID**:
    1.  `lw $t1, 0($a0)` (Load)
    2.  `lw $t2, 0($a1)` (Load)
    3.  `add $t0, $t1, $t2` (Compute)
    4.  `sw $t0, 0($a2)` (Store)

---

## Instruction Types

1.  **R-Type (Register)**
    *   `Opcode | rs | rt | rd | shamt | funct`
    *   Arithmetic: `add`, `sub`, `and`, `or`, `slt`
2.  **I-Type (Immediate)**
    *   `Opcode | rs | rt | immediate`
    *   transfers/branches: `lw`, `sw`, `beq`, `addi`
3.  **J-Type (Jump)**
    *   `Opcode | address`
    *   Jumps: `j`, `jal`

---

## Addressing Modes

*   **Branching (`beq`, `bne`)**
    *   **PC-Relative**: Offset from (PC + 4).
    *   Used for local loops and conditions.
*   **Load/Store (`lw`, `sw`)**
    *   **Base Addressing**: `Register + Sign-Extended Immediate`.
    *   Example: `lw $t0, 4($sp)` -> `$t0 = MEM[$sp + 4]`

---

## MIPS Assembly File Format

*   **.data**
    *   Static variables (globals).
*   **.text**
    *   Program Code.
*   **.globl main**
    *   Entry point for the system.

---

## Supervisory CPU Control (Emulation)

The **Emulator (SPIM/MARS)** acts as a lightweight OS:

1.  **Loading**: Reads (`.asm`) -> Memory (Text/Data segments).
2.  **Scheduling**: Sets `PC` to `main`.
3.  **Execution**: Fetch -> Decode -> Execute loop.
4.  **System Calls**: Handles I/O and Exit (`syscall`).

---

## Example: Simple Program

```assembly
.data
   msg: .asciiz "Hello World\n"
.text
.globl main
main:
   li $v0, 4       # syscall: print_str
   la $a0, msg     # arg: address of string
   syscall
   
   li $v0, 10      # syscall: exit
   syscall
```

---

## Procedures

1.  **Leaf Procedure**: Calls no one.
    *   Uses `$a0-$a3` (args), `$v0-$v1` (return).
    *   Returns with `jr $ra`.
2.  **Nested Procedure**: Calls others.
    *   **MUST** save `$ra` to **Stack** (`$sp`).
3.  **Recursive Procedure**: Calls itself.
    *   Must save `$ra` and locals.
    *   Needs a **Base Case**.

---

## MIPS Emulator (`spim`)

*   **Load**: Read the `.asm` file.
*   **Run**: Execute normally.
*   **Step**: One instruction at a time (Debug).
*   **View**:
    *   **Registers**: CPU state (`$t0`, `$pc`, `$sp`).
    *   **Memory**: Data/Text segments.

---

## The "Fast Inverse Square Root"

*   **Context**: *Quake III Arena* (1999). 3D Graphics needs $1/\sqrt{x}$ for vector normalization.
*   **Hack**: Uses a "Magic Number" `0x5f3759df`.
*   **Method**:
    1.  Treat float bits as integer.
    2.  `i = 0x5f3759df - (i >> 1)` (Approx Initial Guess).
    3.  Treat integer bits back as float.
    4.  One iteration of **Newton-Raphson** for precision.

---

## MIPS Implementation of "Fast InvSqrt"

```assembly
Q_rsqrt:
   # Bit hacking: Move float bits to integer reg
   mfc1  $t0, $f12       # Float -> Int (Raw copy)

   # Initial approximation
   srl   $t1, $t0, 1     # i >> 1
   lw    $t2, magic      # 0x5f3759df
   sub   $t0, $t2, $t1   # magic - (i >> 1)

   # Move bits back to float reg
   mtc1  $t0, $f0        # Int -> Float (Raw copy)

   # Newton-Raphson Iteration ...
   jr    $ra
```

---

# Part 2: SystemVerilog (SV)

---

## What is SystemVerilog?

*   **HDL (Hardware Description Language)**.
*   Describes **Structure** (Connections) and **Parallel Behavior**.
*   **NOT** C/Python:
    *   C describes *sequential* steps.
    *   SV describes *concurrent* hardware.

---

## Tools & Workflow

1.  **Write**: `.sv` files (Design & Testbench).
2.  **Compile**: `iverilog -g2012 -o sim.vvp design.sv tb.sv`
3.  **Simulate**: `vvp sim.vvp`
4.  **Visualize**: `gtkwave waves.vcd`
5.  **Automate**: `make <target>`

---

## Logic Modeling Styles

1.  **Structural**: Netlist style.
    *   `and u1 (y, a, b);`
    *   Good for low-level details.
2.  **Dataflow**: Equation style.
    *   `assign y = a & b;`
    *   Synthesizable, clean, preferred for combinational logic.
3.  **Behavioral**: Algorithm style.
    *   `always_ff`, `always_comb`
    *   Used for efficient RTL and complex logic.

---

## Logic Elements

*   **Combinational**: Output depends **only** on current input.
    *   Gates, Mux, ALU.
    *   No memory.
*   **Sequential**: Output depends on input **AND state**.
    *   Latches, Flip-Flops, Registers, Memory.
    *   Controlled by **Clock**.

---

## SV Data Types

*   **`logic`**: The golden standard.
    *   Catches multi-driver errors.
    *   Used for almost everything (except tri-state).
*   **`wire`**: For multi-driver nets (busses).
*   **`bit`**: 2-state (0/1), distinct from 4-state logic (0/1/X/Z).

---

## Structure: Modules

```systemverilog
module my_module (
    input  logic        clk,
    input  logic [3:0]  data,
    output logic [3:0]  result
);
    // Declarative
    logic [3:0] inverse;

    // Generative / Dataflow
    assign inverse = ~data;

    // Behavioral
    always_ff @(posedge clk) begin
        result <= inverse;
    end
endmodule
```

---

# Part 3: Examples Walkthrough

---

## 1. Logic Gates

*   **Structural**: `and u1 (y, a, b);`
*   **Dataflow**: `assign y = a & b;`
*   **Demo**: `make gates`

## 2. Multiplexors (Mux)
*   **2:1 Mux**: Ternary Operator
    *   `assign y = sel ? d1 : d0;`
*   **4:1 Mux**: Case Statement
    *   `case(sel) ... endcase`
*   **Demo**: `make mux2`, `make mux4`

---

## 3. Clocks & Dividers

*   **Clock Gen**: `forever #5 clk = ~clk;` (Simulation only)
*   **Clock Divider**: Use a Counter.
    *   MSB of counter toggles much slower than input clock.
    *   Used for LED blinking, Baud rates.
*   **PWM**: Pulse Width Modulation.
    *   Compare `counter < threshold`.
*   **Demo**: `make clock_gen`, `make divider`, `make pwm_hw`

---

## 4. Bit Manipulation

*   **Concatenation**: `{a, b}` combines bits.
*   **Replication**: `{4{a}}` repeats bits.
*   **Swizzling**: `{a[0], a[1]}` reorders bits.
*   **Demo**: `make swizzle`

---

## 5. Latches vs Flip-Flops

*   **D-Latch**: Level Sensitive.
    *   Passes data while En=1.
    *   *Implicitly inferred if `if` logic is incomplete in comb blocks.*
*   **D-Flip-Flop**: Edge Triggered.
    *   Captures data on `posedge clk`.
    *   The standard building block of synchronous logic.
*   **Demo**: `make flipflops`

---

## 6. Registers

*   Group of Flip-Flops.
*   **Structural**: 4 instantiations of DFF.
*   **Generative**: `generate for (i=0...)` loop.
*   **Behavioral**: `reg [31:0] mem [0:31]` (Inferred RAM/RegFile).
*   **Demo**: `make registers`

---

## 7. Arithmetic Circuits

*   **Half Adder**: XOR (Sum) + AND (Carry).
*   **Full Adder**: 2 Half Adders + OR.
*   **Ripple Carry Adder**: Chain of Full Adders.
    *   $C_{out}$ of bit $i$ -> $C_{in}$ of bit $i+1$.
*   **Multiplier**:
    *   **Structural**: AND gates (products) + Adders (sum).
    *   **Dataflow**: `assign p = a * b;`
*   **Demo**: `make adder`, `make multiplier_n`

---

# Testbenches

The most important part of design is **Verification**.

*   **`$display`**: Print to console.
*   **`$monitor`**: Auto-print on change.
*   **`$random`**: Generate test vectors.
*   **Assertions**: `if (y !== expected) $stop;`

**Verify EVERYTHING before you build!**

---

# Questions?

*   Review the `Makefile` targets.
*   Run the simulations.
*   Inspect the waveforms in GTKWave.
