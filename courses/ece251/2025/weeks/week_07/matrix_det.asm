.data
 matrix: .word 1, 2, 3, 4, 5, 6, 7, 8, 9 # Example matrix
#matrix: .word 1, 5, 9, 2, 6, 10, 3, 7, 11
#matrix: .word 1, 0, 0, 0, 1, 0, 0, 0, 1
#matrix: .word 1, 5, 9, 2, 6, 10, 3, 7, 11
#matrix: .word 4, 2, 7, 6, 9, 1, 3, 5, 8
determinant_str: .asciiz "Determinant: "
newline: .asciiz "\n"
space: .asciiz " "

.text
.globl main

main:
    # Load matrix address
    la $t0, matrix

    # Print matrix
    li $t1, 0 # Row counter
matrix_loop:
    beq $t1, 3, determinant_calculation # If 3 rows printed, go to determinant calculation

    li $t2, 0 # Column counter
column_loop:
    beq $t2, 3, newline_print # If 3 columns printed, print newline

    # Load matrix element
    lw $a0, 0($t0)

    # Print element
    li $v0, 1
    syscall

    # Print space
    li $v0, 4
    la $a0, space
    syscall

    # Increment column counter and matrix pointer
    addi $t2, $t2, 1
    addi $t0, $t0, 4
    j column_loop

newline_print:
    # Print newline
    li $v0, 4
    la $a0, newline
    syscall

    # Increment row counter
    addi $t1, $t1, 1
    j matrix_loop

determinant_calculation:
    # Reset matrix address
    la $t0, matrix

    # Load matrix elements into registers
    lw $t1, 0($t0)  # a
    lw $t2, 4($t0)  # b
    lw $t3, 8($t0)  # c
    lw $t4, 12($t0) # d
    lw $t5, 16($t0) # e
    lw $t6, 20($t0) # f
    lw $t7, 24($t0) # g
    lw $t8, 28($t0) # h
    lw $t9, 32($t0) # i

    # Calculate (ei - fh)
    mul $s0, $t5, $t9 # ei
    mul $s1, $t6, $t8 # fh
    sub $s2, $s0, $s1 # ei - fh

    # Calculate (di - fg)
    mul $s3, $t4, $t9 # di
    mul $s4, $t6, $t7 # fg
    sub $s5, $s3, $s4 # di - fg

    # Calculate (dh - eg)
    mul $s6, $t4, $t8 # dh
    mul $s7, $t5, $t7 # eg
    sub $s8, $s6, $s7 # dh - eg

    # Calculate a(ei - fh)
    mul $t0, $t1, $s2

    # Calculate -b(di - fg)
    mul $t1, $t2, $s5
    sub $t1, $zero, $t1

    # Calculate c(dh - eg)
    mul $t2, $t3, $s8

    # Calculate determinant
    add $v1, $t0, $t1
    add $v1, $v1, $t2

    # Print "Determinant: "
    li $v0, 4
    la $a0, determinant_str
    syscall

    # Print determinant
    li $v0, 1
    move $a0, $v1
    syscall

    # Exit program
    li $v0, 10
    syscall