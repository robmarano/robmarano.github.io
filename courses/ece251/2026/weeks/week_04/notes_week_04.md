# Notes for Week 4
[ &larr; back to syllabus](/courses/ece251/2026/ece251-syllabus-spring-2026.html) [ &larr; back to notes](/courses/ece251/2026/ece251-notes.html)

# Topics
1. ISA Review
    * The four design principles
    * MIPS memory system layout (RAM)
    * MIPS as a load/store architecture
    * The three types of instructions
    * MIPS ISA
        * operations, conditionals, loops
        * memory use for branching and data load/store
    * MIPS assembly
        * Program File Format
        * Supervisory CPU Control
        * Simple Program
        * Reusable Code - Leaf Procedure
        * Nested Procedures
        * Recursive Procedures
    * MIPS Emulator (`spim`)
2. SystemVerilog as our Hardware Definition Language (HDL)
    * Introducing SystemVerilog (`SV`) (Command Line, `iverilog`, Makefiles)
    * Intro to Logic Design using SystemVerilog (Gates, Muxes, etc.)
    * Logic Elements (Combinational and Sequential Logic)
    * SystemVerilog 
        * Expressions, Data Types, and Patterns
        * Modules, Ports
        * Declarative vs Generative Code
    * Examples
        * Gates, Multiplexors
        * Clocks, Dividers
        * Busses, Bit Manipulation
        * Latches, Flip-Flops
        * Registers, Memory

# Topic Deep Dive

## 1. ISA Review

### A. The Four Design Principles
1.  **Simplicity favors regularity**: Keeping instructions a fixed size (e.g., 32 bits) simplifies hardware decoding.
2.  **Smaller is faster**: A smaller register file (e.g., 32 registers) is faster to access than a large one along with the instruction set.
3.  **Make the common case fast**: Optimize the most frequently used instructions (like arithmetic and data movement) for speed.
4.  **Good design demands good compromises**: Balancing versatility (like allowing immediate constants) with uniformity (keeping instruction formats consistent).

### B. MIPS Memory System Layout (RAM)
*   **0x00000000 - 0x00400000**: **Reserved** (Operating System use).
*   **0x00400000**: **Text Segment** (Program Instructions start here).
*   **0x10000000**: **Static Data Segment** (Global variables).
*   **Dynamic Data**: **Heap** grows upwards from static data; **Stack** grows downwards from the top of user space (`$sp` initialized to high address).

### C. MIPS as a Load/Store Architecture
*   Operations acts **only on registers**. MIPS is a **Load/Store** architecture.
*   You cannot add a number directly from memory to another number in memory (e.g., `add $t0, 0($a0), 0($a1)` is INVALID).
*   Data must first be **Loaded** (`lw`) from memory into a register, operated on, and then the result **Stored** (`sw`) back to memory.

### D. The Three Types of Instructions
1.  **R-Type (Register)**: Arithmetic and logical operations (e.g., `add`, `sub`, `and`, `or`, `slt`).
    *   `Opcode | rs | rt | rd | shamt | funct`
2.  **I-Type (Immediate)**: Data transfer, conditional branches, immediate operations (e.g., `lw`, `sw`, `beq`, `addi`).
    *   `Opcode | rs | rt | immediate`
3.  **J-Type (Jump)**: Unconditional jumps (e.g., `j`, `jal`).
    *   `Opcode | address`

### E. MIPS ISA: Operations, Conditionals, Loops
*   **Operations**: `add`, `sub`, `addi` (add immediate), `sll` (shift left logical).
*   **Conditionals**: `beq` (branch if equal), `bne` (branch if not equal). Used for `if-else` structures.
*   **Loops**: Constructed using combinations of `beq`/`bne` and `j` (jump).

### F. MIPS ISA: Memory Use for Branching and Data Load/Store
*   **Branching (`beq`, `bne`)**: Uses **PC-Relative Addressing**. The immediate field is a signed offset (in words) relative to the *next* instruction (PC+4).
*   **Data Load/Store (`lw`, `sw`)**: Uses **Base Addressing**. The effective address is `Register Value + Sign-Extended Immediate` (e.g., `lw $t0, 4($sp)` reads from `$sp + 4`).

### G. MIPS Assembly: File Format
*   **.data**: Declaration of static data (variables).
*   **.text**: Program instructions.
*   **.globl main**: Declares the `main` label as global so the system can invoke it.

### H. Supervisory CPU Control (Emulation)
A physical CPU typically runs an Operating System (OS) to manage programs. In our course, we use a MIPS emulator (like SPIM or MARS) which acts as a supervisor or a lightweight OS. Its responsibilities include:
1.  **Loading**: Reading the assembly file from disk and placing instructions into the **Text Segment** and variables into the **Data Segment** of the simulated memory.
2.  **Scheduling**: Setting the Program Counter (`PC`) to the starting address of `main`.
3.  **Execution**: Fetching, decoding, and executing instructions one by one.
4.  **Memory Management**: Handling `lw` and `sw` requests to read/write data from the simulated RAM.
5.  **System Calls**: Intercepting `syscall` instructions to perform IO (like printing to the console) or cleanly **Exit** the program.
6.  **Context Switching**: In a real OS (conceptually similar here), the supervisor would handle saving the state of one program and loading the next from memory.

### I. MIPS Assembly: Simple Program

[Download hello_world.asm](hello_world.asm)

```assembly
.data
   msg: .asciiz "Hello World\n"
.text
.globl main
main:
   li $v0, 4       # System call code for print_str
   la $a0, msg     # Load address of string
   syscall
   
   li $v0, 10      # System call code for exit
   syscall
```

### J. MIPS Assembly: Reusable Code - Leaf Procedure
A leaf procedure does not call other procedures.
*   Arguments are passed in `$a0-$a3`.
*   Return values are placed in `$v0-$v1`.
*   Return address is in `$ra`.
*   Uses `jr $ra` to return.

[Download leaf_proc.asm](leaf_proc.asm)

```assembly
# add_em: A leaf procedure
# Input: $a0, $a1
# Output: $v0 = $a0 + $a1
add_em:
    add $v0, $a0, $a1       # Calculate sum
    jr $ra                  # Return to caller
```

### K. MIPS Assembly: Nested Procedures
A procedure that calls another procedure.
*   **Must convert** `$ra` (and typically `$a0-$a3`, `$s0-$s7`) onto the **Stack** (`$sp`) before the nested call to preserve values.
*   **Restore** them from the stack after the nested call returns.

[Download nested_proc.asm](nested_proc.asm)

```assembly
# nested_proc: Calls another procedure 'add_em'
nested_proc:
    # 1. Save Return Address ($ra) to Stack
    addi $sp, $sp, -4       # Allocate 4 bytes on stack
    sw   $ra, 0($sp)        # Store contents of $ra at $sp+0

    # 2. Call Another Procedure
    jal  add_em             # Jump and Link (Overwrites $ra!)

    # 3. Do work with result ($v0)
    addi $v0, $v0, 1        # Result = Sum + 1

    # 4. Restore Return Address
    lw   $ra, 0($sp)        # Load original $ra from stack
    addi $sp, $sp, 4        # Deallocate stack space

    # 5. Return
    jr   $ra                # Return to caller
```

