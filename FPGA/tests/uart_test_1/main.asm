  

__start:  
auipc gp,0x1fc21 
add gp,gp,-2038 
auipc sp,0xfc11 
add sp,sp,-8 
add s0,sp,zero 
lui t0,0x10010 
lui t1,0x54524 
add t1,t1,341 
sw t1,0(t0) 
lui t1,0xd4b5 
add t1,t1,-224 
sw t1,4(t0) 
li t1,10 
sw t1,8(t0) 
jal 40013c <main> 

el:  
j 40003c <el> 
nop 
nop 

delay:  
add sp,sp,-32 
sw s0,28(sp) 
add s0,sp,32 
sw a0,-20(s0) 
j 400060 <delay+0x18> 
nop 
lw a5,-20(s0) 
add a4,a5,-1 
sw a4,-20(s0) 
bnez a5,40005c <delay+0x14> 
nop 
nop 
lw s0,28(sp) 
add sp,sp,32 
ret 

uart_send_byte:  
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
bnez a5,40009c <uart_send_byte+0x18> 
lui a5,0x10012 
lbu a4,-17(s0) 
sw a4,0(a5) 
lbu a4,-17(s0) 
lui a5,0x10012 
or a4,a4,256 
sw a4,0(a5) 
nop 
lw s0,28(sp) 
add sp,sp,32 
ret 

uart_send_string:  
add sp,sp,-32 
sw ra,28(sp) 
sw s0,24(sp) 
add s0,sp,32 
sw a0,-20(s0) 
j 400114 <uart_send_string+0x38> 
lw a5,-20(s0) 
lbu a5,0(a5) 
zext.b a5,a5 
mv a0,a5 
jal 400084 <uart_send_byte> 
lw a5,-20(s0) 
add a5,a5,1 
sw a5,-20(s0) 
lw a5,-20(s0) 
lbu a5,0(a5) 
zext.b a5,a5 
bnez a5,4000f4 <uart_send_string+0x18> 
nop 
nop 
lw ra,28(sp) 
lw s0,24(sp) 
add sp,sp,32 
ret 

main:  
add sp,sp,-32 
sw ra,28(sp) 
sw s0,24(sp) 
add s0,sp,32 
sw zero,-20(s0) 
lui a5,0x10010 
mv a0,a5 
jal 4000dc <uart_send_string> 
lw a5,-20(s0) 
add a4,a5,1 
sw a4,-20(s0) 
lui a4,0x10011 
sw a5,0(a4) 
li a0,65 
jal 400084 <uart_send_byte> 
lui a5,0x7a 
add a0,a5,288 
jal 400048 <delay> 
j 40015c <main+0x20> 
