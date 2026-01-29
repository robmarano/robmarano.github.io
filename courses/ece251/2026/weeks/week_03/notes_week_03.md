# Notes for Week 3
[ &larr; back to syllabus](/courses/ece251/2026/ece251-syllabus-spring-2026.html) [ &larr; back to notes](/courses/ece251/2026/ece251-notes.html)

# Topics
1. Recap: Instructions for arithmetic and for memory access
2. The map of how memory is segmented on a von Neumann computer, using MIPS32 as an example.
3. Instructions for making decisions
4. Supporting procedures (aka functions) in computer hardware

# Topic Deep Dive

## How memory is segmented on a von Neumann computer like MIPS32

### The General Purpose Computer Memory Map

Think of your computer's memory as a vast warehouse, but instead of physical goods, it stores data and instructions. A **memory map** is essentially the blueprint of this warehouse, defining how different sections are organized and used. In a **general-purpose computer**, this map typically includes several key regions:

- **Text (Code) Segment:** This is where the program's instructions reside. It's often read-only, as controlled by the kernel/OS, to prevent accidental modification by users or malware, which could lead to crashes. Think of it as the instruction manual for the CPU.

- **Data Segment:** This segment holds **global variables** and **static data**, which are allocated before the program starts execution and exist throughout its runtime. It's like the storage area for items that need to be readily available.

- **Heap:** The **heap** is a region of memory used for **dynamic memory allocation**. When your program needs to create objects or data structures during execution (using functions like `malloc` in C or `new` in C++), it requests space from the heap. This is a more flexible storage area, but it requires careful management to **avoid memory leaks**.

- **Stack:** The _stack_ is used for function (or procedure) calls and local variables. When a function is called, its parameters, local variables, and return address are pushed onto the stack. When the function returns, meaning it's finished doing its work, these items are popped off the stack, that is, freed from **stack memory** and made available to the calling function. The stack operates on a **Last-In, First-Out** (LIFO) principle, like a stack of plates.

- **Reserved Memory:** Certain memory locations are **reserved** for specific purposes, often by the **operating system** or hardware, itself. These areas are typically **off-limits to user programs** to maintain system stability. This is like the "staff only" area of our warehouse.

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

Now, let's look at how MIPS32, a popular RISC architecture often used in embedded systems and for teaching computer architecture, defines its memory map. MIPS32 has a well-defined memory map that simplifies memory management and provides a consistent environment for software development.

MIPS32's memory map is divided into several segments, but a few key ones are worth highlighting:

- **Kernel Segment** `(0x80000000 - 0xFFFFFFFF)`: This segment is reserved for the operating system kernel. User programs cannot directly access this area, ensuring system protection.

- **User Segment** `(0x00000000 - 0x7FFFFFFF)`: This is where user programs reside and execute. This segment is further subdivided, but the key divisions are:
  - **Text Segment:** Similar to the general case, this holds the program's instructions.
  - **Data Segment:** Holds global and static data.
  - **Heap:** For dynamic memory allocation.
  - **Stack:** For function calls and local variables.
  - `kseg0`, `kseg1`: These segments are for kernel data and are **cached** (`kseg0`) or **uncached** (`kseg1`), respectively.
- **Memory-Mapped I/O:** Certain memory addresses are mapped to I/O devices. When the CPU accesses these addresses, it's actually communicating with the hardware, not reading or writing to memory.

### Key Differences and Considerations for MIPS32:

- **Fixed Memory Map:** MIPS32 typically uses a more rigid and predefined memory map compared to some other architectures. This helps simplify memory management in embedded systems.
- **Kernel Space Protection:** The separation of kernel space and user space is strictly enforced, preventing user programs from interfering with the operating system.
- **Memory-Mapped I/O:** The use of memory-mapped I/O provides a consistent way for the CPU to interact with peripherals.

### How much memory in a 32-bit MIPS processor?

A 32-bit MIPS processor, being byte-addressable by design, supports $2^{32}$ memory addresses, equating to 4,294,967,296 unique memory locations, each holding a single byte of data. Since each address holds one byte, and there are $2^{32}$ addresses, the total memory is $2^{32}$ bytes. To convert this to gigabytes (GB), we know that 1 GB is equal to $2^{30}$ bytes.

