# -------------------------------------------------------------------
# Program: Simple Addition
# Purpose: Demonstrate memory loading and instruction execution
# -------------------------------------------------------------------

.data
    val_a:  .word 0x00000001
    result: .word 0

.text
.globl main

main:
    # 1. Load val_a from memory into register $t0
    lw $t0, val_a

    addi $t0, $zero, 0xffff
    lui $t1, 0xf9f8
    ori $t1, 0x2f3f

    sll $t0, $t0, 31
    
    # 4. Store the result back into the 'res' memory location
    sw $t1, result             

    # Exit the program (SPIM syscall for exit)
    li $v0, 10
    syscall
