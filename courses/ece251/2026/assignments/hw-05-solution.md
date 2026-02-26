### How to use these in class:

These are the direct solutions for **Homework 5**. For the SystemVerilog sections, it is highly recommended you step through exactly *why* blocking vs non-blocking logic dictates hardware synthesis on the whiteboard. For the MIPS section, physically drawing the PC address math helps students contextualize the otherwise abstract Jump processes.

## 🔑 Answer Key: Solutions for Exercises 1-4

Below is the complete solution code and mathematical reasoning for all four exercises.

### Problem 1: Assignment Rules and Dataflow

**A) The Golden Rule Violation**
The module is using a blocking assignment (`=`) inside an edge-triggered sequential block (`always_ff @(posedge clk)`). According to SystemVerilog's **Golden Rules**, sequential hardware (like a Flip-Flop) must *always* use non-blocking assignments (`<=`). Using blocking assignments here causes a **race condition** in simulation where the `q` value updates instantly, potentially triggering cascading logic on the exact same clock edge rather than properly delaying to the next cycle.

> 📝 **Whiteboard Teaching Suggestion:**
> To visually prove *why* this dictates hardware synthesis, draw **two distinct D-Flip-Flops in series** (a shift register), where FF1 connects to FF2. 
> 
> *   **If using Blocking (`=`):** Tell the students to simulate the clock edge top-to-bottom. FF1 captures `D` and updates `Q1` *instantly*. The very next line of code, FF2 evaluates its input (`Q1`). Because it evaluates sequentially, FF2 instantly grabs the *brand new* value of `Q1` in the exact same clock cycle. The hardware synthesizer realizes the two flip-flops have collapsed into a single simultaneous wire, completely destroying the memory pipeline!
> *   **If using Non-Blocking (`<=`):** Explain that `<= `means "evaluate now, update later." On the clock edge, both FF1 and FF2 look at their inputs simultaneously. FF2 sees the *old* value of `Q1`. Only at the *end* of the clock step do the outputs actually update. Thus, the hardware properly synthesizes two distinct, pipelined memory stages.

**B) Corrected Sequential Logic**
```systemverilog
module corrected_dff (output logic q, input logic clk, d);
    always_ff @(posedge clk) begin
        q <= d; // Correct non-blocking assignment
    end
endmodule
```

**C) 2-to-4 Decoder Dataflow (`assign`)**
```systemverilog
// The logic equates to 1-bit boolean True (1) only when sel is exactly 10 in binary
assign dec[2] = (sel == 2'b10); 
```

---

### Problem 2: User-Defined Primitives (UDPs)

```systemverilog
# Solution 2: 3-Input Combinational Majority Gate UDP
primitive maj3_udp (
    output logic y,
    input  logic a, b, c
);
    // Define the full truth table mapping all 8 states
    table
        // a b c : y
        0 0 0 : 0;
        0 0 1 : 0;
        0 1 0 : 0;
        0 1 1 : 1; // b and c are 1
        1 0 0 : 0;
        1 0 1 : 1; // a and c are 1
        1 1 0 : 1; // a and b are 1
        1 1 1 : 1; // all are 1
    endtable
endprimitive
```

---

### Problem 3: MIPS 32-Bit Addressing

**A) Loading a 32-Bit Constant**
```mips
# Split 0xCAFEBABE into upper and lower 16-bit halves
lui $t0, 0xCAFE         # Load Upper Immediate: $t0 = 0xCAFE0000
ori $t0, $t0, 0xBABE    # OR Immediate:         $t0 = 0xCAFEBABE
```

**B) PC-Relative Address Calculation (`beq`)**
When the `beq` branch executes, the CPU automatically increments the Program Counter by 4 first. It then takes the 16-bit offset from the instruction and shifts it left by 2 bytes (multiplying by 4) to convert the "instruction offset" into a literal "byte offset". 

1. **Calculate `PC + 4`:** 
   `0x00400040 + 0x4 = 0x00400044`
2. **Shift Offset Left by 2 (Multiply by 4):** 
   `0x0008 * 4 = 0x0020`
3. **Add offset to `PC + 4`:** 
   `0x00400044 + 0x0020 = ` **`0x00400064`**

**The target branch address is exactly `0x00400064`.**

---

### Problem 4: Multicore Synchronization and Data Races

**A) The Failure of `lw` and `sw`**
Standard `lw` and `sw` instructions are independent from each other. In a multicore system, Thread A and Thread B might both execute `lw` simultaneously. Both threads read `0` (the lock is free). Before Thread A can execute its `sw 1` to claim the lock, Thread B executes its own `sw 1`. Both threads continue executing thinking they successfully own standard access to the memory space. This is a fatal **Data Race**. We need an *atomic* operation that cannot be interrupted.

**B) The `ll` and `sc` Hardware Solution**
MIPS provides hardware-level atomicity using these two instructions:
*   `ll` (**Load Linked**): Loads the 'lock' value from memory, but crucially, it tells the MIPS hardware to *monitor* that specific memory address.
*   `sc` (**Store Conditional**): Attempts to store the `1` to claim the lock. The hardware will **only allow the store to succeed** if no other processor/thread has written to that linked address since the original `ll` was executed. 

If the `sc` fails (meaning another thread snuck in and took the lock), MIPS sets the local register to `0`. The local program sees this failure, loops back, and simply tries the `ll` check again until it eventually secures the lock uninterrupted.

---

This complete set provides the exact code translations and mathematical reasoning for grading the Week 05 logic. If students struggle with the Addressing math, review the visual layout of the Memory map.
