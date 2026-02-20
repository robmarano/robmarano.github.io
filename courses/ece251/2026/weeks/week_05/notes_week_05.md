# Notes for Week 5
[ &larr; back to syllabus](/courses/ece251/2026/ece251-syllabus-spring-2026.html) [ &larr; back to notes](/courses/ece251/2026/ece251-notes.html)

# Topics
## SystemVerilog HDL
1. Built-in Primitives
2. User-Defined Primitives (UDPs)
3. Dataflow Modeling Deep Dive

## MIPS CPU
4. Supporting Procedures in Computer Hardware (Section 2.8)
5. MIPS Addressing for 32-Bit Immediates and Addresses (Section 2.10)
6. Parallelism and Instructions: Synchronization (Section 2.11)

---

# Topic Deep Dive

## 1. Built-in Primitives

While we touched upon structural modeling (instantiating gates) in Week 4, SystemVerilog provides a robust set of built-in gate primitives that form the lowest level of structural description natively supported by the language.

[Detailed notes on Verilog/SystemVerilog as a whole](./verilog.md) and [notes on how to run SystemVerilog on your computer](./installing_verilog_locally.md)

[`module_template.sv`](./module_template.sv)

[`testbench_template.sv`](testbench_template.sv)

### Basic Logic Gates
SystemVerilog supports the standard logic gates, which can have one output and multiple inputs:
*   `and`, `nand`
*   `or`, `nor`
*   `xor`, `xnor`

**Syntax:** `gate_type [instance_name] (output, input1, input2, ...);`

```systemverilog
// 2-input AND gate
and a1 (out, in1, in2);

// 4-input OR gate (primitives can take N inputs!)
or  o1 (out, in1, in2, in3, in4);
```

### Buffers and Inverters
Unlike standard logic gates, buffers and inverters have one input and can have multiple outputs.
*   `buf`: Passes the input to the output unchanged (used for increasing drive strength).
*   `not`: Inverts the input.

**Syntax:** `gate_type [instance_name] (output1, output2, ..., input);`

```systemverilog
// 1 input 'A', fanning out to 3 inverted outputs
not n1 (out1, out2, out3, A);
```

### Tri-State Buffers
Used to model busses where multiple drivers might exist. They have an input, an output, and a control signal.
*   `bufif1`: Passes input to output if control is 1, else high-impedance (`Z`).
*   `notif0`: Inverts input to output if control is 0, else high-impedance (`Z`).

### Delays
You can accurately model physical propagation delays using the `#` delay control operator when instantiating primitives.

```systemverilog
// Output 'y' changes 5 time units after inputs 'a' or 'b' change
and #(5) u1 (y, a, b); 

// Specifies separate rise, fall, and turn-off delays
// #(Rise, Fall, Turn-Off)
bufif1 #(2, 3, 4) b1 (out, in, ctrl);
```

### Array of Instances
When dealing with busses, instantiating 32 individual AND gates is tedious. SystemVerilog allows instantiating an array of primitives concisely.

```systemverilog
logic [7:0] A, B, Y;
// Instantiates 8 AND gates, where Y[i] = A[i] & B[i]
and bitwise_and [7:0] (Y, A, B);
```

### Examples: Built-in Primitives

**Example 1: Easy (SOP Equation)**
*Task: Implement $z = (x_1 x_2)' + x_3$ using `nand`, `and`, `or`.*
```systemverilog
module easy_prim(output logic z, input logic x1, x2, x3);
    logic net1;
    nand u1 (net1, x1, x2); // net1 = (x1 * x2)'
    or   u2 (z, net1, x3);  // z = net1 + x3
endmodule
```

**Example 2: Medium (8-bit Odd Parity Generator)**
*Task: An array of `xor` and `xnor` to determine if an 8-bit bus has an odd number of 1s.*
```systemverilog
module med_prim(output logic p_odd, input logic [7:0] data);
    logic [3:0] net1;
    logic [1:0] net2;
    // Layer 1: pairwise XOR
    xor l1 [3:0] (net1, data[7:4], data[3:0]);
    // Layer 2: pairwise XOR
    xor l2 [1:0] (net2, net1[3:2], net1[1:0]);
    // Layer 3: final XNOR (inverts even parity to get odd)
    xnor out (p_odd, net2[1], net2[0]);
endmodule
```

