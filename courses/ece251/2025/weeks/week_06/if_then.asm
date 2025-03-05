	.data
	
	.text
	.globl main
main:
	# Assume $t0 holds the value of x
	li $t0, 10
	li $t1, 5                   # Load 5 into $t1
	slt $t2, $t1, $t0           # $t2 = 1 if $t1 < $t0 (x > 5), 0 otherwise
	beq $t2, $zero, else_label  # Branch to else if $t2 is 0 (x <= 5)
    # ... code for then part ...
	# decrement t0
	addi $t0, $t0, -1           # Then part (x > 5)
	li $v0, 1
    move $a0, $t0
    syscall
	j end_if                    # Jump to the end of the if-then-else
	addi $t0, $t0, -1

else_label:
                                # Else part (x <= 5)
    # ... code for else part ...

end_if:
                                # Continue with the rest of the program