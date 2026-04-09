---
title: ECE 251 Hardware Assignment 11 Solution Key
subtitle: Pipelined Datapath & Hazard Resolution
---

# HW-11 Solution Key

## Part 1: Pipelining Speedup Analysis

### Problem 1.1: Pipelined Clock Cycle
**Solution**:
In a Pipelined processor, the Clock Cycle Time ($T_c$) is determined by the physically longest architectural pipeline stage plus any latching setup overhead (pipeline register delay).

The stages are: 
*   **IF**: $200\text{ ps}$
*   **ID**: $100\text{ ps}$
*   **EX**: $200\text{ ps}$
*   **MEM**: $200\text{ ps}$
*   **WB**: $100\text{ ps}$

The limiting (longest) hardware components are IF, EX, and MEM ($200\text{ ps}$). We set $T_c$ to match this limit plus the sequential overhead.
$$T_c = 200\text{ ps} + 20\text{ ps} = 220\text{ ps}$$

### Problem 1.2: Pipelined Latency
**Solution**:
A processor divided into 5 stages running at a constrained $T_c = 220\text{ ps}$ executes every clock cycle homogeneously.
Total Latency = $5 \text{ stages} \times 220\text{ ps/stage} = 1100\text{ ps}$.

In a classic single-cycle datapath, the execution evaluates all components consecutively without padding constraints:
$$T_{unpipelined} = 200 + 100 + 200 + 200 + 100 = 800\text{ ps}.$$

Thus, pipelining increases the latency of a single, isolated instruction (from $800\text{ ps}$ to $1100\text{ ps}$) while improving total throughput dramatically via instruction overlap.

---

## Part 2: Data Hazards and Hardware Bypassing

### Problem 2.1: Discovering RAW Dependencies
**Solution**:
1.  **`sub` $\to$ `and`**: `and` depends on `$t2` computed by `sub`.
2.  **`sub` $\to$ `or`**: `or` depends on `$t2` computed by `sub`.
3.  **`sub` $\to$ `add`**: `add` depends on `$t2` computed by `sub`.
4.  **`and` $\to$ `add`**: `add` depends on `$t4` computed by `and`.

### Problem 2.2: Mapping Hardware Forwarding
**Solution**:
1.  **`sub` $\to$ `and` (`$t2`)**: Path originates from the `EX/MEM` boundary (since `sub` is 1 stage ahead in MEM when `and` is in EX) routing back into the upper ALU EX port.
2.  **`sub` $\to$ `or` (`$t2`)**: Path originates from the `MEM/WB` boundary (since `sub` is 2 stages ahead in WB when `or` is in EX) routing back into the upper ALU EX port.
3.  **`sub` $\to$ `add` (`$t2`)**: Resolved natively by the internal Register File (assuming negative-edge write routing). By the time `add` reads `$t2` in ID, `sub` has already committed it during the first half of the WB clock cycle. (No ALU forwarding paths invoked).
4.  **`and` $\to$ `add` (`$t4`)**: Path originates from the `EX/MEM` boundary (since `and` is 1 stage ahead in MEM when `add` is in EX) routing back into the upper ALU EX port.

---

## Part 3: Load-Use Stalls and SystemVerilog

### Problem 3.1: Load-Use Overlap
**Solution**:
Hardware bypassing intercepts results exactly as they are calculated. However, an `lw` instruction does not actually acquire its data target until hitting the end of the **Memory (MEM)** stage. 
If an immediately following `add` instruction relies on this target, it functionally needs the data at the start of its **Execute (EX)** stage.
When `lw` is in MEM reading the data cache, `add` is simultaneously in EX computing its ALU matrix. The data from `lw` is fetched too late to be bypassed natively "back in execution time", forcing a one-cycle hardware stall (bubble) to misalign them correctly into an `MEM/WB \to EX` forwarding structure.

### Problem 3.2: SystemVerilog Decoding Logic
**Solution**:
The internal hazard mechanism must check whether the adjacent executing instruction is performing a memory read targeting the exact `$rs` or `$rt` registers the current ID instruction requests.

Logical parameters required:
*   Did the EX stage evaluate a memory load? (`MemToRegE == 1`)
*   Does the EX register match the ID `$rs` source? (`RsD == RtE`)
*   Does the EX register match the ID `$rt` source? (`RtD == RtE`)

```systemverilog
assign lwstall = ((rsD == rtE) || (rtD == rtE)) && memtoregE;
```

---

## Part 4: Branch Prediction and Control Hazards

### Problem 4.1: Optimizations
**Solution**: 
*   **Predict-Not-Taken (Flush):** The hardware natively continues fetching chronological sequence instructions anticipating that branching flags won't trip. If the branching executes conditionally (target taken), the hardware violently sweeps the trailing, erroneously-fetched components replacing them with `NOP`s utilizing a `flush` logic pin structure.
*   **Branch Delay Slot:** The compiler intelligently evaluates instructions that physically precede the functional branch, surgically displacing one benign, independent instruction directly *after* the jump logic. This occupies the structural jump lag with natively useful execution rather than destructive `NOP`s. The compiler assumes complete computational responsibility to fill this pipeline vacuum, vastly simplifying CPU architectural logic at the expense of assembly tracking complexity.
