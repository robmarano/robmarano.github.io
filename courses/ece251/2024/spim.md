# Meet SPIM

[<- back to notes](/courses/ece251/2024/
ece251-notes.html) ; 
[<- back to syllabus](/courses/ece251/2024/ece251-syllabus-spring-2024.html)

---

_Source:_ [SPIM &mdash; A MIPS32 Simulator](https://pages.cs.wisc.edu/~larus/spim.html)

> `spim` is a self-contained simulator that runs `MIPS32` programs. It reads and executes assembly language programs written for this processor. `spim` also provides a simple debugger and minimal set of operating system services. `spim` does not execute binary (compiled) programs. So provide only MIP32 assembly program files.
>
> `spim` implements almost the entire `MIPS32` assembler-extended instruction set. (It _omits_ most floating point comparisons and rounding modes and the memory system page tables.) The `MIPS` architecture has several variants that differ in various ways (e.g., the `MIPS64` architecture supports 64-bit integers and addresses), which means that `spim` will not run programs compiled for all MIPS processors. `MIPS` compilers also generate a number of assembler directives that `spim` cannot process. These directives usually can be safely ignored.
>
> Earlier versions of spim (before 7.0) implemented the `MIPS-I` instruction set used on the `MIPS R2000/R3000` computers. This architecture is obsolete (though, never surpassed for its simplicity and elegance). `spim` now supports the more modern `MIPS32` architecture, which is the `MIPS-I` instruction set augmented with a large number of occasionally useful instructions. `MIPS` code from earlier versions of `SPIM` should run without changes, except code that handles exceptions and interrupts. This part of the architecture changed over time (and was poorly implemented in earlier versions of `spim`). This type of code will need to be updated. Examples of new exception handling are in the files: `exceptions.s` and `Tests/tt.io.s`.
>
> `spim` comes with complete source code and documentation. It also include a torture test to verify a port to a new machine.
>
> `spim` implements both a terminal and a window interface. On `Microsoft Windows`, `Linux`, and `Mac OS X`, the `spim` program provides the simple terminal interface and the `QtSpim` program provides the windowing interface.

# Installing `spim`

> QtSpim
> The newest version of spim is called QtSpim, and unlike all of the other version, it runs on Microsoft Windows, Mac OS X, and Linux—the same source code and the same user interface on all three platforms! QtSpim is the version of spim that currently being actively maintaned. The other versions are still available, but please stop using them and move to QtSpim. It has a modern user interface, extensive help, and is consistent across all three platforms. QtSpim makes my life far easier, and will likely improve yours and your students' experience as well.
>
> A compiled, immediately installable version of QtSpim is available for Microsoft Windows, Mac OS X, and Linux can be downloaded from: https://sourceforge.net/projects/spimsimulator/files/. Full source code is also available (to compile QtSpim, you need Nokia's Qt framework, a very nice cross-platform UI framework that can be downloaded from here).

## Installing on `Windows`, `Linux`, and `MacOS`

Download the files from here https://sourceforge.net/projects/spimsimulator/files/.

### Another way on `MacOS`

Use Homebrew to install. There are two versions: one to run in a terminal and another to run as a GUI application, called `Qtspim`.

Terminal-based `spim`:

```bash
brew install spim
```

GUI-based `Qtspim`:

```bash
brew install --cask qtspim
```

# Working with `spim`

## At the command line

Working in a Unix-like environment, like `Linux` or `MacOS`

# Template Assembly Program File

```mips
################################################################################
#
# file:    program.s
# author:  Your Name <your.name@cooper.edu>
# date:    2024-02-24
# purpose: This program is a simple example of an assembly language program
#          that can be assembled and run on a MIPS32 simulator, like spim.
#
#2345678901234567890123456789012345678901234567890123456789012345678901234567890
################################################################################

    #------------{ global data section } ------------#
    # declare all global variables and string        #
    # constants in this section.                     #
    # The .data section contains the program's data. #
    #------------------------------------------------#
    .data

    # The .asciiz directive creates a null-terminated string.
    # The string "Hello, world!" is stored in memory.
hello:  .asciiz "Hello, world!"

    #------------{ code section }----------------------------#
    # place all main code ("mainline") and procedure code in #
    # this section of the file                               #
    #--------------------------------------------------------#
    .text

    # The .globl directive makes the main label visible to the linker.
    .globl main

    # The main label marks the beginning of the program.
    # This is mostly a formality, but it will be very
    # important later when we start writing programs with more than one function.
    # In between the initialization and exit of the function there is space
    # to actually write a program.
main:

    # initialize the program stack pointer
    subu $sp, $sp, 4

    # save the return address on the stack
    sw $ra, 4($sp)

    # The la (load address) pseudo instruction loads the address of the string
    # into register $a0.
    la $a0, hello

    # The li (load immediate) pseudo instruction loads the system call number
    # for printing a string into register $v0.
    li $v0, 4

    # The syscall instruction makes a system call (OS-provided).
    syscall

    #
    # exit the program
    #

    # restore the return address from the stack
    lw $ra, 4($sp)
    addu $sp, $sp, 4

    # return to the address in the $ra register
    j $ra

    #
    # OR, use the following code to exit the program
    #

    # The li (load immediate) pseudo instruction loads the system call number
    # for exiting the program into register $v0.
    # li $v0, 10

    # The syscall instruction makes a system call.
    # syscall
.end main
```

# Working with `.data`, `.text`, and procedures

C: `mips-1.c`

```c
#include <stdio.h>

char *prompt = "> ";
char *newline = "\n";
char *msg1 = "Hello, World!";
char *msg2 = "Integer =";
char *msg3 = "Pi =";

int foobar = 4;
float pi = 3.14159265;

void main(void)
{
    printf("%s", prompt);
    printf("%s", msg1);
    printf("%s", newline);
    printf("%s", prompt);
    printf("%s", msg2);
    printf("%d", foobar);
    printf("%s", newline);
    printf("%s", prompt);
    printf("%s", msg3);
    printf("%f", pi);
    printf("%s", newline);
}
```

Assembly: `mips-1.s`

```mips
# mips-1.s
#
        .data
foobar: .word 0x00000004
prompt: .asciiz "> " # a NUL-terminated string
newline:.asciiz "\n"
msg1:   .asciiz "Hello, World!"
msg2:   .asciiz "Integer = "
msg3:   .asciiz "Pi = "
#pi:     .word   01000000010010010000111111011011 # 3.14159265
pi:     .float   3.14159265
#	    .extern foobar 4

        .text
        .globl main
main:
        # print prompt
        la $a0, prompt
        jal print_str # jump to target and save position to $ra

        # print msg1
        la $a0, msg1
        jal print_str # jump to target and save position to $ra

        # print newline
        la $a0, newline # argument: string
        jal print_str # jump to target and save position to $ra

        # print prompt
        la $a0, prompt
        jal print_str # jump to target and save position to $ra

        # print msg2
        la $a0, msg2
        jal print_str # jump to target and save position to $ra

        # print foobar
        la $t0, foobar
        lw $a0, 0($t0)

        jal print_int # jump to target and save position to $ra

        # print newline
        la $a0, newline # argument: string
        jal print_str # jump to target and save position to $ra

        # print prompt
        la $a0, prompt
        jal print_str # jump to target and save position to $ra

        # print msg3
        la $a0, msg3
        jal print_str # jump to target and save position to $ra

        # print pi
        la $t0, pi      # load addr of float
        lwc1 $f12, 0($t0) # load into fpr
        jal print_float # jump to target and save position to $ra

        # print newline
        la $a0, newline # argument: string
        jal print_str # jump to target and save position to $ra

        # exit main
        # The li (load immediate) pseudo instruction loads the system call number
        # for exiting the program into register $v0.
        li $v0, 10

        # The syscall instruction makes a system call.
        syscall

# procedure
print_str:
    # $v0/1 and $a0-3 NOT preserved
    # fix $sp for procedures
    addi $sp,$sp,-4     # Moving Stack pointer

    # print string
    li $v0, 4       # syscall 4 (print_str)
    syscall         # print the string

    # put back $sp and return
    addi $sp,$sp,4      # Moving Stack pointer
    jr $ra              # return (Copy $ra to PC)

print_int:
    # $v0/1 and $a0-3 NOT preserved
    # fix $sp for procedures
    addi $sp,$sp,-4     # Moving Stack pointer

    # print int
    li $v0, 1       # syscall 1 (print_int)
    syscall         # print the string

    # put back $sp and return
    addi $sp,$sp,4      # Moving Stack pointer
    jr $ra              # return (Copy $ra to PC)

print_float:
    # $v0/1 and $a0-3 NOT preserved
    # fix $sp for procedures
    addi $sp,$sp,-4     # Moving Stack pointer

    # print float
    li $v0, 2       # syscall 2 (print_float)
    syscall         # print the string

    # put back $sp and return
    addi $sp,$sp,4      # Moving Stack pointer
    jr $ra              # return (Copy $ra to PC)

```

# `Qtspim` Tutorial

See https://www.lri.fr/~de/QtSpim-Tutorial.pdf
