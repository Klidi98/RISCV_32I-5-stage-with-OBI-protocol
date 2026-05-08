library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity pipe_flusher is
    Port ( 
           clk              : in std_logic;   
           rst_n            : in std_logic;
           i_misprediction  : in std_logic;    -- signal that indicates if there has been a misprediction in branch prediction 
           valid_im         : in std_logic;    -- signal indicating instruction memory is valid
           i_pc_enable      : in std_logic;    -- enable of program counter
           i_pending_req    : in std_logic;    -- aignal indicating a request has been granted by instr memory 
           flush            : out std_logic    -- signal to flush the pipeline
           );
end pipe_flusher;


architecture beh of pipe_flusher is

    signal reg_flush : std_logic := '0';
    signal reg_stall : std_logic := '0';

begin

    -- Output is immediate when jump_taken is asserted (combinational),
    -- and also stays asserted if reg_flush was latched previously.
    flush <= reg_flush or i_misprediction;
   -- flush<= reg_flush;
process(clk)
begin
    if rising_edge(clk) then
        -- active-low synchronous reset
        if rst_n = '0' then
            reg_flush <= '0';

        -- When a jump is taken, set the flush signal
        elsif i_misprediction = '1' then
            reg_flush <= '1';
        
        -- If there is a pending request in the fetch stage, wait until the relative valid and delete the instruction
        -- else flush untill a program counter enable, since no instruction is being fetched.#

        elsif i_pending_req = '1' then
            if valid_im = '1' then
                reg_flush <= '0';
            end if;
        elsif i_pc_enable = '1' then
            reg_flush <= '0';
        end if;
    end if;
end process;

end beh;
            