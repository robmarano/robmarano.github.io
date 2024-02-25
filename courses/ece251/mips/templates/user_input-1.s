################################################################################
#
# file:    user_input-1.s
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
prompt: .asciiz "Enter name: (max 60 chars)" 
hello_str: .asciiz "Hello "
name: .space 61 # including '\0'

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

    # Print prompt
    la $a0, prompt # address of string to print
    li $v0, 4
    syscall

    # Input name
    la $a0, name # address to store string at
    li $a1, 61 # maximum number of chars (including '\0')
    li $v0, 8
    syscall

    # Print hello
    la $a0, hello_str # address of string to print
    li $v0, 4
    syscall

    # Print name
    la $a0, name # address of string to print
    li $v0, 4
    syscall

    # Exit
    # The li (load immediate) pseudo instruction loads the system call number
    # for exiting the program into register $v0.
    li $v0, 10

    # The syscall instruction makes a system call.
    syscall

.end main