### L. MIPS Assembly: Recursive Procedures
A special case of nested procedures where a function calls itself.
*   Requires strict management of the stack to save the return address (`$ra`) and local variables for each recursive step.
*   Must have a **Base Case** to terminate recursion.

[Download recursive_proc.asm](recursive_proc.asm)

```assembly
# n_factorial: MIPS Recursive Factorial
fact:
    # 1. Base Case: if (a0 < 2) return 1
    slti $t0, $a0, 2        # Set $t0=1 if $a0 < 2
    bne  $t0, $zero, L1     # If $t0!=0 (n<2), jump to L1

    # 2. Recursive Case
    addi $sp, $sp, -8       # Make room for $ra and $a0
    sw   $ra, 4($sp)        # Save return address
    sw   $a0, 0($sp)        # Save current n ($a0)

    addi $a0, $a0, -1       # n = n - 1
    jal  fact               # recursive call: fact(n-1)

    lw   $a0, 0($sp)        # Restore original n
    lw   $ra, 4($sp)        # Restore return address (to caller)
    addi $sp, $sp, 8        # POP stack

    mul  $v0, $a0, $v0      # result = n * fact(n-1)
    jr   $ra                # Return

L1: # Base Case
    li   $v0, 1             # Return 1
    jr   $ra
```

### M. MIPS Emulator (`spim`)
Since we don't have physical MIPS hardware, we use a simulator called `spim`. It allows us to load, execute, and debug MIPS assembly programs.

1.  **Starting SPIM**:
    *   Open your terminal and type `spim` (or `qtspim` for the graphical version).
    *   You will see a console prompt or a graphical window showing registers and memory segments.

2.  **Loading a Program**:
    *   In the console: `(spim) load "filename.asm"`
    *   In QtSpim: File -> Load File.

3.  **Running and Stepping**:
    *   **Run**: Executes the entire program. `(spim) run`
    *   **Step**: Executes one instruction at a time. This is crucial for debugging. `(spim) step`
    *   Observe how the Program Counter (`PC`) updates after each step.

4.  **Viewing Registers**:
    *   The register file is displayed (e.g., `$t0`, `$a0`, `$sp`, `$ra`).
    *   Watch these values change as you step through arithmetic or load operations.
    *   In console `spim`, use `print $t0` to see specific values.

5.  **Viewing Memory**:
    *   **Text Segment**: Shows your machine code instructions at addresses starting `0x00400000`.
    *   **Data Segment**: Shows your static variables at `0x10000000`.
    *   **Stack**: View the stack growing downwards from `0x7FFFFFFF`. useful for debugging nested/recursive calls.

### N. Fast Inverse Square Root (Quake III Arena)
The "Fast Inverse Square Root" is a famous algorithm used in the source code of *Quake III Arena* (1999) to compute \( \frac{1}{\sqrt{x}} \). This calculation is critical for normalizing vectors in 3D graphics (lighting and reflection) and needed to be extremely fast.

At the time, computing a square root and then a division was computationally expensive. This code uses a "magic number" (`0x5f3759df`) and bit manipulation to gain a massive speedup over standard floating-point operations.

**The "Magic" Number:**
The hexadecimal constant `0x5f3759df` is not random. It is a carefully calculated constant that exploits the IEEE 754 floating-point representation. By interpreting the bits of a float as an integer, shifting right by 1 (equivalent to multiply by 0.5 in log domain), and subtracting from this constant, the algorithm computes an incredibly accurate initial guess for \( \frac{1}{\sqrt{x}} \) (which is \( x^{-0.5} \)). It essentially linearizes the log curve to approximate the inverse square root directly from the bit pattern.

**Original C Code (with comments):**
```c
float Q_rsqrt( float number )
{
    long i;
    float x2, y;
    const float threehalfs = 1.5F;

    x2 = number * 0.5F;
    y  = number;
    i  = * ( long * ) &y;                       // evil floating point bit level hacking
    i  = 0x5f3759df - ( i >> 1 );               // Initial approximation using magic number and bit shift
    y  = * ( float * ) &i;
    y  = y * ( threehalfs - ( x2 * y * y ) );   // 1st iteration (Newton-Raphson method)
//  y  = y * ( threehalfs - ( x2 * y * y ) );   // 2nd iteration (Newton-Raphson method), this can be removed

    return y;
}
```
*Note: This utilizes the specific way floating point numbers are stored in memory (IEEE 754).*

**MIPS32 Assembly Implementation:**
```assembly
# Fast Inverse Square Root (1/sqrt(x)) in MIPS
# Input: $f12 (float number)
# Output: $f0 (result)
.data
   magic:      .word 0x5f3759df
   threehalfs: .float 1.5
   half:       .float 0.5
   
.text
Q_rsqrt:
   # 1. x2 = number * 0.5
   l.s   $f4, half          # Load 0.5
   mul.s $f2, $f12, $f4     # $f2 (x2) = number * 0.5

   # 2. i = * ( long * ) &y; (Bit hacking: Move float bits to integer reg)
   mfc1  $t0, $f12          # Move float bits from FPU ($f12) to CPU ($t0) - "y"
                            # This is NOT a conversion. It copies the raw bits.

   # 3. i = 0x5f3759df - ( i >> 1 );
   srl   $t1, $t0, 1        # i >> 1
   lw    $t2, magic         # Load magic number
   sub   $t0, $t2, $t1      # i = magic - (i >> 1)

   # 4. y = * ( float * ) &i; (Move bits back to float reg)
   mtc1  $t0, $f0           # Move integer bits ($t0) back to FPU ($f0) - "y"

   # 5. y = y * ( threehalfs - ( x2 * y * y ) ); (Newton-Raphson method)
   l.s   $f6, threehalfs    # Load 1.5
   mul.s $f8, $f0, $f0      # y * y
   mul.s $f8, $f2, $f8      # x2 * (y * y)
   sub.s $f8, $f6, $f8      # threehalfs - (x2 * y * y)
   mul.s $f0, $f0, $f8      # Final result: y * (...)
   
   jr    $ra                # Return (result in $f0)
```

---

## 2. Introducing SystemVerilog: Command Line, `iverilog`, and Makefiles

SystemVerilog is a hardware description language (HDL) used to model, design, and verify electronic systems. Unlike software programming languages (C, Python), HDLs describe *hardware structures* and *parallel execution*.

### Tools
We will use open-source tools for this course:
*   **Icarus Verilog (`iverilog`)**: A compiler that translates Verilog source code into a simulation executable.
*   **vvp**: The runtime engine that executes the simulation generated by `iverilog`.
*   **GTKWave**: A waveform viewer to visualize the simulation results.
*   **Makefiles**: To automate the build and simulation process.

