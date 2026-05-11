--alu.vhd file


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity exe_stage is
    port (
    --control unit signals
        ctr_alu_op      :   in std_logic_vector (2 downto 0);
        ctr_addsub      :   in std_logic;
        ctr_alu_src1    :   in std_logic;
        ctr_alu_src2    :   in std_logic;
        ctr_comp_op     :   in std_logic_vector(1 downto 0);
        ctr_branch      :   in std_logic;
        i_ctr_jalr      :   in std_logic;                       
        i_ctr_jal       :   in std_logic;


        i_prediction_taken:   in std_logic;                         -- signal that says if the instruction is predicted taken or not
        i_predicted_target:   in std_logic_vector(31 downto 2) ; --propagted predicted target of BP in order to compare it with actual calculated target for JALR instructions
    --hazard unit signals
        haz_lui         :   in std_logic;                       --says pprevious instruciton was LUI(load upper immediate)
    
    --forwarding Unit signals
 
        i_fu_sel1       :   in std_logic_vector(1 downto 0);    --chooses if anything to forward as first source of the alu
        i_fu_sel2       :   in std_logic_vector(1 downto 0);    --chooses if anything to forward as second source of the alu

    --decoder signals
        rd1_i, rd2_i    :   in std_logic_vector(31 downto 0);   --source 1 and 2 of the register file
        immediate_i     :   in std_logic_vector(31 downto 0);   --immediate value of current instruction
        current_pc_i    :   in std_logic_vector(31 downto 0);   --program counter of insrtruction being executed
        alu_res_mem_i   :   in std_logic_vector(31 downto 0);   --ALU result forwarded from MEM stage
        i_immediate_mem :   in std_logic_vector(31 downto 0);   --immediate forwarded from MEM stage
        wb_muxer_i      :   in std_logic_vector(31 downto 0);   --Immediate value forwarded from MEM stage

        o_misprediction :   out std_logic;                      -- signal that indicates if there has been a misprediction
        o_target_jump   :   out std_logic_vector(31 downto 0);  -- target address of jump instruction calculated in the EXE stage
        o_next_pc       :   out std_logic_vector(31 downto 0) ; -- next pc from current instruction(+4), to be propagated through next pipelines for JAL
        o_rs2_exe       :   out std_logic_vector(31 downto 0);  -- data(rs2 from RF) that goes in input to the memory
        alu_res_o       :   out std_logic_vector(31 downto 0)


    );
end exe_stage;

architecture rtl of exe_stage is

   signal 	w_alu_src1       :   std_logic_vector(31 downto 0);
   signal 	w_alu_src2       :   std_logic_vector(31 downto 0);
   signal 	w_mux_fu1        :   std_logic_vector(31 downto 0);
   signal 	w_mux_fu2        :   std_logic_vector(31 downto 0);
   signal 	w_mux_alu_src1   :   std_logic_vector(31 downto 0);
   signal   w_target_jmp     :   std_logic_vector(31 downto 0);
   signal   w_alu_res        :   std_logic_vector(31 downto 0);
   signal   w_shifted_imm    :   std_logic_vector(31 downto 0);
   signal   w_addsub_res     :   std_logic_vector(31 downto 0);
   signal   jump_instruction :   std_logic;
   signal   w_jump_taken     :   std_logic;
   signal   w_branch	     :   std_logic;
   signal   w_pc_jump        :   std_logic_vector(31 downto 0);
   signal   w_next_pc        :   std_logic_vector(31 downto 0);   
   signal   w_trgt_misalign  :   std_logic;
begin

    --next program counter of current instruction, used to restore fetch in case of misprediction
    w_next_pc        <= std_logic_vector(unsigned(current_pc_i) + 4);


    w_shifted_imm    <= immediate_i(31) & immediate_i(29 downto 0) & '0';  --shifting immediate left by 1.

    --jump generation
    --active if jalr or jal instruction or if it is a branch instruction and the branch condition is verified (w_alu_res(0) = '1' means that the condition is verified)
    w_jump_taken <= i_ctr_jalr or (w_alu_res(0) and ctr_branch) or i_ctr_jal;
    
    --mux that chooses the jump target address between the one coming from the adder and the one coming from the ALU (jalr)
    w_pc_jump <= w_addsub_res when (i_ctr_jalr = '1') else w_target_jmp;

    --if the jump is taken and it is not predicted taken, then there is a misprediction and following program counter from current instruction has to be refetched.
    o_target_jump <= w_next_pc when (w_jump_taken = '0' and i_prediction_taken = '1') else w_pc_jump;

    w_branch <= i_ctr_jalr or ctr_branch or i_ctr_jal;

    w_trgt_misalign <= '1' when (i_predicted_target /= w_pc_jump(31 downto 2) and i_ctr_jalr = '1') else '0';

--process for recognizing misprediction from branch predictor
process(all)
begin
    if (w_branch = '1') then
        if ((w_jump_taken /= i_prediction_taken) or (i_prediction_taken='1' and w_trgt_misalign = '1') ) then
            o_misprediction <= '1';
        else
            o_misprediction <= '0';
        end if;
    else
        o_misprediction <= '0';
    end if;
end process;

--adder/subber of the ALU --> arithemtic unit
alu    :  entity work.alu
        port map(
        i_alu_src1        => w_alu_src1,
        i_alu_src2        => w_alu_src2,
        i_ctr_sub         => ctr_addsub,         
        i_ctr_comp_op     => ctr_comp_op,
        i_ctr_branch      => ctr_branch,
        i_ctr_alu_op      => ctr_alu_op,
        o_alu_res         => w_alu_res,
        o_addsub_res      => w_addsub_res
    );

    mux_alu_src_1: entity work.mux2to1
        generic map( N => 32)
        port map (
            sel       => ctr_alu_src1,
            input_0   => w_mux_fu1,
            input_1   => current_pc_i,
            q         => w_alu_src1
        );

--muxer that checks if anything has to be forwarded to the first src of the alu      
    muxfu_1:     entity work.mux4to1 

        port map(
            sel     =>  i_fu_sel1,
		    input_0 =>  rd1_i,
		    input_1 =>  alu_res_mem_i,
		    input_2 =>  wb_muxer_i,
		    input_3 =>  i_immediate_mem,
		    q       =>  w_mux_fu1
        );

--muxer that checks if anything has to be forwarded to the second  input src of ALU
    muxfu_2:    entity work.mux4to1

        port map(
            sel     =>  (i_fu_sel2),
		    input_0 =>  (Rd2_i),
		    input_1 =>  (alu_res_mem_i),
		    input_2 =>  (wb_muxer_i),
		    input_3 =>  (i_immediate_mem),
		    q       =>  (w_mux_fu2)
        );              

--muxer that chooses the second src for the alu 
    mux_alu_src_2:  entity work.mux2to1
	generic map (n => 32)
        port map(
            sel     =>  ctr_alu_src2,
		    input_0 =>  w_mux_fu2,
		    input_1 =>  immediate_i,
		    q       =>  w_alu_src2
        );

--adder used to calculate jump branch target
branch_adder:   entity work.adder
        port map(
        a           =>  current_pc_i,    
        b           =>  w_shifted_imm,
        sum         =>  w_target_jmp
        );

alu_res_o <= w_alu_res;             --ALU result going to memory stage
o_rs2_exe <= w_mux_fu2;             -- output to memory stage
o_next_pc <= w_next_pc;


end rtl;