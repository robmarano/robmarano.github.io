    .data
magnitude:  .float 16.0
one:        .float 1.0

    .text
    .globl main
main:
    li    $t0, 0
    li    $t1, 100000       # Loop 100,000 times
    l.s   $f12, magnitude
    l.s   $f4, one

bench_loop:
    beq   $t0, $t1, end_bench
    
    # Standard IEEE 1 / sqrt(x)
    sqrt.s $f0, $f12        # Calculate square root
    div.s  $f0, $f4, $f0    # 1.0 / sqrt(x)
    
    addi  $t0, $t0, 1
    j     bench_loop

end_bench:
    li  $v0, 10
    syscall