### Basic Workflow
1.  **Write Code**: Create `.sv` (SystemVerilog) files for design and testbench.
2.  **Compile**: Use `iverilog` to compile sources into a `.vvp` executable.
    ```bash
    iverilog -g2012 -o simulation.vvp design.sv testbench.sv
    ```
    *   `-g2012`: Enables SystemVerilog 2012 standard features.
    *   `-o simulation.vvp`: Specifies the output filename.
3.  **Simulate**: Run the compiled simulation.
    ```bash
    vvp simulation.vvp
    ```
4.  **View Operations**: If you dumped waveforms, open them in GTKWave.
    ```bash
    gtkwave waveforms.vcd
    ```

### Using Makefiles
Instead of typing commands repeatedly, we use a `Makefile` to define build rules.

```makefile
# Makefile for SystemVerilog compilation and simulation

# Defaults
SIM ?= iverilog
TOP = testbench_module_name
SRC = design.sv testbench.sv
OUT = simulation.vvp

all: build run

build:
	$(SIM) -g2012 -o $(OUT) $(SRC)

run:
	vvp $(OUT)

clean:
	rm -f $(OUT) *.vcd
```

## 2. Intro to Logic Design using SystemVerilog

Logic design involves creating digital circuits using logic gates (AND, OR, NOT) and state-holding elements. SystemVerilog allows us to describe these at different levels of abstraction:
*   **Structural**: Instantiating and connecting primitive gates or other modules (like a netlist).
*   **Dataflow**: Using continuous assignments (`assign`) to describe how data flows through combinational logic.
*   **Behavioral**: Using procedural blocks (`always_comb`, `always_ff`) to describe the algorithm or behavior of the circuit.

## 3. Logic Elements: Combinational vs. Sequential

### Combinational Logic
*   Output depends *only* on the current inputs.
*   No memory of past states.
*   **Examples**: Logic gates (AND, OR), Multiplexors, Adders, Encoders, ALUs.
*   **Modeling**: 
    *   `assign` statements (Continuous Assignment).
    *   `always_comb` blocks (Procedural Combinational Logic).

### Sequential Logic
*   Output depends on current inputs *and* the previous state (memory).
*   Controlled by a clock signal (synchronous) or event (asynchronous).
*   **Examples**: Latches, Flip-Flops, Registers, Counters, Memory.
*   **Modeling**: 
    *   `always_ff` blocks (Flip-Flops).
    *   `always_latch` blocks (Latches - usually avoided unless intentional).

## 4. SystemVerilog Data Types & Expressions

### Variable Declarations
*   `logic`: The most common data type in SystemVerilog. It improves upon Verilog's `reg` and `wire` by catching multi-driver errors.
    *   It can be driven by continuous assignment, gates, or procedural blocks.
    *   It enforces a **single driver** rule (except when connected to a bidirectional `inout` port).
    ```systemverilog
    logic a;         // Single bit signal
    logic [7:0] bus; // 8-bit bus (MSB: 7, LSB: 0)
    logic [31:0] memory [0:1023]; // Array of 1024 32-bit words
    ```
*   `wire`: Used for connecting components, specifically when multiple drivers are needed (e.g., a tri-state bus).
*   `bit`: 2-state data type (0 or 1), useful for testbenches (no X or Z states).

### Bit Patterns & Literals
SystemVerilog literals allow you to specify the *width*, *base*, and *value*.
*   Format: `'<base><value>` or `<width>'<base><value>`
    *   `'b`: Binary
    *   `'d`: Decimal (default)
    *   `'h`: Hexadecimal
*   **Examples**:
    *   `4'b1011`: 4-bit binary value 1011 (decimal 11).
    *   `8'hFF`: 8-bit hex value FF (decimal 255).
    *   `16'd100`: 16-bit decimal value 100.
    *   `'b10`: Automatic width binary 10.
    *   `32'hDEAD_BEEF`: Underscores `_` ignore for readability.

### Expressions & Operators
*   **Bitwise**: `&` (AND), `|` (OR), `^` (XOR), `~` (NOT). Operates bit-by-bit.
*   **Logical**: `&&` (AND), `||` (OR), `!` (NOT). Returns 1 bit (true/false).
*   **Reduction**: `&bus` (AND all bits of bus), `|bus` (OR all bits).
*   **Concatenation**: `{a, b}` combines signals `a` and `b` into a wider bus.
*   **Replication**: `{4{a}}` repeats `a` 4 times (e.g., if a=1, result is 1111).
*   **Conditional (Ternary)**: `sel ? a : b` (If sel is true, result is a, else b).

## 5. SystemVerilog File Format & Structure

### Modules and Ports
The fundamental building block of a hardware design is a `module`. A module has **ports** (inputs/outputs) and internal **declarations** and **logic**.

```systemverilog
module my_module (
    input  logic        clk,
    input  logic        rst,
    input  logic [3:0]  data_in,
    output logic [3:0]  data_out
);
    // --- Declarative Code ---
    // Define internal signals, parameters, and types before using them.
    logic [3:0] internal_signal;
    localparam WIDTH = 4;

    // --- Generative / Operational Code ---
    // Dataflow: Continuous assignments
    assign internal_signal = ~data_in;

    // Behavioral: Procedural blocks
    always_ff @(posedge clk) begin
        if (rst) 
            data_out <= 4'b0;
        else
            data_out <= internal_signal;
    end

endmodule
```

*   **Declarative Code**: Where you define `logic`, `wire`, `parameter`, `localparam`.
*   **Generative Code**: Where behavior is defined. Includes `assign`, `always`, `initial`, and module instantiations.
*   **`generate` Blocks**: Special constructs to conditionally or iteratively create hardware instances (e.g., creating a bank of 100 AND gates using a loop).

# Examples

## 1. Boolean Logic Gates (Structural vs Dataflow)

SystemVerilog offers two primary ways to describe boolean logic: **Structural** (instantiating primitives) and **Dataflow** (using operators).

### A. Structural Modelling
This approach is like drawing a schematic or wiring a breadboard. You instantiate specific gates (primitives) and wire them together. This is mostly used when you need to model specific hardware delays or when generating netlists.

[Download structural_gates.sv](structural_gates.sv)


```systemverilog
module structural_gates (
    input  logic a, b,
    output logic y_and, y_or, y_xor, y_not, y_delayed
);
    // Syntax: <gate_type> <instance_name> (output, input1, input2...);
    // Instance names (u1, u2...) are optional for primitives but good practice.
    
    and u1 (y_and, a, b);  // AND gate
    or  u2 (y_or,  a, b);  // OR gate
    xor u3 (y_xor, a, b);  // XOR gate
    not u4 (y_not, a);     // NOT gate (1 input)

    // Modeling Delays:
    // You can specify propagation delays directly on primitives.
    // 'and #3' means it takes 3 time units for the output to change.
    and #3 u5 (y_delayed, a, b); 
endmodule
```

