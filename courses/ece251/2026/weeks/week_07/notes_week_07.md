# Notes for Week 7 (Session 7)
[ &larr; back to syllabus](/courses/ece251/2026/ece251-syllabus-spring-2026.html) [ &larr; back to notes](/courses/ece251/2026/ece251-notes.html)

# Today's Agenda: The Culmination of Assembly & Project Kickoff
1. **Advanced Assembly Patterns**
    *   Iterating Arrays and Strings
    *   Deep Dive: Tracing Recursive Procedures
2. **The Final Group Project Launch**
    *   Designing the Minimum Lovable Product (MLP)
    *   SystemVerilog CPU, Python Assembler, and Team Logistics
3. **Midterm Exam Preparation**

---

# Topic Deep Dive

## 0. SPIM OS-like Library Calls

Since SPIM is a simulator and not an operating system, it provides basic OS-like functionality to assembly programmers via the `syscall` instruction. This allows your MIPS code to practically interact with the console for input and output. 

To use a `syscall`, you follow a strict convention:
1. Load the specific **Service Code** into register `$v0`.
2. Load any required **Arguments** into the `$a0` (and `a1`) data registers (or `$f12` for FP).
3. Execute the `syscall` instruction physically.

Here is the essential reference table of SPIM library calls you will need to design and test your assembly programs pragmatically:

| Service | Code in `$v0` | Arguments Required | Action / Result |
| :--- | :---: | :--- | :--- |
| **Print Integer** | 1 | `$a0` = integer value to print | Prints integer to the console |
| **Print Float** | 2 | `$f12` = float value to print | Prints float to the console |
| **Print Double** | 3 | `$f12` = double value to print | Prints double to the console |
| **Print String** | 4 | `$a0` = address of NULL-terminated string (`.asciiz`) | Prints string to the console |
| **Read Integer** | 5 | - | User inputs integer; Returned in `$v0` |
| **Read Float** | 6 | - | User inputs float; Returned in `$f0` |
| **Read Double** | 7 | - | User inputs double; Returned in `$f0` |
| **Read String** | 8 | `$a0` = address of input buffer; `$a1` = length | User inputs string into memory at `$a0` |
| **Allocate Heap (`sbrk`)**| 9 | `$a0` = number of bytes to allocate | Address of allocated memory returned in `$v0` |
| **Exit** | 10 | - | Terminates program execution cleanly |
| **Print Char** | 11 | `$a0` = character to print | Prints a single ASCII character |
| **Read Char** | 12 | - | User inputs character; Returned in `$v0` |
| **Open File** | 13 | `$a0` = filename, `$a1` = flags, `$a2` = mode | Opens file; File Descriptor returned in `$v0` |
| **Read File** | 14 | `$a0` = file desc., `$a1` = buffer, `$a2` = max length | Reads from file into memory buffer |
| **Write File** | 15 | `$a0` = file desc., `$a1` = buffer, `$a2` = output length | Writes memory buffer out to file |
| **Close File** | 16 | `$a0` = file descriptor | Closes the open file |
| **Exit (with value)** | 17 | `$a0` = termination result | Terminates program, returns value to OS |

*Note: The `Print String` syscall (4) structurally relies on the target string being explicitly terminated by a `NULL` byte. This is handled automatically by the compiler's `.asciiz` directive, but must be mathematically managed if you use the raw `.ascii` declaration.*

### Example: Interactive I/O (Prompting the User)
Here is a complete, runnable example demonstrating how to use syscalls to print string prompts, wait for the user to type on their keyboard, and capture their input into memory:

**Source Code Reference:** [`interactive_io.asm`](interactive_io.asm)

```assembly
    .data
prompt_name:  .asciiz "Please enter your name: "
prompt_age:   .asciiz "Please enter your age: "
result_msg:   .asciiz "Hello! You entered age: "
newline:      .asciiz "\n"
name_buffer:  .space 64     # Reserve 64 bytes in memory for the string input

    .text
    .globl main
main:
    # 1. Ask for Name FIRST (to avoid the leftover newline from syscall 5)
    li  $v0, 4              # syscall 4: print string
    la  $a0, prompt_name
    syscall
    
    # 2. Read String from Keyboard
    li  $v0, 8              # syscall 8: read string
    la  $a0, name_buffer    # $a0 = address of where to save the string in memory
    li  $a1, 64             # $a1 = maximum length to read (prevents buffer overflow)
    syscall                 # Program pauses waiting for user input
    
    # 3. Ask for Age
    li  $v0, 4              # syscall 4: print string
    la  $a0, prompt_age     
    syscall
    
    # 4. Read Integer from Keyboard
    li  $v0, 5              # syscall 5: read integer
    syscall                 # Program pauses waiting for user to type and press Enter
    add  $s0, $0, $v0       # IMMEDIATELY save the returned integer into a safe register ($s0)
    
    # 5. Echo the Results Back
    li  $v0, 4              # syscall 4: print string
    la  $a0, result_msg
    syscall
    
    li  $v0, 1              # syscall 1: print integer
    add  $a0, $0, $s0       # load our saved age from $s0
    syscall
    
    # Print trailing newline
    li  $v0, 4              # syscall 4: print string
    la  $a0, newline
    syscall
    
    # Exit cleanly
    li  $v0, 10
    syscall
```

