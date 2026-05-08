Microprocessor_v1 is the top level in which the core has been integrated with a instruction memory, data memory, a Transmitter UART and LED GPIOs, a cycle counter and a committed instruction counter. All these peripheral are mapped to address ranges thorugh a dedicated decoder and they all respond with OBI protocol as required by the core.
For simplicity the address range given to each peripheral is the sequent:
-    Instruction memory : 0x100
-    Data memory : 0x10001000 to 0x10011000
-    LED register: 0x10010000 -> 4 bytes    --> only 8 bits used since 8 LEDs available
-    UART Tx Register: 0x1001200 -> 4 bytes --> 8 bits of data, 1 of 'wr_en', 1 of busy/ready
-    cycle counter register   : 0x          --> 32 bits -> 8 bytes of data
-    commit instruction counter : 0x        --> 32 bits