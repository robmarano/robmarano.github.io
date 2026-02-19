# Notes for Week 5
[ &larr; back to syllabus](/courses/ece251/2026/ece251-syllabus-spring-2026.html) [ &larr; back to notes](/courses/ece251/2026/ece251-notes.html)

# Topics
1. Built-in Primitives
2. User-Defined Primitives (UDPs)
3. Dataflow Modeling Deep Dive

---

# Topic Deep Dive

## 1. Built-in Primitives

While we touched upon structural modeling (instantiating gates) in Week 4, SystemVerilog provides a robust set of built-in gate primitives that form the lowest level of structural description natively supported by the language.

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
```systemverilog
    // Packing state flags
    assign status_bus = {is_ready, has_error, 6'b000000}; 
    
    // Sign-extending a 4-bit number 'a' to 8 bits
    assign padded_a = {{4{a[3]}}, a}; 
    ```

By mastering these Dataflow tools, complex combinational logic blocks like ALU functions (Add, Subtract, Shift, Compare) become readable and highly synthesizable one-liners.

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

# Student Problem Set
*Complete these 9 problems. See the answers at the bottom when you are done to check your work!*

## Topic 1: Built-in Primitives
**1. Easy**: Translate the equation $Y = A \cdot B + C$ directly into structural gate primitives `and` and `or`.
**2. Medium**: Identify the error in the following instantiation of logic primitives: `and u1 (in1, in2, out);`
**3. Hard**: Design a structural 2-bit Equality Comparator ($A=B$) using only `xnor` and `and` primitives. Assume $A = {a1, a0}$ and $B = {b1, b0}$. 

## Topic 2: UDPs
**4. Easy**: Write the `table` section of a combinational UDP for a 3-input XOR gate ($Y = A \oplus B \oplus C$).
**5. Medium**: Write the state table for an RS-Latch Sequential UDP. The latch holds state if $R=0, S=0$. It sets if $S=1$, resets if $R=1$, and state is unpredictable limit (`x`) if $R=1, S=1$. 
**6. Hard**: Write the core state table for a negative-edge-triggered T-Flip-Flop (Toggles on clock falling edge if $T=1$).

## Topic 3: Dataflow Modeling 
**7. Easy**: Write a single `assign` statement for a 2-to-4 decoder's $0$th signal (`dec0`), which should be high only when `sel` is `2'b00`.
**8. Medium**: What is logically incorrect about this dataflow statement trying to select 'data1' when 'enable' is high, and bitwise ORing the result with a mask? `assign out = enable ? data1 : data0 | mask;` (Hint: Check operator precedence!)
**9. Hard**: Design a 4-input priority encoder using nested conditional operators. $D[3]$ has highest priority, $D[0]$ has lowest. If $D[3]$ is 1, output `2'b11`. If $D=\text{0000}$, output `2'b00` and assert an `idle` signal using concatenation `{idle, val}`.

---

<details>
<summary><b>Click here to reveal Answer Key</b></summary>

### Topic 1 Answers
**1. Easy**
```systemverilog
logic net1;
and (net1, A, B);
or (Y, net1, C);
```
**2. Medium**: The port ordering is incorrect. In SystemVerilog primitives, the **output** is always listed first. It should be `and u1 (out, in1, in2);`
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
**8. Medium**: According to precedence rules, Bitwise OR (`|`) evaluates *before* the Conditional operator (`?:`). Therefore, the code actually evaluates as `assign out = enable ? data1 : (data0 | mask)`. If 'enable' is high, the mask is entirely ignored! The correct notation requires parenthesis: `assign out = (enable ? data1 : data0) | mask;`
**9. Hard**
```systemverilog
assign {idle, val} = (D[3]) ? {1'b0, 2'b11} :
                     (D[2]) ? {1'b0, 2'b10} :
                     (D[1]) ? {1'b0, 2'b01} :
                     (D[0]) ? {1'b0, 2'b00} : {1'b1, 2'b00}; // D is 0000, assert idle bit
```
</details>

---
[ &larr; back to syllabus](/courses/ece251/2026/ece251-syllabus-spring-2026.html) [ &larr; back to notes](/courses/ece251/2026/ece251-notes.html)