**Example 3: Hard (Structural 4-to-1 Multiplexer)**
*Task: Build a 4:1 mux using only `bufif1` tri-state primitives and standard gates.*
```systemverilog
module hard_prim(output wire y, input logic [3:0] d, input logic [1:0] sel);
    logic sel0_n, sel1_n;
    logic dec[3:0]; // decoder outputs
    
    // Invert select lines
    not (sel0_n, sel[0]);
    not (sel1_n, sel[1]);
    
    // 2-to-4 Decoder
    and (dec[0], sel1_n, sel0_n);
    and (dec[1], sel1_n, sel[0]);
    and (dec[2], sel[1], sel0_n);
    and (dec[3], sel[1], sel[0]);

    // Tri-state drivers
    // Only one driver is active at a time; others are high-Z.
    bufif1 b0 (y, d[0], dec[0]);
    bufif1 b1 (y, d[1], dec[1]);
    bufif1 b2 (y, d[2], dec[2]);
    bufif1 b3 (y, d[3], dec[3]);
endmodule
```

---

## 2. User-Defined Primitives (UDPs)

While built-in primitives handle basic logic, what if you want to define a custom, optimized gate cell (like a 2-to-1 mux or a specific SR latch) without building it from smaller gates? SystemVerilog allows **User-Defined Primitives (UDPs)**.

UDPs are essentially truth tables or state transition tables evaluated extremely quickly by the simulator. 
*   UDPs can only have **one output**.
*   The output must be the first port.
*   They only support scalar (1-bit) inputs and outputs.
*   They don't support `inout` ports.

UDPs are declared outside of `module` boundaries using the `primitive ... endprimitive` block.

### Combinational UDPs
A combinational UDP defines the output solely based on the current inputs.

**Example: A Custom 3-Input Majority Gate**
Outputs 1 if two or more inputs are 1.

```systemverilog
primitive majority3 (
    output logic y,
    input  logic a, b, c
);
    // Define the truth table
    table
        // a b c : y
        0 0 0 : 0;
        0 0 1 : 0;
        0 1 0 : 0;
        0 1 1 : 1; 
        1 0 0 : 0;
        1 0 1 : 1;
        1 1 0 : 1;
        1 1 1 : 1;
    endtable
endprimitive
```
You instantiate `majority3` exactly as you would an `and` gate.

### Sequential UDPs
A sequential UDP has state (memory). The output port relies on both its *current* state and the inputs. The output port must be declared as a `reg` or `logic` within the primitive.

**Example: A Level-Sensitive D-Latch**

```systemverilog
primitive d_latch_udp (
    output logic q,
    input  logic clk, d
);
    // Optional: Set initial state
    initial q = 1'b0;

    table
        // clk  d   : state : next_state(q)
          1     0   :   ?   :   0;      // CLK=1, pass D
          1     1   :   ?   :   1;
          0     ?   :   ?   :   -;      // CLK=0, retain state ('-' means no change)
          ?    (??) :   ?   :   -;      // Ignore any edges on D if CLK hasn't changed
    endtable
endprimitive
```
*(Note: `?` means any state. `(01)` denotes a rising edge, `(??)` denotes any edge).*

As seen above, UDPs are exceptional for modeling low-level library cells provided by silicon foundries, allowing for fast simulation of specific hardware behaviors.

### Examples: User-Defined Primitives (UDPs)

**Example 1: Easy (2-to-1 Mux Combinational UDP)**
*Task: truth table for a Multiplexer.*
```systemverilog
primitive mux2_udp(output logic y, input logic d0, d1, sel);
    table
        // d0 d1 sel : y
           0  ?   0  : 0; // sel=0, pass d0
           1  ?   0  : 1;
           ?  0   1  : 0; // sel=1, pass d1
           ?  1   1  : 1;
    endtable
endprimitive
```

