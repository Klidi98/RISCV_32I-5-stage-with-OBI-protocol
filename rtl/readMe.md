## RTL folder
This directory contains all the VHDL source files implementing the RISC-V core, and the top level microprocessor to be synthesized on FPGA.

The top-level entity of the core is **core_riscv32i.vhd**. 


## Top_level_fpga:
This folder contains the top level microprocessor integrating the core with the PLL and all the peripherals(as memories, GPIOs and TX UART) integrated that will be synthesized on the FPGA.

