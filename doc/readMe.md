## Documentation Folder

This folder contains the block and timing diagrams that detail the technical behavior and microarchitecture of the RISC-V core.

### Top-Level Block Diagram

The top-level view of the core exposes the following interface ports, compliant with the Open Bus Interface (OBI) protocol for memory and peripheral access:

#### Global Signals
- `CLK`: System clock input (active on rising edge).
- `RST`: Asynchronous active-low reset signal.

#### Instruction Memory Interface (OBI Protocol)
- `request_im`: OBI request signal to initiate an instruction fetch.
- `addr_im_32_o`: 32-bit address bus targeting the instruction memory.
- `INSTR_32_i`: 32-bit instruction data bus returning from memory.
- `ready_im`: OBI ready signal from instruction memory (address phase accepted).
- `valid_im`: OBI valid signal from instruction memory (data phase valid).

#### Data Memory & Peripherals Interface (OBI Protocol)
- `request_dm`: OBI request signal to initiate a load/store access.
- `wren_dm`: Write enable signal (`1` for write operations, `0` for read operations).
- `addr_dm_32_o`: 32-bit address bus targeting data memory or external peripherals.
- `be_dm_4_o`: Byte enable lines (4-bit) indicating which bytes are valid during sub-word accesses (byte/half-word).
- `DATA_32_o`: 32-bit write data bus sending data to memory/peripherals.
- `DATA_32_i`: 32-bit read data bus returning from memory/peripherals.
- `ready_dm`: OBI ready signal from data memory/peripheral (address phase accepted).
- `valid_dm`: OBI valid signal from data memory/peripheral (data phase valid).

#### Verification & Status Signals
- `committed_instruction`: Hardware strobe indicating that an instruction has successfully retired/completed execution.

<img width="767" height="471" alt="top_level_block_diagram" src="https://github.com/user-attachments/assets/f1907df9-d992-45f5-8169-9b1ba85f4537" />


---

### Detailed Microarchitectural Block Diagram

Below is a detailed block diagram of the core's internal microarchitecture, highlighting the pipeline stages (Fetch, Decode, Execute, Memory, and Writeback). Although this diagram aims to be as specific and comprehensive as possible, certain interconnections have been omitted to maintain visual clarity. For the precise behavior of these signals, please refer directly to the RTL source code.

<img width="3078" height="1525" alt="cpu" src="https://github.com/user-attachments/assets/9bd28f1a-a743-4646-9bb5-55e175e8124e" />