### B. Dataflow Modelling (Preferred)
For most modern design, we use **Dataflow** modeling. It uses the `assign` statement and operators like `&`, `|`, `^`. It is more concise, easier to read, and allows the synthesizer to optimize the gates for you.

[Download dataflow_gates.sv](dataflow_gates.sv)


```systemverilog
module dataflow_gates (
    input  logic a, b,
    output logic y_and, y_or, y_xor, y_nand, y_slow
);
    // Continuous Assignment
    assign y_and  = a & b;
    assign y_or   = a | b;
    assign y_xor  = a ^ b;
    assign y_nand = ~(a & b);

    // Modeling Delays in Dataflow:
    // While structural is "best" for low-level delay modeling, you can
    // add simulated delays to dataflow assignments for testbenches or distinct timing analysis.
    assign #5 y_slow = a & b; // Wait 5 time units before updating y_slow
endmodule
```

**Testbench (Gates Comparison):**
[Download tb_gates.sv](tb_gates.sv)

```systemverilog
`timescale 1ns/1ps

module tb_gates;
    logic a, b;
    logic y_and_s, y_or_s, y_xor_s, y_not_s, y_del_s;
    logic y_and_d, y_or_d, y_xor_d, y_nand_d, y_slow_d;

    structural_gates u_struct (
        .a(a), .b(b),
        .y_and(y_and_s), .y_or(y_or_s), .y_xor(y_xor_s),
        .y_not(y_not_s), .y_delayed(y_del_s)
    );

    dataflow_gates u_dataflow (
        .a(a), .b(b),
        .y_and(y_and_d), .y_or(y_or_d), .y_xor(y_xor_d),
        .y_nand(y_nand_d), .y_slow(y_slow_d)
    );

    initial begin
        $display("\n===================================================================");
        $display("                 Example 1: Logic Gates Comparison                 ");
        $display("===================================================================");
        $display(" Time | A B | Struct: AND OR XOR NOT | Dataflow: AND OR XOR NAND ");
        $display("------+-----+------------------------+-----------------------------");
        $monitor(" %4t | %b %b |         %b  %b   %b   %b  |           %b  %b   %b    %b",
                 $time, a, b, y_and_s, y_or_s, y_xor_s, y_not_s, y_and_d, y_or_d, y_xor_d, y_nand_d);
        
        a = 0; b = 0;
        #10;
        a = 0; b = 1;
        #10;
        a = 1; b = 0;
        #10;
        a = 1; b = 1;
        #10;
        $display("===================================================================\n");
        $finish;
    end
endmodule
```


**Key Takeaway**: 
*   Use **Dataflow** (`assign`) for writing RTL (Register Transfer Level) code that you intend to synthesize onto an FPGA or ASIC.
*   Use **Structural** when you need precise control over the specific gates used or are modeling the physical properties (like propagation delay) of a specific technology library.

## 2. Multiplexor (2:1 and 4:1)

A mux selects one of several inputs to forward to the output.

[Download mux2.sv](mux2.sv) | [Download mux4.sv](mux4.sv)


```systemverilog
module mux2 (
    input  logic [3:0] d0, d1,
    input  logic       sel,
    output logic [3:0] y
);
    // Ternary operator is perfect for 2:1 mux
    assign y = sel ? d1 : d0; 
endmodule

module mux4 (
    input  logic [3:0] d0, d1, d2, d3,
    input  logic [1:0] sel,
    output logic [3:0] y
);
    always_comb begin
        case (sel)
            2'b00: y = d0;
            2'b01: y = d1;
            2'b10: y = d2;
            2'b11: y = d3;
            default: y = 4'bxxxx; // Handle undefined cases
        endcase
    end
endmodule
```

**Testbench (Muxes):**
[Download tb_mux2.sv](tb_mux2.sv) | [Download tb_mux4.sv](tb_mux4.sv)

```systemverilog
`timescale 1ns/1ps

module tb_mux4;
    logic [3:0] d0, d1, d2, d3;
    logic [1:0] sel;
    logic [3:0] y;

    mux4 uut (
        .d0(d0), .d1(d1), .d2(d2), .d3(d3),
        .sel(sel), .y(y)
    );

    initial begin
        $display("\n=========================================");
        $display("         Example 2: 4:1 Multiplexor      ");
        $display("=========================================");
        d0 = 1; d1 = 2; d2 = 3; d3 = 4;
        sel = 0;
        #10 $display("Sel=%b Inputs=(%d,%d,%d,%d) -> Out=%d (Exp 1)", sel, d0,d1,d2,d3,y);
        sel = 1;
        #10 $display("Sel=%b Inputs=(%d,%d,%d,%d) -> Out=%d (Exp 2)", sel, d0,d1,d2,d3,y);
        sel = 2;
        #10 $display("Sel=%b Inputs=(%d,%d,%d,%d) -> Out=%d (Exp 3)", sel, d0,d1,d2,d3,y);
        sel = 3;
        #10 $display("Sel=%b Inputs=(%d,%d,%d,%d) -> Out=%d (Exp 4)", sel, d0,d1,d2,d3,y);
        $display("=========================================\n");
        $finish;
    end
endmodule
```
*(See Section 7 for the comprehensive `tb_mux2` code)*


## 3. Clock Circuits

Clocks are the heartbeat of digital systems. In SystemVerilog, we often need to generate clocks for simulation and manipulate them for design.

### A. Generating a Clock (Testbench)
In a testbench (which mimics the real world), you need to create the clock signal yourself.

[Download tb_clock_gen.sv](tb_clock_gen.sv)


```systemverilog
module tb_clock_gen;
    logic clk;
    
    // Create a 10ns period clock (100 MHz if timescale is 1ns)
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // Toggle every 5ns
    end
endmodule
```

### B. Clock Divider
FPGA and CPU clocks run very fast (e.g., 50 MHz, 100 MHz). Often, we need slower signals for:
*   **Human Visibility**: Blinking an LED so the eye can see it (requires ~1-10 Hz).
*   **Communication Protocols**: Generating specific baud rates for UART (e.g., 9600 bps).
*   **Debouncing**: Waiting for mechanical switch contacts to settle (requires ~10-20 ms).

A simple way to divide a clock is using a counter. The N-th bit of a counter toggles at a frequency of $F_{clk} / 2^{(N+1)}$.

[Download clock_divider.sv](clock_divider.sv)


```systemverilog
module clock_divider (
    input  logic clk,
    input  logic rst,
    output logic slow_clk
);
    logic [25:0] count; // 26-bit counter covers large ranges

    always_ff @(posedge clk) begin
        if (rst) 
            count <= 0;
        else 
            count <= count + 1;
    end

    // Example with 50MHz input clock:
    // count[0] toggles at 25 MHz
    // count[25] toggles at ~0.74 Hz (visible to eye)
endmodule
```

