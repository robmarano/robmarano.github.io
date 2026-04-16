# ECE 251 Final Project: Building a Pipelined Von Neumann Computer

This guide provides step-by-step instructions on how to build a complete, 5-stage pipelined MIPS32 processor from scratch. By following these five phases, you will implement all components of a classical Von Neumann computer: **CPU, Memory, Datapath, Input, and Output.**

---

## Phase 1: The Foundation (Basic ISA & ALU)
**Goal:** Implement the Arithmetic Logic Unit and basic combinational building blocks.

1.  **Combinational Components:** Start by creating the stateless modules that will drive your datapath.
    *   `adder.sv`: A simple 32-bit behavioral adder.
    *   `mux2.sv`, `mux3.sv`, `mux4.sv`: Multiplexers for path selection.
    *   `sl2.sv`: Shift-left-by-2 for branch address calculation.
    *   `signext.sv`: Sign-extending 16-bit immediates to 32 bits.
    *   `eqcmp.sv`: An equality comparator for branch resolution in the Decode stage.
2.  **The ALU (`alu.sv`):** Build a 32-bit ALU that supports:
    *   `AND`, `OR`, `ADD`, `NOR`, `SUB`, `SLT`.
    *   **Sequential Logic:** Multi-cycle multiplication (`MULT`) and division (`DIV`) results stored in a 64-bit `HiLo` register on the `negedge clk`.
    *   **Control Mapping:** Use a **4-bit `alucontrol`** signal to avoid collisions between instructions (e.g., `mult` vs `nor`).
3.  **ALU Decoder (`aludec.sv`):** Map MIPS `funct` codes and `aluop` signals to your 4-bit `alucontrol` lines.

---

## Phase 2: The Datapath & Storage (State Elements)
**Goal:** Implement registers and the structural stages of the pipeline.

1.  **Storage Elements:**
    *   `dff.sv`: A standard 32-bit D Flip-Flop.
    *   `flopenr.sv` / `flopenrc.sv`: Flip-flops with Enable and Synchronous Clear (crucial for stalling and flushing).
    *   `regfile.sv`: A three-ported 32-word register file.
2.  **Assembly of the Datapath (`datapath.sv`):**
    *   **IF (Fetch):** Logic for `pcnext` (handling Jump, Branch, and Exception vectors).
    *   **ID (Decode):** Local branch evaluation using `eqcmp` to minimize branch delay.
    *   **EX (Execute):** ALU operations and the `EPC` (Exception Program Counter) register.
    *   **MEM (Memory):** Data memory access stage.
    *   **WB (Writeback):** Result selection and register file commits.
3.  **Exception Logic:** In the Execute stage, capture `pcplus4D - 4` into the `EPC` register when `Exception_Flag` is high to ensure precise interrupt recovery.

---

## Phase 3: The Brain (CPU Control & Hazard Unit)
**Goal:** Implement the logic that steers data and resolves timing conflicts.

1.  **Main Decoder (`maindec.sv`):** Translate opcodes into 9-bit control vectors (RegWrite, RegDst, AluSrc, Branch, MemWrite, MemToReg, Jump, AluOp).
2.  **Hazard Unit (`hazard.sv`):** This is the most complex part of a pipelined CPU.
    *   **Forwarding:** Route data from the MEM and WB stages back to the EX stage to resolve RAW hazards without stalling.
    *   **Stalling:** If a `lw` instruction is followed by a dependent instruction, assert `stallF` and `stallD` while asserting `flushE` to insert a bubble.
    *   **Flushing:** If an interrupt (`intr`) occurs, assert `flushD` and `flushE` to scrub instructions currently in the pipeline.

---

## Phase 4: The System Bus (Memory, Input & Output)
**Goal:** Connect your CPU to the outside world.

1.  **Memory Subsystem:**
    *   `imem.sv`: Instruction memory (Harvard Architecture). Use `parameter r = 8` for a 256-word depth.
    *   `dmem.sv`: Data memory.
2.  **The Computer Wrapper (`computer.sv`):** Connect the CPU's PC to I-Mem and its ALU result/WriteData to D-Mem.
3.  **I/O Mapping:**
    *   **Input:** The `intr` pin is your primary asynchronous input. When HIGH, it triggers the hardware exception vector.
    *   **Output:** Monitor memory writes to specific addresses (e.g., `84` and `88`) to verify program success.
4.  **Hardware Exception Vector:** Hardcode the redirection address to `32'h8000_0180` in the datapath.

---

## Phase 5: Software Ecosystem & Testing
**Goal:** Translate code and verify the hardware.

1.  **Assembler (`assembler.py`):** Use the Python script to translate `.asm` MIPS files into `.exe` hex files.
2.  **Programming the OS Handler:**
    *   Write a test program with a `.org 0x180` section.
    *   The handler should perform a recognizable action (e.g., setting `$k0 = 999`) to prove the interrupt worked.
3.  **Simulation & Verification:**
    *   Use the `Makefile` to compile the SV source with `iverilog`.
    *   Run the simulation with `vvp +PROG=your_program.exe`.
    *   **Waveform Analysis:** Use **Surfer** or **VS Code** to inspect `tb_exceptions.vcd`. Track `pcF`, `intr`, `Exception_Flag`, and `EPC` to verify the pipeline flush at 105ns.

---

### Reference Implementation
All verified source code can be found in the `reference_src/` directory. Use these files to compare your implementation against a working 5-stage pipelined model.
