## Branch Impact IPC Test

This program evaluates the impact of branch instructions on pipeline performance.

It executes a loop containing a small number of instructions (approximately four per iteration) with a branch at the end of each iteration. Due to the branch being taken repeatedly, multiple instructions are flushed from the pipeline on every iteration.

The program:

- Measures total cycle count (`CYCLE_CNT`)
- Measures total committed instructions (`INST_CNT`)
- Prints both values
- Allows IPC to be computed as:

IPC = commited_instructions/total_cycles


### Expected Behavior

Since each taken branch causes approximately 4 instructions to be flushed, and the loop body itself contains only a few instructions, the branch penalty dominates execution time.

As a result, the expected IPC is approximately: 0.5

The below image shows the results printed by the program as hexadeciaml values allowing to calculate real IPC:
<img width="511" height="248" alt="Screenshot 2026-03-01 202921" src="https://github.com/user-attachments/assets/638bb321-c780-40ad-bbe4-4cede09bf235" />

IPC = 0.5
