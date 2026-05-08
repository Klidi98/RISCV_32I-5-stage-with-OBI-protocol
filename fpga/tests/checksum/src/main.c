
//Program that tests the memory accesses by ordering data and by using a checksum 
//to check if corrupted data.
//Loaded in rom5.vhd

#define LED_ADDR 0x10011000
#define MEM_BASE 0x10010000
#define DATA_SIZE 16

void delay(int cycles) {
    for (volatile int i = 0; i < cycles; i++);
}

int main() {
    volatile unsigned int *leds = (unsigned int *)LED_ADDR;
    unsigned int *data = (unsigned int *)MEM_BASE;
    unsigned int checksum;

    while (1) {
        // Inizializzazione: Riempie la memoria con dati decrescenti
        for (int i = 0; i < DATA_SIZE; i++) {
            data[i] = DATA_SIZE - i;
        }
        *leds = 0x01; // Fase 1: Inizializzazione (LED 0 acceso)
        delay(200000);

        //bubble sort riordino
        for (int i = 0; i < DATA_SIZE - 1; i++) {
            for (int j = 0; j < DATA_SIZE - i - 1; j++) {
                if (data[j] > data[j+1]) {
               
                    unsigned int temp = data[j];
                    data[j] = data[j+1];
                    data[j+1] = temp;
                }
            }
            //  progresso dell'ordinamento sui LED
            *leds = (1 << i); 
            delay(1000000);
        }

        // Calcolo del Checksum per l'integrità dei dati
        checksum = 0;
        for (int i = 0; i < DATA_SIZE; i++) {
            checksum += data[i];
        }

       
        // Se l'ordinamento è corretto, la somma di 1..16 è 136 (0x88)
        if (checksum == 136) {
            // Successo: Lampeggia tutti i LED 3 volte
            for(int k = 0; k < 3; k++) {
                *leds = 0xFF; delay(1000000);
                *leds = 0x00; delay(1000000);
            }
        } else {
            // Errore di Memoria/Timing: LED alternati (Pattern di errore)
            *leds = 0xAA; 
            while(1); // Si blocca per farti vedere l'errore
        }
    }
}
