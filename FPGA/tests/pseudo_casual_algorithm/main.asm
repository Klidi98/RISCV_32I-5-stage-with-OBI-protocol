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
add sp,sp,-80 
sw s0,76(sp) 
add s0,sp,80 
lui a5,0xb 
add a5,a5,-799 
sw a5,-20(s0) 
sw zero,-76(s0) 
sw zero,-72(s0) 
sw zero,-68(s0) 
sw zero,-64(s0) 
sw zero,-60(s0) 
sw zero,-56(s0) 
sw zero,-52(s0) 
sw zero,-48(s0) 
sw zero,-24(s0) 
lw a5,-20(s0) 
srl a4,a5,0x2 
lw a5,-20(s0) 
xor a4,a4,a5 
lw a5,-20(s0) 
srl a5,a5,0x3 
xor a4,a4,a5 
lw a5,-20(s0) 
srl a5,a5,0x5 
xor a5,a4,a5 
and a5,a5,1 
sw a5,-40(s0) 
lw a5,-20(s0) 
srl a4,a5,0x1 
lw a5,-40(s0) 
sll a5,a5,0xf 
or a5,a4,a5 
sw a5,-20(s0) 
lw a4,-24(s0) 
lui a5,0x1 
add a5,a5,-1 
and a5,a4,a5 
bnez a5,400148 <main+0xe0> 
sw zero,-28(s0) 
j 40013c <main+0xd4> 
lw a5,-28(s0) 
and a5,a5,1 
lw a4,-20(s0) 
srl a5,a4,a5 
zext.b a4,a5 
lw a5,-28(s0) 
sll a5,a5,0x2 
add a5,a5,-16 
add a5,a5,s0 
sw a4,-60(a5) 
lw a5,-28(s0) 
add a5,a5,1 
sw a5,-28(s0) 
lw a4,-28(s0) 
li a5,7 
bge a5,a4,400108 <main+0xa0> 
sw zero,-32(s0) 
lw a5,-24(s0) 
zext.b a5,a5 
sw a5,-44(s0) 
sw zero,-36(s0) 
j 4001a4 <main+0x13c> 
lw a5,-36(s0) 
sll a5,a5,0x2 
add a5,a5,-16 
add a5,a5,s0 
lw a4,-60(a5) 
lw a5,-44(s0) 
bgeu a5,a4,400198 <main+0x130> 
lw a5,-36(s0) 
li a4,1 
sll a5,a4,a5 
mv a4,a5 
lw a5,-32(s0) 
or a5,a5,a4 
sw a5,-32(s0) 
lw a5,-36(s0) 
add a5,a5,1 
sw a5,-36(s0) 
lw a4,-36(s0) 
li a5,7 
bge a5,a4,400160 <main+0xf8> 
lui a5,0x10011 
lw a4,-32(s0) 
sw a4,0(a5) 
lw a5,-24(s0) 
add a5,a5,1 
sw a5,-24(s0) 
j 4000a4 <main+0x3c> 
