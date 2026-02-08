library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity alu is
    port (

        i_alu_src1        :   in  std_logic_vector(31 downto 0);
        i_alu_src2        :   in  std_logic_vector(31 downto 0);
	    i_ctr_signed      :   in  std_logic;
        i_ctr_sub         :   in  std_logic;                     --segnale che dice se fare addizione o sottrazione (1=sottrazione)
        i_ctr_branch      :   in  std_logic;                     --signal that indicates if a branch operation is being performed
        i_ctr_comp_op     :   in  std_logic_vector(1 downto 0);  --signal that selects the comparison operation
        i_ctr_alu_op      :   in  std_logic_vector(2 downto 0);  --signal that selects the operation of the ALU
        o_alu_res         :   out std_logic_vector(31 downto 0)

    );
end alu;

architecture rtl of alu is
signal o_comp_res : std_logic;
signal w_adder_res: std_logic_vector(31 downto 0);
signal w_and_res  : std_logic_vector(31 downto 0);
signal w_or_res   : std_logic_vector(31 downto 0);
signal w_xor_res  : std_logic_vector(31 downto 0);
signal w_sll_res  : std_logic_vector(31 downto 0);
signal w_srl_res  : std_logic_vector(31 downto 0);
signal w_srai_res : std_logic_vector(31 downto 0);
signal w_slt_res  : std_logic_vector(31 downto 0);

signal shmt: integer range 0 to 31;

signal w_alu_res  : std_logic_vector(31 downto 0);
signal lsb_alu_res : std_logic;

begin
shmt <= to_integer(unsigned(i_alu_src2(4 downto 0)));


lsb_alu_res <= o_comp_res when i_ctr_branch = '1' else w_alu_res(0);

comparator: entity work.alu_comparator
        port map (
            ctr_signed        => i_ctr_signed,
            ctr_comp_op       => i_ctr_comp_op(1 downto 0),
            ctr_sltiu         => i_ctr_sub,
            data_in1          => i_alu_src1,
            data_in2          => i_alu_src2,
            q                 => o_comp_res
        );
    
--adder/subber of the ALU --> arithemtic unit
add_sub:        entity work.Adder_sub 
        port map(
          a           => i_alu_src1,
		  b           => i_alu_src2,
		  subtract    => i_ctr_sub,
		  result      => w_adder_res
    );

w_and_res <= i_alu_src1 and i_alu_src2;

w_xor_res <= i_alu_src1 xor i_alu_src2;

w_or_res  <= i_alu_src1 or i_alu_src2;

w_slt_res <= (others => '0') when o_comp_res = '0' else
             (31 downto 1 => '0', 0 => '1');

--left shift unit
w_sll_res <= std_logic_vector(shift_left(unsigned(i_alu_src1), shmt));

--logic right shift unit
w_srl_res <= std_logic_vector(shift_right(unsigned(i_alu_src1), shmt));

--right shift arithmetic unit
w_srai_res <= std_logic_vector(shift_right(signed(i_alu_src1), shmt));

w_alu_res <= w_adder_res when i_ctr_alu_op = "000" else
             w_and_res   when i_ctr_alu_op = "111" else
             w_or_res    when i_ctr_alu_op = "110" else
             w_slt_res   when i_ctr_alu_op = "010" else
             w_xor_res   when i_ctr_alu_op = "100" else
             w_sll_res   when i_ctr_alu_op = "001" else
             w_srl_res   when i_ctr_alu_op = "101" and i_ctr_comp_op(0) = '0' else
             w_srai_res  when i_ctr_alu_op = "101" and i_ctr_comp_op(0) = '1' else
				 (others => '0');

o_alu_res <= w_alu_res(31 downto 1) & lsb_alu_res;

end rtl;