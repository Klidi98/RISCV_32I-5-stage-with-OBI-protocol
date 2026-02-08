library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pipe_IF_ID is
    port (
        clk                 : in  std_logic;                           -- Clock input
        reset_n             : in  std_logic;                           -- Reset input (active low)
        enable_i            : in  std_logic;
        flusher             : in  std_logic;
         -- Ingressi
        instruction_i       : in  std_logic_vector(31 downto 0);     
        current_PC_i        : in  std_logic_vector(31 downto 0);   
        previous_PC_i       : in  std_logic_vector(31 downto 0); 
       
     
        Instruction_o       : out std_logic_vector(31 downto 0);
        current_pc_o        : out std_logic_vector(31 downto 0);
        previous_pc_o       : out std_logic_vector(31 downto 0)
    
    );
end entity pipe_IF_ID;

architecture rtl of pipe_IF_ID is

begin
    -- dichiarazione componente Register32bit
process(reset_n, clk)
begin
    if reset_n = '0' then
        instruction_o   <= (others =>'0');
        
    elsif rising_edge(clk) then
        if flusher = '1' then 
            instruction_o   <= (others => '0');

        elsif enable_i = '1' then
            Instruction_o <= Instruction_i;
            current_pc_o  <= current_pc_i ;
            previous_pc_o <= previous_pc_i;
        end if;
    end if;
end process;

end architecture rtl;