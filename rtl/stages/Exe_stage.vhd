--alu.vhd file


library ieee;
use ieee.std_logic_1164.all;


entity exe_stage is
    port (

    --control unit signals
        ctr_alu_op      :   in std_logic_vector (2 downto 0);
        ctr_addsub      :   in std_logic;
        ctr_alu_src1    :   in std_logic;
        ctr_alu_src2    :   in std_logic;
        ctr_signed      :   in std_logic;
        ctr_comp_op     :   in std_logic_vector(1 downto 0);
        ctr_branch      :   in std_logic;

    --hazard unit signals
        haz_lui         :   in std_logic;                       --says pprevious instruciton was LUI(load upper immediate)
    
    --forwarding Unit signals
 
        i_fu_sel1       :   in std_logic_vector(1 downto 0);    --chooses if anything to forward as first source of the alu
        i_fu_sel2       :   in std_logic_vector(1 downto 0);    --chooses if anything to forward as second source of the alu

    --decoder signals
        rd1_i, rd2_i    :   in std_logic_vector(31 downto 0);   --source 1 and 2 of the register file
        immediate_i     :   in std_logic_vector(31 downto 0);  
        curr_pc_i       :   in std_logic_vector(31 downto 0);
        prev_pc_i       :   in std_logic_vector(31 downto 0);
        alu_res_mem_i   :   in std_logic_vector(31 downto 0);
        i_immediate_mem :   in std_logic_vector(31 downto 0);
        wb_muxer_i      :   in std_logic_vector(31 downto 0);

        o_rs2_exe       :   out std_logic_vector(31 downto 0);  -- data(rs2 from RF) that goes in input to the memory
        alu_res_o       :   out std_logic_vector(31 downto 0);
        jump_branch_o   :   out std_logic_vector(31 downto 0)

    );
end exe_stage;

architecture rtl of exe_stage is

   signal 	w_alu_src1     :   std_logic_vector(31 downto 0);
   signal 	w_alu_src2     :   std_logic_vector(31 downto 0);
   signal 	w_mux_fu1      :   std_logic_vector(31 downto 0);
   signal 	w_mux_fu2      :   std_logic_vector(31 downto 0);
   signal 	w_mux_alu_src1 :   std_logic_vector(31 downto 0);


   signal   w_shifted_imm    :   std_logic_vector(31 downto 0);


begin

    w_shifted_imm    <= immediate_i(31) & immediate_i(29 downto 0) & '0';  --shifting immediate left by 1.


    -- and operator
    
--adder/subber of the ALU --> arithemtic unit
alu    :  entity work.alu
        port map(
        i_alu_src1        => w_alu_src1,
        i_alu_src2        => w_alu_src2,
        i_ctr_sub         => ctr_addsub,     --ctr_sltiu
	    i_ctr_signed      => ctr_signed,     
        i_ctr_comp_op     => ctr_comp_op,
        i_ctr_branch      => ctr_branch,
        i_ctr_alu_op      => ctr_alu_op,
        o_alu_res         => alu_res_o
    );


    mux_alu_src_1: entity work.mux2to1
        generic map( N => 32)
        port map (
            sel       => ctr_alu_src1,
            input_0   => w_mux_fu1,
            input_1   => prev_pc_i,
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

--muxer that checks if anything has to be forwarded to the second src of the alu
    muxfu_2:    entity work.mux4to1

        port map(
            sel     =>  (i_fu_sel2),
		    input_0 =>  (Rd2_i),
		    input_1 =>  (alu_res_mem_i),
		    input_2 =>  (wb_muxer_i),
		    input_3 =>  (i_immediate_mem),
		    q       =>  (w_mux_fu2)
        );              

--muxer that choses the secodn src for the alu 
    mux_alu_src_2:  entity work.mux2to1
	generic map (n => 32)
        port map(
            sel     =>  ctr_alu_src2,
		    input_0 =>  w_mux_fu2,
		    input_1 =>  immediate_i,
		    q       =>  w_alu_src2
        );


--adder used to calculate jump branch
branch_adder:   entity work.adder
        port map(
        a           =>  prev_pc_i,    
        b           =>  w_shifted_imm,
        sum         =>  jump_branch_o
        );


o_rs2_exe <= w_mux_fu2;             -- output to memory stage
end rtl;