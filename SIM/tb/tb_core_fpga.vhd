library ieee;
use ieee.std_logic_1164.all;

entity tb_fpga is
end entity;

architecture sim of tb_fpga is

    signal clk   : std_logic := '0';
    signal rst_n : std_logic := '0';

begin

    ----------------------------------------------------------------
    -- Clock generation: 10 ns period (100 MHz)
    ----------------------------------------------------------------
    clk <= not clk after 2 ns;

    ----------------------------------------------------------------
    -- Reset generation
    ----------------------------------------------------------------
    reset_proc : process
    begin
        rst_n <= '0';        -- reset asserted
        wait for 500 ns;
        rst_n <= '1';        -- release reset
        wait for 5000 ns;                -- stop here
	rst_n <= '0';
	wait for 100 ns;
	rst_n <= '1';
	wait;
    end process;

    ----------------------------------------------------------------
    -- DUT instantiation (example)
    ----------------------------------------------------------------
     dut : entity work.micro_cpu_fpga
     port map (
         x_clk   => clk,
         x_rst_n => rst_n

     );

end architecture;
