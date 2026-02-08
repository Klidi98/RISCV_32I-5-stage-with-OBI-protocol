Two types of testbenches have been developed:

- `tb_fpga_core`, aimed at debugging the FPGA-synthesis version of the microprocessor, where also the GPIOs(UART and LED) are defined.

- `tb_microprocessor`, specifically designed for ISA verification.  
  It automatically evaluates pass/fail outcomes of the ISA tests and is also used to debug standalone programs included in the `tests` folder.
  To use this tesbench have to be defined as parameters the names of the file containing the instructions to be written in hexadecimal format(by default called main.bin) and the name of file containg the initiliased data for data memory (by default data_mem.txt). 
  The first fiel should also contain in the first line the number of the total instructions in IM e total data in DM, which are needed by the program loader to correctly load the memories at the beginning of the execution. 
