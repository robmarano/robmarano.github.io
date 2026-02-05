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
