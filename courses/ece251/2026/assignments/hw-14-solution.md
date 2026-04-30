# Assignment 14 - Solution Key

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

## Part 1: Error Detection and Correction

### 1. Hamming Code Parity and Syndrome Decoding

**a) What is the minimum number of parity bits required to protect a 128-bit word using the SEC/DED code?**
*   For Single Error Correction (SEC), we must satisfy $2^p \ge p + d + 1$.
*   Where $d = 128$.
*   If $p = 7$: $2^7 = 128 \ge 7 + 128 + 1 = 136$ (False)
*   If $p = 8$: $2^8 = 256 \ge 8 + 128 + 1 = 137$ (True)
*   Therefore, $p = 8$ parity bits are required for SEC.
*   To add Double Error Detection (DED), one additional overall parity bit is required.
*   **Total = 9 parity bits.**

**b) SEC correction for the hexadecimal value `0x375`:**
*   First, convert `0x375` to binary: `0011 0111 0101`. (12 bits total).
*   Map the bits to their Hamming positions (1 to 12, right to left):
    *   Pos 1 (p1): `1`
    *   Pos 2 (p2): `0`
    *   Pos 3 (d1): `1`
    *   Pos 4 (p4): `0`
    *   Pos 5 (d2): `1`
    *   Pos 6 (d3): `1`
    *   Pos 7 (d4): `1`
    *   Pos 8 (p8): `0`
    *   Pos 9 (d5): `1`
    *   Pos 10 (d6): `1`
    *   Pos 11 (d7): `0`
    *   Pos 12 (d8): `0`
*   Calculate the Even Parity equations:
    *   **P1 Check** (pos 1,3,5,7,9,11): $1+1+1+1+1+0 = 5$ (Odd $\rightarrow$ Fail $\rightarrow$ **1**)
    *   **P2 Check** (pos 2,3,6,7,10,11): $0+1+1+1+1+0 = 4$ (Even $\rightarrow$ Pass $\rightarrow$ **0**)
    *   **P4 Check** (pos 4,5,6,7,12): $0+1+1+1+0 = 3$ (Odd $\rightarrow$ Fail $\rightarrow$ **1**)
    *   **P8 Check** (pos 8,9,10,11,12): $0+1+1+0+0 = 2$ (Even $\rightarrow$ Pass $\rightarrow$ **0**)
*   The Syndrome is `P8 P4 P2 P1` = **`0101`** (Decimal **5**).
*   Therefore, **Bit 5** flipped from `0` to `1`.
*   Correct the bit: `0011 0110 0101`.
*   Convert back to hexadecimal: **`0x365`**.
*(Note to graders: The official Patterson & Hennessy solution manual contains a typo stating "bit 8 is in error" before correctly providing the `0x365` answer. Bit 5 is mathematically correct).*

---

## Part 2: Virtual Memory Tracing

### 2. TLB, Page Table, and Page Faults

The page size is 4 KB ($2^{12}$ bytes), meaning the lower 12 bits constitute the offset. The Virtual Page Number (VPN) is calculated by integer dividing the address by 4096.

**Access 1: `4669`**
*   **a)** VPN = $4669 / 4096 = \mathbf{1}$
*   **b)** TLB: Tag 1 is not present. $\rightarrow$ **TLB Miss**
*   **c)** PT: Index 1 is marked as `Disk`. $\rightarrow$ **Page Fault**
*   **d)** Because it triggers a Page Fault, the OS takes over to load it from disk. No immediate TLB eviction occurs in the hardware until the OS finishes the trap.

**Access 2: `2227`**
*   **a)** VPN = $2227 / 4096 = \mathbf{0}$
*   **b)** TLB: Tag 0 is not present. $\rightarrow$ **TLB Miss**
*   **c)** PT: Index 0 is Valid (PPN 5). $\rightarrow$ **Page Table Hit**
*   **d)** The TLB is full, so the hardware replaces the True LRU entry. The oldest entry has an LRU Age of 7 (VPN/Tag 4). The hardware **overwrites the entry for Tag 4** with the new mapping (Tag 0 $\rightarrow$ PPN 5).

**Access 3: `13916`**
*   **a)** VPN = $13916 / 4096 = \mathbf{3}$
*   **b)** TLB: Tag 3 is present and Valid. $\rightarrow$ **TLB Hit**
*   **c)** PT: The Page Table is completely bypassed (Not Accessed).
*   **d)** No replacement occurs (though its LRU age is reset to 0).

**Access 4: `34587`**
*   **a)** VPN = $34587 / 4096 = \mathbf{8}$
*   **b)** TLB: Tag 8 is not present. $\rightarrow$ **TLB Miss**
*   **c)** PT: Index 8 is marked as `Disk`. $\rightarrow$ **Page Fault**
*   **d)** No immediate replacement (OS handles the fault).

---

## Part 3: Page Table Sizing

### 3. Single-Level vs Multi-Level Overhead

**a) How many total Page Table Entries must it maintain?**
*   A 4 KB page requires 12 bits for the offset ($\log_2(4096) = 12$).
*   The Virtual Page Number (VPN) size = 43 total bits - 12 offset bits = **31 bits**.
*   A single-level page table requires a continuous array for *every* possible VPN.
*   Total PTEs = $2^{31} = \mathbf{2,147,483,648 \text{ entries}}$.

**b) How much physical memory (in GB) is consumed?**
*   Table Size = $2^{31} \text{ entries} \times 4 \text{ bytes/entry} = 2^{33} \text{ bytes}$.
*   Since $2^{30} \text{ bytes} = 1 \text{ GB}$, the table consumes **$8 \text{ GB}$** of physical memory.

**c) What percentage of DRAM is consumed, and why use Multi-Level?**
*   Percentage = $8 \text{ GB} / 16 \text{ GB} = \mathbf{50\%}$.
*   **Explanation:** A strict single-level page table is impossible on 64-bit architectures because it allocates metadata for the *entire* virtual address space linearly, wasting 50% (or more) of all physical RAM on empty page table entries. Multi-Level Page Tables solve this by organizing the table as a sparse tree, only allocating lower-level table nodes for virtual memory segments that the application has actively requested from the OS.
