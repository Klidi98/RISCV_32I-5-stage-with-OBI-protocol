  

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
add sp,sp,-80 
sw ra,76(sp) 
sw s0,72(sp) 
add s0,sp,80 
li a5,1 
sw a5,-20(s0) 
li a5,2 
sw a5,-24(s0) 
li a5,3 
sw a5,-28(s0) 
li a5,4 
sw a5,-32(s0) 
li a5,5 
sw a5,-36(s0) 
li a5,6 
sw a5,-40(s0) 
li a5,7 
sw a5,-44(s0) 
lui a5,0x10013 
lw a5,0(a5) 
sw a5,-48(s0) 
lui a5,0x10014 
lw a5,0(a5) 
sw a5,-52(s0) 
li a0,1 
li a1,2 
li a2,3 
li a3,4 
li a4,5 
li a5,6 
li a6,7 
lui t0,0x2 
add t0,t0,1808 
add a0,a0,a1 
add a1,a1,a2 
add a2,a3,a4 
add a3,a4,a5 
add a6,a4,a6 
add a5,a4,a6 
add a1,a1,a2 
add a2,a3,a4 
add a3,a4,a5 
add a6,a2,a6 
add a0,a0,a1 
add a1,a1,a2 
add a2,a3,a4 
add a3,a4,a5 
add a6,a4,a6 
add a5,a4,a6 
add a1,a1,a2 
add a2,a3,a4 
add a3,a4,a5 
add a6,a2,a6 
add a0,a0,a1 
add a1,a1,a2 
add a2,a3,a4 
add a3,a4,a5 
add a6,a4,a6 
add a5,a4,a6 
add a1,a1,a2 
add a2,a3,a4 
add a3,a4,a5 
add a6,a2,a6 
add a0,a0,a1 
add a1,a1,a2 
add a2,a3,a4 
add a3,a4,a5 
add a6,a4,a6 
add a5,a4,a6 
add a1,a1,a2 
add a2,a3,a4 
add a3,a4,a5 
add a6,a2,a6 
add a0,a0,a1 
add a1,a1,a2 
add a2,a3,a4 
add a3,a4,a5 
add a6,a4,a6 
add a5,a4,a6 
add a1,a1,a2 
add a2,a3,a4 
add a3,a4,a5 
add a6,a2,a6 
add a0,a0,a1 
add a1,a1,a2 
add a2,a3,a4 
add a3,a4,a5 
add a6,a4,a6 
add a5,a4,a6 
add a1,a1,a2 
add a2,a3,a4 
add a3,a4,a5 
add a6,a2,a6 
add a0,a0,a1 
add a1,a1,a2 
add a2,a3,a4 
add a3,a4,a5 
add a6,a4,a6 
add a5,a4,a6 
add a1,a1,a2 
add a2,a3,a4 
add a3,a4,a5 
add a6,a2,a6 
add a0,a0,a1 
add a1,a1,a2 
add a2,a3,a4 
add a3,a4,a5 
add a6,a4,a6 
add a5,a4,a6 
add a1,a1,a2 
add a2,a3,a4 
add a3,a4,a5 
add a6,a2,a6 
add a0,a0,a1 
add a1,a1,a2 
add a2,a3,a4 
add a3,a4,a5 
add a6,a4,a6 
add a5,a4,a6 
add a1,a1,a2 
add a2,a3,a4 
add a3,a4,a5 
add a6,a2,a6 
add a0,a0,a1 
add a1,a1,a2 
add a2,a3,a4 
add a3,a4,a5 
add a6,a4,a6 
add a5,a4,a6 
add a1,a1,a2 
add a2,a3,a4 
add a3,a4,a5 
add a6,a2,a6 
add t0,t0,-1 
bnez t0,4001a8 <main+0x84> 
sw a6,-20(s0) 
sw a0,-24(s0) 
sw a1,-28(s0) 
sw a2,-32(s0) 
sw a3,-36(s0) 
sw a4,-40(s0) 
sw a5,-44(s0) 
lw a4,-20(s0) 
lw a5,-24(s0) 
add a4,a4,a5 
lw a5,-28(s0) 
add a4,a4,a5 
lw a5,-32(s0) 
add a4,a4,a5 
lw a5,-36(s0) 
add a4,a4,a5 
lw a5,-40(s0) 
add a5,a4,a5 
lw a4,-44(s0) 
add a5,a4,a5 
sw a5,-56(s0) 
lui a5,0x10013 
lw a5,0(a5) 
sw a5,-60(s0) 
lui a5,0x10014 
lw a5,0(a5) 
sw a5,-64(s0) 
lw a4,-60(s0) 
lw a5,-48(s0) 
sub a5,a4,a5 
sw a5,-68(s0) 
lw a4,-64(s0) 
lw a5,-52(s0) 
sub a5,a4,a5 
sw a5,-72(s0) 
li a0,13 
jal 400024 <uart_putc> 
li a0,67 
jal 400024 <uart_putc> 
li a0,58 
jal 400024 <uart_putc> 
li a0,32 
jal 400024 <uart_putc> 
lw a0,-68(s0) 
jal 400088 <uart_put_hex> 
li a0,10 
jal 400024 <uart_putc> 
li a0,13 
jal 400024 <uart_putc> 
li a0,73 
jal 400024 <uart_putc> 
li a0,58 
jal 400024 <uart_putc> 
li a0,32 
jal 400024 <uart_putc> 
lw a0,-72(s0) 
jal 400088 <uart_put_hex> 
li a0,10 
jal 400024 <uart_putc> 
lw a4,-56(s0) 
lui a5,0xb5ca1 
add a5,a5,344 
bne a4,a5,40044c <main+0x328> 
lui a5,0x10011 
li a4,1 
sw a4,0(a5) 
j 400474 <main+0x350> 
lui a5,0x10011 
lui a4,0xe 
add a4,a4,-339 
sw a4,0(a5) 
li a0,69 
jal 400024 <uart_putc> 
li a0,58 
jal 400024 <uart_putc> 
lw a0,-56(s0) 
jal 400088 <uart_put_hex> 
li a5,0 
mv a0,a5 
lw ra,76(sp) 
lw s0,72(sp) 
add sp,sp,80 
ret 