**Testbench:**
[Download tb_clock_divider.sv](tb_clock_divider.sv)

```systemverilog
`timescale 1ns/1ps

module tb_clock_divider;
    logic clk;
    logic rst;
    logic slow_clk;

    clock_divider uut (
        .clk(clk),
        .rst(rst),
        .slow_clk(slow_clk)
    );

    // Fast Clock Gen
    initial begin
        clk = 0;
        forever #1 clk = ~clk; // 2ns period (500MHz) - fast
    end

    initial begin
        $display("\n=========================================");
        $display("       Example 3B: Clock Divider         ");
        $display("=========================================");
        $display("(Note: Real divider assumes 26 bits. We monitor internal counter[3:0] for demo)");
        
        rst = 1;
        #10 rst = 0;
        
        // Monitor the internal counter lower bits since bit 25 takes too long
        $monitor("Time=%0t Count[3:0]=%b Slow_Clk(Bit25)=%b", $time, uut.count[3:0], slow_clk);
        
        #100;
        $display("... Simulation truncated (would take seconds to toggle bit 25) ...");
        $display("=========================================\n");
        $finish;
    end
endmodule
```


### C. Fine-Tuning Duty Cycle
Standard clocks have a **50% duty cycle** (time HIGH equals time LOW). However, some applications (like servo control, LED brightness, or specific communication protocols) require different duty cycles.

#### 1. In Simulation (Testbench)
You can easily adjust the high and low times in your `initial` block.

[Download tb_pwm_clock.sv](tb_pwm_clock.sv)


```systemverilog
module tb_pwm_clock;
    logic clk_25_percent;
    logic clk_75_percent;

    initial begin
        clk_25_percent = 0;
        forever begin
            #2.5 clk_25_percent = 1; // High for 2.5ns
            #7.5 clk_25_percent = 0; // Low for 7.5ns (Total Period = 10ns)
        end
    end
endmodule
```

#### 2. In Hardware (Synthesizable PWM)
To create a specific duty cycle in hardware, we use a counter and a **comparator**. This is often called **Pulse Width Modulation (PWM)**.

[Download pwm_generator.sv](pwm_generator.sv)


```systemverilog
module pwm_generator (
    input  logic       clk,
    input  logic       rst,
    output logic       pwm_out
);
    logic [7:0] count;         // 8-bit counter (0-255)
    localparam DUTY_CYCLE = 64; // 25% Duty Cycle (64/256)

    // Free-running counter
    always_ff @(posedge clk) begin
        if (rst) count <= 0;
        else     count <= count + 1;
    end

    // Comparator: High when count < threshold
endmodule
```

**Testbench:**
[Download tb_pwm_generator.sv](tb_pwm_generator.sv)

```systemverilog
`timescale 1ns/1ps

module tb_pwm_generator;
    logic clk, rst, pwm_out;

    pwm_generator uut (.*);

    initial begin
        clk = 0;
        forever #1 clk = ~clk;
    end

    initial begin
        $display("\n=========================================");
        $display("      Example 3C.2: PWM (Hardware)       ");
        $display("=========================================");
        $display("Threshold = 64 (25%% of 256)");
        
        rst = 1;
        #2 rst = 0;
        
        // Monitor specific points
        $monitor("Time=%0t Count=%d PWM_Out=%b", $time, uut.count, pwm_out);
        
        #300; // Run past 64
        $display("=========================================\n");
        $finish;
    end
endmodule
```


## 4. Bit Manipulation (Swizzling)

Rearranging bits is free in hardware (just wires!), but requires specific syntax in SV.

[Download tb_bit_manip.sv](tb_bit_manip.sv)


```systemverilog
logic [3:0] a = 4'b1100;
logic [3:0] b = 4'b0011;
logic [7:0] y;
logic [3:0] reversed;

assign y = {a, b};          // Concatenation: 11000011
assign y = {2{a}};          // Replication: 11001100
assign reversed = {a[0], a[1], a[2], a[3]}; // Manual reverse: 0011
```

**Testbench:**
[Download tb_bit_manip.sv](tb_bit_manip.sv)

```systemverilog
module tb_bit_manip;
    logic [3:0] a = 4'b1100;
    logic [3:0] b = 4'b0011;
    logic [7:0] y_concat;
    logic [7:0] y_repl;
    logic [3:0] reversed;

    assign y_concat = {a, b};          // Concatenation: 11000011
    assign y_repl = {2{a}};          // Replication: 11001100
    assign reversed = {a[0], a[1], a[2], a[3]}; // Manual reverse: 0011

    initial begin
        $display("\n=========================================");
        $display("       Example 4: Bit Manipulation       ");
        $display("=========================================");
        #1;
        $display("Inputs: a=%b, b=%b", a, b);
        $display("1. Concatenation {a,b}:    %b (Exp 11000011)", y_concat);
        $display("2. Replication   {2{a}}:   %b (Exp 11001100)", y_repl);
        $display("3. Reversal      {a[i]..}: %b (Exp 0011)", reversed);
        $display("=========================================\n");
        $finish;
    end
endmodule
```


**Testbench:**
[Download tb_bit_manip.sv](tb_bit_manip.sv)

```systemverilog
module tb_bit_manip;
    logic [3:0] a = 4'b1100;
    logic [3:0] b = 4'b0011;
    logic [7:0] y_concat;
    logic [7:0] y_repl;
    logic [3:0] reversed;

    assign y_concat = {a, b};          // Concatenation: 11000011
    assign y_repl = {2{a}};          // Replication: 11001100
    assign reversed = {a[0], a[1], a[2], a[3]}; // Manual reverse: 0011

    initial begin
        $display("\n=========================================");
        $display("       Example 4: Bit Manipulation       ");
        $display("=========================================");
        #1;
        $display("Inputs: a=%b, b=%b", a, b);
        $display("1. Concatenation {a,b}:    %b (Exp 11000011)", y_concat);
        $display("2. Replication   {2{a}}:   %b (Exp 11001100)", y_repl);
        $display("3. Reversal      {a[i]..}: %b (Exp 0011)", reversed);
        $display("=========================================\n");
        $finish;
    end
endmodule
```


## 5. D Flip-Flop and Latch

### D Latch (Level Sensitive - Avoid if possible)
Passes data when clock/enable is HIGH. holds data when LOW.

[Download d_latch.sv](d_latch.sv)

```systemverilog
module d_latch (
    input  logic clk,
    input  logic d,
    output logic q
);
    always_latch begin
        if (clk) q <= d;
    end
endmodule
```

### D Flip-Flop (Edge Triggered - Standard)
Captures data *only* on the rising (or falling) edge of the clock.

[Download d_flip_flop.sv](d_flip_flop.sv)

