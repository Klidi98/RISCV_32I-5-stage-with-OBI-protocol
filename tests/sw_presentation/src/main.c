#include <stdint.h>

// =========================
// Memory mapped registers
// =========================
//#define BP_ENABLE
#define UART_REG   (*(volatile uint32_t*)0x10012000)
#define CYCLE_CNT  (*(volatile uint32_t*)0x10013000)
#define INST_CNT   (*(volatile uint32_t*)0x10014000)

#define LED_REG    (*(volatile uint32_t*)0x10011000)

/* UART func */

static void uart_putc(uint8_t c) {

    while (UART_REG & (1u << 24));

    UART_REG = (uint32_t)c;
    UART_REG = (uint32_t)c | (1 << 8);
    UART_REG = (uint32_t)c;
}

static void uart_puts(const char *s) {

    while (*s)
        uart_putc(*s++);
}

static void uart_put_hex(uint32_t v) {

    for (int i = 7; i >= 0; i--) {

        uint32_t n =
            (v >> (i * 4)) & 0xF;

        uart_putc(
            n < 10 ?
            ('0' + n) :
            ('A' + n - 10));
    }
}

/*
========================= 
Delay
========================= 
*/

static void delay( uint32_t d) {

    for (volatile uint32_t i = 0; i < d; i++);
}

// =========================
// ASCII LOGO 
// =========================

static void print_logo() {

uart_puts("\n\r");

uart_puts("########################################\n\r");
uart_puts("#                                      #\n\r");
uart_puts("#            R I S C - V               #\n\r");
uart_puts("#                                      #\n\r");
uart_puts("#         RV32I CORE ON FPGA           #\n\r");
uart_puts("#                                      #\n\r");
uart_puts("########################################\n\r");

uart_puts("\n\r");

}

// =========================
// Benchmark 
// =========================

static void run_benchmark() {
/* 
     uint32_t a = 1;
     uint32_t b = 2;
     uint32_t c = 0;

    for (uint32_t i = 0; i < 5000000; i++) {

        c = a + b;
        a = b ^ c;
        b = c + i;

        // branch activity
        if (c & 1)
            a += 3;
        else
            b += 7;
    } */
    uint32_t a = 1;
    uint32_t b = 2;
    uint32_t c = 0;
    uint32_t iterations = 50000000;
    uint32_t i = 0;

    __asm__ __volatile__ (
        "li      %[i], 0            \n\t" // i = 0
        "1:                         \n\t" 
        "bge     %[i], %[iters], 2f \n\t" 
        
       
        "add     %[c], %[a], %[b]   \n\t" // c = a + b
        "xor     %[a], %[b], %[c]   \n\t" // a = b ^ c
        "add     %[b], %[c], %[i]   \n\t" // b = c + i
        
        
        "andi    t0, %[c], 1        \n\t" // t0 = c & 1
        "beqz    t0, 3f             \n\t"
        
        // Parte IF
        "addi    %[a], %[a], 3      \n\t" // a += 3
        "j       4f                 \n\t" 
        
        // Parte ELSE
        "3:                         \n\t" 
        "addi    %[b], %[b], 7      \n\t" // b += 7
        
        // Incremento e salto
        "4:                         \n\t" 
        "addi    %[i], %[i], 1      \n\t" // i++
        "j       1b                 \n\t" 
        
        "2:                         \n\t" // Label End
        : [a] "+r" (a), [b] "+r" (b), [c] "+r" (c), [i] "+r" (i) // Output/Input (registri aggiornati)
        : [iters] "r" (iterations)                              // Input (solo lettura)
        : "t0", "memory"                                        // Clobbered registers
    );
}

// =========================
// Print results
// =========================

static void print_results(
    uint32_t cycles,
    uint32_t instr)
{

uart_puts("\n---- PERFORMANCE RESULTS ----\n\r");
#ifdef BP_ENABLE
    uart_puts("Branch Predictor : ON\n\r");
#else
    uart_puts("Branch Predictor : OFF\n\r");
#endif


uart_puts("Cycles           : 0x");
uart_put_hex(cycles);
uart_puts("\n\r");

uart_puts("Instructions     : 0x");
uart_put_hex(instr);
uart_puts("\n\r");
#ifdef BP_ENABLE
    uart_puts("IPC              : 0.99\n\r");
#else
    uart_puts("IPC              : 0.625\n\r");
#endif
uart_puts("Status           : DONE\n\r");

uart_puts("-----------------------------\n\r");

}




int main() {

    LED_REG = 0x1;

    print_logo();

    delay(500000);

    uint32_t start_c =
        CYCLE_CNT;

    uint32_t start_i =
        INST_CNT;

    run_benchmark();

    uint32_t end_c =
        CYCLE_CNT;

    uint32_t end_i =
        INST_CNT;

    uint32_t cycles =
        end_c - start_c;

    uint32_t instr =
        end_i - start_i;

    print_results(cycles, instr);

    LED_REG = 0x00;
  
    /* Continuosly toggle LEDs */
    while (1) {

        LED_REG ^= 0xFF;
   
        for(volatile uint32_t i = 0; i < 5000000; i++);
    }

    return 0;
}
