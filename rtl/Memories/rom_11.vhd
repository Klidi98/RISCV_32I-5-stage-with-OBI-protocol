-- Instruction rom containing the IPC performance test 3.


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity rom_11 is
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

architecture rtl of rom_11 is

type mem_t is array (0 to WORDS-1) of std_logic_vector(31 downto 0);

constant ROM_INIT : mem_t := (

 x"1fc21197",
 x"80018193",
 x"0fc11117",
 x"ff810113",
 x"00010433",
 x"290000ef",
 x"0000006f",
 x"00000013",
 x"00000013",
 x"fe010113",
 x"00812e23",
 x"02010413",
 x"00050793",
 x"fef407a3",
 x"00000013",
 x"100127b7",
 x"0007a703",
 x"010007b7",
 x"00f777b3",
 x"fe0798e3",
 x"100127b7",
 x"fef44703",
 x"00e7a023",
 x"fef44703",
 x"100127b7",
 x"10076713",
 x"00e7a023",
 x"100127b7",
 x"fef44703",
 x"00e7a023",
 x"00000013",
 x"01c12403",
 x"02010113",
 x"00008067",
 x"fd010113",
 x"02112623",
 x"02812423",
 x"03010413",
 x"fca42e23",
 x"00700793",
 x"fef42623",
 x"0600006f",
 x"fec42783",
 x"00279793",
 x"fdc42703",
 x"00f757b3",
 x"00f7f793",
 x"fef42423",
 x"fe842703",
 x"00900793",
 x"00e7ec63",
 x"fe842783",
 x"0ff7f793",
 x"03078793",
 x"0ff7f793",
 x"0140006f",
 x"fe842783",
 x"0ff7f793",
 x"03778793",
 x"0ff7f793",
 x"00078513",
 x"f31ff0ef",
 x"fec42783",
 x"fff78793",
 x"fef42623",
 x"fec42783",
 x"fa07d0e3",
 x"00000013",
 x"00000013",
 x"02c12083",
 x"02812403",
 x"03010113",
 x"00008067",
 x"ff010113",
 x"00112623",
 x"00812423",
 x"01010413",
 x"00a00513",
 x"eedff0ef",
 x"00000013",
 x"00c12083",
 x"00812403",
 x"01010113",
 x"00008067",
 x"ff010113",
 x"00112623",
 x"00812423",
 x"01010413",
 x"04300513",
 x"ec1ff0ef",
 x"05900513",
 x"eb9ff0ef",
 x"04300513",
 x"eb1ff0ef",
 x"04c00513",
 x"ea9ff0ef",
 x"04500513",
 x"ea1ff0ef",
 x"05300513",
 x"e99ff0ef",
 x"03a00513",
 x"e91ff0ef",
 x"02000513",
 x"e89ff0ef",
 x"00000013",
 x"00c12083",
 x"00812403",
 x"01010113",
 x"00008067",
 x"ff010113",
 x"00112623",
 x"00812423",
 x"01010413",
 x"04900513",
 x"e5dff0ef",
 x"04e00513",
 x"e55ff0ef",
 x"05300513",
 x"e4dff0ef",
 x"05400513",
 x"e45ff0ef",
 x"05200513",
 x"e3dff0ef",
 x"03a00513",
 x"e35ff0ef",
 x"02000513",
 x"e2dff0ef",
 x"00000013",
 x"00c12083",
 x"00812403",
 x"01010113",
 x"00008067",
 x"fe010113",
 x"00812e23",
 x"02010413",
 x"00100793",
 x"fef42423",
 x"00200793",
 x"fef42223",
 x"00300793",
 x"fef42023",
 x"fe042623",
 x"0480006f",
 x"fe842703",
 x"fe442783",
 x"00f707b3",
 x"fef42423",
 x"fe442703",
 x"fe042783",
 x"00f747b3",
 x"fef42223",
 x"fe042783",
 x"00179713",
 x"fe042783",
 x"01f7d793",
 x"00f767b3",
 x"fef42023",
 x"fec42783",
 x"00178793",
 x"fef42623",
 x"fec42703",
 x"000187b7",
 x"69f78793",
 x"fae7d8e3",
 x"00000013",
 x"00000013",
 x"01c12403",
 x"02010113",
 x"00008067",
 x"fd010113",
 x"02112623",
 x"02812423",
 x"03010413",
 x"04200513",
 x"d6dff0ef",
 x"04f00513",
 x"d65ff0ef",
 x"04f00513",
 x"d5dff0ef",
 x"05400513",
 x"d55ff0ef",
 x"e51ff0ef",
 x"100137b7",
 x"0007a783",
 x"fef42623",
 x"100147b7",
 x"0007a783",
 x"fef42423",
 x"f21ff0ef",
 x"100137b7",
 x"0007a783",
 x"fef42223",
 x"100147b7",
 x"0007a783",
 x"fef42023",
 x"fe442703",
 x"fec42783",
 x"40f707b3",
 x"fcf42e23",
 x"fe042703",
 x"fe842783",
 x"40f707b3",
 x"fcf42c23",
 x"e25ff0ef",
 x"fdc42503",
 x"d55ff0ef",
 x"dedff0ef",
 x"e79ff0ef",
 x"fd842503",
 x"d45ff0ef",
 x"dddff0ef",
 x"100117b7",
 x"00100713",
 x"00e7a023",
 x"0000006f",


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
