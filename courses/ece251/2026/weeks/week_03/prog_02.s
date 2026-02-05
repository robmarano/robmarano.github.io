# ECE 251 - Week 3 Example 2
# Topics: Branching, Loops, Inequalities
# Textbook Section: 2.7

.data
    array:  .word 10, 20, 30, 40, 50  # An array of integers
    length: .word 5                   # Length of the array
    target: .word 30                  # Value we are searching for

.text
.globl main

main:
    # Initialize variables
    la   $s0, array         # $s0 = Base address of array
    lw   $s1, length        # $s1 = Array length (5)
    lw   $s2, target        # $s2 = Target value (30)
    li   $t0, 0             # $t0 = i (Loop iterator/index), init to 0

# ---------------------------------------------------------
# LOOP STRUCTURE (Simulating a C while loop)
# while (i < length) { ... }
# ---------------------------------------------------------
Loop_Start:
    # 1. INEQUALITY CHECK (Set Less Than)
    # Check if i < length. 
    # slt sets destination to 1 if true, 0 if false.
    slt  $t1, $t0, $s1      # if ($t0 < $s1) set $t1 = 1, else $t1 = 0
    
    # 2. CONDITIONAL BRANCH (Exit if condition fails)
    # If $t1 is 0, then i >= length, so we exit the loop.
    beq  $t1, $zero, Loop_Exit 

    # -----------------------------------------------------
    # Loop Body: Access Array[i] and Compare
    # -----------------------------------------------------
    
    # Calculate byte offset: offset = i * 4 (since words are 4 bytes)
    sll  $t2, $t0, 2        # $t2 = i << 2 (multiplying by 4)
    
    # Get address of Array[i]: Base + Offset
    add  $t3, $s0, $t2      # $t3 = &array[i]
    
    # Load value: val = Array[i]
    lw   $t4, 0($t3)        # $t4 = array[i]

    # Check for equality: if (Array[i] == target)
    beq  $t4, $s2, Found_Target

    # Increment iterator: i++
    addi $t0, $t0, 1        
    
    # 3. UNCONDITIONAL JUMP
    # Go back to the start of the loop
    j    Loop_Start

Found_Target:
    # If we get here, we found the number. 
    # We can perform an action, or just exit.
    # For this example, we jump to exit.
    j    Loop_Exit

Loop_Exit:
    # End of program
    li   $v0, 10
    syscall