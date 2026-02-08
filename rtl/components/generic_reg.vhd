library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity generic_reg is
    generic (
        -- Generic parameters can be added here if needed
        N : integer := 32
    );
    Port (
        CLK     : in  std_logic;          -- Clock input
        RESET   : in  std_logic;          -- Reset input
        ENABLE  : in  std_logic;          -- Enable input
        D_IN    : in  std_logic_vector( N-1 downto 0); -- Data input
        D_OUT   : out std_logic_vector(N-1 downto 0)  -- Data output
    );
end generic_reg;

architecture Behavioral of generic_reg is
    signal reg : std_logic_vector(N-1 downto 0) := (others => '0'); -- Register declaration
begin
    process (CLK, RESET)
    begin
        if (RESET = '0') then           -- Asynchronous reset
            reg <= (others => '0');
        elsif rising_edge(CLK) then    -- Clock edge trigger
            if (ENABLE = '1') then     -- Check if enable is asserted
                reg <= D_IN;           -- Assign input data to register only when ENABLE is '1'
            end if;
        end if;
    end process;

    D_OUT <= reg;                      -- Output registered data
end Behavioral;