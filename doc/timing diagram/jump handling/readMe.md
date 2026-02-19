## Jump / Branch Handling

For simplicity and to reduce the critical path in the EX stage, jump decisions are resolved in the **MEM stage**.  
In the best-case scenario (single-cycle memory access with always-ready memory), a taken jump introduces a **4-cycle penalty**, as shown in the timing diagram.

When a jump is taken, the `jump` signal is asserted in the MEM stage.  
This immediately triggers a `flush` signal for the **ID, EX**, removing all younger instructions that must not commit their effects.

The `flush` signal remains asserted until a valid instruction is returned by the instruction memory (first active valid signal after jump address has been sampled), meaning the jump target instruction has been fetched and can safely enter the pipeline. 

During a jump, the fetch stage may be stalled while waiting for a valid or ready signal.  
To guarantee that the target address is correctly sampled by the PC, the MEM stage is stalled until the PC enable signal is asserted(sampling address target), after which also the mem stage is flushed and normal execution resumes.  
