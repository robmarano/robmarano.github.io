# Assignment 7 - Solution Key

## Answer Key

### Part 1: Advanced Assembly & Hardware Profiling

**1. The Cost of Hardware Execution**
*   **A.** **The Simulation Illusion:** Emulators like SPIM execute instructions sequentially on modern high-speed host processors. SPIM artificially parses every MIPS command natively as exactly 1 software execution "step." Therefore, executing a block sequence of 2 instructions will empirically finish 7x faster in the terminal than iterating through a loop of 14 instructions, regardless of the underlying hardware complexity being modeled.
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