Therefore, the total memory in GB is: $\Large\dfrac{ 2^{32} bytes }{2^{30}\frac{bytes}{GB}} = 2^{2} GB = 4 GB$

So, a 32-bit MIPS processor with byte addressing supports 4 GB of memory.

### Pointers to sections in the MIPS32 memory map

Let's talk about pointers in the MIPS32 memory map, focusing on the crucial frame pointer and stack pointer. Pointers, in essence, are memory addresses. They "point" to a specific location in memory, allowing you to access and manipulate data stored there. In MIPS32, like most architectures, pointers are typically 32-bit values, capable of addressing any location within the 4GB address space.

#### Stack Pointer (`$sp`):

The **stack pointer** (`$sp`) is one of the 32 registers (`R29`) that holds the address of the top of the stack. Remember, the stack **grows downwards** in memory. So, as you push data onto the stack, the stack pointer decrements. Conversely, when you pop data off the stack, the stack pointer increments.

The `$sp` is essential for managing function calls and local variables. When a function is called:

1. The return address (where to jump back to after the function finishes) is pushed onto the stack.
2. Function arguments (parameters) are often passed on the stack.
3. Space for local variables within the function is allocated on the stack by decrementing `$sp`.

Why add 4? Remember, MIPS32 is byte-addressable, so 1 word = 4 bytes to move up addresses of memory map/ladders

#### Frame Pointer (`$fp`):

The **frame pointer** (`$fp`) is another important register that points to the base of the current function's stack frame. A **stack frame** is the region of the stack dedicated to a particular function call, containing its local variables, parameters, and return address.

The `$fp` provides a stable reference point for accessing local variables and function arguments within a function, even if the stack pointer changes during the function's execution (e.g., due to pushing or popping other values). This is especially useful for debugging and for languages that support variable-length argument lists.

- **Relationship with `$sp`:** At the beginning of a function's execution, the `$fp` is typically set to a known offset from the current `$sp`. The `$sp` might change during the function's operation, but the `$fp` remains constant, providing a consistent way to access the function's data.

#### Key Differences and Usage:

- `$sp`: Dynamically changes as data is pushed and popped from the stack. It always points to the top of the stack.
- `$fp`: Generally remains constant during a function's execution. It points to a fixed location within the function's stack frame, providing a stable base for accessing local variables and parameters.

##### Why Use a Frame Pointer?

While not strictly required (some compilers optimize it away), the **frame pointer** simplifies function call management and makes debugging easier. It allows you to trace back the call stack and inspect the values of local variables at different points in the program's execution.

## Instructions for Making Decisions (Textbook &sect;2.7)

Let's shift gears and talk about decision-making in MIPS32. Arithmetic is great, but a CPU also needs to make choices – to branch, loop, and execute code conditionally. That's where decision-making instructions come in. Here's a high-level summary for you:

*   **Conditional Branches**: Allow the computer to change the flow of execution based on comparison.
    *   `beq reg1, reg2, L1`: Go to L1 if reg1 == reg2.
    *   `bne reg1, reg2, L1`: Go to L1 if reg1 != reg2.
*   **Basic Block**: A sequence of instructions without branches (except at the end) and without branch targets (except at the beginning). Compilers optimize at the basic block level.

