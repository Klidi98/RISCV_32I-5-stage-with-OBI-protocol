
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ForwardingUnit is
    Port (
        
        writeback_prev        : in std_logic;                       -- write signal coming coming from mem_stage

        i_ctr_U_UJ_I          : in std_logic;                       -- tells type of instruction 
        i_ctr_lui_prev        : in std_logic;                       -- Indicates if the instruction in MEM stage is LUI    
	    writeback_pre_prev    : in std_logic;                       -- write signal coming from wb_stage

       -- writeRF_WB: in std_logic;
        load_rd_prev          : in std_logic_vector(4 downto 0);    -- Destination register of the load instruction coming from mem stage 
	    load_rd_pre_prev      : in std_logic_vector(4 downto 0);    -- Destination register of the load instruction coming from wb stage
        exec_rs1, exec_rs2    : in std_logic_vector(4 downto 0);    -- Source register 1 of the subsequent instructions
        forward_ctrl_rs1      : out std_logic_vector(1 downto 0);   -- Forwarding control signal for ALU input muxes for source 1
       	forward_ctrl_rs2      : out std_logic_vector(1 downto 0)    -- Forwarding control signal for ALU input muxes for source 2

    );
end ForwardingUnit;

architecture Behavioral of ForwardingUnit is

signal w_ctr_rs1,w_ctr_rs2 :std_logic_vector(1 downto 0);
begin
    process (writeback_prev,writeback_pre_prev, load_rd_prev,load_rd_pre_prev, exec_rs1, exec_rs2, i_ctr_lui_prev)
    begin
        -- Initialize signal
    w_ctr_rs1 <= (others => '0');
	w_ctr_rs2 <= (others => '0');


-- priorità a 'prev' (MEM_STAGE) rispetto a 'pre_prev(WRITEBACK_STAGE)'
if (writeback_prev = '1' and load_rd_prev = exec_rs1) then
    if i_ctr_lui_prev = '1' then     -- If in stage MEM instruction is a LUI, forward immediate value
            w_ctr_rs1 <= "11";
    else                            --else forward from ALU result
            w_ctr_rs1 <= "01";
    end if;
elsif (writeback_pre_prev = '1' and load_rd_pre_prev = exec_rs1) then       --forward from WB stage
    w_ctr_rs1 <= "10";
else
    w_ctr_rs1 <= "00";
end if;

--forwarding for register rs2.
--if (i_ctr_U_UJ_I = '0') then -- Controlla se rs2 è presente nell'istruzione
    if (writeback_prev = '1' and load_rd_prev = exec_rs2) then
        if i_ctr_lui_prev = '1' then     -- If in stage MEM instruction is a LUI, forward immediate value
            w_ctr_rs2 <= "11";
        else                            --else forward from ALU result
            w_ctr_rs2 <= "01"; 
        end if;
    elsif (writeback_pre_prev = '1' and load_rd_pre_prev = exec_rs2) then       --forward from WB stage
        w_ctr_rs2 <= "10";
    else 
        w_ctr_rs2 <= "00";
    end if;
--end if;
        
end process;


forward_ctrl_rs1<=w_ctr_rs1;
forward_ctrl_rs2<=w_ctr_rs2;
end Behavioral;
