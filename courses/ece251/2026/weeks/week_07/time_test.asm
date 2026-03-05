    .text
    .globl main
main:
    li  $v0, 30
    syscall
    
    move $t0, $a0
    
    # Loop to delay
    li  $t1, 1000000
    li  $t2, 0
delay:
    addi $t2, $t2, 1
    bne  $t1, $t2, delay
    
    li  $v0, 30
    syscall
    
    sub $a0, $a0, $t0   # End time - Start time
    li  $v0, 1
    syscall
    
    li  $v0, 10
    syscall
