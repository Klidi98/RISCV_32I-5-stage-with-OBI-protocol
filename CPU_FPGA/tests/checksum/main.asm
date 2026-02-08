section .text:  

__start:  
auipc gp,0x1fc21 
add gp,gp,-2048 
auipc sp,0xfc11 
add sp,sp,-8 
add s0,sp,zero 
jal 400068 <main> 

el:  
j 400018 <el> 
nop 
nop 

  

delay:  
add sp,sp,-48 
sw s0,44(sp) 
add s0,sp,48 
sw a0,-36(s0) 
sw zero,-20(s0) 
j 400048 <delay+0x24> 
lw a5,-20(s0) 
add a5,a5,1 
sw a5,-20(s0) 
lw a5,-20(s0) 
lw a4,-36(s0) 
blt a5,a4,40003c <delay+0x18> 
nop 
nop 
lw s0,44(sp) 
add sp,sp,48 
ret 

main:  
add sp,sp,-64 
sw ra,60(sp) 
sw s0,56(sp) 
add s0,sp,64 
lui a5,0x10011 
sw a5,-44(s0) 
lui a5,0x10010 
sw a5,-48(s0) 
sw zero,-24(s0) 
j 4000c0 <main+0x58> 
li a4,16 
lw a5,-24(s0) 
sub a3,a4,a5 
lw a5,-24(s0) 
sll a5,a5,0x2 
lw a4,-48(s0) 
add a5,a4,a5 
mv a4,a3 
sw a4,0(a5) 
lw a5,-24(s0) 
add a5,a5,1 
sw a5,-24(s0) 
lw a4,-24(s0) 
li a5,15 
bge a5,a4,400090 <main+0x28> 
lw a5,-44(s0) 
li a4,1 
sw a4,0(a5) 
lui a5,0x31 
add a0,a5,-704 
jal 400024 <delay> 
sw zero,-28(s0) 
j 4001d4 <main+0x16c> 
sw zero,-32(s0) 
j 400190 <main+0x128> 
lw a5,-32(s0) 
sll a5,a5,0x2 
lw a4,-48(s0) 
add a5,a4,a5 
lw a4,0(a5) 
lw a5,-32(s0) 
add a5,a5,1 
sll a5,a5,0x2 
lw a3,-48(s0) 
add a5,a3,a5 
lw a5,0(a5) 
bgeu a5,a4,400184 <main+0x11c> 
lw a5,-32(s0) 
sll a5,a5,0x2 
lw a4,-48(s0) 
add a5,a4,a5 
lw a5,0(a5) 
sw a5,-52(s0) 
lw a5,-32(s0) 
add a5,a5,1 
sll a5,a5,0x2 
lw a4,-48(s0) 
add a4,a4,a5 
lw a5,-32(s0) 
sll a5,a5,0x2 
lw a3,-48(s0) 
add a5,a3,a5 
lw a4,0(a4) 
sw a4,0(a5) 
lw a5,-32(s0) 
add a5,a5,1 
sll a5,a5,0x2 
lw a4,-48(s0) 
add a5,a4,a5 
lw a4,-52(s0) 
sw a4,0(a5) 
lw a5,-32(s0) 
add a5,a5,1 
sw a5,-32(s0) 
li a4,15 
lw a5,-28(s0) 
sub a5,a4,a5 
lw a4,-32(s0) 
blt a4,a5,4000f4 <main+0x8c> 
lw a5,-28(s0) 
li a4,1 
sll a5,a4,a5 
mv a4,a5 
lw a5,-44(s0) 
sw a4,0(a5) 
lui a5,0xf4 
add a0,a5,576 
jal 400024 <delay> 
lw a5,-28(s0) 
add a5,a5,1 
sw a5,-28(s0) 
lw a4,-28(s0) 
li a5,14 
bge a5,a4,4000ec <main+0x84> 
sw zero,-20(s0) 
sw zero,-36(s0) 
j 400218 <main+0x1b0> 
lw a5,-36(s0) 
sll a5,a5,0x2 
lw a4,-48(s0) 
add a5,a4,a5 
lw a5,0(a5) 
lw a4,-20(s0) 
add a5,a4,a5 
sw a5,-20(s0) 
lw a5,-36(s0) 
add a5,a5,1 
sw a5,-36(s0) 
lw a4,-36(s0) 
li a5,15 
bge a5,a4,4001ec <main+0x184> 
lw a4,-20(s0) 
li a5,136 
bne a4,a5,400280 <main+0x218> 
sw zero,-40(s0) 
j 400270 <main+0x208> 
lw a5,-44(s0) 
li a4,255 
sw a4,0(a5) 
lui a5,0xf4 
add a0,a5,576 
jal 400024 <delay> 
lw a5,-44(s0) 
sw zero,0(a5) 
lui a5,0xf4 
add a0,a5,576 
jal 400024 <delay> 
lw a5,-40(s0) 
add a5,a5,1 
sw a5,-40(s0) 
lw a4,-40(s0) 
li a5,2 
bge a5,a4,400238 <main+0x1d0> 
j 400088 <main+0x20> 
lw a5,-44(s0) 
li a4,170 
sw a4,0(a5) 
j 40028c <main+0x224> 
