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

[ &larr; back to syllabus](/courses/ece251/2026/ece251-syllabus-spring-2026.html) [ &larr; back to notes](/courses/ece251/2026/ece251-notes.html)