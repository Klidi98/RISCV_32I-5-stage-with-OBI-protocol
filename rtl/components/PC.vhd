library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity PC is
    Port ( clk : in std_logic;
           rst_n : in std_logic;
           enable : in std_logic;
           data_in : in std_logic_vector(31 downto 0);
           q : out std_logic_vector(31 downto 0)
        );
end PC;

architecture Behavioral of PC is
    signal reg : std_logic_vector(31 downto 0) :="00000000010000000000000000000000";   --x"400000"
begin
    process (clk, rst_n)
    begin
        if rst_n = '0' then
            -- Asynchronous reset
            reg <= "00000000010000000000000000000000";
        elsif rising_edge(clk) then
            -- Synchronous update on rising edge of the clock
            if enable = '1' then
                reg <= data_in;
            end if;
        end if;
    end process;

    q <= reg;

end Behavioral;
