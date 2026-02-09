.data
# Array di test
test_array:
    .word 5
    .word 9
    .word -3
    .word 100
    .word 2
    .word 8
    .word 1
    .word 0
    .word -7
    .word 50


.text
.global __start

__start:
    # setup gp e sp
    auipc gp, 0x1fc18
    addi gp, gp, 40        # __global_pointer$
    auipc sp, 0x7fbff
    addi sp, sp, -12       # __stack_top
    add s0, sp, zero
    jal ra, main           # jump to main

el:
    j el
    nop
    nop

main:
    lui a0, 0x10010        # indirizzo base test_array
    addi sp, sp, -16
    mv a0, a0
    li a1, 10               # lunghezza dell'array
    sw ra, 12(sp)
    jal ra, bubble_sort
    lw ra, 12(sp)
    li a0, 0
    addi sp, sp, 16
    ret

bubble_sort:
    li a5, 1
loop_start:
    bgeu a5, a1, loop_end
    slli a2, a1, 2
    add a2, a0, a2
    li a6, 1
    addi a0, a0, 4
step_1:
    mv a5, a0
step_2:
    lw a4, -4(a5)
    lw a3, 0(a5)
    bge a3, a4, skip_swap
    sw a3, -4(a5)
    sw a4, 0(a5)
skip_swap:
    addi a5, a5, 4
    bne a5, a2, step_2
    addi a1, a1, -1
    addi a2, a2, -4
    bne a1, a6, step_1
loop_end:
    ret
