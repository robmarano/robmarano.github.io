    .data
prompt_name:  .asciiz "Please enter your name: "
prompt_age:   .asciiz "Please enter your age: "
result_msg:   .asciiz "Hello! You entered age: "
newline:      .asciiz "\n"
name_buffer:  .space 64     # Reserve 64 bytes in memory for the string input

    .text
    .globl main
main:
    # 1. Ask for Name FIRST (to avoid the leftover newline from syscall 5)
    li  $v0, 4              # syscall 4: print string
    la  $a0, prompt_name
    syscall
    
    # 2. Read String from Keyboard
    li  $v0, 8              # syscall 8: read string
    la  $a0, name_buffer    # $a0 = address of where to save the string in memory
    li  $a1, 64             # $a1 = maximum length to read (prevents buffer overflow)
    syscall                 # Program pauses waiting for user input
    
    # 3. Ask for Age
    li  $v0, 4              # syscall 4: print string
    la  $a0, prompt_age     
    syscall
    
    # 4. Read Integer from Keyboard
    li  $v0, 5              # syscall 5: read integer
    syscall                 # Program pauses waiting for user to type and press Enter
    move $s0, $v0           # IMMEDIATELY save the returned integer into a safe register ($s0)
    
    # 5. Echo the Results Back
    li  $v0, 4              # syscall 4: print string
    la  $a0, result_msg
    syscall
    
    li  $v0, 1              # syscall 1: print integer
    move $a0, $s0           # load our saved age from $s0
    syscall
    
    # Print trailing newline
    li  $v0, 4              # syscall 4: print string
    la  $a0, newline
    syscall
    
    # Exit cleanly
    li  $v0, 10
    syscall
