    .data
magic:      .word 0x5f3759df    # The famous Quake "magic number" constant
threehalfs: .float 1.5
half:       .float 0.5
magnitude:  .float 16.0         # Simulated light vector magnitude (x)
newline:    .asciiz "\n"

    .text
    .globl main
main:
    # Load our lighting magnitude into a floating-point register
    l.s   $f12, magnitude
    
    # --- The Fast Inverse Square Root Algorithm ---
    
    # 1. Calculate x2 = x * 0.5
    l.s   $f4, half
    mul.s $f2, $f12, $f4        # $f2 (x2) = x * 0.5

    # 2. Evil Bit-Level Hacking (Move float bits natively to an integer register)
    mfc1  $t0, $f12             # Copy raw IEEE 754 bits from FPU ($f12) to CPU ($t0)

    # 3. Initial Approximation via Magic Number Subtraction
    srl   $t1, $t0, 1           # Logic Shift Right by 1 (i >> 1)
    lw    $t2, magic            # Load the 0x5f3759df magic constant
    sub   $t0, $t2, $t1         # i = magic - (i >> 1)

    # 4. Move the manipulated integer bits back to the FPU
    mtc1  $t0, $f0              # The float structure in $f0 is now incredibly close to 1/sqrt(x)!

    # 5. First iteration of Newton-Raphson to clean up the approximation
    l.s   $f6, threehalfs       # Load 1.5
    mul.s $f8, $f0, $f0         # y * y
    mul.s $f8, $f2, $f8         # x2 * (y * y)
    sub.s $f8, $f6, $f8         # threehalfs - (x2 * y * y)
    mul.s $f0, $f0, $f8         # Final $f0 Result: y = y * [1.5 - (x2 * y * y)]
    
    # ----------------------------------------------
    
    # (The value in $f0 can now be used to rapidly normalize the light reflection vector!)
    
    # Print the calculated float result in $f0
    li  $v0, 2                  # syscall 2: print float
    mov.s $f12, $f0             
    syscall
    
    # Print trailing newline
    li  $v0, 4
    la  $a0, newline
    syscall

    # Exit cleanly
    li  $v0, 10
    syscall
