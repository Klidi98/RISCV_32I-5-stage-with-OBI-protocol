##RISCV32I 

5-stage RV32I RISC-V core with OBI interface, synthesized on Intel Cyclone 10 LP, with Harvard Architecture
The core implements a classic IF–ID–EX–MEM–WB pipeline, supports 37 instructions of the RV32I ISA( excluding for now CSR, ECALL and FENCE) and communicates with instruction/data memory and peripherals through the Open Bus Interface (OBI).

In the design have been implemented the forwarding unit and the hazard detection unit. 
Considering an always 'ready' single cycle access memory the pipe is stalled only for load or store instructions, which require at least two cycles to conclude, depending on the speed of the memory and during a load word hazard, where the pipe is stalled for one cycle.

The design has been synthesized and tested on FPGA at 90 MHz, passing official riscv-tests and custom stress tests targeting pipeline hazards and OBI transactions.

GPIO (LEDs) and UART peripherals are integrated in the microprocessor architecture for on-board validation and runtime debugging.


##OBI protocol:
The core doesn't make any assumptions on how many cycles the memory will take to respond and interfaces with it with he following signals.
The core assumes the valid and ready signals to be synchornous and that the memory can sample the request signal.
The protocol supports back-to-back transactions and allows maximum memory throughput when `ready` and `valid` are asserted without introducing unnecessary stalls( memory always ready and one access cycle delay).

**core to memory signals**
   -request: has to stay high one cycle with ready signal in order to be accepted by memory
   -addr   : address sent together with request
   -wdata  : Data to be written in memory, sent together with request
   -we     : write enable, sent together with request

**memory to core signal**
   -mem_rdy: Ready signal; it states that the request has been accepted. Address and data can change in the next cycle.
   -rdata  : Data read from memory: only valid when valid signal is high.
   -valid  : It signals the end of the response phase for both read and write transactions. For a read transaction rdata holds valid data when valid is high.
   

In progress:
- more testing programs
- add remaining instructions (FENCE, ECALL, EBREAK) completing ISA

PLANNING next:
-exception handler
-program Loader for FPGA