**Example 2: Medium (Positive Edge-Triggered D-FF)**
*Task: Sequential UDP transitioning only on `posedge clk`.*
```systemverilog
primitive dff_udp(output logic q, input logic clk, d);
    initial q = 0;
    table
        // clk  d : state : next_state
          (01)  0 :   ?   :   0; // Rising edge, capture 0
          (01)  1 :   ?   :   1; // Rising edge, capture 1
          (1?)  ? :   ?   :   -; // Falling edge, hold state
          (?0)  ? :   ?   :   -; // Any 0 transition, hold state
            ?  (?) :   ?   :   -; // Ignore changes in D without clock edge
    endtable
endprimitive
```

**Example 3: Hard (D-FF with Asynchronous Active-Low Clear)**
*Task: Sequential UDP handling asynchronous inputs alongside a clock.*
```systemverilog
primitive dff_clr_udp(output logic q, input logic clk, d, clr_n);
    initial q = 0;
    table
        // clk   d  clr_n : state : next_state
            ?    ?    0   :   ?   :   0; // Async clear takes precedence
            ?    ?  (?0)  :   ?   :   0; // Clearing edge
          (01)   0    1   :   ?   :   0; // Rising edge, clr is inactive (1)
          (01)   1    1   :   ?   :   1; 
          (1?)   ?    1   :   ?   :   -; // Ignoring falling clock
            ?   (?)   1   :   ?   :   -; // Ignoring D variations
            ?    ?  (01)  :   0   :   -; // clr recovering, hold 0
    endtable
endprimitive
```

---

## 3. Dataflow Modeling Deep Dive

Dataflow modeling (`assign`) describes how data moves from inputs to outputs concurrently through combinational logic. In Week 4, we saw basic boolean equations. Here we dive into the nuances that make Dataflow powerful for RTL design.

### Continuous Assignments (`assign`)
A continuous assignment evaluates instantly anytime a signal on its right-hand side (RHS) changes, driving the result to the left-hand side (LHS) continuously.

**Rules:**
1.  The LHS must be a net type (e.g., `wire`, `logic`). It cannot be a variable type heavily used in procedural blocks without care.
2.  The RHS can be any valid expression involving signals, registers, or function calls.

```systemverilog
wire sum, carry;
// Both statements execute concurrently. If 'a' changes, both are re-evaluated.
assign sum = a ^ b ^ cin;
assign carry = (a & b) | (cin & (a ^ b));
```

### Implicit Continuous Assignments
Instead of declaring a net and then assigning it, you can combine them.

```systemverilog
// Explicit
wire out;
assign out = in1 & in2;

// Implicit (Shorthand)
wire out = in1 & in2;
```

### Delays in Dataflow
Unlike structural delays, dataflow delays specify how long it takes for a changed value on the RHS to propagate to the LHS.

1.  **Regular Assignment Delay**: Wait *delay* units, evaluate RHS, assign to LHS.
    ```systemverilog
    // If 'a' changes, wait 10 units, then assign the new value of (a & b) to 'y'
    assign #10 y = a & b; 
    ```
2.  **Implicit Net Delay**: The net itself has an inherent delay.
    ```systemverilog
    wire #10 y; // 'y' always takes 10 units to reflect any driven value
    assign y = a & b; // Evaluates immediately, but 'y' won't update for 10 units
    ```

### Expressions and Operator Precedence
SystemVerilog provides a rich set of operators for dataflow equations. Understanding precedence (order of operations) is critical to avoid unexpected logic.

*(Highest to Lowest Precedence)*
1.  `+ - ! ~ & ~& | ~| ^ ~^` (Unary / Reduction)
2.  `**` (Power / Exponentiation)
3.  `* / %` (Arithmetic Multiply/Divide)
4.  `+ -` (Arithmetic Add/Subtract)
5.  `<< >> <<< >>>` (Logical and Arithmetic Shifts)
6.  `< <= > >=` (Relational)
7.  `== != === !==` (Equality and Case Equality)
8.  `&` (Bitwise AND)
9.  `^ ~^` (Bitwise XOR/XNOR)
10. `|` (Bitwise OR)
11. `&&` (Logical AND)
12. `||` (Logical OR)
13. `?:` (Conditional / Ternary)

