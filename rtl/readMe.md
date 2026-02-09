This directory contains all the VHDL source files implementing the RISC-V core, and the top level microprocessor.

The top-level entity of the core is 'core_riscv32I'.

## top_level_sim:
For simulation purposes, the core is provided with a program loader that allows direct loading of:
- instruction memory from a compiled binary
- data memory from an external data file
This approach allows to speeds up testing and iteration.

## top_level_fpga:
This folder contains the top level microprocessor intgrating the core with the PLL and the GPIOs used for testing. 

