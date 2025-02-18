# Notes for Week 5
[ &larr; back to syllabus](/courses/ece251/2025/ece251-syllabus-spring-2025.html) [ &larr; back to notes](/courses/ece251/2025/ece251-notes.html)

# Topics
1. Recap: Instruction for arithmetic and for memory access
2. The map of how memory is segmented on a von Neumann computer, using MIPS32 as an example.
3. Instructions for making decisions
4. Supporting procedures (aka functions) in computer hardware
5. Begin converting our instructions to control logic for computation and memory storage.

[ &larr; back to syllabus](/courses/ece251/2025/ece251-syllabus-spring-2025.html) [ &larr; back to notes](/courses/ece251/2025/ece251-notes.html)

# Topics Deep Dive
## Recap: Instruction for arithmetic and for memory access

The arithmetic instructions of the MIPS32 architecture are a cornerstone of understanding how CPUs actually do math.  Remember, we're building up from the ground floor, so understanding these fundamentals is crucial for your future work in computer architecture and embedded systems.

Here's the high-level overview of MIPS32 arithmetic instructions, focusing on the key concepts relevant to you as budding engineers and computer scientists:

1. **Register-Based Operations:** MIPS32 is a **load-store architecture**. This means arithmetic operations are performed only on data held in registers.  You can't directly manipulate values in memory with arithmetic instructions.  This is a crucial design decision that impacts performance and instruction complexity.  Think of registers as the CPU's scratchpad – quick access, limited space.
2. **Three-Operand Instructions:**  Most MIPS32 arithmetic instructions are **three-operand instructions**.  This means they take **two source registers** and **one destination register**.  The general format is `operation $rd, $rs, $rt`, where `$rd` is the destination, `$rs` is the first source, and `$rt` is the second source.  For example, `add $t0, $t1, $t2` means `$t0 = $t1 + $t2`. This consistent format simplifies instruction decoding and execution.
3. **Instruction Types and Functionality:**  MIPS32 provides a variety of arithmetic instructions, covering the basic operations:
    1. **Addition:** `add`, `addu` (unsigned), `addi` (immediate), `addiu` (unsigned immediate).<br>
  Pay close attention to the signed vs. unsigned versions. Overflow handling is different!
    2. **Subtraction:** `sub`, `subu` (unsigned). <br>
  Again, mind the signed/unsigned distinction.
    3. **Multiplication:** `mul`, `mult`, `multu`. `mult` and `multu` produce a 64-bit result, stored in the special `HI` and `LO` registers. You then use `mfhi` and `mflo` to move these parts into general-purpose registers. `mul` provides the *lower 32-bit result*.
    4. **Division:** `div`, `divu`. Similar to multiplication, `div` and `divu` produce a quotient and a remainder. The quotient is stored in `LO`, and the remainder in `HI`.
    5. **Logical Operations:** `and`, `or`, `xor`, `nor`. These perform bitwise logical operations. Crucial for manipulating data at the bit level. We'll delve into their uses later when we discuss control flow and data manipulation.
    6. **Shift Operations:** `sll` (shift left logical), `srl` (shift right logical), `sra` (shift right arithmetic).  These are essential for bit manipulation and are often used in implementing multiplication and division by powers of 2.
4. **Immediate Operands:**  Many instructions have an "immediate" version (e.g., `addi`).  This allows you to use a constant value directly in the instruction, without needing to load it into a register first.  This is a significant optimization for frequently used constants. Preparation is handled by the assembler and encoded into the machine code of the program.
5. **Overflow and Underflow:**  It's your responsibility as the programmer to handle **overflow** and **underflow** conditions.  MIPS32 provides some instructions that detect overflow (the signed versions), but it doesn't automatically throw exceptions in all cases.  Understanding the implications of signed and unsigned arithmetic is crucial to the success of your CPU design!
6. **No Condition Codes:**  Unlike some other architectures, MIPS32 does not use condition codes (flags) set by arithmetic operations.  This has implications for how you implement branching and comparisons, which we'll discuss when we cover control flow.

### Some introductory arithmetic SystemVerilog components
Let's illustrate these MIPS32 arithmetic concepts with some SystemVerilog examples.  These examples demonstrate how you might represent these operations in a hardware description language, keeping in mind that this is a simplified representation and a real MIPS32 implementation would be significantly more complex.

