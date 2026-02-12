--=============================================================================
-- File      : core_riscv32i.vhd
-- Author    : Klides Kaba
-- Description:
--   Top-level module of a custom RV32I RISC-V core featuring a 5-stage pipeline.
--   The core interfaces with instruction and data memories using an OBI-like
--   ready/valid handshake protocol, suitable for both on-chip memories and
--   external memory wrappers.
--
--   The design includes an asynchronous global reset. Pipeline registers
--   support both asynchronous reset and synchronous flush mechanisms; for
--   synthesis simplicity, only control-unit driven signals are reset.
--=============================================================================


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity core_riscv32i is
    port (
        
        x_i_rst_n                   : in    std_logic;                         -- asynchronous reset (active low)
        x_i_clk                     : in    std_logic;                         -- input clock

        x_instr_32_i                : in    std_logic_vector(31 downto 0);     --instruction fetched from IM
        x_data_32_i                 : in    std_logic_vector(31 downto 0);     --data coming from data memory to cpu (reading from cpu)

        x_data_32_o                 : out   std_logic_vector(31 downto 0);     --data to be written in memory (writing memory)

        x_ready_im_i                : in    std_logic;                         --ready signal coming from Instruction Memory (OBI protocol)
        x_ready_dm_i                : in    std_logic;                         --ready signal coming from Data Memory (OBI protocol)
        x_valid_im_i                : in    std_logic;                         --valid coming from IM (OBI).
        x_valid_dm_i                : in    std_logic;                         --valid coming from DM (OBI).

        x_request_im_o              : out   std_logic;                         --request signal to Instruction Memory (OBI protocol)
        x_request_dm_o              : out   std_logic;                         --request signal to Data Memory (OBI protocol)
        x_wren_dm_o                 : out   std_logic;                         --write enable signal to Data Memory
        x_byte_enable_dm            : out   std_logic_vector(3 downto 0);      -- byte enable signal to Data Memory
        x_addr32_im_o               : out   std_logic_vector(31 downto 0);     -- address signal to Instruction Memory 
        x_addr32_dm_o               : out   std_logic_vector(31 downto 0)      -- address signal to Data Memory

    );
end core_riscv32i;

architecture rtl of core_riscv32i is
          
