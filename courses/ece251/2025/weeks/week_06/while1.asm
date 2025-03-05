    .text
    .globl main
main:
    li $t0, 10                   # count = 10 (initialization)
    li $t2, 5
while_start:                    # start loop
    slt $t1, $t2, $t0            # $t1 = 1 if count > 5 (condition)
    beq $t1, $zero, while_end   # Branch to while_end if count >= 5
                                # ... loop body ...
    addi $t0, $t0, -1            # count-- (increment)
    li $v0, 1
    move $a0, $t0
    syscall
    j while_start               # Jump back to condition check
while_end:                      # loop end
    li $v0, 10                            # ... rest of the program ...
    syscall