# ECE 251: Week 08 Notes - Floating-Point Architecture

## Overview
This week we transition from Chapter 2 (Instructions) directly into **Chapter 3** of our textbook ([Computer Organization and Design](/COaD-MIPS-6ed.pdf)). Until now, we have exclusively designed hardware and processed data using the **Integer Data Type** (both signed and unsigned formats). 

However, real-world engineering requires processing fractional decimal values. In these notes, we explore how computer architecture mathematically structures decimals, the limitations of Fixed-Point logic, the globally standardized **IEEE 754 Protocol**, and how MIPS manages these complex numbers using an external **Floating-Point Unit (FPU)** known as Coprocessor 1.

---

## 1. The Decimal Dilemma: Fixed vs. Floating Point
Our fundamental architectural issue is that physical memory arrays and CPU registers (like `$t0`) are rigidly built using 32 physical bits. How do we represent a decimal point `.` using only binary `0`s and `1`s?

### The Fixed-Point Approach (And Why It Fails)
The most intuitive approach is to statically define an arbitrary dividing line within our 32-bit constraint. For example, we could say the first 16 bits represent the whole integer number, and the remaining 16 bits represent the fractional decimal. 

*   **Pro:** Immediate hardware simplicity. Normal integer Addition (`add`) works natively.
*   **Con (The Fatal Flaw):** Extreme range limitation. If we divide 32 bits evenly, the maximum macro-scale number we can compute is only $2^{15} - 1 = 32,767$, and our precision for micro-scale numbers is strictly capped. In physics or graphics rendering (like the Quake example from Week 07), we need the ability to compute astronomical distances and microscopic wavelengths simultaneously. Fixed-point simply lacks the dynamic range.

### The Floating-Point Protocol (IEEE 754)
To solve this, the Institute of Electrical and Electronics Engineers ratified the **IEEE 754 Standard** in 1985. Instead of fixing the decimal in place, the hardware dynamically "floats" the decimal point based on scientific notation, maximizing both range and granular precision within the exact same 32 bits!

Standard Scientific Notation: $-1.234 \times 10^{5}$
Binary Floating Point Notation: $(-1)^{s} \times (1 + \text{Fraction}) \times 2^{(\text{Exponent} - \text{Bias})}$

MIPS implements the **Single Precision (32-bit)** format utilizing three distinct, mathematically packed fields:
1.  **Sign Bit (1 bit):** Bit 31. `1` is negative, `0` is positive.
2.  **Exponent (8 bits):** Bits 30-23. Represents the $2^{\text{power}}$. (Uses a Bias of 127).
3.  **Fraction / Mantissa (23 bits):** Bits 22-0. The precise fractional magnitude.

When packed together, the CPU can dynamically reallocate its bit-budget: if the exponent is incredibly large, the number represents cosmic distances. If the exponent is incredibly negative, the exact same 32 bits represent microscopic fractions.

---

## 2. Hardware Segregation: Coprocessor 1 (The FPU)
Floating-point arithmetic (specifically multiplication and division) requires drastically different physical silicon gates to execute than standard integer math. Combining floating-point logic and integer logic into a single monolithic ALU would create massive, slow bottlenecks in the processor datapath.

Therefore, the MIPS architecture formally delegates all decimal math to a mathematically dedicated secondary chip known as **Coprocessor 1 (CP1)**, universally referred to as the **Floating Point Unit (FPU)**.

### The FPU Register File
The FPU maintains its own separate, physically distinct memory array containing 32 independent registers (`$f0` through `$f31`). 
*   **Single Precision:** Each register natively holds exactly 32 bits.
*   **Double Precision:** The FPU pairs adjacent registers (e.g., `$f0` and `$f1`) to create massive 64-bit mathematical structures.

### Specialized FPU Instructions
Standard MIPS instructions like `add` and `lw` cannot physically access the FPU. You must explicitly command the CPU to execute FPU-specific hardware commands. Notice they append `.s` (Single-Precision) or `.d` (Double-Precision) to the instruction.

*   **Loading/Storing:** `lwc1 $f0, 0($a0)` (Load Word to Coprocessor 1)
*   **Arithmetic:** `add.s $f0, $f1, $f2` (Floating-Point Addition)
*   **Moving Data:** `mfc1 $t0, $f12` (Move *From* Coprocessor 1 into Integer CPU)

$\Rightarrow$ *For a complete execution list, refer to the "Floating-Point Instruction Formats" section on the back of your [MIPS Green Sheet](/courses/ece251/mips/MIPS_Green_Sheet.pdf).*

