# Notes for Week 8 &mdash; Arithmetic for Computers

[ &larr; back to syllabus](/courses/ece251/2025/ece251-syllabus-spring-2025.html) [ &larr; back to notes](/courses/ece251/2025/ece251-notes.html)

# Reading Assignment for these topics

1. Read sections 3.1, 3.2, 3.3, and 3.4 from [CODmips textbook's Chapter 3](./textbook_CODmips_Chapter_3%20-%20Arithmetic%20for%20Computers.pdf).

# Topics

1. Reviewing what it means for a computer to perform arithmetic
2. Addition and Subtraction
3. Multiplication
4. Division
5. Introducing "Floating Point" to represent the very small and the very large.

# Topic Deep Dive

## Computers perform arithmetic

At its core the fundamental principle of a computer is that it performs computation, specifically arithmetic operations.

Let's emphasize that arithmetic operations are a core function of the computer's Arithmetic and Logic Unit (ALU). It would explain that all other components of the computer system exist primarily to bring data to the ALU for processing and to handle the results, like storing them and using them again in another computation.

According to von Neumann's "stored program concept," number representation is crucial for understanding how arithmetic is performed.

### Integer Representation:

Integers represent the set of whole numbers in a CPU, using the binary format limited to the maximum bit width of the operands supported by the ALU. In our MIPS computer, that width is 32 bits.

**Binary Numbers:** The fundamental way computers represent numbers using strings of bits.

**Two's Complement Representation:** We have already covered this standard method for representing signed integers, especially covering its advantages for arithmetic operations.

### Floating-Point Representation:

Floating-point represents the set of **real numbers** using a format similar to scientific notation in binary. The **IEEE 754 standard** for floating-point representation defines the format for **single-precision** and **double-precision** floating-point numbers, including the **sign bit**, **exponent**, and **significand** (or mantissa). With IEEE 754 computers can adequately handle computating involving **normalized** and **denormalized numbers**, as well as special values like **infinity** and **NaN** (not a number), all defined in the IEEE 754 standard.

### Integer Arithmetic:

We will cover:

1. How addition and subtraction are performed using the two's complement representation.
2. The basic principles of integer multiplication and division.
3. The role of the ALU in executing these operations using digital logic circuits.

#### Two's Complement Integer Arithmetic

It's interesting how different architectures handle integer arithmetic with operands of varying sizes. Some programming languages allow two's complement integer arithmetic on variables declared byte and halfword, whereas MIPS only has integer arithmetic operations on full words.

There's a key difference between some programming languages' capabilities and the fundamental integer arithmetic operations in the basic MIPS architecture.

**Operand Sizes and Arithmetic:**

Some programming languages, particularly at lower levels or when interacting closely with hardware, allow you to declare integer variables as bytes (8 bits) or halfwords (16 bits) and perform direct two's complement arithmetic on these sizes. This implies that the underlying architecture has instructions that can operate directly on these smaller data types.

Regarding **MIPS Architecture and Operand Sizes:**

In contrast, the base MIPS architecture primarily performs integer arithmetic operations on full 32-bit words held in its general-purpose registers (GPRs). While MIPS has load and store instructions (`lb`, `lbu`, `lh`, `lhu`, `sb`, `sh`) that can move byte and halfword data between memory and registers, when these smaller data types are loaded into a 32-bit register, they are either sign-extended (`lb`, `lh`) to preserve their signed value or zero-extended (`lbu`, `ldhu`) to treat them as unsigned non-negative integers.

The primary arithmetic instructions (`add`, `sub`, `mul`, `div`, `and`, `or`, `xor`, etc.) in MIPS typically operate on these 32-bit register values.

There are "word" versions of some arithmetic instructions in MIPS (e.g., `addw`, `subw`, `mulw`, `divw`, `remw`). These instructions operate on the lower 32 bits of registers, and the result is a 32-bit sign-extended value. This is particularly **relevant in 64-bit MIPS implementations** or when explicitly dealing with 32-bit sub-sections of larger registers, but the fundamental unit for general integer arithmetic remains the 32-bit word.

**Comparison with Other Architectures (x86 and ARM):**

Other architectures like Intel's x86 and ARM have more flexibility in handling different data sizes for arithmetic operations.

1. **x86** can directly deal with data types of 8 (byte), 16 (word), 32 (doubleword), 64 (quadword), and 128 (double quadword) bits in length for various operations. It has instructions specifically designed to operate on these different sizes (e.g., `add AL`, `imm8` for 8-bit addition).
2. ARM also supports arithmetic on byte, halfword, and word data types. While many ARM implementations may lack floating-point hardware and rely on software for it, integer arithmetic on these smaller sizes is a standard feature.

**Why the Difference?**

The design philosophy of MIPS, particularly as a RISC (Reduced Instruction Set Computer) architecture, emphasizes simplicity and regularity. By focusing most integer arithmetic on a single, fixed word size (32 bits in the base MIPS), the instruction set and the underlying hardware can be made simpler and potentially faster for common operations. Operations on smaller data types are handled primarily through load/store with extension to fit the 32-bit register format for subsequent arithmetic.

**Implications for Programming:**

When programming in a language that allows direct byte and halfword arithmetic and then targeting a MIPS architecture, the compiler must handle these operations by:

1. Loading the byte or halfword into a 32-bit register (with appropriate extension).
2. Performing the 32-bit arithmetic.
3. Potentially masking or truncating the result if it needs to be stored back into a byte or halfword variable to simulate the behavior of direct smaller-size arithmetic and handle potential overflows or underflows at those smaller bit widths.

**In summary,** while some programming languages offer the abstraction of performing two's complement integer arithmetic directly on byte and halfword variables, the fundamental design of the base MIPS architecture primarily focuses its integer arithmetic operations on 32-bit words in registers. Operations on smaller data sizes in MIPS involve loading and extending them to 32 bits before performing arithmetic. Architectures like x86 and ARM provide more direct hardware support for arithmetic on byte and halfword operands.

#### Arithmetic Overflow

In MIPS, the detection of overflow in integer arithmetic depends on whether the operation is treated as **signed** or **unsigned**. MIPS provides separate sets of instructions for these cases, and their behavior with respect to overflow is different.

Here's how overflow detection works in MIPS integer arithmetic:

**Signed Arithmetic:**

1. MIPS instructions such as `add`, `addi`, and `sub` are used for signed integer arithmetic.
2. For these signed operations, the MIPS processor has built-in hardware to detect arithmetic overflow.
3. Overflow occurs when the result of an arithmetic operation is outside the range of values that can be represented by the number of bits available for the operands. For n-bit two's complement numbers, the representable range is from $-2^{n-1}$ to $+2^{n-1} - 1$.
4. When a signed arithmetic overflow occurs, the MIPS processor triggers an **exception**. This is an unscheduled procedure call that jumps to a new address, typically an **exception handler** in the operating system's kernel program. The exception handler then takes the appropriate action based on that specific exception, such as terminating the program or attempting to recover.
5. The **Program Counter** (`PC`) is copied to the **Exception Program Counter** (`EPC`) register, and a code indicating the source of the exception (`0x30` for **arithmetic overflow**) is stored in the **`Cause` register**. The processor then jumps to the exception handler at a predefined memory address (`0x80000180`). Check where on the memory map this address lives.
6. Some languages, like Ada and Fortran, rely on this exception mechanism to handle overflow. C does not care.

**Unsigned Arithmetic:**

1. MIPS provides instructions like `addu`, `addiu`, and `subu` for unsigned integer arithmetic.
2. For these unsigned operations, the MIPS processor does not typically generate an exception on overflow.
3. In unsigned addition, a **carry-out** of 1 from the most significant bit (MSb) position indicates an overflow, that means the result is too big to fit in the word size. However, the `addu` and related instructions do not automatically signal this overflow in a way that triggers an exception.
4. If you need to detect overflow in unsigned arithmetic, you would typically need to **perform an explicit check**. For example, after an addition `add r4, r2, r3`, you can check if the unsigned sum in `r4` is **less than either of the unsigned operands** (`r2` or `r3`). If it is, a `carry` (and thus overflow in the unsigned context) has occurred. The `bltu` (branch if less than unsigned) instruction can be used for this purpose. Similarly, for unsigned subtraction, a `carry` (borrow) can be detected if the **minuend is less than the subtrahend**, which can be checked using `bltu`.

**Carry Flag (`C Flag`):**

While the base MIPS architecture doesn't have explicit condition code flags (like a dedicated carry or overflow flag) that are automatically set by arithmetic instructions in the same way as some other architectures, the **concept of carry** is still relevant for **implementing multi-precision arithmetic** or for explicitly checking for unsigned overflow as mentioned above.

**In summary,** MIPS detects overflow automatically for signed integer arithmetic operations (`add`, `addi`, `sub`) by raising an exception. For unsigned integer arithmetic operations (`addu`, `addiu`, `subu`), overflow is not automatically detected by an exception; programmers need to implement explicit checks if overflow detection is required. The distinction between signed and unsigned instructions is crucial in how overflow is handled in MIPS.

#### Again what is an exception and how to handle it?

In MIPS, an **exception** is an **unexpected event that disrupts the normal flow of program execution**, requiring a change in the control flow. Exceptions can arise from various sources, both within the CPU (like arithmetic overflow, undefined opcode, system calls) and from external devices (interrupts from I/O controllers). The term "exception" in MIPS often encompasses both **hardware-initiated interrupts** and **software-initiated deviations** from normal execution.

When an exception occurs in MIPS, the processor needs to handle it in a structured manner to maintain system stability and allow for potential recovery or graceful termination of the program. This is where the exception handler comes into play. An **exception handler** is a specific piece of code, typically part of the operating system (kernel program), that is designed to determine the cause of the exception and take appropriate action.

In MIPS:

1. When an exception occurs, the processor saves the address of the instruction that caused the exception (or the instruction immediately following it) into a special register called the `Exception Program Counter` (`EPC`).
2. The processor also records the reason for the exception in another special register called the `Cause` register. Different codes in the `Cause` register indicate different types of exceptions (e.g., `0x30` for arithmetic overflow, `0x28` for undefined instruction).
3. The processor then transfers control (jumps) to a predefined memory address where the exception handler code is located. In MIPS, this address is typically `0x80000180`.
4. The exception handler code begins execution. It first needs to determine the cause of the exception by reading the value in the `Cause` register. 1. Based on the cause, the exception handler will perform the necessary actions. This might involve:
   1. Handling an interrupt from an I/O device.
   2. Attempting to recover from an error condition like an arithmetic overflow (e.g., by performing the calculation with greater precision if possible, or by logging an error).
   3. Terminating the program if the error is unrecoverable (like an undefined instruction or a memory access violation).
   4. Servicing a system call requested by the user program.
   5. Responding to a debugger breakpoint.
5. After the exception has been handled, the exception handler usually needs to return control to the interrupted program. This is done by:
   1. Restoring the saved program counter from the `EPC` register back into the `PC`.
   2. Executing a special instruction (like `jr $k0`, where `$k0` is often used to hold the return address from `EPC`, or a specific exception return instruction if available in an extended architecture) to resume the program from where it was interrupted.

Here is a simple example of MIPS assembly code that will intentionally cause an arithmetic overflow exception:

<!-- <details>
<summary><code>arith_overflow_exception_handler.asm</code></summary>
{% highlight mips %} -->

```mips
    .data
overflow_message: .asciiz "\nArithmetic overflow detected!\n"

    .text
    .globl main
main:
    li $t0, 0x7FFFFFFF # Load the maximum positive signed 32-bit integer into $t0
    li $t1, 1 # Load the value 1 into $t1
    add $t2, $t0, $t1 # Attempt to add 1 to the maximum positive value

    # The next instructions will likely not be reached because an overflow
    # exception will occur on the 'add' instruction.
    li $v0, 1
    move $a0, $t2
    syscall             # Print the (likely incorrect) result

    li $v0, 10
    syscall             # Exit the program

    .kseg0
    .org 0x80000180

exception_handler: # This is a very basic example of an exception handler. # In a real system, it would be much more complex.

    # Read the Cause register to determine the exception type
    mfc0 $k0, $13      # Cause register is coprocessor 0 register 13

    # Check if it was an arithmetic overflow (code 0x30)
    andi $k1, $k0, 0x00000030
    bne $k1, $zero, overflow_occurred

    # Handle other exceptions here (not shown)

    j return_from_exception

overflow_occurred:
    li $v0, 4
    la $a0, overflow_message
    syscall # Print an overflow message

return_from_exception: # Restore the program counter from EPC
    mfc0 $k0, $14 # EPC register is coprocessor 0 register 14
    jr $k0 # Return to the instruction that caused the exception (or the next)
```

<!-- {% endhighlight %}

</details> -->

**Explanation of the Example:**

1. The main section attempts to add 1 to the maximum positive signed 32-bit integer (`0x7FFFFFFF`).
2. Because this operation results in a value that cannot be represented as a positive signed 32-bit integer (it would wrap around to a negative number), an arithmetic overflow exception will occur on the `add $t2, $t0, $t1` instruction.
3. The MIPS processor will then:
   1. Save the address of the `add` instruction (or the next one) into the `EPC` register.
   2. Set the `Cause` register to indicate an arithmetic overflow.
   3. Jump to the exception handler code located at address `0x80000180` (in the `.kseg0` kernel segment).
4. The exception_handler code in this example:
   1. Reads the `Cause` register to identify the type of exception.
   2. Checks if the cause corresponds to an arithmetic overflow (by checking for the specific bit pattern)
   3. If it's an overflow, it prints a message to the console.
   4. Finally, it reads the saved program counter from the `EPC` register and uses the `jr` (jump register) instruction to return to the interrupted program (in this simple example, it would re-attempt the add instruction or proceed to the next instruction, depending on the exact behavior).

In a real operating system, the exception handler would be significantly more sophisticated, potentially handling the error more robustly or terminating the program if necessary. This example serves to illustrate the basic concept of an exception being triggered and the control being transferred to a designated handler. It also demonstrates the use of the EPC and Cause registers to manage the exception process

#### Integer Multiplication

Integer multiplication in the MIPS CPU involves dedicated digital hardware within the Arithmetic Logic Unit (ALU). Due to the fact that multiplying two n-bit numbers can result in a product of up to 2n bits, MIPS uses a special mechanism to handle the potentially larger result.

Here's a breakdown of how integer multiplication is handled:

1. **Special-Purpose Registers:** MIPS architecture employs two special-purpose registers called `HI` and `LO` to store the result of a multiplication operation. These registers are separate from the 32 general-purpose registers.
   1. When two 32-bit numbers are multiplied, the 64-bit product is stored across these two registers.
   2. The `LO` register holds the least significant 32 bits of the product.
   3. The `HI` register holds the most significant 32 bits of the product.
2. **Multiplication Instructions:** MIPS provides several instructions for integer multiplication:
   1. `mult rs, rt`: This instruction multiplies the 32-bit integer values in source registers `rs` and `rt`. The 64-bit product is then stored in the `HI` and `LO` registers. The `HI` register receives the upper 32 bits, and the `LO` register receives the lower 32 bits of the product.
   2. `multu rs, rt`: This is similar to `mult`, but it treats the operands as unsigned integers.
   3. `mflo rd` (Move From `LO`): After a `mult` or `multu` instruction, this instruction is used to move the value from the `LO` register into a general-purpose destination register `rd`. This is typically how you access the lower 32 bits of the multiplication result for further use.
   4. `mfhi rd (Move From `HI`)`: This instruction is used to move the value from the `HI` register into a general-purpose destination register `rd`. This allows you to access the upper 32 bits of the product, which is crucial for detecting overflow or for working with the full 64-bit result.
   5. `mul rd, rs, rt`: This instruction performs the multiplication of the values in `rs` and `rt` and directly places the least significant 32 bits of the product into the destination register `rd`. This instruction is useful when you know that the product will fit within 32 bits or when you are only interested in the lower 32 bits.
3. **Overflow Detection:** When multiplying two 32-bit numbers, an overflow occurs if the 64-bit result cannot be accurately represented within 32 bits.
   1. After a `mult` operation (for signed numbers), you can check the `HI` register to detect if an overflow occurred. If the `HI` register contains only 0s (for positive results) or only 1s (as an extension of the sign bit for negative results in the `LO` register), then no overflow occurred within the 32-bit range. If the `HI` register contains any other pattern, it indicates that the result exceeded 32 bits and an overflow happened.
   2. For unsigned multiplication using `multu`, if the `HI` register is non-zero, it signifies that the product is larger than 32 bits.
   3. MIPS also provides a pseudo-instruction `mulo rd, rs, rt` (multiply with overflow check) which multiplies `rs` and `rt`, stores the result in `rd`, and raises an exception if an overflow occurs.
4. **Hardware Implementation:** The multiplication operation is performed by dedicated hardware within the ALU. Simpler multiplication algorithms used by computers are similar to traditional pencil-and-paper methods, involving the addition of partial products. More sophisticated hardware can perform portions of the calculation in parallel to optimize throughput. Bit shift operations can also be used for multiplication and division by constants, often being faster than the equivalent `mul` or `div` operations.

**In summary,** MIPS handles integer multiplication by using the `mult` (and `multu` for unsigned) instruction to generate a 64-bit product stored in the special `HI` and `LO` registers. The `mflo` and `mfhi` instructions are then used to move the lower and upper halves of the result to general-purpose registers. Overflow in signed multiplication can be detected by examining the `HI` register, and the `mulo` pseudo-instruction provides built-in overflow detection with an exception. The `mul` instruction offers a direct way to get the lower 32 bits of the product when the full 64-bit result is not needed.

#### Integer Division

Integer division in the MIPS CPU is handled using dedicated instructions and a pair of special-purpose registers, similar to integer multiplication.

Here's a breakdown of how it works:

1. **Special-Purpose Registers:** MIPS utilizes two 32-bit special-purpose registers named `HI` and `LO` to store the results of integer division. These registers are distinct from the 32 general-purpose registers available for other operations.
   1. When a division operation is performed, the quotient is stored in the `LO` register.
   2. The remainder of the division is stored in the `HI` register.
2. **Division Instructions:** MIPS provides two main instructions for integer division:
   1. `div rs, rt`: This instruction divides the 32-bit signed integer value in source register `rs` (the dividend) by the 32-bit signed integer value in source register `rt` (the divisor). After the operation, the integer quotient is placed in the `LO` register, and the remainder is placed in the `HI` register. The result is truncated towards zero, which is typical for integer division.
   2. `divu rs, rt`: This instruction performs the same operation as `div`, but it treats both the dividend (`rs`) and the divisor (`rt`) as unsigned integers. The unsigned quotient is stored in `LO`, and the unsigned remainder is stored in `HI`.
3. **Accessing Results:** To use the quotient and remainder in subsequent calculations, you need to transfer the values from the `HI` and `LO` registers to general-purpose registers using the following instructions:
   1. `mflo rd` (Move From `LO`): This instruction copies the value from the `LO` register into the specified general-purpose destination register `rd`. This is how you retrieve the quotient.
   2. `mfhi rd` (Move From `HI`): This instruction copies the value from the `HI` register into the specified general-purpose destination register `rd`. This is how you retrieve the remainder.
4. **No Hardware Overflow or Divide-by-Zero Checking:** It's important to note that the basic `div` and `divu` instructions in MIPS **do not have** built-in hardware mechanisms to detect division by zero or overflow (where the quotient might be too large to fit in the `LO` register). If a program attempts to divide by zero, the behavior is undefined and may lead to an exception, **but it's not a guaranteed hardware check**. Similarly, if the quotient exceeds 32 bits (though this is less common with integer division of two 32-bit numbers within their typical ranges), the result in `LO` might not be accurate. Therefore, programmers must explicitly include checks in their code if they need to handle these conditions. For example, a program might **check if the divisor is zero** before executing a division instruction.
5. **Remainder Pseudo-operator:** MIPS assembly provides a `rem` (remainder) pseudo-operator to simplify obtaining the remainder. For example, `rem rd, rs, rt` calculates `rs % rt` and stores the result in `rd`. This pseudo-instruction is typically translated into a sequence of actual MIPS instructions involving `div` and `mfhi`.
6. **Division Algorithms:** At the hardware level, integer division is often implemented using algorithms that involve repeated subtraction and shifting, similar to the long division method taught in elementary school. Some implementations might use a restoring division algorithm or more optimized techniques. These hardware details are generally abstracted away from the assembly language programmer, who primarily interacts with the `div`, `divu`, `mflo`, and `mfhi` instructions.

**In summary,** MIPS integer division is performed using the div (for signed) and divu (for unsigned) instructions. The quotient is stored in the LO register, and the remainder is stored in the HI register. Programmers then use mflo and mfhi to move these results to general-purpose registers. It is crucial to remember that hardware-level checks for division by zero or overflow are not provided by these basic instructions, requiring software-level handling if necessary.

### Floating-Point Arithmetic:

We will cover:

1. The more complex algorithms for performing addition, subtraction, multiplication, and division on floating-point numbers according to the IEEE 754 standard
2. The steps involved, such as aligning exponents, performing the operation on the significands, and normalizing the result.
3. Guard bits, rounding techniques, overflow, and underflow, would also be covered. Understanding these is crucial for appreciating the limitations and potential sources of error in floating-point computations.

Let's cover these in the [CODmips textbook's Chapter 3 presentation deck](./Patterson6e_MIPS_Ch03_PPT.ppt)
