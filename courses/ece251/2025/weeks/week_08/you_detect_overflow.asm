    .text
    .globl main
main:
    li $t0, 0                   # count = 10 (initialization)
    li $t1, 1
    subu $t2, $t0, $t1
    slt $t3, $t2, $t0
    slt $t4, $t2, $t1

    li $v0, 10                            # ... rest of the program ...
    syscall
