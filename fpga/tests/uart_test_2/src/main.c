/* test for synthetised core:
The program tests memory access by sending the results on UART and using LEDs as counting address.
Loaded in rom7.vhd */

#include <stdint.h>

/* Periferiche */
#define LED_REG   (*(volatile uint32_t*)0x10011000)
#define UART_REG  (*(volatile uint32_t*)0x10012000)

/* RAM */
#define RAM_BASE  0x10010000
#define RAM_WORDS 512 

/* UART: invio singolo carattere */
static inline void uart_putc(uint8_t c) {
    while (UART_REG & (1u << 24));
    UART_REG = (uint32_t)c;
    UART_REG = (uint32_t)c | (1 << 8);
    UART_REG = (uint32_t)c;
}

/* UART: stampa valore hex a 8 cifre */
static void uart_put_hex(uint32_t v) {
    for (int i = 7; i >= 0; i--) {
        uint32_t n = (v >> (i * 4)) & 0xF;
        uart_putc(n < 10 ? ('0' + n) : ('A' + n - 10));
    }
}

int main(void) {
    volatile uint32_t *ram = (uint32_t*)RAM_BASE;
    uint32_t iter = 0;
    uint32_t total_errors = 0;

    uart_putc('R'); uart_putc('I'); uart_putc('S'); uart_putc('C'); uart_putc('V'); uart_putc('3'); uart_putc('2'); uart_putc('I'); uart_putc('\n'); uart_putc('\r'); 
    uart_putc('M'); uart_putc('e'); uart_putc('m'); uart_putc('o'); uart_putc('r'); uart_putc('y'); uart_putc(' '); uart_putc('T'); uart_putc('e'); uart_putc('s'); uart_putc('t');  uart_putc('\n'); uart_putc('\r');
    while (1) {
        /* Pattern dinamico per ogni iterazione (senza MUL) */
        uint32_t base_seed = 0xA5A5A5A5 ^ (iter << 13) ^ (iter >> 5);

        for (uint32_t i = 0; i < RAM_WORDS; i++) {
            /* Calcolo indirizzo fisico e dato unico per questa cella */
            uint32_t phys_addr = RAM_BASE + (i * 4);
            uint32_t val_to_write = base_seed ^ (i << 2) ^ i;
            
            /* --- OPERAZIONE: SCRITTURA E LETTURA ISTANTANEA --- */
            ram[i] = val_to_write;
            uint32_t val_read = ram[i];

            if (val_to_write != val_read) {
                total_errors++;
            }

            /* --- STAMPA FORMATTATA SU SINGOLA RIGA --- */
            /* Formato: IT:XXXXXXXX ADDR:XXXXXXXX W:XXXXXXXX/R:XXXXXXXX ERR:XXXXXXXX */
            uart_putc('\r'); 
            
            // Iterazione
            uart_putc('I'); uart_putc('T'); uart_putc(':');
            uart_put_hex(iter);
            uart_putc(' ');

            // Indirizzo Fisico
            uart_putc('A'); uart_putc('D'); uart_putc('D'); uart_putc('R'); uart_putc(':');uart_putc('0'); uart_putc('x');
            uart_put_hex(phys_addr);
            uart_putc(' ');

            // Dati: Scritto / Letto
            uart_putc('0'); uart_putc('x');
            uart_put_hex(val_to_write);
            uart_putc('|');
            uart_putc('0'); uart_putc('x');
            uart_put_hex(val_read);
            uart_putc(' ');

            // Errori totali
            uart_putc('E'); uart_putc('R'); uart_putc('R'); uart_putc(':');
            uart_put_hex(total_errors);

            /* Feedback visivo sui LED */
            if (total_errors > 0) {
                LED_REG = 0xF0 | (total_errors & 0x0F); // Errore: LED alti accesi
            } else {
                LED_REG = (i >> 2); // Tutto OK: i LED scorrono con l'indirizzo
            }
            
            /* Delay minimo per permettere alla UART di trasmettere e a te di vedere */
            // Se la simulazione è troppo lenta, puoi commentare questa riga
            for(volatile int d = 0; d < 1500000; d++); 
        }

        iter++;
    }
}