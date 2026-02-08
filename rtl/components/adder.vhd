library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity Adder is
    Port ( a : in STD_LOGIC_VECTOR(31 downto 0);
           b : in STD_LOGIC_VECTOR(31 downto 0);
           sum : out STD_LOGIC_VECTOR(31 downto 0));
          
end Adder;

architecture Behavioral of Adder is
    signal sum_temp : signed(31 downto 0);
begin
    process (a, b)
    begin
        sum_temp <= signed(a) + signed(b);
    end process;

    sum <= std_logic_vector(sum_temp);
  end Behavioral;