signal       ready_im                   :   std_logic;
signal       valid_im                   :   std_logic;
signal       w_fetched_instr_if         :   std_logic_vector(31 downto 0);
signal       w_current_pc_if            :   std_logic_vector(31 downto 0);
signal       w_previous_pc_if           :   std_logic_vector(31 downto 0);
signal       w_increment_pc_if          :   std_logic_vector(31 downto 0);
signal       w_jump_pc_mem              :   std_logic_vector(31 downto 0);
signal       w_sel_next_pc_mem          :   std_logic; 
signal       w_fetched_instr_id         :   std_logic_vector(31 downto 0);
signal       w_current_pc_id            :   std_logic_vector(31 downto 0);
signal       w_previous_pc_id           :   std_logic_vector(31 downto 0);
signal	     w_ctr_req_dm_id		    :   std_logic;
signal	     w_ctr_req_dm_ex		    :   std_logic;
signal	     w_ctr_req_dm_mem		    :   std_logic;
signal       w_ctr_write_rf_wb          :   std_logic;
signal       w_stall_hdu                :   std_logic;
signal       w_opcode_id                :   std_logic_vector(6 downto 0);
signal       w_ctr_write_rf_id          :   std_logic;
signal       w_ctr_sel_alu_src1_id      :   std_logic;
signal       w_ctr_sel_alu_src2_id      :   std_logic;
signal       w_ctr_addsub_id            :   std_logic;
signal       w_ctr_comp_op_id           :   std_logic_vector(1 downto 0);
signal       w_ctr_alu_op_id            :   std_logic_vector(2 downto 0);
signal       w_ctr_signed_id            :   std_logic;
signal       w_ctr_branch_id            :   std_logic;
signal       w_ctr_wren_dm_id           :   std_logic;
signal       w_ctr_jalr_id              :   std_logic;
signal       w_ctr_lui_id               :   std_logic;
signal       w_ctr_jal_id               :   std_logic;
signal       w_dreg_wb                  :   std_logic_vector(4 downto 0);
signal       w_ctr_U_UJ_I_id            :   std_logic;
signal       w_ctr_U_UJ_I_ex            :   std_logic;
signal       w_rf_rs1_id                :   std_logic_vector(4 downto 0);
signal       w_rf_rs2_id                :   std_logic_vector(4 downto 0);
signal       w_rf_dreg_id               :   std_logic_vector(4 downto 0);
signal       w_rf_reg1_id               :   std_logic_vector(31 downto 0);
signal       w_rf_reg2_id               :   std_logic_vector(31 downto 0);
signal       w_immediate_id             :   std_logic_vector(31 downto 0);
signal       w_ctr_addsub_ex            :   std_logic;
signal       w_ctr_alu_op_ex            :   std_logic_vector(2 downto 0);
signal       w_ctr_sel_alu_src1_ex      :   std_logic;
signal       w_ctr_sel_alu_src2_ex      :   std_logic;
signal       w_ctr_signed_ex            :   std_logic;
signal       w_fu_sel1_ex               :   std_logic_vector(1 downto 0);
signal       w_fu_sel2_ex               :   std_logic_vector(1 downto 0);
signal       w_rf_reg1_ex               :   std_logic_vector(31 downto 0);
signal       w_rf_reg2_ex               :   std_logic_vector(31 downto 0);
signal       w_immediate_ex             :   std_logic_vector(31 downto 0);
signal       w_current_pc_ex            :   std_logic_vector(31 downto 0);
signal       w_prev_pc_ex               :   std_logic_vector(31 downto 0);
signal       w_alu_res_mem              :   std_logic_vector(31 downto 0);
signal       w_ctr_comp_op_ex           :   std_logic_vector(1 downto 0);
signal       w_ctr_jalr_ex              :   std_logic;
signal       w_ctr_lui_ex               :   std_logic;
signal       w_ctr_jal_ex               :   std_logic;
signal       w_opcode_ex                :   std_logic_vector(6 downto 0);
signal       w_ctr_write_rf_ex          :   std_logic;
signal       w_ctr_branch_ex            :   std_logic;
signal       w_ctr_wren_dm_ex           :   std_logic;
signal       w_forward_enable_ex        :   std_logic;
signal       w_rf_dreg_ex		        :   std_logic_vector(4 downto 0);
signal       w_rf_rs1_ex          	    :   std_logic_vector(4 downto 0);
signal       w_rf_rs2_ex          	    :   std_logic_vector(4 downto 0);
signal       w_alu_res_ex               :   std_logic_vector(31 downto 0);
signal       w_jump_branch_ex           :   std_logic_vector(31 downto 0);
signal       stall                      :   std_logic;
signal       ctr_jalr_mem               :   std_logic;
signal       ctr_jal_mem                :   std_logic;
signal       w_rf_reg2_mem              :   std_logic_vector(31 downto 0);
signal       request_dm                 :   std_logic;
signal       wren_dm                    :   std_logic;
signal       addr_dm                    :   std_logic_vector(31 downto 0);
signal       w_ctr_wren_mem             :   std_logic;   
signal       w_immediate_mem            :   std_logic_vector(31 downto 0);
signal       w_dreg_mem                 :   std_logic_vector(4 downto 0);
signal       w_jump_branch_mem          :   std_logic_vector(31 downto 0);
signal       w_ctr_branch_mem           :   std_logic;
signal       w_ctr_jal_mem              :   std_logic;
signal       w_ctr_jalr_mem             :   std_logic;
signal       w_ctr_lui_mem              :   std_logic;
signal       w_ctr_write_rf_mem         :   std_logic;
signal       w_dout_dm, w_din_dm        :   std_logic_vector(31 downto 0);
signal       w_alu_res_wb               :   std_logic_vector(31 downto 0);
signal       w_ctr_lui_wb               :   std_logic;
signal       w_ctr_jal_wb               :   std_logic;
signal       w_immediate_wb             :   std_logic_vector(31 downto 0);
signal       w_rf_wdata_wb              :   std_logic_vector(31 downto 0);
signal       stall_pipe_n               :   std_logic;
signal       w_ctr_signed_ld_id         :   std_logic;
signal       w_ctr_signed_ld_ex         :   std_logic;
signal       w_ctr_signed_ld_mem        :   std_logic;
signal       stall_pipe                 :   std_logic;
signal	     w_req_im_cpu		        :   std_logic;
signal       w_rs2_fw_exe               :   std_logic_vector(31 downto 0);
signal       w_forward_enable_id		:   std_logic;
signal       w_flush_pipe               :   std_logic;
signal       w_instr_valid_id           :   std_logic;