### Example: File I/O (Loading Data into Memory)
A powerful capability of SPIM is its native support for opening, reading, and closing literal files on your hard drive (Syscalls 13, 14, and 16). 

Suppose you have a text file named `data.txt` in the exact same directory as your `.asm` file. 
The literal contents of `data.txt` are 5 integers separated by a newline (`\n` on Mac/Linux, or `\r\n` on Windows).

**Target File Reference:** [`data.txt`](data.txt)

```text
10
20
30
40
50
```

The following code demonstrates how to open that file, read the dense string of ASCII characters into a buffer space reserved dynamically in the `.data` Memory Segment (`0x10010000`), convert those characters into mathematical integers, and then use a `jal` procedure to calculate their average.

**Source Code Reference:** [`file_io.asm`](file_io.asm)

```assembly
    .data
filename:    .asciiz "data.txt"
file_buffer: .space 1024        # Reserve 1024 bytes in the Data Segment to hold the raw text file
result_msg:  .asciiz "The average of the 5 integers is: "
newline:     .asciiz "\n"
myArray:     .word 0, 0, 0, 0, 0 # Reserve 5 integer slots (20 bytes) to store the converted math values

    .text
    .globl main
main:
    # 1. Open the File
    li  $v0, 13             # syscall 13: open file
    la  $a0, filename       # $a0 = address of null-terminated filename
    li  $a1, 0              # $a1 = flags (0 = read-only)
    li  $a2, 0              # $a2 = mode (ignored)
    syscall
    add  $s0, $0, $v0       # IMMEDIATELY save the "File Descriptor" returned in $v0 to $s0 safely
    
    # 2. Read the File into Memory
    li  $v0, 14             # syscall 14: read from file
    add  $a0, $0, $s0       # $a0 = File descriptor we just saved
    la  $a1, file_buffer    # $a1 = address of our 1024 byte buffer in the `.data` segment
    li  $a2, 1024           # $a2 = maximum number of bytes to read
    syscall
    
    # 3. Close the File
    li  $v0, 16             # syscall 16: close file
    add  $a0, $0, $s0       # $a0 = File Descriptor
    syscall
    
    # 4. Convert the Raw ASCII Text Buffer into Physical Integers
    la  $a0, file_buffer    # Argument 0: Base address of the text buffer we just populated
    la  $a1, myArray        # Argument 1: Base address of the destination integer array
    li  $a2, 5              # Argument 2: How many integers we expect to parse
    jal convert_ascii_to_int # Jump and Link to our custom parsing procedure!
    
    # 5. Call the 'average' Procedure
    la  $a0, myArray        # Pass the base address of the array as Argument 0
    li  $a1, 5              # Pass the length of the array as Argument 1
    jal average             # Jump and Link to the procedure (saves Return Address to $ra)
    add  $t0, $0, $v0       # Save the calculated average returned in $v0
    
    # 6. Print the Results
    li  $v0, 4              # syscall 4: print string
    la  $a0, result_msg
    syscall
    
    li  $v0, 1              # syscall 1: print integer
    add  $a0, $0, $t0       # load our average
    syscall
    
    # Print trailing newline
    li  $v0, 4              # syscall 4: print string
    la  $a0, newline
    syscall
    
    # Exit cleanly
    li  $v0, 10
    syscall

# ---------------------------------------------------- #
# Procedure: average
# Arguments: $a0 = array base address, $a1 = size
# Returns:   $v0 = integer average
# ---------------------------------------------------- #
average:
    li  $t0, 0              # Loop counter
    li  $t1, 0              # Running sum
    add  $t2, $0, $a0       # Copy the base address to $t2 so we can shift it

Avg_Loop:
    beq $t0, $a1, Avg_Done  # If counter == size, we reached the end
    
    lw  $t3, 0($t2)         # Load physical word from memory array
    add $t1, $t1, $t3       # Add to sum
    
    addi $t2, $t2, 4        # Shift memory pointer by 4 bytes (1 word)
    addi $t0, $t0, 1        # Increment counter by 1
    
    j   Avg_Loop            # Jump back up

Avg_Done:
    div $t1, $a1            # Divide Sum ($t1) by Count ($a1)
    mflo $v0                # MIPS stores the quotient in the LO register. Move it to $v0 as our return value!
    jr  $ra                 # Return structurally to the caller (main) using $ra

# ---------------------------------------------------- #
# Procedure: convert_ascii_to_int
# Arguments: $a0 = address of file_buffer (source ASCII)
#            $a1 = address of myArray (destination ints)
#            $a2 = number of expected integers to find
# Returns:   None (modifies memory directly at myArray)
# ---------------------------------------------------- #
convert_ascii_to_int:
    add  $t0, $0, $a0       # $t0 = Parse pointer (sliding along file_buffer)
    add  $t1, $0, $a1       # $t1 = Store pointer (sliding along myArray)
    li   $t2, 0             # $t2 = Current integer accumulator
    li   $t3, 0             # $t3 = Successful integers parsed counter
    li   $t4, 10            # $t4 = Constant math multiplier (10)

Parse_Loop:
    beq  $t3, $a2, Parse_Done # If we found all expected integers, exit!

    lb   $t5, 0($t0)        # Load exactly 1 byte of ASCII text
    addi $t0, $t0, 1        # Shift parse pointer to the right by 1 byte
    
    # Check for empty byte / Null terminator (ASCII 0)
    beq  $t5, 0, Parse_Done
    # Check for newline '\n' (ASCII 10)
    beq  $t5, 10, Save_Int  
    # Check for Windows carriage return '\r' (ASCII 13)
    beq  $t5, 13, Parse_Loop # Safely ignore \r and read the next physical byte
    
    # Check for Space (ASCII 32)
    beq  $t5, 32, Save_Int  

    # If we are here, we strongly assume it is a valid digit '0' to '9'.
    # Subtract 48 (ASCII code for '0') to reveal the true mathematical value
    addi $t5, $t5, -48
    
    # Accumulate: Current_Value = (Current_Value * 10) + new_digit
    mul  $t2, $t2, $t4      # Shift current value left natively in base-10
    add  $t2, $t2, $t5      # Add the new digit
    
    j    Parse_Loop         # Unconditionally jump back up to grab the next byte!

Save_Int:
    sw   $t2, 0($t1)        # Save the built up integer physically into the myArray slot
    addi $t1, $t1, 4        # Shift the destination pointer down by 1 word (4 bytes)
    addi $t3, $t3, 1        # Increment our successful integers counter by 1
    li   $t2, 0             # **CRITICAL:** Reset the accumulator back to 0 for the next number!
    
    j    Parse_Loop         # Go back to finding the next number

Parse_Done:
    jr   $ra                # Return structurally to the caller (main) using $ra
```

