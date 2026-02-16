# Fetcher Timing Diagrams

## Burst access


If Instruction memory is always 'ready' and single cycles access the core can fetch an instruction per cycle. This is handled by the request handler FSM which is composed of the following states:
-   idle: when resetted the fetcher starts in idle and passes to start_req in the following cycle.
-   start_req: in this state the request signal toward the instruction memory is activated. Both ready and request high cause the next state to follow.
-   issue_next: This is the state that allows burst access. If valid is high, the request signal is activated in the same cycle in order to not loose any cycles without fetching, and allowing for a burst access(always considering ready high).

---

## Fetching with random valid delay


This diagram represents the case in which memory is always ready but might require different cycles. 
The 'stall' signal represents a stall of the pipe generated externally from the fetcher, as for example from a data memory access in the MEM stage.
As in the previous case the arrival of the valid acts as enable of the program counter register.  

---
## Fetching with random ready 


This represents how a random active ready signal coming from the memory is handled by the FSM.
-   start_req : this state waits until ready is high before passing to next state.
-   issue_next: if during the arrival of a valid signal 'ready' is not high a new request can't be done in this state and the FSM returns to start_req waiting for a new 'ready'.

## Fetching during stall 


The stalling of the pipe can generate two different events in the fetcher dependingon on which state this latter is:
-   start_req: if 'stall' is active during this state, the request signal is maintained low untill the end of 'stall'
-   ISSUE_NEXT: if a stall happens during this state, during also the arrival of a valid signal from memory, the FSM returns to start_req.