<details>
<summary><code>mips_alu.sv</code></summary>
{% highlight verilog %}
module mips_alu (
  input logic clk,
  input logic rst,
  input logic [4:0] opcode, // Represents the arithmetic operation
  input logic [31:0] rs,
  input logic [31:0] rt,
  output logic [31:0] rd,
  output logic overflow
);

  logic [63:0] mult_result; // For multiplication

  always_ff @(posedge clk) begin
    if (rst) begin
      rd <= '0;
      overflow <= 0;
    end else begin
      case (opcode)
        5'b00000: begin // add
          rd <= rs + rt;
          overflow <= (rs[31] == rt[31]) && (rs[31] != rd[31]); // Signed overflow check
        end
        5'b00001: begin // addu (unsigned)
          rd <= rs + rt; // No overflow check for unsigned
          overflow <= 0;
        end
        5'b00010: begin // sub
          rd <= rs - rt;
          overflow <= (rs[31] != rt[31]) && (rs[31] != rd[31]); // Signed overflow check
        end
        5'b00011: begin // subu (unsigned)
          rd <= rs - rt; // No overflow check for unsigned
          overflow <= 0;
        end
        5'b00100: begin // mul
          mult_result <= rs * rt;
          rd <= mult_result[31:0]; // Lower 32 bits
          overflow <= 0; // Simplified - real mul doesn't set overflow in this way.
        end
        5'b00101: begin // mult (signed)
          mult_result <= $signed(rs) * $signed(rt);
          rd <= mult_result[31:0];
          overflow <= 0; // Simplified
        end
        5'b00110: begin // multu (unsigned)
          mult_result <= rs * rt;
          rd <= mult_result[31:0];
          overflow <= 0; // Simplified
        end

        5'b00111: begin // div (signed)
          if (rt == 0) begin
            rd <= 'x; // Undefined result on divide by zero
            overflow <= 1; // Indicate divide by zero.
          end else begin
            rd <= $signed(rs) / $signed(rt);
            overflow <= 0;
          end
        end
        5'b01000: begin // divu (unsigned)
          if (rt == 0) begin
            rd <= 'x; // Undefined result
            overflow <= 1; // Indicate divide by zero.
          end else begin
            rd <= rs / rt;
            overflow <= 0;
          end
        5'b01001: begin // and
          rd <= rs & rt;
          overflow <= 0;
        end
        5'b01010: begin // or
          rd <= rs | rt;
          overflow <= 0;
        end
        5'b01011: begin // xor
          rd <= rs ^ rt;
          overflow <= 0;
        end
        5'b01100: begin // nor
          rd <= ~(rs | rt);
          overflow <= 0;
        end
        5'b01101: begin // sll
          rd <= rs << rt[4:0]; // Only lower 5 bits of rt are used for shift amount
          overflow <= 0;
        end
        5'b01110: begin // srl
          rd <= rs >> rt[4:0]; // Logical shift
          overflow <= 0;
        end
        5'b01111: begin // sra
          rd <= $signed(rs) >>> rt[4:0]; // Arithmetic shift
          overflow <= 0;
        end
        default: begin
          rd <= 'x; // Invalid opcode
          overflow <= 0;
        end
      endcase
    end
  end

endmodule
{% endhighlight %}
</details>

Key points about this SystemVerilog example:
1. **Simplified Representation:** This is a very basic ALU. A real MIPS32 ALU would be far more complex, handling instruction decoding, control signals, and other aspects.
2. **Opcode:** The opcode input selects the operation to be performed. In a real CPU, this would come from the instruction decoder module.
3. **Registers:** `rs` and `rt` represent the source registers, and `rd` is the destination register.
4. **Overflow:** The overflow output indicates signed overflow for addition and subtraction. Multiplication and division overflow handling is simplified here. Division by zero is also handled.
5. **Multiplication:** The `mult` and `multu` instructions produce a 64-bit result. This example uses a wider `mult_result` signal to hold this intermediate value. In a real implementation, you would then transfer the `HI` and `LO` parts of this result to separate registers using other instructions.
6. **Division:** The example shows a very basic division. Real division logic is significantly more involved.
7. **Shift Operations:** The `shift` operations use only the lower 5 bits of the `rt` register as the shift amount, as per the MIPS32 specification.
8. **Signed vs. Unsigned:** The code demonstrates the difference between signed and unsigned operations, particularly with respect to overflow detection.

