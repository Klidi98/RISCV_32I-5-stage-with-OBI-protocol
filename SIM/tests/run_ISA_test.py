import subprocess

tests = [
    "add"   ,
    "addi"  ,
    "and"   ,
    "andi"  ,
    "auipc" ,
    "blt"   ,
    "bltu"  ,
    "bge"   ,
    "bgeu"  ,
    "beq"   ,
    "bne"   ,
    "jal"   ,
    "jalr"  ,
    "lb"    ,
    "lbu"   ,
    "lh"    ,
    "lhu"   ,
    "lui"   ,
    "lw"    ,
    "or"    ,
    "ori"   ,
    "sb"    ,
    "sh"    ,
    "sll"   ,
    "slli"  ,
    "srl"   ,
    "slt"   ,
    "slti"  ,
    "sltiu" ,
    "sltu"  ,
    "srli"  ,
    "srai"  ,
    "sra"   ,
    "sub"   ,
    "sw"    ,
    "xor"   ,
    "xori"
]
tb_name = "work.tb_microprocessor"
results = {}

def run_command(cmd):
    """Esegue un comando e restituisce l'output"""
    return subprocess.run(cmd, shell=True, capture_output=True, text=True)


for test in tests:
    print(f"Eseguendo il test ISA per l'istruzione: {test}.bin")
    if test == "lb" or test == "lbu" :

        cmd = f'vsim -c -do "run -all; quit -f" -gFILE_INSTR=isa/{test}.bin -gFILE_DATA="isa/lb_data.txt" {tb_name}'
    elif test == "lh" or test == "lhu" :
        cmd = f'vsim -c -do "run -all; quit -f" -gFILE_INSTR=isa/{test}.bin -gFILE_DATA="isa/lh_data.txt" {tb_name}'
    elif test == "lw":
        cmd = f'vsim -c -do "run -all; quit -f" -gFILE_INSTR=isa/{test}.bin -gFILE_DATA="isa/lw_data.txt" {tb_name}'
    elif test == "sb":
        cmd = f'vsim -c -do "run -all; quit -f" -gFILE_INSTR=isa/{test}.bin -gFILE_DATA="isa/sb_data.txt" {tb_name}'
    elif test == "sh":
        cmd = f'vsim -c -do "run -all; quit -f" -gFILE_INSTR=isa/{test}.bin -gFILE_DATA="isa/sh_data.txt" {tb_name}'
    else:
        cmd = f'vsim -c -do "run -all; quit -f" -gFILE_INSTR=isa/{test}.bin -gFILE_DATA=isa/"data.txt" {tb_name}'
        
        
    sim_result = run_command(cmd)
    
    GREEN = '\033[92m'
    RED = '\033[91m'
    RESET = '\033[0m'
    CHECK = '✔'
    CROSS = '✘'

    if "RESULT: PASS" in sim_result.stdout:
        # Stampa: Test nome.bin PASSED ✔ (in verde)
        print(f"Test {test}.bin {GREEN}PASSED {CHECK}{RESET}")
        results[test] = "PASS"
    else:
        # Stampa: Test nome.bin FAILED ✘ (in rosso)
        print(f"Test {test}.bin {RED}FAILED {CROSS}{RESET}")

        results[test] = "FAIL"
  #      with open(f"log_{test}.txt", "w") as f:
  #              f.write(sim_result.stdout)
        print("Output della simulazione:")
        print(sim_result.stdout)
        
#RISULTATO FINALE SIMULAZIONE
print("\n" + "="*30)
print(f"{'TEST':<10} | {'STATO'}")
print("-" * 30)
for t, r in results.items():
    if r == "PASS":
        # Stampa il nome del test, "PASS" in verde 
        print(f"{t:<15} | {GREEN}PASS {CHECK}{RESET}")
    else:
        # Stampa il nome del test, "FAIL" in rosso 
        print(f"{t:<15} | {RED}FAIL {CROSS}{RESET}")

print("="*35)