### Understanding SPIM Exceptions (`exceptions.s`)

Whenever you run a file in SPIM, you will notice the very first output line on your terminal is:
```text
Loaded: /opt/homebrew/Cellar/spim/9.1.24/share/exceptions.s
```

**What are Exceptions in Computer Architecture?**
In hardware architecture, an **Exception** (or Interrupt) is an unscheduled event that forcibly disrupts the normal flow of program execution. When a CPU encounters an impossible physical situation, such as dividing a binary number by zero, attempting to execute an invalid opcode sequence, or trying to access memory that doesn't physically exist, it cannot simply "keep going." The hardware inherently triggers an *Exception*, immediately halting the user's program and aggressively transferring control privileges to the Operating System (or a dedicated Kernel handler) to deal with the crisis.

**What is the `exceptions.s` file?**
Because SPIM is a simulator acting as a bare-bones operating system, it must manually provide an OS Kernel Exception Handler. The `exceptions.s` file is exactly that: a pre-written MIPS assembly file that SPIM permanently loads into the protected **Kernel Text Segment** (`.ktext` at `0x80000180`) before it ever looks at your user code. 

When your code violently crashes, the simulated MIPS CPU hardware jumps directly to `0x80000180`. The `exceptions.s` routine reads the hardware **Cause Register** (Coprocessor 0, Register 13) to aggressively identify *why* the CPU halted. It then prints a structured error message based on an internal array of strings (`__excp`), and conventionally terminates your process to prevent catastrophic cascading failures.

**What Exceptions Does It Catch?**
If you look closely at the `exceptions.s` source code, it officially catches and translates over a dozen hardware faults for you, including:
*   `[Address error in inst/data fetch]` (Unaligned memory access)
*   `[Bad instruction address]`
*   `[Error in syscall]` (Passing an invalid `$v0` code)
*   `[Reserved instruction]` (Invalid machine code)
*   `[Arithmetic overflow]` (Standard `add` exceeding 32-bit limits)
*   `[Floating point]` (FPU division by zero)

**Example: Triggering an Address Exception**
The MIPS architecture rigidly enforces that all 32-bit Words must align on physical Memory Boundaries that are multiples of `4` (e.g., `0x10000000`, `0x10000004`, `0x10000008`). If you attempt to load a Word (`lw`) from an obscure address like `0x10010001`, the silicon gating will critically fail.

Running the following "simplest exception" code:

**Source Code Reference:** [`exception_demo.asm`](exception_demo.asm)

```assembly
    .text
    .globl main
main:
    # Trigger an Address Error Exception by loading a word from an unaligned address
    li  $t0, 0x10010001     # Unaligned memory address (not a multiple of 4)
    lw  $t1, 0($t0)         # Attempt to load a 32-bit word

    # Exit cleanly (will never be reached)
    li  $v0, 10
    syscall
```

Will trigger SPIM's `exceptions.s` handler to catch the hardware failure and cleanly abort the run:
```text
Loaded: /opt/homebrew/Cellar/spim/9.1.24/share/exceptions.s
Exception occurred at PC=0x0040002c
  Unaligned address in inst/data fetch: 0x10010001
  Exception 4  [Address error in inst/data fetch]  occurred and ignored
```

## 1. Advanced Assembly Patterns

We've mastered the mechanical foundations of MIPS: the load-store architecture, memory layouts, control flow (`beq`/`j`), and basic procedure calling. Today, we bridge these isolated mechanics to write complex, algorithmic software natively in hardware.

