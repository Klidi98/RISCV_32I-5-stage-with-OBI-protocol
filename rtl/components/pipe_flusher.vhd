library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity pipe_flusher is
    Port ( 
           clk        : in std_logic;   
           rst_n      : in std_logic;   
           jump_taken : in std_logic;                     -- signal indicating a jump has been taken
           valid_im   : in std_logic;                     -- signal indicating instruction memory is valid            
           flush      : out std_logic                     -- signal to flush the pipeline
           );
end pipe_flusher;


architecture beh of pipe_flusher is

    signal reg_flush : std_logic := '0';
    signal reg_stall : std_logic := '0';

begin

    -- Output is immediate when jump_taken is asserted (combinational),
    -- and also stays asserted if reg_flush was latched previously.
    flush <= reg_flush or jump_taken;
   -- flush<= reg_flush;
process(clk)
begin
    if rising_edge(clk) then
        -- active-low synchronous reset
        if rst_n = '0' then
            reg_flush <= '0';

        -- When a jump is taken, set the flush signal
        elsif jump_taken = '1' then
            reg_flush <= '1';
            
        -- when instruction memory indicates valid, clear the latched flush
        elsif valid_im = '1' then
            reg_flush <= '0';
        end if;
    end if;
end process;

end beh;
            