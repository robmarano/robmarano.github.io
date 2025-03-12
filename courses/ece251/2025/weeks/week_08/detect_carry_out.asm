    .text
    .globl main
main:
    # li $t0, 0xFFFF
    # lui $t1, 0x7FFF
    # add $t1, $t1, $t0 # number

    li $t0, 0x0000
    lui $t1, 0x8000
    lui $t2, 0x7000
    slt $t4, $t1, $zero
    slt $t5, $t2, $zero
    # add $t6, $t4, $t5 # or just do the and
    and $t6, $t4, $t5



    li $v0, 10
    syscall
