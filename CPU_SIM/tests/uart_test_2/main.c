#include <stdint.h>


/* Memory-mapped peripherals */
#define LED_REG   (*(volatile uint32_t*)0x10011000)
#define UART_REG  (*(volatile uint32_t*)0x10012000)

/* RAM */
#define RAM_BASE  0x10010000
#define RAM_WORDS 1024 - 64   /* 4 KB */

/* -------------------------------------------------- */
/* UART: send one character                           */
/* -------------------------------------------------- */
static inline void uart_putc(uint8_t c)
{
    /* wait while busy (bit 24) */
    while (UART_REG & (1u << 24));

    /* start transmission (bit 8 = wr) */
    UART_REG = (uint32_t)c;
    UART_REG = (uint32_t)c | (1 << 8);
    UART_REG = (uint32_t)c;
}

/* -------------------------------------------------- */
/* UART: print 32-bit value as hex                    */
/* -------------------------------------------------- */
static void uart_put_hex(uint32_t v)
{
    for (int i = 7; i >= 0; i--) {
        uint32_t n = (v >> (i * 4)) & 0xF;
        uart_putc(n < 10 ? ('0' + n) : ('A' + n - 10));
    }
}

/* -------------------------------------------------- */
/* Simple delay (busy loop)                           */
/* -------------------------------------------------- */
static void delay(volatile uint32_t d)
{
    while (d--) {
        __asm__ volatile ("nop");
    }
}

/* -------------------------------------------------- */
/* MAIN                                               */
/* -------------------------------------------------- */
int main(void)
{
    volatile uint32_t *ram = (uint32_t*)RAM_BASE;

    uint32_t iter = 0;

    /* BOOT indication */
    LED_REG = 0x01;
   // uart_putc('B');
   // uart_putc('O');
   // uart_putc('O');
   // uart_putc('T');
   // uart_putc('\n');
   // uart_putc('\r');
   // uart_putc('R');
   // uart_putc('I');
   // uart_putc('S');
   // uart_putc('C');
   // uart_putc('V');
   // uart_putc(' ');
   // uart_putc('c');
   // uart_putc('o');
   // uart_putc('r');
   // uart_putc('e');
   // uart_putc('\n');
   // uart_putc('\r');

  //  delay(500000);

    while (1) {
        uint32_t checksum = 0;
        uint32_t errors   = 0;

        /* --------------------------------------------------
         * RAM WRITE TEST
         * -------------------------------------------------- */
        for (uint32_t i = 0; i < RAM_WORDS; i++) {
            ram[i] = i ^ 0xA5A5A5A5;
        }

        /* --------------------------------------------------
         * RAM READ / VERIFY
         * -------------------------------------------------- */
        for (uint32_t i = 0; i < RAM_WORDS; i++) {
            uint32_t v = ram[i];
            checksum ^= v;

            if (v != (i ^ 0xA5A5A5A5)) {
                errors++;
            }
        }

        /* --------------------------------------------------
         * REPORT
         * -------------------------------------------------- */
        uart_putc('I'); uart_putc('T'); uart_putc(':'); uart_putc(' ');
        uart_put_hex(iter);
        uart_putc('\n'); uart_putc('\r');

        uart_putc('C'); uart_putc('S'); uart_putc(':'); uart_putc(' ');
        uart_put_hex(checksum);
        uart_putc('\n'); uart_putc('\r');

        uart_putc('E'); uart_putc('R'); uart_putc('R'); uart_putc(':'); uart_putc(' ');
        uart_put_hex(errors);
        uart_putc('\n'); uart_putc('\r');
        uart_putc('\n'); uart_putc('\r');

        /* --------------------------------------------------
         * LED STATUS
         * -------------------------------------------------- */
        if (errors == 0) {
            LED_REG = iter & 0xFF;
        } else {
            LED_REG = 0xF0;
        }

        iter++;
        delay(2000000);
    }
}
