import re
import sys # Necessario per exit e argv

def parse_gs_line(line):
    # Formato GS: pc | instr | op | dr | reg_data | addr_mem | data_mem | cyc
    parts = [p.strip() for p in line.split('|')]
    if len(parts) < 7 or "PC" in parts[0]:
        return None
    
    # Pulizia mem_data (rimuove il numero del ciclo finale)
    mem_data_clean = parts[6].split()[0] if parts[6] else "00000000"
    
    return {
        'pc':       parts[0].replace("0x", "").lower().zfill(8),
        'instr':    parts[1].replace("0x", "").lower().zfill(8),
        'op':       parts[2].upper(),
        'dr_idx':   int(parts[3]) if parts[3].isdigit() else 0,
        'reg_data': parts[4].lower().zfill(8),
        'mem_addr': parts[5].lower().zfill(8),
        'mem_data': mem_data_clean.lower().zfill(8)
    }

def parse_rtl_line(line):
    # Formato RTL: pc;instr;reg_idx;reg_data;mem_addr;mem_data; @time
    parts = [p.strip() for p in line.split(';')]
    if len(parts) < 6:
        return None

    return {
        'pc':       parts[0].lower().zfill(8),
        'instr':    parts[1].lower().zfill(8),
        'dr_idx':   int(parts[2]) if parts[2].isdigit() else 0,
        'reg_data': parts[3].lower().zfill(8),
        'mem_addr': parts[4].lower().zfill(8),
        'mem_data': parts[5].lower().zfill(8)
    }

def compare_logs(gs_path, rtl_path, report_path):
    with open(gs_path, 'r') as f_gs, open(rtl_path, 'r') as f_rtl, open(report_path, 'w') as f_rep:
        gs_data = [parse_gs_line(l) for l in f_gs.readlines() if parse_gs_line(l)]
        rtl_data = [parse_rtl_line(l) for l in f_rtl.readlines() if parse_rtl_line(l)]
        
        f_rep.write("=== REPORT DI VERIFICA RISC-V ===\n")
        f_rep.write(f"Istruzioni totali: GS={len(gs_data)} | RTL={len(rtl_data)}\n")
        f_rep.write("-" * 70 + "\n\n")
        
        mismatches = 0
        limit = min(len(gs_data), len(rtl_data))

        for i in range(limit):
            gs = gs_data[i]
            rtl = rtl_data[i]
            errors = []

            # 1. Controllo PC
            if gs['pc'] != rtl['pc']:
                errors.append(f"PC MISMATCH: GS_PC={gs['pc']} != RTL_PC={rtl['pc']}")

            # 2. Controllo Istruzione Hex
            if gs['instr'] != rtl['instr']:
                errors.append(f"INSTR HEX: GS={gs['instr']} vs RTL={rtl['instr']}")

            # 3. Controllo Registri (escludendo Store e Branch)
            is_store = gs['op'] in ["SB", "SH", "SW"]
            is_branch = gs['op'] in ["BEQ", "BNE", "BLT", "BGE", "BLTU", "BGEU"]
            
            if not is_store and not is_branch:
                if gs['reg_data'] != rtl['reg_data']:
                    errors.append(f"REG DATA: x{gs['dr_idx']} -> GS={gs['reg_data']} vs RTL={rtl['reg_data']}")

            # 4. Controllo Memoria (solo Store)
            if is_store:
                if gs['mem_addr'] != rtl['mem_addr'] or gs['mem_data'] != rtl['mem_data']:
                    errors.append(f"MEM STORE: Addr GS={gs['mem_addr']} Data={gs['mem_data']} | Addr RTL={rtl['mem_addr']} Data={rtl['mem_data']}")

            if errors:
                mismatches += 1
                f_rep.write(f"[ERROR] line {i} | Instruction: {gs['op']}\n")
                f_rep.write(f"    INFO: [PC_GS: {gs['pc']}] [PC_RTL: {rtl['pc']}]\n")
                for err in errors:
                    f_rep.write(f"    -> {err}\n")
                f_rep.write("-" * 40 + "\n")

        # Controllo finale successo/fallimento
        is_success = (mismatches == 0 and len(gs_data) == len(rtl_data) and len(gs_data) > 0)

        if is_success:
            f_rep.write("\nESITO: PASS - logs perfectly match.\n")
            return True
        else:
            if len(gs_data) != len(rtl_data):
                f_rep.write(f"\nATTENZIONE: Numero di istruzioni diverso! GS:{len(gs_data)} RTL:{len(rtl_data)}\n")
            f_rep.write(f"\nESITO: FAIL - Trovate {mismatches} incongruenze.\n")
            return False

if __name__ == "__main__":
    # Verifichiamo di avere gli argomenti necessari, altrimenti usiamo i default
    if len(sys.argv) == 4:
        gs_file = sys.argv[1]
        rtl_file = sys.argv[2]
        rep_file = sys.argv[3]
    else:
        gs_file = "log_gs.txt"
        rtl_file = "log_rtl.txt"
        rep_file = "mismatch_report.txt"

    # Esecuzione confronto
    passed = compare_logs(gs_file, rtl_file, rep_file)
    
    # EXIT STATUS: 0 se tutto ok, 1 se ci sono errori
    # Questo permette allo script 'run_isa_suite.py' di capire il risultato
    sys.exit(0 if passed else 1)