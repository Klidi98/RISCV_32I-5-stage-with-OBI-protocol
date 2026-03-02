# Simplified Block Diagram of the RISCV32I OBI core
![block_diagram_core](https://github.com/user-attachments/assets/41812ae9-5a3a-4f1e-a40b-f9b70336514a)

The block diagram illustrates the five-stage pipeline, with stages separated by dedicated pipeline registers.

-    Core Logic: The components within the white rectangle represent the core's internal architecture and interconnections.

-    Simulation Environment: Blocks outside the white rectangle comprise the Program Loader, utilized exclusively for simulation.

-    Scope: This is a detailed yet simplified view; FPGA-specific peripherals—such as GPIOs, address decoders, and the UART Tx module—are omitted for clarity.
