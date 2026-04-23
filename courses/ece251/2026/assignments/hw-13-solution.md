# Assignment 13 - Solution Key

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

## Part 1: Cache Addressing and Geometry

### 1. Cache Fields and Configuration

**a) What is the cache block size (in words)?**
*   The offset is 5 bits (bits 4-0). Therefore, the block size in bytes = $2^5 = 32$ bytes.
*   Since 1 word = 4 bytes, the block size in words = $32 / 4 = 8$ words.

**b) How many entries (blocks) does the cache have?**
*   The index is 5 bits (bits 9-5). Therefore, the number of entries = $2^5 = 32$ entries (blocks).

**c) Ratio between total bits and data storage bits?**
*   Data storage bits per block = $32 \text{ bytes} \times 8 \text{ bits/byte} = 256 \text{ bits}$.
*   Overhead bits per block = Tag size + Valid bit = $22 \text{ bits} (31-10) + 1 \text{ bit} = 23 \text{ bits}$.
*   Total bits per block = $256 + 23 = 279 \text{ bits}$.
*   Ratio = $279 / 256 = 1.089$. (Or roughly $109\%$).

---

## Part 2: Cache Access Tracing

### 2. Direct-Mapped Cache Access

Since addresses are **word addresses** and the cache has **16 one-word blocks**:
*   Number of blocks = 16. Therefore, the Index is 4 bits ($\log_2(16) = 4$).
*   The Tag is the remaining upper bits (Address shifted right by 4).
*   Index = `Address % 16` (or the lowest 4 bits of the binary address).
*   Tag = `Address / 16`.

| Word Address (Hex) | Word Address (Decimal) | Binary Address (lowest 12 bits) | Tag | Index (Binary) | Hit/Miss |
|--------------------|------------------------|---------------------------------|-----|----------------|----------|
| `0x03`             | 3                      | `0000 0000 0011`                | 0   | `0011` (3)     | Miss     |
| `0xb4`             | 180                    | `0000 1011 0100`                | 11  | `0100` (4)     | Miss     |
| `0x2b`             | 43                     | `0000 0010 1011`                | 2   | `1011` (11)    | Miss     |
| `0x02`             | 2                      | `0000 0000 0010`                | 0   | `0010` (2)     | Miss     |
| `0xbf`             | 191                    | `0000 1011 1111`                | 11  | `1111` (15)    | Miss     |
| `0x58`             | 88                     | `0000 0101 1000`                | 5   | `1000` (8)     | Miss     |
| `0xbe`             | 190                    | `0000 1011 1110`                | 11  | `1110` (14)    | Miss     |
| `0x0e`             | 14                     | `0000 0000 1110`                | 0   | `1110` (14)    | Miss (Evicts Tag 11) |
| `0xb5`             | 181                    | `0000 1011 0101`                | 11  | `0101` (5)     | Miss     |
| `0x2c`             | 44                     | `0000 0010 1100`                | 2   | `1100` (12)    | Miss     |
| `0xba`             | 186                    | `0000 1011 1010`                | 11  | `1010` (10)    | Miss     |
| `0xfd`             | 253                    | `0000 1111 1101`                | 15  | `1101` (13)    | Miss     |

**Note:** All accesses result in Misses. The cache is initially empty (compulsory misses), and none of the addresses share the exact same tag and index consecutively or reuse data already loaded without eviction (conflict misses at index 14).

---

## Part 3: Average Memory Access Time and CPI

### 3. Cache Performance and Bottlenecks

**a) Clock rates for P1 and P2**
*   P1 Clock Rate = $1 / (0.66 \text{ ns}) = 1.515 \text{ GHz}$
*   P2 Clock Rate = $1 / (0.90 \text{ ns}) = 1.111 \text{ GHz}$

**b) Average Memory Access Time (AMAT)**
*   $\text{AMAT} = \text{Hit Time} + (\text{Miss Rate} \times \text{Miss Penalty})$
*   **P1 AMAT:** $0.66 \text{ ns} + (0.08 \times 70 \text{ ns}) = 0.66 + 5.6 = 6.26 \text{ ns}$
*   **P2 AMAT:** $0.90 \text{ ns} + (0.06 \times 70 \text{ ns}) = 0.90 + 4.2 = 5.10 \text{ ns}$

**c) Total effective CPI and processor speed**
To calculate CPI stalls, we need the Miss Penalty in terms of *cycles*, not nanoseconds.
*   P1 Miss Penalty (cycles) = $70 \text{ ns} / 0.66 \text{ ns/cycle} = 106.06 \text{ cycles}$ (round to 106)
*   P2 Miss Penalty (cycles) = $70 \text{ ns} / 0.90 \text{ ns/cycle} = 77.78 \text{ cycles}$ (round to 78)

*   $\text{Total CPI} = \text{Base CPI} + \text{Memory Stall Cycles}$
*   $\text{Memory Stall Cycles} = \text{Memory Instructions/Instruction} \times \text{Miss Rate} \times \text{Miss Penalty}$

*   **P1 CPI:** $1.0 + (0.36 \times 0.08 \times 106) = 1.0 + 3.05 = 4.05$
*   **P2 CPI:** $1.0 + (0.36 \times 0.06 \times 78) = 1.0 + 1.68 = 2.68$

To determine which processor is *faster*, we must calculate the total execution time (or Time Per Instruction):
*   $\text{Time Per Instruction} = \text{CPI} \times \text{Cycle Time}$
*   **P1 Time:** $4.05 \text{ cycles/instr} \times 0.66 \text{ ns/cycle} = 2.67 \text{ ns/instr}$
*   **P2 Time:** $2.68 \text{ cycles/instr} \times 0.90 \text{ ns/cycle} = 2.41 \text{ ns/instr}$

**Conclusion:** Even though P1 has a faster clock rate, its higher miss rate and significantly larger miss penalty in cycles causes its effective execution time per instruction to be slower. **P2 is the faster processor.**
