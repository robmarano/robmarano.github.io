# Driver code for a student-written "add numbers" (addem) function.

# This code uses memory-mapped I/O so that the sentinal marking end of
# data can be a non-printing character (Control-D) instead of a
# "special number," which would have been the only option using the
# simulator's built-in read_int function.

# C. Vickery
# March, 2006

#
#   Data Segment
#
              .data
greet_msg:    .ascii  "Enter numbers, one per line.\n"
              .asciiz "End with ^D at start of line.\n"
prompt_msg:   .asciiz "# "
eod_msg:      .asciiz "\nEnd of input.\n"
syntax_msg:   .asciiz "\nYou are SO naughty!\n"
student_msg:  .asciiz "Your sum:    "
correct_msg:  .asciiz "Correct sum: "
newline_msg:  .asciiz "\n"
happy_msg:    .asciiz "Congratulations!\n"
sad_msg:      .asciiz "Wrong answer! Time to Debug!!\n"
no_nums_msg:  .asciiz "No numbers! Bye.\n"

correct_str:  .space  12
student_str:  .space  12
              .align  4
const_ten:    .word   10
values:       .space  256 # room for up to 64 values

#
#   Code Segment
#

# main()
# Reads numbers from console until user types Control-D
          .globl  main
          .text
main:
            # Standard MIPS prologue for functions that call other
            # functions.
            subu    $sp,$sp,32
            sw      $ra,20($sp)
            sw      $fp,16($sp)
            addiu   $fp,$sp,28

            # Initialize
            lw      $s7,const_ten       #  Radix for char conversions
            la      $s6,values          #  Array of values
            li      $s5,0               #  Number of values
            li      $s4,0               #  My sum
            la      $a1,greet_msg
            jal     printstr

            # Outer loop: read lines until Control-D

            # initialize number and set up to allow +/-
next_line:  li      $s0,0               # val=0
            li      $s1,1               # set start of string flag
            li      $s2,0               # clear negative value flag
            la      $a1,prompt_msg      # prompt for the number
            jal     printstr
next_char:  jal     getchar
            addi    $t0,$v0,-4          # Check for Control-D
            beq     $t0,$zero,eof
          
            # echo character typed
            addi    $a0,$v0,0
            jal     putchar

            # process the char
            beq     $s1,$zero,not_sign  # Check for start of string
            li      $s1,0               # clear start of string flag
            addi    $t0,$a0,-43         # Check for plus sign
            beq     $t0,$zero,next_char # Positive num is default
            addi    $t0,$a0,-45         # Check for minus sign
            bne     $t0,$zero,not_sign
            li      $s2,1               # set negative value flag
            b       next_char

not_sign:   addi    $t0,$a0,-10         # Check for linefeed
            beq     $t0,$zero,eol
            addi    $a0,$a0,-48         # convert char to decimal
            slti    $t0,$a0,10          # check if valid
            beq     $t0,$zero,syntax
            slti    $t0,$a0,0
            bne     $t0,$zero,syntax
            
            mul     $s0,$s0,$s7         # val = (val * 10) + d
            add     $s0,$s0,$a0
            b       next_char

eol:        # EOL (end of line) received: Negate the value if necessary
            # and save it in memory.
            beq     $s2,$zero,not_neg
            sub     $s0,$zero,$s0
not_neg:    sw      $s0,0($s6)
            add     $s4,$s4,$s0         # Update my vector sum
            addi    $s6,4
            addi    $s5,$s5,1
            b       next_line

            # EOF (end of file, Control-D) received: Call student's
            # routine.