### A Pedagogical Note on Pseudo-Instructions (`move`, `li`, `la`)
Before we dive into advanced patterns, let's address a structural quirk of the SPIM simulator and the MIPS assembler: **Pseudo-instructions**. 

Pseudo-instructions are "fake" assembly commands that do not physically exist in the MIPS hardware silicon. They are provided purely as a convenience by the software Assembler (like SPIM), which quietly translates them into one or two actual native hardware instructions right before execution.

**1. `move` (Copying Registers)**
You will often see tutorials broadly use `move $t0, $t1`. However, the MIPS hardware architecture has no actual `move` command in silicon! To physically copy a register, you must systematically exploit the hardwired `$0` (Zero) register using the ALU. Adding zero to a number leaves it unchanged:
*   **Pseudo-instruction:** `move $t0, $t1`
*   **Native Hardware Translation:** `add $t0, $0, $t1`

We strictly enforce this native format to prove exactly how the ALU routes data physically!

**2. `li` (Load Immediate)**
MIPS instructions are rigidly exactly *32-bits long*. The I-Type (Immediate) machine code format only grants you 16 literal bits to store a constant number. If you try to load a massive number like `100,000`, it physically cannot fit inside the instruction! 
To bypass this limitation seamlessly, the software Assembler provides `li $t0, 100000`. Behind your back, it secretly splits the operation into two native hardware commands:
1. `lui` (Load Upper Immediate) to securely fill the top 16 bits.
2. `ori` (Or Immediate) to mathematically inject the bottom 16 bits.

*Why do we allow it?* Forcing you to manually translate every large decimal into binary, slice it seamlessly in half, and write two native instructions for every constant is tedious and distracts heavily from the core algorithmic logic of your program (e.g., loops and recursion).

**3. `la` (Load Address)**
When you define a label in the `.data` segment (e.g., `myArray:`), the compiler/linker eventually assigns it a physical 32-bit SRAM/DRAM address (commonly `0x10010000` via SPIM). Because you, the programmer, do not mathematically know exactly what that 32-bit mapped address will be until the code physically compiles, you simply use `la $t0, myArray`. Similarly to `li`, the assembler secretly replaces this abstraction with native `lui` and `ori` instructions once it structurally finalizes the 32-bit memory map!

*Why do we allow it?* Attempting to manually hardcode 32-bit RAM addresses independently without the linker's mathematical assistance is nearly impossible for dynamic software!

### Iterating Arrays and Words
When we talk about "Arrays" in assembly, we are merely talking about a contiguous block of data sitting in Main Memory (usually the `.data` or Heap segments). Because MIPS memory is byte-addressed, and our standard integers ("words") are 32 bits (4 bytes) long, we cannot simply increment an array index by `1` to move to the next integer. We must increment our memory pointer by `4`.

**Example: Summing an Array of 5 Integers**

**Source Code Reference:** [`sum_array.asm`](sum_array.asm)

```assembly
    .data
myArray: .word 10, 20, 30, 40, 50   # 5 integers (20 bytes total)
length:  .word 5
newline: .asciiz "\n"

    .text
    .globl main
main:
    la  $t0, myArray    # $t0 = Base address pointer of the array
    lw  $t1, length     # $t1 = Total elements (5)
    li  $t2, 0          # $t2 = Current index counter (starts at 0)
    li  $t3, 0          # $t3 = Running sum accumulator (starts at 0)
    
Loop_Start:
    beq $t2, $t1, Loop_End  # If counter == length, we're done! Exit loop.
    
    lw  $t4, 0($t0)         # Load the physical word at the current pointer address
    add $t3, $t3, $t4       # Add it to our running sum
    
    addi $t0, $t0, 4        # CRITICAL: Shift the memory pointer up by 4 bytes!
    addi $t2, $t2, 1        # Increment our logical loop counter by 1
    
    j   Loop_Start          # Unconditionally jump back up to evaluate the next loop

Loop_End:
    # Print the final sum ($t3)
    li  $v0, 1          # syscall 1 = print integer
    add  $a0, $0, $t3       # move our accumulated sum into the argument register
    syscall             # execute print
    
    # Print trailing newline
    li  $v0, 4          # syscall 4 = print string
    la  $a0, newline
    syscall
    
    # Exit cleanly
    li  $v0, 10         # syscall 10 = exit
    syscall
```

**Example: Summing an Array of 5 Decimals (Floats)**

A look ahead! While integers (`.word`) rely on standard registers (`$t0-$t9`), dealing with fractional decimals (`.float`) requires delegating execution natively to the hardware's Floating Point Unit (FPU). Notice how we introduce `Coprocessor 1` specific commands like `l.s` (Load Single-Precision Float) and `add.s` (Floating-Point Add), utilizing dedicated FPU registers (`$f0-$f31`). 

**Source Code Reference:** [`sum_array_floats.asm`](sum_array_floats.asm)

