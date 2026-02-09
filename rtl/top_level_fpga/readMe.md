Microprocessor_v1 is the top level in which the core has been integrated in order to use the Tx Uart and LEds as GPIOs. For simplicity the address range given to each peripheral is the sequent:
-    Data memory : 0x1001000 to 0x1001100
-    LED register: 0x1001000 -> 4 bytes -> only 8 bits used since 8 LEDs available
-    UART Tx Register: 0x1001200 -> 4 bytes --> 8 bits of data, 1 of 'wr_en', 1 of busy/ready