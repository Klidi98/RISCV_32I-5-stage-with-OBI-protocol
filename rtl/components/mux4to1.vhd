--mux4to1 file
--generic N bit mux 4 to 1

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity mux4to1 is
generic (
    N : integer := 32  -- larghezza del bus
  );
    Port (
        sel      : in  STD_LOGIC_VECTOR(1 downto 0);  -- Select input
        input_0  : in  STD_LOGIC_VECTOR(N-1 downto 0);  -- Input data 0
        input_1  : in  STD_LOGIC_VECTOR(N-1 downto 0);  -- Input data 1
        input_2  : in  STD_LOGIC_VECTOR(N-1 downto 0);  -- Input data 2
        input_3  : in  STD_LOGIC_VECTOR(N-1 downto 0);  -- Input data 3
        q        : out STD_LOGIC_VECTOR(N-1 downto 0)   -- Output data
    );
end mux4to1;

architecture beh of mux4to1 is
begin
    process(sel, input_0, input_1, input_2, input_3)
    begin
        case sel is
            when "00" =>
                q <= input_0;
            when "01" =>
                q <= input_1;
            when "10" =>
                q <= input_2;
            when "11" =>
                q <= input_3;
            when others =>
                q <= (others => '0');  -- Default case
        end case;
    end process;
end beh;
