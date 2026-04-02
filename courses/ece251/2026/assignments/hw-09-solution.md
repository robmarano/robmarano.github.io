# Assignment 9 Solutions

### Part 1: Datapath Logic & Component Utilization

**1. Datapath Component Pathways (Based on textbook Ex. 4.3)**

*   **A. Instruction Memory:** **100%**. 
    *   *Explanation*: The very first mandatory phase of the Execution Cycle is the Instruction Fetch. Without pulling an instruction out of the Instruction Memory using the active Program Counter, the processor literally does not know what task it is being asked to perform. 
*   **B. Data Memory:** **35%**.
    *   *Explanation*: The Data Memory unit is only electrically accessed during instructions that specifically need to read a variable from RAM or write a variable to RAM. In this instruction mix, the only memory operations are Load (`lw` at 20%) and Store (`sw` at 15%). $20\% + 15\% = 35\%$. R-Type, Branches, and Jumps actively bypass Data Memory by rejecting its output structurally.
*   **C. Sign-Extend Unit:** **50%**.
    *   *Explanation*: The Sign-Extend unit takes a 16-bit immediate value embedded inside an instruction and stretches it to 32 bits for the ALU to use in offsetting mathematics. The instructions requiring this are `lw` (20%), `sw` (15%), and `beq` (15%) because they compute 16-bit address offsets. Standard R-types (35%) do not possess an immediate field. Explicit MIPS Jump instructions (`j`) also bypass the main 16-bit sign-extender. Therefore, cumulative interaction is $20\% + 15\% + 15\% = 50\%$.

---

### Part 2: Single-Cycle Instruction Tracing

**2. Tracing the MUXes and ALU (Based on textbook Ex. 4.5)**

*   **A. MIPS Assembly Instruction Translation:**
    *   *Hex*: `0x00c6ba22`
    *   *Binary*: `0000 0000 1100 0110 1011 1010 0010 0010`
    *   *Decoding via R-Type Format:* 
        *   `Opcode` = `000000` (R-Type)
        *   `rs` = `00110` (Register 6, which is `$A2`)
        *   `rt` = `00110` (Register 6, which is `$A2`)
        *   `rd` = `10111` (Register 23, which is `$S7`)
        *   `shamt` = `01000` (8)
        *   `funct` = `100010` (34, which mathematically commands MIPS `sub`)
    *   **Answer**: `sub $s7, $a2, $a2`

*   **B. MUX Logical Values:**
    *   *Understanding the Diagram*: Refer to **Textbook Figure 4.11**, specifically the MUX controls stemming from the top main Control Unit blob.
    *   **Answer**:
        *   `ALUSrc = 0`. Because it is an R-Type `sub`, the second operand feeding the ALU must come from register `rt` (the `$A2` value from the Register File path), rather than the bottom immediate sign-extended constant line.
        *   `MemtoReg = 0`. The processor must write the result of the `sub` mathematics straight from the ALU's output wire directly back to the Register File, bypassing Data Memory .
        *   `Branch = 0`. This is an arithmetic instruction, not a `beq` instruction; the program flow will linearly not deviate from `PC + 4`.

*   **C. Final Updated Program Counter:**
    *   **Answer**: The finalized address locked in is **`0x00400014`**, which was computed by the **PC + 4 Adder** located at the top left of the Chapter 4 datapath. Because the `Branch = 0` signal triggered the highest final MUX to select the logic `0` pathway, the secondary branch-target adder generated output is physically ignored.

---

### Part 3: Timing & Critical Paths

**3. Datapath Component Latencies (Based on textbook Ex. 4.7)**

*   **A. R-Type Latency Calculation:**
    *   *Explanation*: To trace latency, follow the exact electrical path drawn traversing textbook Figure 4.11. Start at the PC, travel through Instruction Memory, down into the Registers, out the top line into the ALUSrc MUX to hit the ALU, then travel natively out of the ALU and thread back into the Register File Write port, locking the state.
    *   *Pathway:* `PC Clock-to-Q` -> `Instruction Memory` -> `Register Read` -> `ALUSrc MUX` -> `ALU` -> `MemtoReg MUX` -> `Register Setup Time`
    *   *Math:* $30 + 250 + 150 + 25 + 200 + 25 + 20$
    *   **Answer:** **700 ps**

*   **B. Load Word (`lw`) Latency Calculation:**
    *   *Explanation*: For a load word, the ALU computes an address offset. Therefore, its output must flow completely THROUGH the entire Data Memory unit sequentially before it can loop back to the Register File.
    *   *Pathway:* `PC Clock-to-Q` -> `Instruction Memory` -> `Register Read` -> `ALUSrc MUX` -> `ALU` -> `Data Memory Read` -> `MemtoReg MUX` -> `Register Setup Time`
    *   *Math:* $30 + 250 + 150 + 25 + 200 + 250 + 25 + 20$
    *   **Answer:** **950 ps**

*   **C. Universal Clock Cycle Requirement:**
    *   **Answer**: The Clock Cycle Time MUST be hard-locked at **950 ps**. 
    *   *Explanation*: In a Single-Cycle hardware design, the processor clock provides one unyielding drumbeat across the silicon. State elements exclusively capture results right on the upward edge of that beat. In order to guarantee the processor never accidentally captures a "half-finished" electrical pulse on highly complex instructions like `lw` (which takes 950 ps to clear its final wire and arrive at the Reg Setup), the entire clock cycle must be globally set to safely accommodate that longest, worst-case latency scenario. Faster instructions (like the 700ps R-Type) simply finish calculating early and physically sit electrically idle for the remaining 250ps waiting for the eventual clock pulse to trigger their write.
