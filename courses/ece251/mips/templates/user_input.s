.data

prompt: .asciiz "Enter name: (max 60 chars)" 
hello_str: .asciiz "Hello "
name: .space 61 # including '\0'

.text

# Print prompt
la $a0, prompt # address of string to print
li $v0, 4
syscall

# Input name
la $a0, name # address to store string at
li $a1, 61 # maximum number of chars (including '\0')
li $v0, 8
syscall

# Print hello
la $a0, hello_str # address of string to print
li $v0, 4
syscall

# Print name
la $a0, name # address of string to print
li $v0, 4
syscall

# Exit
li $v0, 10
syscall
