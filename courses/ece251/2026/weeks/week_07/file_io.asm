    .data
filename:    .asciiz "data.txt"
file_buffer: .space 1024        # Reserve 1024 bytes in the Data Segment to hold the raw text file
result_msg:  .asciiz "The average of the 5 integers is: "
myArray:     .word 0, 0, 0, 0, 0 # Reserve 5 integer slots (20 bytes) to store the converted math values

    .text
    .globl main
main:
    # 1. Open the File
    li  $v0, 13             # syscall 13: open file
    la  $a0, filename       # $a0 = address of null-terminated filename
    li  $a1, 0              # $a1 = flags (0 = read-only)
    li  $a2, 0              # $a2 = mode (ignored)
    syscall
    move $s0, $v0           # IMMEDIATELY save the "File Descriptor" returned in $v0 to $s0 safely
    
    # 2. Read the File into Memory
    li  $v0, 14             # syscall 14: read from file
    move $a0, $s0           # $a0 = File descriptor we just saved
    la  $a1, file_buffer    # $a1 = address of our 1024 byte buffer in the `.data` segment
    li  $a2, 1024           # $a2 = maximum number of bytes to read
    syscall
    
    # 3. Close the File
    li  $v0, 16             # syscall 16: close file
    move $a0, $s0           # $a0 = File Descriptor
    syscall
    
    # 4. Convert the Raw ASCII Text Buffer into Physical Integers
    la  $a0, file_buffer    # Argument 0: Base address of the text buffer we just populated
    la  $a1, myArray        # Argument 1: Base address of the destination integer array
    li  $a2, 5              # Argument 2: How many integers we expect to parse
    jal convert_ascii_to_int # Jump and Link to our custom parsing procedure!
    
    # 5. Call the 'average' Procedure
    la  $a0, myArray        # Pass the base address of the array as Argument 0
    li  $a1, 5              # Pass the length of the array as Argument 1
    jal average             # Jump and Link to the procedure (saves Return Address to $ra)
    move $t0, $v0           # Save the calculated average returned in $v0
    
    # 6. Print the Results
    li  $v0, 4              # syscall 4: print string
    la  $a0, result_msg
    syscall
    
    li  $v0, 1              # syscall 1: print integer
    move $a0, $t0           # load our average
    syscall
    
    # Exit cleanly
    li  $v0, 10
    syscall

# ---------------------------------------------------- #
# Procedure: average
# Arguments: $a0 = array base address, $a1 = size
# Returns:   $v0 = integer average
# ---------------------------------------------------- #
average:
    li  $t0, 0              # Loop counter
    li  $t1, 0              # Running sum
    move $t2, $a0           # Copy the base address to $t2 so we can shift it

Avg_Loop:
    beq $t0, $a1, Avg_Done  # If counter == size, we reached the end
    
    lw  $t3, 0($t2)         # Load physical word from memory array
    add $t1, $t1, $t3       # Add to sum
    
    addi $t2, $t2, 4        # Shift memory pointer by 4 bytes (1 word)
    addi $t0, $t0, 1        # Increment counter by 1
    
    j   Avg_Loop            # Jump back up

Avg_Done:
    div $t1, $a1            # Divide Sum ($t1) by Count ($a1)
    mflo $v0                # MIPS stores the quotient in the LO register. Move it to $v0 as our return value!
    jr  $ra                 # Return structurally to the caller (main) using $ra

# ---------------------------------------------------- #
# Procedure: convert_ascii_to_int
# Arguments: $a0 = address of file_buffer (source ASCII)
#            $a1 = address of myArray (destination ints)
#            $a2 = number of expected integers to find
# Returns:   None (modifies memory directly at myArray)
# ---------------------------------------------------- #
convert_ascii_to_int:
    move $t0, $a0           # $t0 = Parse pointer (sliding along file_buffer)
    move $t1, $a1           # $t1 = Store pointer (sliding along myArray)
    li   $t2, 0             # $t2 = Current integer accumulator
    li   $t3, 0             # $t3 = Successful integers parsed counter
    li   $t4, 10            # $t4 = Constant math multiplier (10)

Parse_Loop:
    beq  $t3, $a2, Parse_Done # If we found all expected integers, exit!

    lb   $t5, 0($t0)        # Load exactly 1 byte of ASCII text
    addi $t0, $t0, 1        # Shift parse pointer to the right by 1 byte
    
    # Check for empty byte / Null terminator (ASCII 0)
    beq  $t5, 0, Parse_Done
    # Check for newline '\n' (ASCII 10)
    beq  $t5, 10, Save_Int  
    # Check for Windows carriage return '\r' (ASCII 13)
    beq  $t5, 13, Parse_Loop # Safely ignore \r and read the next physical byte
    
    # Check for Space (ASCII 32)
    beq  $t5, 32, Save_Int  

    # If we are here, we strongly assume it is a valid digit '0' to '9'.
    # Subtract 48 (ASCII code for '0') to reveal the true mathematical value
    addi $t5, $t5, -48
    
    # Accumulate: Current_Value = (Current_Value * 10) + new_digit
    mul  $t2, $t2, $t4      # Shift current value left natively in base-10
    add  $t2, $t2, $t5      # Add the new digit
    
    j    Parse_Loop         # Unconditionally jump back up to grab the next byte!

Save_Int:
    sw   $t2, 0($t1)        # Save the built up integer physically into the myArray slot
    addi $t1, $t1, 4        # Shift the destination pointer down by 1 word (4 bytes)
    addi $t3, $t3, 1        # Increment our successful integers counter by 1
    li   $t2, 0             # **CRITICAL:** Reset the accumulator back to 0 for the next number!
    
    j    Parse_Loop         # Go back to finding the next number

Parse_Done:
    jr   $ra                # Return structurally to the caller (main) using $ra
