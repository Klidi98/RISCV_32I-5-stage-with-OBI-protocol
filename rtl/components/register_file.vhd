
--Register_File.vhd file
--added an update on the outputs to handle the case in which an instruction wants to read a register that is being written in that same cycle
--If this is the case the WriteData signal is forwarded directly on the output of the register(Rd1 or Rd2)
--This allows not to introduce a NOP instruction
--Klides Kaba
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity register_file is
    Port (
        clk        : in  STD_LOGIC;                     -- Clock input
        wr_enable  : in  STD_LOGIC;                     -- Enable signal for writing operation
        readAddr1  : in  STD_LOGIC_VECTOR(4 downto 0); -- Address for first read port
        readAddr2  : in  STD_LOGIC_VECTOR(4 downto 0); -- Address for second read port
        writeAddr  : in  STD_LOGIC_VECTOR(4 downto 0); -- Address for write port
        writeData  : in  STD_LOGIC_VECTOR(31 downto 0); -- Data to be written
        readData1  : out STD_LOGIC_VECTOR(31 downto 0); -- Data from first read port
        readData2  : out STD_LOGIC_VECTOR(31 downto 0)  -- Data from second read port
    );
end register_file;

architecture Behavioral of register_file is

    signal en_addr_0 : std_logic;

    type RegisterArray is array (0 to 31) of STD_LOGIC_VECTOR(31 downto 0);
    signal registers : RegisterArray := (
                2 => "01111111111111111110111111111100",
        3 =>"00010000000000001000000000000000",
        others=>(others=>'0'));

begin
-- Forwarding logic for read ports
    en_addr_0 <= '1' when writeAddr /= "00000" else '0';

      readData1 <= writeData when (wr_enable = '1' and readAddr1 = writeAddr and en_addr_0 = '1') else registers(to_integer(unsigned(readAddr1)));
      readData2 <= writeData when (wr_enable = '1' and readAddr2 = writeAddr and en_addr_0 = '1') else registers(to_integer(unsigned(readAddr2)));


process(clk)
begin
    if rising_edge(clk) then
        -- Write operation with enable signal
        if wr_enable = '1' and en_addr_0 = '1' then
            registers(to_integer(unsigned(writeAddr))) <= writeData;
        end if;
    end if;
            end process;

end Behavioral;
