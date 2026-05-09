
# RISCV32I Core (5-stage Pipeline, OBI Interface)

A 5-stage RV32I RISC-V core with Harvard architecture and Open Bus Interface (OBI),with full forwarding unit and 2-bit dynamic branch predictor, synthesized on **Intel Cyclone 10 LP FPGA**.

The core implements a classic **IF–ID–EX–MEM–WB pipeline**, supports **37 RV32I instructions** (currently excluding `FENCE`, `ECALL`, and `EBREAK`), and communicates with instruction/data memory and peripherals through the **OBI handshake protocol**.

<img width="1501" height="800" alt="top_level" src="https://github.com/user-attachments/assets/6effc4f8-ad76-4eee-9d31-c3aa7d49ac63" />

---

## ✨ Key Features

- 5-stage pipelined RISC-V RV32I core (Harvard architecture)
- OBI-based memory and peripheral interface (ready/valid handshake)
- Full forwarding unit and hazard detection implemented.
- Branch decision in execution stage.
- 2 bit dynamic branch predictor
- ISA test environment with risc_v core golden model written C for rapid and complete ISA instruction verification.
- Synthesized and tested on FPGA @ **60 MHz**
- Passed **official RISC-V ISA compliance tests** and custom stress tests with randomic memory delays.
- Integrated **GPIO (LEDs)** and **UART** for on-board validation and runtime debugging
- Performance Tests for calculating IPC and comparing results with and without branch predictor

---

## 🧠 Pipeline & Hazard Handling

A full forwarding unit and a hazard detection unit are implemented.

Considering a single-cycle access always-ready memory:
- The pipeline stalls for **load and store instructions**, which require at least two cycles depending on memory latency.
- **Load-use hazards** introduce one-cycle stall.

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
- `ready`: Indicates the request has been accepted; address/data may change next cycle
- `rdata`: Read data, valid only when `valid` is high
- `valid`: Signals completion of read/write transac b tion; for reads, `rdata` is valid when `valid=1`

---

## 🔀 Branch Predictor

- 2-bit dynamic branch predictor  
- 32-entry prediction table (parameterizable)  
- Branch decision moved to EX stage to reduce penalty  
- IPC improvement evaluated with dedicated benchmarks  


## 🧪 Verification

A complete automated verification flow has been developed to validate the processor functionality and robustness.

- **37 RISC-V official ISA tests** (`riscv-tests`) executed  
- Reference **RV32I model written in C** used as golden model  
- RTL and reference execution logs compared **instruction-by-instruction**  
- Python-based comparison tool generates automatic **PASS/FAIL reports**  
- Automated regression script runs all tests sequentially  

### Randomized Memory Stress Testing

A SystemVerilog random memory model is used to validate the OBI interface under variable latency.

Each test is executed in **three different memory conditions** with automated script:

1. **Full-speed** → memory always ready and single cycle access 
2. **Light delay** → small random latency  
3. **Stress delay** → larger random latency  

This ensures correct operation under realistic and worst-case timing scenarios.

### Additional Validation

- Custom stress tests for:
  - pipeline hazards  
  - forwarding logic  
  - branch handling  
  - back-to-back memory transactions  
- IPC measurement using cycle and instruction counters  
- FPGA validation using LEDs and UART output

## 🎬 Demonstration and Performance Evaluation

Performance has been measured using:
- hardware cycle counter
- instruction commit counter
- same benchmark executed on both configurations with branch predictor ON and OFF

IPC computed offline.

## 🚫 Branch Predictor: OFF

<p align="center">
  <img width="900" height="400" alt="Branch Predictor Disabled Demo" src="https://github.com/user-attachments/assets/d0166eb0-7a4b-47d3-aad8-b73e26728201" />
</p>

> **Technical Status:** Branch predictor disabled. 
> In this configuration, `bp_update` signal is forced to `0` during HW recompilation.

---

## ✅ Branch Predictor: ON

<p align="center">
  <img width="900" height="400" alt="Branch Predictor Enabled Demo" src="https://github.com/user-attachments/assets/166673dc-5b9d-42a8-ae2e-caf163312f9b" />
</p>

> **Technical Status:** Branch predictor enabled. 
> With the branch prediction unit enabled, performance increases drastically. The IPC (Instructions Per Cycle) scales nearly to 1 for subsequent test programs, minimizing branch penalties.

> [!TIP]
> The demo software executed by the core in these animations can be found in the following directory:
> [`tests/sw_presentation/src`](tests/presentation_sw/src)

---





