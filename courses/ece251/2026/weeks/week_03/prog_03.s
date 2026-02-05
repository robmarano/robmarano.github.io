# ECE 251 - Week 3 Example 3
# Topics: Procedures, jal, jr, Stack Management
# Textbook Section: 2.8

.text
.globl main

# ---------------------------------------------------------
# MAIN PROGRAM (The Caller)
# ---------------------------------------------------------
main:
    # Initialize arguments for the function
    # Let's compute: leaf_example(g, h, i, j)
    # Mapping: g=$a0, h=$a1, i=$a2, j=$a3
    li  $a0, 10     # g = 10
    li  $a1, 20     # h = 20
    li  $a2, 5      # i = 5
    li  $a3, 6      # j = 6

    # CALL THE PROCEDURE
    # jal (Jump and Link) puts the address of the next instruction 
    # into register $ra, then jumps to the label.
    jal leaf_example

    # RETURN POINT
    # The result is now in $v0. 
    # (Optional: Print result using syscall 1)
    move $a0, $v0   # Move result to $a0 for printing
    li   $v0, 1     # Service 1: Print Integer
    syscall

    # Exit
    li   $v0, 10
    syscall

# ---------------------------------------------------------
# PROCEDURE: leaf_example
# C Code equivalent:
# int leaf_example(int g, int h, int i, int j) {
#    int f;
#    f = (g + h) - (i + j);
#    return f;
# }
# ---------------------------------------------------------
leaf_example:
    # 1. PROLOGUE: Adjust Stack to save registers
    # We need to use saved registers $s0, $t0, $t1 for calculation.
    # Note: Optimization might use only $t registers without saving,
    # but we will save 3 registers to demonstrate the stack concept.
    
    addi $sp, $sp, -12      # Create space for 3 words (3 * 4 bytes)
    sw   $t1, 8($sp)        # Save $t1
    sw   $t0, 4($sp)        # Save $t0
    sw   $s0, 0($sp)        # Save $s0

    # 2. BODY OF PROCEDURE
    add  $t0, $a0, $a1      # $t0 = g + h
    add  $t1, $a2, $a3      # $t1 = i + j
    sub  $s0, $t0, $t1      # $s0 = (g + h) - (i + j)

    # 3. SET RETURN VALUE
    add  $v0, $s0, $zero    # Returns f ($v0 = $s0)

    # 4. EPILOGUE: Restore registers and stack
    lw   $s0, 0($sp)        # Restore $s0
    lw   $t0, 4($sp)        # Restore $t0
    lw   $t1, 8($sp)        # Restore $t1
    addi $sp, $sp, 12       # Deallocate stack space

    # 5. RETURN TO CALLER
    jr   $ra                # Jump to address stored in $ra