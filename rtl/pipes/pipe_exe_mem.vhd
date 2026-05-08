library ieee ;
    use ieee.std_logic_1164.all ;


use pipe_pckg.all;

entity pipe_exe_mem is
  port (
    clk   : in std_logic;
    rst_n : in std_logic;
    enable: in std_logic;

    i_ctrl : in mem_ctrl_t;
    i_data : in mem_data_t;

    o_ctrl : out mem_ctrl_t;
    o_data : out mem_data_t

  );
end pipe_exe_mem; 

architecture arch of pipe_mem_wb is

begin

process (clk, rst_n)
begin
    if rst_n = '0' then
        o_ctrl <= MEM_CTRL_RST;

    elsif rising_edge(clk) then
        if enable = '1' then
            o_ctrl <= i_ctrl;
            o_data <= i_data;
        end if;
    end if;
end process;
end architecture ;