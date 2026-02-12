# File: leaf_proc.asm
# Description: Demonstrates a MIPS leaf procedure call.
# 
# Key Concepts:
# - Procedure call (jal) and return (jr)
# - Argument passing ($a0-$a3)
# - Return values ($v0-$v1)
# - No need to save $ra because we don't clobber it with another call.

.data
    g_vars: .word 10, 20    # Global arguments to be added
    
.text
.globl main

# -------------------------------------------------------------
# main:
#   Entry point. Sets up arguments and calls a leaf function.
# -------------------------------------------------------------
main:
    # 1. Load arguments into $a0 and $a1
    la $t0, g_vars          # Load address of our global array
    lw $a0, 0($t0)          # Arg 1: load first word (10)
    lw $a1, 4($t0)          # Arg 2: load second word (20)
    
    # 2. Call the leaf procedure
    jal add_em              # Jump to 'add_em' and link (save return addr in $ra)
    
    # 3. Use the return value (in $v0)
    move $a0, $v0           # Move result to $a0 to print it
    li $v0, 1               # syscall 1: print_int
    syscall

    # 4. Exit
    li $v0, 10
    syscall

# -------------------------------------------------------------
# add_em:
#   A simple leaf procedure that adds two integers.
#   Since it calls no other functions, it doesn't need to save $ra.
#
#   Input:  $a0 (int a), $a1 (int b)
#   Output: $v0 (sum)
# -------------------------------------------------------------
add_em:
    add $v0, $a0, $a1       # $v0 = a + b
    jr $ra                  # Jump register: return to address in $ra