## How memory is segmented on a von Neumann computer like MIPS32

### The General Purpose Computer Memory Map

Think of your computer's memory as a vast warehouse, but instead of physical goods, it stores data and instructions.  A **memory map** is essentially the blueprint of this warehouse, defining how different sections are organized and used.  In a **general-purpose computer**, this map typically includes several key regions:

* **Text (Code) Segment:** This is where the program's instructions reside. It's often read-only, as controlled by the kernel/OS, to prevent accidental modification by users or malware, which could lead to crashes. Think of it as the instruction manual for the CPU.

* **Data Segment:** This segment holds **global variables** and **static data**, which are allocated before the program starts execution and exist throughout its runtime.  It's like the storage area for items that need to be readily available.   

* **Heap:** The **heap** is a region of memory used for __dynamic memory allocation__. When your program needs to create objects or data structures during execution (using functions like `malloc` in C or `new` in C++), it requests space from the heap. This is a more flexible storage area, but it requires careful management to **avoid memory leaks**.   

* **Stack:** The *stack* is used for function (or procedure) calls and local variables. When a function is called, its parameters, local variables, and return address are pushed onto the stack. When the function returns, meaning it's finished doing its work, these items are popped off the stack, that is, freed from __stack memory__ and made available to the calling function. The stack operates on a **Last-In, First-Out** (LIFO) principle, like a stack of plates.   

* **Reserved Memory:**  Certain memory locations are **reserved** for specific purposes, often by the __operating system__ or hardware, itself.  These areas are typically **off-limits to user programs** to maintain system stability.  This is like the "staff only" area of our warehouse.

Visual Representation:

A simplified memory map might look like this:
```
+-----------------+  High Address
| Reserved Memory |
+-----------------+
|      Stack      |  Growing downwards
+-----------------+
|      Heap       |  Growing upwards
+-----------------+
|      Data       |
+-----------------+
|      Text       |
+-----------------+  Low Address
```

### MIPS32 Memory Map

Now, let's look at how MIPS32, a popular RISC architecture often used in embedded systems and for teaching computer architecture, defines its memory map.  MIPS32 has a well-defined memory map that simplifies memory management and provides a consistent environment for software development.

MIPS32's memory map is divided into several segments, but a few key ones are worth highlighting:

* **Kernel Segment** `(0x80000000 - 0xFFFFFFFF)`: This segment is reserved for the operating system kernel.  User programs cannot directly access this area, ensuring system protection.   

* **User Segment** `(0x00000000 - 0x7FFFFFFF)`: This is where user programs reside and execute. This segment is further subdivided, but the key divisions are:
  * **Text Segment:** Similar to the general case, this holds the program's instructions.
  * **Data Segment:** Holds global and static data.
  * **Heap:** For dynamic memory allocation.
  * **Stack:** For function calls and local variables.
  * `kseg0`, `kseg1`: These segments are for kernel data and are **cached** (`kseg0`) or **uncached** (`kseg1`), respectively.
* **Memory-Mapped I/O:**  Certain memory addresses are mapped to I/O devices.  When the CPU accesses these addresses, it's actually communicating with the hardware, not reading or writing to memory.

### Key Differences and Considerations for MIPS32:

* **Fixed Memory Map:** MIPS32 typically uses a more rigid and predefined memory map compared to some other architectures. This helps simplify memory management in embedded systems.
* **Kernel Space Protection:** The separation of kernel space and user space is strictly enforced, preventing user programs from interfering with the operating system.   
* **Memory-Mapped I/O:** The use of memory-mapped I/O provides a consistent way for the CPU to interact with peripherals.

### How much memory in a 32-bit MIPS processor?
A 32-bit MIPS processor, being byte-addressable by design, supports $2^{32}$ memory addresses, equating to 4,294,967,296 unique memory locations, each holding a single byte of data. Since each address holds one byte, and there are $2^{32}$ addresses, the total memory is $2^{32}$ bytes. To convert this to gigabytes (GB), we know that 1 GB is equal to $2^{30}$ bytes.

