/* Performance test for calculating IPC and testing forwarding unit.
In this case each cycle of the loop contains a hundred ALU instructions. Thanks to the forarding unit
the IPC should be near to 1. The tests checks also the final value of the operations, checking correct forwarding behaviour.

Loaded in rom_10.vhd
*/

#include <stdint.h>
#define UART_REG   (*(volatile uint32_t*)0x10012000)
#define CYCLE_CNT  (*(volatile uint32_t*)0x10013000)
#define INST_CNT   (*(volatile uint32_t*)0x10014000)

// LED
#define LED_REG    (*(volatile uint32_t*)0x10011000)


static inline void uart_putc(uint8_t c) {
    while (UART_REG & (1u << 24));
    UART_REG = (uint32_t)c;
    UART_REG = (uint32_t)c | (1 << 8);
    UART_REG = (uint32_t)c;
}

static void uart_put_hex(uint32_t v) {
    for (int i = 7; i >= 0; i--) {
        uint32_t n = (v >> (i * 4)) & 0xF;
        uart_putc(n < 10 ? ('0' + n) : ('A' + n - 10));
    }
}


int main() {


    uint32_t a0=1, a1=2, a2=3, a3=4, a4=5, a5=6, a6=7;
    uint32_t t0; 
    uint32_t res;

    uint32_t c0 = CYCLE_CNT;
    uint32_t i0 = INST_CNT;


    asm volatile(
        "li a0, 1\n\t"
        "li a1, 2\n\t"
        "li a2, 3\n\t"
        "li a3, 4\n\t"
        "li a4, 5\n\t"
        "li a5, 6\n\t"
        "li a6, 7\n\t"
        "li t0, 10000\n\t"

        "1:\n\t"

#define ASM_ALU10 \
    "add a0, a0, a1\n\t" \
    "add a1, a1, a2\n\t" \
    "add a2, a3, a4\n\t" \
    "add a3, a4, a5\n\t" \
    "add a6, a4, a6\n\t" \
    "add a5, a4, a6\n\t" \
    "add a1, a1, a2\n\t" \
    "add a2, a3, a4\n\t" \
    "add a3, a4, a5\n\t" \
    "add a6, a2, a6\n\t" 


        ASM_ALU10 ASM_ALU10 ASM_ALU10 ASM_ALU10 ASM_ALU10
        ASM_ALU10 ASM_ALU10 ASM_ALU10 ASM_ALU10 ASM_ALU10

        "addi t0, t0, -1\n\t"
        "bnez t0, 1b\n\t"

        : "=r" (a0), "=r" (a1), "=r" (a2), "=r" (a3), "=r" (a4), "=r" (a5), "=r" (a6)
   
        : "t0", "cc", "memory"
    );

    //a0, a1... contengono i valori post-loop
    res = a0 + a1 + a2 + a3 + a4 + a5 + a6;

    uint32_t c1 = CYCLE_CNT;
    uint32_t i1 = INST_CNT;

    uint32_t cycles = c1 - c0;
    uint32_t instr  = i1 - i0;

    // print CYCLES
    uart_putc('\r');
    uart_putc('C'); uart_putc(':'); uart_putc(' ');
    uart_put_hex(cycles);
    uart_putc('\n');
    uart_putc('\r');
    // print INSTR
    uart_putc('I'); uart_putc(':'); uart_putc(' ');
    uart_put_hex(instr);
    uart_putc('\n');

if(res == 0xB5CA1158) {
        LED_REG = 1;
    } else {
        LED_REG = 0xDEAD;
        //stampa il valore errato per debug
        uart_putc('E'); uart_putc(':'); uart_put_hex(res);
    }
}
