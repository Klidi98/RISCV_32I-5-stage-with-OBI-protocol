/* Performance test n.3:
This test shows the impact of branches in a loop.
It calculates IPC of the benchmark a and prints the number of cycles and the number of committed instructions, allowing to calculate IPC.
Attended IPC is around 0.5 considering 4 instructions flushed per branch taken and considerirng that the loop 
contains around 4 instructions.

Loaded in rom_11.vhd
 */


#include <stdint.h>

#define UART_REG   (*(volatile uint32_t*)0x10012000)
#define CYCLE_CNT  (*(volatile uint32_t*)0x10013000)
#define INST_CNT   (*(volatile uint32_t*)0x10014000)

// LED
#define LED_REG    (*(volatile uint32_t*)0x10011000)

static void uart_putc(uint8_t c) {
    while (UART_REG & (1u << 24));   // busy
    UART_REG = (uint32_t)c;
    UART_REG = (uint32_t)c | (1 << 8); // wr_enable
    UART_REG = (uint32_t)c;
}

static void uart_put_hex(uint32_t v) {
    for (int i = 7; i >= 0; i--) {
        uint32_t n = (v >> (i * 4)) & 0xF;
        uart_putc(n < 10 ? ('0' + n) : ('A' + n - 10));
    }
}

static void uart_print_nl() { uart_putc('\n'); }

static inline void uart_print_label_cycles() {
    uart_putc('C'); uart_putc('Y'); uart_putc('C');
    uart_putc('L'); uart_putc('E'); uart_putc('S');
    uart_putc(':'); uart_putc(' ');
}

static inline void uart_print_label_instr() {
    uart_putc('I'); uart_putc('N'); uart_putc('S');
    uart_putc('T'); uart_putc('R'); uart_putc(':');
    uart_putc(' ');
}

void benchmark() {
    volatile uint32_t a = 1, b = 2, c = 3;

    for (int i = 0; i < 100000; i++) {
        a = a + b;
        b = b ^ c;
        c = (c << 1) | (c >> 31);
    }
}

int main() {

    // boot message
    uart_putc('B'); uart_putc('O'); uart_putc('O'); uart_putc('T');
    uart_print_nl();

    uint32_t c_start = CYCLE_CNT;
    uint32_t i_start = INST_CNT;

    benchmark();

    uint32_t c_end = CYCLE_CNT;
    uint32_t i_end = INST_CNT;

    uint32_t cycles = c_end - c_start;
    uint32_t instr  = i_end - i_start;

    // Print cycles
    uart_print_label_cycles();
    uart_put_hex(cycles);
    uart_print_nl();

    // Print instructions
    uart_print_label_instr();
    uart_put_hex(instr);
    uart_print_nl();

    // LED ON (program reached end)
    LED_REG = 1;

    while (1);
}