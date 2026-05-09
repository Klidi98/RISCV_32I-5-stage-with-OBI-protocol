Two types of testbenches have been developed:

- `tb_fpga_core`, aimed at debugging the FPGA-synthesis version of the microprocessor, where also the GPIOs(UART and LED) are defined.

- `random_memory.sv`, specifically designed for ISA verification.  
  It automatically evaluates pass/fail outcomes of the ISA tests and is also used to debug standalone programs included in the `tests` folder.
  The simulation runs untill register_3 of register file is written with the value '1'( as required by ISA_TEST_VERIFICATION). The simulation also ends if it lasts more than 150 us.
  The tb intergates two memories(code and data), written in system verilog that generates random ready and valid signals for simulating OBI protocol with random delay access memory.
  To use this tesbench have to be defined as parameters the names of the file containing the instructions to be written in hexadecimal format(by default called main.bin) and the name of file containg the initiliased data for data memory (by default data_mem.txt). 

