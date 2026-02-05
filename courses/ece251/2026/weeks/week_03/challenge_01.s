# DEBUG CHALLENGE: Find the logic error!
.data
    array:  .word 10, 20, 30, 40, 50
    length: .word 5
    target: .word 50        # We are looking for the last element
    msg_found: .asciiz "Found it!\n"

.text
.globl main
main:
    la   $s0, array
    lw   $s1, length
    lw   $s2, target
    li   $t0, 0             # i = 0

Loop_Start:
    # --- THE BUG IS LIKELY HERE ---
    # Logic: if (i < length - 1) ... wait, is that right?
    addi $t7, $s1, -1       # $t7 = length - 1 (4)
    slt  $t1, $t0, $t7      # if (i < 4) $t1 = 1
    beq  $t1, $zero, Exit   # If $t1 is 0, exit loop

    # --- Loop Body ---
    sll  $t2, $t0, 2        # Offset = i * 4
    add  $t3, $s0, $t2      # Address of array[i]
    lw   $t4, 0($t3)        # Load array[i]

    beq  $t4, $s2, Found    # Did we find 50?
    
    addi $t0, $t0, 1        # i++
    j    Loop_Start

Found:
    li   $v0, 4             # Print string syscall
    la   $a0, msg_found
    syscall

Exit:
    li   $v0, 10
    syscall