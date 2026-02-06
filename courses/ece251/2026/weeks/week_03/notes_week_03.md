# Notes for Week 3
[ &larr; back to syllabus](/courses/ece251/2026/ece251-syllabus-spring-2026.html) [ &larr; back to notes](/courses/ece251/2026/ece251-notes.html)

# Topics
1. Recap: Instructions for arithmetic and for memory access
2. The map of how memory is segmented on a von Neumann computer, using MIPS32 as an example.
3. Instructions for making decisions
4. Supporting procedures (aka functions) in computer hardware

# Topic Deep Dive

## How to Program MIPS Assembly: Arithmetic & Memory Access

**Reference:** *Computer Organization and Design*, Sections 2.5 – 2.6 and said sections in[Prof. Marano's Notes](/courses/ece251/2026/Prof_Marano_Course_Notes-Intro_Comp_Arch.pdf)

### Part 1: Translating Assembly to Machine Language (Section 2.5)
In Week 2, we learned the *vocabulary* (instructions like `add`, `lw`). Now we define the *grammar*—how these instructions are physically represented in the hardware as 32-bit binary numbers. This is the **Stored-Program Concept**: instructions are just numbers stored in memory.

#### 1. The MIPS Instruction Formats
To balance "Simplicity favors regularity" with "Good design demands good compromise," MIPS uses three specific instruction formats. All instructions are exactly 32 bits long.

##### **A. R-Type (Register Format)**
Used for arithmetic and logical instructions that use three registers (e.g., `add`, `sub`, `and`, `or`, `slt`).

| Field | **op** | **rs** | **rt** | **rd** | **shamt** | **funct** |
| :--- | :---: | :---: | :---: | :---: | :---: | :---: |
| **Bits** | 6 | 5 | 5 | 5 | 5 | 6 |

*   **op (Opcode):** Basic operation. For R-Type, this is always **0**.
*   **rs:** The first source register operand.
*   **rt:** The second source register operand.
*   **rd:** The destination register (where the result goes).
*   **shamt:** Shift amount (used only for shift instructions; **0** for math).
*   **funct:** Function code. This selects the specific variant of the operation (e.g., `add`=32, `sub`=34) given that `op` is 0.

**Example Translation:** `add $t0, $s1, $s2`
*   **Map Registers:** `$s1`=17, `$s2`=18, `$t0`=8.
*   **Fields:** op=0, rs=17, rt=18, rd=8, shamt=0, funct=32.
*   **Binary:** `000000 10001 10010 01000 00000 100000`.

##### **B. I-Type (Immediate Format)**
Used for data transfer (`lw`, `sw`) and immediate arithmetic (`addi`, `andi`). This format handles cases where we need a constant or an address offset.

| Field | **op** | **rs** | **rt** | **constant / address** |
| :--- | :---: | :---: | :---: | :---: |
| **Bits** | 6 | 5 | 5 | 16 |

*   **op:** The opcode value identifies the instruction (e.g., `lw`=35, `sw`=43, `addi`=8).
*   **rs:** The base register (for memory) or source register.
*   **rt:**
    *   For **Loads (`lw`)**: The *destination* register.
    *   For **Stores (`sw`)**: The *source* register (data to be stored).
*   **constant:** A 16-bit signed integer (range -32,768 to +32,767).

**Example Translation:** `lw $t0, 32($s3)`
*   **Analysis:** Base register is `$s3` (19). Destination is `$t0` (8). Offset is 32.
*   **Fields:** op=35, rs=19, rt=8, address=32.
*   **Binary:** `100011 10011 01000 0000000000100000`.

### Part 2: Logical Operations (Section 2.6)
Logical instructions allow us to operate on bits within a word (packing/unpacking data) rather than treating the word as a single integer.

#### 1. Shift Operations (R-Type)
Shifting moves all bits in a word to the left or right, filling the empty spots with 0s.
*   **sll (Shift Left Logical):** Moves bits left. Mathematically equivalent to multiplying by $2^i$.
    *   *Example:* `sll $t2, $s0, 4` (Reg `$t2` = `$s0` << 4).
    *   *Encoding:* The `rs` field is unused (0). The shift amount goes into the **shamt** field.
*   **srl (Shift Right Logical):** Moves bits right. Mathematically equivalent to dividing by $2^i$ (for unsigned numbers).

#### 2. Bitwise Operations
*   **AND (`and`, `andi`):** Used for **masking**. It isolates bits by forcing 0s where the mask is 0.
*   **OR (`or`, `ori`):** Used to combine bits. It places 1s where the mask is 1.
*   **NOR (`nor`):** Used to invert bits. MIPS does not have a NOT instruction.
    *   *Implementation:* To invert register `$t1`, use `nor $t0, $t1, $zero`. (A NOR 0 = NOT A).

#### 3. Immediate Logic Differences
*   **Arithmetic (`addi`):** Uses **sign-extension** (copies the sign bit) to fill the upper 16 bits of the 32-bit register.
*   **Logical (`andi`, `ori`):** Uses **zero-extension** (fills upper 16 bits with 0s) because we treat the data as a collection of bits, not a signed number.

### Part 3: Handling Large Constants (Section 2.10)
Since the I-Format only allows for 16-bit constants, we cannot load a full 32-bit address or large integer in a single instruction. We must construct it in two steps using the `lui` (Load Upper Immediate) instruction.

**Algorithm to load 32-bit constant:**
1.  **`lui $s0, 61`**: Loads the upper 16 bits (decimal 61) into the left half of `$s0` and clears the lower half to 0s.
2.  **`ori $s0, $s0, 2304`**: logically ORs the lower 16 bits (decimal 2304) into the register.

*Note:* The assembler often handles this via the pseudoinstruction `li` (load immediate), splitting it into `lui` and `ori` automatically, using the reserved register `$at`.

Let's do some examples on your computer. Follow this [link](#coding) for our programs.

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

# <a id="coding">Examples of using the Assembler (`spim`)</a>

Based on the course syllabus, **Week 3** focuses on **"Instructions — The Language & Grammar of Computers (Part 2),"** covering logical operations, decision making, and procedures.

Here is a series of MIPS assembly programs designed for the **SPIM** emulator. These examples progress from basic memory and arithmetic operations (Textbook &sect;2.2&ndash;&sect;2.6) to control flow (&sect;2.7) and finally procedures (&sect;2.8&ndash;&sect;2.9).

## General Steps to Writing Assembly Code and Running it on `spim`

To see how instructions are loaded and view memory, we will:

1. **Write a simple MIPS assembly file** (`.s`).
2. **Load it into SPIM.**
3. **Use the `step` command** to watch the Program Counter (PC) move.
4. **Examine the Data Segment** to see how variables are stored in RAM.

### The Memory Layout

When you load code, SPIM divides memory into specific sections:

* **Text Segment:** Where your machine code (instructions) lives.
* **Data Segment:** Where your static variables live.
* **Stack Segment:** For dynamic data during function calls.

### Emulation Tools to Run MIPS Code

There are several tools to run MIPS code, but we will use **SPIM** (Simple Program Interpreter for MIPS). SPIM is a simulator that allows you to run MIPS code and examine the memory and registers. It is available for Windows, macOS, and Linux. You can download it from the [SPIM website](https://www.cs.cmu.edu/~spim/). You can also use **QEMU** (Quick Emulator) to run MIPS code. QEMU is a simulator that allows you to run MIPS code and examine the memory and registers. It is available for Windows, macOS, and Linux. You can download it from the [QEMU website](https://www.qemu.org/). Additionally, you can use https://shawnzhong.github.io/JsSpim/ to run MIPS code in your browser.

### The Code: `example.s`

Let's create a simple script that adds two numbers and stores them in memory.

```mips
# -------------------------------------------------------------------
# Program: Simple Addition
# Purpose: Demonstrate memory loading and instruction execution
# -------------------------------------------------------------------

.data
    val1: .word 10          # Store the number 10 in memory
    val2: .word 20          # Store the number 20 in memory
    res:  .word 0           # Space for the result

.text
.globl main

main:
    # 1. Load val1 from memory into register $t0
    lw $t0, val1            
    
    # 2. Load val2 from memory into register $t1
    lw $t1, val2            
    
    # 3. Add registers $t0 and $t1, store in $t2
    add $t2, $t0, $t1       
    
    # 4. Store the result back into the 'res' memory location
    sw $t2, res             

    # Exit the program (SPIM syscall for exit)
    li $v0, 10
    syscall
```

### How to Inspect Instructions and Memory

If you are using the command-line `spim`, follow these steps in your terminal:

1. **Launch SPIM:** Type `spim`.
2. **Load your file:** `load "example.s"`
3. **Examine Instructions:** Type `re` (read/print registers). You will see the **PC (Program Counter)** pointing to the first instruction.
4. **Step through code:** Type `step`. SPIM will show you the exact instruction being executed.
5. **View Memory:** * To see the **Data Segment** (where `val1` and `val2` are), type: `dump`.
* This will show you the hexadecimal addresses and the values stored there (e.g., `0x0000000a` for 10).

> **Pro Tip:** In the `step` mode, watch the **PC** register. Every time an instruction is loaded, the PC usually increments by 4 bytes, as MIPS instructions are fixed at 32-bit lengths.

To see the value of `res` in memory using the command-line version of **spim**, you need to inspect the **Data Segment**.

In MIPS, global variables defined under `.data` are stored starting at a specific base address, usually `0x10010000`.

### Finding the Address

When you define variables in your code, SPIM assigns them sequential addresses in memory:

| Variable | Offset | Estimated Address |
| --- | --- | --- |
| `val1` | 0 bytes | `0x10010000` |
| `val2` | 4 bytes | `0x10010004` |
| `res` | 8 bytes | `0x10010008` |

### Using the `print` Command

Once you have run your program (or stepped through the `sw $t2, res` instruction), you can view the memory content directly in the terminal.

#### The Syntax

To view a specific memory address, use the `print` command followed by the address:

```bash
(spim) print 0x10010008
```

#### The `dump` Command

If you aren't sure of the exact address, you can view the entire data segment:

```bash
(spim) dump
```

This will output a block of hexadecimal values. You will look for the line starting with `[0x10010000]`. If your code successfully added 10 and 20, the third word in that row (at offset `+8`) should change from `00000000` to `0000001e` (which is 30 in hexadecimal).

### Step-by-Step Execution Trace

To verify the value is actually being stored, follow this sequence in your terminal:

1. **Run the program:** Type `run`.
2. **Print the memory:** Type `print 0x10010008`.
3. **Check the output:** SPIM should return `30` (or `0x0000001e`).

#### Important Note on Big/Little Endian

If you are on an **Apple Silicon Mac** or **ARM-based computer**, your system is **Little-Endian**. SPIM adopts the endianness of the host machine. This means the bytes might look "flipped" if you were to look at them individually, but the `print` command will handle the conversion and show you the integer correctly.

### Summary of Commands

| Command | Action |
| --- | --- |
| `step` | Execute one instruction (watch the registers change). |
| `print_all_regs hex` | Show all registers (to see if `$t2` holds 30). |
| `print addr` | Show the value at a specific memory address. |
| `dump` | Show a large chunk of the data segment memory. |

### Saving the Memory Dump to a File

When you use the `dump` command in the `spim` console, it prints to the screen. To use external CLI tools like `od` (octal dump) or `hexdump`, you first need to tell `spim` to save that memory state to a physical file on your Mac.

Inside the `spim` interface, use the `dump` command with a filename argument. This exports the current state of memory into a binary format.

1. Open `spim` and load your code.
2. Run your instructions so `res` is updated.
3. Execute:
```bash
(spim) dump "spim.dump"
```

4. Exit `spim` using `exit` or `quit`.

### Analyzing with `od` and `hexdump`

Now that you have a file named `spim.dump` in your directory, you can use standard Unix terminal tools to inspect it.

#### Using `hexdump` (Recommended)

`hexdump` is often more readable for MIPS because you can group bytes into 4-byte "words" (the size of a MIPS instruction/integer).

```bash
hexdump -C spim.dump
```

* **`-C`**: Displays "Canonical" hex+ASCII output.
* The first column is the offset, the middle is the hex data, and the right side is the ASCII representation.

#### Using `od` (Octal Dump)

To see the decimal values (like your result `30`) directly from the file, use:

```bash
od -t d4 spim.dump
```

* **`-t d4`**: Interprets the data as **signed decimal integers** in **4-byte** chunks.

### Interpreting the Output

The dump file contains the entire address space, so it can be quite large. You need to look for the **Data Segment offset**.

In MIPS, the data segment usually starts at `0x10010000`. In a file dump, you will often find your data after the "header" or empty space.

| Hex Offset in File | Value (Hex) | Value (Decimal) | MIPS Variable |
| --- | --- | --- | --- |
| `0000000` | `0000000a` | `10` | `val1` |
| `0000004` | `00000014` | `20` | `val2` |
| `0000008` | `0000001e` | `30` | `res` |

> **Note:** Because ARM-based computers are **Little-Endian**, if you look at the raw bytes using `od -t x1` (1-byte hex), you will see `1e 00 00 00` instead of `00 00 00 1e`. Using `d4` or `x4` tells the tool to treat them as 32-bit words, which fixes the ordering for you.

### Quick CLI Shortcut

If you want to quickly see the value of `res` without scrolling through a huge file, you can pipe the output to `head` (to see the beginning of the data segment):

```bash
od -An -j 0 -N 12 -t d4 spim.dump
```

* **`-An`**: Removes the address column.
* **`-j 0`**: Skips 0 bytes (adjust if your variables start further down).
* **`-N 12`**: Only looks at the first 12 bytes (3 integers: `val1`, `val2`, `res`).


#### Setting Up Your Files

Before starting, ensure each program is saved as a `.s` file (e.g., `prog1.s`, `prog2.s`, `prog3.s`) in your working directory. To launch the emulator, simply open your terminal and type:

```bash
spim
```

#### Program 1: Memory, Arithmetic, and Logic

This program is all about moving data between RAM and the CPU.

##### How to Run and Inspect:

1. **Load the code:** `(spim) load "prog1.s"`
2. **See the Memory (Data Segment):** Before running, see how `var_a` (15) and `var_b` (10) are stored:
` (spim) dump`
Look at address `[0x10010000]`. You should see `0x0000000f` (15) and `0x0000000a` (10).
3. **Step through the Loading:**
Type `step` twice.
* Watch the **PC** (Program Counter) increase by 4 bytes each time.
* Type `re` (read registers) to see `$s0` and `$s1` fill up with the values from memory.

4. **Verify Logic:** Step through the `sll` (Shift Left Logical) instruction. Check register `$t8`. It should now hold `40` (or `0x28`), proving that shifting left by 2 is equivalent to multiplying by .

#### Program 2: Decisions and Loops

This program demonstrates "Control Flow"—how the CPU skips or repeats instructions.

##### How to Run and Inspect:

1. **Load the code:** `(spim) load "prog2.s"`
2. **Observe the Branching:**
Instead of typing `run`, type `step` repeatedly.
* When you reach `beq $t1, $zero, Loop_Exit`, look at the **PC**.
* If `$t1` is not zero, notice how the next `step` command makes the PC jump back to a lower address (the start of the loop) instead of moving forward.

3. **Monitor the Iterator:**
Type `print $t0` after every few steps. You will see the loop index  incrementing ().
4. **Final Result:**
Once the program hits the `syscall` for exit, type `re`. Register `$t4` will hold the last value loaded from the array before the loop finished or found the target.

#### Program 3: Procedures and the Stack

This is the most advanced stage: managing "The Stack" to ensure functions don't overwrite important data.

##### How to Run and Inspect:

1. **Load the code:** `(spim) load "prog3.s"`
2. **Watch the Stack Pointer ($sp):**
Before the `jal` instruction, type `print $sp`. Note the address (e.g., `0x7fffeffc`).
3. **Step into the Procedure:**
Step until you execute `addi $sp, $sp, -12`.
* Type `print $sp` again. You will see the address has **decreased**.
* **The Concept:** In MIPS, the stack grows "downward" toward lower memory addresses.

4. **See the Return Address ($ra):**
After the `jal` instruction, type `print $ra`. This address tells the CPU exactly where to go back to in `main` once the function finishes.
5. **Final Output (Printing to Screen):**
Type `run`. Because this program uses `li $v0, 1` and `syscall`, SPIM will print the result directly to your terminal:
`19` (Since ).

### Summary of "Cheat Sheet" Commands

| Task | SPIM Command | Explanation |
| --- | --- | --- |
| **Load File** | `load "filename.s"` | Prepares your code for execution. |
| **Run All** | `run` | Executes the entire program until a syscall exit. |
| **Step One** | `step` | Executes exactly one line of code. |
| **View Registers** | `re` | Shows the hex value of all 32 registers. |
| **View Single Reg** | `print $t0` | Shows the value of a specific register in decimal. |
| **View RAM** | `dump` | Shows the "Data Segment" where variables live. |

### Pro-Tip: User Input

To ask a student for an integer during a program, use **Syscall 5**:

```mips
li $v0, 5      # Prepare to read integer
syscall        # System pauses and waits for user input in terminal
move $t0, $v0  # The input is now stored in $v0; move it to use it
```

## **Program 1: Memory Access, Arithmetic, and Logic (Textbook &sect;2.2 &ndash; &sect;2.6)**
This program demonstrates how to define integer literals in the `.data` segment (memory), load them into registers, perform arithmetic, and manipulate bits using logical operators.
    
**Key Concepts:**
*   **`.data` vs `.text`:** separating memory storage from executable instructions.
*   **`lw` / `sw`:** The Data Transfer instructions to move values between memory and the register file,.
*   **`add`, `sub`:** R-type arithmetic.
*   **`and`, `or`, `nor`, `sll`:** Logical operations for bit masking and shifting.

```mips
# ECE 251 - Week 3 Example 1
# Topics: Memory Access, Arithmetic, Logic Operations
# Textbook Sections: 2.2, 2.3, 2.5, 2.6

.data
    # Define integer literals in memory
    var_a:  .word 15        # Binary: 0000...0000 1111
    var_b:  .word 10        # Binary: 0000...0000 1010
    result: .word 0         # Space to store a result

.text
.globl main

main:
    # ---------------------------------------------------------
    # 1. MEMORY CALLS: Loading literals from Memory to Registers
    # ---------------------------------------------------------
    # Use 'la' (Load Address) pseudo-instruction to get address of var_a
    la  $t0, var_a          # $t0 = Address of var_a
    lw  $s0, 0($t0)         # $s0 = Memory[$t0 + 0] (Value: 15)

    # Use 'la' for var_b
    la  $t1, var_b          # $t1 = Address of var_b
    lw  $s1, 0($t1)         # $s1 = Memory[$t1 + 0] (Value: 10)

    # ---------------------------------------------------------
    # 2. ARITHMETIC: Using values in registers (Section 2.2)
    # ---------------------------------------------------------
    add $t2, $s0, $s1       # $t2 = $s0 + $s1 (15 + 10 = 25)
    sub $t3, $s0, $s1       # $t3 = $s0 - $s1 (15 - 10 = 5)

    # Store arithmetic result back to memory
    la  $t4, result         # Load address of result variable
    sw  $t2, 0($t4)         # Memory[$t4] = 25

    # ---------------------------------------------------------
    # 3. BOOLEAN LOGIC & SHIFTS (Section 2.6)
    # ---------------------------------------------------------
    
    # Bitwise AND (Masking)
    # 15 (1111) AND 10 (1010) = 10 (1010)
    and $t5, $s0, $s1       
    
    # Bitwise OR (Combining)
    # 15 (1111) OR 10 (1010) = 15 (1111)
    or  $t6, $s0, $s1       

    # Bitwise NOR (Implementing NOT)
    # MIPS does not have a NOT instruction. It uses NOR with $zero.
    # ~(1010 OR 0000) = ~(1010)
    nor $t7, $s1, $zero     # Inverts bits of $s1

    # Shift Left Logical (sll) - Multiplying by powers of 2
    # Shift 10 (1010) left by 2 becomes 40 (101000)
    sll $t8, $s1, 2         # $t8 = $s1 << 2 

    # Shift Right Logical (srl) - Dividing by powers of 2
    # Shift 15 (1111) right by 1 becomes 7 (0111) (Integer division)
    srl $t9, $s0, 1         # $t9 = $s0 >> 1

    # ---------------------------------------------------------
    # EXIT: Clean termination (System Call 10)
    # ---------------------------------------------------------
    li  $v0, 10             # Load immediate 10 into $v0 (Service 10: Exit)
    syscall
```

## **Program 2: Decisions, Loops, and Inequalities (Textbook &sect;2.7)**
This program demonstrates control flow. It covers inequalities (`slt`), unconditional jumps (`j`), and conditional branches (`beq`/`bne`) to construct a `while` loop.

**Key Concepts:**
*   **Basic Blocks:** Sequences of instructions without branches.
*   **`slt` (Set Less Than):** Handling inequalities like $<$, $>$, $\leq$.
*   **`beq` / `bne`:** Branch if Equal / Not Equal.
*   **`j`:** Unconditional Jump,.

```mips
# ECE 251 - Week 3 Example 2
# Topics: Branching, Loops, Inequalities
# Textbook Section: 2.7

.data
    array:  .word 10, 20, 30, 40, 50  # An array of integers
    length: .word 5                   # Length of the array
    target: .word 30                  # Value we are searching for

.text
.globl main

main:
    # Initialize variables
    la   $s0, array         # $s0 = Base address of array
    lw   $s1, length        # $s1 = Array length (5)
    lw   $s2, target        # $s2 = Target value (30)
    li   $t0, 0             # $t0 = i (Loop iterator/index), init to 0

# ---------------------------------------------------------
# LOOP STRUCTURE (Simulating a C while loop)
# while (i < length) { ... }
# ---------------------------------------------------------
Loop_Start:
    # 1. INEQUALITY CHECK (Set Less Than)
    # Check if i < length. 
    # slt sets destination to 1 if true, 0 if false.
    slt  $t1, $t0, $s1      # if ($t0 < $s1) set $t1 = 1, else $t1 = 0
    
    # 2. CONDITIONAL BRANCH (Exit if condition fails)
    # If $t1 is 0, then i >= length, so we exit the loop.
    beq  $t1, $zero, Loop_Exit 

    # -----------------------------------------------------
    # Loop Body: Access Array[i] and Compare
    # -----------------------------------------------------
    
    # Calculate byte offset: offset = i * 4 (since words are 4 bytes)
    sll  $t2, $t0, 2        # $t2 = i << 2 (multiplying by 4)
    
    # Get address of Array[i]: Base + Offset
    add  $t3, $s0, $t2      # $t3 = &array[i]
    
    # Load value: val = Array[i]
    lw   $t4, 0($t3)        # $t4 = array[i]

    # Check for equality: if (Array[i] == target)
    beq  $t4, $s2, Found_Target

    # Increment iterator: i++
    addi $t0, $t0, 1        
    
    # 3. UNCONDITIONAL JUMP
    # Go back to the start of the loop
    j    Loop_Start

Found_Target:
    # If we get here, we found the number. 
    # We can perform an action, or just exit.
    # For this example, we jump to exit.
    j    Loop_Exit

Loop_Exit:
    # End of program
    li   $v0, 10
    syscall
```

## **Program 3: Procedures and the Stack (Textbook &sect;2.8)**
This program implements a leaf procedure (a function that does not call other functions). It demonstrates the **Jump-and-Link (`jal`)** instruction, the **Jump Register (`jr`)** instruction, and how to manage the **Stack Pointer (`$sp`)** to preserve registers.

**Key Concepts:**
*   **`jal`:** Jumps to a label and saves `PC + 4` in `$ra` (Return Address).
*   **`jr $ra`:** Jumps back to the address stored in `$ra`.
*   **The Stack:** Growing the stack down (subtracting from `$sp`) to save registers, and shrinking it (adding to `$sp`) to restore them,.
*   **Register Conventions:** Arguments in `$a0-$a3`, Return values in `$v0-$v1`, Saved registers `$s0-$s7`.

```mips
# ECE 251 - Week 3 Example 3
# Topics: Procedures, jal, jr, Stack Management
# Textbook Section: 2.8

.text
.globl main

# ---------------------------------------------------------
# MAIN PROGRAM (The Caller)
# ---------------------------------------------------------
main:
    # Initialize arguments for the function
    # Let's compute: leaf_example(g, h, i, j)
    # Mapping: g=$a0, h=$a1, i=$a2, j=$a3
    li  $a0, 10     # g = 10
    li  $a1, 20     # h = 20
    li  $a2, 5      # i = 5
    li  $a3, 6      # j = 6

    # CALL THE PROCEDURE
    # jal (Jump and Link) puts the address of the next instruction 
    # into register $ra, then jumps to the label.
    jal leaf_example

    # RETURN POINT
    # The result is now in $v0. 
    # (Optional: Print result using syscall 1)
    move $a0, $v0   # Move result to $a0 for printing
    li   $v0, 1     # Service 1: Print Integer
    syscall

    # Exit
    li   $v0, 10
    syscall

# ---------------------------------------------------------
# PROCEDURE: leaf_example
# C Code equivalent:
# int leaf_example(int g, int h, int i, int j) {
#    int f;
#    f = (g + h) - (i + j);
#    return f;
# }
# ---------------------------------------------------------
leaf_example:
    # 1. PROLOGUE: Adjust Stack to save registers
    # We need to use saved registers $s0, $t0, $t1 for calculation.
    # Note: Optimization might use only $t registers without saving,
    # but we will save 3 registers to demonstrate the stack concept.
    
    addi $sp, $sp, -12      # Create space for 3 words (3 * 4 bytes)
    sw   $t1, 8($sp)        # Save $t1
    sw   $t0, 4($sp)        # Save $t0
    sw   $s0, 0($sp)        # Save $s0

    # 2. BODY OF PROCEDURE
    add  $t0, $a0, $a1      # $t0 = g + h
    add  $t1, $a2, $a3      # $t1 = i + j
    sub  $s0, $t0, $t1      # $s0 = (g + h) - (i + j)

    # 3. SET RETURN VALUE
    add  $v0, $s0, $zero    # Returns f ($v0 = $s0)

    # 4. EPILOGUE: Restore registers and stack
    lw   $s0, 0($sp)        # Restore $s0
    lw   $t0, 4($sp)        # Restore $t0
    lw   $t1, 8($sp)        # Restore $t1
    addi $sp, $sp, 12       # Deallocate stack space

    # 5. RETURN TO CALLER
    jr   $ra                # Jump to address stored in $ra
```

## Coding exercises
TDebugging is where the "magic" of assembly really clicks.

Let's modify **Program 2** to include a very common "Off-by-One" error. In this version, the loop is supposed to search for the number `50` in the array, but it contains a logic bug that causes it to stop too early.

### The Debugging Challenge: "The Missing Element"

#### 1. The Broken Code (`challenge.s`)

This program is supposed to find the value 50 (the last element) in the array, but it fails to find it. Use `SPIM` to find out why. Remember `#` is a comment in a MIPS assembly program.

```mips
# DEBUG CHALLENGE: Find the logic error!
.data
    array:  .word 10, 20, 30, 40, 50
    length: .word 5
    target: .word 50        # We are looking for the last element
    msg_found: .asciiz "Found it!\n"

.text
.globl main
main:
    la   $s0, array
    lw   $s1, length
    lw   $s2, target
    li   $t0, 0             # i = 0

Loop_Start:
    # --- THE BUG IS LIKELY HERE ---
    # Logic: if (i < length - 1) ... wait, is that right?
    addi $t7, $s1, -1       # $t7 = length - 1 (4)
    slt  $t1, $t0, $t7      # if (i < 4) $t1 = 1
    beq  $t1, $zero, Exit   # If $t1 is 0, exit loop

    # --- Loop Body ---
    sll  $t2, $t0, 2        # Offset = i * 4
    add  $t3, $s0, $t2      # Address of array[i]
    lw   $t4, 0($t3)        # Load array[i]

    beq  $t4, $s2, Found    # Did we find 50?
    
    addi $t0, $t0, 1        # i++
    j    Loop_Start

Found:
    li   $v0, 4             # Print string syscall
    la   $a0, msg_found
    syscall

Exit:
    li   $v0, 10
    syscall

```

#### 2. Instructions to Solve the Bug

##### Step A: Observe the Failure

1. Load the file into `spim`: `load "challenge.s"`
2. Type `run`.
3. **Observe:** The program finishes, but "Found it!" is never printed to the screen.

##### Step B: Use the `step` Command to Trace

1. Reload the program and type `step`.
2. Watch the value of `$t0` (the index `i`).
3. When `$t0` reaches `3`, keep stepping carefully.
4. **The "Aha!" Moment:** Look at the `slt` instruction. When `i=4`, the program compares `4 < 4`. This is false, so it jumps to `Exit` **before** it ever loads the 5th element (the 50).

##### Step C: Inspect Memory to Confirm

1. To prove the `50` actually exists in memory, type:
`dump`
2. Look at the data segment addresses. You will see `0x00000032` (which is 50 in hex) sitting at the 5th word position.

##### Step D: The Fix

To fix the bug, you should change the inequality logic. Instead of comparing `i < length - 1`, they should compare `i < length`:

**Old Code:**

```mips
addi $t7, $s1, -1
slt  $t1, $t0, $t7

```

**New (Fixed) Code:**

```mips
slt  $t1, $t0, $s1  # Directly compare i ($t0) and length ($s1)

```

##### Interactive Bonus: Getting User Input

To make this more engaging, modify the program so the user can **type in** the target number they are searching for.

**Add this to the start of `main`:**

```mips
# Get target from user
li $v0, 5      # Syscall for read_int
syscall
move $s2, $v0  # Store user input into our target register

```



## MIPS Syscall Cheat Sheet

Here is a **MIPS Syscall Cheat Sheet**. These system calls are the "bridge" between the CPU and the outside world (the console and the user).

In `spim`, you always load the **Service Code** into register `$v0` before calling `syscall`.

### MIPS Syscall Quick Reference

| Service | Code (`$v0`) | Arguments | Result |
| --- | --- | --- | --- |
| **Print Integer** | 1 | `$a0` = value to print | Prints integer to console |
| **Print String** | 4 | `$a0` = address of null-terminated string | Prints string to console |
| **Read Integer** | 5 | None | `$v0` contains the integer entered |
| **Read String** | 8 | `$a0` = buffer address, `$a1` = length | Fills buffer with user input |
| **Exit** | 10 | None | Gracefully stops the emulator |

## Demonstrating User Input: The "Search Interactive" Program

Let's combine the Syscall knowledge with the previous loop challenge. This program asks the user for a number and tells them if it exists in the array.

### The Code (`search.s`)

```mips
# ECE 251 - Interactive Search
.data
    array:  .word 5, 12, 18, 25, 30
    length: .word 5
    prompt: .asciiz "Enter a number to find: "
    found_msg: .asciiz "Success! The number is in the array.\n"
    lost_msg:  .asciiz "Not found. Try again!\n"

.text
.globl main
main:
    # 1. PRINT PROMPT (Syscall 4)
    li $v0, 4
    la $a0, prompt
    syscall

    # 2. READ INPUT (Syscall 5)
    li $v0, 5
    syscall
    move $s2, $v0          # $s2 = target number from user

    # 3. INITIALIZE LOOP
    la $s0, array
    lw $s1, length
    li $t0, 0              # i = 0

search_loop:
    slt $t1, $t0, $s1      # i < length?
    beq $t1, $zero, not_found

    sll $t2, $t0, 2        # Offset
    add $t3, $s0, $t2      # Address
    lw  $t4, 0($t3)        # Load value

    beq $t4, $s2, is_found # Compare input to array element

    addi $t0, $t0, 1       # i++
    j search_loop

is_found:
    li $v0, 4
    la $a0, found_msg
    syscall
    j exit

not_found:
    li $v0, 4
    la $a0, lost_msg
    syscall

exit:
    li $v0, 10
    syscall

```

## Instructions to Observe the Interaction

### 1. Observe the Syscall Flow

1. **Load and Step:** Load `search.s` and `step` until the PC hits the `syscall` for reading an integer ( ).
2. **Terminal Input:** Notice that SPIM will pause. You must click in your terminal and type a number (e.g., `18`), then press **Enter**.
3. **Register Check:** Immediately type `print $v0`. You will see the number you just typed is now sitting inside that register.

### 2. Verify the Array Address

Before the loop starts, look at `$s0`.

* Type `print $s0`. This is the starting address of your array (usually `0x10010000`).
* Type `dump`. Verify that the five numbers (`5, 12, 18, 25, 30`) are indeed sitting at that location in RAM.

### 3. Step Through the Comparison

Step until the code reaches `beq $t4, $s2, is_found`.

* Type `print $t4` to see the current element being checked.
* Type `print $s2` to see your input.
* If they match, the next `step` will jump the PC to the `is_found` label!


## 💡 MIPS Quick Start Guide for SPIM

Here is a **MIPS Quick Start Guide**. This document is designed to be a "one-stop shop" for you to transition from high-level logic to assembly execution on your Unix-based systems.

### 1. Essential SPIM Commands

Once you launch `spim` in your terminal, use these commands to control the simulation:

| Command | Usage | Description |
| --- | --- | --- |
| `load "file.s"` | `load "lab3.s"` | Loads your assembly file into memory. |
| `run` | `run` | Executes the entire program. |
| `step <n>` | `step` or `step 5` | Executes  instructions (default is 1). |
| `print_all_regs hex` | `print_all_regs hex` | **R**ead **E**very register (Hexadecimal). |
| `print $t0` | `print $s1` | Shows the value of a specific register in **Decimal**. |
| `dump` | `dump` | Shows the Data Segment (RAM). |
| `exit` | `exit` | Quits the SPIM emulator. |

---

### 2. The MIPS Memory Map

Understanding where your data lives is crucial for debugging.

* **Text Segment (`0x00400000`):** Where your executable instructions are stored.
* **Data Segment (`0x10010000`):** Where your variables (strings, arrays, words) start.
* **Stack Segment (`0x7ffffffc`):** Where local function data is stored. It grows **downward**.

### 3. Register Conventions (The "Social Rules" of MIPS)

While you *can* use almost any register for anything, following these rules ensures your code works with procedures:

| Register Name | Number | Usage |
| --- | --- | --- |
| **$zero** | 0 | Always holds the value 0. Cannot be changed. |
| **$v0 - $v1** | 2 - 3 | Values for results and expression evaluation (and Syscalls). |
| **$a0 - $a3** | 4 - 7 | Arguments for functions. |
| **$t0 - $t9** | 8-15, 24-25 | Temporaries. Can be overwritten by functions. |
| **$s0 - $s7** | 16 - 23 | Saved registers. Must be preserved by functions. |
| **$sp** | 29 | Stack Pointer. Points to the top of the stack. |
| **$ra** | 31 | Return Address. Used by `jal` and `jr`. |

### 4. Anatomy of a Procedure (The Stack)

When writing a function (procedure), follow this pattern to ensure you don't lose data:

1. **Prologue:** Save registers you plan to use onto the stack.
2. **Body:** Perform your logic.
3. **Epilogue:** Restore the registers from the stack.
4. **Return:** Use `jr $ra`.

### 5. Common Debugging Workflow

If your code isn't working, follow this checklist:

1. **Syntax Check:** Does the file load without errors?
2. **Initial State:** Use `re` to see if your constants loaded into `$s` registers correctly.
3. **The Step Test:** Step through your loop **once**. After `lw`, use `print` to see if the register actually holds the value from the array.
4. **Memory Check:** Use `dump` to ensure your `sw` (Store Word) instruction actually placed the result at the correct address in the Data Segment.

### Pro-Tip for Unix Users

Since you are using a terminal, you can "pipe" your assembly files directly into `spim` for a quick result without entering the interactive console:

```bash
spim -file program.s
```
but if you want to perform more complex operations, such as capturing the output to a text file for your lab report or filtering for specific results, you can use standard Unix redirection and pipes:

```bash
# Save the output of your program to a file
spim -file program.s > output.txt

# Run the program and search for a specific value in the output
spim -file program.s | grep "Result:"
```
This is particularly useful to automate testing or keep a log of your program's behavior without manually copying text from the terminal.

## MIPS Instruction Syntax Reference

### 1. Arithmetic & Logic (R-Type)

*Most R-type instructions follow the format: `op $dest, $src1, $src2*`

| Instruction | Syntax | Description |
| --- | --- | --- |
| **Add** | `add $t0, $t1, $t2` | `$t0 = $t1 + $t2` (signed) |
| **Subtract** | `sub $t0, $t1, $t2` | `$t0 = $t1 - $t2` |
| **And** | `and $t0, $t1, $t2` | Bitwise AND |
| **Or** | `or $t0, $t1, $t2` | Bitwise OR |
| **Nor** | `nor $t0, $t1, $zero` | Bitwise NOT (Inverts bits of `$t1`) |
| **Shift Left** | `sll $t0, $t1, 2` | `$t0 = $t1 << 2` (Multiply by 4) |
| **Shift Right** | `srl $t0, $t1, 1` | `$t0 = $t1 >> 1` (Divide by 2) |

---

### 2. Data Transfer (I-Type)

*Remember: Address format is `offset($base_register)*`

| Instruction | Syntax | Description |
| --- | --- | --- |
| **Load Word** | `lw $t0, 4($s0)` | Load value at `($s0 + 4)` into `$t0` |
| **Store Word** | `sw $t0, 8($s0)` | Store value of `$t0` into address `($s0 + 8)` |
| **Load Addr** | `la $t0, label` | (Pseudo) Load the memory address of `label` |
| **Load Imm** | `li $t0, 100` | (Pseudo) Load the constant 100 into `$t0` |

---

### 3. Comparison & Branching

*Used for `if` statements and `loops`.*

| Instruction | Syntax | Description |
| --- | --- | --- |
| **Set Less Than** | `slt $t0, $s1, $s2` | If `$s1 < $s2`, `$t0 = 1`; else `$t0 = 0` |
| **Branch Equal** | `beq $t0, $t1, Label` | If `$t0 == $t1`, jump to `Label` |
| **Branch Not Eq** | `bne $t0, $t1, Label` | If `$t0 != $t1`, jump to `Label` |
| **Jump** | `j Label` | Unconditional jump to `Label` |

---

### 4. Procedures & The Stack

*Crucial for modular programming.*

| Instruction | Syntax | Description |
| --- | --- | --- |
| **Jump & Link** | `jal Function` | Jump to `Function` and store return address in `$ra` |
| **Jump Register** | `jr $ra` | Jump to the address stored in `$ra` (Return) |
| **Move** | `move $t0, $a0` | (Pseudo) Copy `$a0` into `$t0` |

---

## Pro-Tips

* **Pseudo-instructions:** Note that `li`, `la`, and `move` are not "real" MIPS instructions; the assembler converts them into `ori` or `add` instructions. If you use `step` in SPIM, you might see these expand into two lines of code!
* **Word Alignment:** Always remember that memory addresses move in increments of **4** for words. If you use `3` or `5`, SPIM will throw an **Address Alignment Error**.
* **The Zero Register:** `$zero` is your best friend. Want to clear a register? `add $t0, $zero, $zero`. Want to check if a number is negative? `slt $t1, $s0, $zero`.

# `spim` command line workflow

## 1. The Preparation Phase

Before launching the emulator, ensure your source code is formatted correctly.

1. **Write your code:** Use a plain text editor (like VS Code or TextEdit) and save your file with a `.s` extension (e.g., `lab_test.s`).
2. **Verify the Entry Point:** Ensure your code has a `.text` section and a `.globl main` label so SPIM knows where to start.
3. **Mandatory Exit:** Ensure the last thing your program does is call **Syscall 10**. Without this, SPIM will keep executing "empty" memory, leading to errors.

## 2. Running the Program

Open your terminal and enter the interactive SPIM shell.

```bash
spim

```

Once inside the `(spim)` prompt, follow these commands:

* **Load:** `load "program.s"` (Always use quotes).
* **Run:** `run` (This executes the code to completion).
* **Check Results:** If you used a print syscall, the output will appear directly in your terminal.

## 3. The Debugging Phase (The "Inner Workings")

If the program doesn't work as expected, you need to look inside the CPU.

### A. Inspecting Registers

To see the values currently held in the 32 general-purpose registers:

* **Command:** `print_all_regs hex`
* **What to look for:** Look at `$t` and `$s` registers. Values are shown in **Hexadecimal**.
* **Specific Check:** `print $t0` will show you the value of that specific register in **Decimal**, which is often easier for debugging math logic.

### B. Stepping Through Code

Instead of `run`, execute one line at a time to find exactly where the logic fails:

* **Command:** `step`
* **The Visualization:** Every time you type `step`, SPIM shows you the **next instruction** to be executed and its memory address.
* **The PC:** Watch the **Program Counter (PC)**. It should increment by **4** each step unless a branch (`beq`) or jump (`j`) occurs.

### C. Inspecting Memory (The Data Segment)

If your program stores results in memory (using `sw`), you must verify the RAM:

* **Command:** `dump`
* **Interpretation:** This shows a large block of hex values.
* Find the row starting with `[0x10010000]`. This is the start of your `.data` section.
* Each 8-digit hex value is one **Word** (4 bytes).


* **Direct Access:** `print 0x10010004` will show you the specific decimal value stored at that exact memory address.

## 4. Advanced: The "Quick Pipe" Workflow

For a fast check without entering the shell, use the Unix terminal command we discussed:

```bash
# Run the file and immediately see the register state at the end
spim -file program.s

```

### Pro-Tip for Unix Users

Since you are using a terminal, you can "pipe" your assembly files directly into `spim` for a quick result without entering the interactive console:

```bash
spim -file program.s

```

...and if you suspect a memory alignment issue, you can pipe the `dump` output into `hexdump` for a clearer view of the byte order:

```bash
# This forces a dump to a file and lets you inspect it with Mac's native tools
echo "dump \"mem.bin\"" | spim -file program.s
hexdump -C mem.bin

```

# Why do we need two instructions to load a 32-bit constant?

Let's dive into the architecture of MIPS32 to understand why loading a full 32-bit constant is a two-step process.

---

## The "Why": The 16-bit Immediate Limit

In MIPS32, every instruction is exactly **32 bits long**. This fixed-length instruction set is a hallmark of RISC (Reduced Instruction Set Computer) architecture, designed for speed and simplicity.

When you use an **I-type (Immediate) instruction** (like `addi`, `ori`, or `lw`), the 32 bits of the instruction must be divided to fit different pieces of information:

* **Opcode:** 6 bits (tells the CPU what to do)
* **Source Register ():** 5 bits
* **Target Register ():** 5 bits
* **Immediate Value:** 16 bits

Because 16 bits are dedicated to the "immediate" value, you can only represent numbers from  to  (unsigned) or  to  (signed) in a single instruction. A 32-bit integer requires all 32 bits to be set, but there simply isn't enough physical "room" left in a single MIPS instruction to hold a 32-bit constant alongside the opcode and register addresses.

---

## The "How": The Two-Step Solution

To load a 32-bit constant (e.g., `0x12345678`), we have to split the process into two steps: loading the "Upper" 16 bits and then the "Lower" 16 bits.

### 1. The Strategy

1. **`lui` (Load Upper Immediate):** This instruction takes a 16-bit value and places it in the top 16 bits of a register, filling the lower 16 bits with zeros.
2. **`ori` (Bitwise OR Immediate):** This instruction performs a logical OR between the register and a 16-bit constant, effectively "plugging in" the lower half without changing the upper half.

### 2. The Code Implementation

Suppose we want to load the value `0x12345678` into register `$s0`.

```mips
.text
.globl main

main:
    # Step 1: Load the upper 16 bits (0x1234)
    # $s0 becomes 0x12340000
    lui $s0, 0x1234

    # Step 2: Load the lower 16 bits (0x5678) using OR
    # 0x12340000 OR 0x00005678 = 0x12345678
    ori $s0, $s0, 0x5678

    # The 32-bit number is now fully loaded in $s0
    
    # Exit program (standard MARS/SPIM syscall)
    li $v0, 10
    syscall

```

### 3. Documentation of Steps

* **`lui $s0, 0x1234`**: The CPU takes the constant `0x1234`, shifts it left by 16 bits, and stores it in `$s0`.
* **`ori $s0, $s0, 0x5678`**: The `ori` instruction treats the immediate value as an unsigned 16-bit integer. By ORing it with the register that already has the upper bits, we combine them into a single 32-bit word.

> **Pro Tip:** Most MIPS assemblers provide a **pseudo-instruction** called `li` (Load Immediate). When you write `li $s0, 0x12345678`, the assembler automatically translates that single line into the `lui` and `ori` sequence shown above for you!

## Load/Store Architecture

Because MIPS is a **Load/Store architecture**, we can't perform math directly on values sitting in memory. We must first load them into registers (as we did in the previous step) and then use **R-type (Register-type)** instructions to perform the calculation.

### 1. The Overview

To demonstrate, we will:

1. Load a second 32-bit number into another register (`$s1`).
2. Use the `add` instruction to calculate the sum.
3. Store the result in a third register (`$s2`).

Since `add` is an **R-type instruction**, it doesn't have the 16-bit limitation because it pulls its data from two 32-bit registers rather than an immediate field in the instruction itself.

### 2. The Code Implementation

This script adds `0x12345678` and `0x00001111`.

```mips
.text
.globl main

main:
    # --- Load First 32-bit Number (0x12345678) ---
    lui $s0, 0x1234
    ori $s0, $s0, 0x5678

    # --- Load Second 32-bit Number (0x00001111) ---
    # Since the upper bits are 0, we can just use ori or li
    lui $s1, 0x0000
    ori $s1, $s1, 0x1111

    # --- Perform Addition ---
    # add rd, rs, rt -> rd = rs + rt
    # This works on the full 32-bit values stored in the registers
    add $s2, $s0, $s1

    # --- End Program ---
    li $v0, 10
    syscall

```

### 3. Implementation Instructions

1. **Open an Emulator:** Use a MIPS simulator like **MARS** or **QtSpim**.
2. **Assemble:** Click the "Assemble" (wrench and screwdriver) icon.
3. **Execute:** Step through the code line-by-line using the "F7" key or the "Step" button.
4. **Observe Registers:** Watch the **Registers** pane. You will see `$s0` and `$s1` populate with the 32-bit values, and finally, `$s2` will show the result: `0x12346789`.

### Key Takeaway

While **I-type** instructions (like `addi`) are limited to 16-bit constants, **R-type** instructions (like `add`, `sub`, `and`, `or`) operate on the **full 32-bit width** of the registers. This is why we load the large numbers first, then do the math.

## Loading Values from RAM

Loading values from RAM is a fundamental skill in MIPS. Unlike loading immediate constants, where the data is embedded directly in the instruction code, loading from memory involves pointing the CPU to a specific address in the Data Segment.

### 1. The Overview

To load 32-bit values from memory, we follow these steps:

1. **Define a `.data` section:** This is where we allocate space for our variables.
2. **Use labels:** Labels act as human-readable names for memory addresses.
3. **The `lw` (Load Word) instruction:** This instruction moves 4 bytes (32 bits) from a memory address into a register.

In MIPS, memory is byte-addressed, meaning every byte has its own address. A 32-bit integer is a "word" (4 bytes), so we use `lw`.

---

### 2. The Code Implementation

This program defines two 32-bit integers in memory, loads them into registers, and adds them.

```mips
.data
    # Define two 32-bit words in memory
    num1: .word 0x12345678
    num2: .word 0x00001111
    result: .word 0          # Space to store the result later

.text
.globl main

main:
    # Step 1: Get the address of 'num1' and load the value
    # 'la' (Load Address) is a pseudo-instruction that uses lui/ori
    la $t0, num1       # Put the memory address of num1 into $t0
    lw $s0, 0($t0)     # Load the 32-bit word at that address into $s0

    # Step 2: Load 'num2'
    la $t1, num2       # Put the memory address of num2 into $t1
    lw $s1, 0($t1)     # Load the 32-bit word at that address into $s1

    # Step 3: Perform addition
    add $s2, $s0, $s1

    # Step 4: Store the result back into RAM
    la $t2, result     # Get address of the result label
    sw $s2, 0($t2)     # Store Word: move value from $s2 to memory

    # --- End Program ---
    li $v0, 10
    syscall

```

### 3. Implementation Instructions

* **`.word` directive:** This tells the assembler to reserve 32 bits of space and initialize it with the value provided.
* **`la $t0, num1`:** Since memory addresses are also 32-bit numbers, the assembler translates `la` into a `lui`/`ori` pair to load the address of your variable into a register.
* **`lw $rt, offset($rs)`:** * `$rs` is the base register (the address).
* `offset` is a numerical constant (usually 0 here) added to the address.
* `$rt` is the destination register.


* **`sw` (Store Word):** This is the opposite of `lw`. it takes the 32-bit value in a register and writes it to the RAM address.


### Why this matters

Using memory allows your program to handle much larger datasets than what can fit in the 32 available registers. However, remember that accessing RAM is significantly slower than accessing registers, which is why we "load" them into registers to do the actual math.

## Arrays

Moving from single variables to **arrays** is where assembly language starts to feel powerful.

To handle an array, we use a loop and an **index/offset** that we increment to point to the next 32-bit (4-byte) word in memory.

---

### 1. The Overview

We will:

1. Define an array of 32-bit integers in the `.data` section.
2. Set up a **loop** using a counter.
3. Use a **pointer** (the memory address) and increment it by **4** in each iteration (since each 32-bit word takes 4 bytes).
4. Sum the elements of the array.

---

### 2. The Code Implementation

This program iterates through an array of 5 integers and calculates their total sum.

```mips
.data
    myArray: .word 10, 20, 30, 40, 50  # An array of five 32-bit integers
    length:  .word 5                   # The number of elements
    sum:     .word 0                   # Variable to store final result

.text
.globl main

main:
    # --- Initialization ---
    la $t0, myArray      # $t0 = Base address of the array
    lw $t1, length       # $t1 = Loop counter (starts at 5)
    li $t2, 0            # $t2 = Accumulator (sum starts at 0)

loop:
    # --- Check Loop Condition ---
    # If counter ($t1) is 0, jump to the end
    beq $t1, $zero, end_loop

    # --- Load Data and Add ---
    lw $t3, 0($t0)       # Load the current 32-bit word into $t3
    add $t2, $t2, $t3    # sum = sum + $t3

    # --- Update Pointer and Counter ---
    addi $t0, $t0, 4     # Move pointer to the next word (add 4 bytes)
    addi $t1, $t1, -1    # Decrement the loop counter
    
    j loop               # Jump back to the start of the loop

end_loop:
    # --- Store Result ---
    sw $t2, sum          # Store the final sum back into RAM

    # --- End Program ---
    li $v0, 10
    syscall

```

---

### 3. Documentation of the Logic

* **The 4-Byte Jump (`addi $t0, $t0, 4`):** This is the most critical part. Because MIPS memory is byte-addressed, if you only incremented the address by 1, you would be pointing to the second *byte* of the first number. To reach the first byte of the *second* number, you must skip 4 bytes.
* **`beq $t1, $zero, end_loop`:** This is a **Branch if Equal** instruction. It controls the flow of the program by checking if our counter has reached zero.
* **`j loop`:** This is an unconditional jump that creates the "looping" behavior by sending the program counter back to the `loop:` label.

### 4. Implementation Instructions

1. **Load into MARS/SPIM:** Copy the code above.
2. **Watch the Registers:** Pay close attention to `$t0` (the address). You will see it increase by 4 each time (`...00`, `...04`, `...08`, `...0C`, etc.).
3. **Check Data Segment:** After the program finishes, look at the memory address associated with the `sum` label to see the result (which should be 150, or `0x96` in hex).

---

### Pro Tip: Alignment

MIPS requires 32-bit words to be **word-aligned**, meaning their memory addresses must be multiples of 4. The `.word` directive handles this for you automatically!

### Pro Tip: Debugging

If you are having trouble with your code, you can use the `break` instruction to pause the program and inspect the values of the registers and memory.

### Additional Code Examples
* [prog_00.s](/courses/ece251/2026/weeks/week_03/prog_00.s)
* [prog_01.s](/courses/ece251/2026/weeks/week_03/prog_01.s)
* [prog_02.s](/courses/ece251/2026/weeks/week_03/prog_02.s)
* [prog_03.s](/courses/ece251/2026/weeks/week_03/prog_03.s)
* [lui.s](/courses/ece251/2026/weeks/week_03/lui.s)
* [mips0.asm](/courses/ece251/2026/weeks/week_03/mips0.asm)
* [challenge_01.s](/courses/ece251/2026/weeks/week_03/challenge_01.s)
* [add.s](/courses/ece251/2026/weeks/week_03/add.s)
* [array.s](/courses/ece251/2026/weeks/week_03/array.s)

[ &larr; back to syllabus](/courses/ece251/2026/ece251-syllabus-spring-2026.html) [ &larr; back to notes](/courses/ece251/2026/ece251-notes.html)
