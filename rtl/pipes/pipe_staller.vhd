library ieee;
use ieee.std_logic_1164.all;

entity pipe_staller is
    port (
        clk             : in  std_logic;
        rst_n           : in  std_logic;
        request_dm      : in  std_logic;     --signal indicating memory access instruction. This is the signal generated in the control unit arrived in mem stage,
                                             --not the actual request sent to memory.
        valid           : in  std_logic;
        block_pipe      : out std_logic
    );
end entity;

architecture rtl of pipe_staller is
    
    signal reg_stall : std_logic := '0';

begin

    --during a load or store instruction in mem, valid from dmem acts as enable of the pipe.
reg_stall <= not(valid) when request_dm = '1' else '0';
    
block_pipe <= reg_stall;
 
end architecture;
