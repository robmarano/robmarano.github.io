    .data
save:    .word 0, 1, 2, 3, 0, 5, 6, 7
    .text
main:
    # i = $s3, k = $s5, save = $s6
    la $s6, save
    add $s5, $zero, $zero # k = 0
Loop:
    sll $t1, $s3, 2 # Temp reg $t1 = i * 4
    add $t1, $t1, $s6 # $t1 = address of save[i]
    lw $t0, 0($t1) # Temp reg $t0 = save[i]
    bne $t0, $s5, Exit # go to Exit if save[i] ≠ k
    addi $s3, $s3, 1 # i = i + 1
    j Loop # go to Loop

Exit:
    li $v0, 1       # syscall 1 (print_int)
    add $a0, $s3, $zero
    syscall