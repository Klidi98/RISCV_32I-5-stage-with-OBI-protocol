  

__start:  
auipc gp,0xfc11 
add gp,gp,-2048 
auipc sp,0xfc11 
add sp,sp,-8 
add s0,sp,zero 
jal 400390 <main> 

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

uart_puts:  
add sp,sp,-32 
sw ra,28(sp) 
sw s0,24(sp) 
add s0,sp,32 
sw a0,-20(s0) 
j 4000b8 <uart_puts+0x30> 
lw a5,-20(s0) 
add a4,a5,1 
sw a4,-20(s0) 
lbu a5,0(a5) 
mv a0,a5 
jal 400024 <uart_putc> 
lw a5,-20(s0) 
lbu a5,0(a5) 
bnez a5,4000a0 <uart_puts+0x18> 
nop 
nop 
lw ra,28(sp) 
lw s0,24(sp) 
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
j 400158 <uart_put_hex+0x7c> 
lw a5,-20(s0) 
sll a5,a5,0x2 
lw a4,-36(s0) 
srl a5,a4,a5 
and a5,a5,15 
sw a5,-24(s0) 
lw a4,-24(s0) 
li a5,9 
bltu a5,a4,400134 <uart_put_hex+0x58> 
lw a5,-24(s0) 
zext.b a5,a5 
add a5,a5,48 
zext.b a5,a5 
j 400144 <uart_put_hex+0x68> 
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
bgez a5,4000fc <uart_put_hex+0x20> 
nop 
nop 
lw ra,44(sp) 
lw s0,40(sp) 
add sp,sp,48 
ret 

delay:  
add sp,sp,-32 
sw s0,28(sp) 
add s0,sp,32 
sw a0,-20(s0) 
j 400190 <delay+0x18> 
nop 
lw a5,-20(s0) 
add a4,a5,-1 
sw a4,-20(s0) 
bnez a5,40018c <delay+0x14> 
nop 
nop 
lw s0,28(sp) 
add sp,sp,32 
ret 

print_logo:  
add sp,sp,-16 
sw ra,12(sp) 
sw s0,8(sp) 
add s0,sp,16 
lui a5,0x400 
add a0,a5,1088 
jal 400088 <uart_puts> 
lui a5,0x400 
add a0,a5,1092 
jal 400088 <uart_puts> 
lui a5,0x400 
add a0,a5,1136 
jal 400088 <uart_puts> 
lui a5,0x400 
add a0,a5,1180 
jal 400088 <uart_puts> 
lui a5,0x400 
add a0,a5,1136 
jal 400088 <uart_puts> 
lui a5,0x400 
add a0,a5,1224 
jal 400088 <uart_puts> 
lui a5,0x400 
add a0,a5,1136 
jal 400088 <uart_puts> 
lui a5,0x400 
add a0,a5,1092 
jal 400088 <uart_puts> 
lui a5,0x400 
add a0,a5,1088 
jal 400088 <uart_puts> 
nop 
lw ra,12(sp) 
lw s0,8(sp) 
add sp,sp,16 
ret 

run_benchmark:  
add sp,sp,-32 
sw s0,28(sp) 
add s0,sp,32 
li a5,1 
sw a5,-24(s0) 
li a5,2 
sw a5,-28(s0) 
sw zero,-32(s0) 
sw zero,-20(s0) 
j 4002d0 <run_benchmark+0x8c> 
lw a4,-24(s0) 
lw a5,-28(s0) 
add a5,a4,a5 
sw a5,-32(s0) 
lw a4,-28(s0) 
lw a5,-32(s0) 
xor a5,a4,a5 
sw a5,-24(s0) 
lw a4,-32(s0) 
lw a5,-20(s0) 
add a5,a4,a5 
sw a5,-28(s0) 
lw a5,-32(s0) 
and a5,a5,1 
beqz a5,4002b8 <run_benchmark+0x74> 
lw a5,-24(s0) 
add a5,a5,3 
sw a5,-24(s0) 
j 4002c4 <run_benchmark+0x80> 
lw a5,-28(s0) 
add a5,a5,7 
sw a5,-28(s0) 
lw a5,-20(s0) 
add a5,a5,1 
sw a5,-20(s0) 
lw a4,-20(s0) 
lui a5,0x4c5 
add a5,a5,-1217 
bgeu a5,a4,40026c <run_benchmark+0x28> 
nop 
nop 
lw s0,28(sp) 
add sp,sp,32 
ret 

print_results:  
add sp,sp,-32 
sw ra,28(sp) 
sw s0,24(sp) 
add s0,sp,32 
sw a0,-20(s0) 
sw a1,-24(s0) 
lui a5,0x400 
add a0,a5,1268 
jal 400088 <uart_puts> 
lui a5,0x400 
add a0,a5,1300 
jal 400088 <uart_puts> 
lui a5,0x400 
add a0,a5,1324 
jal 400088 <uart_puts> 
lw a0,-20(s0) 
jal 4000dc <uart_put_hex> 
lui a5,0x400 
add a0,a5,1088 
jal 400088 <uart_puts> 
lui a5,0x400 
add a0,a5,1348 
jal 400088 <uart_puts> 
lw a0,-24(s0) 
jal 4000dc <uart_put_hex> 
lui a5,0x400 
add a0,a5,1088 
jal 400088 <uart_puts> 
lui a5,0x400 
add a0,a5,1372 
jal 400088 <uart_puts> 
lui a5,0x400 
add a0,a5,1400 
jal 400088 <uart_puts> 
nop 
lw ra,28(sp) 
lw s0,24(sp) 
add sp,sp,32 
ret 

main:  
add sp,sp,-48 
sw ra,44(sp) 
sw s0,40(sp) 
add s0,sp,48 
lui a5,0x10011 
li a4,1 
sw a4,0(a5) 
jal 4001b4 <print_logo> 
lui a5,0x7a 
add a0,a5,288 
jal 400178 <delay> 
lui a5,0x10013 
lw a5,0(a5) 
sw a5,-20(s0) 
lui a5,0x10014 
lw a5,0(a5) 
sw a5,-24(s0) 
jal 400244 <run_benchmark> 
lui a5,0x10013 
lw a5,0(a5) 
sw a5,-28(s0) 
lui a5,0x10014 
lw a5,0(a5) 
sw a5,-32(s0) 
lw a4,-28(s0) 
lw a5,-20(s0) 
sub a5,a4,a5 
sw a5,-36(s0) 
lw a4,-32(s0) 
lw a5,-24(s0) 
sub a5,a4,a5 
sw a5,-40(s0) 
lw a1,-40(s0) 
lw a0,-36(s0) 
jal 4002f4 <print_results> 
lui a5,0x10011 
lw a4,0(a5) 
lui a5,0x10011 
xor a4,a4,1 
sw a4,0(a5) 
lui a5,0x1e8 
add a0,a5,1152 
jal 400178 <delay> 
j 40041c <main+0x8c> 
