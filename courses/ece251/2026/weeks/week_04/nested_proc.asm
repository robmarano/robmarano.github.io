# File: nested_proc.asm
# Description: Demonstrates nested procedure calls.
# 
# Key Concepts:
# - Saving $ra, $s0, etc. on the stack
# - Calling another procedure within a procedure
# - Restoring registers after the call.

.data
    g_x: .word 5
    g_y: .word 10
    
.text
.globl main

# -------------------------------------------------------------
# main:
#   Entry point. Sets up arguments and calls 'nested_proc'.
# -------------------------------------------------------------
main:
    # 1. Load arguments
    la $t0, g_x
    lw $a0, 0($t0)          # Arg 1: 5
    la $t0, g_y
    lw $a1, 0($t0)          # Arg 2: 10
    
    # 2. Call nested_proc
    jal nested_proc

    # 3. Print result
    move $a0, $v0
    li $v0, 1
    syscall

    # 4. Exit
    li $v0, 10
    syscall

# -------------------------------------------------------------
# nested_proc:
#   This procedure calls another procedure (add_em).
#   It must save its return address ($ra) because 'jal add_em' will overwrite it.
#   It also might need to save temporary registers ($t0-$t9) if they are needed across calls.
#
#   Input:  $a0, $a1
#   Output: $v0 (result of add_em + 1)
# -------------------------------------------------------------
nested_proc:
    # 1. Save Context (Prologue)
    addi $sp, $sp, -4       # Make room on stack (4 bytes)
    sw   $ra, 0($sp)        # Save return address

    # 2. Call Another Procedure
    jal  add_em             # Call 'add_em'. This changes $ra to point here+4.

    # 3. Use Result and Modify
    addi $v0, $v0, 1        # Add 1 to result: (a+b) + 1

    # 4. Restore Context (Epilogue)
    lw   $ra, 0($sp)        # Restore original return address
    addi $sp, $sp, 4        # Pop stack

    # 5. Return
    jr   $ra                # Return to caller

# -------------------------------------------------------------
# add_em:
#   Leaf procedure. Does not call others. No stack needed.
# -------------------------------------------------------------
add_em:
    add $v0, $a0, $a1
    jr $ra
