    .text
    .globl main
main:
    # Trigger an Address Error Exception by loading a word from an unaligned address
    li  $t0, 0x10010001     # Unaligned memory address (not a multiple of 4)
    lw  $t1, 0($t0)         # Attempt to load a 32-bit word

    # Exit cleanly (will never be reached)
    li  $v0, 10
    syscall