```systemverilog
module d_flip_flop (
    input  logic clk,
    input  logic rst_n, // Active low reset
    input  logic d,
    output logic q
);
    // Asynchronous Reset
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) 
            q <= 0;
        else 
            q <= d;
    end
endmodule
```

## 6. Register File (Memory): From Structure to Behavior

A **register** is just a collection of flip-flops sharing a common clock. A **register file** is an array of registers.

### A. Structural: Manual Instantiation (The "Hard" Way)
To make a 4-bit register, we could manually instantiate 4 of our `d_flip_flop` modules.

[Download reg4_structural.sv](reg4_structural.sv)


```systemverilog
module reg4_structural (
    input  logic       clk,
    input  logic       rst_n,
    input  logic [3:0] d,
    output logic [3:0] q
);
    // Manually connecting each bit
    d_flip_flop d0 (.clk(clk), .rst_n(rst_n), .d(d[0]), .q(q[0]));
    d_flip_flop d1 (.clk(clk), .rst_n(rst_n), .d(d[1]), .q(q[1]));
    d_flip_flop d2 (.clk(clk), .rst_n(rst_n), .d(d[2]), .q(q[2]));
    d_flip_flop d3 (.clk(clk), .rst_n(rst_n), .d(d[3]), .q(q[3]));
endmodule
```

### B. Structural: Using `generate` (The Scalable Way)
What if we need a 32-bit or 64-bit register? Typing 64 lines is tedious and error-prone. SystemVerilog provides `generate` blocks to automate this. The compiler unrolls the loop for you.

**Why `generate` is useful**: It allows you to write parameterized code. Change one number (`WIDTH`), and the hardware scales automatically.

[Download reg_n.sv](reg_n.sv)


```systemverilog
module reg_n #(parameter WIDTH = 8) (
    input  logic             clk,
    input  logic             rst_n,
    input  logic [WIDTH-1:0] d,
    output logic [WIDTH-1:0] q
);
    genvar i; // Special variable for generate loops
    generate
        for (i = 0; i < WIDTH; i++) begin : gen_dff
            // Each instance needs a unique name, the loop handles this
            d_flip_flop d_inst (
                .clk(clk), 
                .rst_n(rst_n), 
                .d(d[i]), 
                .q(q[i])
            );
        end
    endgenerate
endmodule
```

### C. Behavioral: Inference (The Efficient Way)
While structural instantiations are educational, in practice we describe the *behavior* of memory and let the synthesis tool figure out the flip-flops or RAM blocks.

Here is a full 32x32 Register File (like in MIPS), typically having 2 read ports and 1 write port.

[Download register_file.sv](register_file.sv)


```systemverilog
module register_file (
    input  logic        clk,
    input  logic        we3,       // Write enable for port 3
    input  logic [4:0]  ra1, ra2,  // Read addresses (5 bits for 32 regs)
    input  logic [4:0]  wa3,       // Write address
    input  logic [31:0] wd3,       // Write data
    output logic [31:0] rd1, rd2   // Read data outputs
);
    // Shorthand: Defining an array of logic vectors
    // logic [width] name [depth];
    logic [31:0] rf[31:0]; 

    // Write Logic (Synchronous)
    always_ff @(posedge clk) begin
        if (we3) rf[wa3] <= wd3;
    end

    // Read Logic (Combinational / Asynchronous)
    // MIPS R0 is always hardwired to 0
    assign rd1 = (ra1 != 0) ? rf[ra1] : 0;
endmodule
```

**Testbench:**
[Download tb_registers.sv](tb_registers.sv)

```systemverilog
`timescale 1ns/1ps

module tb_registers;
    logic clk, rst_n;
    
    // Reg 4
    logic [3:0] r4_d, r4_q;
    reg4_structural u_reg4 (.*, .d(r4_d), .q(r4_q));

    // Reg 8 (Generative)
    logic [7:0] r8_d, r8_q;
    reg_n #(8) u_reg8 (.*, .d(r8_d), .q(r8_q));

    // Register File
    logic        we3;
    logic [4:0]  ra1, ra2, wa3;
    logic [31:0] wd3, rd1, rd2;
    register_file u_rf (.*);

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        $display("\n=========================================");
        $display("      Example 6: Register Types          ");
        $display("=========================================");
        
        rst_n = 0; we3 = 0; r4_d = 0; r8_d = 0;
        #10 rst_n = 1;

        $display("1. Testing Structural 4-bit Register...");
        r4_d = 4'hA;
        @(posedge clk); #1;
        $display("   In=%h Out=%h (Exp A)", r4_d, r4_q);

        $display("2. Testing Generative 8-bit Register...");
        r8_d = 8'hEF;
        @(posedge clk); #1;
        $display("   In=%h Out=%h (Exp EF)", r8_d, r8_q);

        $display("3. Testing Register File...");
        // Write
        @(negedge clk);
        wa3 = 5; wd3 = 32'hDEADBEEF; we3 = 1;
        @(posedge clk); #1; we3 = 0;
        $display("   Wrote DEADBEEF to Reg 5");

        // Read
        ra1 = 5;
        #1;
        $display("   Read Reg 5: %h (Exp DEADBEEF)", rd1);

        $display("=========================================\n");
        $finish;
    end