## 3. Representing Decimal Numbers: IEEE 754 Standard Deep Dive
*(Synthesized from Patterson & Hennessy's COaD and Hamacher's Embedded Systems)*

While the basic fields of IEEE 754 provide range and precision, the standard dictates several critical architectural details for reliable hardware evaluation:

*   **Biased Notation for Exponents:** Unlike integer calculations which use Two's Complement for negative numbers, the FPU exponent applies a **Bias (+127 for Single Precision)**. Why? It purely simplifies hardware comparison logic. A biased exponent ensures that all exponent values remain strictly positive integers in binary, allowing the CPU to use a standard, high-speed integer comparator to check which floating-point number is larger.
*   **Normalized Mantissas:** The leading `1` in the fractional component is always assumed (`1.xxxxx`). This "hidden bit" buys us one extra bit of free precision, granting 24 bits of effective accuracy in a 23-bit field.
*   **Architectural Special Values:** 
    *   **Zero:** Exponent = `00000000`, Fraction = `0`
    *   **Infinity:** Exponent = `11111111`, Fraction = `0` (Used for divide-by-zero).
    *   **NaN (Not a Number):** Exponent = `11111111`, Fraction $\neq 0$ (Used for illegal math, like taking the square root of a negative without complex logic).

### Textbook Examples: IEEE 754

**Example 1: Easy (Decimal to IEEE 754 Single Precision)**
*Problem:* Convert $-0.75_ {10}$ to IEEE 754 Single Precision binary. *(Source: COaD)*
*Solution:*
1. Calculate the binary fraction: $-0.75_ {10} = -3/4 = -0.11_ {2}$.
2. Normalize to scientific notation: $-1.1_ {2} \times 2^{-1}$.
3. Field 1 (Sign): The number is negative, so **Sign = `1`**.
4. Field 2 (Exponent): True exponent is $-1$. Add the bias: $-1 + 127 = 126$. Binary representation is **Exponent = `01111110`**.
5. Field 3 (Mantissa): Drop the leading `1` (hidden bit). The fractional remainder is just `1`. Pad with zeros: **Mantissa = `100 0000 0000 0000 0000 0000`**.
*Final 32-bit Code:* `1 01111110 10000000000000000000000` (**`0xBF400000`**)

**Example 2: Medium/Hard (Floating-Point Decimal Arithmetic)**
*Problem:* Convert $12.375_ {10}$ to IEEE 754 Single Precision.
*Solution:*
1. Define the whole number: $12_ {10} = 1100_ {2}$.
2. Define the fraction: $0.375_ {10} = 3/8 = 0.011_ {2}$.
3. Combine: $1100.011_ {2}$.
4. Normalize: $1.100011_ {2} \times 2^{3}$.
5. Calculate fields:
    *   **Sign:** Positive $\rightarrow$ **`0`**.
    *   **Exponent:** $3 + 127 = 130 \rightarrow$ **`10000010`**.
    *   **Mantissa:** Drop leading 1 $\rightarrow$ **`10001100000000000000000`**.
*Final 32-bit Code:* `0 10000010 10001100000000000000000` (**`0x41460000`**)

