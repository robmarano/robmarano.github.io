    .data
hellostr:
    .asciiz "Hello, World!\n"

    .text
    .globl main
main:
    la $a0, hellostr
    li $v0, 4
    syscall

    li $v0, 10
    syscall