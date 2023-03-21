# Modern Computer Programming

[computer_abstraction]: ./Modern_Computer_Programming_with_steps.png
[mips32_qtspim]: ./qtspim_example.png
[endianness]: ./Endianness.png
[mips_asm_guide]: ./AssemblyLanguageProgDoc.pdf
[console_hello]: ./console-hello.png
[mips32_mem_layout]: ./mips32_memory_layout.png

## Introduction

This course focuses on writing assembly language programs for the 32-bit MIPS central processing unit (CPU), aka `mips32`, as well as learn how the CPU is design, built, and implemented at the logical level and used with memory and input/output from/to humans and other machines. See the [Wikipedia summary on MIPS](https://en.wikipedia.org/wiki/MIPS_architecture_processors).

The steps to program a modern, general purpose computer, such as `mips32`, often follow the flow:

![Modern Computer Programming Steps][computer_abstraction]

0. Use an algorithm to solve a problem and include the requisite data on which to process.
1. Write the algorithm using a high-level computer programming language, e.g., C, C++, Java, Python, Go, Rust, and many others. Certain languages like Java are compiled down to bytecode which is the equivalent of machine code that runs on a virtual machine; for Java it's the Java Virtual Machine. For our study and work, the high-level language we use is C.
2. Once the programmer finishes writing the software code (program), they will use the language's compiler to create _unlinked machine code_ that conforms to the computers instruction set architecture (ISA); for example, a PC running an `x86` CPU, or one running an `arm64` CPU, or one running a `mips32` CPU. Our work and study will focus on the [`mips32` processor](https://www.mips.com/products/architectures/mips32-2/). During this step, the compiler runs through its own steps to convert the high-level language to the respective CPU's machine code. The compilation steps are
   1. Preprocess (expand code, e.g., pull in the include files where called out)
   2. Compile (convert `high-level code` to `assembly code` for CPU)
   3. Optimize the assembly code then convert the final assembly code into `machine code`.
   4. Link the resulting `machine code`, that is, convert the labels in the assembly code to actual relative memory addresses, so that when the operating system (OS) loads the code into memory from the disk the labels have absolute memory addresses, readied to run properly. The final linked machine code is called an `executable program`.
3. Once the ``executable program` is ready from the development process, you have an application that can be run on the CPU using the OS running on that computer.

## What is Assembly Programming?

As shown in the above figure, (Step 1) the compiler for the language and the computer runs the step going from high-level language representation of your program to object code. An intermediate step from compilation to object code involves `assembly language` transformation of the high-level lanaguage. (Step 1') A programmer can also start writing their program using a lower-level language, in this case, that's called `assembly language` for the specific processor that serves as the CPU to the type of computer on which you're going to run your program.

Assembly programming starts with knowing the ISA of the CPU, in our case, `mips32`. The ISA reference card (green card) for the `mips32` CPU is located [here](./MIPS_Green_Sheet.pdf). Also, you can also read through the product page of the `mips32` CPU [here](https://www.mips.com/products/architectures/mips32-2/). The vendor provides their own green card [here](https://s3-eu-west-1.amazonaws.com/downloads-mips/documents/MD00565-2B-MIPS32-QRC-01.01.pdf). We will use the `spim` simulation software, which was written by James Larus of University of Wisconsin-Madison. [Here](./spim_documentation.pdf) is the `spim` documentation from James Larus. Also here is the [link](https://pages.cs.wisc.edu/~larus/spim.html) from his university's web page. `spim` provides a MIPS R2000 simulator on which we will run our assembly programs. The simulator can be run on a Linux-based command-line program or a [GUI-based application](https://spimsimulator.sourceforge.net/), either using X-Windows or using Qt windowing system on Windows and Apple Mac OS. It is important to note that the `endianness` of the memory as represented in `spim` or `QtSpim` is determined by the host computer's CPU. So if an `x86` CPU powers your computer, then it's `little endian` (LE). The `mips32` CPU is `big endian` (BE). The following image summarizes what the concept of BE and LE are in terms of which position in memory are the data stored and addressed.

![Endianness][endianness]

Read [Wikipedia's entry on `endianness`](https://en.wikipedia.org/wiki/Endianness).

## `mips32` Memory

To execute a program on a `mips32` computer, memory needs to be allocated. A `mips32` computer can address 4 gigabytes (GB) of addressable memory, from address `0x0000 0000` to `0xffff ffff`. Programmer, or user, memory is limited to memory addresses below `0x7fff ffff`. The figure below describes the `mips32` memory layout.

![MIPS32 Memory Layout][mips32_mem_layout]

Each of the memory segments serves a specific purpose in running logic on the computer:

1. The user-level code written by the programmer is stored in the `text segment`. Programs that the user seeks to run will be stored at start of this memory location (`0x0040 0000`).
2. The `data segment` stores the `static data` which refers to program data that are known at compile-time.
3. The `heap` stores `dynamic data` which is program data that are allocated while the program runs, thatis, during run-time. `heap` grows in memory towards higher memory addresses but is limited to under the stack segment.
4. User programs use the `stack` to store temporary data. It is most commonly used during function (subroutine) calls where you would temporarily save values of specific registers as the MIPS ISA requires. See MIPS Green Card.
5. The `kernel text segment` is where kernel-level program code is stored in memory. Such code includes `exception and interrupt handlers`. A `mips32` computer would run an operating system (OS) like Linux, which would provide the kernel program logic. Think of the kernel as the primary program orchestrating all user programs to run on the CPU.
6. The `kernel data segment` stores the static data used by the kernel.
7. The `memory-mapped IO segment` stores the memory-mapped registers for IO devices, e.g., USB drives, mice, etc.

## Writing an Assembly Program for `mips32`

A `mips32` assembly program has the following basic structure. Let's start with the assembly program file called `hello.asm`. Note that assembly programs should have either `.s`, `.S`, `.asm`, or `.ASM` as file format extensions. Note `#` means anything following it and itself denote a comment to the assembler and is summarily ignored. That is, there is no code at `#` or beyond for the remainder of the line in quesiton.

```assembly
        .data
msg:    .asciiz "Hello, World!" # a NUL-terminated string
pi:     .word   314159
	    .extern foobar 4

        .text
        .globl main
main:   li $v0, 4       # syscall 4 (print_str)
        la $a0, msg     # argument: string
        syscall         # print the string
        lw $t1, foobar

        jr $ra          # return to caller
```

Since `spim` is a simulator of a basic `mips32` computer, there is no operating system (OS). Therefore, the simulator provides basic OS-like functionality to the assembly programmer via the assembly call `syscall`. For example, some basic `syscall` functions include exit from program, print to a console, input from the user, and others. See [this link](https://syscalls.w3challs.com/?arch=mips_o32) for the full set of `syscall` functions available to `mips32` CPUs. Officially, from the MIPS documentation (see this [MIPS Assembly Language Programmer’s Guide](./AssemblyLanguageProgDoc.pdf), page 5-26), `syscall` "causes a system call trap. The OS interprets the information set in specific registers to determine what system call to do."

After righting an assembly program using the `mips32` ISA, you simply load the program file into `QtSpim` by choosing the menu "File" &rarr; "Load" then select the `hello.asm` file.

![QtSpim Exampl][mips32_qtspim]

Run the program by choosing the menu "Simulator" &rarr; "Run/Continue" as you watch the "Text" and "Int Regs [16]" sub-windows in `QtSpim`. A `console` window will appear and output "Hello, World!" as shown below:

![QtSpim Console Hello][console_hello]

You will be able to see the CPU's registers, program counter (PC), text code, kernel text code, and memory values (data and kernel data).

Congratulations! You have written your first `mips32` assembly program. Let's move on to some more challenging topics.

### Assembler Macros

A `mips32` assembler is the program which translates `mips32` assembly language code to `mips32` binary machine language code. The assembler provides a set of macros to simplify the task of writing MIPS assembly language code, meaning you write less code. Macros are also called `synthetic` or `pseudo` instructions. Each call of a macro instruction, the assembler replaces with the respective, equivalent set of actual `mips32` instructions to deliver the expected outcome. Below are some macro examples. Check [MIPS Official Assembly Language Guide](./Official%20MIPS%20Assembly%20Language%20Guide.pdf) for more.

#### (a) `nop` &mdash; "no op"

`nop` &larr; `sll $zero, $zero, $zero`

#### (b) `not` &mdash; "logical not"

`not $v1` &larr; `nor $v1, $zero, $v1`

#### (c) `move` &mdash; "move from one reg to another"

`move $v1, $a0` &larr; `addu $v1, $a0, $zero`

#### (d) `la` &mdash; "load address from label"

`la $a0, addrLabel` &larr;

`lui $at, 4097`

`#(0x1001 → upper 16 bits of $at).`

`ori $a0, $at, disp`

`# where the immediate (“disp”) is the number of bytes between the first data location (always 0x 1001 0000) and the address of the first byte in the string.`

This is a [good list](https://en.wikibooks.org/wiki/MIPS_Assembly/Pseudoinstructions) of `mips32` common macros.

### Assembler Directives

The assembler also provides a set of directives which are instructions to the assembler that specify a specif action to be taken during the assembly process, that is translation of the assembly code into machine code. One important use of directives is declaring or reserving variables in memory. Another use is to break up the program into sections of memory. Directives always start with a period ("."). Usually, a `.data` section only contains `data` directives, and a `.text` section only contains instructions.A `mips32` program can have multiple sections of `.data` and `.text`. The assembler groups all of the `.data` sections together in data memory segments and all of the `.text` sections together in text memory segments. See [MIPS32 Assembler Directives Short Summary](./MIPS32%20Assember%20Directives.pdf).

| Directive | Operand Syntax                          | Meaning                                                                                                                                                                                                                                                                          |
| --------- | --------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `.align`  | `.align n`                              | Align the next datum on a `2^n` byte boundary. For example, `.align 2` aligns the next value on a word boundary. `.align 0` turns off automatic alignment of `.half`, `.word`, `.float`, and `.double` directives until the next `.data` or `.kdata` directive.                  |
| `.globl`  | `.globl label {, label }\*`             | Declares labels to be global and can be referenced from other files.                                                                                                                                                                                                             |
| `.data`   | `.data [<addr>]`                        | Start a data section. Subsequent items are stored in the data segment. If the optional argument `addr` is present, subsequent items are stored starting at address `addr`.                                                                                                       |
| `.text`   | `.text [<addr>]`                        | Start an instruction section. Subsequent items are put in the `user text segment`. In SPIM, these items may only be instructions or words (see the `.word` directive below). If the optional argument `addr` is present, subsequent items are stored starting at address `addr`. |
| `.word`   | `.word integer [:non-negative integer]` | Declare C `int` variable                                                                                                                                                                                                                                                         |
| `.byte`   | `.byte b1, ..., bn`                     | Store the n values in successive words of memory. Recall endianness.                                                                                                                                                                                                             |
| `.ascii`  | `.ascii string`                         | Declare a string variable without NULL termination. Be careful since the string will ultimately need to be NULL-terminated. Strings are enclosed in double quotes (”)                                                                                                            |
| `.asciiz` | `.asciiz string`                        | Declare a NULL-terminated string variable. Strings are enclosed in double quotes (”)                                                                                                                                                                                             |
| `.space`  | `.space n`                              | Allocate `n` bytes of space in the current segment (which must be the data segment in `SPIM`).                                                                                                                                                                                   |

NOTE: The braces and asterisk are not part of the assembly language code. They are markup notation indicating that the contents inside the braces can be repeated zero or more times. This means that the operands for the `.globl` directive can be a list of labels separated by commas. The ASCII code `back space` (`0x08`) is not supported by the `SPIM` simulator. Numbers are `base 10` by default. If they are preceded by 0x, they are interpreted as hexadecimal. Hence, `256` and `0x100` denote the same value.

Most operating systems or `mips32` emulators require that the `main` or `start` label be declared with `.globl` in order for the program to start executing at the correct address. This is not needed if the `main` or `start` label is at the beginning of the first text segment.

The first operand for `.word` specifies the initial value for the variable. The second operand specifies the number of repetitions of the size of `word` - that is, 4 bytes in `mips32`. The brackets are not part of the assembly language code. They only indicate that the second operand is optional. This is regular expression notation.

### Program Use of `mips32` Registers

When writing simple programs for a `mips32` computer, you should only use the following registers:

1. `$zero` for the constant zero value `0`
2. `$s0` - `$s8` for main program variables
3. `$t0` - `$t8` for subroutine (function) variables
4. `$a0` - `$a3` for subroutine and `syscall` parameters
5. `$v0`, `$v1` for subroutine return values and `syscall` codes and return values to the calling subroutine.

When you're writing more complex programs, you should follow the conventions of register usage conventions that specify how main programs and subroutines must coordinate their use of registers. If not, then logic will not be deterministic.

| Register     | Name                   | Use                                             | Preserved Across Calls |
| ------------ | ---------------------- | ----------------------------------------------- | ---------------------- |
| `$zero`      | `$0`                   | constant integer value `0`                      | -                      |
| `$s0`-`$s8`  | `$16`-`$23`, `$30`     | saved values                                    | yes                    |
| `$sp`        | `$29`                  | stack pointer                                   | yes                    |
| `$ra`        | `$31`                  | return address                                  | no                     |
| `$a0`-`$a3`  | `$4`-`$7`              | first 4 subroutine parameters                   | no                     |
| `$t0`-`$t9`  | `$8`-`$15`,`$24`-`$25` | temporaries                                     | no                     |
| `$v0`, `$v1` | `$2`, `$3`             | expression evaluation & subroutine return value | no                     |
| `$at`        | `$1`                   | reserved by assembler                           | DO NOT USE             |
| `$gp`        | `$28`                  | global pointer                                  | DO NOT USE             |
| `$k0`, `$k1` | `$26`, `$27`           | reserved by OS                                  | DO NOT USE             |

The usage convention designations have significant implications for both subroutines and their calling logic. When a register is designated as "preserved across calls", it means that the caller can depend on the register having the same contents before and after a subroutine call. If the subroutine uses one of these registers, the programmer should save the register value before changing it and restore the value before returning. If a register is designated as "not preserved across calls", it means that the caller cannot count on the register having the same contents before and after a subroutine call. Therefore, the subroutine can use the register freely. If the caller puts a value into one of these registers before a subroutine call and needs the value after the call, then the caller has the responsibility of saving and restoring the value.
If a register is designated as "DO NOT USE", it means that the register is used either by the operating system or the assembler. Most programs should avoid the use of these registers. They're dangerous to use.

### Program Use of `mips32` "`syscall`" Functions

In our programming of `mips32`, we will be writing and running programs that will run on software engines that emulate the `mips32` computer, that is, it's CPU, memory, data path, input, and output. Modern computers run operating systems (OS) which serve as the orchestrator of all programs, sharing computer resources across these programs. The user seems to run many programs simultaneously, easing the use of the computer to perform many tasks. In reality, the OS coordinates the computer resources to ensure the deterministic execution of each program. Since this course is an introductory course in computer archicture, we assume the CPU is a uniprocessor, that is, there is only one core processor, not many as is the case in modern CPUs like Intel Core, AMD Ryzen, Apple M1/M2, and others.

Some basic `syscall` functions usually used in our coursework:
|Service|Code in `$v0`|Arguments|Results|
|-|-|-|-|
|Print an integer|1|`$a0` = value to print|Print value in Console|
|Print an float|2|`$a0` = value to print|Print value in Console|
|Print an double|3|`$a0` = value to print|Print value in Console|
|Print a string|4|`$a0` = address of string to print|Print string in Console|
|Read an integer from input|5|`$a0` = value to print|Integer Returned in `$v0`|
|Read a float from input|6|`$a0` = value to print|Float Returned in `$v0`|
|Read a double from input|7|`$a0` = value to print|Double Returned in `$v0`|
|Read a string from input|8|`$a0` = address of input buffer in memory; `$a1` = length of buffer|String now in input buffer starting at address|
|Allocate `heap` memory; aka `sbrk`|9|`$a0` = number of bytes to allocate|`$v0` contains address of allocated memory|
|Exit|10||Program execution ends|
|Exit-s|17|`$a0` = termination result|Program execution ends, return value|

The syscall `Read Integer` reads an entire line of input from the keyboard up to and including the `newline` character. Characters following the last digit in the decimal number are ignored. The syscall `Read String` has the same semantics as the Unix library routine `fgets`. It reads up to `n – 1` characters into a buffer and terminates the string with a `NULL` byte. If fewer than
`n – 1` characters are on the current line, the syscall `Read String` reads up to and including the `newline` character and again NULL-terminates the string. The syscall `Print String` will display on the console the string of characters found in memory starting with the location pointed to by the address stored in `$a0`. Printing will stop when a `NULL` character is located in the string. This is why you should be careful printing a string defined with `.ascii`. What `NULL` character will it use? The syscall `sbrk` returns a pointer to a block of memory containing `n` additional bytes. The syscall `Exit` terminates the user program execution and returns control to the operating system, and `Exit-2` does same as `Exit` but returns the value stored in `$a0` which can then be accessed by the OS in a Bash shell with command `echo $?`. The C equivalent code is as follows for `Exit-2`:

```c
int main(void)
{
        return(0);
}
```

The `main` function returns value `0`, which is passed to the OS then available by the shell via accessing the environment variable `$?`.

### `mips32` Assembly Language Commands

Check the official manual for the [MIPS32 Instruction Set Architecture](./Official%20MIPS%20Instruction%20Set%20Manual.pdf).

### `mips32` Working with Subroutines

A typical program of any reasonable complexity usually involves a `main program` that calls `subroutines`, or `functions`. Any important variables in the main program that must be maintained across function calls should be assigned to registers `$s0` through `$s7`. As programs become more complex, functions will call other functions. This is referred to as `nested function calls`. A function that does not call another function is referred to as a `leaf function`. When writing a function, the programmer can utilize registers `$t0` through `$t9` with the understanding that _no other code modules expect values in these registers will be maintained_. If additional registers are needed within the function, the programmer may use only registers `$s0` through `$s7` if they _first_ save these registers' respective, current values on the `stack` and restores their values before exiting the function. Registers `$s0` through `$s7` are referred to as `callee-saved registers`. Registers `$t0` through `$t9` are referred to as `caller-saved registers`. This means that if the code module requires that the contents of certain “`t`” registers must be maintained upon return from a call to another function, then it is the responsibility of the calling module to save these values on the stack and restore the values upon returning from the function call. Registers `$a0` through `$a3` are used to pass _arguments_ to functions, and registers `$v0` and `$v1` are used to return values from functions.

### Translation of Conditional Control Structures

#### (a) Convert `if`-`then`-`else` to Assembly

```c
if ($t8 < 0)
then
{
        $s0 = 0 - $t8;
        $t1 = $t1 +1
}
else
{
        $s0 = $t8;
        $t2 = $t2 + 1
}
```

This C pseudocode translates to the following `mips32` assembly code fragment.

Note: In `mips32` assembly language, anything on a line following the number sign (#) is a comment. Notice how the comments in the code below help to make the connection back to the original pseudocode.

```assembly
        bgez $t8, else          # if ($t8 is > or = zero) branch to else
        sub $s0, $zero, $t8     # $s0 gets the negative of $t8
        addi $t1, $t1, 1        # increment $t1 by 1
        b next                  # branch around the else code
else:
        ori $s0, $t8, 0         # $s0 gets a copy of $t8
        addi $t2, $t2, 1        # increment $t2 by 1
next:
```

#### (b) Convert `while` Loop to Assembly

```c
$v0 = 1
while ($a1 < $a2) do
{
        $t1 = mem[$a1]
        $t2 = mem[$a2]
        if ($t1 != $t2)
                go to break
        $a1 = $a1 + 1
        $a2 = $a2 - 1
break:
        $v0 = 0
        return
}
```

This C pseudocode translates to the following `mips32` assembly code fragment.

```assembly
        li $v0, 1               # Load Immediate $v0 with the value 1
loop:
        bgeu $a1, $a2, done     # If( $a1 >= $a2) Branch to done
        lb $t1, 0($a1)          # Load a Byte: $t1 = mem[$a1 + 0]
        lb $t2, 0($a2)          # Load a Byte: $t2 = mem[$a2 + 0]
        bne $t1, $t2, break     # If ($t1 != $t2) Branch to break
        addi $a1, $a1, 1        # $a1 = $a1 + 1
        addi $a2, $a2, -1       # $a2 = $a2 - 1
        b loop                  # Branch to loop
break:
        li $v0, 0               # Load Immediate $v0 with the value 0
done:
```

#### (c) Convert `for` Loop to Assembly

```c
$a0 = 0;
for ( $t0 =10; $t0 > 0; $t0 = $t0 -1)
{
        $a0 = $a0 + $t0
}
```

converts to the following `mips32` assembly.

```assembly
        li $a0, 0               # $a0 = 0
        li $t0, 10              # Initialize loop counter to 10
loop:
        add $a0, $a0, $t0
        addi $t0, $t0, -1       # Decrement loop counter
        bgtz $t0, loop          # If ($t0 > 0) Branch to loop


# Decrement loop counter
# If ($t0 > 0) Branch to loop
```

#### (d) Convert Arithmetic Expressions to Assembly

```c
$s0 = srt( $a0 * $a0 + $a1 * $a1);
```

converts to the following `mips32` assembly.

```assembly
        mult $a0, $a0           # Square $a0
        mflo $t0                # $t0 = Lower 32-bits of product
        mult $a1, $a1           # Square $a1
        mflo $a1                # $t1 = Lower 32-bits of product
        add $a0, $t0, $t1       # a0 = t0 + t1
        jal srt                 # Call the square root function
        move $s0, $v0           # Result of sqr is returned in $v0 (Standard Convention)
```

```c
$s0 = ( Y * $t8 * $t8) / 2;
```

converts to the following `mips32` assembly.

```assembly
        li $t0, 31415           # Pi scaled up by 10,000
        mult $t8, $t8           # Radius squared
        mflo $t1                # Move lower 32-bits of product in LOW register to $t1
        mult $t1, $t0           # Multiply by Pi
        mflo $s0                # Move lower 32-bits of product in LOW register to $s0
        sra $s0, $s0, 1         # Division by two (2) is accomplished more efficiently
                                # using the Shift Right Arithmetic instruction
```

#### (e) Convert a C integer array to Assembly

```c
int array[1024] ;
```

converts to the following `mips32` assembly.

```assembly
        .data
array:  .space 4096
```

Note: The assembler directive `.space` requires that the amount of space to be allocated must be specified in bytes. Since there are four bytes in a word, an array of 1024 words is the same as an array of 4096 bytes.

To initialize a memory array with a set of 16 values corresponding to the powers of 2 ( 2^N with N going from 0 to 15), the following construct is used in the C language:

```c
int pof2[16] ={ 1, 2, 4, 8, 16, 32, 64, 128, 256, 512, 1024, 2048, 4096, 8192, 16384, 32768 }
```

```assembly
        .data
pof2:
        .word 1, 2, 4, 8, 16, 32, 64, 128, 256, 512, 1024, 2048, 4096, 8192, 16384, 32768

        .text
main:
        la $a0, pof2    # a0 =&pof2
        lw $s0, 8($a0)  # s0 = MEM[a0 + 8]
```

Note: The `Load Address` (`la`) macro instruction initializes the pointer `$a0` with the base address of the array `pof2.` After executing this code, register `$s0` will contain the value `4`. To access specific words within the array, the constant offset must be some multiple of four. The smallest element of information that can be accessed from memory is a byte, which is 8 bits of information. There are 4 bytes in a word. The address of a word is the same as the address of the first byte in a word.

# Useful Links

1. [MIPS Converter (instruction &rarr; hex &rarr; instruction)](https://www.eg.bucknell.edu/~csci320/mips_web/)
2. [Hex to Binary Converter](https://www.rapidtables.com/convert/number/hex-to-binary.html)
3.
