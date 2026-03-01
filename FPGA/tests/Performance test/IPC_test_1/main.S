#Performance test for calulcating IPC and testing also the commited instruction signal.
#By writng the program totally in asm I know precisly the number of instructions that have to be counted as committed by the core.
# By contuning the cycles and the instructions the final IPC can be calculated for this program.
# The program should count a total of 0xF9067 committed instructions. Considering that the benchmark is represented by a loop of
# 10000 cycles each executing 100 ALU instructions..

#Loaded in rom_9.vhd


# Definizione Indirizzi Hardware
.equ UART_REG,   0x10012000
.equ CYCLE_ADDR, 0x10013000
.equ INST_ADDR,  0x10014000
.equ LED_REG,    0x10011000

.section .text
.globl main

main:
    # 1. INIZIALIZZAZIONE STACK 
    li sp, 0x10011000 

    # 2. Benchmark Setup
    li a0, 10000        
    li s10, CYCLE_ADDR  
    li s11, INST_ADDR  

    # --- SNAPSHOT START ---
    lw s0, 0(s10)       # s0 = start cycles
    lw s1, 0(s11)       # s1 = start instructions

    # Inizializzazione registri di calcolo
    li t2, 1
    li t3, 2
    li t4, 3
    li t5, 4
    li t6, 5

benchmark_loop:
    add t2, t2, t3
    add t3, t3, t4
    add t4, t4, t5
    add t5, t5, t6
    add t6, t6, t2
    .rept 19
    add t2, t2, t3
    add t3, t3, t4
    add t4, t4, t5
    add t5, t5, t6
    add t6, t6, t2
    .endr

    addi a0, a0, -1     
    bnez a0, benchmark_loop

    # --- SNAPSHOT END ---
    lw s2, 0(s10)       # s2 = end cycles
    lw s3, 0(s11)       # s3 = end instructions

    # Delta
    sub s2, s2, s0      # s2 = diff_cycles
    sub s3, s3, s1      # s3 = diff_instr

    # 3. print
    li a0, 'C'
    jal ra, uart_putc
    li a0, ':'
    jal ra, uart_putc
    
    mv a0, s2           
    jal ra, uart_put_hex

    li a0, '\n'
    jal ra, uart_putc
    li a0, 'I'
    jal ra, uart_putc
    li a0, ':'
    jal ra, uart_putc

    mv a0, s3           
    jal ra, uart_put_hex

    # 4. END
    li t0, LED_REG
    li t1, 1
    sw t1, 0(t0)

loop_forever:
    j loop_forever



uart_putc:
    li a1, UART_REG

wait_busy:
    lw a2, 0(a1)
    li a3, (1 << 24)      # busy bit
    and a2, a2, a3
    bnez a2, wait_busy    # aspetta finché busy=1

    # --- Scrittura con start=1 ---
    li a3, (1 << 8)       # start bit
    or a2, a0, a3         # unisci char + start
    sw a2, 0(a1)

    # --- Riporta start a 0 ---
    sw a0, 0(a1)

    ret

uart_put_hex:
    addi sp, sp, -32
    sw ra, 28(sp)
    sw s0, 24(sp)
    sw s1, 20(sp)
    mv s0, a0           # Valore da stampare
    li s1, 7          

hex_loop:
    sll a4, s1, 2       # Shift amount
    srl a0, s0, a4      
    andi a0, a0, 0xF    
    
    li a5, 10
    blt a0, a5, low_digit
    addi a0, a0, ('A' - 10)
    j print_digit
low_digit:
    addi a0, a0, '0'
print_digit:
    jal ra, uart_putc

    addi s1, s1, -1     
    li a5, -1
    bne s1, a5, hex_loop

    lw s1, 20(sp)
    lw s0, 24(sp)
    lw ra, 28(sp)
    addi sp, sp, 32
    ret