*Always use parentheses `()` to clarify intent, even if you memorize precedence.*

**Dataflow Modeling Patterns:**

*   **Arithmetic**: `assign y = (a + b) - c;` (Synthesis tools infer adders/subtractors).
*   **Logical**: `assign is_valid = (data_in > 10) && (en == 1);` (Returns 1-bit boolean).
*   **Conditional Selection (Muxing)**: 
    ```systemverilog
    assign data_out = (sel == 2'b00) ? in0 :
                      (sel == 2'b01) ? in1 :
                      (sel == 2'b10) ? in2 : in3;
    ```
*   **Concatenation & Replication**: Excellent for bit-packing.
    ```systemverilog
    // Packing state flags
    assign status_bus = {is_ready, has_error, 6'b000000}; 
    
    // Sign-extending a 4-bit number 'a' to 8 bits
    assign padded_a = {{4{a[3]}}, a}; 
    ```

By mastering these Dataflow tools, complex combinational logic blocks like ALU functions (Add, Subtract, Shift, Compare) become readable and highly synthesizable one-liners.

### 3.5 SystemVerilog Assignment Rules: `assign`, `=`, and `<=`

As designs grow complex, understanding EXACTLY how values are placed into variables is critical to synthesize working hardware. SystemVerilog strictly separates continuous dataflow assignments from procedural block assignments.

**1. Continuous Assignment (`assign`)**
*   **Where it lives:** Concurrently placed directly inside a `module`.
*   **Target Data Type:** The left-hand side MUST be a net type (like `wire` or the structural use of `logic`).
*   **How it works:** It acts as a physical wire. Any time a signal on the right side changes, the left side updates instantaneously. It *cannot* have memory or state. 

**2. Procedural Blocking Assignment (`=`)**
*   **Where it lives:** Exclusively inside `always` or `always_comb` procedural blocks.
*   **Target Data Type:** The left-hand side MUST be a variable type (`reg` or the procedural use of `logic`).
*   **How it works:** Statements execute sequentially, top-to-bottom. The variable receives its new value *immediately*, and subsequent lines see the updated value. It is the primary way to define complex **combinational logic** using software-like `if/else` and `case` structures.

**3. Procedural Non-Blocking Assignment (`<=`)**
*   **Where it lives:** Exclusively inside clocked `always_ff` or `always @(posedge clk)` blocks.
*   **Target Data Type:** The left-hand side MUST be a variable type (`reg` or `logic`).
*   **How it works:** Statements execute concurrently. The right-hand side of all `<=` statements in the block are evaluated immediately, but the left-hand sides *do not change* until the very end of the simulation time step. This is explicitly required to model **Registers and Flip-Flops**. Using `<=` safely prevents simulation race conditions between discrete clocked hardware elements.

> [!WARNING]
> **The Golden Rules:**
> 1. Never use `=` to model sequential logic (Flip-Flops). Use `<=`.
> 2. Never use `<=` to model combinational logic. Use `=` or `assign`.
> 3. Never mix `=` and `<=` in the same `always` block.

### Examples: Dataflow Modeling

**Example 1: Easy (Full Adder)**
*Task: Utilize logic operations and concatenation for a 1-bit full adder.*
```systemverilog
module easy_dataflow(output logic sum, cout, input logic a, b, cin);
    // Explicit boolean eq:
    // assign sum = a ^ b ^ cin;
    // assign cout = (a & b) | (cin & (a ^ b));

    // Better: Allow synthesis tools to map the arithmetic operator (+)
    assign {cout, sum} = a + b + cin;
endmodule
```

**Example 2: Medium (Dataflow 4-to-1 Mux)**

