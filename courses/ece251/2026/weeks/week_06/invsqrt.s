# Fast Inverse Square Root (1/sqrt(x)) in MIPS
# Input: $f12 (float number)
# Output: $f0 (result)
.data
   magic:      .word 0x5f3759df
   threehalfs: .float 1.5
   half:       .float 0.5
   
.text
Q_rsqrt:
   # 1. x2 = number * 0.5
   l.s   $f4, half          # Load 0.5
   mul.s $f2, $f12, $f4     # $f2 (x2) = number * 0.5

   # 2. i = * ( long * ) &y; (Bit hacking: Move float bits to integer reg)
   mfc1  $t0, $f12          # Move float bits from FPU ($f12) to CPU ($t0) - "y"
                            # This is NOT a conversion. It copies the raw bits.

   # 3. i = 0x5f3759df - ( i >> 1 );
   srl   $t1, $t0, 1        # i >> 1
   lw    $t2, magic         # Load magic number
   sub   $t0, $t2, $t1      # i = magic - (i >> 1)

   # 4. y = * ( float * ) &i; (Move bits back to float reg)
   mtc1  $t0, $f0           # Move integer bits ($t0) back to FPU ($f0) - "y"

   # 5. y = y * ( threehalfs - ( x2 * y * y ) ); (Newton-Raphson method)
   l.s   $f6, threehalfs    # Load 1.5
   mul.s $f8, $f0, $f0      # y * y
   mul.s $f8, $f2, $f8      # x2 * (y * y)
   sub.s $f8, $f6, $f8      # threehalfs - (x2 * y * y)
   mul.s $f0, $f0, $f8      # Final result: y * (...)
   
   jr    $ra                # Return (result in $f0)