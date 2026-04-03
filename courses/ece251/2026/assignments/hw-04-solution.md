# Assignment 4 - Solution Key

< 5 points >

<details>
<summary>Homework Pointing Scheme</summary>

| Total points | Explanation |
| -----------: | :--- |
| 0 | Not handed in |
| 1 | Handed in late |
| 2 | Handed in on time, not every problem fully worked through and clearly identifying the solution |
| 3 | Handed in on time, each problem answered a boxed answer, each problems answered with a clearly worked through solution, and **less than majority** of problems answered correctly |
| 4 | Handed in on time, **majority** of problems answered correctly, each solution boxed clearly, and each problem fully worked through |
| 5 | Handed in on time, every problem answered correctly, every solution boxed clearly, and every problem fully worked through. |

</details>

---

## Part 1: MIPS ISA Review

### 1. Machine Code Translation

**a) `add $t0, $s1, $s2`**
*   **Format:** R-Type
*   **Fields:** Opcode: `0` (`000000`), `rs` ($s1): `17` (`10001`), `rt` ($s2): `18` (`10010`), `rd` ($t0): `8` (`01000`), `shamt`: `0` (`00000`), `funct` (add): `32` (`100000`)
*   **32-bit Binary:** `000000 10001 10010 01000 00000 100000`
*   **8-digit Hexadecimal:** `0x02324020`

**b) `lw  $t0, 32($s3)`**
*   **Format:** I-Type
*   **Fields:** Opcode: `35` (`100011`), `rs` ($s3): `19` (`10011`), `rt` ($t0): `8` (`01000`), `immediate`: `32` (`0000 0000 0010 0000`)
*   **32-bit Binary:** `100011 10011 01000 0000000000100000`
*   **8-digit Hexadecimal:** `0x8E680020`

---

### 2. Memory Addressing & Endianness
Data: `0x12345678` at `0x10000000`.

**a) Big Endian byte at `0x10000000`:**
`0x12`. Big Endian structurally stores the Most Significant Byte (MSB) exactly at the lowest numerical memory address boundary.

**b) Little Endian byte at `0x10000000`:**
`0x78`. Little Endian structurally maps the Least Significant Byte (LSB) into the lowest numerical address boundary.

**c) PC-Relative vs Base Addressing:**
*   **PC-Relative Addressing:** Natively calculates physical target addresses by dynamically adding the 16-bit Immediate offset directly to the actively incrementing `$PC` (`Next Instruction = PC + 4 + (offset << 2)`). Used aggressively by branches (`beq`).
*   **Base Addressing:** Natively calculates target addresses by pulling an explicit physical address mapped inside a native **Register** (the Base Register) and strictly summing it with the Immediate offset (`Address = Register[rs] + offset`). Used exclusively by memory flow (`lw`, `sw`). Base Addressing therefore solely relies on a Register map.

---

### 3. Procedure Call Stack Frames

**a) Register Saving Protocol (`$s0`, `$s1`, `$t0`, `$ra`)**
*   `$ra`: **MUST** be saved in the prologue. Because `foo` natively calls `bar` using `jal`, the hardware will violently overwrite the current `$ra` with `foo`'s internal memory jump, permanently wiping out `foo`'s ability to return strictly to `main`.
*   `$s0`, `$s1`: **MUST** be saved in the prologue. According to strict MIPS Call convention, 'S' registers are inherently "Callee-Saved". If `foo` (the callee) wishes to dynamically alter `$s0` or `$s1`, it assumes structural responsibility for explicitly saving their original values to the Stack prior to execution, and aggressively restoring them prior to returning.
*   `$t0`: **DOES NOT** belong in the initial prologue! 'T' registers are "Caller-Saved". If `foo` temporarily values the data inside `$t0`, it must structurally push it to the stack *immediately before* executing `jal bar`, because `bar` inherently operates entirely freely without owing any guarantee of preserving `T` block data.

**b) Prologue MIPS Assembly**
```mips
foo:
    addi $sp, $sp, -12    # Dynamically allocate 3 vertical Stack plates (12 bytes)
    sw   $ra, 8($sp)      # Physically preserve the Return Address
    sw   $s0, 4($sp)      # Physically preserve Callee-Saved Register 0
    sw   $s1, 0($sp)      # Physically preserve Callee-Saved Register 1
    
    # ... (body of foo executes) ...
```

---

## Part 2: SystemVerilog Fundamentals

### 4. Building a Datapath Component: The Multiplexor

**a) 2-to-1 Multiplexor (Dataflow)**
```systemverilog
module mux2 #(parameter WIDTH=32) (
    input  logic [WIDTH-1:0] d0, d1,
    input  logic             s,
    output logic [WIDTH-1:0] y
);
    // Dataflow modeling mapping the ternary conditional layout
    assign y = s ? d1 : d0;
endmodule
```

**b) 4-to-1 Multiplexor (Structural)**
```systemverilog
module mux4 #(parameter WIDTH=32) (
    input  logic [WIDTH-1:0] d0, d1, d2, d3,
    input  logic [1:0]       s,
    output logic [WIDTH-1:0] y
);
    logic [WIDTH-1:0] low_out, high_out;
    
    // Structural instantiation mathematically fusing 3 discrete MUX2 gates
    mux2 #(WIDTH) mux_low  (.d0(d0), .d1(d1), .s(s[0]), .y(low_out));  // Target branch 0 vs 1
    mux2 #(WIDTH) mux_high (.d0(d2), .d1(d3), .s(s[0]), .y(high_out)); // Target branch 2 vs 3
    mux2 #(WIDTH) mux_final(.d0(low_out), .d1(high_out), .s(s[1]), .y(y)); // Elect final path natively dependent on MSB
endmodule
```

---

### 5. Building a State Element: The Program Counter (PC)

```systemverilog
module register_n #(parameter WIDTH=32) (
    input  logic             clk,
    input  logic             rst_n,
    input  logic             en,
    input  logic [WIDTH-1:0] d,
    output logic [WIDTH-1:0] q
);
    // Sequential State element requiring rigid Clock synchronization constraints
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) 
            q <= {WIDTH{1'b0}};  // Explicitly vector clearing all bits natively to 0
        else if (en)
            q <= d;              // Physically mapping the input payload precisely on Pos-Edge logic
    end
endmodule
```
