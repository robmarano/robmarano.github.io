.text
.globl sqrt_fixed

sqrt_fixed:
    # Input: $a0 (32-bit fixed-point number)
    # Output: $v0 (32-bit fixed-point square root)

    li $v0, 0       # Initialize result to 0
    li $t0, 0x80000000 # Initialize bit mask (starting with the most significant bit)
    move $t1, $a0    # Copy input to $t1

loop:
    beq $t0, 0, done # If bit mask is 0, we're done

    # Calculate potential next square
    or $t2, $v0, $t0 # Try setting the current bit in the result
    mul $t3, $t2, $t2 # Calculate the square of the potential result

    # Check if the square is less than or equal to the remaining input
    ble $t3, $t1, set_bit

    # If the square is too large, don't set the bit
    srl $t0, $t0, 1 # Shift the bit mask to the right
    j loop

set_bit:
    # Set the bit in the result
    or $v0, $v0, $t0
    sub $t1, $t1, $t3 # Subtract the square from the remaining input
    srl $t0, $t0, 1 # Shift the bit mask to the right
    j loop

done:
    jr $ra # Return