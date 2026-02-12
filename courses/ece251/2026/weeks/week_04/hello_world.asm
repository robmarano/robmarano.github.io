# File: hello_world.asm
# Description: A simple MIPS assembly program to print "Hello World" to the console.
# 
# Key Concepts:
# - System calls (syscall) for I/O
# - Data segment for string storage
# - Text segment for code
# - Main entry point

.data                       # Data segment: where global variables are declared
    msg: .asciiz "Hello World\n" # .asciiz creates a null-terminated string

.text                       # Text segment: where code instructions live
.globl main                 # Make 'main' label available to the linker/simulator

main:
    # 1. Print the string
    li $v0, 4               # Load immediate value 4 into register $v0.
                            # syscall code 4 = print_string
    la $a0, msg             # Load address of 'msg' into register $a0.
                            # $a0 is the argument for the syscall.
    syscall                 # Execute the system call specified by $v0

    # 2. Exit the program
    li $v0, 10              # Load immediate value 10 into register $v0.
                            # syscall code 10 = exit
    syscall                 # Execute the system call to terminate execution
