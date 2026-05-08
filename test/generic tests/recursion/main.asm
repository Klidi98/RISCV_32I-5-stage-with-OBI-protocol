.data

list:
	.word 7
	.word 3
	.word 9
	.word 12
	.word -1
	


.text:
.global __start  

__start:  
auipc gp,0x1fc18 
addi gp,gp,20
auipc sp,0x7fbff 
addi sp,sp,-12 
add s0,sp,zero 
jal ra, main 

el:  
j el 
nop 
nop 

  

count_list:  
addi sp,sp,-32 
sw ra,28(sp) 
sw s0,24(sp) 
addi s0,sp,32 
sw a0,-20(s0) 
lw a5,-20(s0) 
lw a4,0(a5) 
li a5,-1 
bne a4,a5,j1 
li a5,0 
j j2
j1:
lw a5,-20(s0) 
addi a5,a5,4 
mv a0,a5 
jal ra, count_list
mv a5,a0 
addi a5,a5,1 
j2:
mv a0,a5 
lw ra,28(sp) 
lw s0,24(sp) 
addi sp,sp,32 
ret 

main:  
addi sp,sp,-16 
sw ra,12(sp) 
sw s0,8(sp) 
addi s0,sp,16 
lui a5,0x10010 
mv a0,a5 
jal ra, count_list 
mv a4,a0 
lui a5,0x10010 
sw a4,20(a5) 
end:
j end