```assembly
    .data
myArray:    .float 10.5, 20.25, 30.125, 40.0, 50.5   # 5 floats (20 bytes total in memory)
length:     .word 5
init_sum:   .float 0.0
result_msg: .asciiz "The sum of the decimals is: "
newline:    .asciiz "\n"

    .text
    .globl main
main:
    la  $t0, myArray    # $t0 = Base address pointer of the array
    lw  $t1, length     # $t1 = Total elements (5)
    li  $t2, 0          # $t2 = Current index counter (starts at 0)
    
    # Initialize floating-point sum to 0.0 using Coprocessor 1 (FPU)
    l.s $f12, init_sum  # $f12 = Running sum accumulator (Starts at 0.0)
    
Loop_Start:
    beq $t2, $t1, Loop_End  # If counter == length, we're done! Exit loop.
    
    # Load physical float from the memory pointer directly into the Floating Point Unit
    l.s $f4, 0($t0)         
    
    # Add the extracted decimal to our running sum natively inside the FPU
    add.s $f12, $f12, $f4   
    
    addi $t0, $t0, 4        # CRITICAL: Shift the memory pointer up by 4 bytes (Floats are 32-bit Words too)!
    addi $t2, $t2, 1        # Increment our logical loop counter by 1
    
    j   Loop_Start          # Unconditionally jump back up to evaluate the next loop

Loop_End:
    # Print the descriptive text
    li  $v0, 4          # syscall 4 = print string
    la  $a0, result_msg
    syscall

    # Print the final decimal sum ($f12)
    # Note: SPIM syscall 2 inherently accesses register $f12 to find the float to print!
    li  $v0, 2          # syscall 2 = print float
    syscall             # execute print
    
    # Print trailing newline
    li  $v0, 4          # syscall 4 = print string
    la  $a0, newline
    syscall
    
    # Exit cleanly
    li  $v0, 10         # syscall 10 = exit
    syscall
```

### String Manipulation (Byte-by-Byte)
Strings (`.asciiz`) are handled differently than arrays of integers. Every ASCII character occupies exactly 1 byte (8 bits). 
Therefore, to iterate through a string, you **do not** shift your memory pointer by `4` (which would skip 3 characters). You shift your pointer by `1`. You also use `lb` (Load Byte) instead of `lw` (Load Word).

*Note:* `.asciiz` automatically appends a "Null Terminator" (a literal binary `0x00`) to the end of your string. Your loop condition simply searches for this zero byte to know when the string is entirely finished!

### Deep Dive: Tracing Recursive Procedures
Recursion is when a function calls *itself* back-to-back until it hits a base condition. It is the ultimate test of your **Stack Management** (`$sp`), because every single recursive layer aggressively overwrites the `$ra` (Return Address) tracker and the `$a0` arguments!

**The Fibonacci Example (`fib(n)`)**
Let's trace how the CPU physically builds the stack frame when calculating `fib(3)`.

1. `main` calls `fib(3)`. `$a0 = 3`. The CPU saves `main`'s return address in `$ra`.
2. Inside `fib`: The function pushes a "plate" onto the Stack (`addi $sp, $sp, -12`). It rigidly saves its current `$ra`, `$a0`, and `$s0` values into memory. 
3. It subtracts 1 from `$a0` (`$a0 = 2`) and calls `jal fib`.
4. The cycle repeats! A new layer is built. The Stack physically grows downwards inside the CPU representing `fib(2)` inside `fib(3)` inside `main`.

When the base cases `fib(1)` or `fib(0)` are finally breached, the recursion violently collapses *upwards*. 
The CPU systematically calculates the math, issues `lw` to pop the saved `$ra` and `$a0` values back off their respective stack plates, destroys the physical stack slot (`addi $sp, $sp, 8`), and utilizes `jr $ra` to seamlessly return up the chain of functions. If a single stack `push/pop` operation triggers out of order, the entire program fatally crashes into the void of memory.

### Real-World Application: The Fast Inverse Square Root (Quake Engine)
The **Fast Inverse Square Root** algorithm was famously used in the source code of the 1999 video game *Quake III Arena*. In 3D graphics engines, calculating how light reflects off a polygonal surface requires calculating the "surface normal" (a perpendicular vector). Normalizing this lighting vector mathematically requires computing $\frac{1}{\sqrt{x}}$, where $x$ is the magnitude. 

At the time, performing a standard CPU square root followed by a division instruction was devastatingly slow. To maintain a smooth, performant 3D experience, the Quake developers implemented a brilliant algorithmic hack that drastically sped up this calculation using bit manipulation and Newton-Raphson approximation.

Here is a simplified MIPS implementation of that exact logic. Notice how it seamlessly moves raw bits between the floating-point (`$f12`) and integer (`$t0`) registers using `mfc1` and `mtc1` to perform rapid integer math on a floating-point structure!

**Simplified Lighting Reflection Example:**

**Source Code Reference:** [`quake_inv_sqrt.asm`](quake_inv_sqrt.asm)