*Task: A 4:1 Mux modeled strictly with nested conditional (`?:`) operators.*
```systemverilog
module med_dataflow(output logic [31:0] y, input logic [31:0] d0, d1, d2, d3, input logic [1:0] s);
    assign y = (s == 2'b00) ? d0 :
               (s == 2'b01) ? d1 :
               (s == 2'b10) ? d2 : d3;
endmodule
```

**Example 3: Hard (Simple Arithmetic Logic Unit)**

*Task: A dataflow ALU determining its output operation via a 3-bit opcode.*
```systemverilog
module hard_dataflow(output logic [15:0] result, output logic zero, input logic [15:0] a, b, input logic [2:0] opcode);
    // 000: ADD, 001: SUB, 010: AND, 011: OR, 100: XOR, 101: Shift L, 110: Shift R
    assign result = (opcode == 3'b000) ? (a + b) :
                    (opcode == 3'b001) ? (a - b) :
                    (opcode == 3'b010) ? (a & b) :
                    (opcode == 3'b011) ? (a | b) :
                    (opcode == 3'b100) ? (a ^ b) :
                    (opcode == 3'b101) ? (a << b[3:0]) :
                    (opcode == 3'b110) ? (a >> b[3:0]) : 16'h0000;
                    
    // Reduction NOR logic to test for zero outcome
    assign zero = ~(|result);
endmodule
```

---

## 4. Supporting Procedures in Computer Hardware (Section 2.8)

A **procedure** (or function) is a mechanism for code reuse and abstraction. The MIPS architecture relies heavily on software conventions to implement procedure calls seamlessly.

### The 6-Step Procedure Execution
1.  **Place Parameters:** The caller places arguments where the procedure can access them (`$a0`-`$a3`).
2.  **Transfer Control:** The caller jumps to the procedure (`jal Label`).
3.  **Acquire Storage:** The procedure allocates memory for local variables and saved registers on the stack.
4.  **Perform Task:** The procedure executes its logic.
5.  **Place Result:** The procedure places its return value where the caller can access it (`$v0`-`$v1`).
6.  **Return:** The procedure returns control to the point of origin (`jr $ra`).

### MIPS Register Conventions
*   `$a0`-`$a3` (4-7): Arguments passed to the procedure.
*   `$v0`-`$v1` (2-3): Return values.
*   `$t0`-`$t9` (8-15, 24-25): **Caller-Saved** temporaries (not preserved across calls).
*   `$s0`-`$s7` (16-23): **Callee-Saved** saved registers (must be preserved across calls).
*   `$sp` (29): Stack Pointer.
*   `$ra` (31): Return Address.

### The Stack and Stack Frames
The stack is memory used to "spill" registers when we run out of MIPS's 32 hardware registers, or when we need to preserve variables across a nested procedure call. The stack grows **downwards** from high memory addresses to low.
*   **Push:** `addi $sp, $sp, -4` then `sw $t0, 0($sp)`
*   **Pop:** `lw $t0, 0($sp)` then `addi $sp, $sp, 4`

**Leaf vs. Nested Procedures:**
A **leaf procedure** does not call any other procedures. It may not need to use the stack at all if it only uses `$t` registers. A **nested procedure** calls another procedure. It **must** save its `$ra` to the stack before jumping, otherwise the second `jal` will irreparably overwrite the original return address!

---

## 5. MIPS Addressing for 32-Bit Immediates and Addresses (Section 2.10)

MIPS instructions are rigidly 32 bits long. This makes it impossible for an I-Type instruction (like `addi`) to contain both the opcode/registers AND a full 32-bit constant, as the immediate field is only 16 bits.

### Loading 32-Bit Constants
We construct 32-bit constants using two instructions:
1.  **`lui` (Load Upper Immediate):** Loads a 16-bit constant into the top 16 bits of a register, clearing the bottom 16 bits to 0.
2.  **`ori` (OR Immediate):** Bitwise ORs a 16-bit constant into the bottom 16 bits.

```assembly
// Load 0xDEADBEEF into $s0
lui $s0, 0xDEAD     // $s0 = 0xDEAD0000
ori $s0, $s0, 0xBEEF // $s0 = 0xDEADBEEF
```

