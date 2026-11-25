# Listing 5 - the class report (TN3 file)
.data
classA: .word 72, 55, 90, 48, 63, 85, 39, 77, 60, 94
classB: .word 45, 81, 66, 50, 92, 38, 70, 59
hdrA:   .asciiz "== Class A ==\n"
hdrB:   .asciiz "== Class B ==\n"
mTot:   .asciiz "Total:  "
mPass:  .asciiz "Passed: "
mSpr:   .asciiz "Spread: "
nl:     .asciiz "\n"
.text
.globl main
main:
    li   $v0, 4
    la   $a0, hdrA
    syscall
    # Class A
la   $a0, classA
addi $a1, $zero, 10
addi $a2, $zero, 83
jal  report

# Class B
la   $a0, classB
addi $a1, $zero, 8
addi $a2, $zero, 83
jal  report
    li   $v0, 10
    syscall

# report(addr = $a0, n = $a1, mark = $a2): prints total, passes and spread
report:

    addi $sp, $sp, -16      # frame: $ra, $s0, $s1, $s2

    sw $ra, 12($sp)
    sw $s0, 8($sp)
    sw $s1, 4($sp)
    sw $s2, 0($sp)

    add $s0, $a0, $zero     # $s0 = addr
    add $s1, $a1, $zero     # $s1 = n
    add $s2, $a2, $zero     # $s2 = mark

    jal sum_array           # $v0 = total

    la $a0, mTot
    add $a1, $v0, $zero
    jal show

    # call count_pass(addr, n, mark)

    add $a0, $s0, $zero
    add $a1, $s1, $zero
    add $a2, $s2, $zero
    jal count_pass

    # print Passed

    la $a0, mPass
    add $a1, $v0, $zero
    jal show

    # call spread(addr, n)

    add $a0, $s0, $zero
    add $a1, $s1, $zero
    jal spread

    # print Spread

    la $a0, mSpr
    add $a1, $v0, $zero
    jal show

    # restore registers

    lw $s2, 0($sp)
    lw $s1, 4($sp)
    lw $s0, 8($sp)
    lw $ra, 12($sp)

    addi $sp, $sp, 16

    jr $ra


# Listing 4 - spread with $s0 and a frame of four words
spread:

    addi $sp, $sp, -16      # frame: four words

    sw   $ra, 12($sp)

    sw   $s0, 8($sp)        # save $s0

    sw   $a0, 4($sp)        # keep addr

    sw   $a1, 0($sp)        # keep n

    jal  max_array

    add  $s0, $v0, $zero    # keep the largest in $s0

    lw   $a0, 4($sp)

    lw   $a1, 0($sp)

    jal  min_array

    sub  $v0, $s0, $v0

    lw   $s0, 8($sp)        # restore $s0
    lw   $ra, 12($sp)       # restore $ra

    addi $sp, $sp, 16       # give the frame back

    jr   $ra
# max_array(addr = $a0, n = $a1): returns the largest of n words in $v0
max_array:
    lw   $v0, 0($a0)        # largest = element 0
    addi $t0, $zero, 1      # i = 1
max_loop:
    slt  $t1, $t0, $a1      # $t1 = 1 if i < n
    beq  $t1, $zero, max_end
    sll  $t2, $t0, 2
    add  $t2, $t2, $a0      # $t2 = address of element i
    lw   $t3, 0($t2)
    slt  $t1, $v0, $t3      # $t1 = 1 if largest < element i
    beq  $t1, $zero, max_next
    add  $v0, $t3, $zero    # new largest
max_next:
    addi $t0, $t0, 1        # i = i + 1
    j    max_loop
max_end:
    jr   $ra



# min_array(addr = $a0, n = $a1): returns the largest of n words in $v0
min_array:

    lw $v0, 0($a0)          # smallest = element 0

    addi $t0, $zero, 1      # i = 1

min_loop:

    slt $t1, $t0, $a1
    beq $t1, $zero, min_end

    sll $t2, $t0, 2
    add $t2, $t2, $a0
    lw $t3, 0($t2)

    slt $t1, $t3, $v0       # if element i < smallest
    beq $t1, $zero, min_next

    add $v0, $t3, $zero     # new smallest

min_next:

    addi $t0, $t0, 1
    j min_loop

min_end:

    jr $ra
