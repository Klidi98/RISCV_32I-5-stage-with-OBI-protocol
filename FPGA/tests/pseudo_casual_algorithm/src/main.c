/* The goal of this firmware is to create a dynamic shimmering visual effect
on an 8-LED array by simulating variable brightness through Software PWM.
If anything goes wrong in the pipe causing it to stall, the LEDs would stack on a single pattern.
Loaded in rom3.vhd
*/

#define LED_ADDR 0x10011000
#define VOLATILE_REG(addr) (*(volatile unsigned int *)(addr))

void delay(int count) {
    for (volatile int i = 0; i < count; i++);
}

int main() {
    // Stato iniziale del LFSR (non deve mai essere zero)
    unsigned int lfsr = 0xACE1u; 
    unsigned int bit;
    unsigned int led_values[8] = {0}; // Luminosità per ogni LED (0-255)
    
    int pwm_counter = 0;

    while (1) {
        // Generazione Numero Pseudo-Casuale (Galois LFSR a 16-bit)
        bit  = ((lfsr >> 0) ^ (lfsr >> 2) ^ (lfsr >> 3) ^ (lfsr >> 5)) & 1;
        lfsr = (lfsr >> 1) | (bit << 15);

        //  Aggiorna la luminosità target dei LED ogni X cicli
        if ((pwm_counter & 0xFFF) == 0) {
            for(int i = 0; i < 8; i++) {
                // Prendi un byte dal registro LFSR per ogni LED
                led_values[i] = (lfsr >> (i % 2)) & 0xFF; 
            }
        }

        // PWM Software per controllare la luminosità
        unsigned int current_out = 0;
        int duty_cycle = (pwm_counter & 0xFF); // Ciclo da 0 a 255

        for(int i = 0; i < 8; i++) {
            if (led_values[i] > duty_cycle) {
                current_out |= (1 << i);
            }
        }

     
        VOLATILE_REG(LED_ADDR) = current_out;

        pwm_counter++;
    }

    return 0;
}