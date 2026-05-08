  

__start:  
auipc gp,0x1fc21 
add gp,gp,-2048 
auipc sp,0xfc11 
add sp,sp,-8 
add s0,sp,zero 
jal 400124 <main> 

el:  
j 400018 <el> 
nop 
nop 

uart_putc:  
add sp,sp,-32 
sw s0,28(sp) 
add s0,sp,32 
mv a5,a0 
sb a5,-17(s0) 
nop 
lui a5,0x10012 
lw a4,0(a5) 
lui a5,0x1000 
and a5,a4,a5 
bnez a5,40003c <uart_putc+0x18> 
lui a5,0x10012 
lbu a4,-17(s0) 
sw a4,0(a5) 
lbu a4,-17(s0) 
lui a5,0x10012 
or a4,a4,256 
sw a4,0(a5) 
lui a5,0x10012 
lbu a4,-17(s0) 
sw a4,0(a5) 
nop 
lw s0,28(sp) 
add sp,sp,32 
ret 

uart_put_hex:  
add sp,sp,-48 
sw ra,44(sp) 
sw s0,40(sp) 
add s0,sp,48 
sw a0,-36(s0) 
li a5,7 
sw a5,-20(s0) 
j 400104 <uart_put_hex+0x7c> 
lw a5,-20(s0) 
sll a5,a5,0x2 
lw a4,-36(s0) 
srl a5,a4,a5 
and a5,a5,15 
sw a5,-24(s0) 
lw a4,-24(s0) 
li a5,9 
bltu a5,a4,4000e0 <uart_put_hex+0x58> 
lw a5,-24(s0) 
zext.b a5,a5 
add a5,a5,48 
zext.b a5,a5 
j 4000f0 <uart_put_hex+0x68> 
lw a5,-24(s0) 
zext.b a5,a5 
add a5,a5,55 
zext.b a5,a5 
mv a0,a5 
jal 400024 <uart_putc> 
lw a5,-20(s0) 
add a5,a5,-1 
sw a5,-20(s0) 
lw a5,-20(s0) 
bgez a5,4000a8 <uart_put_hex+0x20> 
nop 
nop 
lw ra,44(sp) 
lw s0,40(sp) 
add sp,sp,48 
ret 

