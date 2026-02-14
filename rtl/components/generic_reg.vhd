library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity generic_reg is
    generic (
        
        N : integer := 32
    );
    Port (
        CLK     : in  std_logic;          
        RESET   : in  std_logic;          
        ENABLE  : in  std_logic;         
        D_IN    : in  std_logic_vector( N-1 downto 0); 
        D_OUT   : out std_logic_vector(N-1 downto 0)  
    );
end generic_reg;

architecture Behavioral of generic_reg is
    signal reg : std_logic_vector(N-1 downto 0) := (others => '0'); 
begin
    process (CLK, RESET)
    begin
        if (RESET = '0') then           
            reg <= (others => '0');
        elsif rising_edge(CLK) then   
            if (ENABLE = '1') then     
                reg <= D_IN;          
            end if;
        end if;
    end process;

    D_OUT <= reg;                      -- Output registered data
end Behavioral;