signal       w_pp_if_id_enable          :   std_logic;
signal       w_instr_valid_if           :   std_logic;
signal       w_stall_fetch              :   std_logic;
signal       w_stall_mem_pp             :   std_logic;
signal       w_ctr_size_dm_mem          :   std_logic_vector(1 downto 0);
signal       w_ctr_signed_mem           :   std_logic;
signal       w_flush_mem_pipe           :   std_logic;
signal       w_enable_pp_mem            :   std_logic;
signal       w_pc_enable                :   std_logic;
signal       w_current_pc_mem           :   std_logic_vector(31 downto 0);
signal       w_current_pc_wb            :   std_logic_vector(31 downto 0);
signal       w_dout_dm_mem              :   std_logic_vector(31 downto 0);
signal       w_jump_taken               :   std_logic;

--debugging signals
signal       w_instr_ex	                :   std_logic_vector(31 downto 0);  
signal       w_instr_mem, w_instr_wb    :   std_logic_vector(31 downto 0);


begin

--signal that acts as enable to pipes '1'-> pipe running
--                                    '0'-> pipe stalled
stall_pipe          <=    not(stall_pipe_n);          

w_pp_if_id_enable   <=   w_instr_valid_if and (stall_pipe and not(w_stall_hdu));

--prorgram counter depends on stall from hdu and pipe staller
w_stall_fetch       <=   stall_pipe_n or w_stall_hdu;                          

--program counter enable 
w_pc_enable         <=   w_req_im_cpu and x_ready_im_i;  
                                                                             
-- Generation of stall for EX_MEM pipeline:
-- When there is not a jump taken the pipe is normally stalled as the other stages, but in case of a jump taken this stage is stalled untill
-- program counter has sampled the address generated through the jump instruction
w_enable_pp_mem     <=  w_pc_enable when w_jump_taken = '1' else stall_pipe;
--w_enable_pp_mem     <=  stall_pipe when w_jump_taken = '0' else (stall_pipe and w_pc_enable);

--w_flush_mem_pipe    <=  '0' when w_jump_taken = '0' else w_pc_enable;--

--* since flush pipe is synchronous, in order to avoid the propagation of the EX stage instruction in the MEM stage in the next cycle
--* flush also the mem stage after the jump address has been sampled by program counter.  
w_flush_mem_pipe    <=  w_jump_taken AND w_pc_enable;



Valid_sampling: process(x_i_clk, x_i_rst_n)
begin
    if x_i_rst_n = '0' then
        w_instr_valid_id <= '0';
    elsif rising_edge(x_i_clk) then
        if stall_pipe = '1' and w_stall_hdu = '0' then
            w_instr_valid_id  <= w_instr_valid_if;
        end if;
    end if;
    end process;

--***********component fetch***********************
-- **********fetcher stage*************************
--*************************************************
iFETCH: entity work.fetch 
        port map(

            clk                    =>   x_i_clk             ,  
            rst_n                  =>   x_i_rst_n           ,
            o_request              =>   w_req_im_cpu        ,
            ready_im               =>   x_ready_im_i        ,
            valid_im               =>   x_valid_im_i        ,
            next_instruction_i     =>   x_instr_32_i        ,
            next_instruction_o     =>   w_fetched_instr_if  ,
            current_PC_o           =>   w_current_pc_if     ,
            PreviousPC_o           =>   w_previous_pc_if    ,
            i_pc_jump              =>   w_jump_pc_mem       ,      
            i_selNextPC            =>   w_jump_taken        ,
            valid_instr_o          =>   w_instr_valid_if    ,
            i_block_pp             =>   w_stall_fetch       
        );

--***************** pipe_IF_ID **********************--
--component pipe_IF_ID
--pipe beetween Fetch stage and decode stage  
--***************************************************
IF_ID_PP : entity work.pipe_IF_ID
        port map(

            clk                     =>   x_i_clk                ,              
            reset_n                 =>   x_i_rst_n              ,
            enable_i                =>   w_pp_if_id_enable      ,
            flusher                 =>   w_flush_pipe           ,    
            instruction_i           =>   w_fetched_instr_if     ,
            current_PC_i            =>   w_current_PC_if        ,
            previous_PC_i           =>   w_previous_pc_if       ,
            Instruction_o           =>   w_fetched_instr_id     ,
            current_pc_o            =>   w_current_pc_id        ,
            previous_pc_o           =>   w_previous_pc_id       

        );

