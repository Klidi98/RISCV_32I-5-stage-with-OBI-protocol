# Fetcher Timing Diagrams

## Burst access
<img width="1400" height="346" alt="fetch_burst" src="https://github.com/user-attachments/assets/b593436f-3fab-48ff-86d5-4422a47ad1b9" />

If Instruction memory is always 'ready' and single cycles access the core can fetch an instruction per cycle. This is handled by the request handler FSM which is composed of the following states:
-   idle: when resetted the fetcher starts in idle and passes to start_req in the following cycle.
-   START_REQ: in this state the request signal toward the instruction memory is activated. Both ready and request high cause the next state to follow.
-   ISSUE_NEXT: This is the state that allows burst access. If valid is high, the request signal is activated in the same cycle in order to not loose any cycles without fetching, and allowing for a burst access(always considering ready high).

---

## Fetching with random valid delay

<img width="1420" height="346" alt="obi_fetch_delay_valid" src="https://github.com/user-attachments/assets/35aa82ae-6e12-4825-9b55-e9527d3f8e1b" />

This diagram represents the case in which memory is always ready but might require different cycles. 
The 'stall' signal represents a stall of the pipe generated externally from the fetcher, as for example from a data memory access in the MEM stage.
As in the previous case the arrival of the valid acts as enable of the program counter register.  

---
## Fetching with random ready 

<img width="1420" height="436" alt="obi_fetch_not_ready" src="https://github.com/user-attachments/assets/633155d0-e54a-4a8c-b34d-ecf287d555c5" />

This represents how a random active ready signal coming from the memory is handled by the FSM.
-   START_REQ : this state waits until ready is high before passing to next state.
-   ISSUE_NEXT: if during the arrival of a valid signal 'ready' is not high a new request can't be done in this state and the FSM returns to start_req waiting for a new 'ready'.

## Fetching during stall pipeline
<img width="1440" height="466" alt="stalling fetch" src="https://github.com/user-attachments/assets/966502fa-3b6c-4108-9d46-1dbaf5e1d382" />


Pipeline stalls can generate two different behaviors in the fetcher, depending on the current FSM state:
- **START_REQ**:  
  If a stall is asserted in this state, the request signal is forced low and remains deasserted until the stall condition is released. No new memory requests are issued during this phase.
- **ISSUE_NEXT**:  
  If a stall occurs in this state while a valid response is received from memory, the FSM transitions back to **START_REQ**, to wait for the stall signal to end and restart a new request.
  Since the pipe is stalled a new instruction coming from previous requests cannot be sampled, so it's saved in a buffer, which will be immediatly sampled once the pipe restarts.


