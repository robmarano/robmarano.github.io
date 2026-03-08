# Assignment 1 - Solution Key

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

## Textbook Problem Solutions (Chapter 1)

### Problem 1.2
**Identify the Seven Great Ideas in Computer Architecture matching from other fields:**

*   **a. Assembly lines in automobile manufacturing** $\rightarrow$ **Performance via Pipelining**
    *(Pipelining takes a single large task and breaks it into smaller parallel stages along an assembly line).*
*   **b. Suspension bridge cables** $\rightarrow$ **Dependability via Redundancy**
    *(Multiple cables support the bridge; if one fails, the redundant cables prevent collapse).*
*   **c. Aircraft and marine navigation systems that incorporate wind information** $\rightarrow$ **Performance via Prediction**
    *(Predicting external variables allows the system to pre-correct its course, avoiding delays).*
*   **d. Express elevators in buildings** $\rightarrow$ **Make the Common Case Fast**
    *(Most traffic routes from the lobby to specific hubs. Expediting this common route speeds up global throughput).*
*   **e. Library reserve desk** $\rightarrow$ **Hierarchy of Memories**
    *(The reserve desk holds heavily referenced books immediately at hand, akin to an L1 Cache, while less popular books sit deep in the library stacks).*
*   **f. Increasing the gate area on a CMOS transistor to decrease its switching time** $\rightarrow$ **Performance via Parallelism**
    *(By increasing the gate area, more electron channels are fundamentally paralleled, lowering physical resistance and speeding up switching).*
*   **g. Building self-driving cars whose control systems partially rely on existing sensor systems already installed into the base vehicle** $\rightarrow$ **Use Abstraction to Simplify Design**
    *(Re-using abstracted lower-level sensors simplifies the high-level control design).*

### Problem 1.5
**Processor Evaluation (P1: 3.0GHz @ 1.5 CPI, P2: 2.5Ghz @ 1.0 CPI, P3: 4.0GHz @ 2.2 CPI)**

**a. Highest performance in Instructions Per Second (IPS):**
IPS = Clock Rate / CPI
*   **P1:** $3 \times 10^9 / 1.5 = 2.0 \times 10^9 \text{ IPS}$
*   **P2:** $2.5 \times 10^9 / 1.0 = \mathbf{2.5 \times 10^9 \text{ IPS}}$ **(Highest)**
*   **P3:** $4.0 \times 10^9 / 2.2 = 1.81 \times 10^9 \text{ IPS}$

**b. If execution time is 10 seconds, find Cycles and Instructions:**
Cycles = Time $\times$ Clock Rate
Instructions = Cycles / CPI
*   **P1:** Cycles = $10 \times 3.0\text{GHz} = \mathbf{30 \times 10^9 \text{ cycles}}$. Instructions = $30\text{G} / 1.5 = \mathbf{20 \times 10^9 \text{ inst}}$.
*   **P2:** Cycles = $10 \times 2.5\text{GHz} = \mathbf{25 \times 10^9 \text{ cycles}}$. Instructions = $25\text{G} / 1.0 = \mathbf{25 \times 10^9 \text{ inst}}$.
*   **P3:** Cycles = $10 \times 4.0\text{GHz} = \mathbf{40 \times 10^9 \text{ cycles}}$. Instructions = $40\text{G} / 2.2 = \mathbf{18.18 \times 10^9 \text{ inst}}$.

**c. Reduce execution time by 30% mapping a 20% CPI increase. What is the new clock rate?**
New Time = $10\text{s} \times 0.70 = 7\text{s}$.
New CPI = Old CPI $\times 1.20$.
New Clock Rate = $\frac{\text{Instructions } \times \text{ New CPI}}{7\text{s}}$
*   **P1:** $20\text{G} \times (1.5 \times 1.2) / 7 = 36\text{G} / 7 = \mathbf{5.14 \text{ GHz}}$
*   **P2:** $25\text{G} \times (1.0 \times 1.2) / 7 = 30\text{G} / 7 = \mathbf{4.29 \text{ GHz}}$
*   **P3:** $18.18\text{G} \times (2.2 \times 1.2) / 7 = 48\text{G} / 7 = \mathbf{6.86 \text{ GHz}}$

### Problem 1.7
**Global CPI and Timing (P1: 2.5GHz, P2: 3.0GHz. Mix: 10% A, 20% B, 50% C, 20% D. Tot Inst = 1.0E6)**
P1 CPIs: A=1, B=2, C=3, D=3.
P2 CPIs: A=2, B=2, C=2, D=2.

