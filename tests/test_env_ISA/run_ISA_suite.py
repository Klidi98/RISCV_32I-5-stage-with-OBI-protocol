import subprocess
import os
import shutil
import sys

# --- CONFIGURAZIONE PERCORSI (Relativi a test_env_isa) ---
ISA_BIN_DIR = "ISA/bin"
TB_NAME     = "../sim/work.tb_microprocessor" # Esce da test_env_isa e entra in sim
GOLDEN_EXE  = "riscv32i.exe" # È nella stessa cartella dello script
VERIFY_SCRIPT = "verify.py"

tests = ["add", "addi", "and", "andi", "auipc", "blt", "bltu", "bge", "bgeu", "beq", "bne", "jal", "jalr", "lb", "lbu", "lh", "lhu", "lui", "lw", "or", "ori", "sb", "sh", "sll", "slli", "srl", "slt", "slti", "sltiu", "sltu", "srli", "srai", "sra", "sub", "sw", "xor", "xori"]

GREEN = '\033[92m'
RED   = '\033[91m'
BOLD  = '\033[1m'
RESET = '\033[0m'

def run_command(cmd, working_dir="."):
    """Esegue un comando in una cartella specifica (default: corrente)"""
    return subprocess.run(
        cmd, 
        shell=True, 
        capture_output=True, 
        text=True, 
        cwd=working_dir  # <--- Fondamentale per far funzionare 'working_dir'
    )

if not os.path.exists("results"):
    os.makedirs("results")

results_summary = {}

for test in tests:
    test_dir = f"results/{test}"
    os.makedirs(test_dir, exist_ok=True)

    # 1. File per il Simulatore C (Percorsi locali)
    instr_file = f"{ISA_BIN_DIR}/{test}.bin"
    
    if test in ["lb", "lbu"]:   data_file = f"{ISA_BIN_DIR}/lb_data.txt"
    elif test in ["lh", "lhu"]: data_file = f"{ISA_BIN_DIR}/lh_data.txt"
    elif test == "lw":          data_file = f"{ISA_BIN_DIR}/lw_data.txt"
    elif test in ["sb", "sh"]:  data_file = f"{ISA_BIN_DIR}/{test}_data.txt"
    else:                       data_file = "data_mem.txt"

    # Log finale (Percorsi assoluti per non far sbagliare ModelSim)
    ref_log = os.path.abspath(f"{test_dir}/{test}_log_ref.txt")
    rtl_log = f"../test_env_ISA/{test_dir}/{test}_log_rtl.txt"
    mismatch_report = os.path.abspath(f"{test_dir}/{test}_report_mismatch.txt")

    print(f"Esecuzione {test.upper():<6}...", end=" ", flush=True)

    # 2. Lancio Simulatore C
    # Nota: riscv32i.exe deve essere lanciato senza ./ su Windows CMD
    cmd_gold = f"{GOLDEN_EXE} {instr_file} {data_file}"
    res_gold = run_command(cmd_gold)
    
    if res_gold.returncode == 0 and os.path.exists("log_gs.txt"):
        shutil.move("log_gs.txt", ref_log)
    else:
        print(f"{RED}ERR GOLD{RESET}")
        continue

    # 3. Lancio ModelSim
    # Importante: ModelSim viene lanciato da test_env_isa, 
    # quindi deve andare indietro di uno per trovare il testbench in ../sim/
# --- LOGICA PER MODELSIM (Parte da ../sim) ---
    sim_dir = "../sim" # Cartella dove c'è la 'work'
    
    shutil.copy2(instr_file, os.path.join(sim_dir, "main.bin"))
    
    # 2. Copia il file dei dati rinominandolo nel default del VHDL
    shutil.copy2(data_file, os.path.join(sim_dir, "data_mem.txt"))
    
    # 3. Definiamo dove vogliamo che ModelSim scriva il log temporaneo
    # Meglio farlo scrivere in locale a 'sim' e poi spostarlo noi
    temp_rtl_log = os.path.join(sim_dir, "log_rtl.txt")
    if os.path.exists(temp_rtl_log):
        os.remove(temp_rtl_log)

    # 2. Costruiamo il comando con l'ordine CORRETTO:
    # vsim [options] [library.entity] [generics]
# 4. Lancio ModelSim pulito (senza -g, usa i default)
    cmd_vsim = 'vsim -c -do "run -all; quit -f" work.tb_microprocessor'
    
    print(f"(RTL)...", end=" ", flush=True)
    res_vsim = run_command(cmd_vsim, working_dir=sim_dir)
    
  
# 5. Spostiamo il log prodotto nella cartella dei risultati finale
    if os.path.exists(temp_rtl_log):
        shutil.move(temp_rtl_log, rtl_log)
    else:
        # Se non esiste, c'è stato un errore in ModelSim
        print(f"{RED}ERR RTL: Log non generato{RESET}")
        print(res_vsim.stdout)
        continue

    # 4. Verifica
    cmd_verify = f'python "{VERIFY_SCRIPT}" "{ref_log}" "{rtl_log}" "{mismatch_report}"'
    verify_proc = subprocess.run(cmd_verify, shell=True)

    if verify_proc.returncode == 0:
        print(f"{GREEN}PASS ✔{RESET}")
        results_summary[test] = "PASS"
    else:   
        print(f"{RED}FAIL ✘{RESET}")
        results_summary[test] = "FAIL"

# Tabella finale... (omessa per brevità, rimane uguale)