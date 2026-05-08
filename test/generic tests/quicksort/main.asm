 .data
 	.word 7
 	.word 1
    .word 4
    .word 9
    .word 2
    .word 8
    .word 3
    .word 5
    .word 0
    .word 6
    .word 11
    .word 10
 
 
 
 .text:
 .global __start  

__start:  
auipc gp,0x1fc18 
addi gp,gp,48 
auipc sp,0x7fbff 
addi sp,sp,-12 
add s0,sp,zero 
jal main

el:  
j el
nop 
nop 

  

swap:  
addi sp,sp,-48 
sw s0,44(sp) 
addi s0,sp,48 
sw a0,-36(s0) 
sw a1,-40(s0) 
lw a5,-36(s0) 
lw a5,0(a5) 
sw a5,-20(s0) 
lw a5,-40(s0) 
lw a4,0(a5) 
lw a5,-36(s0) 
sw a4,0(a5) 
lw a5,-40(s0) 
lw a4,-20(s0) 
sw a4,0(a5) 
nop 
lw s0,44(sp) 
addi sp,sp,48 
ret 

partition:  
addi sp,sp,-48 
sw ra,44(sp) 
sw s0,40(sp) 
addi s0,sp,48 
sw a0,-36(s0) 
sw a1,-40(s0) 
sw a2,-44(s0) 
lw a5,-44(s0) 
slli a5,a5,0x2 
lw a4,-36(s0) 
add a5,a4,a5 
lw a5,0(a5) 
sw a5,-28(s0) 
lw a5,-40(s0) 
addi a5,a5,-1 
sw a5,-20(s0) 
lw a5,-40(s0) 
sw a5,-24(s0) 
j step1#40011c <partition+0xac> 
step3:
lw a5,-24(s0) 
slli a5,a5,0x2 
lw a4,-36(s0) 
add a5,a4,a5 
lw a5,0(a5) 
lw a4,-28(s0) 
bge a5,a4, step2#400110 <partition+0xa0> 
lw a5,-20(s0) 
addi a5,a5,1 
sw a5,-20(s0) 
lw a5,-20(s0) 
slli a5,a5,0x2 
lw a4,-36(s0) 
add a3,a4,a5 
lw a5,-24(s0) 
slli a5,a5,0x2 
lw a4,-36(s0) 
add a5,a4,a5 
mv a1,a5 
mv a0,a3 
jal swap#400024 <swap> 
step2:
lw a5,-24(s0) 
addi a5,a5,1 
sw a5,-24(s0) 
step1:
lw a4,-24(s0) 
lw a5,-44(s0) 
blt a4,a5,step3 #4000bc <partition+0x4c> 
lw a5,-20(s0) 
addi a5,a5,1 
slli a5,a5,0x2 
lw a4,-36(s0) 
add a3,a4,a5 
lw a5,-44(s0) 
slli a5,a5,0x2 
lw a4,-36(s0) 
add a5,a4,a5 
mv a1,a5 
mv a0,a3 
jal swap  
lw a5,-20(s0) 
addi a5,a5,1 
mv a0,a5 
lw ra,44(sp) 
lw s0,40(sp) 
addi sp,sp,48 
ret 

quickSort:  
addi sp,sp,-48 
sw ra,44(sp) 
sw s0,40(sp) 
addi s0,sp,48 
sw a0,-36(s0) 
sw a1,-40(s0) 
sw a2,-44(s0) 
lw a4,-40(s0) 
lw a5,-44(s0) 
bge a4,a5,step4 #4001e0 <quickSort+0x6c> 
lw a2,-44(s0) 
lw a1,-40(s0) 
lw a0,-36(s0) 
jal partition 
sw a0,-20(s0) 
lw a5,-20(s0) 
addi a5,a5,-1 
mv a2,a5 
lw a1,-40(s0) 
lw a0,-36(s0) 
jal quickSort
lw a5,-20(s0) 
addi a5,a5,1 
lw a2,-44(s0) 
mv a1,a5 
lw a0,-36(s0) 
jal quickSort
step4:
nop 
lw ra,44(sp) 
lw s0,40(sp) 
addi sp,sp,48 
ret 

main:  
addi sp,sp,-16 
sw ra,12(sp) 
sw s0,8(sp) 
addi s0,sp,16 
li a2,11 
li a1,0 
lui a5,0x10010 
mv a0,a5 
jal quickSort
lui a5,0x10010 
mv a5,a5 
lw a4,0(a5) 
lui a5,0x10010 
sw a4,48(a5) 
end:
j end 
