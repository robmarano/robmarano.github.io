	.data
pi:	.float 3.14159
one:	.float 1.10000
newline:	.asciiz "\n"

	.text
	.globl main

main:
	# Load fp
	la $t0, pi
	la $t1, one

	l.s $f1, ($t0)
	l.s $f2, ($t1)

	mul.s $f12, $f1, $f2 

	# Load the single-precision floating-point value from memory into a
	# floating-point register (e.g., $f4).
	# The 'l.s' instruction is a pseudo-instruction for 'lwc1'.
	#l.s $f12, ($t0)

	# Print fp number
	li $v0, 2
	syscall

	# Print trailing newline
	li  $v0, 4              # syscall 4: print string
	la  $a0, newline
	syscall

	
	# Exit cleanly
	li  $v0, 10
	syscall

