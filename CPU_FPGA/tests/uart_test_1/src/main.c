/* This program is the first one testing the UART TX integrated with the core.
It prints a starting message and then continously the letter, while the LEDs blink following a counter continously updated.
Loaded in rom6.vhd
 */

#include <stdint.h>

/* ===============================
 * Memory mapped registers
 * =============================== */
#define UART_TX_REG   (*(volatile uint32_t*)0x10012000)
#define LED_REG       (*(volatile uint32_t*)0x10011000)

/* ===============================
 * Messaggio in DATA MEMORY
 * (NON in ROM istruzioni)
 * =============================== */
volatile char uart_msg[] = "UART OK\r\n";

/* ===============================
 * Simple delay (busy loop)
 * =============================== */
void delay(volatile uint32_t count)
{
    while (count--) {
        asm volatile("nop");
    }
}

/* ===============================
 * Send one byte over UART
 * =============================== */
void uart_send_byte(uint8_t c)
{
    /* wait while UART is busy */
    while (UART_TX_REG & (1 << 24));

    /* write data + start bit */
    UART_TX_REG = (uint32_t)c;
    UART_TX_REG = (uint32_t)c | (1 << 8);
}

/* ===============================
 * Send string over UART
 * =============================== */
void uart_send_string(volatile char *s)
{
    while (*s) {
        uart_send_byte(*s);
        s++;
    }
}

/* ===============================
 * Main
 * =============================== */
int main(void)
{
    uint32_t led_counter = 0;

    /* Send message once at boot */
    uart_send_string(uart_msg);

    /* Main loop */
    while (1)
    {
        /* increment LEDs */
        LED_REG = led_counter++;

        /* send a character periodically */
        uart_send_byte('A');

        /* crude delay */
        delay(500000);
    }

    return 0;
}
