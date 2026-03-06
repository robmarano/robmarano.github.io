    .data
myArray:    .float 10.5, 20.25, 30.125, 40.0, 50.5   # 5 floats (20 bytes total in memory)
length:     .word 5
init_sum:   .float 0.0
result_msg: .asciiz "The sum of the decimals is: "
newline:    .asciiz "\n"

    .text
    .globl main
main:
    la  $t0, myArray    # $t0 = Base address pointer of the array
    lw  $t1, length     # $t1 = Total elements (5)
    li  $t2, 0          # $t2 = Current index counter (starts at 0)
    
    # Initialize floating-point sum to 0.0 using Coprocessor 1 (FPU)
    l.s $f12, init_sum  # $f12 = Running sum accumulator (Starts at 0.0)
    
Loop_Start:
    beq $t2, $t1, Loop_End  # If counter == length, we're done! Exit loop.
    
    # Load physical float from the memory pointer directly into the Floating Point Unit
    l.s $f4, 0($t0)         
    
    # Add the extracted decimal to our running sum natively inside the FPU
    add.s $f12, $f12, $f4   
    
    addi $t0, $t0, 4        # CRITICAL: Shift the memory pointer up by 4 bytes (Floats are 32-bit Words too)!
    addi $t2, $t2, 1        # Increment our logical loop counter by 1
    
    j   Loop_Start          # Unconditionally jump back up to evaluate the next loop

Loop_End:
    # Print the descriptive text
    li  $v0, 4          # syscall 4 = print string
    la  $a0, result_msg
    syscall

    # Print the final decimal sum ($f12)
    # Note: SPIM syscall 2 inherently looks at register $f12 to find the float to print!
    li  $v0, 2          # syscall 2 = print float
    syscall             # execute print
    
    # Print trailing newline
    li  $v0, 4          # syscall 4 = print string
    la  $a0, newline
    syscall
    
    # Exit cleanly
    li  $v0, 10         # syscall 10 = exit
    syscall