1. **Comparison Instructions:** MIPS32 doesn't have explicit "compare" instructions that set flags like some other architectures. Instead, it uses instructions that combine comparison and branching. This might seem a bit odd at first, but it's a design choice that impacts instruction encoding and execution.
2. **Branch on Equal/Not Equal:** The most common decision-making instructions are `beq` (branch if equal) and `bne` (branch if not equal). They take three operands: two registers to compare and a branch target (an address). If the comparison is true, the program counter (`PC`) is updated to the branch target, and execution continues from there. Otherwise, execution continues sequentially. Example: `beq $t0, $t1, label`.
3. **Set Less Than:** MIPS32 provides `slt` (set less than) and `sltu` (set less than unsigned) instructions. These are not branch instructions. They perform a comparison and store the result (`1` if true, `0` if false) in a register. Example: `slt $t2, $t3, $t4`. This sets `$t2` to `1` if `$t3` < `$t4`, and `0` otherwise. You then use `beq` or `bne` with `$t2` to make a branch decision.
4. **Set Less Than Immediate:** There are also immediate versions of the "set less than" instructions: `slti` (set less than immediate) and `sltiu` (set less than immediate unsigned). These allow you to compare a register with a constant value directly.
5. **Jump Instructions:** While not strictly "decision" instructions, jumps are essential for control flow. `j` (jump) unconditionally jumps to a target address. `jr` (jump register) jumps to the address stored in a register. These are used for implementing function calls, returns, and other control flow structures.
6. **Branch Target Address Calculation:** The way the branch target address is calculated is important. In many cases, it's a **relative offset** from the current PC. This makes code more position-independent. However, for longer jumps, you might need to use a jump instruction or a more complex address calculation.
7. **No Condition Codes:** Remember, MIPS32 doesn't use condition codes (flags) set by arithmetic or comparison instructions. This means you can't directly test for zero, negative, or other conditions using dedicated branch instructions like in some other architectures. You have to use `slt`, `slti`, `beq`, and `bne` to achieve the same result.
8. **Delayed Branching:** MIPS32 uses **delayed branching**. This means that the instruction **immediately** following a branch instruction is **always executed**, before the branch takes effect. This can seem confusing at first, but it's a **performance optimization** that allows the CPU to fill the pipeline while the branch target is being calculated. You, as the programmer, need to be aware of this and either fill the delay slot with a useful instruction (often a `nop` – no operation) or arrange your code so that the instruction in the delay slot doesn't depend on the branch result.

In essence, decision-making in MIPS32 boils down to combining comparisons (using slt, slti) with conditional branching (beq, bne). The lack of condition codes and the presence of delayed branching are key characteristics you need to understand to write correct and efficient MIPS32 code. 

## Supporting Procedures (Textbook &sect;2.8)
Procedures (functions) facilitate abstraction and reuse. MIPS uses specific registers and instructions:
*   `jal` (Jump and Link): Jumps to an address and saves the return address in `$ra`.
*   `jr` (Jump Register): Jumps to the address stored in a register (usually `$ra` to return).
*   **Register Conventions**:
    *   `$a0-$a3`: Arguments.
    *   `$v0-$v1`: Return values.
    *   `$ra`: Return address.
    *   `$s0-$s7`: Saved registers (must be preserved by callee).
    *   `$t0-$t9`: Temporary registers (not preserved).
*   **The Stack**: A memory structure used to spill registers when the active procedure needs more space or calls another procedure. Grows downwards.

## Communicating with People (Textbook &sect;2.9)
*   **ASCII/Unicode**: Standards for representing characters as numbers.
*   **Byte/Halfword Operations**:
    *   `lb`/`lbu`: Load byte (signed/unsigned).
    *   `sb`: Store byte.
    *   `lh`/`lhu`: Load halfword.
    *   `sh`: Store halfword.

## MIPS Addressing for 32-Bit Immediates and Addresses (Textbook &sect;2.10)
*   **Wide Immediates**: `lui` (load upper immediate) allows loading 32-bit constants in two steps.
*   **Addressing Modes**:
    1.  **Immediate**: Operand is constant in instruction.
    2.  **Register**: Operand is a register.
    3.  **Base**: Operand is at memory location (register + constant).
    4.  **PC-Relative**: Address is PC + constant (for branches).
    5.  **Pseudodirect**: Jump address is concatenation of bits (for jumps).

## Parallelism and Instructions: Synchronization (Textbook &sect;2.11)
*   Synchronization requires atomic read-modify-write operations.
*   MIPS uses `ll` (load linked) and `sc` (store conditional) to implement atomic primitives like lock/unlock and atomic swap without locking the entire bus.

## Translating and Starting a Program (Textbook &sect;2.12)
The four steps to run C code:
1.  **Compiler**: C $\rightarrow$ Assembly Language.
2.  **Assembler**: Assembly $\rightarrow$ Machine Language (Object File). Handles pseudoinstructions.
3.  **Linker**: Combines object files and libraries into an Executable. Resolves addresses.
4.  **Loader**: Loads executable into memory and starts execution.

[ &larr; back to syllabus](/courses/ece251/2026/ece251-syllabus-spring-2026.html) [ &larr; back to notes](/courses/ece251/2026/ece251-notes.html)