--component ID_stage
--decoder of the instruction stage
ID_STAGE: entity work.ID_stage 
        port map(
            clk                     =>  x_i_clk                 ,         
            i_instruction           =>  w_fetched_instr_id      , 
            i_dreg                  =>  w_dreg_wb               ,
            i_wdata                 =>  w_rf_wdata_wb           ,
            i_ctr_write_rf          =>  w_ctr_write_rf_wb       ,
            i_instr_valid           =>  w_instr_valid_id        ,
            i_stall                 =>  w_stall_hdu             ,
            o_opcode                =>  w_opcode_id             ,
            o_ctr_U_UJ_I            =>  w_ctr_U_UJ_I_id         ,
            o_ctr_write_rf          =>  w_ctr_write_rf_id       ,
            o_ctr_sel_alu_src1      =>  w_ctr_sel_alu_src1_id   ,
            o_ctr_sel_alu_src2      =>  w_ctr_sel_alu_src2_id   ,
            o_ctr_addsub            =>  w_ctr_addsub_id         ,
            o_ctr_alu_op            =>  w_ctr_alu_op_id         ,
            o_ctr_signed            =>  w_ctr_signed_id         ,
            o_ctr_comp_op           =>  w_ctr_comp_op_id        ,
            o_ctr_branch            =>  w_ctr_branch_id         ,
            o_ctr_wren_dm           =>  w_ctr_wren_dm_id        ,
            o_ctr_request_dm        =>  w_ctr_req_dm_id         ,
            o_ctr_jalr              =>  w_ctr_jalr_id           ,
            o_ctr_lui               =>  w_ctr_lui_id            ,
            o_ctr_jal               =>  w_ctr_jal_id            ,
            o_ctr_signed_ld         =>  w_ctr_signed_ld_id      ,
            o_rf_rs1                =>  w_rf_rs1_id             ,
            o_rf_rs2                =>  w_rf_rs2_id             ,
            o_rf_dreg               =>  w_rf_dreg_id            ,
            o_rf_reg1               =>  w_rf_reg1_id            ,
            o_rf_reg2               =>  w_rf_reg2_id            ,
            o_immediate             =>  w_immediate_id          
        );

