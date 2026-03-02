# IPC Performance Test Summary

This project includes three IPC-oriented tests to validate both correctness and performance of the core.

---

## 1. Retire Logic Validation (`retired_valid`)

**Goal**  
Ensure `INST_CNT` increments exactly once per retired instruction.

**Method**
- Execute a loop with a mathematically known instruction count.
- Snapshot `INST_CNT` before and after execution.
- Compare measured delta with expected value.

**Validates**
- Correct `instruction_commited` behavior  
- No double counting  
- No lost instructions  
- Proper retirement of branches and jumps  

---

## 2. High-IPC ALU Stress Test

**Goal**  
Measure near-maximum achievable IPC.

**Structure**
- Fully assembly-based loop  
- ~100 ALU operations per iteration  
- 1 loop branch per ~100 instructions  
- No memory accesses  

**Purpose**
- Stress forwarding paths  
- Evaluate branch penalty impact  
- Measure peak pipeline efficiency  

**Expected IPC:** close to 1.0.

---

## 3. Low-IPC Realistic Loop

**Goal**  
Measure IPC under non-ideal conditions.

**Structure**
- More Frequent branches   

**Purpose**
- Observe load-use stalls  
- Measure branch penalties  
- Evaluate realistic pipeline behavior  

---

Together, these tests validate architectural correctness and performance across both ideal and realistic workloads.
