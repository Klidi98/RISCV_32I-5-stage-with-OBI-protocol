library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity Adder_sub is
    Port ( a : in STD_LOGIC_VECTOR(31 downto 0);
           b : in STD_LOGIC_VECTOR(31 downto 0);
           subtract : in STD_LOGIC;
           result : out STD_LOGIC_VECTOR(31 downto 0));
           
end Adder_sub;

architecture Behavioral of adder_sub is
    signal sum_temp : signed(31 downto 0);
begin
    process (a, b, subtract)
    begin
        if subtract = '1' then
            sum_temp <= signed(a) - signed(b);
        else
            sum_temp <= signed(a) + signed(b);
        end if;
    end process;

    result <= std_logic_vector(sum_temp);


end Behavioral;