--component pipe_IF_ID
--pipe beetween DECODE stage and EXECUTE stage  
ID_EX_PP : entity work.pipe_ID_EX
        port map(
             
             clk                    =>  x_i_clk                 ,
             rstn                   =>  x_i_rst_n               ,
             enable                 =>  stall_pipe              ,
             flusher                =>   w_flush_pipe           ,  
-- Inputs        
	         i_ctr_addsub           =>  w_ctr_addsub_id		    ,
             i_ctr_alu_op           =>  w_ctr_alu_op_id         ,
             i_debug_instr          =>  w_fetched_instr_id      , 
             i_CURRENT_PC           =>  w_current_pc_id         ,
             i_PAST_PC              =>  w_previous_pc_id        ,
             i_rf_write             =>  w_ctr_write_rf_id       ,
             i_opcode        	    =>  w_opcode_id             ,
	         i_ctr_req_dm           =>  w_ctr_req_dm_id         ,
             i_ALU_src1             =>  w_ctr_sel_alu_src1_id   ,
             i_alu_src2             =>  w_ctr_sel_alu_src2_id   ,
             i_MemWrite             =>  w_ctr_wren_dm_id        ,
             i_ctr_branch           =>  w_ctr_branch_id         ,
             i_ctr_comp_op          =>  w_ctr_comp_op_id        ,
             i_ctr_signed           =>  w_ctr_signed_id         ,
             i_ctr_jalr             =>  w_ctr_jalr_id           ,
             i_ctr_LUI              =>  w_ctr_lui_id            ,
             i_ctr_JAL              =>  w_ctr_jal_id            ,
             i_ctr_U_UJ_I           =>  w_ctr_U_UJ_I_id         ,
             i_ctr_signed_ld        =>  w_ctr_signed_ld_id      ,
             Rs1Addx_in             =>  w_rf_rs1_id             ,   
             Rs2Addx_in             =>  w_rf_rs2_id             ,
             DrAddx_in              =>  w_rf_dreg_id            ,
             i_Reg1                 =>  w_rf_reg1_id            ,
             i_Reg2                 =>  w_rf_reg2_id            ,
             i_Immediate            =>  w_immediate_id          ,
-- Outputs   
             o_CURRENT_PC           =>  w_current_pc_ex         ,
             o_PAST_PC              =>  w_prev_pc_ex            ,
             o_rf_write             =>  w_ctr_write_rf_ex       ,
             o_alu_src1             =>  w_ctr_sel_alu_src1_ex   ,
             o_alu_src2             =>  w_ctr_sel_alu_src2_ex   ,  
	         o_ctr_addsub           =>  w_ctr_addsub_ex		    ,
             o_ctr_alu_op           =>  w_ctr_alu_op_ex         ,
             o_ctr_branch           =>  w_ctr_branch_ex         ,
	         o_ctr_req_dm           =>  w_ctr_req_dm_ex         ,
             o_MemWrite             =>  w_ctr_wren_dm_ex        ,
             o_CTR_signed           =>  w_ctr_signed_ex         ,
             o_CTR_jalr             =>  w_ctr_jalr_ex           ,
             o_CTR_LUI              =>  w_ctr_lui_ex            ,
             o_CTR_JAL              =>  w_ctr_jal_ex            ,
             o_ctr_U_UJ_I           =>  w_ctr_U_UJ_I_ex         ,
             o_ctr_signed_ld        =>  w_ctr_signed_ld_ex      ,
             o_opcode               =>  w_opcode_ex             ,
             Rs1Addx_out            =>  w_rf_rs1_ex             ,
             Rs2Addx_out            =>  w_rf_rs2_ex             ,
             DrAddx_out             =>  w_rf_dreg_ex            ,
             o_Reg1                 =>  w_rf_reg1_ex            ,
             o_Reg2                 =>  w_rf_reg2_ex            ,
             o_Immediate            =>  w_immediate_ex          ,
             o_ctr_comp_op          =>  w_ctr_comp_op_ex        ,
             o_debug_instr          =>  w_instr_ex              
        );

--component alu_stage
--alu
EXE_STAGE : entity work.exe_stage
        port map(
             ctr_alu_op         =>  w_ctr_alu_op_ex             ,  
	         ctr_addsub		    =>  w_ctr_addsub_ex		        ,
             ctr_alu_src1       =>  w_ctr_sel_alu_src1_ex       ,
             ctr_alu_src2       =>  w_ctr_sel_alu_src2_ex       ,
             ctr_branch         =>  w_ctr_branch_ex             ,
             ctr_signed         =>  w_ctr_signed_ex             ,
             ctr_comp_op        =>  w_ctr_comp_op_ex            ,
             haz_lui            =>  w_ctr_lui_mem               ,
             i_fu_sel1          =>  w_fu_sel1_ex                ,
             i_fu_sel2          =>  w_fu_sel2_ex                ,
             rd1_i              =>  w_rf_reg1_ex                ,
             rd2_i              =>  w_rf_reg2_ex                ,
             immediate_i        =>  w_immediate_ex              ,
             i_immediate_mem    =>  w_immediate_mem             ,
             curr_pc_i          =>  w_current_pc_ex             ,
             prev_pc_i          =>  w_prev_pc_ex                ,
             alu_res_mem_i      =>  w_alu_res_mem               ,
             wb_muxer_i         =>  w_rf_wdata_wb               ,
             alu_res_o          =>  w_alu_res_ex                ,
             o_rs2_exe          =>  w_rs2_fw_exe                ,
             jump_branch_o      =>  w_jump_branch_ex    

        );