### The 5 Addressing Modes of MIPS
1.  **Immediate Addressing:** The operand is a constant embedded in the instruction itself (e.g., `addi $t0, $t1, 5`).
2.  **Register Addressing:** The operand is a hardware register (e.g., `add $t0, $t1, $t2`).
3.  **Base (Displacement) Addressing:** The memory address is the sum of a register and a sign-extended 16-bit constant (e.g., `lw $t0, 100($s1)`).
4.  **PC-Relative Addressing:** The memory address is the sum of the PC and a sign-extended 16-bit constant, shifted left by 2 (e.g., `beq $t0, $t1, Label`). Used for relatively close branches. Target = $PC + 4 + (\text{offset} \times 4)$.
5.  **Pseudodirect Addressing:** The target address is the 26-bit field of a `J-Type` instruction shifted left by 2, combined with the top 4 bits of the current PC (e.g., `j Label`). This allows a jump anywhere within the current 256 MB block of memory. To jump further, `jr` (Register Addressing) must be used.

---

## 6. Parallelism and Instructions: Synchronization (Section 2.11)

In modern multicore processors, multiple CPUs share the same main memory. This introduces the concept of a **Data Race**: when two threads try to read and write to the same memory location simultaneously, the final variable state is unpredictable and depends on the exact timing of the threads.

### The Synchronization Problem
A simple "lock" mechanism stored in memory (0 = unlocked, 1 = locked) cannot be implemented with standard `lw` and `sw`. Two threads might both `lw` the lock simultaneously, see that it is 0, and both `sw` 1 to claim it. They both think they own the lock! We need an **atomic** read-modify-write operation (an operation that cannot be interrupted).

### Load Linked and Store Conditional
MIPS provides two special instructions to build atomic operations hardware-efficiently without complex lock lines on the memory bus.
*   **`ll rt, offset(rs)` (Load Linked):** Loads a word from memory and registers the memory address with the CPU.
*   **`sc rt, offset(rs)` (Store Conditional):** Attempts to store to the address. **It succeeds (writes to memory and sets `rt` to 1) ONLY IF no other processor has written to that address since the `ll`.** Otherwise, it fails (does not write, sets `rt` to 0).

If `sc` fails, the local thread can simply loop back and try the `ll` again.

---

# Student Problem Set

*Complete these 9 problems. See the answers at the bottom when you are done to check your work!*

## Topic 1: Built-in Primitives

**1. Easy**:
Translate the equation $Y = A \cdot B + C$ directly into structural gate primitives `and` and `or`.

**2. Medium**:
Identify the error in the following instantiation of logic primitives: `and u1 (in1, in2, out);`

**3. Hard**:
Design a structural 2-bit Equality Comparator ($A=B$) using only `xnor` and `and` primitives. Assume $A = {a1, a0}$ and $B = {b1, b0}$. 

## Topic 2: UDPs

**4. Easy**:
Write the `table` section of a combinational UDP for a 3-input XOR gate ($Y = A \oplus B \oplus C$).

**5. Medium**:
Write the state table for an RS-Latch Sequential UDP. The latch holds state if $R=0, S=0$. It sets if $S=1$, resets if $R=1$, and state is unpredictable limit (`x`) if $R=1, S=1$. 

**6. Hard**:
Write the core state table for a negative-edge-triggered T-Flip-Flop (Toggles on clock falling edge if $T=1$).

## Topic 3: Dataflow Modeling 