**a. Global CPI:**
*   **P1 CPI:** $(0.1 \times 1) + (0.2 \times 2) + (0.5 \times 3) + (0.2 \times 3) = 0.1 + 0.4 + 1.5 + 0.6 = \mathbf{2.6 \text{ CPI}}$
*   **P2 CPI:** $(0.1 \times 2) + (0.2 \times 2) + (0.5 \times 2) + (0.2 \times 2) = \mathbf{2.0 \text{ CPI}}$

**b. Clock Cycles and Winner:**
Cycles = Instructions $\times$ CPI
*   **P1 Cycles:** $1.0\times10^6 \times 2.6 = \mathbf{2.6 \times 10^6 \text{ cycles}}$. 
    Time = $2.6\text{M} / 2.5\text{GHz} = \mathbf{1.04 \text{ ms}}$.
*   **P2 Cycles:** $1.0\times10^6 \times 2.0 = \mathbf{2.0 \times 10^6 \text{ cycles}}$. 
    Time = $2.0\text{M} / 3.0\text{GHz} = \mathbf{0.667 \text{ ms}}$.
**P2 is Faster.**

---

## Number System Conversions

### Problem 1: Largest 32-bit binary number 
1.  **unsigned numbers:** $2^{32} - 1 = \mathbf{4,294,967,295}$
2.  **two's complement numbers:** $2^{31} - 1 = \mathbf{2,147,483,647}$
3.  **sign/magnitude numbers:** $2^{31} - 1 = \mathbf{2,147,483,647}$

### Problem 2: Smallest 16-bit binary number
1.  **unsigned numbers:** $\mathbf{0}$
2.  **two's complement numbers:** $-2^{15} = \mathbf{-32,768}$
3.  **sign/magnitude numbers:** $-(2^{15} - 1) = \mathbf{-32,767}$

### Problem 3: Convert the following unsigned binary numbers to decimal
1.  **1010:** $(1\times8) + (1\times2) = \mathbf{10}$
2.  **110110:** $(1\times32) + (1\times16) + (1\times4) + (1\times2) = \mathbf{54}$
3.  **11110000:** $(1\times128) + (1\times64) + (1\times32) + (1\times16) = \mathbf{240}$

### Problem 4: Convert the following two's complement, signed binary numbers to decimal
*(Determining the sign depends strictly on the MSB. If the MSB is 1, invert the bits, add 1, and make it negative).*
1.  **1010 (4-bit):** MSB is 1 $\rightarrow$ Negative. Invert `0101`, Add 1 $\rightarrow$ `0110` (6). Result = **-6**
2.  **110110 (6-bit):** MSB is 1 $\rightarrow$ Negative. Invert `001001`, Add 1 $\rightarrow$ `001010` (10). Result = **-10**
3.  **11110000 (8-bit):** MSB is 1 $\rightarrow$ Negative. Invert `00001111`, Add 1 $\rightarrow$ `00010000` (16). Result = **-16**

### Problem 5: 6-bit Two's Complement Operations
*Range of 6-bit two's complement is $-32$ to $+31$.*

#### Pair 1: 16 and 29
*   **$16$:** `010000`
*   **$29$:** `011101`

**Addition ($16 + 29 = 45$):**
```text
  010000
+ 011101
--------
  101101
```
The result's MSB flipped to `1` (negative `19`). Since $45 > 31$, **OVERFLOW OCCURS**.

**Subtraction ($16 - 29 = 16 + (-29)$):**
$-29$: Invert `100010`, Add 1 $\rightarrow$ `100011`
```text
  010000 
+ 100011 
--------
  110011 
```
The result `110011` is $-13$. Since $-13$ safely fits bounds, **NO OVERFLOW OCCURS.**

#### Pair 2: -26 and 19
*   **$-26$:** $+26$ is `011010` $\rightarrow$ Invert `100101` $\rightarrow$ Add 1 $\rightarrow$ `100110`
*   **$19$:** `010011`

**Addition ($-26 + 19 = -7$):**
```text
  100110
+ 010011
--------
  111001
```
The result `111001` is $-7$. It matches math perfectly! **NO OVERFLOW OCCURS.**

**Subtraction ($-26 - 19 = -26 + (-19)$):**
$-19$: Invert `101100`, Add 1 $\rightarrow$ `101101`
```text
  100110
+ 101101
--------
 1010011
```
Discard the 7th carry-out bit. The resulting 6 bits are `010011` (positive 19). Because subtracting two negative numbers resulted in a falsely positive bit sign, mathematically attempting to calculate $-45 < -32$ failed. **OVERFLOW OCCURS.**