Therefore, the total memory in GB is: $\Large\dfrac{ 2^{32} bytes }{2^{30}\frac{bytes}{GB}} = 2^{2} GB = 4 GB$ 

So, a 32-bit MIPS processor with byte addressing supports 4 GB of memory.

### Pointers to sections in the MIPS32 memory map
Let's talk about pointers in the MIPS32 memory map, focusing on the crucial frame pointer and stack pointer.  Pointers, in essence, are memory addresses. They "point" to a specific location in memory, allowing you to access and manipulate data stored there.  In MIPS32, like most architectures, pointers are typically 32-bit values, capable of addressing any location within the 4GB address space.

#### Stack Pointer (`$sp`):

The **stack pointer** (`$sp`) is one of the 32 registers (`R29`) that holds the address of the top of the stack.  Remember, the stack **grows downwards** in memory. So, as you push data onto the stack, the stack pointer decrements.  Conversely, when you pop data off the stack, the stack pointer increments.

The `$sp` is essential for managing function calls and local variables. When a function is called:
1. The return address (where to jump back to after the function finishes) is pushed onto the stack.
2. Function arguments (parameters) are often passed on the stack.
3. Space for local variables within the function is allocated on the stack by decrementing `$sp`.

##### SystemVerilog Example (Conceptual Model of `$sp`):
```verilog
// Assuming 'stack_memory' is an array representing the stack
// and 'sp' is a variable holding the stack pointer value

// Push a value onto the stack
sp = sp - 4; // Decrement stack pointer (4 bytes for a word)
stack_memory[sp] = data_to_push;

// Pop a value from the stack
data_received = stack_memory[sp];
sp = sp + 4; // Increment stack pointer
```
Why add 4? Remember, MIPS32 is byte-addressable, so 1 word = 4 bytes to move up addresses of memory map/ladders

#### Frame Pointer (`$fp`):

The **frame pointer** (`$fp`) is another important register that points to the base of the current function's stack frame.  A **stack frame** is the region of the stack dedicated to a particular function call, containing its local variables, parameters, and return address.

The `$fp` provides a stable reference point for accessing local variables and function arguments within a function, even if the stack pointer changes during the function's execution (e.g., due to pushing or popping other values). This is especially useful for debugging and for languages that support variable-length argument lists.

* **Relationship with `$sp`:** At the beginning of a function's execution, the `$fp` is typically set to a known offset from the current `$sp`. The `$sp` might change during the function's operation, but the `$fp` remains constant, providing a consistent way to access the function's data.

##### SystemVerilog Example (Conceptual model of `$fp`):
```verilog
// At function entry:
fp = sp + offset_to_frame_base; // Set frame pointer

// Accessing a local variable (at a fixed offset from fp)
local_variable = stack_memory[fp + offset_to_local_variable];
```

#### Key Differences and Usage:

* `$sp`: Dynamically changes as data is pushed and popped from the stack. It always points to the top of the stack.
* `$fp`: Generally remains constant during a function's execution. It points to a fixed location within the function's stack frame, providing a stable base for accessing local variables and parameters.

##### Why Use a Frame Pointer?

While not strictly required (some compilers optimize it away), the **frame pointer** simplifies function call management and makes debugging easier.  It allows you to trace back the call stack and inspect the values of local variables at different points in the program's execution.

### Overall SystemVerilog Implications of the memory map:

When designing a MIPS32-based system in SystemVerilog, you'll need to model this memory map. You'll define address ranges for each segment and ensure that your memory controller correctly handles memory accesses based on these ranges. For instance, you could use parameterized address ranges in your SystemVerilog code to represent each segment.  You'll also need to model the behavior of the stack and heap, perhaps using arrays and pointers within your SystemVerilog testbench to simulate memory allocation and deallocation.

Understanding the MIPS32 memory map is crucial for writing correct and efficient code for MIPS-based systems.  It allows you to manage memory effectively, avoid memory leaks, and take advantage of the architecture's features.

