  

__start:  
auipc gp,0x1fc21 
add gp,gp,-2048 
auipc sp,0xfc11 
add sp,sp,-8 
add s0,sp,zero 
jal 400024 <main> 

el:  
j 400018 <el> 
nop 
nop 

main:  
lui sp,0x10011 
lui a0,0x2 
add a0,a0,1808 
lui s10,0x10013 
lui s11,0x10014 
lw s0,0(s10) 
lw s1,0(s11) 
li t2,1 
li t3,2 
li t4,3 
li t5,4 
li t6,5 

benchmark_loop:  
add t2,t2,t3 
add t3,t3,t4 
add t4,t4,t5 
add t5,t5,t6 
add t6,t6,t2 
add t2,t2,t3 
add t3,t3,t4 
add t4,t4,t5 
add t5,t5,t6 
add t6,t6,t2 
add t2,t2,t3 
add t3,t3,t4 
add t4,t4,t5 
add t5,t5,t6 
add t6,t6,t2 
add t2,t2,t3 
add t3,t3,t4 
add t4,t4,t5 
add t5,t5,t6 
add t6,t6,t2 
add t2,t2,t3 
add t3,t3,t4 
add t4,t4,t5 
add t5,t5,t6 
add t6,t6,t2 
add t2,t2,t3 
add t3,t3,t4 
add t4,t4,t5 
add t5,t5,t6 
add t6,t6,t2 
add t2,t2,t3 
add t3,t3,t4 
add t4,t4,t5 
add t5,t5,t6 
add t6,t6,t2 
add t2,t2,t3 
add t3,t3,t4 
add t4,t4,t5 
add t5,t5,t6 
add t6,t6,t2 
add t2,t2,t3 
add t3,t3,t4 
add t4,t4,t5 
add t5,t5,t6 
add t6,t6,t2 
add t2,t2,t3 
add t3,t3,t4 
add t4,t4,t5 
add t5,t5,t6 
add t6,t6,t2 
add t2,t2,t3 
add t3,t3,t4 
add t4,t4,t5 
add t5,t5,t6 
add t6,t6,t2 
add t2,t2,t3 
add t3,t3,t4 
add t4,t4,t5 
add t5,t5,t6 
add t6,t6,t2 
add t2,t2,t3 
add t3,t3,t4 
add t4,t4,t5 
add t5,t5,t6 
add t6,t6,t2 
add t2,t2,t3 
add t3,t3,t4 
add t4,t4,t5 
add t5,t5,t6 
add t6,t6,t2 
add t2,t2,t3 
add t3,t3,t4 
add t4,t4,t5 
add t5,t5,t6 
add t6,t6,t2 
add t2,t2,t3 
add t3,t3,t4 
add t4,t4,t5 
add t5,t5,t6 
add t6,t6,t2 
add t2,t2,t3 
add t3,t3,t4 
add t4,t4,t5 
add t5,t5,t6 
add t6,t6,t2 
add t2,t2,t3 
add t3,t3,t4 
add t4,t4,t5 
add t5,t5,t6 
add t6,t6,t2 
add t2,t2,t3 
add t3,t3,t4 
add t4,t4,t5 
add t5,t5,t6 
add t6,t6,t2 
add t2,t2,t3 
add t3,t3,t4 
add t4,t4,t5 
add t5,t5,t6 
add t6,t6,t2 
add a0,a0,-1 
bnez a0,400054 <benchmark_loop> 
lw s2,0(s10) 
lw s3,0(s11) 
sub s2,s2,s0 
sub s3,s3,s1 
li a0,67 
jal 400244 <uart_putc> 
li a0,58 
jal 400244 <uart_putc> 
mv a0,s2 
jal 40026c <uart_put_hex> 
li a0,10 
jal 400244 <uart_putc> 
li a0,73 
jal 400244 <uart_putc> 
li a0,58 
jal 400244 <uart_putc> 
mv a0,s3 
jal 40026c <uart_put_hex> 
lui t0,0x10011 
li t1,1 
sw t1,0(t0) 

loop_forever:  
j 400240 <loop_forever> 

uart_putc:  
lui a1,0x10012 

wait_busy:  
lw a2,0(a1) 
lui a3,0x1000 
and a2,a2,a3 
bnez a2,400248 <wait_busy> 
li a3,256 
or a2,a0,a3 
sw a2,0(a1) 
sw a0,0(a1) 
ret 

uart_put_hex:  
add sp,sp,-32 
sw ra,28(sp) 
sw s0,24(sp) 
sw s1,20(sp) 
mv s0,a0 
li s1,7 

hex_loop:  
sll a4,s1,0x2 
srl a0,s0,a4 
and a0,a0,15 
li a5,10 
blt a0,a5,4002a0 <low_digit> 
add a0,a0,55 
j 4002a4 <print_digit> 

low_digit:  
add a0,a0,48 

print_digit:  
jal 400244 <uart_putc> 
add s1,s1,-1 
li a5,-1 
bne s1,a5,400284 <hex_loop> 
lw s1,20(sp) 
lw s0,24(sp) 
lw ra,28(sp) 
add sp,sp,32 
ret 
