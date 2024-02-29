# mips-2.s

    .data
n:  .word 0x00000004
msg0: .asciiz "Calculate fact of "
msg1: .asciiz "The factorial of n is "
newline:.asciiz "\n"

    .text
    .globl main
main:
    subu $sp, $sp, 32 # stack frame size is 32 bytes
    sw $ra, 20($sp)    # save return address
    sw $fp, 16($sp)    # save frame pointer
    addiu $fp, $sp, 28 # set frame pointer
    la $t0, n          # load address of n
    lw $a0, 0($t0)     # load n
    jal fact           # call fact, value in $v0

    la $a0, msg0       # load address of msg0
    jal print_str      # call print_str
    la $t0, n          # load address of n
    lw $a0, 0($t0)     # load n
    jal print_int      # call print_int
    la $a0, newline    # load address of newline
    jal print_str      # call print_str

    la $a0, msg1       # load address of msg1
    jal print_str      # call print_str
    add $a0, $v0, $zero     # result of fact
    jal print_int      # call print_int
    la $a0, newline    # load address of newline
    jal print_str      # call print_str

    lw $ra, 20($sp)    # restore return address
    lw $fp, 16($sp)    # restore frame pointer
    addu $sp, $sp, 32  # restore stack pointer
    jr $ra             # return to caller

fact:  # compute n!
    subu $sp, $sp, 32 # stack frame size is 32 bytes
    sw $ra, 20($sp)    # save return address
    sw $fp, 16($sp)    # save frame pointer
    addiu $fp, $sp, 28 # set frame pointer
    sw $a0, 0($fp)     # save n

    lw $t0, 0($fp)     # load n
    sltiu $v0, $t0, 1   # set v0 to 1 if n < 1
    beq $v0, $zero, L2  # branch if n < 1
    #bgtz $v0, $t0, L2  # branch if n > 0
    li $v0, 1          # return 1
    jr L1              # jump to L1
    
L2:
    lw $v1, 0($fp)     # load n
    subu $v0, $v1, 1   # v0 = n - 1
    move $a0, $v0      # move n - 1 to a0 (add $a0, $v0, $zero)
    lw $v1, 0($fp)     # load n
    mul $v0, $v1, $v0  # v0 = n * (n - 1)s

L1: 
    lw $ra, 20($sp)    # restore return address
    lw $fp, 16($sp)    # restore frame pointer
    addiu $sp, $sp, 32  # restore stack pointer
    jr $ra             # return to caller

    # procedure
print_str:
    # $v0/1 and $a0-3 NOT preserved
    # fix $sp for procedures
    addi $sp,$sp,-4     # Moving Stack pointer

    # print string
    li $v0, 4       # syscall 4 (print_str)
    syscall         # print the string

    # put back $sp and return
    addi $sp,$sp,4      # Moving Stack pointer
    jr $ra              # return (Copy $ra to PC)

print_int:
    # $v0/1 and $a0-3 NOT preserved
    # fix $sp for procedures
    addi $sp,$sp,-4     # Moving Stack pointer

    # print int
    li $v0, 1       # syscall 1 (print_int)
    syscall         # print the string

    # put back $sp and return
    addi $sp,$sp,4      # Moving Stack pointer
    jr $ra              # return (Copy $ra to PC)

print_float:
    # $v0/1 and $a0-3 NOT preserved
    # fix $sp for procedures
    addi $sp,$sp,-4     # Moving Stack pointer

    # print float
    li $v0, 2       # syscall 2 (print_float)
    syscall         # print the string

    # put back $sp and return
    addi $sp,$sp,4      # Moving Stack pointer
    jr $ra              # return (Copy $ra to PC)