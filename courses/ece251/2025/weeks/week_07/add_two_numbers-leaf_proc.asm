# int add_two_numbers(int a0, int a1) {
#     return (a0+a1);
# }
    
    .text
    .globl main
main:
    # Set up arguments
    li $a0, 5      # First argument: 5
    li $a1, 10     # Second argument: 10

    # Call the add_two_numbers procedure
    jal add_two_numbers

    # Print the result (optional, requires syscall)
    move $a0, $v0  # Move result to $a0
    li $v0, 1      # System call code for print integer
    syscall

    # Exit the program
    li $v0, 10     # System call code for exit
    syscall
    
    .globl add_two_numbers
add_two_numbers:
    # Procedure Prologue (not needed for a simple leaf procedure)

    # Procedure Body
    add $v0, $a0, $a1  # $v0 = $a0 + $a1

    # Procedure Epilogue
    jr $ra              # Return to the caller
