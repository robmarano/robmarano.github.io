.data
    myArray: .word 10, 20, 30, 40, 50  # An array of five 32-bit integers
    length:  .word 5                   # The number of elements
    sum:     .word 0                   # Variable to store final result

.text
.globl main

main:
    # --- Initialization ---
    la $t0, myArray      # $t0 = Base address of the array
    lw $t1, length       # $t1 = Loop counter (starts at 5)
    li $t2, 0            # $t2 = Accumulator (sum starts at 0)

loop:
    # --- Check Loop Condition ---
    # If counter ($t1) is 0, jump to the end
    beq $t1, $zero, end_loop

    # --- Load Data and Add ---
    lw $t3, 0($t0)       # Load the current 32-bit word into $t3
    add $t2, $t2, $t3    # sum = sum + $t3

    # --- Update Pointer and Counter ---
    addi $t0, $t0, 4     # Move pointer to the next word (add 4 bytes)
    addi $t1, $t1, -1    # Decrement the loop counter
    
    j loop               # Jump back to the start of the loop

end_loop:
    # --- Store Result ---
    sw $t2, sum          # Store the final sum back into RAM

    # --- End Program ---
    li $v0, 10
    syscall
