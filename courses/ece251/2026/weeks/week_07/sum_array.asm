    .data
myArray: .word 10, 20, 30, 40, 50   # 5 integers (20 bytes total)
length:  .word 5
newline: .asciiz "\n"

    .text
    .globl main
main:
    la  $t0, myArray    # $t0 = Base address pointer of the array
    lw  $t1, length     # $t1 = Total elements (5)
    li  $t2, 0          # $t2 = Current index counter (starts at 0)
    li  $t3, 0          # $t3 = Running sum accumulator (starts at 0)
    
Loop_Start:
    beq $t2, $t1, Loop_End  # If counter == length, we're done! Exit loop.
    
    lw  $t4, 0($t0)         # Load the physical word at the current pointer address
    add $t3, $t3, $t4       # Add it to our running sum
    
    addi $t0, $t0, 4        # CRITICAL: Shift the memory pointer up by 4 bytes!
    addi $t2, $t2, 1        # Increment our logical loop counter by 1
    
    j   Loop_Start          # Unconditionally jump back up to evaluate the next loop

Loop_End:
    # Print the final sum ($t3)
    li  $v0, 1          # syscall 1 = print integer
    move $a0, $t3       # move our accumulated sum into the argument register
    syscall             # execute print
    
    # Print trailing newline
    li  $v0, 4          # syscall 4 = print string
    la  $a0, newline
    syscall
    
    # Exit cleanly
    li  $v0, 10         # syscall 10 = exit
    syscall
