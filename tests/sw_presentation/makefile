# Percorsi e Toolchain
RISCV_PATH = /opt/riscv2/bin
ARCH = riscv32-unknown-elf

CC      = $(RISCV_PATH)/$(ARCH)-gcc
OBJCOPY = $(RISCV_PATH)/$(ARCH)-objcopy
OBJDUMP = $(RISCV_PATH)/$(ARCH)-objdump

# Opzioni di compilazione

CFLAGS = -march=rv32i -mabi=ilp32 -g -ffreestanding -O0 -Wl,--gc-sections -nostartfiles -nostdlib -nodefaultlibs


LINKER_SCRIPT = riscv32-isa.ld
CRT0 = crt0.s
SRC = main.c

all: mem.hex main.lst

# 1. Compilazione dell'eseguibile ELF
main: $(CRT0) $(SRC)
	$(CC) $(CFLAGS) -T $(LINKER_SCRIPT) -o $@ $^

# 2. Generazione del file per la BRAM 
mem.hex: main
	$(OBJCOPY) -O binary $< main.bin
	hexdump -v -e '1/4 "%08x\n"' main.bin > $@

# 3. Generazione del Disassembly
main.lst: main
	$(OBJDUMP) -d $< > $@

# Pulizia dei file generati
clean:
	rm -f main mem.hex main.lst

.PHONY: all clean
