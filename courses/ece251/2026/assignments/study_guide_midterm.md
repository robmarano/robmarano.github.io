# ECE 251: Midterm Study Guide (Spring 2026)

This comprehensive study guide encompasses the foundational curriculum introduced during Weeks 01-07, aligning intimately with Chapters 1 and 2 of the formal textbook. 

To best prepare for the Midterm Examination, students must be capable of bridging physical mathematics (latency, clock cycles) with logic design (K-Maps, Boolean Expansion), and software compilation (C arrays mapped to raw MIPS Machine Code).

---

## Table of Contents
1. [Chapter 1: Computer Abstractions and Technology](#chapter-1-computer-abstractions-and-technology)
2. [Chapter 2: Instructions (Language of the Computer)](#chapter-2-instructions-language-of-the-computer)
3. [Digital Logic & Hardware Architecture](#digital-logic--hardware-architecture)

---

## Chapter 1: Computer Abstractions and Technology

### Key Concepts
- **The Power Wall:** The phenomenon where clock frequencies peaked near 2004 due to exponential thermal dissipation limits, forcing the industry to shift from single-core uniprocessors to multi-core architectures.
- **CPU Execution Time:** The fundamental benchmark of true hardware performance.
  $$\text{CPU Time} = \text{Instruction Count} \times \text{CPI} \times \text{Clock Cycle Time}$$
  $$\text{CPU Time} = \frac{\text{Instruction Count} \times \text{CPI}}{\text{Clock Rate}}$$

### Worked Example 1.1: Clock Rate Optimization
**Problem:** Our favorite program runs in 25 seconds on $Computer_A$, which has a 2 GHz clock. We are trying to help a computer designer build a $Computer_B$, which will run this program in 5 seconds. The designer has determined that a substantial increase in the clock rate is possible, but this increase will affect the rest of the CPU design, causing $Computer_B$ to require 1.2 times as many clock cycles as $Computer_A$ for this program. What clock rate should we tell the designer to target?

**Solution:**
1. Calculate the raw number of structural clock cycles required for Computer A:
   $$\text{CPU Time}_A = \frac{\text{Clock Cycles}_A}{\text{Clock Rate}_A}$$
   $$25 \text{ s} = \frac{\text{Clock Cycles}_A}{2 \times 10^9 \text{ Hz}}$$
   $$\text{Clock Cycles}_A = 25 \times 2 \times 10^9 = 50 \times 10^9 \text{ cycles}$$
2. Calculate the required clock cycles allocated for Computer B:
   $$\text{Clock Cycles}_B = 1.2 \times \text{Clock Cycles}_A = 1.2 \times 50 \times 10^9 = 60 \times 10^9 \text{ cycles}$$
3. Determine the target clock rate necessary for Computer B to finish processing in exactly 5 seconds:
   $$\text{CPU Time}_B = \frac{\text{Clock Cycles}_B}{\text{Clock Rate}_B}$$
   $$5 \text{ s} = \frac{60 \times 10^9 \text{ cycles}}{\text{Clock Rate}_B}$$
   $$\text{Clock Rate}_B = \frac{60 \times 10^9}{5} = 12 \times 10^9 \text{ Hz} = 12 \text{ GHz}$$

### Worked Example 1.2: CPI and Compiling Code Sequences
**Problem:** A compiler designer is trying to decide between compiling two specific hardware code sequences. They evaluate three unique instruction architectures:
| Metric | Class A | Class B | Class C |
| --- | --- | --- | --- |
| Hardware CPI | 1 | 2 | 3 |

*   **Code Sequence 1 requires:** 2 (Class A), 1 (Class B), 2 (Class C).
*   **Code Sequence 2 requires:** 4 (Class A), 1 (Class B), 1 (Class C).

Which code sequence executes the most instructions? Which will be faster? What is the CPI for each sequence?

**Solution:**
1. **Total Instruction Counts:**
   - Sequence 1: $2 + 1 + 2 = 5$ instructions natively.
   - Sequence 2: $4 + 1 + 1 = 6$ instructions natively.
   - **Answer:** *Sequence 2 executes the most hardware instructions.*
2. **Execution Latency (in physical Clock Cycles):**
   - Cycles for Sequence 1 = $(2 \times 1) + (1 \times 2) + (2 \times 3) = 2 + 2 + 6 = 10 \text{ clock cycles}$.
   - Cycles for Sequence 2 = $(4 \times 1) + (1 \times 2) + (1 \times 3) = 4 + 2 + 3 = 9 \text{ clock cycles}$.
   - **Answer:** *Sequence 2 is physically faster (9 cycles vs 10 cycles), despite having more instructions!*
3. **Average CPI Mapping:**
   - $\text{CPI}_1 = \frac{\text{Total Cycles}_1}{\text{Instruction Count}_1} = \frac{10}{5} = 2.0$
   - $\text{CPI}_2 = \frac{\text{Total Cycles}_2}{\text{Instruction Count}_2} = \frac{9}{6} = 1.5$


---

## Chapter 2: Instructions (Language of the Computer)

### Key Concepts
- **MIPS Registers:** `$t0-$t9` (temporary), `$s0-$s7` (saved), `$a0-$a3` (arguments), `$v0-$v1` (return values), `$ra` (return address), `$sp` (stack pointer).
- **Instruction Formats:** R-type (Register), I-type (Immediate), J-type (Jump).

### Worked Example 2.1: Binary & Two's Complement Constraints
**Problem:** Determine the two's complement constraint integer for the raw binary address `11100111`.
**Solution:**
*(Note: This concept is mathematically critical for understanding MIPS Branch offsets and calculating Signed Immediate addresses).*
1. Invert the independent bits: `00011000`
2. Add physical 1 to the logic: `00011001` (representing `25` decimal).

### Worked Example 2.2: Instruction Compilation & Addressing
**Problem:** Convert the following MIPS instruction into its corresponding 32-bit hexadecimal machine code representation: `lw $t1, -4($s3)`
**Solution:**
1. Analyze the format natively: I-Type (`opcode rs rt immediate`)
2. `lw` opcode: `0x23` or $35$ decimal (`100011` binary)
3. `rs` (base register): `$s3` maps to array register $19$ (`10011` binary)
4. `rt` (destination register): `$t1` maps to array register $9$ (`01001` binary)
5. `immediate`: The integer `-4` written mathematically in 16-bit two's complement.
   - Positive $4$: `0000 0000 0000 0100` -> Invert to: `1111 1111 1111 1011` -> Add 1: `1111 1111 1111 1100` (`0xFFFC`)
6. Construct the raw 32-bit binary layout:
   `100011` | `10011` | `01001` | `1111 1111 1111 1100`
7. Combine and calculate hexadecimal sequence:
   `1000 1110 0110 1001 1111 1111 1111 1100`
   **`0x8E69FFFC`**

### Worked Example 2.3: Virtual Memory Layout & Row-Major Storage
**Problem:** Consider the C language declaration `char x[8][3];`. If `x[0][2]` happens to be stored at memory address `0x20c`, at which memory address would `x[2][1]` physically be stored? Assume little-endian memory and row-major array storage methodologies.
**Solution:**
1. Array indices are explicitly 0-based. The array generates 8 rows of 3 columns, where each physical `char` takes exactly 1 byte.
2. The distance from the origin `x[0][0]` to any offset `x[i][j]` equals `(i * 3) + j` independent bytes.
3. Therefore, `x[0][2]` sits at structural index 2 ($0 \times 3 + 2$). Its base address `x[0][0]` must logically be `0x20c - 2 = 0x20a`.
4. We need to find `x[2][1]`. Its raw offset from the base integer is `(2 * 3) + 1 = 7` bytes.
5. Final Memory Address = `0x20a + 7` = **`0x211`**.

### Worked Example 2.4: Translating C Arrays directly to MIPS Assembly
**Problem:** Hand-compile the following C `for` loop iteration into structural MIPS assembly. Assume `$s0 = &arr[0]` and `$s1 = size = 10`. The variables `sum`, `pos`, and `neg` represent `$t0`, `$t1`, and `$t2` respectively (all natively initialized to $0$). `$t3` operates iteratively as variable `i`.

```c
for (i = 0; i < size; i++) {
    sum += arr[i];
    if (arr[i] > 0)
        pos += arr[i];
    if (arr[i] < 0)
        neg += arr[i];
}
```

**Solution:**
```mips
# Initialize working variables iteratively
    add $t0, $0, $0   # sum = 0
    add $t1, $0, $0   # pos = 0
    add $t2, $0, $0   # neg = 0
    add $t3, $0, $0   # i = 0

FOR_LOOP:
    slt $t4, $t3, $s1 # Evaluate: $t4 = 1 if i < size
    beq $t4, $0, DONE # IF i >= size implies $t4 == 0, break loop sequentially
    
    # Calculate physical address for array extraction: arr[i]
    sll $t5, $t3, 2   # $t5 = i * 4 (shifting 2 bytes extracts Word offsets)
    add $t5, $s0, $t5 # $t5 = base address origin + mathematical offset
    lw  $t6, 0($t5)   # Register $t6 structurally now holds arr[i]
    
    add $t0, $t0, $t6 # Evaluate integer logic: sum += arr[i]
    
    # if (arr[i] > 0)
    slt $t7, $0, $t6  # $t7 = 1 if (0 < arr[i]) translating directly to (arr[i] > 0)
    beq $t7, $0, CHECK_NEG
    add $t1, $t1, $t6 # Implement logic: pos += arr[i]
    
CHECK_NEG:
    # if (arr[i] < 0)
    slt $t7, $t6, $0  # $t7 = 1 if (arr[i] < 0)
    beq $t7, $0, NEXT_ITER
    add $t2, $t2, $t6 # Implement logic: neg += arr[i]
    
NEXT_ITER:
    addi $t3, $t3, 1  # Iterate counter: i++
    j FOR_LOOP        # Jump structurally to repeat evaluation block

DONE:
    # Function successfully routed and finalized natively
```

---

## SystemVerilog Basics & Hardware Architecture

### Key Concepts
- **Combinational Logic:** Digital logic whose physical output depends purely on the current state of its inputs. In SystemVerilog, this is architected using continuous assignments (`assign`) for simple dataflow, or isolated `always_comb` blocks for complex routing and decision logic.
- **Sequential Logic:** Digital memory structures whose output depends on both the current inputs and the *previous* state of the system. Modeled natively in SystemVerilog using `always_ff @(posedge clk)` blocks that are triggered precisely on the rising edge of a clock signal.
- **Clocks and Busses:** Standard wires (`logic`) can represent singular 1-bit flags (like a clock), or multi-bit busses such as `logic [7:0] data_bus` (which physically routes 8 independent bits in parallel). Multiplexors and conditional logic dynamically route these bus signals across the CPU.

### Worked Example 3.1: Writing a Hardware Module and Testbench
**Problem:** Construct a foundational SystemVerilog module implementing a sequential Register (a D Flip-Flop) alongside its corresponding simulation Testbench.
**Solution:**
A hardware module encapsulates the physical logic and defines structural input/output ports. A testbench represents an isolated virtual environment that instantiates the module, generates simulated signals (like toggling a clock), and tests the logical outputs.

```systemverilog
// 1. Hardware Module Definition
module d_flip_flop(
    input logic clk,
    input logic d,
    output logic q
);
    // Sequential logic: triggered purely on the rising edge of the clock
    always_ff @(posedge clk) begin
        q <= d; // Non-blocking assignment for secure sequential state updates
    end
endmodule

// 2. Simulation Testbench
module tb_d_flip_flop();
    logic clk, d, q; // Local testbench wires to drive the design
    
    // Instantiate the Device Under Test (DUT)
    d_flip_flop dut(.clk(clk), .d(d), .q(q));
    
    // Generate a simulated physical clock (toggles every 5 time units)
    always #5 clk = ~clk;
    
    initial begin
        clk = 0; d = 0; // Initialize starting signal states
        #10 d = 1;      // Drive inputs high and evaluate logic
        #10 d = 0;
        #20 $finish;    // Terminate simulation cleanly
    end
endmodule
```

### Worked Example 3.2: Designing an 8-bit SystemVerilog ALU
**Problem:** Show how to construct an 8-bit ALU module that accepts two 8-bit data operands, utilizes a 4-bit operation code (Opcode) bus, handles basic mathematical and logical combinations (Add, Subtract, AND, OR, NOT, Shift Left/Right), and routes memory via an 8-bit address bus utilizing decision combination logic.

**Solution:**
This implementation necessitates an `always_comb` combinational logic block acting essentially as a massive hardware multiplexor. A structural `case` statement evaluates the 4-bit opcode bus to decide which physical circuit's manipulation gets routed natively to the 8-bit `alu_out_bus`.

```systemverilog
module alu_8bit(
    input  logic [7:0] operand_a,    // 8-bit Data Bus (Operand A)
    input  logic [7:0] operand_b,    // 8-bit Data Bus (Operand B)
    input  logic [3:0] alu_opcode,   // 4-bit Operation Bus
    input  logic [7:0] address_bus,  // 8-bit Address Bus (Routing/Memory target)

    output logic [7:0] alu_out_bus,  // 8-bit Result Data Bus
    output logic       zero_flag     // 1-bit Condition Flag
);

    // Combinational logic block for decision/routing circuitry
    always_comb begin
        // Default routing to prevent unwanted physical latch generation
        alu_out_bus = 8'b0;
        
        case(alu_opcode)
            4'b0000: alu_out_bus = operand_a & operand_b;       // Logical AND
            4'b0001: alu_out_bus = operand_a | operand_b;       // Logical OR
            4'b0010: alu_out_bus = operand_a + operand_b;       // Arithmetic Add
            4'b0110: alu_out_bus = operand_a - operand_b;       // Arithmetic Subtract
            4'b0111: alu_out_bus = ~operand_a;                  // Logical NOT (Invert A)
            4'b1000: alu_out_bus = operand_a << 1;              // Shift Logic Left
            4'b1001: alu_out_bus = operand_a >> 1;              // Shift Logic Right
            4'b1111: alu_out_bus = address_bus;                 // Route Address directly to output
            default: alu_out_bus = 8'b0;                        // Safe default state isolation
        endcase
    end

    // Combinational logic calculating the Zero Flag status
    assign zero_flag = (alu_out_bus == 8'b0);

endmodule
```
*(Note: This logic structure implements native **Combinational Logic**. The outputs structurally update instantaneously whenever the inputs `operand_a`, `operand_b`, `address_bus`, or `alu_opcode` transform. Sequential memory architectures would be introduced structurally outside the ALU to "save" the resulting `alu_out_bus` computation onto a Register component triggered by a clock).*
