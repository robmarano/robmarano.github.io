### How to use these in class:

You can provide the "starter code" (the `.data` section) and have the students fill in the `.text` instructions. This prevents them from getting bogged down in syntax and focuses their attention on the logic of the instructions.

Would you like me to provide the **solution code** for these exercises so you have an answer key for grading?

As your coding partner, I’ve expanded the curriculum to include the "Triple Threat" of procedure types. These exercises specifically test the student's ability to manage the **Return Address ($ra)** and the **Stack Pointer ($sp)**, which is where most MIPS errors occur.


## 🔑 Answer Key: Solutions for Exercises 1-6

Below is the complete solution code for all exercises, formatted for easy use in `spim`.

### Exercises 1 & 2: Arithmetic and Loops

```mips
# Solution 1: Multiplier & Memory
.data
    final_val: .word 0
.text
main_ex1:
    li $v0, 5          # Read Int 1
    syscall
    move $t0, $v0
    li $v0, 5          # Read Int 2
    syscall
    move $t1, $v0
    sll $t0, $t0, 3    # x8
    add $t2, $t0, $t1  # (Int1 * 8) + Int2
    sw $t2, final_val
    li $v0, 10         # Exit
    syscall

# Solution 2: Negative Counter
.data
    array: .word 5, -2, 18, -1, -30
    len:   .word 5
.text
main_ex2:
    la $s1, array
    lw $s2, len
    li $t0, 0          # i = 0
    li $s0, 0          # count = 0
loop:
    slt $t1, $t0, $s2
    beq $t1, $zero, done
    lw  $t2, 0($s1)
    slt $t3, $t2, $zero # Is element < 0?
    add $s0, $s0, $t3   # If yes, $t3=1, so count++
    addi $s1, $s1, 4    # Move pointer
    addi $t0, $t0, 1    # i++
    j loop
done:
    li $v0, 10
    syscall

```

---

### Exercises 3 & 4: Leaf Procedures

```mips
# Solution 3 & 4 (Combined Concept)
.text
main:
    li $a0, 10
    li $a1, 5
    jal calc_perimeter
    move $a0, $v0      # Print result
    li $v0, 1
    syscall
    li $v0, 10
    syscall

calc_perimeter:
    addi $sp, $sp, -4
    sw   $s0, 0($sp)   # Save $s0 to be a good "citizen"
    add  $s0, $a0, $a1 # L + W
    sll  $v0, $s0, 1   # (L + W) * 2
    lw   $s0, 0($sp)   # Restore
    addi $sp, $sp, 4
    jr   $ra

```

---

### Exercise 5: Nested Procedure

```mips
# Solution 5: Nested (Square + Average)
.text
main_nested:
    li $a0, 3
    li $a1, 4
    jal avg_squares
    # Result in $v0 should be (9+16)/2 = 12
    li $v0, 10
    syscall

avg_squares:
    addi $sp, $sp, -12
    sw   $ra, 8($sp)   # MUST SAVE $ra
    sw   $s0, 4($sp)
    sw   $s1, 0($sp)

    move $s0, $a1      # Save b in $s0
    jal  square        # call square(a)
    move $s1, $v0      # $s1 = a^2

    move $a0, $s0      # $a0 = b
    jal  square        # call square(b)
    
    add  $v0, $v0, $s1 # a^2 + b^2
    srl  $v0, $v0, 1   # Divide by 2

    lw   $s1, 0($sp)
    lw   $s0, 4($sp)
    lw   $ra, 8($sp)   # RESTORE $ra
    addi $sp, $sp, 12
    jr   $ra

square:
    mul  $v0, $a0, $a0 # Leaf function, no $ra save needed
    jr   $ra

```

---

### Exercise 6: Recursive Procedure

```mips
# Solution 6: Factorial
.text
main_rec:
    li $a0, 5
    jal factorial      # 5! = 120
    move $a0, $v0
    li $v0, 1
    syscall
    li $v0, 10
    syscall

factorial:
    addi $sp, $sp, -8
    sw   $ra, 4($sp)
    sw   $a0, 0($sp)

    slti $t0, $a0, 1
    beq  $t0, $zero, recurse
    
    # Base Case
    li   $v0, 1
    addi $sp, $sp, 8
    jr   $ra

recurse:
    addi $a0, $a0, -1
    jal  factorial
    
    # After returning
    lw   $a0, 0($sp)   # Restore n for this frame
    lw   $ra, 4($sp)   # Restore $ra for this frame
    addi $sp, $sp, 8
    mul  $v0, $a0, $v0 # n * factorial(n-1)
    jr   $ra

```

---

This complete set should provide a robust foundation for your Week 3 labs! Would you like me to help you format these into a printable **Student Lab Worksheet** with spaces for them to write their observations during `spim` stepping?