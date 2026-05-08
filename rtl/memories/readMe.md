##Memories

This folder contains the memory models used both for simulation and FPGA synthesis.  
They differ mainly in access latency and in the behavior of the `ready` and `valid` signals, allowing comprehensive verification of the OBI protocol.

The "rom" memories are intended for FPGA synthesis, where a program loader is not yet available.  
As a result, the instruction memory must be generated with the program preloaded.

The various "rom" implementations only differ in their initialized contents. Each of them contains a different testing program.
