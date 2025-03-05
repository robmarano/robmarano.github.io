    .text
    .globl main
main:
    # Set up arguments
    li $a0, 5      # n = 5
    # Call the add_two_numbers procedure
    jal factorial

    # Print the result (optional, requires syscall)
    move $a0, $v0  # Move result to $a0
    li $v0, 1      # System call code for print integer
    syscall

    # Exit the program
    li $v0, 10     # System call code for exit
    syscall


factorial:
    # Prologue (save $ra, etc.)
    # ...
    beq $a0, $zero, base_case # if n == 0, go to base case
    addi $sp, $sp, -8 # make space on stack
    sw $ra, 4($sp) # save return address
    sw $a0, 0($sp) # save n
    addi $a0, $a0, -1 # n = n - 1
    jal factorial # recursive call
    lw $a0, 0($sp) # restore n
    lw $ra, 4($sp) # restore return address
    addi $sp, $sp, 8 # deallocate stack space
    mul $v0, $a0, $v0 # v0 = n * factorial(n-1)
    jr $ra # return

base_case:
    li $v0, 1 # v0 = 1
    jr $ra # return