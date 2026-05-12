# DATA MEMORY ACCESS TIMING DIAGRAM
<img width="1040" height="482" alt="data_memory_access" src="https://github.com/user-attachments/assets/02765784-8530-42b3-ba27-48ad40a55453" />

Memory Access FSM Logic

During a memory access instruction (Load or Store), the Control Unit asserts the data memory request signal (ctr_request). The FSM manages the transaction and pipeline flow as follows:

State Transition (IDLE → W_VALID): When ctr_request is sampled high alongside the ready signal (indicating the Memory is prepared to accept the request), the FSM transitions from the IDLE state to the W_VALID (Wait Valid) state. This allows for the request_dm signal to be high exactly one cycle for access.
Pipeline Stall: While in the W_VALID state,  the pipeline is stalled. The system waits for the valid signal from the Data Memory (DM).

Transaction Completion: The valid signal indicates that the requested data has been successfully loaded or stored. Upon receiving valid:

    The pipeline stall is deasserted.
    The FSM returns to the IDLE state.
    The next instruction is sampled, and the pipeline resumes normal operation.


The timing diagram illustrates two subsequent memory access instructions, I4 and I5:

    I4 Execution: Shows the initial handshake where ctr_request and ready are both active, moving the FSM into the W_VALID state.

    I5 Sampling: Instruction I5 is sampled only after the valid signal for I4 is received, bringing the FSM back to IDLE and allowing the next memory transaction to begin.