When you're modeling a MIPS32 processor in SystemVerilog, you'll need to implement the behavior of both the `$sp` and `$fp`.  You'll typically use variables or arrays to represent the stack memory and registers, and then implement the logic for pushing, popping, and accessing data using these pointers.  You'll also need to consider how these pointers are initialized and updated during function calls and returns.

Remember, the specific usage of `$fp` can vary slightly depending on the compiler and calling conventions used.  But the fundamental principles of stack management and the role of these pointers remain consistent.

## Instructions for making decisions
Let's shift gears and talk about decision-making in MIPS32.  Arithmetic is great, but a CPU also needs to make choices – to branch, loop, and execute code conditionally.  That's where decision-making instructions come in. Here's a high-level summary for you:
1. **Comparison Instructions:**  MIPS32 doesn't have explicit "compare" instructions that set flags like some other architectures. Instead, it uses instructions that combine comparison and branching.  This might seem a bit odd at first, but it's a design choice that impacts instruction encoding and execution.
2. **Branch on Equal/Not Equal:** The most common decision-making instructions are `beq` (branch if equal) and `bne` (branch if not equal).  They take three operands: two registers to compare and a branch target (an address).  If the comparison is true, the program counter (`PC`) is updated to the branch target, and execution continues from there. Otherwise, execution continues sequentially.  Example: `beq $t0, $t1, label`.
3. **Set Less Than:**  MIPS32 provides `slt` (set less than) and `sltu` (set less than unsigned) instructions. These are not branch instructions.  They perform a comparison and store the result (`1` if true, `0` if false) in a register.  Example: `slt $t2, $t3, $t4`.  This sets `$t2` to `1` if `$t3` < `$t4`, and `0` otherwise.  You then use `beq` or `bne` with `$t2` to make a branch decision.
4. **Set Less Than Immediate:**  There are also immediate versions of the "set less than" instructions: `slti` (set less than immediate) and `sltiu` (set less than immediate unsigned).  These allow you to compare a register with a constant value directly.
5. **Jump Instructions:**  While not strictly "decision" instructions, jumps are essential for control flow. `j` (jump) unconditionally jumps to a target address. `jr` (jump register) jumps to the address stored in a register.  These are used for implementing function calls, returns, and other control flow structures.
6. **Branch Target Address Calculation:** The way the branch target address is calculated is important.  In many cases, it's a **relative offset** from the current PC.  This makes code more position-independent.  However, for longer jumps, you might need to use a jump instruction or a more complex address calculation.
7. **No Condition Codes:** Remember, MIPS32 doesn't use condition codes (flags) set by arithmetic or comparison instructions.  This means you can't directly test for zero, negative, or other conditions using dedicated branch instructions like in some other architectures.  You have to use `slt`, `slti`, `beq`, and `bne` to achieve the same result.
8. **Delayed Branching:** MIPS32 uses **delayed branching**.  This means that the instruction **immediately** following a branch instruction is **always executed**, before the branch takes effect.  This can seem confusing at first, but it's a **performance optimization** that allows the CPU to fill the pipeline while the branch target is being calculated.  You, as the programmer, need to be aware of this and either fill the delay slot with a useful instruction (often a `nop` – no operation) or arrange your code so that the instruction in the delay slot doesn't depend on the branch result.

In essence, decision-making in MIPS32 boils down to combining comparisons (using slt, slti) with conditional branching (beq, bne).  The lack of condition codes and the presence of delayed branching are key characteristics you need to understand to write correct and efficient MIPS32 code.  Now, let's look at some SystemVerilog examples of how you might represent these instructions in hardware.

