# File: recursive_proc.asm
# Description: Demonstrates recursion by calculating Factorial(n).
# 
# Key Concepts:
# - Saving $ra, $a0, and $s0 on the stack (Stack Frames)
# - Base Case to stop recursion (n < 2)
# - Handling recursion: fact calls fact(n-1)

.data
    g_n: .word 5            # Number to calculate factorial for

.text
.globl main

# -------------------------------------------------------------
# main:
#   Entry point. Loads 'g_n' and calls 'fact(g_n)'.
#   Finally, print the result from $v0.
# -------------------------------------------------------------
main:
    # 1. Setup Arguments: factorial(5)
    la $t0, g_n             # Load address of global variable
    lw $a0, 0($t0)          # Load value (5) into $a0

    # 2. Call Factorial Procedure
    jal fact                # Recursive call
    
    # 3. Handle Result
    move $a0, $v0           # Move result into $a0 for printing
    li $v0, 1               # syscall 1: print_int
    syscall

    # 4. Exit
    li $v0, 10
    syscall

# -------------------------------------------------------------
# Function: fact
# Purpose: Calculates n! (n factorial) recursively.
#
#   int fact(int n) {
#       if (n < 2) return 1;
#       else return n * fact(n-1);
#   }
# 
# Input:  $a0 (int n)
# Output: $v0 (int n!)
# -------------------------------------------------------------
fact:
    # 1. Check Base Case: if (n < 2)
    slti $t0, $a0, 2        # Set $t0 = 1 if $a0 (n) < 2
    bne  $t0, $zero, fact_base_case # If $t0 != 0, jump to base case

    # 2. Recursion Case: n >= 2
    #    We MUST save $ra (return address) and $a0 (our current n) to stack
    addi $sp, $sp, -8       # Make room for 2 words (8 bytes) on stack
    sw   $ra, 4($sp)        # Save current $ra at offset 4
    sw   $a0, 0($sp)        # Save current argument (n) at offset 0

    # 3. Setup Recursive Call: fact(n-1)
    addi $a0, $a0, -1       # $a0 = n - 1
    jal  fact               # Recursively call fact(n-1)

    # 4. Restore Context
    lw   $a0, 0($sp)        # Restore original n ($a0) from stack
    lw   $ra, 4($sp)        # Restore original return address ($ra)
    addi $sp, $sp, 8        # "Pop" stack (reclaim space)

    # 5. Do Calculation: result = n * result_from_recursive_call
    #    $v0 currently holds fact(n-1). We need n * fact(n-1).
    mul  $v0, $a0, $v0      # $v0 = n ($a0) * fact(n-1) ($v0)
    jr   $ra                # Return to caller

fact_base_case:
    # 6. Handle Base Case: return 1
    li   $v0, 1             # Result is 1
    jr   $ra                # Return to caller
