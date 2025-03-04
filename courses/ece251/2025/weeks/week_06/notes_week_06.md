# Notes for Week 6

[ &larr; back to syllabus](/courses/ece251/2025/ece251-syllabus-spring-2025.html) [ &larr; back to notes](/courses/ece251/2025/ece251-notes.html)

Let's learn how to program MIPS assembly language, and run these programs on a MIPS emulator (`spim`).

# Topics

1. Building blocks of assembly language programming on MIPS processors
2. General forms of most used control flow code blocks
3. Full example to run on `spim`

These [class notes focus on on MIPS assembly programming](/courses/ece251/mips/mips.html)

Your best friend here, [MIPS Green Card reference card](/courses/ece251/books/patterson-hennessey/MIPS_Green_Sheet.pdf).

## The building blocks of a programming language

1. Variables
2. Data types
3. Operators
4. Control flow (if/else statements, loops)

### Variables

In assembly language, general purpose registers (GPRs) serve as variables.

| GPR Name | GPR Number | Use                                                   | Preserved Across a Procedure Call? |
| :------: | :--------: | :---------------------------------------------------- | :--------------------------------: |
|  $zero   |     0      | The Constant Value 0                                  |                n/a                 |
|   $at    |     1      | Assembler Temporary                                   |                 No                 |
| $v0-$v1  |    2-3     | Values for Function Results and Expression Evaluation |                 No                 |
| $a0-$a3  |    4-7     | Arguments                                             |                 No                 |
| $t0-$t7  |    8-15    | Temporaries                                           |                 No                 |
| $s0-$s7  |   16-23    | Saved Temporaries                                     |                Yes                 |
| $t8-$t9  |   24-25    | Temporaries                                           |                 No                 |
| $k0-$k1  |   26-27    | Reserved for OS Kernel                                |                 No                 |
|   $gp    |     28     | Global Pointer                                        |                Yes                 |
|   $sp    |     29     | Stack Pointer                                         |                Yes                 |
|   $fp    |     30     | Frame Pointer                                         |                Yes                 |
|   Sra    |     31     | Return Address                                        |                 No                 |

### Data Types

On the MIPS processor, you can program in bytes, halfwords, or words, where a word is 32 bits. Check the [MIPS Green Card reference card](/courses/ece251/books/patterson-hennessey/MIPS_Green_Sheet.pdf) for loading and saving these data types from and to memory, respectively.

The MIPS CPU supports the following key memory operations:

|    Instruction Name    | Mnemonic |                 Operation                 |
| :--------------------: | :------: | :---------------------------------------: |
|   load byte unsigned   |  `lbu`   | `R[rt]={24'b0,M[R[rs]+SignExtImm](7:0)}`  |
| load halfword unsigned |  `lhu`   | `R[rt]={16'b0,M[R[rs]+SignExtImm](15:0)}` |
|       load word        |   `lw`   |       `R[rt] = M[R[rs]+SignExtImm]`       |
|       store byte       |   `sb`   |  `M[R[rs]+SignExtImm](7:0) = R[rt](7:0)`  |
|     store halfword     |   `sh`   | `M[R[rs]+SignExtImm](15:0) = R[rt](15:0)` |
|       store word       |   `sw`   |       `M[R[rs]+SignExtImm] = R[rt]`       |

Note: `SignExtImm= { 16{immediate[15]}, immediate }`, `ZeroExtImm = { 16{1b'0}, immediate }`

### Operators

The MIPS CPU supports the following key operators for compute operations:

| Processor  | General Operation | Instruction Name                       | Mnemonic |             Operation             |
| :--------: | :---------------: | :------------------------------------- | :------: | :-------------------------------: |
|    Core    |      Logical      | And                                    |  `and`   |      `R[rd] = R[rs] & R[rt]`      |
|            |                   | And immediate                          |  `andi`  |   `R[rt] = R[rs] & ZeroExtImm`    |
|            |                   | Nor                                    |  `nor`   |      `R[rd] =~(R[rs] R[rt])`      |
|            |                   | Or                                     |   `or`   |       `R[rd] = R[rs] R[rt]`       |
|            |                   | Or immediate                           |  `ori`   |   `R[rt] = R[rs] \| ZeroExtImm`   |
|            |                   | Shift left logical                     |  `sll`   |     ` R[rd] = R[rt] << shamt`     |
|            |                   | Shift right logical                    |  `srl`   |     `R[rd] = R[rt] >> shamt`      |
|            |        Add        | Add signed words                       |  `add`   |      `R[rd] = R[rs] + R[rt]`      |
|            |                   | Add signed word and halfword immediate |  `addi`  |   `R[rt] = R[rs] + SignExtImm`    |
|            |                   | Add immediate unsigned                 | `addiu`  |   `R[rt] = R[rs] + SignExtImm`    |
|            |                   | Add unsigned words                     |  `addu`  |      `R[rd] = R[rs] + R[rt]`      |
|            |     Subtract      | Subtract signed words                  |  `sub`   |      `R[rd] = R[rs] - R[rt]`      |
|            |                   | Subtract unsigned words                |  `subu`  |      `R[rd] = R[rs] - R[rt]`      |
| Arithmetic |     Multiply      | Multiply signed words                  |  `mult`  |     `{Hi,Lo} = R[rs]* R[rt]`      |
|            |                   | Multiply unsigned words                | `multu`  |     `{Hi,Lo} = R[rs]* R[rt]`      |
|            |      Divide       | Divide signed words                    |  `div`   | ` Lo=R[rs]/R[rt]; Hi=R[rs]%R[rt]` |
|            |                   | Divide unsigned words                  |  `divu`  | ` Lo=R[rs]/R[rt]; Hi=R[rs]%R[rt]` |
|            |       Move        | Move from Hi                           |  `mfhi`  |           ` R[rd] = Hi`           |
|            |                   | Move from Lo                           |  `mflo`  |        `R[rd] = Lo      `         |

### Control flow (if/else statements, loops)

| Control Flow |         Instruction Name         | Mnemonic |                Operation                |
| :----------: | :------------------------------: | :------: | :-------------------------------------: |
|  Branching   |         Branch on equal          |  `beq`   | `if(R[rs]==R[rt]) PC=PC+4+BranchAddr*4` |
|              |       Branch on not equal        |  `bne`   | `if(R[rs]!=R[rt]) PC=PC+4+BranchAddr*4` |
|              |          Set less than           |  `slt`   |     `R[rd] = (R[rs] <R[rt]) ? 1:0`      |
|              |     Set less than immediate      |  `slti`  |   `R[rt] = (R[rs] < SignExtImm ? 1:0`   |
|              | Set less than immediate unsigned | `sltiu`  |   `R[rt] = (R[rs] < SignExtImm ? 1:0`   |
|   Jumping    |               Jump               |   `j`    |              `PC=JumpAddr`              |
|              |          Jump and link           |  `jal`   |        `R[31]=PC+4;PC=JumpAddr`         |
|              |          Jump register           |   `jr`   |               `PC=R[rs]`                |

# General forms of most used control flow code blocks

## `if-then-else` Conditional Control Flow

`C` code definition of `if-then-else`

```c
if (condition) {
    // Code to execute if the condition is true (then part)
} else {
    // Code to execute if the condition is false (else part)
}
```

### MIPS Assembly Implementation

In MIPS assembly, there's no direct `if-then-else` keyword. Instead, we use conditional branch instructions to achieve the same effect.

Here's how it generally works in assembly:

1. Evaluate the condition: <br>
   Use comparison instructions (e.g., `slt`, `beq`, `bne`) to determine if the condition is true or false.