--***************************************************
--component pipe execution stage to memory stage
--pipe_ex_mem
--***************************************************
EX_MEM_PP: entity work.pipe_EX_MEM 
        port map(
            clk                 =>  x_i_clk                 ,
            rstn                =>  x_i_rst_n               ,
            enable              =>  w_enable_pp_mem         ,                       
            flusher             =>  w_flush_mem_pipe        ,--w_flush_mem_pipe        ,                   
            i_debug_instr       =>  w_instr_ex              ,        
            dReg_in             =>  w_rf_dreg_ex            ,
            i_Immediate         =>  w_immediate_ex          ,
            ALUres_in           =>  w_alu_res_ex            ,
            i_rf_reg2           =>  w_rs2_fw_exe            ,   
            JALres_in           =>  w_jump_branch_ex        ,
            i_pc_current        =>  w_current_pc_ex         ,
            i_ctr_signed        =>  w_ctr_signed_ex         ,
            i_request_dm        =>  w_ctr_req_dm_ex         ,
            i_addr_dm           =>  w_alu_res_ex            ,
            i_wren_dm           =>  w_ctr_wren_dm_ex        ,
            i_CTR_LUI           =>  w_ctr_lui_ex            ,
            CTR_branch_in       =>  w_ctr_branch_ex         ,
            i_CTR_jal_muxRF     =>  w_ctr_jal_ex            ,
            i_CTR_JALR          =>  w_ctr_jalr_ex           ,
            i_CTR_RFwrite       =>  w_ctr_write_rf_ex       ,
            i_ctr_signed_ld     =>  w_ctr_signed_ld_ex      ,
            i_ctr_size_dm       =>  w_ctr_comp_op_ex        , 
-- outputs __________________________________________________           
            o_request_dm        =>  w_ctr_req_dm_mem        ,
            o_wren_dm           =>  w_ctr_wren_mem          ,
            o_Immediate         =>  w_immediate_mem         ,
            dreg_out            =>  w_dreg_mem              ,
            ALUres_out          =>  w_alu_res_mem           ,
            JALres_out          =>  w_jump_branch_mem       ,
            o_rf_reg2           =>  w_rf_reg2_mem           ,   
            o_pc_current        =>  w_current_pc_mem        ,
            CTR_branch_out      =>  w_ctr_branch_mem        ,
            o_CTR_jal_muxRF     =>  w_ctr_jal_mem           ,
            o_CTR_JALR          =>  w_ctr_jalr_mem          ,
            o_CTR_LUI           =>  w_ctr_lui_mem           ,
            o_CTR_RFwrite       =>  w_ctr_write_rf_mem      ,
            o_debug_instr       =>  w_instr_mem             ,
            o_ctr_signed        =>  w_ctr_signed_mem        ,
            o_ctr_signed_ld     =>  w_ctr_signed_ld_mem     ,
            o_ctr_size_dm       =>  w_ctr_size_dm_mem          
        );

--memory stage

MEM_STAGE:  entity work.mem_stage
        port map(
            clk                 =>  x_i_clk                 ,            
            rst_n               =>  x_i_rst_n               ,
            i_ctr_jalr          =>  w_ctr_jalr_mem          ,
            i_ctr_size_access   =>  w_ctr_size_dm_mem       ,
            i_ctr_signed_ld     =>  w_ctr_signed_ld_mem     ,
            i_ctr_jal           =>  w_ctr_jal_mem           ,
            pc_jump_o           =>  w_jump_pc_mem           ,
            i_ctr_branch        =>  w_ctr_branch_mem        ,
            o_sel_next_pc       =>  w_jump_taken            ,
            pc_branch_i         =>  w_jump_branch_mem       ,
            i_Alu_result_MEM    =>  w_alu_res_mem           ,
            dm_wdata_i          =>  w_rf_reg2_mem           ,
            dm_rdata_i          =>  x_data_32_i             ,
            dm_req_i            =>  w_ctr_req_dm_mem        ,
            dm_we_i             =>  w_ctr_wren_mem          ,
            dm_ready_i          =>  x_ready_dm_i            ,
            dm_valid_i          =>  x_valid_dm_i            ,
            dm_byte_enable_o    =>  x_byte_enable_dm        ,      
            dm_req_o            =>  request_dm              ,
            dm_we_o             =>  wren_dm                 ,
            dm_wdata_o          =>  w_din_dm                ,
            data_to_wb_o        =>  w_dout_dm_mem           ,
            dm_addx_o           =>  addr_dm 
        );

