# Assignment 7 - Solution Key

## Answer Key

### Part 1: Advanced Assembly & Hardware Profiling

**1. The Cost of Hardware Execution**
*   **A.** **The Emulator Timing Abstraction:** Emulators like SPIM execute instructions sequentially on modern high-speed host processors. SPIM artificially parses every MIPS command natively as exactly 1 software execution "step." Therefore, executing a block sequence of 2 instructions will empirically finish 7x faster in the terminal than iterating through a loop of 14 instructions, regardless of the underlying hardware complexity being modeled.
*   **B.** **The Hardware Justification:** On physical 1999 silicon (like Pentium III or MIPS processors), instructions do *not* execute in equal 1-cycle steps as modeled by the simulator. Typical ALUs execute basic integer math (`sub`, `srl`) in natively **1 clock cycle**. However, dispatching a single-precision floating-point division instruction (`div.s`) to the FPU could catastrophically stall the entire processor pipeline for **up to 54 individual clock cycles**. Thus, trading 1 agonizing 54-cycle FPU stall for 14 rapid 1-cycle integer hardware operations yielded massive performance gains for Quake graphics rendering.

**2. Exception Handling Architecture**
*   **A. Coprocessor 0 and `.ktext`:** When a hardware exception triggers, the standard execution pipeline is interrupted and structural control securely transitions from the primary ALU/Datapath to Coprocessor 0. CP0 operates the hardware flags and natively sets the Exception PC (`EPC`) to remember the exact instruction that crashed. Control then jumps directly into the dedicated kernel text (`.ktext`) execution block at memory address `0x80000180` to evaluate the fault dynamically (like SPIM's `exceptions.s`).
*   **B. The PC Action:** The user program's `PC` (Program Counter) is fundamentally overridden and replaced with the hardcoded address of the kernel handler `0x80000180`. Execution freezes in User Space and is violently redirected to OS Kernel Space.

---

### Part 2: Final Project & Midterm Readiness

**3. ISA Design and Bit Constraints**

*   **A. Mathematical Constraints:** In a strict 32-bit width format, dedicating 24 bits exclusively to an `immediate` payload value leaves only **8 bits remaining** for the rest of the instructional logic ($32 - 24 = 8$). These 8 remaining bits must miraculously encode both the operational `opcode` (to determine what action the CPU should take) AND multiple physical register wire addresses (`rs`, `rt`, `rd` depending on your ISA style). 
*   **B. Architectural Consequence:** If you leave only 8 total bits available, and you dedicate 4 of those bits to defining an `opcode` (allowing $2^{4} = 16$ unique commands natively), you only have **4 bits remaining** for a target Register map! A 4-bit register field means your datapath can strictly support a maximum of only $2^4 = 16$ discrete registers. Contrast this to the MIPS ISA, which supports 32 physical registers because it structurally dedicates 5-bit width arrays (`rs`/`rt`/`rd`).

**4. MIPS Dataflow & Recursion (Fibonacci Sequence)**

*Note: For reference during grading, here is the student's conceptually broken code presented in the prompt:*
```assembly
fib:
    beq  $a0, 0, fib_zero
    beq  $a0, 1, fib_one
    
    # FATAL ERROR 1: Missing Stack push to save $ra, $a0, $s0
    
    addi $a0, $a0, -1      
    jal  fib               # <-- OVERWRITES EXISTING $ra IMMEDIATELY!
    
    move $s0, $v0          
    
    addi $a0, $a0, -1      
    jal  fib               # <-- OVERWRITES $ra AGAIN!
    
    add  $v0, $s0, $v0     
    
    # FATAL ERROR 2: Missing Stack pop to restore original $ra and $a0
    
    jr   $ra               # <-- TRAPPED IN INFINITE LOOP!

fib_zero:
    li   $v0, 0
    jr   $ra
fib_one:
    li   $v0, 1
    jr   $ra
```
*   **A. Hardware Overwrite:** The Return Address register (`$ra`) is definitively destroyed (overwritten). The `jal` execution natively and forcefully saves the address of the immediately following instruction (`PC + 4`) directly into `$ra`. Because calculating Fibonacci explicitly requires the procedure to call `jal` *twice internally* (once for `fib(n-1)` and again for `fib(n-2)`) without shifting that initial return branch offset into the stack, the old return marker is erased forever.
*   **B. The `jr $ra` Failure:** When the recursion bottoms out into the base case (`n=1` or `n=0`) and attempts to unfold natively, the code executes `jr $ra`. However, because the `$ra` points to the recursive block literally inside itself (the result of the internal `jal` calls) rather than the original `main` entry marker, the program enters an infinite structural loop. It will continually bounce between `jr $ra` and the inner recursively executed loops, never returning dynamically to `main`. This generates a fatal stack fault or timeout.

---

### Part 3: Architecture Translation

**5. C to MIPS Assembly Translation**

*   **Step-by-Step Logic**: Calculate the indices first. Integers require a 4-byte offset multiplication.
```assembly
    lw   $t0, 16($s7)      # $t0 = B[4]  (4 * 4 bytes = 16 offset)
    lw   $t1, 12($s7)      # $t1 = B[3]  (3 * 4 bytes = 12 offset)
    sub  $t0, $t0, $t1     # $t0 = B[4] - B[3]
    sll  $t0, $t0, 2       # Multiply index result by 4 (to get byte offset for integer array A)
    add  $t0, $t0, $s6     # $t0 = exact Base Address of A + target offset
    lw   $t1, 0($t0)       # $t1 = A[B[4] - B[3]] (load actual array value)
    add  $s0, $s1, $t1     # f = g + A[B[4] - B[3]]
```

**6. MIPS to Binary/Hex Machine Code**
*   **Target Instruction:** `sw $t5, 16($t0)`
*   **Format Type:** I-Type 
*   **Opcode (`sw`):** `43` in decimal $\rightarrow$ `10 1011` in binary.
*   **Base Register (`rs`):** `$t0` is register `8` $\rightarrow$ `0 1000` in binary.
*   **Target/Source Register (`rt`):** `$t5` is register `13` $\rightarrow$ `0 1101` in binary.
*   **Immediate Offset:** `16` $\rightarrow$ `0000 0000 0001 0000` in 16-bit binary.

**Final Compilation Alignment:**
| opcode (6 bits) | rs (5 bits) | rt (5 bits) | immediate (16 bits) |
| :---: | :---: | :---: | :---: |
| `101011` | `01000` | `01101` | `0000000000010000` |

*   **Final Binary:** `1010 1101 0000 1101 0000 0000 0001 0000`
*   **Final Hexadecimal:** `0xAD0D0010`