2. Branch based on the condition:
   1. If the condition is true, branch to the "then" part of the code.
   2. If the condition is false, branch to the "else" part (or continue to the next instruction if there's no "else").
3. Use labels: Define labels to mark the beginning of the "then" and "else" blocks.
4. Use unconditional jumps: At the end of the "then" block, use an unconditional jump (`j`) to skip the "else" block.

### Example

#### Python code

```python
x = 10
if x > 5:
    print("x is greater than 5")
else:
    print("x is not greater than 5")
```

#### MIPS assembly code

```mips
# Assume $t0 holds the value of x
    li $t1, 5                   # Load 5 into $t1
    slt $t2, $t1, $t0           # $t2 = 1 if $t1 < $t0 (x > 5), 0 otherwise
    beq $t2, $zero, else_label  # Branch to else if $t2 is 0 (x <= 5)

                                # Then part (x > 5)
    # ... code for then part ...
    j end_if                    # Jump to the end of the if-then-else

else_label:
                                # Else part (x <= 5)
    # ... code for else part ...

end_if:
                                # Continue with the rest of the program
```

## `for` Loop Control Flow

`C` code definition of a `for` loop:

```c
for (initialization; condition; increment/decrement) {
    // Code to be executed repeatedly (loop body)
}
```

In MIPS assembly, we achieve the effect of a `for` loop using conditional branches and jumps, much like how we handle `if-then-else` statements.

Here's how it generally works in assembly:

1. **Initialization:** Initialize the loop counter register.
2. **Condition Check:** Compare the loop counter with the termination condition.
3. **Branching:**
   1. If the condition is false, branch to the end of the loop.
   2. If the condition is true, execute the loop body.
4. **Loop Body:** Execute the code within the loop.
5. **Increment/Decrement:** Update the loop counter.
6. **Jump:** Jump back to the condition check.

### Example

#### C code

```c
for (int i = 0; i < 10; i++) {
    printf("%d\n", i);
}
```

#### MIPS assembly code

```mips
    li $t0, 0                       # i = 0 (initialization)
loop_start:                     # start loop
    slti $t1, $t0, 10           # $t1 = 1 if i < 10 (condition)
    beq $t1, $zero, loop_end    # Branch to loop_end if i >= 10
                                # ... loop body ...
    addi $t0, $t0, 1            # i++ (increment)
    j loop_start                # Jump back to condition check
loop_end:
                                # ... rest of the program ...
```

## `while` Loop Control Flow

`C` code definition of a `while` loop:

```c
while (condition) {
    // Code to be executed repeatedly (loop body)
}
```

In MIPS assembly, we achieve the effect of a `while` loop using conditional branches and jumps, much like how we handle other conditional looping statements.

Here's how it generally works in assembly:

### Example

#### C code

```c
int count = 0;
while count < 5 {
    printf("%d\n",count);
    count += 1;
}
```

#### MIPS assembly code

In MIPS assembly, we implement a `while` loop using conditional branch instructions and jumps, similar to how we handle for loops.

Here's how it generally works in assembly:

1. **Condition Check:** Evaluate the loop condition.
2. **Branching:**
   1. If the condition is false, branch to the end of the loop.
   2. If the condition is true, execute the loop body.
3. **Loop Body:** Execute the code within the loop.
4. **Jump:** Jump back to the condition check.

```mips
    li $t0, 0                   # count = 0 (initialization)
while_start:                    # start loop
    slti $t1, $t0, 5            # $t1 = 1 if count < 5 (condition)
    beq $t1, $zero, while_end   # Branch to while_end if count >= 5
                                # ... loop body ...
    addi $t0, $t0, 1            # count++ (increment)
    j while_start               # Jump back to condition check
while_end:                      # loop end
                                # ... rest of the program ...
```

## `do-while` Loop Control Flow

`C` code definition of a `do-while` loop:

```c
do {
    // Code to be executed repeatedly (loop body)
} while (condition);
```

In MIPS assembly, we achieve the effect of a `do-while` loop using conditional branches and jumps, much like how we handle other conditional looping statements except the step if done after the first loop iteration.

Here's how it generally works in assembly:

### Example

#### C code

```c
int count = 0;
do {
    printf("%d\n", count);
    count++;
} while (count < 5);
```

#### MIPS assembly code

In MIPS assembly, we implement a `while` loop using conditional branch instructions and jumps, similar to how we handle for loops.

Here's how it generally works in assembly:

1. **Loop Body:** Execute the code within the loop.
2. **Condition Check:** Evaluate the loop condition.
3. **Branching:**
   1. If the condition is true, **jump back** to the beginning of the loop body.
   2. If the condition is false, continue to the next instruction after the loop.

```mips
    li $t0, 0                       # count = 0 (initialization)
do_while_loop:
                                    # ... loop body ...
    addi $t0, $t0, 1                # count++ (increment)
    slti $t1, $t0, 5                # $t1 = 1 if count < 5 (condition)
    bne $t1, $zero, do_while_loop   # Branch back if count < 5
                                    # ... rest of the program ...
```

[ &larr; back to syllabus](/courses/ece251/2025/ece251-syllabus-spring-2025.html) [ &larr; back to notes](/courses/ece251/2025/ece251-notes.html)