**7. Easy**: Write a single `assign` statement for a 2-to-4 decoder's $0$th signal (`dec0`), which should be high only when `sel` is `2'b00`.

**8. Medium**: What is logically incorrect about this dataflow statement trying to select 'data1' when 'enable' is high, and bitwise ORing the result with a mask? `assign out = enable ? data1 : data0 | mask;` (Hint: Check operator precedence!)

**9. Hard**:
Design a 4-input priority encoder using nested conditional operators. $D[3]$ has highest priority, $D[0]$ has lowest. If $D[3]$ is 1, output `2'b11`. If $D=\text{0000}$, output `2'b00` and assert an `idle` signal using concatenation `{idle, val}`.

## Topic 4: Supporting Procedures (Section 2.8)

**10. Easy**:
Categorize the following registers into "Caller-Saved" or "Callee-Saved": `$t0`, `$s0`, `$ra`, `$a0`.

**11. Medium**:
Write a MIPS procedure prologue and epilogue that safely backs up and restores `$s0` and `$s1`. Assume `$sp` needs to stay 4-byte aligned (so allocate 8 bytes).

**12. Hard**: 
alculate the necessary stack frame size (in bytes) and `$sp` movement for a deeply nested recursive function that needs to save `$ra`, `$a0`, `$s0`, `$s1`, and `$s2` on the stack for each call. 

## Topic 5: MIPS Addressing (Section 2.10)

**13. Easy**:
Write the two instructions needed to load the 32-bit constant `0xDEADBEEF` into register `$t0`.

**14. Medium**:
Calculate the exact target address of a `beq` instruction given the $PC = \text{0x00400010}$ and the 16-bit offset is `0x0005`.

**15. Hard**:
Contrast the reach (addressable range) of a `j` instruction vs. a `jr` instruction. Explain why `jr` is strictly necessary for large OS kernels to jump anywhere in a 32-bit address space.

## Topic 6: Synchronization (Section 2.11)

**16. Easy**:
Define a "data race" condition in the context of multicore processors.

**17. Medium**:
Explain what happens to an `sc` (store conditional) instruction if an operating system context-switch (an interrupt) occurs entirely between the `ll` (load linked) and the `sc`.

**18. Hard**:
Write a simple atomic "spin-lock" acquisition loop using `ll` and `sc` instructions in MIPS assembly. Assume the lock address is in `$a0` (0 means unlocked, 1 means locked).

---

<details markdown="1">
<summary><b>Click here to reveal Answer Key</b></summary>

### Topic 1 Answers

**1. Easy**

```systemverilog
logic net1;
and (net1, A, B);
or (Y, net1, C);
```

**2. Medium**:
The port ordering is incorrect. In SystemVerilog primitives, the **output** is always listed first. It should be `and u1 (out, in1, in2);`

**3. Hard**
```systemverilog
logic eq0, eq1;
xnor (eq0, a0, b0);
xnor (eq1, a1, b1);
and (A_eq_B, eq0, eq1);
```

### Topic 2 Answers

**4. Easy**
```systemverilog
table
    // A B C : Y
       0 0 0 : 0;
       0 0 1 : 1;
       0 1 0 : 1;
       0 1 1 : 0;
       1 0 0 : 1;
       1 0 1 : 0;
       1 1 0 : 0;
       1 1 1 : 1;
endtable
```

**5. Medium**
```systemverilog
table
    // R  S : state : next_state
       0  0 :   ?   :   -; // hold
       1  0 :   ?   :   0; // reset
       0  1 :   ?   :   1; // set
       1  1 :   ?   :   x; // unpredictable
endtable
```

**6. Hard**
```systemverilog
table
    // clk   T  : state : next_state
      (10)   0  :   ?   :   -; // Falling edge, T=0, hold
      (10)   1  :   0   :   1; // Falling edge, T=1, toggle 0->1
      (10)   1  :   1   :   0; // Falling edge, T=1, toggle 1->0
      (0?)   ?  :   ?   :   -; // Ignore rising edges
       ?    (?) :   ?   :   -; // Ignore T variations
