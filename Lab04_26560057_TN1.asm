times4:

    addi $sp, $sp, -4      # make room for one word

    sw   $ra, 0($sp)       # save $ra

    jal  twice             # $v0 = 2 * x

    add  $a0, $v0, $zero

    jal  twice             # $v0 = 4 * x

    lw   $ra, 0($sp)       # restore $ra

    addi $sp, $sp, 4       # give the room back

    jr   $ra
