library ieee;
use ieee.std_logic_1164.all;

entity pipe_staller is
    port (
        clk             : in  std_logic;
        rst_n           : in  std_logic;
        request_dm      : in  std_logic;
        valid           : in  std_logic;
        block_pipe      : out std_logic
    );
end entity;

architecture rtl of pipe_staller is
    
    signal reg_stall : std_logic := '0';

begin

reg_stall <= not(valid) when request_dm = '1' else '0';
block_pipe <= reg_stall;
 
end architecture;
