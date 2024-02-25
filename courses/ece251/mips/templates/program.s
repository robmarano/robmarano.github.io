################################################################################
#
# file:    program.s
# author:  Prof Rob Marano <rob.marano@cooper.edu>
# date:    2024-02-24
# purpose: This program is a simple example of an assembly language program
#          that can be assembled and run on a MIPS32 simulator.
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