Taking a sneak-peak into some SystemVerilog code for implementing some of these. Don't worry, we will deep dive in the coming weeks.
<details>
<summary><code>mips_control_unit.sv</code></summary>
{% highlight verilog %}
module mips_control_unit (
  input logic clk,
  input logic rst,
  input logic [31:0] instruction, // The MIPS instruction
  input logic [31:0] rs,
  input logic [31:0] rt,
  input logic [31:0] pc, // Current Program Counter
  output logic [31:0] next_pc, // Next Program Counter
  output logic branch_taken, // Indicates if a branch was taken
  output logic [31:0] rd_data_sel, // Data to write to rd
  output logic rd_write_enable // Enable write to rd
);

  logic [5:0] opcode;
  logic [4:0] rs_addr, rt_addr, rd_addr;
  logic [15:0] immediate;
  logic [25:0] jump_target;

  logic slt_result;

  assign opcode = instruction[31:26];
  assign rs_addr = instruction[25:21];
  assign rt_addr = instruction[20:16];
  assign rd_addr = instruction[15:11];
  assign immediate = instruction[15:0];
  assign jump_target = instruction[25:0];

  always_ff @(posedge clk) begin
    if (rst) begin
      next_pc <= '0;
      branch_taken <= 0;
      rd_data_sel <= '0;
      rd_write_enable <= 0;
    end else begin
      next_pc <= pc + 4; // Default: sequential execution (PC + 4)
      branch_taken <= 0;
      rd_write_enable <= 0;

      case (opcode)
        6'b000100: begin // beq
          if (rs == rt) begin
            next_pc <= pc + (immediate << 2); // Branch target calculation
            branch_taken <= 1;
          end
        end
        6'b000101: begin // bne
          if (rs != rt) begin
            next_pc <= pc + (immediate << 2); // Branch target calculation
            branch_taken <= 1;
          end
        end
        6'b001010: begin // slti
          slt_result <= ($signed(rs) < $signed($signed(immediate)));
          rd_data_sel <= slt_result;
          rd_write_enable <= 1;
        end
        6'b001011: begin // sltiu
          slt_result <= (rs < immediate); // Unsigned comparison
          rd_data_sel <= slt_result;
          rd_write_enable <= 1;
        end
        6'b000010: begin // j
          next_pc <= {jump_target, 2'b00}; // Jump target calculation
          branch_taken <= 1; // Treat as a branch
        end
        6'b000011: begin // jal
          next_pc <= {jump_target, 2'b00}; // Jump target calculation
          branch_taken <= 1; // Treat as a branch

        end
        6'b001100: begin // andi
          rd_data_sel <= rs & immediate;
          rd_write_enable <= 1;
        end
        6'b001101: begin // ori
          rd_data_sel <= rs | immediate;
          rd_write_enable <= 1;
        end
        6'b001110: begin // xori
          rd_data_sel <= rs ^ immediate;
          rd_write_enable <= 1;
        end
        // ... other instructions
        default: begin
          // Handle invalid opcodes or other instructions
        end
      endcase

    end
  end

endmodule
{% endhighlight %}
</details>

### Key improvements and explanations:
1. **Instruction Decoding:** The code now decodes the instruction to extract the opcode, register addresses, immediate value, and jump target.
2. **Branch Target Calculation:** The branch target address is calculated correctly, including the sign extension of the immediate value and the left shift by 2 (because MIPS32 addresses are word-aligned).
3. **`slti` and `sltiu`:** The `slti` and `sltiu` instructions are implemented, setting the `slt_result` which is then used to update the destination register.
4. **Jump Instructions:** The `j` and `jal` (jump and link) instructions are included. Note how the jump target is constructed.
5. **`andi`, `ori`, `xori`:** Added for completeness, these are often used for masking and bit manipulation in conjunction with branching.
6. **`branch_taken` Output:** This output signals whether a branch was taken. This is useful for pipeline control and performance analysis.
7. **`rd_data_sel` and `rd_write_enable`:** These outputs control the write-back stage of the pipeline, selecting the data to be written to the destination register (`rd`) and enabling the write operation. This is a more realistic representation of how data is written back in a pipelined processor (next major chapter).
8. **Delayed Branching (Implicit):** This example doesn't explicitly handle delayed branching. In a real implementation, you would need additional logic to manage the instruction in the delay slot. This is a complex topic we can cover later, but it's important to be aware of.

This SystemVerilog module is a more complete (though still simplified) representation of the control logic for handling decision-making instructions in MIPS32.  It shows how the instruction is decoded, how branch targets are calculated, and how the results of comparisons are used to control program flow.  Remember, this is still a building block. A real MIPS CPU would have a much more complex control unit, handling interrupts, exceptions, and other features.  We can expand on this as we delve into pipelined processors and more advanced topics later in chapter 3.

## Supporting procedures (aka functions) in computer hardware
TBA

## Begin converting our instructions to control logic for computation and memory storage.
TBA