```assembly
    .data
magic:      .word 0x5f3759df    # The famous Quake "magic number" constant
threehalfs: .float 1.5
half:       .float 0.5
magnitude:  .float 16.0         # Simulated light vector magnitude (x)
result_msg: .asciiz "1 / sqrt(16.0) is approx: "
newline:    .asciiz "\n"

    .text
    .globl main
main:
    # Load our lighting magnitude into a floating-point register
    l.s   $f12, magnitude
    
    # --- The Fast Inverse Square Root Algorithm ---
    
    # 1. Calculate x2 = x * 0.5
    l.s   $f4, half
    mul.s $f2, $f12, $f4        # $f2 (x2) = x * 0.5

    # 2. Evil Bit-Level Hacking (Move float bits natively to an integer register)
    mfc1  $t0, $f12             # Copy raw IEEE 754 bits from FPU ($f12) to CPU ($t0)

    # 3. Initial Approximation via Magic Number Subtraction
    srl   $t1, $t0, 1           # Logic Shift Right by 1 (i >> 1)
    lw    $t2, magic            # Load the 0x5f3759df magic constant
    sub   $t0, $t2, $t1         # i = magic - (i >> 1)

    # 4. Move the manipulated integer bits back to the FPU
    mtc1  $t0, $f0              # The float structure in $f0 is now incredibly close to 1/sqrt(x)!

    # 5. First iteration of Newton-Raphson to clean up the approximation
    l.s   $f6, threehalfs       # Load 1.5
    mul.s $f8, $f0, $f0         # y * y
    mul.s $f8, $f2, $f8         # x2 * (y * y)
    sub.s $f8, $f6, $f8         # threehalfs - (x2 * y * y)
    mul.s $f0, $f0, $f8         # Final $f0 Result: y = y * [1.5 - (x2 * y * y)]
    
    # 6. Second iteration of Newton-Raphson to further refine the approximation
    mul.s $f8, $f0, $f0         # y * y
    mul.s $f8, $f2, $f8         # x2 * (y * y)
    sub.s $f8, $f6, $f8         # threehalfs - (x2 * y * y)
    mul.s $f0, $f0, $f8         # Final $f0 Result: y = y * [1.5 - (x2 * y * y)]
    
    # ----------------------------------------------
    
    # (The value in $f0 can now be used to rapidly normalize the light reflection vector!)
    
    # Print the descriptive text
    li  $v0, 4                  # syscall 4: print string
    la  $a0, result_msg
    syscall

    # Print the calculated float result in $f0
    li  $v0, 2                  # syscall 2: print float
    mov.s $f12, $f0             # Move result to argument register for printing           
    syscall
    
    # Print trailing newline
    li  $v0, 4
    la  $a0, newline
    syscall

    # Exit cleanly
    li  $v0, 10
    syscall
```

*When you run this code, the output will yield:*
```text
1 / sqrt(16.0) is approx: 0.24999891
```
**Why this exact number?** Mathematically, computing $\frac{1}{\sqrt{16.0}}$ yields exactly $\frac{1}{4.0}$, or `0.25000000`. By exploiting integer bitwise architecture to yield an initial guess, and mathematically refining it with *two* iterations of the Newton-Raphson method, Quake approximates `0.24999891`. This is stunningly precise (an error margin of just 0.000436%) while entirely avoiding the use of a strict floating-point division instruction.