endmodule
```


## 7. Testbenches and Verification

A **Testbench** is a SystemVerilog module used to verify the correctness of a design (the **Device Under Test** or **DUT**). Unlike design modules, a testbench:
1.  Has **no inputs or outputs** (it is a closed system).
2.  Instantiates the DUT.
3.  Generates inputs (clocks, resets, test vectors).
4.  Monitors outputs (using waveforms or print statements).

### Common System Tasks

SystemVerilog provides special commands (starting with `$`) to control the simulation, print information, and interact with files.

| Task | Description | Usage Example |
| :--- | :--- | :--- |
| **`$display`** | Prints a formatted message to the console *immediately* (like C's `printf`). | `$display("Time: %0t, y=%h", $time, y);` |
| **`$write`** | Same as `$display` but without a newline at the end. | `$write("Loading...");` |
| **`$monitor`** | Prints a message *automatically* whenever any signal in its argument list changes. Only one `$monitor` can be active at a time. | `$monitor("t=%0t s=%b y=%h", $time, sel, y);` |
| **`$strobe`** | Similar to `$display`, but executes at the very *end* of the current time step (after all assignments). Useful for avoiding race condition printouts. | `$strobe("Stable value: %h", bus);` |
| **`$time`** | Returns the current simulation time as a 64-bit integer. | `if ($time > 1000) $finish;` |
| **`$finish`** | Terminates the simulation immediately and exits. | `$finish;` |
| **`$stop`** | Pauses the simulation (enters interactive mode). Useful for debugging failures. | `if (err) $stop;` |
| **`$random`** | Returns a random 32-bit signed integer. Great for generating random test vectors. | `const_val = $random;` |
| **`$readmemh`** | Loads logical memory arrays from a hexadecimal file (crucial for loading RAM/ROM). | `$readmemh("firmware.hex", memory_array);` |
| **`$readmemb`** | Loads logical memory arrays from a binary file. | `$readmemb("data.bin", rom);` |
| **`$dumpfile`** | Specifies the VCD (Value Change Dump) file for waveform viewing. | `$dumpfile("waves.vcd");` |
| **`$dumpvars`** | Specifies which variables to record in the waveforms. | `$dumpvars(0, tb_top);` |

### Example: Comprehensive Testbench

This testbench verifies the `mux2` module using several of the concepts above.

[Download tb_mux2.sv](tb_mux2.sv)


```systemverilog
`timescale 1ns/1ps // Unit (1ns) / Precision (1ps)

module tb_mux2;
    // 1. Signals (No inputs/outputs in TB)
    logic [3:0] d0, d1;
    logic       sel;
    logic [3:0] y;

    // 2. Instantiate DUT
    mux2 uut (
        .d0(d0), .d1(d1), .sel(sel), .y(y)
    );

    // Helper signal for self-checking
    logic [3:0] expected;
    assign expected = sel ? d1 : d0;

    // 3. Test Stimulus
    initial begin
        // --- A. Waveform Setup ---
        // $dumpfile creates the VCD file for visualization in GTKWave.
        // $dumpvars(0, ...) records all signals in the specified module hierarchy.
        $dumpfile("mux_simulation.vcd");
        $dumpvars(0, tb_mux2); 

        // --- B. Console Logging ---
        // $display works like printf to format headers for our output table.
        // $monitor is a background process that auto-prints whenever a signal changes.
        $display("-----------------------------------------");
        $display(" Time | Sel | D0   | D1   | Output (Y) ");
        $display("-----------------------------------------");
        $monitor(" %4t |  %b  | %h | %h | %h", $time, sel, d0, d1, y);

        // Initialize inputs to avoiding 'x' (undefined) states at start
        sel = 0; d0 = 4'hA; d1 = 4'h5;

        // --- C. Directed Testing (Specific Cases) ---
        // We manually specify inputs and delays to test known scenarios.
        #10 sel = 1;     // Case 1: Select D1 (Expect 5)
        #10 d1  = 4'hC;  // Case 2: Change D1 (Expect C)
        #10 sel = 0;     // Case 3: Select D0 (Expect A)
        #10 d0  = 4'h3;  // Case 4: Change D0 (Expect 3)

        // --- D. Randomized Testing ---
        // We use a loop and $random to generate unpredictable inputs.
        // This helps find edge cases we might forget to test manually.
        repeat (5) begin
            #10; // Wait 10 time units between tests
            sel = $random;  // Generate random 32-bit int, taking only LSB (1-bit)
            d0  = $random;  // Take lower 4-bits
            d1  = $random;  // Take lower 4-bits
            
            // --- E. Self-Checking Logic (Assertions) ---
            // Instead of just looking at waves, we make the testbench verify itself.
            // We use a small delay (#1) or $strobe to check values *after* they settle.
            #1 $strobe("   -> Check: Expected %h, Got %h", expected, y);
            
            // Golden Model Comparison
            if (y !== expected) begin
                $display("ERROR at time %0t: Mismatch!", $time);
                $stop; // Pause simulation immediately to debug the error
            end
        end

        // --- F. Simulation Termination ---
        $display("-----------------------------------------");
        $display("Simulation Complete. No Errors.");
        $finish; // Exits the simulation (closes the vvp runner)
    end
endmodule
```

## 8. Adders: Building Up Complexity

Adders are the core of the Arithmetic Logic Unit (ALU). We can build them step-by-step using structural SystemVerilog.

### A. Half Adder (Structural)
A half adder adds two single bits (`a` and `b`) and produces a `sum` and a `carry` out.
*   **Sum** = A XOR B
*   **Carry** = A AND B

[Download half_adder.sv](half_adder.sv)

```systemverilog
module half_adder (
    input  logic a, b,
    output logic sum, cout
);
    xor u1 (sum, a, b);
endmodule
```

**Testbench:**
[Download tb_half_adder.sv](tb_half_adder.sv)

```systemverilog
`timescale 1ns/1ps

module tb_half_adder;
    logic a, b;
    logic sum, cout;
    
    // Expected values for checking
    logic exp_sum, exp_cout;
    assign exp_sum = a ^ b;
    assign exp_cout = a & b;

    half_adder uut (.*);

    initial begin
        $display("\n=========================================");
        $display("          Example 8A: Half Adder         ");
        $display("=========================================");
        $display(" Time | A B | Sum Cout | Expected");
        $display("------+-----+----------+---------");
        $monitor(" %4t | %b %b |  %b    %b  | Sum=%b Cout=%b", $time, a, b, sum, cout, exp_sum, exp_cout);

        a=0; b=0; #10;
        a=0; b=1; #10;
        a=1; b=0; #10;
        a=1; b=1; #10;

        $display("=========================================\n");
        $finish;
    end
endmodule
```


### B. Full Adder (Structural)
A full adder adds three bits (`a`, `b`, and `cin`) and produces a `sum` and `cout`. It can be built from two half adders and an OR gate.

[Download full_adder.sv](full_adder.sv)

```systemverilog
module full_adder (
    input  logic a, b, cin,
    output logic sum, cout
);
    logic s1, c1, c2;

    // First Half Adder
    half_adder ha1 (.a(a), .b(b), .sum(s1), .cout(c1));

    // Second Half Adder
    half_adder ha2 (.a(s1), .b(cin), .sum(sum), .cout(c2));

    // Carry Logic
    or u3 (cout, c1, c2);
endmodule
```

**Testbench:**
[Download tb_full_adder.sv](tb_full_adder.sv)

```systemverilog
`timescale 1ns/1ps

module tb_full_adder;
    logic a, b, cin;
    logic sum, cout;

    full_adder uut (.*);

    initial begin
        $display("\n=========================================");
        $display("          Example 8B: Full Adder         ");
        $display("=========================================");
        $display(" Time | A B Cin | Sum Cout | Expected Sum/Cout");
        $display("------+---------+----------+------------------");
        
        // Exhaustive test for 3 bits (8 cases)
        for (int i=0; i<8; i++) begin
            {a, b, cin} = i[2:0];
            #10;
            $display(" %4t | %b %b  %b  |  %b    %b  | Sum=%b Cout=%b", 
                     $time, a, b, cin, sum, cout, (a^b^cin), ((a&b)|(cin&(a^b))) );
        end

        $display("=========================================\n");
        $finish;
    end
endmodule
```


### C. N-Bit Ripple Carry Adder (Parameterized)
To add multi-bit numbers, we chain full adders together. The carry-out of bit `i` becomes the carry-in of bit `i+1`. We can use `generate` blocks to make this scalable.

[Download n_bit_adder.sv](n_bit_adder.sv)

