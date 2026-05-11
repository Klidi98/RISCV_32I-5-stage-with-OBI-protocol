# RISC-V ISA Testing Environment (RV32I)

This environment is designed to verify the architectural compliance of my RISC-V core using the official ISA test suite. A key focus of this setup is stress-testing the **OBI (Open Bus Interface)** protocol under various memory pressure conditions.

## 📂 Project Structure

### `isa/`
Contains the official RISC-V ISA executables. 
- Source files and pre-compiled binaries are stored here.
- The testbench sequentially loads these binaries into the core for execution.

### `results/`
Stores the simulation outputs. To validate the robustness of the OBI handshake, tests are run across three different memory latency profiles:
* **`lat_0`**: Zero-latency memory (single-cycle access). The "ideal" scenario.
* **`lat_1`**: Light memory delays affecting `ready` and `valid` signals.
* **`lat_2`**: Extreme memory delays to stress-test pipeline stalls and backpressure.

> **Note**: These delays are not fixed; they are generated using a **SystemVerilog random constraint module** to simulate unpredictable memory behavior.

---

## 🛠️ Verification Workflow

The environment uses a **Golden Reference** comparison strategy to ensure the RTL behaves exactly like the RISC-V specification:

1.  **Reference Generation**: I use `riscv32i.exe` (written by me) as the Golden Model. It executes the test binary and generates a report of exactly what *should* happen(PC, instructions, registers, etc.).
2.  **Simulation**: The RTL testbench simulates the core and generates its own execution report.
3.  **Comparison (`verify.py`)**: This script compares the Golden Model report against the simulation report line-by-line.
4.  **Debugging**: If a discrepancy is found, it creates a `mismatch_report` file. It lists the error type and the exact line number, making it much easier to track down tricky bugs in the pipeline logic.

---

## 🚀 Automation & Regression

### `run_ISA_suite_sv.py`
This script handles all the "heavy lifting" for regression testing:
* **Batch Execution**: Automatically iterates through every test in the `isa/` folder.
* **Recursive Testing**: Launches the full suite for all three latency profiles (`lat_0`, `lat_1`, `lat_2`).
* **Summary**: Provides a clear **PASS** or **FAIL** status for each test, ensuring that new code changes haven't introduced regressions.