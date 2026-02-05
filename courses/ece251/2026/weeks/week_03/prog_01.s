# ECE 251 - Week 3 Example 1
# Topics: Memory Access, Arithmetic, Logic Operations
# Textbook Sections: 2.2, 2.3, 2.5, 2.6

.data
    # Define integer literals in memory
    var_a:  .word 15        # Binary: 0000...0000 1111
    var_b:  .word 10        # Binary: 0000...0000 1010
    result: .word 0         # Space to store a result

.text
.globl main

main:
    # ---------------------------------------------------------
    # 1. MEMORY CALLS: Loading literals from Memory to Registers
    # ---------------------------------------------------------
    # Use 'la' (Load Address) pseudo-instruction to get address of var_a
    la  $t0, var_a          # $t0 = Address of var_a
    lw  $s0, 0($t0)         # $s0 = Memory[$t0 + 0] (Value: 15)

    # Use 'la' for var_b
    la  $t1, var_b          # $t1 = Address of var_b
    lw  $s1, 0($t1)         # $s1 = Memory[$t1 + 0] (Value: 10)

    # ---------------------------------------------------------
    # 2. ARITHMETIC: Using values in registers (Section 2.2)
    # ---------------------------------------------------------
    add $t2, $s0, $s1       # $t2 = $s0 + $s1 (15 + 10 = 25)
    sub $t3, $s0, $s1       # $t3 = $s0 - $s1 (15 - 10 = 5)

    # Store arithmetic result back to memory
    la  $t4, result         # Load address of result variable
    sw  $t2, 0($t4)         # Memory[$t4] = 25

    # ---------------------------------------------------------
    # 3. BOOLEAN LOGIC & SHIFTS (Section 2.6)
    # ---------------------------------------------------------
    
    # Bitwise AND (Masking)
    # 15 (1111) AND 10 (1010) = 10 (1010)
    and $t5, $s0, $s1       
    
    # Bitwise OR (Combining)
    # 15 (1111) OR 10 (1010) = 15 (1111)
    or  $t6, $s0, $s1       

    # Bitwise NOR (Implementing NOT)
    # MIPS does not have a NOT instruction. It uses NOR with $zero.
    # ~(1010 OR 0000) = ~(1010)
    nor $t7, $s1, $zero     # Inverts bits of $s1

    # Shift Left Logical (sll) - Multiplying by powers of 2
    # Shift 10 (1010) left by 2 becomes 40 (101000)
    sll $t8, $s1, 2         # $t8 = $s1 << 2 

    # Shift Right Logical (srl) - Dividing by powers of 2
    # Shift 15 (1111) right by 1 becomes 7 (0111) (Integer division)
    srl $t9, $s0, 1         # $t9 = $s0 >> 1

    # ---------------------------------------------------------
    # EXIT: Clean termination (System Call 10)
    # ---------------------------------------------------------
    li  $v0, 10             # Load immediate 10 into $v0 (Service 10: Exit)
    syscall