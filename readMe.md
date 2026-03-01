# RISCV32I Core (5-stage Pipeline, OBI Interface)

A 5-stage RV32I RISC-V core with Harvard architecture and Open Bus Interface (OBI), synthesized on **Intel Cyclone 10 LP FPGA**.

The core implements a classic **IF–ID–EX–MEM–WB pipeline**, supports **37 RV32I instructions** (currently excluding `FENCE`, `ECALL`, and `EBREAK`), and communicates with instruction/data memory and peripherals through the **OBI handshake protocol**.

---

## ✨ Key Features

- 5-stage pipelined RISC-V RV32I core (Harvard architecture)
- OBI-based memory and peripheral interface (ready/valid handshake)
- Forwarding unit and hazard detection unit implemented
- Synthesized and tested on FPGA @ **90 MHz**
- Passed **official RISC-V ISA compliance tests** and custom stress tests
- Integrated **GPIO (LEDs)** and **UART** for on-board validation and runtime debugging

---

## 🧠 Pipeline & Hazard Handling

A forwarding unit and a hazard detection unit are implemented.

Assuming a single-cycle always-ready memory:
- The pipeline stalls for **load and store instructions**, which require at least two cycles depending on memory latency.
- **Load-use hazards** introduce a one-cycle stall.

---

## 🔗 OBI Protocol Overview
 
The core does not assume any fixed memory latency and interfaces with memory using the **Open Bus Interface (OBI)** handshake protocol.  
The protocol supports **back-to-back transactions** and achieves maximum throughput when `ready` and `valid` are continuously asserted.

### Core → Memory signals
- `request`: Must stay high for one cycle together with `mem_rdy` to be accepted
- `addr`: Address bus sent together with request
- `wdata`: Data to be written in memory, sent together with request
- `we`: Write enable, sent together with request

### Memory → Core signals
- `mem_rdy`: Indicates the request has been accepted; address/data may change next cycle
- `rdata`: Read data, valid only when `valid` is high
- `valid`: Signals completion of read/write transac b tion; for reads, `rdata` is valid when `valid=1`

---

## 🧪 Verification

- RISC-V official ISA compliance tests (`riscv-tests`)
- Custom stress tests targeting:
  - pipeline hazards
  - OBI latency variation
  - back-to-back memory transactions
- Full simulation environment with program loader for instruction and data memory
- Performance test calculating IPC.
- Video demonstration on FPGA.

---

## 🚧 In Progress

- Additional test programs
- Moving branch decision in exe stage.

---

## 🧩 Planned Next Steps

- Move branch decision in exe_stage
- Implement branch prediction to increase IPC
- Program loader for FPGA (instruction/data memory loading at runtime).



