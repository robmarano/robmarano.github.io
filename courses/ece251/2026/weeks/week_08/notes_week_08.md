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