#### A Look Ahead: Decimal Data Types and the FPU
Wait, * decimals*? Up until this exact moment in Chapter 1 and Chapter 2 of our textbook ([Computer Organization and Design](/COaD-MIPS-6ed.pdf)), we have rigidly introduced you *only* to the integer data type (both unsigned integers and signed integers using Two's Complement).

However, just like desktop calculators, computer CPUs must structurally handle fractional decimal numbers too (like `0.24999891`). Our native 32-bit registers (`$t0`, `$s0`) are perfectly wired for whole integers. But how do we physically wire a `.` (decimal point) into microscopic silicon gates? 

A rudimentary "Fixed-Point" decimal system is the first intuitive option, but structurally, it does not provide sufficient dynamic range to handle both macroscopically *huge* numbers and microscopically *tiny* numbers inside the exact same 32-bit operand limit. A universally robust protocol is required. 

Next week, we transition into **Chapter 3**. We will formally introduce the **Floating-Point Data Type** powered by the **IEEE 754 protocol**. We will explore how MIPS handles these specialized decimals by delegating them to an entirely separate piece of hardware acting as a Coprocessor: the **Floating Point Unit (FPU)**. 

*(Check out the bottom-right corner of your [MIPS Green Sheet](/courses/ece251/mips/MIPS_Green_Sheet.pdf) to preview the dedicated `add.s`, `sub.s`, and `div.s` instructions that exclusively run on this FPU coprocessor!)*

$\Rightarrow$ **[Continue to Week 08 Notes: Where we dive deep into using decimals on our CPU (the what), the IEEE 754 protocol (the how), and the Floating-Point Unit (FPU) (the where)](../week_08/notes_week_08.md)**

### Performance Analysis: Instruction Count vs. Hardware Latency
In an engineering context, let's compare the Quake approach against the standard IEEE-754 approach to demonstrate the marked performance improvement.

**Standard IEEE Approach:** 2 Instructions
```assembly
    sqrt.s $f0, $f12        # Calculate square root
    div.s  $f0, $f4, $f0    # 1.0 / sqrt(x)
```

**Quake Approach:** 14 Instructions
As seen in the code block above, the Quake method utilizes roughly 14 individual instructions (`mul.s`, `sub`, `srl`, `mfc1`, etc.) to achieve the same result.

**The Emulator Timing Abstraction:** If you write a benchmark script to loop both algorithms 100,000 times in the `SPIM` emulator, the Standard approach will finish roughly 3x faster than the Quake approach. Why? Because software emulators like SPIM execute instructions sequentially on your modern host Mac/PC CPU. SPIM treats every instruction as taking exactly 1 software "step", abstracting away the realities of the physical silicon. This creates a severe pedagogical blind spot where 2 software steps empirically beats 14 software steps, regardless of the underlying structural pipeline bottlenecks those steps might trigger on physical hardware.

To explicitly prove this mathematical abstraction, here is the raw output from measuring `SPIM` executing both programs 100,000 times natively on my terminal (`time spim -file ...`):

**Benchmark References:**
*   [`bench_standard.asm`](bench_standard.asm)
*   [`bench_quake.asm`](bench_quake.asm)
*   [`Makefile`](Makefile)

```text
$ time spim -file bench_standard.asm
spim -file bench_standard.asm  0.04s user 0.03s system 96% cpu 0.074 total

$ time spim -file bench_quake.asm
spim -file bench_quake.asm  0.13s user 0.08s system 98% cpu 0.214 total
```
As you can see, the 2-instruction loop finishes in `0.074s`, while the 14-instruction loop finishes in `0.214s` (almost exactly 3x slower natively).

**The Physical Hardware Reality:** On physical silicon in 1999 (e.g., Pentium III or MIPS R4000 CPUs), all instructions did not take equal time. We can mathematically prove exactly why the Quake method was superior by revisiting the fundamental **CPU Performance Equation** from Chapter 1 of our textbook ([Computer Organization and Design](/COaD-MIPS-6ed.pdf)):

$$ \text{CPU Execution Time} = \text{Instruction Count (IC)} \times \text{Cycles Per Instruction (CPI)} \times \text{Clock Cycle Time} $$

*   **Standard IEEE Approach (2 Instructions):** The Instruction Count is extremely low ($\text{IC} = 2$). However, on 1999 silicon, Floating Point Division (`div.s`) was incredibly complex and could stall the processor pipeline for **up to 54 clock cycles** waiting for completion. Assuming a basic `sqrt.s` execution alongside it, the average CPI is roughly $27.5$. The total execution requirement is $2 \text{ instructions} \times 27.5 \text{ CPI} \approx 55 \text{ physical clock cycles}$.
*   **Quake Approach (14 Instructions):** The Instruction Count is technically 7x higher ($\text{IC} = 14$). However, standard ALUs executed integer math (`sub`, `srl`) and bit-moves (`mfc1`) natively in exactly **1 clock cycle**. Therefore, the constant CPI is strictly $1.0$. The total execution requirement is $14 \text{ instructions} \times 1.0 \text{ CPI} = \mathbf{14 \text{ physical clock cycles}}$.

Even though the *Instruction Count* was radically higher, the Quake developers minimized the *Cycles Per Instruction* so drastically that their total **CPU Execution Time** finished nearly 4x faster on actual silicon! 

This perfectly illustrates why relying blindly on a software emulator (which mathematically enforces an abstracted, flat CPI of $1.0$ across every command) creates a severe pedagogical blind spot for computer architects.

---

## 2. The Final Group Project Launch

Today commemorates the official assignment of your **Final Group Project** (due May 15, 2026 no later than 5:00 PM ET)! This project encompasses the primary educational objective of ECE 251: you will organically design and implement a von Neumann computer from scratch.

This project carries a total value of **100 raw points** (accounting for 25% of your final semester grade). There is also an allocation for a possible **30 points of extra-credit**. 

### Requirements
You are to implement the design using SystemVerilog and to include a test bench to demonstrate the full functionality of your processor and memory (especially loading and running programs, as well as taking input and showing output to the user).

The following requirements hold for full assessment:
*   **Team:** Teams must consist of precisely 2 students.
*   **Instruction Set Architecture (ISA):** You must design your own ISA, document the design, and summarize it on a two-sided US Letter sized document. You are effectively creating your own ISA's "Green Card."
*   **Submission Mechanism:** Each team will manage source code in a single GitHub repository and submit their final URL via Microsoft Teams. The repository must include all Verilog code files, markdown documentation, and supporting embedded images.

### Final Project Grading Rubric
See below for the formal grading parameters of the final project. The rubric evaluates your complete architectural design across **200 raw points** (which scales directly to the 100 base points defined in the syllabus).

**1. ISA Design (34 Raw Points)**
*   **[2 pts each]** ALU Operand Size, Address Bus Size, Addressability, Register File Size, Opcode Size, Function Size, `shamt` Size, Instruction Size, PC Increment, Immediate Size.
*   **[2 pts each]** Explicit architectural support for R-type, I-type, and J-type instructions.
*   **[2 pts each]** Implementation of robust Memory Reference Support alongside physical logic for R-type, I-type, and J-type instructions.

**2. Memory Design & Implementation (16 Raw Points)**
*   **[3 pts each]** Instruction Memory and Data Memory structure.
*   **[5 pts each]** Memory Layout definitions and the physical Program Load into Processor mechanism.

**3. Processor Design & Implementation (120 Raw Points)**
*   **Control & Datapath:** Overall Control Signals (10 pts), Main Decoder Details (5 pts), ALU Decoder (5 pts), Datapath Design (5 pts), Multiplexors (4 pts), Controller-Datapath Integration (4 pts), Clock Design (2 pts).
*   **Component Logic:** Proper PC incrementing for R/I/J types & Conditional Branching (5 pts each), PC increment adders (3 pts), Register File (5 pts), Sign Extender(s) (5 pts), ALU combinatorial logic (4 pts).
*   **Execution & Integration:** Program Load Integration (4 pts), physical computation of R/I/J Instructions (5 pts each).
*   **Software Validation (Simulation):** Executing a Provided Assembly Program (4 pts), Hand-compiled Program (5 pts), Program 0 [Simple Assembly] (5 pts), Program 1 [Leaf Procedure] (10 pts), Program 2 [Nested Procedure] (5 pts), Program 3 [Recursive Procedure] (5 pts).

**4. Project & Design Documentation (30 Raw Points)**
*   **[5 pts each]** Overall Design Explanation, complete Architectural Diagrams, and explicit instructions to Successfully Demo the processor logic.
*   **[5 pts each]** Creating explicit, step-by-step Timing Diagrams for R-type, I-type, and J-type executions.

### Extra Credit (Up to 70 Raw Points)
If your base von Neumann machine boots successfully, you may attempt the following advanced architectural features for extra credit:
*   **[20 pts each]** Implementing multi-stage **Pipeline Design Support** or integrating **L1 Cache Support**.
*   **[15 pts]** Building a **Programmatic Assembler** (e.g., in Python/C) to automatically map text mnemonics uniformly into your custom ISA machine code.
*   **[5 pts each]** Writing individual Verilog Test Benches for each modular component, integrating explicit Structural Modeling (signal delays), and recording a structured technical Demo Video.

*Note: The Professor will be hosting optional weekend lab sessions leading up to the deadline to assist with simulation debugging or architectural design consultation.*

### First assignment for this project: Ideation

Choose a partner. Brainstorm your final project for which you will design, program, and simulate a computer with your own CPU ISA using SystemVerilog. The theme of the project is to create a computer of your choice with a minimum of 4 bits, given the complexity expected from this course. 

Some fundamental ideas would include the Intel 4004, Intel 8086, Intel 8088, Motorola 6800, Motorola 68000, the MOS 6502, Zilog Z80, etc. Check out the [Computer History Museum Timeline](https://www.computerhistory.org/timeline/computers) for some inspiration, or be creative! Here is a design guide to use as an official resource: [Professor Marano's Notes on Designing a von Neumann Computer](/ECE%20251%20-%20Prof%20Marano's%20Notes%20on%20Designing%20a%20von%20Neumann%20Computer.pdf).

You will design the entire ISA, the data path, the control path, the ALU, and the Controller units, along with the explicit support for integer processing. *(Challenge: How would you mathematically handle floating point?)* 

If you like, you can choose an alternative path and write a functional MIPS simulator that shows the state of each register and how the memory works, along with writing the control path, data path, ALU, and Controller. I will share the basic architecture in SystemVerilog. Check out the [CPU HDL Catalog](https://github.com/robmarano/cpu_hdl_catalog) for reference.

**Submission Guidelines:**
1. You will work in groups of precisely two.
2. Submit a one-page write-up via Microsoft Teams indicating who you intend to work with and what architecture you intend to pursue for your project. 
3. *Note:* You and your partner must hand in the exact same write-up, but ensure you submit it in your own respective Team’s account within Assignments.

---

## 3. Midterm Exam Preparation

Next week (Session 8: March 12th) represents the **Midterm Exam**. We have covered an immense amount of foundational computing architecture since January.

The Midterm will heavily assess the following comprehensive topics:
1. **Logic, Combinational, & Sequential Circuits:** Translating boolean equations into hardware logic gates. Truth tables, Karnaugh maps, Multiplexors, and Flip-Flops.
2. **Hardware Modeling (SystemVerilog):** Structuring `assign` dataflows, combinatorial block rules versus sequential `always_ff` edge-triggered operations, and the explicit differences between Blocking (`=`) and Non-Blocking (`<=`) assignments physically altering silicon synthesis.
3. **MIPS Architecture Overview:** Applying the 4 core design principles of MIPS, evaluating performance (IC x CPI x Clock time), and mapping memory out spatially (Text, Data, Heap, Stack).
4. **Assembly Programming:** Simulating code blocks tracing loops (`bne`/`beq`), array manipulations, translating standard C structures (`if/else/while`), and procedure tracking (`jal`, `$ra`, `$sp` execution chains).

Begin aggressively studying the posted [Midterm Study Guide](../../assignments/study_guide_midterm.md). Office hours will dynamically switch to structured, review-oriented topic overviews!

---
[ &larr; back to syllabus](/courses/ece251/2026/ece251-syllabus-spring-2026.html) [ &larr; back to notes](/courses/ece251/2026/ece251-notes.html)
