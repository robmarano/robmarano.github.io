    .data
magic:      .word 0x5f3759df
threehalfs: .float 1.5
half:       .float 0.5
magnitude:  .float 16.0

    .text
    .globl main
main:
    li    $t8, 0
    li    $t9, 100000       # Loop 100,000 times
    l.s   $f12, magnitude
    l.s   $f4, half
    l.s   $f6, threehalfs
    lw    $t2, magic

bench_loop:
    beq   $t8, $t9, end_bench

    # Quake algorithm
    mul.s $f2, $f12, $f4
    mfc1  $t0, $f12
    srl   $t1, $t0, 1
    sub   $t0, $t2, $t1
    mtc1  $t0, $f0
    mul.s $f8, $f0, $f0
    mul.s $f8, $f2, $f8
    sub.s $f8, $f6, $f8
    mul.s $f0, $f0, $f8
    mul.s $f8, $f0, $f0
    mul.s $f8, $f2, $f8
    sub.s $f8, $f6, $f8
    mul.s $f0, $f0, $f8

    addi  $t8, $t8, 1
    j     bench_loop

end_bench:
    li  $v0, 10
    syscall
