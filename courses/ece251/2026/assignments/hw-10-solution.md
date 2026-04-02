---
title: ECE 251 Hardware Assignment 10 Solution Key
subtitle: Multicycle Datapath & Control FSMs
---

# HW-10 Solution Key

## Part 1: Clock Cycle Limiting Equations

### Problem 1.1: Single-Cycle Limitation
**Solution**:
In a Single-Cycle machine, the Clock Cycle Time ($T_c$) must accommodate the longest instruction path in the architecture. The longest path is the Load Word (`lw`) instruction.

The `lw` mathematical routing is: 
$$\text{Instruction Memory} \to \text{Register File (Read)} \to \text{ALU} \to \text{Data Memory} \to \text{Register File (Write)}$$
*(Note: 3 Multiplexers are traversed serially).*

$$T_c = 300\text{ ps} + 150\text{ ps} + 30\text{ ps} + 250\text{ ps} + 30\text{ ps} + 300\text{ ps} + 30\text{ ps} + 150\text{ ps}$$
$$T_c = 1240\text{ ps}$$

### Problem 1.2: Multicycle Clock Frequency
**Solution**:
In a Multicycle design, the clock cycle time is dictated by the physically longest operational stage step.

*   **Memory Stage**: $300\text{ ps}$
*   **ALU Stage**: $250\text{ ps}$
*   **Register Stage**: $150\text{ ps}$

The limiting hardware component is the Memory Access ($300\text{ ps}$). We set $T_c$ to match the limit: $T_c = 300\text{ ps}$.
To find the frequency $f_c$:
$$f_c = \frac{1}{T_c} = \frac{1}{300 \times 10^{-12}\text{ s}} \approx 3.33\text{ GHz}$$

---

## Part 2: Multicycle Datapath Tracing

### Problem 2.1: Register A and B Content (State 1)
**Solution**:
During State 1 (Instruction Decode), the machine extracts the `rs` (source) and `rt` (target) operand values from the Register File and latches them into registers `A` and `B`.
For the Store instruction `sw $t1, 100($t2)`:
*   The base address parameter `$t2` occupies the `rs` format field.
*   The payload parameter `$t1` occupies the `rt` format field.
*   **A holding register** captures the exact payload of `$t2`.
*   **B holding register** captures the exact payload of `$t1`.

### Problem 2.2: Compute Routing control (State 2)
**Solution**:
During State 2 (Execution), the ALU calculates the immediate memory target limit: `Address = A + SignExtend(Imm)`.
*   **`ALUSrcA = 1`**: Directly pipes Register `A` (holding `$t2`) into the upper ALU port.
*   **`ALUSrcB = 2 (or 10)`**: Pipes the sign-extended immediate offset (`100`) into the lower ALU port, overriding the `B` holding register route.

---

## Part 3: Architecture SystemVerilog FSM Controller

### Problem 3.1: ADDI Physical State execution mapping
**Solution**:
*   **State 0 (Fetch)**: Fetch the mapped instruction via the `PC`.
*   **State 1 (Decode)**: Decode the immediate payload.
*   **State 2 (Execute)**: The ALU calculates `A + SignExtend(Imm)`. The FSM commands `ALUOp` to `ADD`, while gating `ALUSrcA` to `$rs` and `ALUSrcB` to the immediate bus.
*   **State 3 (Write Back)**: Unlike `lw` which proceeds to Memory, `addi` triggers `RegWrite` to copy the `ALUOut` register back into the targeted register `$rt`.

### Problem 3.2: SystemVerilog Behavioral Insertion
**Solution**:

The logical sequence expands the OP-code switch block within the combinational phase of the FSM:

```systemverilog
// ... Within the next_state always_comb evaluation case(opcode) block:

// ADDI (Opcode: 001000)
6'b001000: begin 
    next_state = ADDI_EXEC; 
end
```

Then mapping the cascade down the state progression structure:

```systemverilog
// ... Within the outer-level case(state) structure:

ADDI_EXEC: begin
    next_state = ADDI_WRITEBACK;
end

ADDI_WRITEBACK: begin
    next_state = FETCH; // Return to grab internal iteration Loop
end
```

And setting the Write Flag via boolean assignment:

```systemverilog
assign regwrite = (state == R_WRITEBACK) | (state == ADDI_WRITEBACK);
```

---

## Part 4: The Origin of Pipeline Hazards (Conceptual)

### Problem 4.1: Write Stage
**Solution**: The `add` instruction writes its calculation into `$t0` during **State 4 (Write Back)**, the final stage of its execution sequence.

### Problem 4.2: Read Stage
**Solution**: The `sub` instruction attempts to read the value of `$t0` during **State 1 (Decode / Register Read)**.

### Problem 4.3: The Data Hazard
**Solution**: If the `sub` instruction follows immediately behind the `add` instruction in the pipeline, it will enter its State 1 (Decode) while the `add` instruction is only in State 2 (Execute). Because the `add` instruction will not update `$t0` until it reaches State 4, the `sub` instruction will read obsolete, incorrect data. To evaluate correctly, the `sub` instruction must **stall** (wait) for three clock cycles until `add` completes its Write Back, or the hardware must be engineered with a data-forwarding bypass path.
