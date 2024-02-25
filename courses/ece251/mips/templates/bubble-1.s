# Bubble Sort is an elementary sorting algorithm, which works by repeatedly exchanging adjacent elements, if necessary. When no exchanges are required, the file is sorted.

# We assume list is an array of n elements. We further assume that swap function swaps the values of the given array elements.

# Step 1 − Check if the first element in the input array is greater than the next element in the array.

# Step 2 − If it is greater, swap the two elements; otherwise move the pointer forward in the array.

# Step 3 − Repeat Step 2 until we reach the end of the array.

# Step 4 − Check if the elements are sorted; if not, repeat the same process (Step 1 to Step 3) from the last element of the array to the first.

# Step 5 − The final output achieved is the sorted array.

# Algorithm: Sequential-Bubble-Sort (A)
# fori ← 1 to length [A] do
# for j ← length [A] down-to i +1 do
#    if A[A] < A[j-1] then
#       Exchange A[j] ⟷ A[j-1]
  
  
  .data
arr: .word 10, 60, 40, 70, 20, 30, 90, 100, 0, 80, 50
space: .asciiz " "
newLine: .asciiz "\n"                               # Newline character

  .text
  .globl main

main:
  lui $s0, 0x1001                   #arr[0]
  add $t2, $zero, $s0
  li $s1, 11                        #n = 11
print_loop_1:
  li $v0, 1
  lw $a0, 0($t2)
  syscall
  li $v0, 4
  la $a0, space
  syscall

  addi $t2, $t2, 4                  #addr itr i += 4
  addi $t0, $t0, 1                  #i++
  bne $t0, $s1, print_loop_1          #i != n

    ####################################
    # Print a new line
    ####################################
    la $a0,newLine
    li $v0,4
    syscall 


  # start algo here
  lui $s0, 0x1001                   #arr[0]
  li $t0, 0                         #i = 0
  li $t1, 0                         #j = 0
  li $s1, 11                        #n = 11
  li $s2, 11                        #n-i for inner loop
  add $t2, $zero, $s0               #for iterating addr by i
  add $t3, $zero, $s0               #for iterating addr by j

  addi $s1, $s1, -1

outer_loop:
  li  $t1, 0                        #j = 0
  addi $s2, $s2, -1                 #decreasing size for inner_loop
  add $t3, $zero, $s0               #resetting addr itr j

  inner_loop:
    lw $s3, 0($t3)                  #arr[j]
    addi $t3, $t3, 4                #addr itr j += 4
    lw $s4, 0($t3)                  #arr[j+1]
    addi $t1, $t1, 1                #j++

    slt $t4, $s3, $s4               #set $t4 = 1 if $s3 < $s4
    bne $t4, $zero, cond
    swap:
      sw $s3, 0($t3)
      sw $s4, -4($t3)
      lw $s4, 0($t3)

    cond:
      bne $t1, $s2, inner_loop      #j != n-i

    addi $t0, $t0, 1                  #i++
  bne $t0, $s1, outer_loop           #i != n

  li $t0, 0
  addi $s1, $s1, 1
print_loop:
  li $v0, 1
  lw $a0, 0($t2)
  syscall
  li $v0, 4
  la $a0, space
  syscall

  addi $t2, $t2, 4                  #addr itr i += 4
  addi $t0, $t0, 1                  #i++
  bne $t0, $s1, print_loop          #i != n

    ####################################
    # Print a new line
    ####################################
    la $a0,newLine
    li $v0,4
    syscall 
exit:
  li $v0, 10
  syscall
