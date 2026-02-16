# DATA MEMORY ACCESS TIMING DIAGRAM
<img width="1040" height="482" alt="data_memory_access" src="https://github.com/user-attachments/assets/02765784-8530-42b3-ba27-48ad40a55453" />

During a memory access instruction (load or store) the request data memory signal (ctr_request) coming from the control unit is active. When this signal is sampled active the FSM passes from state 'idle' to 'w_valid'.
In this new state the FSM waits for the valid signal coming from the DM and the pipe is stalled. 'valid' indicates that the requested data has been loaded ( or stored) and the pipe can start again and new instruction is sampled. FSM goes again in idle until a new memory access instruction is sampled.

In the timing diagram I4 and I5 represent two subsequent instructions that access data memory.
