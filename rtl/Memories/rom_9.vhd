--Instruction ROM loaded with IPC performance test 1.

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity rom_9 is
    generic (
        WORDS : integer := 1024   -- 256 * 4B = 1 KB
    );
    port (
        clk     : in  std_logic;
--        rst_n   : in  std_logic;

        req    : in  std_logic;
        we     : in  std_logic;
        addr   : in  std_logic_vector(9 downto 0);  -- word address
        wdata  : in  std_logic_vector(31 downto 0);

        ready  : out std_logic;
        valid  : out std_logic;
        rdata  : out std_logic_vector(31 downto 0)
    );
end entity;

architecture rtl of rom_9 is

type mem_t is array (0 to WORDS-1) of std_logic_vector(31 downto 0);

constant ROM_INIT : mem_t := (


 x"1fc21197",
 x"80018193",
 x"0fc11117",
 x"ff810113",
 x"00010433",
 x"010000ef",
 x"0000006f",
 x"00000013",
 x"00000013",
 x"10011137",
 x"00002537",
 x"71050513",
 x"10013d37",
 x"10014db7",
 x"000d2403",
 x"000da483",
 x"00100393",
 x"00200e13",
 x"00300e93",
 x"00400f13",
 x"00500f93",
 x"01c383b3",
 x"01de0e33",
 x"01ee8eb3",
 x"01ff0f33",
 x"007f8fb3",
 x"01c383b3",
 x"01de0e33",
 x"01ee8eb3",
 x"01ff0f33",
 x"007f8fb3",
 x"01c383b3",
 x"01de0e33",
 x"01ee8eb3",
 x"01ff0f33",
 x"007f8fb3",
 x"01c383b3",
 x"01de0e33",
 x"01ee8eb3",
 x"01ff0f33",
 x"007f8fb3",
 x"01c383b3",
 x"01de0e33",
 x"01ee8eb3",
 x"01ff0f33",
 x"007f8fb3",
 x"01c383b3",
 x"01de0e33",
 x"01ee8eb3",
 x"01ff0f33",
 x"007f8fb3",
 x"01c383b3",
 x"01de0e33",
 x"01ee8eb3",
 x"01ff0f33",
 x"007f8fb3",
 x"01c383b3",
 x"01de0e33",
 x"01ee8eb3",
 x"01ff0f33",
 x"007f8fb3",
 x"01c383b3",
 x"01de0e33",
 x"01ee8eb3",
 x"01ff0f33",
 x"007f8fb3",
 x"01c383b3",
 x"01de0e33",
 x"01ee8eb3",
 x"01ff0f33",
 x"007f8fb3",
 x"01c383b3",
 x"01de0e33",
 x"01ee8eb3",
 x"01ff0f33",
 x"007f8fb3",
 x"01c383b3",
 x"01de0e33",
 x"01ee8eb3",
 x"01ff0f33",
 x"007f8fb3",
 x"01c383b3",
 x"01de0e33",
 x"01ee8eb3",
 x"01ff0f33",
 x"007f8fb3",
 x"01c383b3",
 x"01de0e33",
 x"01ee8eb3",
 x"01ff0f33",
 x"007f8fb3",
 x"01c383b3",
 x"01de0e33",
 x"01ee8eb3",
 x"01ff0f33",
 x"007f8fb3",
 x"01c383b3",
 x"01de0e33",
 x"01ee8eb3",
 x"01ff0f33",
 x"007f8fb3",
 x"01c383b3",
 x"01de0e33",
 x"01ee8eb3",
 x"01ff0f33",
 x"007f8fb3",
 x"01c383b3",
 x"01de0e33",
 x"01ee8eb3",
 x"01ff0f33",
 x"007f8fb3",
 x"01c383b3",
 x"01de0e33",
 x"01ee8eb3",
 x"01ff0f33",
 x"007f8fb3",
 x"01c383b3",
 x"01de0e33",
 x"01ee8eb3",
 x"01ff0f33",
 x"007f8fb3",
 x"fff50513",
 x"e60516e3",
 x"000d2903",
 x"000da983",
 x"40890933",
 x"409989b3",
 x"04300513",
 x"044000ef",
 x"03a00513",
 x"03c000ef",
 x"00090513",
 x"05c000ef",
 x"00a00513",
 x"02c000ef",
 x"04900513",
 x"024000ef",
 x"03a00513",
 x"01c000ef",
 x"00098513",
 x"03c000ef",
 x"100112b7",
 x"00100313",
 x"0062a023",
 x"0000006f",
 x"100125b7",
 x"0005a603",
 x"010006b7",
 x"00d67633",
 x"fe061ae3",
 x"10000693",
 x"00d56633",
 x"00c5a023",
 x"00a5a023",
 x"00008067",
 x"fe010113",
 x"00112e23",
 x"00812c23",
 x"00912a23",
 x"00050413",
 x"00700493",
 x"00249713",
 x"00e45533",
 x"00f57513",
 x"00a00793",
 x"00f54663",
 x"03750513",
 x"0080006f",
 x"03050513",
 x"fa1ff0ef",
 x"fff48493",
 x"fff00793",
 x"fcf49ae3",
 x"01412483",
 x"01812403",
 x"01c12083",
 x"02010113",
 x"00008067",

    others => (others => '0')
);

signal mem : mem_t := ROM_INIT;

begin
    -- sempre pronta (single-cycle memory)
    ready <= '1';

    process(clk)
    begin
        if rising_edge(clk) then
            
                --rdata <= (others => '0');

                valid <= '0';

                if req = '1' then

                    if we = '1' then
                        mem(to_integer(unsigned(addr))) <= wdata;
                    end if;

                    -- lettura sincrona
                    rdata <= mem(to_integer(unsigned(addr)));
                    valid <= '1';
                end if;
            end if;
    end process;

end architecture;
