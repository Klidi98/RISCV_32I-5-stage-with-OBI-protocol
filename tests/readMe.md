## Simulation

For simulation purposes, the core is provided with a program loader that allows direct loading of:
- instruction memory from a compiled binary
- data memory from an external data file

This approach allows to speeds up testing and iteration.

To run the simulation all the .vhd files in this folder, the ones in the 'rtl' folder and the .vhd of memories should be added to the project.
- Two top level are present here:
  - micro_cpu_obi: which uses random access memories as instruction and data memory in order to better simulate and test OBI protocol
  - micro_cpu_instant: In this case are used single cycle access memoriesas IM and DM.
  A single testbench file where one of these two top level can be defined, just by changing the name of the component.

The core has been verified using:
- the official RISC-V ISA compliance tests (located in `tests/isa`) 
  - A Python script has been defined to run all tests consecutively and report the results.

- several standalone programs, including:
  - quicksort algorithm
  - recursive test programs
  - additional custom tests

Each test folder contains:
- the original C source code
- the compiled executable binary
- scripts used to compile the program and extract instruction and data memories
- simulation result screenshots for functional verification