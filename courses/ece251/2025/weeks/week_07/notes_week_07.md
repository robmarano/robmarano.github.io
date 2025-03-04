# Notes for Week 7 &mdash; Intro to Assembly Language Programming — MIPS CPU; Part 2

[ &larr; back to syllabus](/courses/ece251/2025/ece251-syllabus-spring-2025.html) [ &larr; back to notes](/courses/ece251/2025/ece251-notes.html)

Let's learn how to program MIPS assembly language, and run these programs on a MIPS emulator [`MARS`](https://dpetersanderson.github.io/download.html). You'll run it using Java, `java -jar Mars4_5.jar`.

# Topics

1. Writing procedures, starting with leaf procedures
2. Nested procedures
3. Recursive procedures

These [class notes focus on on MIPS assembly programming](/courses/ece251/mips/mips.html)

Your best friend here, [MIPS Green Card reference card](/courses/ece251/books/patterson-hennessey/MIPS_Green_Sheet.pdf).

# Writing procedures, starting with leaf procedures

## General Flow for Implementing Procedures in MIPS Assembly

There are two types of procedures, **leaf procedures** and **nested procedures**. Each **leaf procedure** is simply a code block that can be called with or without parameters. It's a mechanism for reusability. They do not call other procedures. Each **nested procedure** is a reusable code block with or without parameters, and it does call other procedures within its code block.

When implementing procedures in MIPS assembly, there's a general flow you should follow, which varies slightly depending on whether the procedure is a leaf or nested.

## Leaf procedures

For emphasis, a leaf procedure is a procedure that does not call any other procedures. The flow for implementing a leaf procedure is relatively straightforward:

1. **Procedure Prologue:**
   1. Allocate space on the stack if local variables are needed. However, since it is a leaf procedure, often local variables are not needed.
2. **Procedure Body:**
   1. Perform the necessary computations using the input arguments (passed in registers `$a0 - $a3`).
   2. Store the result in the return value register `$v0`.
3. **Procedure Epilogue:**
   1. Restore any saved registers (not usually needed for leaf procedures).
   2. Return to the calling procedure using the `jr $ra` instruction.

### Worked Example

#### Requirement

Write a MIPS assembly procedure named `add_two_numbers` that takes two integer arguments, adds them together, and returns the sum.

#### Code

```mips
    .text
    .globl add_two_numbers

add_two_numbers:
    # Procedure Prologue (not needed for a simple leaf procedure)

    # Procedure Body
    add $v0, $a0, $a1  # $v0 = $a0 + $a1

    # Procedure Epilogue
    jr $ra              # Return to the caller
```

#### Code Explanation

1. `.text:` This directive indicates that the following code is part of the text segment in memory, which contains executable instructions.
2. `.globl add_two_numbers:` This directive makes the `add_two_numbers` label globally visible, allowing it to be called from other parts of the program.
3. `add_two_numbers:`: This label marks the beginning of the `add_two_numbers` leaf procedure.
4. `add $v0, $a0, $a1`: This instruction performs the addition.
   1. `$a0` and `$a1` are **argument registers**, where the two input integers are passed to the procedure.
   2. `$v0` is the **value register**, where the result of the addition is stored, by ISA convention.
5. `jr $ra`: This instruction jumps to the address stored in the **return address register** `$ra`, effectively returning control, that is the `PC`, to the calling procedure.

#### How to use

```mips
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
```

#### Explanation of the Calling Program:

1. `main:`: This label marks the beginning of the main program.
2. `li $a0, 5` and `li $a1, 10`: These instructions load the immediate values 5 and 10 into the **argument registers** `$a0` and `$a1`, respectively.
3. `jal add_two_numbers`: This instruction jumps and links to the `add_two_numbers` procedure, saving the **return address** in `$ra`.
4. `move $a0, $v0`: This instruction moves the result from `$v0` (where `add_two_numbers` stored it) to `$a0`, preparing it for the print system call. **Note** `move` is not a core instruction in the MIPS ISA.
5. `li $v0, 1` and `syscall`: These instructions perform the system call to print the integer in `$a0`.
6. `li $v0, 10` and `syscall`: These instructions perform the system call to exit the program.

## Nested procedures

Again for emphasis, a nested procedure is a procedure that calls other procedures. The flow for implementing a nested procedure is more complex:

1. **Procedure Prologue:**
   1. Allocate space on the stack for local variables and saved registers.
   2. Save the return address `$ra` and any callee-saved registers (`$s0 - $s7`) on the stack.
2. **Procedure Body:**
   1. Perform the necessary computations.
   2. Prepare arguments for any called procedures.
   3. Call the other procedures using the `jal` instruction.
   4. Retrieve return values from called procedures.
3. **Procedure Epilogue:**
   1. Restore the saved registers from the stack.
   2. Restore the return address `$ra` from the stack.
   3. Deallocate the stack space.
   4. Return to the calling procedure using the `jr $ra` instruction.

