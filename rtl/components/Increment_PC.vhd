
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity increment_PC is
    Port (
        input  : in  STD_LOGIC_VECTOR(31 downto 0);  -- Input data
        output : out STD_LOGIC_VECTOR(31 downto 0)   -- Output data (input + 4)
    );
end increment_PC;

architecture Behavioral of increment_PC is
    signal sum : unsigned(31 downto 0);
begin
    sum <= unsigned(input) + to_unsigned(4, 32);     -- Add 4 to the input
    output <= std_logic_vector(sum);
end Behavioral;
