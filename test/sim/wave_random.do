onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -group core /tb_random_mem/load
add wave -noupdate -group core /tb_random_mem/uut/x_i_rst_n
add wave -noupdate -group core /tb_random_mem/uut/x_i_clk
add wave -noupdate -group core /tb_random_mem/uut/x_instr_32_i
add wave -noupdate -group core /tb_random_mem/uut/x_data_32_i
add wave -noupdate -group core /tb_random_mem/uut/x_data_32_o
add wave -noupdate -group core /tb_random_mem/uut/x_ready_im_i
add wave -noupdate -group core /tb_random_mem/uut/x_ready_dm_i
add wave -noupdate -group core /tb_random_mem/uut/x_valid_im_i
add wave -noupdate -group core /tb_random_mem/uut/x_valid_dm_i
add wave -noupdate -group core /tb_random_mem/uut/x_instr_commit_o
add wave -noupdate -group core /tb_random_mem/uut/x_request_im_o
add wave -noupdate -group core /tb_random_mem/uut/x_request_dm_o
add wave -noupdate -group core /tb_random_mem/uut/x_wren_dm_o
add wave -noupdate -group core /tb_random_mem/uut/x_byte_enable_dm
add wave -noupdate -group core -radix hexadecimal /tb_random_mem/uut/x_addr32_im_o
add wave -noupdate -group core /tb_random_mem/uut/x_addr32_dm_o
add wave -noupdate -group core /tb_random_mem/uut/ready_im
add wave -noupdate -group core /tb_random_mem/uut/valid_im
add wave -noupdate -group core /tb_random_mem/uut/w_fetched_instr_if
add wave -noupdate -group core /tb_random_mem/uut/w_current_pc_if
add wave -noupdate -group core /tb_random_mem/uut/w_previous_pc_if
add wave -noupdate -group core /tb_random_mem/uut/w_increment_pc_if
add wave -noupdate -group core /tb_random_mem/uut/w_jump_pc_mem
add wave -noupdate -group core /tb_random_mem/uut/w_sel_next_pc_mem
add wave -noupdate -group core /tb_random_mem/uut/w_fetched_instr_id
add wave -noupdate -group core /tb_random_mem/uut/w_current_pc_id
add wave -noupdate -group core /tb_random_mem/uut/w_previous_pc_id
add wave -noupdate -expand -group fetch -radix hexadecimal /tb_random_mem/uut/iFETCH/clk
add wave -noupdate -expand -group fetch -radix hexadecimal /tb_random_mem/uut/iFETCH/rst_n
add wave -noupdate -expand -group fetch -color Cyan -radix hexadecimal /tb_random_mem/uut/iFETCH/o_request
add wave -noupdate -expand -group fetch -color White -radix hexadecimal /tb_random_mem/uut/iFETCH/ready_im
add wave -noupdate -expand -group fetch -color White -radix hexadecimal /tb_random_mem/uut/iFETCH/valid_im
add wave -noupdate -expand -group fetch -radix hexadecimal /tb_random_mem/uut/iFETCH/next_instruction_i
add wave -noupdate -expand -group fetch -radix hexadecimal /tb_random_mem/uut/iFETCH/next_instruction_o
add wave -noupdate -expand -group fetch -color Yellow -radix hexadecimal /tb_random_mem/uut/iFETCH/next_PC_o
add wave -noupdate -expand -group fetch -radix hexadecimal /tb_random_mem/uut/iFETCH/current_PC_o
add wave -noupdate -expand -group fetch -radix hexadecimal /tb_random_mem/uut/iFETCH/valid_instr_o
add wave -noupdate -expand -group fetch -radix hexadecimal /tb_random_mem/uut/iFETCH/o_pending_req
add wave -noupdate -expand -group fetch -radix hexadecimal /tb_random_mem/uut/iFETCH/i_misprediction
add wave -noupdate -expand -group fetch -radix hexadecimal /tb_random_mem/uut/iFETCH/i_predict_taken
add wave -noupdate -expand -group fetch -radix hexadecimal /tb_random_mem/uut/iFETCH/i_predicted_trgt
add wave -noupdate -expand -group fetch -radix hexadecimal /tb_random_mem/uut/iFETCH/i_jump_target
add wave -noupdate -expand -group fetch -radix hexadecimal /tb_random_mem/uut/iFETCH/i_block_pp
add wave -noupdate -expand -group fetch -radix hexadecimal /tb_random_mem/uut/iFETCH/i_flush_pp
add wave -noupdate -expand -group fetch -radix hexadecimal /tb_random_mem/uut/iFETCH/w_pc_mux_out
add wave -noupdate -expand -group fetch -radix hexadecimal /tb_random_mem/uut/iFETCH/w_PC_out
add wave -noupdate -expand -group fetch -radix hexadecimal /tb_random_mem/uut/iFETCH/w_next_PC
add wave -noupdate -expand -group fetch -radix hexadecimal /tb_random_mem/uut/iFETCH/w_pc_enable
add wave -noupdate -expand -group fetch -radix hexadecimal /tb_random_mem/uut/iFETCH/w_req_o
add wave -noupdate -expand -group fetch -radix hexadecimal /tb_random_mem/uut/iFETCH/w_buffered_instruction
add wave -noupdate -expand -group fetch -radix hexadecimal /tb_random_mem/uut/iFETCH/w_buf_instr_valid
add wave -noupdate -expand -group fetch -radix hexadecimal /tb_random_mem/uut/iFETCH/w_valid_instr_o
add wave -noupdate -expand -group fetch -radix hexadecimal /tb_random_mem/uut/iFETCH/w_pending_trg
add wave -noupdate -expand -group fetch -radix hexadecimal /tb_random_mem/uut/iFETCH/pending_trg_reg
add wave -noupdate -expand -group fetch /tb_random_mem/uut/iFETCH/w_block_ftch
add wave -noupdate -expand -group pp_if_id /tb_random_mem/uut/IF_ID_PP/clk
add wave -noupdate -expand -group pp_if_id /tb_random_mem/uut/IF_ID_PP/reset_n
add wave -noupdate -expand -group pp_if_id /tb_random_mem/uut/IF_ID_PP/enable_i
add wave -noupdate -expand -group pp_if_id /tb_random_mem/uut/IF_ID_PP/flusher
add wave -noupdate -expand -group pp_if_id /tb_random_mem/uut/IF_ID_PP/i_predict_taken
add wave -noupdate -expand -group pp_if_id -radix hexadecimal /tb_random_mem/uut/IF_ID_PP/instruction_i
add wave -noupdate -expand -group pp_if_id -radix hexadecimal /tb_random_mem/uut/IF_ID_PP/current_PC_i
add wave -noupdate -expand -group pp_if_id -radix hexadecimal /tb_random_mem/uut/IF_ID_PP/previous_PC_i
add wave -noupdate -expand -group pp_if_id -radix hexadecimal /tb_random_mem/uut/IF_ID_PP/o_predict_taken
add wave -noupdate -expand -group pp_if_id -radix hexadecimal /tb_random_mem/uut/IF_ID_PP/current_pc_o
add wave -noupdate -expand -group pp_if_id -radix hexadecimal /tb_random_mem/uut/IF_ID_PP/previous_pc_o
add wave -noupdate -color Yellow -radix hexadecimal /tb_random_mem/uut/IF_ID_PP/Instruction_o
add wave -noupdate -group id /tb_random_mem/uut/ID_STAGE/clk
add wave -noupdate -group id /tb_random_mem/uut/ID_STAGE/i_instruction
add wave -noupdate -group id /tb_random_mem/uut/ID_STAGE/i_wdata
add wave -noupdate -group id /tb_random_mem/uut/ID_STAGE/i_dreg
add wave -noupdate -group id /tb_random_mem/uut/ID_STAGE/i_ctr_write_rf
add wave -noupdate -group id /tb_random_mem/uut/ID_STAGE/o_opcode
add wave -noupdate -group id /tb_random_mem/uut/ID_STAGE/i_stall
add wave -noupdate -group id /tb_random_mem/uut/ID_STAGE/i_instr_valid
add wave -noupdate -group id /tb_random_mem/uut/ID_STAGE/o_instr_valid
add wave -noupdate -group id /tb_random_mem/uut/ID_STAGE/o_ctr_U_UJ_I
add wave -noupdate -group id /tb_random_mem/uut/ID_STAGE/o_ctr_write_rf
add wave -noupdate -group id /tb_random_mem/uut/ID_STAGE/o_ctr_sel_alu_src1
add wave -noupdate -group id /tb_random_mem/uut/ID_STAGE/o_ctr_sel_alu_src2
add wave -noupdate -group id /tb_random_mem/uut/ID_STAGE/o_ctr_addsub
add wave -noupdate -group id /tb_random_mem/uut/ID_STAGE/o_ctr_alu_op
add wave -noupdate -group id /tb_random_mem/uut/ID_STAGE/o_ctr_comp_op
add wave -noupdate -group id /tb_random_mem/uut/ID_STAGE/o_ctr_signed
add wave -noupdate -group id /tb_random_mem/uut/ID_STAGE/o_ctr_branch
add wave -noupdate -group id /tb_random_mem/uut/ID_STAGE/o_ctr_wren_dm
add wave -noupdate -group id /tb_random_mem/uut/ID_STAGE/o_ctr_request_dm
add wave -noupdate -group id /tb_random_mem/uut/ID_STAGE/o_ctr_jalr
add wave -noupdate -group id /tb_random_mem/uut/ID_STAGE/o_ctr_lui
add wave -noupdate -group id /tb_random_mem/uut/ID_STAGE/o_ctr_jal
add wave -noupdate -group id /tb_random_mem/uut/ID_STAGE/o_ctr_signed_ld
add wave -noupdate -group id /tb_random_mem/uut/ID_STAGE/o_rf_rs1
add wave -noupdate -group id /tb_random_mem/uut/ID_STAGE/o_rf_rs2
add wave -noupdate -group id /tb_random_mem/uut/ID_STAGE/o_rf_dreg
add wave -noupdate -group id /tb_random_mem/uut/ID_STAGE/o_rf_reg1
add wave -noupdate -group id /tb_random_mem/uut/ID_STAGE/o_rf_reg2
add wave -noupdate -group id /tb_random_mem/uut/ID_STAGE/o_immediate
add wave -noupdate -group id /tb_random_mem/uut/ID_STAGE/w_reg1
add wave -noupdate -group id /tb_random_mem/uut/ID_STAGE/w_reg2
add wave -noupdate -group id /tb_random_mem/uut/ID_STAGE/w_registerwrite
add wave -noupdate -group id /tb_random_mem/uut/ID_STAGE/w_alusrc1
add wave -noupdate -group id /tb_random_mem/uut/ID_STAGE/w_alusrc2
add wave -noupdate -group id /tb_random_mem/uut/ID_STAGE/w_ctr_branch
add wave -noupdate -group id /tb_random_mem/uut/ID_STAGE/w_ctr_mem_reg
add wave -noupdate -group id /tb_random_mem/uut/ID_STAGE/w_ctr_wren_dm
add wave -noupdate -group id /tb_random_mem/uut/ID_STAGE/w_ctr_request_dm
add wave -noupdate -group id /tb_random_mem/uut/ID_STAGE/w_ctr_jalr_mux
add wave -noupdate -group id /tb_random_mem/uut/ID_STAGE/w_ctr_lui_mux
add wave -noupdate -group id /tb_random_mem/uut/ID_STAGE/w_ctr_jal_muxtorf
add wave -noupdate -group id /tb_random_mem/uut/ID_STAGE/w_ctr_signed
add wave -noupdate -group id /tb_random_mem/uut/ID_STAGE/w_ctr_tipo_i_s_sb
add wave -noupdate -group id /tb_random_mem/uut/ID_STAGE/w_ctr_tipo_u_uj
add wave -noupdate -group id /tb_random_mem/uut/ID_STAGE/w_ctr_U_UJ_I_mux
add wave -noupdate -group id /tb_random_mem/uut/ID_STAGE/w_ctr_muxfinale
add wave -noupdate -group id /tb_random_mem/uut/ID_STAGE/w_ctr_addsub
add wave -noupdate -group id /tb_random_mem/uut/ID_STAGE/w_ctr_signed_ld
add wave -noupdate -group id /tb_random_mem/uut/ID_STAGE/w_ctr_alu_op
add wave -noupdate -group id /tb_random_mem/uut/ID_STAGE/w_ctr_comp_op
add wave -noupdate -group id /tb_random_mem/uut/ID_STAGE/w_addr_r1
add wave -noupdate -group id /tb_random_mem/uut/ID_STAGE/w_addr_r2
add wave -noupdate -group id /tb_random_mem/uut/ID_STAGE/w_valid_instr
add wave -noupdate -group id /tb_random_mem/uut/ID_STAGE/w_mux_out
add wave -noupdate -group id /tb_random_mem/uut/ID_STAGE/w_opcode
add wave -noupdate -group id /tb_random_mem/uut/ID_STAGE/w_funct3
add wave -noupdate -group id /tb_random_mem/uut/ID_STAGE/w_funct7
add wave -noupdate -group id /tb_random_mem/uut/ID_STAGE/w_sel_cu
add wave -noupdate -group pp_id_exe -radix hexadecimal /tb_random_mem/uut/ID_EX_PP/clk
add wave -noupdate -group pp_id_exe -radix hexadecimal /tb_random_mem/uut/ID_EX_PP/rstn
add wave -noupdate -group pp_id_exe -radix hexadecimal /tb_random_mem/uut/ID_EX_PP/enable
add wave -noupdate -group pp_id_exe -radix hexadecimal /tb_random_mem/uut/ID_EX_PP/flusher
add wave -noupdate -group pp_id_exe -radix hexadecimal /tb_random_mem/uut/ID_EX_PP/i_predict_taken
add wave -noupdate -group pp_id_exe -radix hexadecimal /tb_random_mem/uut/ID_EX_PP/i_instr_valid
add wave -noupdate -group pp_id_exe -radix hexadecimal /tb_random_mem/uut/ID_EX_PP/i_debug_instr
add wave -noupdate -group pp_id_exe -radix hexadecimal /tb_random_mem/uut/ID_EX_PP/i_current_pc
add wave -noupdate -group pp_id_exe -radix hexadecimal /tb_random_mem/uut/ID_EX_PP/i_past_pc
add wave -noupdate -group pp_id_exe -radix hexadecimal /tb_random_mem/uut/ID_EX_PP/i_opcode
add wave -noupdate -group pp_id_exe -radix hexadecimal /tb_random_mem/uut/ID_EX_PP/i_ctr_req_dm
add wave -noupdate -group pp_id_exe -radix hexadecimal /tb_random_mem/uut/ID_EX_PP/i_rf_write
add wave -noupdate -group pp_id_exe -radix hexadecimal /tb_random_mem/uut/ID_EX_PP/i_alu_src1
add wave -noupdate -group pp_id_exe -radix hexadecimal /tb_random_mem/uut/ID_EX_PP/i_alu_src2
add wave -noupdate -group pp_id_exe -radix hexadecimal /tb_random_mem/uut/ID_EX_PP/i_CTR_branch
add wave -noupdate -group pp_id_exe -radix hexadecimal /tb_random_mem/uut/ID_EX_PP/i_ctr_comp_op
add wave -noupdate -group pp_id_exe -radix hexadecimal /tb_random_mem/uut/ID_EX_PP/i_MemWrite
add wave -noupdate -group pp_id_exe -radix hexadecimal /tb_random_mem/uut/ID_EX_PP/i_ctr_signed
add wave -noupdate -group pp_id_exe -radix hexadecimal /tb_random_mem/uut/ID_EX_PP/i_ctr_jalr
add wave -noupdate -group pp_id_exe -radix hexadecimal /tb_random_mem/uut/ID_EX_PP/i_ctr_LUI
add wave -noupdate -group pp_id_exe -radix hexadecimal /tb_random_mem/uut/ID_EX_PP/i_ctr_JAL
add wave -noupdate -group pp_id_exe -radix hexadecimal /tb_random_mem/uut/ID_EX_PP/i_ctr_U_UJ_I
add wave -noupdate -group pp_id_exe -radix hexadecimal /tb_random_mem/uut/ID_EX_PP/i_ctr_addsub
add wave -noupdate -group pp_id_exe -radix hexadecimal /tb_random_mem/uut/ID_EX_PP/i_ctr_signed_ld
add wave -noupdate -group pp_id_exe -radix hexadecimal /tb_random_mem/uut/ID_EX_PP/Rs1Addx_in
add wave -noupdate -group pp_id_exe -radix hexadecimal /tb_random_mem/uut/ID_EX_PP/Rs2Addx_in
add wave -noupdate -group pp_id_exe -radix hexadecimal /tb_random_mem/uut/ID_EX_PP/DrAddx_in
add wave -noupdate -group pp_id_exe -radix hexadecimal /tb_random_mem/uut/ID_EX_PP/i_Reg1
add wave -noupdate -group pp_id_exe -radix hexadecimal /tb_random_mem/uut/ID_EX_PP/i_Reg2
add wave -noupdate -group pp_id_exe -radix hexadecimal /tb_random_mem/uut/ID_EX_PP/i_Immediate
add wave -noupdate -group pp_id_exe -radix hexadecimal /tb_random_mem/uut/ID_EX_PP/i_ctr_alu_op
add wave -noupdate -group pp_id_exe -radix hexadecimal /tb_random_mem/uut/ID_EX_PP/o_predict_taken
add wave -noupdate -group pp_id_exe -radix hexadecimal /tb_random_mem/uut/ID_EX_PP/o_instr_valid
add wave -noupdate -group pp_id_exe -radix hexadecimal /tb_random_mem/uut/ID_EX_PP/o_debug_instr
add wave -noupdate -group pp_id_exe -radix hexadecimal /tb_random_mem/uut/ID_EX_PP/o_opcode
add wave -noupdate -group pp_id_exe -radix hexadecimal /tb_random_mem/uut/ID_EX_PP/o_current_pc
add wave -noupdate -group pp_id_exe -radix hexadecimal /tb_random_mem/uut/ID_EX_PP/o_past_pc
add wave -noupdate -group pp_id_exe -radix hexadecimal /tb_random_mem/uut/ID_EX_PP/o_alu_src1
add wave -noupdate -group pp_id_exe -radix hexadecimal /tb_random_mem/uut/ID_EX_PP/o_alu_src2
add wave -noupdate -group pp_id_exe -radix hexadecimal /tb_random_mem/uut/ID_EX_PP/o_ctr_addsub
add wave -noupdate -group pp_id_exe -radix hexadecimal /tb_random_mem/uut/ID_EX_PP/o_rf_write
add wave -noupdate -group pp_id_exe -radix hexadecimal /tb_random_mem/uut/ID_EX_PP/o_ctr_branch
add wave -noupdate -group pp_id_exe -radix hexadecimal /tb_random_mem/uut/ID_EX_PP/o_MemWrite
add wave -noupdate -group pp_id_exe -radix hexadecimal /tb_random_mem/uut/ID_EX_PP/o_ctr_comp_op
add wave -noupdate -group pp_id_exe -radix hexadecimal /tb_random_mem/uut/ID_EX_PP/o_ctr_signed
add wave -noupdate -group pp_id_exe -radix hexadecimal /tb_random_mem/uut/ID_EX_PP/o_ctr_jalr
add wave -noupdate -group pp_id_exe -radix hexadecimal /tb_random_mem/uut/ID_EX_PP/o_ctr_LUI
add wave -noupdate -group pp_id_exe -radix hexadecimal /tb_random_mem/uut/ID_EX_PP/o_ctr_JAL
add wave -noupdate -group pp_id_exe -radix hexadecimal /tb_random_mem/uut/ID_EX_PP/o_ctr_req_dm
add wave -noupdate -group pp_id_exe -radix hexadecimal /tb_random_mem/uut/ID_EX_PP/o_ctr_U_UJ_I
add wave -noupdate -group pp_id_exe -radix hexadecimal /tb_random_mem/uut/ID_EX_PP/o_ctr_signed_ld
add wave -noupdate -group pp_id_exe -radix hexadecimal /tb_random_mem/uut/ID_EX_PP/Rs1Addx_out
add wave -noupdate -group pp_id_exe -radix hexadecimal /tb_random_mem/uut/ID_EX_PP/Rs2Addx_out
add wave -noupdate -group pp_id_exe -radix hexadecimal /tb_random_mem/uut/ID_EX_PP/DrAddx_out
add wave -noupdate -group pp_id_exe -radix hexadecimal /tb_random_mem/uut/ID_EX_PP/o_Reg1
add wave -noupdate -group pp_id_exe -radix hexadecimal /tb_random_mem/uut/ID_EX_PP/o_Reg2
add wave -noupdate -group pp_id_exe -radix hexadecimal /tb_random_mem/uut/ID_EX_PP/o_Immediate
add wave -noupdate -group pp_id_exe -radix hexadecimal /tb_random_mem/uut/ID_EX_PP/o_ctr_alu_op
add wave -noupdate -group pp_id_exe -radix hexadecimal /tb_random_mem/uut/ID_EX_PP/r_CURRENT_PC
add wave -noupdate -group pp_id_exe -radix hexadecimal /tb_random_mem/uut/ID_EX_PP/r_PAST_PC
add wave -noupdate -group pp_id_exe -radix hexadecimal /tb_random_mem/uut/ID_EX_PP/r_OPCODE
add wave -noupdate -group pp_id_exe -radix hexadecimal /tb_random_mem/uut/ID_EX_PP/r_RegisterWrite
add wave -noupdate -group pp_id_exe -radix hexadecimal /tb_random_mem/uut/ID_EX_PP/r_signed_ld
add wave -noupdate -group pp_id_exe -radix hexadecimal /tb_random_mem/uut/ID_EX_PP/r_ALUsrc1
add wave -noupdate -group pp_id_exe -radix hexadecimal /tb_random_mem/uut/ID_EX_PP/r_ALUsrc2
add wave -noupdate -group pp_id_exe -radix hexadecimal /tb_random_mem/uut/ID_EX_PP/r_addsub
add wave -noupdate -group pp_id_exe -radix hexadecimal /tb_random_mem/uut/ID_EX_PP/r_alu_op
add wave -noupdate -group pp_id_exe -radix hexadecimal /tb_random_mem/uut/ID_EX_PP/r_CTR_branch
add wave -noupdate -group pp_id_exe -radix hexadecimal /tb_random_mem/uut/ID_EX_PP/r_MemWrite
add wave -noupdate -group pp_id_exe -radix hexadecimal /tb_random_mem/uut/ID_EX_PP/r_CTR_signed
add wave -noupdate -group pp_id_exe -radix hexadecimal /tb_random_mem/uut/ID_EX_PP/r_CTR_jalr
add wave -noupdate -group pp_id_exe -radix hexadecimal /tb_random_mem/uut/ID_EX_PP/r_CTR_LUI
add wave -noupdate -group pp_id_exe -radix hexadecimal /tb_random_mem/uut/ID_EX_PP/r_ctr_req_dm
add wave -noupdate -group pp_id_exe -radix hexadecimal /tb_random_mem/uut/ID_EX_PP/r_instr_valid
add wave -noupdate -group pp_id_exe -radix hexadecimal /tb_random_mem/uut/ID_EX_PP/r_CTR_JAL
add wave -noupdate -group pp_id_exe -radix hexadecimal /tb_random_mem/uut/ID_EX_PP/r_forward_enable
add wave -noupdate -group pp_id_exe -radix hexadecimal /tb_random_mem/uut/ID_EX_PP/r_ctr_U_UJ_I
add wave -noupdate -group pp_id_exe -radix hexadecimal /tb_random_mem/uut/ID_EX_PP/r_predict_taken
add wave -noupdate -group pp_id_exe -radix hexadecimal /tb_random_mem/uut/ID_EX_PP/r_ctr_comp_op
add wave -noupdate -group pp_id_exe -radix hexadecimal /tb_random_mem/uut/ID_EX_PP/r_Rs1Addx
add wave -noupdate -group pp_id_exe -radix hexadecimal /tb_random_mem/uut/ID_EX_PP/r_Rs2Addx
add wave -noupdate -group pp_id_exe -radix hexadecimal /tb_random_mem/uut/ID_EX_PP/r_DrAddx
add wave -noupdate -group pp_id_exe -radix hexadecimal /tb_random_mem/uut/ID_EX_PP/r_Reg1
add wave -noupdate -group pp_id_exe -radix hexadecimal /tb_random_mem/uut/ID_EX_PP/r_Reg2
add wave -noupdate -group pp_id_exe /tb_random_mem/uut/ID_EX_PP/r_Immediate
add wave -noupdate -color Yellow -radix hexadecimal /tb_random_mem/uut/ID_EX_PP/r_debug_instr
add wave -noupdate -expand -group exe /tb_random_mem/uut/EXE_STAGE/ctr_alu_op
add wave -noupdate -expand -group exe /tb_random_mem/uut/EXE_STAGE/ctr_addsub
add wave -noupdate -expand -group exe /tb_random_mem/uut/EXE_STAGE/ctr_alu_src1
add wave -noupdate -expand -group exe /tb_random_mem/uut/EXE_STAGE/ctr_alu_src2
add wave -noupdate -expand -group exe /tb_random_mem/uut/EXE_STAGE/ctr_comp_op
add wave -noupdate -expand -group exe /tb_random_mem/uut/EXE_STAGE/ctr_branch
add wave -noupdate -expand -group exe /tb_random_mem/uut/EXE_STAGE/i_ctr_jalr
add wave -noupdate -expand -group exe /tb_random_mem/uut/EXE_STAGE/i_ctr_jal
add wave -noupdate -expand -group exe -radix hexadecimal /tb_random_mem/uut/EXE_STAGE/i_next_pc
add wave -noupdate -expand -group exe -radix hexadecimal /tb_random_mem/uut/EXE_STAGE/i_prediction_taken
add wave -noupdate -expand -group exe -radix hexadecimal /tb_random_mem/uut/EXE_STAGE/haz_lui
add wave -noupdate -expand -group exe -radix hexadecimal /tb_random_mem/uut/EXE_STAGE/i_fu_sel1
add wave -noupdate -expand -group exe -radix hexadecimal /tb_random_mem/uut/EXE_STAGE/i_fu_sel2
add wave -noupdate -expand -group exe -radix hexadecimal /tb_random_mem/uut/EXE_STAGE/rd1_i
add wave -noupdate -expand -group exe -radix hexadecimal /tb_random_mem/uut/EXE_STAGE/rd2_i
add wave -noupdate -expand -group exe -radix hexadecimal /tb_random_mem/uut/EXE_STAGE/immediate_i
add wave -noupdate -expand -group exe -radix hexadecimal /tb_random_mem/uut/EXE_STAGE/current_pc_i
add wave -noupdate -expand -group exe -radix hexadecimal /tb_random_mem/uut/EXE_STAGE/alu_res_mem_i
add wave -noupdate -expand -group exe -radix hexadecimal /tb_random_mem/uut/EXE_STAGE/i_immediate_mem
add wave -noupdate -expand -group exe -radix hexadecimal /tb_random_mem/uut/EXE_STAGE/wb_muxer_i
add wave -noupdate -expand -group exe -radix hexadecimal /tb_random_mem/uut/EXE_STAGE/o_misprediction
add wave -noupdate -expand -group exe -radix hexadecimal /tb_random_mem/uut/EXE_STAGE/o_target_jump
add wave -noupdate -expand -group exe -radix hexadecimal /tb_random_mem/uut/EXE_STAGE/o_rs2_exe
add wave -noupdate -expand -group exe -radix hexadecimal /tb_random_mem/uut/EXE_STAGE/alu_res_o
add wave -noupdate -expand -group exe -radix hexadecimal /tb_random_mem/uut/EXE_STAGE/w_alu_src1
add wave -noupdate -expand -group exe -radix hexadecimal /tb_random_mem/uut/EXE_STAGE/w_alu_src2
add wave -noupdate -expand -group exe -radix hexadecimal /tb_random_mem/uut/EXE_STAGE/w_mux_fu1
add wave -noupdate -expand -group exe -radix hexadecimal /tb_random_mem/uut/EXE_STAGE/w_mux_fu2
add wave -noupdate -expand -group exe -radix hexadecimal /tb_random_mem/uut/EXE_STAGE/w_mux_alu_src1
add wave -noupdate -expand -group exe -radix hexadecimal /tb_random_mem/uut/EXE_STAGE/w_target_jmp
add wave -noupdate -expand -group exe -radix hexadecimal /tb_random_mem/uut/EXE_STAGE/w_alu_res
add wave -noupdate -expand -group exe -radix hexadecimal /tb_random_mem/uut/EXE_STAGE/w_shifted_imm
add wave -noupdate -expand -group exe -radix hexadecimal /tb_random_mem/uut/EXE_STAGE/w_addsub_res
add wave -noupdate -expand -group exe /tb_random_mem/uut/EXE_STAGE/jump_instruction
add wave -noupdate -expand -group exe /tb_random_mem/uut/EXE_STAGE/w_jump_taken
add wave -noupdate -expand -group exe /tb_random_mem/uut/EXE_STAGE/w_branch
add wave -noupdate -expand -group exe -radix hexadecimal /tb_random_mem/uut/EXE_STAGE/w_pc_jump
add wave -noupdate -group pp_ex_mem /tb_random_mem/uut/EX_MEM_PP/clk
add wave -noupdate -group pp_ex_mem /tb_random_mem/uut/EX_MEM_PP/rstn
add wave -noupdate -group pp_ex_mem /tb_random_mem/uut/EX_MEM_PP/enable
add wave -noupdate -group pp_ex_mem /tb_random_mem/uut/EX_MEM_PP/i_instr_valid
add wave -noupdate -group pp_ex_mem /tb_random_mem/uut/EX_MEM_PP/i_debug_instr
add wave -noupdate -group pp_ex_mem /tb_random_mem/uut/EX_MEM_PP/dReg_in
add wave -noupdate -group pp_ex_mem /tb_random_mem/uut/EX_MEM_PP/i_Immediate
add wave -noupdate -group pp_ex_mem /tb_random_mem/uut/EX_MEM_PP/ALUres_in
add wave -noupdate -group pp_ex_mem /tb_random_mem/uut/EX_MEM_PP/i_rf_reg2
add wave -noupdate -group pp_ex_mem /tb_random_mem/uut/EX_MEM_PP/i_request_dm
add wave -noupdate -group pp_ex_mem /tb_random_mem/uut/EX_MEM_PP/i_addr_dm
add wave -noupdate -group pp_ex_mem /tb_random_mem/uut/EX_MEM_PP/i_wren_dm
add wave -noupdate -group pp_ex_mem /tb_random_mem/uut/EX_MEM_PP/i_CTR_LUI
add wave -noupdate -group pp_ex_mem /tb_random_mem/uut/EX_MEM_PP/CTR_branch_in
add wave -noupdate -group pp_ex_mem /tb_random_mem/uut/EX_MEM_PP/i_CTR_jal_muxRF
add wave -noupdate -group pp_ex_mem /tb_random_mem/uut/EX_MEM_PP/i_CTR_JALR
add wave -noupdate -group pp_ex_mem /tb_random_mem/uut/EX_MEM_PP/i_CTR_RFwrite
add wave -noupdate -group pp_ex_mem /tb_random_mem/uut/EX_MEM_PP/i_ctr_signed
add wave -noupdate -group pp_ex_mem /tb_random_mem/uut/EX_MEM_PP/i_ctr_signed_ld
add wave -noupdate -group pp_ex_mem /tb_random_mem/uut/EX_MEM_PP/i_ctr_size_dm
add wave -noupdate -group pp_ex_mem /tb_random_mem/uut/EX_MEM_PP/i_pc_current
add wave -noupdate -group pp_ex_mem /tb_random_mem/uut/EX_MEM_PP/o_instr_valid
add wave -noupdate -group pp_ex_mem /tb_random_mem/uut/EX_MEM_PP/o_debug_instr
add wave -noupdate -group pp_ex_mem /tb_random_mem/uut/EX_MEM_PP/o_request_dm
add wave -noupdate -group pp_ex_mem /tb_random_mem/uut/EX_MEM_PP/o_wren_dm
add wave -noupdate -group pp_ex_mem /tb_random_mem/uut/EX_MEM_PP/o_Immediate
add wave -noupdate -group pp_ex_mem /tb_random_mem/uut/EX_MEM_PP/dreg_out
add wave -noupdate -group pp_ex_mem /tb_random_mem/uut/EX_MEM_PP/o_addr_dm
add wave -noupdate -group pp_ex_mem /tb_random_mem/uut/EX_MEM_PP/ALUres_out
add wave -noupdate -group pp_ex_mem /tb_random_mem/uut/EX_MEM_PP/o_rf_reg2
add wave -noupdate -group pp_ex_mem /tb_random_mem/uut/EX_MEM_PP/o_pc_current
add wave -noupdate -group pp_ex_mem /tb_random_mem/uut/EX_MEM_PP/o_ctr_signed_ld
add wave -noupdate -group pp_ex_mem /tb_random_mem/uut/EX_MEM_PP/CTR_branch_out
add wave -noupdate -group pp_ex_mem /tb_random_mem/uut/EX_MEM_PP/o_CTR_jal_muxRF
add wave -noupdate -group pp_ex_mem /tb_random_mem/uut/EX_MEM_PP/o_CTR_JALR
add wave -noupdate -group pp_ex_mem /tb_random_mem/uut/EX_MEM_PP/o_CTR_LUI
add wave -noupdate -group pp_ex_mem /tb_random_mem/uut/EX_MEM_PP/o_CTR_RFwrite
add wave -noupdate -group pp_ex_mem /tb_random_mem/uut/EX_MEM_PP/o_ctr_signed
add wave -noupdate -group pp_ex_mem /tb_random_mem/uut/EX_MEM_PP/o_ctr_size_dm
add wave -noupdate -group pp_ex_mem /tb_random_mem/uut/EX_MEM_PP/r_signed_ld
add wave -noupdate -group pp_ex_mem /tb_random_mem/uut/EX_MEM_PP/r_destination
add wave -noupdate -group pp_ex_mem /tb_random_mem/uut/EX_MEM_PP/r_Immediate
add wave -noupdate -group pp_ex_mem /tb_random_mem/uut/EX_MEM_PP/r_ALUres
add wave -noupdate -group pp_ex_mem /tb_random_mem/uut/EX_MEM_PP/r_JALres
add wave -noupdate -group pp_ex_mem /tb_random_mem/uut/EX_MEM_PP/r_PC_plus_4
add wave -noupdate -group pp_ex_mem /tb_random_mem/uut/EX_MEM_PP/r_addr_dm
add wave -noupdate -group pp_ex_mem /tb_random_mem/uut/EX_MEM_PP/r_rf_reg2
add wave -noupdate -group pp_ex_mem /tb_random_mem/uut/EX_MEM_PP/r_CTR_LUI
add wave -noupdate -group pp_ex_mem /tb_random_mem/uut/EX_MEM_PP/r_CTR_branch
add wave -noupdate -group pp_ex_mem /tb_random_mem/uut/EX_MEM_PP/r_CTR_jal_muxRF
add wave -noupdate -group pp_ex_mem /tb_random_mem/uut/EX_MEM_PP/r_CTR_JALR
add wave -noupdate -group pp_ex_mem /tb_random_mem/uut/EX_MEM_PP/r_CTR_RFwrite
add wave -noupdate -group pp_ex_mem /tb_random_mem/uut/EX_MEM_PP/r_wren_dm
add wave -noupdate -group pp_ex_mem /tb_random_mem/uut/EX_MEM_PP/r_request_dm
add wave -noupdate -group pp_ex_mem /tb_random_mem/uut/EX_MEM_PP/r_ctr_signed
add wave -noupdate -group pp_ex_mem /tb_random_mem/uut/EX_MEM_PP/r_ctr_size_dm
add wave -noupdate -group pp_ex_mem /tb_random_mem/uut/EX_MEM_PP/r_instr_valid
add wave -noupdate -color Yellow -radix hexadecimal /tb_random_mem/uut/EX_MEM_PP/r_debug_instr
add wave -noupdate -group mem /tb_random_mem/uut/MEM_STAGE/clk
add wave -noupdate -group mem /tb_random_mem/uut/MEM_STAGE/rst_n
add wave -noupdate -group mem /tb_random_mem/uut/MEM_STAGE/i_ctr_jalr
add wave -noupdate -group mem /tb_random_mem/uut/MEM_STAGE/i_ctr_jal
add wave -noupdate -group mem /tb_random_mem/uut/MEM_STAGE/i_ctr_branch
add wave -noupdate -group mem /tb_random_mem/uut/MEM_STAGE/i_ctr_size_access
add wave -noupdate -group mem /tb_random_mem/uut/MEM_STAGE/i_ctr_signed_ld
add wave -noupdate -group mem /tb_random_mem/uut/MEM_STAGE/i_Alu_result_MEM
add wave -noupdate -group mem /tb_random_mem/uut/MEM_STAGE/dm_rdata_i
add wave -noupdate -group mem /tb_random_mem/uut/MEM_STAGE/dm_wdata_i
add wave -noupdate -group mem /tb_random_mem/uut/MEM_STAGE/dm_req_i
add wave -noupdate -group mem /tb_random_mem/uut/MEM_STAGE/dm_we_i
add wave -noupdate -group mem /tb_random_mem/uut/MEM_STAGE/dm_ready_i
add wave -noupdate -group mem /tb_random_mem/uut/MEM_STAGE/dm_valid_i
add wave -noupdate -group mem /tb_random_mem/uut/MEM_STAGE/dm_wdata_o
add wave -noupdate -group mem /tb_random_mem/uut/MEM_STAGE/dm_req_o
add wave -noupdate -group mem /tb_random_mem/uut/MEM_STAGE/dm_we_o
add wave -noupdate -group mem /tb_random_mem/uut/MEM_STAGE/dm_byte_enable_o
add wave -noupdate -group mem /tb_random_mem/uut/MEM_STAGE/data_to_wb_o
add wave -noupdate -group mem /tb_random_mem/uut/MEM_STAGE/dm_addx_o
add wave -noupdate -group mem /tb_random_mem/uut/MEM_STAGE/current_state
add wave -noupdate -group mem /tb_random_mem/uut/MEM_STAGE/next_state
add wave -noupdate -group mem /tb_random_mem/uut/MEM_STAGE/ctr_lw
add wave -noupdate -group mem /tb_random_mem/uut/MEM_STAGE/dm_rdata
add wave -noupdate -group pp?mem?wb -radix hexadecimal /tb_random_mem/uut/MEM_WB_PP/clk
add wave -noupdate -group pp?mem?wb -radix hexadecimal /tb_random_mem/uut/MEM_WB_PP/reset_n
add wave -noupdate -group pp?mem?wb -radix hexadecimal /tb_random_mem/uut/MEM_WB_PP/enable
add wave -noupdate -group pp?mem?wb -radix hexadecimal /tb_random_mem/uut/MEM_WB_PP/i_debug_instr
add wave -noupdate -group pp?mem?wb -radix hexadecimal /tb_random_mem/uut/MEM_WB_PP/i_instr_valid
add wave -noupdate -group pp?mem?wb -radix hexadecimal /tb_random_mem/uut/MEM_WB_PP/i_ctr_rf_write_mem
add wave -noupdate -group pp?mem?wb -radix hexadecimal /tb_random_mem/uut/MEM_WB_PP/i_ctr_lui_mem
add wave -noupdate -group pp?mem?wb -radix hexadecimal /tb_random_mem/uut/MEM_WB_PP/i_ctr_jal_mem
add wave -noupdate -group pp?mem?wb -radix hexadecimal /tb_random_mem/uut/MEM_WB_PP/i_pc_increment_mem
add wave -noupdate -group pp?mem?wb -radix hexadecimal /tb_random_mem/uut/MEM_WB_PP/i_data_dm_mem
add wave -noupdate -group pp?mem?wb -radix hexadecimal /tb_random_mem/uut/MEM_WB_PP/i_immediate_mem
add wave -noupdate -group pp?mem?wb -radix hexadecimal /tb_random_mem/uut/MEM_WB_PP/i_dr_mem
add wave -noupdate -group pp?mem?wb -radix hexadecimal /tb_random_mem/uut/MEM_WB_PP/o_instr_valid
add wave -noupdate -group pp?mem?wb -radix hexadecimal /tb_random_mem/uut/MEM_WB_PP/o_debug_instr
add wave -noupdate -group pp?mem?wb -radix hexadecimal /tb_random_mem/uut/MEM_WB_PP/o_ctr_rf_write_wb
add wave -noupdate -group pp?mem?wb -radix hexadecimal /tb_random_mem/uut/MEM_WB_PP/o_ctr_lui_wb
add wave -noupdate -group pp?mem?wb -radix hexadecimal /tb_random_mem/uut/MEM_WB_PP/o_ctr_jal_wb
add wave -noupdate -group pp?mem?wb -radix hexadecimal /tb_random_mem/uut/MEM_WB_PP/o_pc_increment_wb
add wave -noupdate -group pp?mem?wb -radix hexadecimal /tb_random_mem/uut/MEM_WB_PP/o_data_dm_wb
add wave -noupdate -group pp?mem?wb -radix hexadecimal /tb_random_mem/uut/MEM_WB_PP/o_immediate_wb
add wave -noupdate -group pp?mem?wb -radix hexadecimal /tb_random_mem/uut/MEM_WB_PP/o_dr_mem
add wave -noupdate -group pp?mem?wb -radix hexadecimal /tb_random_mem/uut/MEM_WB_PP/r_RegisterWrite
add wave -noupdate -group pp?mem?wb -radix hexadecimal /tb_random_mem/uut/MEM_WB_PP/r_CTR_LUI_mux
add wave -noupdate -group pp?mem?wb -radix hexadecimal /tb_random_mem/uut/MEM_WB_PP/r_CTR_JAL_muxtoRF
add wave -noupdate -group pp?mem?wb -radix hexadecimal /tb_random_mem/uut/MEM_WB_PP/r_ALUresult
add wave -noupdate -group pp?mem?wb -radix hexadecimal /tb_random_mem/uut/MEM_WB_PP/r_DoutDM
add wave -noupdate -group pp?mem?wb -radix hexadecimal /tb_random_mem/uut/MEM_WB_PP/r_Immediate
add wave -noupdate -group pp?mem?wb -radix hexadecimal /tb_random_mem/uut/MEM_WB_PP/r_dr
add wave -noupdate -radix hexadecimal /tb_random_mem/uut/MEM_WB_PP/r_instr_valid
add wave -noupdate -color Yellow -radix hexadecimal /tb_random_mem/uut/MEM_WB_PP/r_debug_instr
add wave -noupdate -radix hexadecimal /tb_random_mem/uut/MEM_WB_PP/r_PCincrement
add wave -noupdate -group wb /tb_random_mem/uut/WB_STAGE/i_dato_mem
add wave -noupdate -group wb /tb_random_mem/uut/WB_STAGE/i_ctr_lui
add wave -noupdate -group wb /tb_random_mem/uut/WB_STAGE/i_ctr_jal
add wave -noupdate -group wb /tb_random_mem/uut/WB_STAGE/i_next_pc
add wave -noupdate -group wb /tb_random_mem/uut/WB_STAGE/i_immediate
add wave -noupdate -group wb /tb_random_mem/uut/WB_STAGE/o_wdata_rf
add wave -noupdate -group wb /tb_random_mem/uut/WB_STAGE/w_wb_muxer
add wave -noupdate -group wb /tb_random_mem/uut/WB_STAGE/w_sel_output
add wave -noupdate -expand -group RF /tb_random_mem/uut/ID_STAGE/RF/clk
add wave -noupdate -expand -group RF /tb_random_mem/uut/ID_STAGE/RF/wr_enable
add wave -noupdate -expand -group RF /tb_random_mem/uut/ID_STAGE/RF/readAddr1
add wave -noupdate -expand -group RF /tb_random_mem/uut/ID_STAGE/RF/readAddr2
add wave -noupdate -expand -group RF /tb_random_mem/uut/ID_STAGE/RF/writeAddr
add wave -noupdate -expand -group RF /tb_random_mem/uut/ID_STAGE/RF/writeData
add wave -noupdate -expand -group RF /tb_random_mem/uut/ID_STAGE/RF/readData1
add wave -noupdate -expand -group RF /tb_random_mem/uut/ID_STAGE/RF/readData2
add wave -noupdate -expand -group RF /tb_random_mem/uut/ID_STAGE/RF/en_addr_0
add wave -noupdate -expand -group RF -childformat {{/tb_random_mem/uut/ID_STAGE/RF/registers(0) -radix hexadecimal} {/tb_random_mem/uut/ID_STAGE/RF/registers(1) -radix hexadecimal} {/tb_random_mem/uut/ID_STAGE/RF/registers(2) -radix hexadecimal} {/tb_random_mem/uut/ID_STAGE/RF/registers(3) -radix hexadecimal} {/tb_random_mem/uut/ID_STAGE/RF/registers(4) -radix hexadecimal} {/tb_random_mem/uut/ID_STAGE/RF/registers(5) -radix hexadecimal} {/tb_random_mem/uut/ID_STAGE/RF/registers(6) -radix hexadecimal} {/tb_random_mem/uut/ID_STAGE/RF/registers(7) -radix hexadecimal} {/tb_random_mem/uut/ID_STAGE/RF/registers(8) -radix hexadecimal} {/tb_random_mem/uut/ID_STAGE/RF/registers(9) -radix hexadecimal} {/tb_random_mem/uut/ID_STAGE/RF/registers(10) -radix hexadecimal} {/tb_random_mem/uut/ID_STAGE/RF/registers(11) -radix hexadecimal} {/tb_random_mem/uut/ID_STAGE/RF/registers(12) -radix hexadecimal} {/tb_random_mem/uut/ID_STAGE/RF/registers(13) -radix hexadecimal} {/tb_random_mem/uut/ID_STAGE/RF/registers(14) -radix hexadecimal} {/tb_random_mem/uut/ID_STAGE/RF/registers(15) -radix hexadecimal} {/tb_random_mem/uut/ID_STAGE/RF/registers(16) -radix hexadecimal} {/tb_random_mem/uut/ID_STAGE/RF/registers(17) -radix hexadecimal} {/tb_random_mem/uut/ID_STAGE/RF/registers(18) -radix hexadecimal} {/tb_random_mem/uut/ID_STAGE/RF/registers(19) -radix hexadecimal} {/tb_random_mem/uut/ID_STAGE/RF/registers(20) -radix hexadecimal} {/tb_random_mem/uut/ID_STAGE/RF/registers(21) -radix hexadecimal} {/tb_random_mem/uut/ID_STAGE/RF/registers(22) -radix hexadecimal} {/tb_random_mem/uut/ID_STAGE/RF/registers(23) -radix hexadecimal} {/tb_random_mem/uut/ID_STAGE/RF/registers(24) -radix hexadecimal} {/tb_random_mem/uut/ID_STAGE/RF/registers(25) -radix hexadecimal} {/tb_random_mem/uut/ID_STAGE/RF/registers(26) -radix hexadecimal} {/tb_random_mem/uut/ID_STAGE/RF/registers(27) -radix hexadecimal} {/tb_random_mem/uut/ID_STAGE/RF/registers(28) -radix hexadecimal} {/tb_random_mem/uut/ID_STAGE/RF/registers(29) -radix hexadecimal} {/tb_random_mem/uut/ID_STAGE/RF/registers(30) -radix hexadecimal} {/tb_random_mem/uut/ID_STAGE/RF/registers(31) -radix hexadecimal}} -expand -subitemconfig {/tb_random_mem/uut/ID_STAGE/RF/registers(0) {-radix hexadecimal} /tb_random_mem/uut/ID_STAGE/RF/registers(1) {-radix hexadecimal} /tb_random_mem/uut/ID_STAGE/RF/registers(2) {-radix hexadecimal} /tb_random_mem/uut/ID_STAGE/RF/registers(3) {-radix hexadecimal} /tb_random_mem/uut/ID_STAGE/RF/registers(4) {-radix hexadecimal} /tb_random_mem/uut/ID_STAGE/RF/registers(5) {-radix hexadecimal} /tb_random_mem/uut/ID_STAGE/RF/registers(6) {-radix hexadecimal} /tb_random_mem/uut/ID_STAGE/RF/registers(7) {-radix hexadecimal} /tb_random_mem/uut/ID_STAGE/RF/registers(8) {-radix hexadecimal} /tb_random_mem/uut/ID_STAGE/RF/registers(9) {-radix hexadecimal} /tb_random_mem/uut/ID_STAGE/RF/registers(10) {-radix hexadecimal} /tb_random_mem/uut/ID_STAGE/RF/registers(11) {-radix hexadecimal} /tb_random_mem/uut/ID_STAGE/RF/registers(12) {-radix hexadecimal} /tb_random_mem/uut/ID_STAGE/RF/registers(13) {-radix hexadecimal} /tb_random_mem/uut/ID_STAGE/RF/registers(14) {-radix hexadecimal} /tb_random_mem/uut/ID_STAGE/RF/registers(15) {-radix hexadecimal} /tb_random_mem/uut/ID_STAGE/RF/registers(16) {-radix hexadecimal} /tb_random_mem/uut/ID_STAGE/RF/registers(17) {-radix hexadecimal} /tb_random_mem/uut/ID_STAGE/RF/registers(18) {-radix hexadecimal} /tb_random_mem/uut/ID_STAGE/RF/registers(19) {-radix hexadecimal} /tb_random_mem/uut/ID_STAGE/RF/registers(20) {-radix hexadecimal} /tb_random_mem/uut/ID_STAGE/RF/registers(21) {-radix hexadecimal} /tb_random_mem/uut/ID_STAGE/RF/registers(22) {-radix hexadecimal} /tb_random_mem/uut/ID_STAGE/RF/registers(23) {-radix hexadecimal} /tb_random_mem/uut/ID_STAGE/RF/registers(24) {-radix hexadecimal} /tb_random_mem/uut/ID_STAGE/RF/registers(25) {-radix hexadecimal} /tb_random_mem/uut/ID_STAGE/RF/registers(26) {-radix hexadecimal} /tb_random_mem/uut/ID_STAGE/RF/registers(27) {-radix hexadecimal} /tb_random_mem/uut/ID_STAGE/RF/registers(28) {-radix hexadecimal} /tb_random_mem/uut/ID_STAGE/RF/registers(29) {-radix hexadecimal} /tb_random_mem/uut/ID_STAGE/RF/registers(30) {-radix hexadecimal} /tb_random_mem/uut/ID_STAGE/RF/registers(31) {-radix hexadecimal}} /tb_random_mem/uut/ID_STAGE/RF/registers
add wave -noupdate -group staller /tb_random_mem/uut/STALLER/clk
add wave -noupdate -group staller /tb_random_mem/uut/STALLER/rst_n
add wave -noupdate -group staller /tb_random_mem/uut/STALLER/request_dm
add wave -noupdate -group staller /tb_random_mem/uut/STALLER/valid
add wave -noupdate -group staller /tb_random_mem/uut/STALLER/block_pipe
add wave -noupdate -group staller /tb_random_mem/uut/STALLER/reg_stall
add wave -noupdate -group fu /tb_random_mem/uut/FORWARD_UNIT/writeback_prev
add wave -noupdate -group fu /tb_random_mem/uut/FORWARD_UNIT/i_ctr_U_UJ_I
add wave -noupdate -group fu /tb_random_mem/uut/FORWARD_UNIT/i_ctr_lui_prev
add wave -noupdate -group fu /tb_random_mem/uut/FORWARD_UNIT/writeback_pre_prev
add wave -noupdate -group fu /tb_random_mem/uut/FORWARD_UNIT/load_rd_prev
add wave -noupdate -group fu /tb_random_mem/uut/FORWARD_UNIT/load_rd_pre_prev
add wave -noupdate -group fu /tb_random_mem/uut/FORWARD_UNIT/exec_rs1
add wave -noupdate -group fu /tb_random_mem/uut/FORWARD_UNIT/exec_rs2
add wave -noupdate -group fu /tb_random_mem/uut/FORWARD_UNIT/forward_ctrl_rs1
add wave -noupdate -group fu /tb_random_mem/uut/FORWARD_UNIT/forward_ctrl_rs2
add wave -noupdate -group fu /tb_random_mem/uut/FORWARD_UNIT/w_ctr_rs1
add wave -noupdate -group fu /tb_random_mem/uut/FORWARD_UNIT/w_ctr_rs2
add wave -noupdate -group hdu /tb_random_mem/uut/HAZARD_DU/pipe_flush
add wave -noupdate -group hdu /tb_random_mem/uut/HAZARD_DU/previousInstr_op
add wave -noupdate -group hdu /tb_random_mem/uut/HAZARD_DU/load_rd
add wave -noupdate -group hdu /tb_random_mem/uut/HAZARD_DU/exec_rs1
add wave -noupdate -group hdu /tb_random_mem/uut/HAZARD_DU/exec_rs2
add wave -noupdate -group hdu /tb_random_mem/uut/HAZARD_DU/stall
add wave -noupdate -group flusher /tb_random_mem/uut/PIPE_FLUSHER/clk
add wave -noupdate -group flusher /tb_random_mem/uut/PIPE_FLUSHER/rst_n
add wave -noupdate -group flusher /tb_random_mem/uut/PIPE_FLUSHER/i_misprediction
add wave -noupdate -group flusher /tb_random_mem/uut/PIPE_FLUSHER/valid_im
add wave -noupdate -group flusher /tb_random_mem/uut/PIPE_FLUSHER/i_pc_enable
add wave -noupdate -group flusher /tb_random_mem/uut/PIPE_FLUSHER/i_pending_req
add wave -noupdate -group flusher /tb_random_mem/uut/PIPE_FLUSHER/flush
add wave -noupdate -group flusher /tb_random_mem/uut/PIPE_FLUSHER/reg_flush
add wave -noupdate -group flusher /tb_random_mem/uut/PIPE_FLUSHER/reg_stall
add wave -noupdate -expand -group bp /tb_random_mem/uut/bp/clk
add wave -noupdate -expand -group bp /tb_random_mem/uut/bp/rst_n
add wave -noupdate -expand -group bp -radix hexadecimal /tb_random_mem/uut/bp/pc
add wave -noupdate -expand -group bp -color Yellow -radix hexadecimal /tb_random_mem/uut/bp/predict_taken
add wave -noupdate -expand -group bp -color Yellow -radix hexadecimal /tb_random_mem/uut/bp/predict_target
add wave -noupdate -expand -group bp -radix hexadecimal /tb_random_mem/uut/bp/update_en
add wave -noupdate -expand -group bp -radix hexadecimal /tb_random_mem/uut/bp/pc_update
add wave -noupdate -expand -group bp -radix hexadecimal /tb_random_mem/uut/bp/actual_target
add wave -noupdate -expand -group bp /tb_random_mem/uut/bp/actual_taken
add wave -noupdate -expand -group bp -radix hexadecimal /tb_random_mem/uut/bp/btb_addr
add wave -noupdate -expand -group bp -radix hexadecimal /tb_random_mem/uut/bp/btb_addr_upd
add wave -noupdate -expand -group bp -childformat {{{/tb_random_mem/uut/bp/btb_entry[0]} -radix hexadecimal} {{/tb_random_mem/uut/bp/btb_entry[1]} -radix hexadecimal} {{/tb_random_mem/uut/bp/btb_entry[2]} -radix hexadecimal} {{/tb_random_mem/uut/bp/btb_entry[3]} -radix hexadecimal} {{/tb_random_mem/uut/bp/btb_entry[4]} -radix hexadecimal -childformat {{{/tb_random_mem/uut/bp/btb_entry[4].valid} -radix hexadecimal} {{/tb_random_mem/uut/bp/btb_entry[4].state} -radix hexadecimal} {{/tb_random_mem/uut/bp/btb_entry[4].pc_tag} -radix hexadecimal} {{/tb_random_mem/uut/bp/btb_entry[4].target} -radix hexadecimal}}} {{/tb_random_mem/uut/bp/btb_entry[5]} -radix hexadecimal} {{/tb_random_mem/uut/bp/btb_entry[6]} -radix hexadecimal} {{/tb_random_mem/uut/bp/btb_entry[7]} -radix hexadecimal} {{/tb_random_mem/uut/bp/btb_entry[8]} -radix hexadecimal} {{/tb_random_mem/uut/bp/btb_entry[9]} -radix hexadecimal} {{/tb_random_mem/uut/bp/btb_entry[10]} -radix hexadecimal} {{/tb_random_mem/uut/bp/btb_entry[11]} -radix hexadecimal} {{/tb_random_mem/uut/bp/btb_entry[12]} -radix hexadecimal} {{/tb_random_mem/uut/bp/btb_entry[13]} -radix hexadecimal} {{/tb_random_mem/uut/bp/btb_entry[14]} -radix hexadecimal} {{/tb_random_mem/uut/bp/btb_entry[15]} -radix hexadecimal} {{/tb_random_mem/uut/bp/btb_entry[16]} -radix hexadecimal} {{/tb_random_mem/uut/bp/btb_entry[17]} -radix hexadecimal} {{/tb_random_mem/uut/bp/btb_entry[18]} -radix hexadecimal} {{/tb_random_mem/uut/bp/btb_entry[19]} -radix hexadecimal} {{/tb_random_mem/uut/bp/btb_entry[20]} -radix hexadecimal} {{/tb_random_mem/uut/bp/btb_entry[21]} -radix hexadecimal} {{/tb_random_mem/uut/bp/btb_entry[22]} -radix hexadecimal} {{/tb_random_mem/uut/bp/btb_entry[23]} -radix hexadecimal} {{/tb_random_mem/uut/bp/btb_entry[24]} -radix hexadecimal} {{/tb_random_mem/uut/bp/btb_entry[25]} -radix hexadecimal} {{/tb_random_mem/uut/bp/btb_entry[26]} -radix hexadecimal} {{/tb_random_mem/uut/bp/btb_entry[27]} -radix hexadecimal} {{/tb_random_mem/uut/bp/btb_entry[28]} -radix hexadecimal} {{/tb_random_mem/uut/bp/btb_entry[29]} -radix hexadecimal} {{/tb_random_mem/uut/bp/btb_entry[30]} -radix hexadecimal} {{/tb_random_mem/uut/bp/btb_entry[31]} -radix hexadecimal}} -expand -subitemconfig {{/tb_random_mem/uut/bp/btb_entry[0]} {-height 15 -radix hexadecimal} {/tb_random_mem/uut/bp/btb_entry[1]} {-height 15 -radix hexadecimal} {/tb_random_mem/uut/bp/btb_entry[2]} {-height 15 -radix hexadecimal} {/tb_random_mem/uut/bp/btb_entry[3]} {-height 15 -radix hexadecimal} {/tb_random_mem/uut/bp/btb_entry[4]} {-height 15 -radix hexadecimal -childformat {{{/tb_random_mem/uut/bp/btb_entry[4].valid} -radix hexadecimal} {{/tb_random_mem/uut/bp/btb_entry[4].state} -radix hexadecimal} {{/tb_random_mem/uut/bp/btb_entry[4].pc_tag} -radix hexadecimal} {{/tb_random_mem/uut/bp/btb_entry[4].target} -radix hexadecimal}}} {/tb_random_mem/uut/bp/btb_entry[4].valid} {-height 15 -radix hexadecimal} {/tb_random_mem/uut/bp/btb_entry[4].state} {-height 15 -radix hexadecimal} {/tb_random_mem/uut/bp/btb_entry[4].pc_tag} {-height 15 -radix hexadecimal} {/tb_random_mem/uut/bp/btb_entry[4].target} {-height 15 -radix hexadecimal} {/tb_random_mem/uut/bp/btb_entry[5]} {-height 15 -radix hexadecimal} {/tb_random_mem/uut/bp/btb_entry[6]} {-height 15 -radix hexadecimal} {/tb_random_mem/uut/bp/btb_entry[7]} {-height 15 -radix hexadecimal} {/tb_random_mem/uut/bp/btb_entry[8]} {-height 15 -radix hexadecimal} {/tb_random_mem/uut/bp/btb_entry[9]} {-height 15 -radix hexadecimal} {/tb_random_mem/uut/bp/btb_entry[10]} {-height 15 -radix hexadecimal} {/tb_random_mem/uut/bp/btb_entry[11]} {-height 15 -radix hexadecimal} {/tb_random_mem/uut/bp/btb_entry[12]} {-height 15 -radix hexadecimal} {/tb_random_mem/uut/bp/btb_entry[13]} {-height 15 -radix hexadecimal} {/tb_random_mem/uut/bp/btb_entry[14]} {-height 15 -radix hexadecimal} {/tb_random_mem/uut/bp/btb_entry[15]} {-height 15 -radix hexadecimal} {/tb_random_mem/uut/bp/btb_entry[16]} {-height 15 -radix hexadecimal} {/tb_random_mem/uut/bp/btb_entry[17]} {-height 15 -radix hexadecimal} {/tb_random_mem/uut/bp/btb_entry[18]} {-height 15 -radix hexadecimal} {/tb_random_mem/uut/bp/btb_entry[19]} {-height 15 -radix hexadecimal} {/tb_random_mem/uut/bp/btb_entry[20]} {-height 15 -radix hexadecimal} {/tb_random_mem/uut/bp/btb_entry[21]} {-height 15 -radix hexadecimal} {/tb_random_mem/uut/bp/btb_entry[22]} {-height 15 -radix hexadecimal} {/tb_random_mem/uut/bp/btb_entry[23]} {-height 15 -radix hexadecimal} {/tb_random_mem/uut/bp/btb_entry[24]} {-height 15 -radix hexadecimal} {/tb_random_mem/uut/bp/btb_entry[25]} {-height 15 -radix hexadecimal} {/tb_random_mem/uut/bp/btb_entry[26]} {-height 15 -radix hexadecimal} {/tb_random_mem/uut/bp/btb_entry[27]} {-height 15 -radix hexadecimal} {/tb_random_mem/uut/bp/btb_entry[28]} {-height 15 -radix hexadecimal} {/tb_random_mem/uut/bp/btb_entry[29]} {-height 15 -radix hexadecimal} {/tb_random_mem/uut/bp/btb_entry[30]} {-height 15 -radix hexadecimal} {/tb_random_mem/uut/bp/btb_entry[31]} {-height 15 -radix hexadecimal}} /tb_random_mem/uut/bp/btb_entry
add wave -noupdate -group imem -radix hexadecimal /tb_random_mem/imem/MEM_SIZE
add wave -noupdate -group imem -radix hexadecimal /tb_random_mem/imem/clk
add wave -noupdate -group imem -radix hexadecimal /tb_random_mem/imem/rst_n
add wave -noupdate -group imem -radix hexadecimal /tb_random_mem/imem/addr
add wave -noupdate -group imem -radix hexadecimal /tb_random_mem/imem/data_in
add wave -noupdate -group imem -radix hexadecimal /tb_random_mem/imem/req
add wave -noupdate -group imem -radix hexadecimal /tb_random_mem/imem/we
add wave -noupdate -group imem -radix hexadecimal /tb_random_mem/imem/be
add wave -noupdate -group imem -radix hexadecimal /tb_random_mem/imem/ready
add wave -noupdate -group imem -radix hexadecimal /tb_random_mem/imem/valid
add wave -noupdate -group imem -radix hexadecimal /tb_random_mem/imem/data_out
add wave -noupdate -group imem -radix hexadecimal /tb_random_mem/imem/mem
add wave -noupdate -group imem -radix hexadecimal /tb_random_mem/imem/w_addr
add wave -noupdate -group imem -radix hexadecimal /tb_random_mem/imem/w_dout
add wave -noupdate -group imem -radix hexadecimal /tb_random_mem/imem/pending
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {2498864 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 346
configure wave -valuecolwidth 213
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {2438047 ps} {2651278 ps}
