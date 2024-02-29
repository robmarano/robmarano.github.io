# mips-1.s
#
        .data
foobar: .word 0x00000004
prompt: .asciiz "> " # a NUL-terminated string
newline:.asciiz "\n"
msg1:   .asciiz "Hello, World!"
msg2:   .asciiz "Integer = "
msg3:   .asciiz "Pi = "
#pi:     .word   01000000010010010000111111011011 # 3.14159265
pi:     .float   3.14159265
#	    .extern foobar 4

        .text
        .globl main
main:
        # print prompt
        la $a0, prompt
        jal print_str # jump to target and save position to $ra

        # print msg1
        la $a0, msg1
        jal print_str # jump to target and save position to $ra

        # print newline
        la $a0, newline # argument: string
        jal print_str # jump to target and save position to $ra

        # print prompt
        la $a0, prompt
        jal print_str # jump to target and save position to $ra

        # print msg2
        la $a0, msg2
        jal print_str # jump to target and save position to $ra

        # print foobar
        la $t0, foobar
        lw $a0, 0($t0)

        jal print_int # jump to target and save position to $ra

        # print newline
        la $a0, newline # argument: string
        jal print_str # jump to target and save position to $ra

        # print prompt
        la $a0, prompt
        jal print_str # jump to target and save position to $ra

        # print msg3
        la $a0, msg3
        jal print_str # jump to target and save position to $ra

        # print pi
        la $t0, pi      # load addr of float
        lwc1 $f12, 0($t0) # load into fpr
        jal print_float # jump to target and save position to $ra

        # print newline
        la $a0, newline # argument: string
        jal print_str # jump to target and save position to $ra

        # exit main
        # The li (load immediate) pseudo instruction loads the system call number
        # for exiting the program into register $v0.
        li $v0, 10

        # The syscall instruction makes a system call.
        syscall

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