```systemverilog
module n_bit_adder #(parameter N = 4) (
    input  logic [N-1:0] a, b,
    input  logic         cin,
    output logic [N-1:0] sum,
    output logic         cout
);
    logic [N:0] c; // Internal carry chain

    assign c[0] = cin;
    assign cout = c[N]; // Final carry out

    genvar i;
    generate
        for (i = 0; i < N; i++) begin : gen_adder
            full_adder fa_inst (
                .a(a[i]), 
                .b(b[i]), 
                .cin(c[i]), 
                .sum(sum[i]), 
                .cout(c[i+1])
            );
        end
    endgenerate
endmodule
```

**Testbench:**
[Download tb_n_bit_adder.sv](tb_n_bit_adder.sv)

```systemverilog
`timescale 1ns/1ps

module tb_n_bit_adder;
    parameter WIDTH = 4;
    logic [WIDTH-1:0] a, b;
    logic             cin;
    logic [WIDTH-1:0] sum;
    logic             cout;

    // Instantiate 4-bit adder
    n_bit_adder #(.N(WIDTH)) uut (.*);

    initial begin
        $dumpfile("adder.vcd");
        $dumpvars(0, tb_n_bit_adder);

        $display("\n=========================================");
        $display("  Example 8C: %0d-Bit Ripple Carry Adder ", WIDTH);
        $display("=========================================");
        
        // 1. Simple Test
        cin = 0; a = 2; b = 3;
        #10;
        $display(" %d + %d (cin=%b) = %d (cout=%b) | Exp: 5", a, b, cin, sum, cout);

        // 2. Test Carry Out
        cin = 0; a = 4'hF; b = 1;
        #10;
        $display(" %h + %h (cin=%b) = %h (cout=%b) | Exp: 0, Cout=1", a, b, cin, sum, cout);

        // 3. Test Carry In propagation
        cin = 1; a = 10; b = 10; // 10+10+1 = 21 (0x15). 4-bit -> 5 with carry
        #10;
        $display(" %d + %d (cin=%b) = %d (cout=%b) | Exp: 5, Cout=1", a, b, cin, sum, cout);

        // 4. Random Testing
        repeat(5) begin
             a = $random;
             b = $random;
             cin = $random;
             #10;
             if ({cout, sum} !== (a + b + cin)) begin
                 $display("ERROR: %d + %d + %b = %d (Actual %d)!", a, b, cin, (a+b+cin), {cout, sum});
             end else begin
                 $display(" OK: %d + %d + %b = %d", a, b, cin, {cout, sum});
             end
        end

        $display("=========================================\n");
        $finish;
    end
endmodule
```


### D. Structural 2-Bit Multiplier
For small multipliers, we can build them structurally using AND gates to generate partial products and Adders to sum them up.
*   **Partial Products**: `AND` gates (e.g., `p00 = a[0] & b[0]`).
*   **Summation**: Half Adders shift and add the rows.

[Download multiplier_structural.sv](multiplier_structural.sv)

```systemverilog
module multiplier2x2 (
    input  logic [1:0] a, b,
    output logic [3:0] p
);
    logic p00, p01, p10, p11;
    logic c1, s1;

    // 1. Generate Partial Products (AND gates)
    and (p00, a[0], b[0]);
    and (p01, a[0], b[1]);
    and (p10, a[1], b[0]);
    and (p11, a[1], b[1]);

    // 2. Summation Stage
    // Bit 0: Just p00
    assign p[0] = p00;

    // Bit 1: Add p01 and p10 -> Sum is p[1], Carry is c1
    half_adder ha1 (.a(p01), .b(p10), .sum(p[1]), .cout(c1));

    // Bit 2: Add p11 and c1 -> Sum is p[2], Carry is p[3]
    half_adder ha2 (.a(p11), .b(c1),  .sum(p[2]), .cout(p[3]));
endmodule
```

**Testbench:**
[Download tb_multiplier_structural.sv](tb_multiplier_structural.sv)

```systemverilog
`timescale 1ns/1ps

module tb_multiplier2x2;
    logic [1:0] a, b;
    logic [3:0] p;

    multiplier2x2 uut (.*);

    initial begin
        $dumpfile("multiplier_structural.vcd");
        $dumpvars(0, tb_multiplier2x2);

        $display("\n=========================================");
        $display("   Example 8D: 2x2 Structural Multiplier ");
        $display("=========================================");
        
        // Exhaustive test (4x4 = 16 cases)
        for (int i=0; i<4; i++) begin
            for (int j=0; j<4; j++) begin
                a = i[1:0];
                b = j[1:0];
                #10;
                if (p !== (a*b))
                     $display("ERROR: %d * %d = %d (Exp %d)", a, b, p, a*b);
                else
                     $display(" OK: %d * %d = %d", a, b, p);
            end
        end

        $display("=========================================\n");
        $finish;
    end
endmodule
```


### E. N-Bit Multiplier (Parameterized Dataflow)
Digital multiplication can be complex to build structurally as N grows. In SystemVerilog, we typically use the `*` operator, and the synthesis tool infers a hardware multiplier (like a DSP block on an FPGA).

[Download multiplier.sv](multiplier.sv)

```systemverilog
module multiplier #(parameter N = 4) (
    input  logic [N-1:0] a, b,
    output logic [(2*N)-1:0] product
);
    // Result of N*N multiplication is 2*N bits wide
    assign product = a * b;
endmodule
```

**Testbench:**
[Download tb_multiplier.sv](tb_multiplier.sv)

```systemverilog
`timescale 1ns/1ps

module tb_multiplier;
    parameter WIDTH = 4;
    logic [WIDTH-1:0] a, b;
    logic [(2*WIDTH)-1:0] product;

    multiplier #(.N(WIDTH)) uut (.*);

    initial begin
        $dumpfile("multiplier.vcd");
        $dumpvars(0, tb_multiplier);

        $display("\n=========================================");
        $display("  Example 8E: %0d-Bit Multiplier         ", WIDTH);
        $display("=========================================");
        
        // 1. Simple Test
        a = 2; b = 3;
        #10;
        $display(" %d * %d = %d | Exp: 6", a, b, product);

        // 2. Max Value
        a = 4'hF; b = 4'hF; // 15 * 15 = 225 (0xE1)
        #10;
        $display(" %d * %d = %d (Hex: %h) | Exp: 225 (E1)", a, b, product, product);

        // 3. Random Testing
        repeat(5) begin
             a = $random;
             b = $random;
             #10;
             if (product !== (a * b)) begin
                 $display("ERROR: %d * %d = %d (Actual %d)!", a, b, (a*b), product);
             end else begin
                 $display(" OK: %d * %d = %d", a, b, product);
             end
        end

        $display("=========================================\n");
        $finish;
    end
endmodule
```
---
[ &larr; back to syllabus](/courses/ece251/2026/ece251-syllabus-spring-2026.html) [ &larr; back to notes](/courses/ece251/2026/ece251-notes.html)


