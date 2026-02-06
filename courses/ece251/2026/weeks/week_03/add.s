# -------------------------------------------------------------------
# Program: Simple Addition
# Purpose: Demonstrate memory loading and instruction execution
# -------------------------------------------------------------------

.data
    val_a:  .word 4
    val_b:  .word 8
    result: .word 0

.text
.globl main

main:
    # 1. Load val_a from memory into register $t0
    lw $t0, val_a
    
    # 2. Load val_b from memory into register $t1
    lw $t1, val_b
    
    # 3. Add registers $t0 and $t1, store in $t2
    add $t2, $t0, $t1       
    
    # 4. Store the result back into the 'res' memory location
    sw $t2, result             

    # Exit the program (SPIM syscall for exit)
    li $v0, 10
    syscall
