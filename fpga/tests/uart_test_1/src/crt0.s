#.section .init, "ax"
.global _start
_start:
    .cfi_startproc
    .cfi_undefined ra
    .option push
    .option norelax
    la gp, __global_pointer$
    .option pop
    la sp, __stack_top
    add s0, sp, zero
    li t0, 0x10010000

    li t1, 0x54524155
    sw t1,0(t0)

    li t1, 0x0D4B4F20
    sw t1,4(t0)

    /* "\n\0" */
    li t1, 0x0000000A
    sw t1, 8(t0)
    jal ra, main
el:
    j el
    nop
    nop	
    .cfi_endproc
    .end
