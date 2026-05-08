library ieee ;
    use ieee.std_logic_1164.all ;
    use ieee.numeric_std.all ;

use pipe_pckg.all;

entity pipe_mem_wb is
  port (
    clk   : in std_logic;
    rst_n : in std_logic;
    enable: in std_logic;

    i_ctrl : in ctrl_wb_t;
    i_data : in data_wb_t;

    o_ctrl : out ctrl_wb_t;
    o_data : out data_wb_t

  );
end pipe_mem_wb; 

architecture arch of pipe_mem_wb is

begin

process (clk, rst_n)
begin
    if rst_n = '0' then
        o_ctrl <= wb_ctrl_reset;
        o_data <= (others => (others => '0'));
    elsif rising_edge(clk) then
        if enable = '1' then
            o_ctrl <= i_ctrl;
            o_data <= i_data;
        end if;
    end if;
end process;
end architecture ;