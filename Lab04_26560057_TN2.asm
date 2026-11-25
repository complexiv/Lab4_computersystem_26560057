# Listing 3 - spread(addr, n) = largest - smallest (this version has an error)
.data
classA: .word 72, 55, 90, 48, 63, 85, 39, 77, 60, 94
classB: .word 45, 81, 66, 50, 92, 38, 70, 59
msgA:   .asciiz "Class A spread: "
msgB:   .asciiz "Class B spread: "
nl:     .asciiz "\n"
.text
.globl main
main:
    la   $a0, classA
    addi $a1, $zero, 10
    jal  spread             # $v0 = spread of class A
    la   $a0, msgA
    add  $a1, $v0, $zero
    jal  show
    la   $a0, classB
    addi $a1, $zero, 8
    jal  spread             # $v0 = spread of class B
    la   $a0, msgB
    add  $a1, $v0, $zero
    jal  show
    li   $v0, 10
    syscall

# Listing 4 - spread with $s0 and a frame of four words
spread:
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