### Worked Example

#### Requirement

Write the procedure `sum_of_squares` that takes two integer arguments, calls the `square` procedure to calculate the square of each argument, and returns the sum of the squares.

#### Code

```mips
    .text
    .globl sum_of_squares
sum_of_squares:
    # Prologue (save $ra)
    addi $sp, $sp, -4  # Make space on the stack
    sw $ra, 0($sp)     # Save return address

    # Calculate square of the first argument
    move $a0, $a0     # Move first argument to $a0 for square
    jal square
    move $t0, $v0     # Store the result in $t0

    # Calculate square of the second argument
    move $a0, $a1     # Move second argument to $a0 for square
    jal square
    add $t0, $t0, $v0 # Add the squares

    # Epilogue (restore $ra)
    move $v0, $t0     # Store the sum of squares in $v0
    lw $ra, 0($sp)     # Restore return address
    addi $sp, $sp, 4  # Deallocate stack space
    jr $ra             # Return

    .globl square
square:
    # Calculate square
    mul $v0, $a0, $a0 # $v0 = $a0 * $a0
    jr $ra             # Return
```

#### Code Explanation

1. `main` **Procedure:**
   1. Sets up the arguments for `sum_of_squares`.
   2. Calls sum_of_squares using `jal`.
   3. Prints the result using system calls.
   4. Exits the program.
2. `sum_of_squares` **Procedure:**
   1. **Prologue:** Saves the return address `$ra` on the stack because this procedure calls another procedure.
      1. Calculates the square of the first argument by calling `square`.
      2. Stores the result in `$t0`.
      3. Calculates the square of the second argument by calling `square`.
      4. Adds the two squares together, storing the result in `$t0`.
   2. **Epilogue:** restores the return address, and returns the sum.
3. `square` **Procedure:**
   1. Calculates the square of the input argument.
   2. Returns the result in `$v0`.

#### How to use

```mips
    .globl main
main:
    # Set up arguments for sum_of_squares
    li $a0, 3      # First argument: 3
    li $a1, 4      # Second argument: 4

    # Call the sum_of_squares procedure
    jal sum_of_squares

    # Print the result (optional, requires syscall)
    move $a0, $v0  # Move result to $a0
    li $v0, 1      # System call code for print integer
    syscall

    # Exit the program
    li $v0, 10     # System call code for exit
    syscall

    .globl sum_of_squares
sum_of_squares:
    # Prologue (save $ra)
    addi $sp, $sp, -4  # Make space on the stack
    sw $ra, 0($sp)     # Save return address

    # Calculate square of the first argument
    move $a0, $a0     # Move first argument to $a0 for square
    jal square
    move $t0, $v0     # Store the result in $t0

    # Calculate square of the second argument
    move $a0, $a1     # Move second argument to $a0 for square
    jal square
    add $t0, $t0, $v0 # Add the squares

    # Epilogue (restore $ra)
    move $v0, $t0     # Store the sum of squares in $v0
    lw $ra, 0($sp)     # Restore return address
    addi $sp, $sp, 4  # Deallocate stack space
    jr $ra             # Return

    .globl square
square:
    # Calculate square
    mul $v0, $a0, $a0 # $v0 = $a0 * $a0
    jr $ra             # Return
```

### Key Points

1. **Nested Procedure Calls:** `sum_of_squares` calls `square`, making it a nested procedure.
2. **Stack Usage:** The stack is used to save the return address in `sum_of_squares` to allow for the nested call.
3. **Argument Passing:** Arguments are passed using the argument registers `$a0` and `$a1`.
4. **Return Values:** Return values are passed using the value register `$v0`.
5. **Temporary Registers:** The temporary register `$t0` is used to store the sum of the squared values.

## Recursive procedures

A recursive procedure is a procedure that calls itself. Therefore, it also is a nested procedure. Designing and implementing a recursive procedure involves the following steps:

1. **Identify the Base Case:**
   1. Determine the condition under which the recursion should stop. This is the base case.
2. **Identify the Recursive Case:**
   1. Determine how the problem can be broken down into smaller, similar subproblems.
   2. Make a recursive call to the procedure with the smaller subproblem.
3. **Implement the Procedure:**
   1. Write the code to check for the base case.
   2. If the base case is met, return the appropriate value.
   3. If the recursive case is met, perform the necessary computations and make the recursive call.
   4. Follow the nested procedure process, since recursive functions will be calling themselves.
4. **Stack Management:**
   1. Recursive procedures rely heavily on the stack. Each recursive call pushes a **new stack frame**, containing local variables and the return address.
   2. Ensure that the stack is properly managed to prevent stack overflow.

### Example

#### Requirement

#### Code

```mips
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
```

Left as an exercise, write the `main` and test the program with input values.