eof:
            la      $a1, eod_msg
            jal     printstr

            la      $a0,values
            add     $a1,$s5,$zero
            beq     $a1,$zero,no_nums
            jal     addem
            addi    $s3,$v0,0           # Save student's answer

            # Print My Sum
            la      $a1, correct_msg
            jal     printstr
            addi    $a0,$s4,0           # Value to format
            la      $a1,correct_str     # Field to receive string
            li      $a2,12              # Field width
            jal     format_decimal
            la      $a1,correct_str     # Print it
            jal     printstr
            la      $a1,newline_msg
            jal     printstr

            # Print Student Sum
            la      $a1,student_msg
            jal     printstr
            addi    $a0,$s3,0           # Value to format
            la      $a1,student_str     # Field to receive string
            li      $a2,12              # Field width
            jal     format_decimal
            la      $a1,student_str     # Print it
            jal     printstr
            la      $a1, newline_msg
            jal     printstr

            # Tell student whether his/her answer agrees with mine or
            # not.
            la      $a1,sad_msg
            bne     $s3,$s4,summary
            la      $a1,happy_msg
summary:    jal     printstr

            # Exit Program
            li      $v0, 10
            syscall

            # Advise user that there were no numbers
no_nums:    la      $a1,no_nums_msg
            b       summary

            # Display syntax msg and abandon line
syntax:     la      $a1,syntax_msg
            jal     printstr
            b       next_line

#
#   Utilities
#

# getchar()
# Uses memory-mapped I/O to read a character from console.
getchar:  la      $t1,0xFFFF0000  # Control register
waitRx:   lw      $t2,0($t1)      # Test ready bit
          beq     $t2,$zero,waitRx
          addi    $t1,$t1,4       # Data register
          lw      $v0,0($t1)
          jr      $ra

# putchar()
# Uses memory-mapped I/O to write a character to the console.
putchar:  la      $t1,0xFFFF0008  # Control register
waitTx:   lw      $t2,0($t1)      # Test ready bit
          beq     $t2,$zero,waitTx
          addi    $t1,$t1,4       # Data register
          sw      $a0,0($t1)
          jr      $ra

# printstr()
# Uses putchar() to write a nul-terminated string to the console.
#   $a1: Address of asciiz string.

printstr:
          # prologue
          subu    $sp,$sp,32
          sw      $ra,20($sp)
          sw      $fp,16($sp)
          addiu   $fp,$sp,28

printstr_1:   # Get a char and check for nul byte marking end of
              # string.
          lb      $a0,0($a1)
          beq     $a0,$zero,printstr_ret
          jal     putchar
          addiu   $a1,$a1,1
          b       printstr_1

printstr_ret: # epilogue
          lw      $ra,20($sp)
          lw      $fp,16($sp)
          addiu   $sp,$sp,32
          jr      $ra


# format_decimal()
# Convert the signed int in $a0 to an asciiz string at mem addr $a1,
# right justified in a field of width $a2 characters.
format_decimal:
            lw    $s7,const_ten         # For extracting digits
            add   $a1,$a1,$a2           # Position of terminating nul
            sb    $zero,0($a1)
            addi  $a1,$a1,-1
            addi  $a2,$a2,-1
            
            slti  $t0,$a0,0             # Check sign of value
            beq   $t0,$zero,fmt_dec_1   # $t0 is 1 for neg, and 0 otherwise
            sub   $a0,$zero,$a0

fmt_dec_1:    # Get next digit
            beq   $a2,$zero,fmt_dec_2   # No more room in field?
            div   $a0,$s7
            mflo  $a0                   # val div 10
            mfhi  $v0                   # val mod 10
            addi  $v0,48                # Convert to ASCII
            sb    $v0,0($a1)
            addi  $a1,$a1,-1
            addi  $a2,$a2,-1
            bne   $a0,$zero,fmt_dec_1   # Loop while quotient not zero

fmt_dec_2:    # Insert sign and fill with spaces
            beq   $t0,$zero,fmt_dec_3   # Branch if value is not neg.
            li    $v0,0x2D              # Minus sign
            sb    $v0,0($a1)
            addi  $a1,-1
            addi  $a2,-1
            slti  $t0,$a2,0             # Exit if field filled
            bne   $t0,$zero,fmt_dec_ret

fmt_dec_3:  li    $v0,0x20              # Pad left with spaces
fmt_dec_4:  sb    $v0,0($a1)
            addi  $a1,-1
            addi  $a2,-1
            slti  $t0,$a2,0
            beq   $t0,$zero,fmt_dec_4

fmt_dec_ret:  # Return
            jr    $ra

          .end