endtable
```

### Topic 3 Answers
**7. Easy**
```systemverilog
assign dec0 = (sel == 2'b00); // Evaluates to 1-bit logic 1/0
```

**8. Medium**:
According to precedence rules, Bitwise OR (`|`) evaluates *before* the Conditional operator (`?:`). Therefore, the code actually evaluates as `assign out = enable ? data1 : (data0 | mask)`. If 'enable' is high, the mask is entirely ignored! The correct notation requires parenthesis: `assign out = (enable ? data1 : data0) | mask;`

**9. Hard**
```systemverilog
assign {idle, val} = (D[3]) ? {1'b0, 2'b11} :
                     (D[2]) ? {1'b0, 2'b10} :
                     (D[1]) ? {1'b0, 2'b01} :
                     (D[0]) ? {1'b0, 2'b00} : {1'b1, 2'b00}; // D is 0000, assert idle bit
```

### Topic 4 Answers
**10. Easy**: 
*   **Caller-Saved (Not preserved across calls)**: `$t0`, `$a0`.
*   **Callee-Saved (Preserved across calls)**: `$s0`, `$ra`.

**11. Medium**
```systemverilog
// Prologue
addi $sp, $sp, -8  // Allocate 8 bytes
sw   $s0, 4($sp)   // Save $s0
sw   $s1, 0($sp)   // Save $s1

// [Procedure Body]

// Epilogue
lw   $s1, 0($sp)   // Restore $s1
lw   $s0, 4($sp)   // Restore $s0
addi $sp, $sp, 8   // Deallocate 8 bytes
jr   $ra           // Return
```

**12. Hard**:
Saving 5 registers requires 5 words. Each word is 4 bytes. 
Frame Size = $5 \times 4 = 20$ bytes. 
Stack Pointer movement: `addi $sp, $sp, -20` (prologue) and `addi $sp, $sp, 20` (epilogue).

### Topic 5 Answers
**13. Easy**
```systemverilog
lui $t0, 0xDEAD     // Load Upper Immediate
ori $t0, $t0, 0xBEEF // OR Immediate
```

**14. Medium**:
`beq` uses PC-Relative Addressing. The target address is $PC + 4 + (\text{offset} \times 4)$. 
$Target = \text{0x00400010} + 4 + (5 \times 4) = \text{0x00400014} + 20 = \text{0x00400014} + \text{0x00000014} = \text{0x00400028}$.

**15. Hard**:
A `j` instruction uses Pseudodirect Addressing, allowing it to reach anywhere within the current **256 MB block** (determined by the upper 4 bits of the PC). A `jr` instruction jumps to the address contained in a 32-bit register, giving it an **absolute 4 GB reach**. `jr` is necessary for OS kernels and dynamically linked libraries because they might reside in completely different memory segments than the calling code block.

### Topic 6 Answers

**16. Easy**:
A data race occurs when two or more concurrent threads/processes access the same memory location simultaneously, and at least one access is a write, and the accesses are not synchronized. The final result depends on the unpredictable timing of the execution.

**17. Medium**:
If a context switch occurs between `ll` and `sc`, the `sc` instruction will fail (store 0 into the target register instead of 1, and not update memory) because the operating system guarantees that any exception/interrupt resets the link register used by the `ll`/`sc` pair.

**18. Hard**
```systemverilog
spin_lock:
    ll   $t0, 0($a0)     // Load Linked: Read lock status
    bne  $t0, $zero, spin_lock // If lock is 1 (taken), spin and try again
    add  $t1, $zero, 1   // Setup $t1 = 1 (locked value)
    sc   $t1, 0($a0)     // Store Conditional: Try to write 1 to lock
    beq  $t1, $zero, spin_lock // If sc failed (returned 0), spin and try again
    // Lock acquired!
```

</details>

---

## MIPS32 ALU SystemVerilog Project
A fully parameterized, combinational Arithmetic Logic Unit (ALU) modeled after the MIPS32 architecture has been added to this week's materials. It processes standard R-Type instructions (e.g., `add`, `sub`, `and`, `or`, `slt`) directly from the opcode and funct bit inputs without utilizing a hardware clock.

**Project Files:**
*   [`README.md`](mips32_alu/README.md): Documentation and simulation instructions.
*   [`alu.sv`](mips32_alu/alu.sv): The parameterized ALU SystemVerilog module.
*   [`tb_alu.sv`](mips32_alu/tb_alu.sv): The testbench validating signed/unsigned math operations and the zero-flag.

---
[ &larr; back to syllabus](/courses/ece251/2026/ece251-syllabus-spring-2026.html) [ &larr; back to notes](/courses/ece251/2026/ece251-notes.html)