main:  
add sp,sp,-64 
sw ra,60(sp) 
sw s0,56(sp) 
add s0,sp,64 
lui a5,0x10010 
sw a5,-32(s0) 
sw zero,-20(s0) 
sw zero,-24(s0) 
li a0,82 
jal 400024 <uart_putc> 
li a0,73 
jal 400024 <uart_putc> 
li a0,83 
jal 400024 <uart_putc> 
li a0,67 
jal 400024 <uart_putc> 
li a0,86 
jal 400024 <uart_putc> 
li a0,51 
jal 400024 <uart_putc> 
li a0,50 
jal 400024 <uart_putc> 
li a0,73 
jal 400024 <uart_putc> 
li a0,10 
jal 400024 <uart_putc> 
li a0,13 
jal 400024 <uart_putc> 
li a0,77 
jal 400024 <uart_putc> 
li a0,101 
jal 400024 <uart_putc> 
li a0,109 
jal 400024 <uart_putc> 
li a0,111 
jal 400024 <uart_putc> 
li a0,114 
jal 400024 <uart_putc> 
li a0,121 
jal 400024 <uart_putc> 
li a0,32 
jal 400024 <uart_putc> 
li a0,84 
jal 400024 <uart_putc> 
li a0,101 
jal 400024 <uart_putc> 
li a0,115 
jal 400024 <uart_putc> 
li a0,116 
jal 400024 <uart_putc> 
li a0,10 
jal 400024 <uart_putc> 
li a0,13 
jal 400024 <uart_putc> 
lw a5,-20(s0) 
sll a4,a5,0xd 
lw a5,-20(s0) 
srl a5,a5,0x5 
xor a4,a4,a5 
lui a5,0xa5a5a 
add a5,a5,1445 
xor a5,a4,a5 
sw a5,-36(s0) 
sw zero,-28(s0) 
j 4003e0 <main+0x2bc> 
lw a4,-28(s0) 
lui a5,0x4004 
add a5,a4,a5 
sll a5,a5,0x2 
sw a5,-40(s0) 
lw a5,-28(s0) 
sll a4,a5,0x2 
lw a5,-36(s0) 
xor a5,a4,a5 
lw a4,-28(s0) 
xor a5,a4,a5 
sw a5,-44(s0) 
lw a5,-28(s0) 
sll a5,a5,0x2 
lw a4,-32(s0) 
add a5,a4,a5 
lw a4,-44(s0) 
sw a4,0(a5) 
lw a5,-28(s0) 
sll a5,a5,0x2 
lw a4,-32(s0) 
add a5,a4,a5 
lw a5,0(a5) 
sw a5,-48(s0) 
lw a4,-44(s0) 
lw a5,-48(s0) 
beq a4,a5,4002a0 <main+0x17c> 
lw a5,-24(s0) 
add a5,a5,1 
sw a5,-24(s0) 
li a0,13 
jal 400024 <uart_putc> 
li a0,73 
jal 400024 <uart_putc> 
li a0,84 
jal 400024 <uart_putc> 
li a0,58 
jal 400024 <uart_putc> 
lw a0,-20(s0) 
jal 400088 <uart_put_hex> 
li a0,32 
jal 400024 <uart_putc> 
li a0,65 
jal 400024 <uart_putc> 
li a0,68 
jal 400024 <uart_putc> 
li a0,68 
jal 400024 <uart_putc> 
li a0,82 
jal 400024 <uart_putc> 
li a0,58 
jal 400024 <uart_putc> 
li a0,48 
jal 400024 <uart_putc> 
li a0,120 
jal 400024 <uart_putc> 
lw a0,-40(s0) 
jal 400088 <uart_put_hex> 
li a0,32 
jal 400024 <uart_putc> 
li a0,48 
jal 400024 <uart_putc> 
li a0,120 
jal 400024 <uart_putc> 
lw a0,-44(s0) 
jal 400088 <uart_put_hex> 
li a0,124 
jal 400024 <uart_putc> 
li a0,48 
jal 400024 <uart_putc> 
li a0,120 
jal 400024 <uart_putc> 
lw a0,-48(s0) 
jal 400088 <uart_put_hex> 
li a0,32 
jal 400024 <uart_putc> 
li a0,69 
jal 400024 <uart_putc> 
li a0,82 
jal 400024 <uart_putc> 
li a0,82 
jal 400024 <uart_putc> 
li a0,58 
jal 400024 <uart_putc> 
lw a0,-24(s0) 
jal 400088 <uart_put_hex> 
lw a5,-24(s0) 
beqz a5,4003a0 <main+0x27c> 
lw a5,-24(s0) 
zext.b a4,a5 
lui a5,0x10011 
or a4,a4,240 
sw a4,0(a5) 
j 4003b0 <main+0x28c> 
lui a5,0x10011 
lw a4,-28(s0) 
srl a4,a4,0x2 
sw a4,0(a5) 
sw zero,-52(s0) 
j 4003c4 <main+0x2a0> 
lw a5,-52(s0) 
add a5,a5,1 
sw a5,-52(s0) 
lw a4,-52(s0) 
lui a5,0x16e 
add a5,a5,863 
bge a5,a4,4003b8 <main+0x294> 
lw a5,-28(s0) 
add a5,a5,1 
sw a5,-28(s0) 
lw a4,-28(s0) 
li a5,511 
bgeu a5,a4,400228 <main+0x104> 
lw a5,-20(s0) 
add a5,a5,1 
sw a5,-20(s0) 
j 4001fc <main+0xd8> 