--pipe memory stage to write back stage
MEM_WB_PP:    entity work.pipe_mem_wb
        port map(
            clk                 => x_i_clk                ,  
            reset_n             => x_i_rst_n              ,
            enable              => stall_pipe             ,      
-- Inputs_________________________________________________  
            i_debug_instr       => w_instr_mem            ,
            i_ctr_rf_write_mem  => w_ctr_write_rf_mem     ,
            i_ctr_lui_mem       => w_ctr_lui_mem          ,
            i_ctr_jal_mem       => w_ctr_jal_mem          ,   
            i_pc_increment_mem  => w_current_pc_mem       , 
            i_data_dm_mem       => w_dout_dm_mem          ,
            i_immediate_mem     => w_immediate_mem        ,       
            i_dr_mem            => w_dreg_mem             ,       
-- outputs_________________________________________________          
            o_ctr_rf_write_wb   => w_ctr_write_rf_wb      ,       
            o_ctr_lui_wb        => w_ctr_lui_wb           ,       
            o_ctr_jal_wb        => w_ctr_jal_wb           ,       
            o_pc_increment_wb   => w_current_pc_wb        ,           
            o_data_dm_wb        => w_dout_dm              ,       
            o_immediate_wb      => w_immediate_wb         ,       
            o_dr_mem            => w_dreg_wb              ,
            o_debug_instr       => w_instr_wb         
        );

--write back component
WBACK_STAGE:    entity work.writeback
        port map(
            i_dato_mem            => w_dout_dm            ,
            i_ctr_lui             => w_ctr_lui_wb         ,      
            i_ctr_jal             => w_ctr_jal_wb         ,
            i_pc_increment        => w_current_pc_wb      ,
            i_immediate           => w_immediate_wb       ,
            o_wdata_rf            => w_rf_wdata_wb           
        );

--***************************************--
--*************PIPE_STALLER**************--
--When there is need to stopp the pipe 'block_pipe' is '1'
--***************************************--

STALLER:  entity work.pipe_staller
        port map(
            clk                   =>  x_i_clk                 ,
            rst_n                 =>  x_i_rst_n               ,
            request_dm            =>  w_ctr_req_dm_mem        ,
            valid                 =>  x_valid_dm_i            ,
            block_pipe            =>  stall_pipe_n
        );


--***************************--
--******FORWARD UNIT*********
--***************************--
FORWARD_UNIT: entity work.ForwardingUnit
        port map(

            writeback_prev          =>  w_ctr_write_rf_mem      ,       
            writeback_pre_prev      =>  w_ctr_write_rf_wb       ,
            i_ctr_lui_prev          =>  w_ctr_lui_mem           ,               
            i_ctr_U_UJ_I            =>  w_ctr_U_UJ_I_ex         ,
            load_rd_prev            =>  w_dreg_mem              ,
            load_rd_pre_prev        =>  w_dreg_wb               ,
            exec_rs1                =>  w_rf_rs1_ex             ,
            exec_rs2                =>  w_rf_rs2_ex             ,
            forward_ctrl_rs1        =>  w_fu_sel1_ex            ,
            forward_ctrl_rs2        =>  w_fu_sel2_ex            
  
        );


--******************************--
--*****HAZARD_DETECTION_UNIT****--
--******************************--
HAZARD_DU: entity work.HAZARD_DETECTION_UNIT
        port map(
            pipe_flush              =>  w_flush_pipe            , 
            previousInstr_op        =>  w_opcode_ex             ,
            load_rd                 =>  w_rf_dreg_ex            ,
            exec_rs1                =>  w_rf_rs1_id             ,
            exec_rs2                =>  w_rf_rs2_id             ,
            stall                   =>  w_stall_hdu               
        );

--**********************************--
--**********PIPE_FLUSHER*************--
--**********************************--
PIPE_FLUSHER : entity work.pipe_flusher
    port map(
        clk         =>  x_i_clk,
        rst_n       =>  x_i_rst_n,
        jump_taken  =>  w_jump_taken,
        valid_im    =>  w_instr_valid_if,  
        flush       =>  w_flush_pipe
    );

--**********OUTPUTS ASSIGNMENTS**********--

    x_addr32_im_o       <= w_current_pc_if  ;        
    x_addr32_dm_o       <= addr_dm          ;

    x_request_im_o      <= w_req_im_cpu     ;       
    x_request_dm_o      <= request_dm       ;

    x_wren_dm_o         <= wren_dm          ;             
    x_data_32_o         <= w_din_dm         ;          


end rtl;