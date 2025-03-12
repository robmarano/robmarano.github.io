    .text
    .globl main
main:
    li $t0, 0xFFFF
    lui $t1, 0x7FFF
    add $t1, $t1, $t0
    addi $t0, $t1, 1
    li $v0, 10                            # ... rest of the program ...
    syscall
