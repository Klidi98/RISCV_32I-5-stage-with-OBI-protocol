OUTPUT_FORMAT("elf32-littleriscv", "elf32-littleriscv", "elf32-littleriscv")
OUTPUT_ARCH(riscv)

MEMORY
{
   /* Memoria Istruzioni e Costanti (Bit 22 = 1) */
   ROM (rx)  : ORIGIN = 0x00400000, LENGTH = 64k
   /* Memoria Dati Volatili (Bit 28 = 1) */
   RAM (rwx) : ORIGIN = 0x10010000, LENGTH = 4k
}

ENTRY(_start)

SECTIONS
{
  . = ORIGIN(ROM);

  .init :
  {
    KEEP (*(SORT_NONE(.init)))
  } > ROM

  .text :
  {
    *(.text .text.* .gnu.linkonce.t.*)
  } > ROM

  /* --- MODIFICA CRUCIALE: Sezione per le Stringhe --- */
  .rodata : ALIGN(4)
  {
    *(.rodata .rodata.*)
    *(.srodata .srodata.*) /* Spostate qui dalla RAM */
    *(.gnu.linkonce.r.*)
    . = ALIGN(4);
  } > ROM
  /* -------------------------------------------------- */

  PROVIDE (__etext = .);
  PROVIDE (_etext = .);
  PROVIDE (etext = .);

  /* Indirizzo dello Stack (Fine della RAM) */
  PROVIDE(__stack_top = 0x10011000); 

  .data : 
  {
    __data_start = .;
    *(.data .data.* .gnu.linkonce.d.*)
    *(.data1)
    *(.got .got.plt)
    
    /* Global Pointer a metà della sdata per indirizzamento relativo */
    __global_pointer$ = . + 0x800;
    *(.sdata .sdata.* .gnu.linkonce.s.*)
    
    . = ALIGN(4);
    __data_end = .;
  } > RAM AT > ROM 
  /* AT > ROM indica che i valori iniziali delle variabili globali 
     sono salvati in ROM ma verranno usati in RAM */

  .bss :
  {
    __bss_start = .;
    *(.sbss .sbss.* .gnu.linkonce.sb.*)
    *(.bss .bss.* .gnu.linkonce.b.*)
    *(COMMON)
    . = ALIGN(4);
    __bss_end = .;
  } > RAM

  _end = .; 
  PROVIDE (end = .);
}