## 4. Literal Values in ISA Design
*(Synthesized from Harris & Harris' Digital Design and COaD)*

A critical aspect of Instruction Set Architecture (ISA) design is how to handle **Literals/Immediates**—hardcoded numbers directly embedded into the code (e.g., `addi $t0, $t0, 4` or `li $v0, 10`).

*   **Design Principle - "Make the Common Case Fast":** Statistical analysis of running programs shows that small constants (like `0`, `1`, `4`) account for over 50% of arithmetic and branching operands. Instead of storing these constants in memory and executing an expensive `lw` (Load Word) operation every time, MIPS dedicates the **I-Type Instruction Format** to embed a 16-bit literal directly inside the 32-bit instruction.
*   **The 32-bit Literal Workaround:** To maintain ISA design principles like "Good design demands good compromises" and "Simplicity favors regularity" (keeping all instructions exactly 32 bits), MIPS cannot fit a 32-bit literal inside a 32-bit instruction. When a massive literal is needed, the architecture uses a two-instruction macro (often masked by the pseudo-instruction `li`):
    1.  `lui $t0, 0x1234` (Load Upper Immediate into the top 16 bits).
    2.  `ori $t0, $t0, 0xABCD` (Bitwise OR the lower 16 bits).

### Textbook Examples: Initializing Literals

**Example 1: Easy (Base I-Type Arithmetic)**
*Problem:* Compile the C-code `A = B - 50` into a MIPS native instruction assuming `A = $s0` and `B = $s1`. *(Source: Harris & Harris)*
*Solution:*
There is no `subi` instruction in MIPS. The architecture handles negative constants using standard `addi`.
*Assembly:* `addi $s0, $s1, -50`
*Machine Encoding:*
*   Opcode (`addi`): `8` $\rightarrow$ `001000`
*   `rs` (`$s1`): `17` $\rightarrow$ `10001`
*   `rt` (`$s0`): `16` $\rightarrow$ `10000`
*   `imm` ($-50_ {10}$ in Two's Complement): `1111 1111 1100 1110`

**Example 2: Medium/Hard (Loading a 32-bit Literal)**
*Problem:* Load the enormous 32-bit hex address `0x003D0900` into integer register `$s0`. *(Source: COaD)*
*Solution:*
Because I-Type formats strictly limit immediate values to 16 bits, we cannot accomplish this in one clock cycle. We must use a two-instruction macro.
1. Load the upper 16 bits (the left half) into the top of the register:
   `lui $s0, 0x003D` *(Loads `0000 0000 0011 1101` into the upper 16 bits, clears lower bits).*
2. Splice the lower 16 bits (the right half) using Bitwise OR:
   `ori $s0, $s0, 0x0900` *(ORs `0000 1001 0000 0000` into the lower 16 bits).*
*(Note: Attempting to use `addi` instead of `ori` can fail here because `addi` sign-extends its 16-bit argument, potentially corrupting the explicit upper bit-pattern).*

## 5. Instruction Definition and Hardware Implementation
*(Synthesized from Harris & Harris and Cavanagh's HDL Fundamentals)*

How does the processor actually physically evaluate these instructions in SystemVerilog hardware? 

*   **Microarchitectural Datapath:** The physical datapath for integer instructions (like `add`) usually resolves in a single clock cycle utilizing a standard ripple-carry or carry-lookahead adder. Floating-point operations, however, require massive gate depth. The physical implementation of an FPU instruction mathematically requires distinct sequential processing states:
    1.  **Alignment:** Shift the smaller number's mantissa to the right until both exponents match perfectly.
    2.  **Execution:** Route the aligned mantissas through the fractional adder or subtractor.
    3.  **Normalization:** Shift the resulting decimal back to regain the strict `1.xxxx` leading format and adjust the exponent accordingly.
    4.  **Rounding:** Apply IEEE 754 rounding rules (Truncate, Round to Nearest Even, Round to +Inf, Round to -Inf).
*   **Verilog / FPU Bottlenecks:** Because this 4-step hardware process involves significant transistor propagation delay, FPU adders and multipliers must be deeply **pipelined** in silicon. While an integer `add` may finish in 1 cycle, an `add.s` might require 4 to 6 discrete clock cycles, and a `div.s` could halt the pipeline for 20+ cycles. This constraint highlights precisely why Coprocessor 1 must be logically segregated from the main integer datapath—if they shared the exact same clock phase logic, the floating-point latency would catastrophically cripple the entire central processing unit's throughput.

### Textbook Examples: Hardware Implementation

**Example 1: Easy (Tracing an Integer Datapath)**
*Problem:* Trace the specific microarchitectural hardware units utilized during a complete clock cycle of the instruction `add $t0, $t1, $t2`. *(Source: Hamacher / Harris)*
*Solution:*
The integer addition requires precisely defined functional units in sequence:
1.  **Instruction Memory:** Fetch the instruction located at the Program Counter (PC).
2.  **Register File (Read):** Decode instruction. Extract operands simultaneously from read ports corresponding to `$t1` and `$t2`.
3.  **ALU (Execute):** The arithmetic logic unit evaluates `$t1 + $t2` via its combinational gate datapath.
4.  **Register File (Write):** Write the ALU result back into the register file on the falling edge of the clock cycle at address `$t0` using the Write Data port.
*(Data Memory is entirely bypassed during an R-Type ALU operation).*

**Example 2: Medium/Hard (Tracing a Coprocessor 1 FPU Pipeline)**
*Problem:* Detail the sequential hardware logic utilized by the FPU to execute `add.s $f0, $f1, $f2`, highlighting why it cannot execute in a single basic clock cycle. *(Source: Cavanagh HDL / COaD)*
*Solution:*
Attempting $0.5 + (-0.4375)$ requires the FPU to perform multi-stage calculations that drastically exceed integer ALU latency.
1.  **Exponent Comparison & Alignment Shift:** The hardware unpacks the 8-bit exponents. It finds `$f1`'s exponent is $2^{-1}$ and `$f2` is $2^{-4}$. The smaller number ($-0.4375$) must be shifted dynamically to the right by 3 places so both numbers share the $2^{-1}$ power frame.
2.  **Fraction Addition:** Only once aligned can the 24-bit Mantissa ALU process the math.
3.  **Normalization Shift:** The result might have spawned a carry or absorbed a leading `1`. The hardware must shift the solution left/right until the leading `1` is perfectly normalized (`1.xxxx`), while simultaneously decrementing/incrementing the resulting Exponent field.
4.  **Rounding Hardware:** The IEEE 754 logic ensures the trailing fractional bits are properly truncated or rounded to nearest even.
Because no silicon can propagate these cascading tests and shifts instantaneously, FPUs must **pipeline** this operation, dividing it across 4 to 6 unique clock cycles to avoid crashing the CPU max clock frequency.

---

## Appendix: Additional Floating-Point Exercises

**Exercise 1: Easy (Decimal to Single & Double Precision)**
*Problem:* Convert $8.5_ {10}$ to IEEE 754 Single-Precision (32-bit) and Double-Precision (64-bit) binary formats.
*Solution:*
1. Calculate the binary fraction: $8_ {10} = 1000_ {2}$ and $0.5_ {10} = 1/2 = 0.1_ {2}$. Thus, $8.5_ {10} = 1000.1_ {2}$.
2. Normalize to scientific notation: $1.0001_ {2} \times 2^{3}$.
3. Field 1 (Sign): The number is positive, so **Sign = `0`**.
4. Single Precision (32-bit):
    *   **Exponent:** True exponent is $3$. Add the Single bias (+127): $3 + 127 = 130 \rightarrow$ **`10000010`**.
    *   **Mantissa:** Drop the leading `1`. The fractional remainder is `0001`. Pad with zeros to 23 bits $\rightarrow$ **`0001 0000 0000 0000 0000 000`**.
    *   *Final 32-bit Code:* `0 10000010 00010000000000000000000` (**`0x41080000`**)
5. Double Precision (64-bit):
    *   **Exponent:** True exponent is $3$. Add the Double bias (+1023): $3 + 1023 = 1026 \rightarrow$ **`100 0000 0010`**.
    *   **Mantissa:** Drop the leading `1`. The fractional remainder is `0001`. Pad with zeros to 52 bits $\rightarrow$ **`0001`** followed by 48 zeros.
    *   *Final 64-bit Code:* `0 10000000010 0001000000000000000000000000000000000000000000000000` (Upper: **`0x40210000`**, Lower: **`0x00000000`**)

**Exercise 2: Medium (Negative Fractional Decimal)**
*Problem:* Convert $-0.15625_ {10}$ to IEEE 754 Single and Double Precision.
*Solution:*
1. Calculate the binary fraction: $0.15625_ {10} = 5/32 = 1/8 + 1/32 = 0.125 + 0.03125 = 0.001_ {2} + 0.00001_ {2} = 0.00101_ {2}$.
2. Normalize to scientific notation: $-1.01_ {2} \times 2^{-3}$.
3. Field 1 (Sign): The number is negative, so **Sign = `1`**.
4. Single Precision (32-bit):
    *   **Exponent:** $-3 + 127 = 124 \rightarrow$ **`01111100`**.
    *   **Mantissa:** Drop leading `1` $\rightarrow$ **`0100 0000 0000 0000 0000 000`**.
    *   *Final 32-bit Code:* `1 01111100 01000000000000000000000` (**`0xBE200000`**)
5. Double Precision (64-bit):
    *   **Exponent:** $-3 + 1023 = 1020 \rightarrow$ **`011 1111 1100`**.
    *   **Mantissa:** Drop leading `1` $\rightarrow$ **`0100`** followed by 48 zeros.
    *   *Final 64-bit Code:* `1 01111111100 0100000000000000000000000000000000000000000000000000` (Upper: **`0xBFC40000`**, Lower: **`0x00000000`**)

**Exercise 3: Hard (Repeating Fraction & Rounding)**
*Problem:* Convert $0.1_ {10}$ to IEEE 754 Single and Double Precision.
*Solution:*
1. Calculate the binary fraction: $0.1_ {10}$ cannot be represented perfectly in binary. It is a repeating fraction: $0.0001100110011...\overline{0011}_ {2}$.
2. Normalize to scientific notation: $1.100110011...\overline{0011}_ {2} \times 2^{-4}$.
3. Field 1 (Sign): The number is positive, so **Sign = `0`**.
4. Single Precision (32-bit):
    *   **Exponent:** $-4 + 127 = 123 \rightarrow$ **`01111011`**.
    *   **Mantissa:** Drop the leading `1`. We need the first 23 bits: `1001 1001 1001 1001 1001 100`. The incredibly strict IEEE 754 "Round to Nearest, Ties to Even" requires us to look at the 24th bit (which is a `1`). Since it's a `1`, we must round up our 23-bit mantissa $\rightarrow$ **`1001 1001 1001 1001 1001 101`**.
    *   *Final 32-bit Code:* `0 01111011 10011001100110011001101` (**`0x3DCCCCCD`**)
5. Double Precision (64-bit):
    *   **Exponent:** $-4 + 1023 = 1019 \rightarrow$ **`011 1111 1011`**.
    *   **Mantissa:** We take the first 52 bits. Again, the 53rd bit causes us to round up the very last bit. The final field is: **`1001100110011001100110011001100110011001100110011010`**.
    *   *Final 64-bit Code:* `0 01111111011 1001100110011001100110011001100110011001100110011010` (Upper: **`0x3FB99999`**, Lower: **`0x9999999A`**)

---

**Exercise 4: Easy (IEEE 754 Binary to Decimal)**
*Problem:* Convert the following 32-bit Single-Precision binary value (`0x40D00000`) into a base-10 decimal:
`0 10000001 10100000000000000000000`
*Solution:*
1. **Sign field:** `0` $\rightarrow$ The number is Positive `$+$`.
2. **Exponent field:** `10000001` in decimal is $128 + 1 = 129$. Subtract the Single-Precision bias (127): $129 - 127 = 2$. Exponent is $2^{2}$.
3. **Mantissa field:** `101000...`. Append the hidden leading `1.`: The scientific fraction is $1.101_ {2}$.
4. **Combine:** $+1.101_ {2} \times 2^{2}$. 
5. **Shift the decimal:** Move the point to the right by 2 to multiply: $+110.1_ {2}$.
6. **Convert binary to decimal:** $(1 \times 4) + (1 \times 2) + (0 \times 1) + (1 \times 0.5) = \mathbf{6.5_ {10}}$.

**Exercise 5: Medium (IEEE 754 Hexadecimal to Decimal)**
*Problem:* In a debugger, register `$f0` contains the hex value `0xC1480000`. What base-10 decimal value does this represent?
*Solution:*
1. **Convert Hex to Binary:** `C` is `1100`, `1` is `0001`, `4` is `0100`, `8` is `1000`.
   $\rightarrow$ `1100 0001 0100 1000 0000 0000 0000 0000`
2. **Slice into Fields:**
   $\rightarrow$ `1` | `10000010` | `10010000000000000000000`
3. **Sign:** `1` $\rightarrow$ Negative `$-$`.
4. **Exponent:** `10000010` is $128 + 2 = 130$. Minus bias: $130 - 127 = 3$. Exponent is $2^{3}$.
5. **Mantissa:** Add the hidden bit to `1001`: $1.1001_ {2}$.
6. **Combine & Shift:** $-1.1001_ {2} \times 2^{3} \rightarrow -1100.1_ {2}$.
7. **Convert to Decimal:** $-(8 + 4 + 0.5) = \mathbf{-12.5_ {10}}$.

**Exercise 6: Hard (IEEE 754 Hexadecimal to Micro-Decimal)**
*Problem:* MIPS memory contains `0xBED00000`. Calculate its exact base-10 value.
*Solution:*
1. **Convert Hex to Binary:** `B` = `1011`, `E` = `1110`, `D` = `1101`, `0` = `0000`.
   $\rightarrow$ `1011 1110 1101 0000 0000 0000 0000 0000`
2. **Slice into Fields:**
   $\rightarrow$ `1` | `01111101` | `10100000000000000000000`
3. **Sign:** `1` $\rightarrow$ Negative `$-$`.
4. **Exponent:** `01111101` in decimal is $64 + 32 + 16 + 8 + 4 + 1 = 125$. Minus bias: $125 - 127 = -2$. Exponent is $2^{-2}$.
5. **Mantissa:** Add the hidden bit to `101`: $1.101_ {2}$.
6. **Combine & Shift:** $-1.101_ {2} \times 2^{-2} \rightarrow$ Move decimal left by 2 $\rightarrow -0.01101_ {2}$.
7. **Convert to base-10 Decimal:** 
   $-(0 \times 0.5 \quad+\quad 1 \times 0.25 \quad+\quad 1 \times 0.125 \quad+\quad 0 \times 0.0625 \quad+\quad 1 \times 0.03125)$
   $-(0.25 + 0.125 + 0.03125) = \mathbf{-0.40625_ {10}}$.

