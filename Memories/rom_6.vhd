--Instruction ROM loaded with UART test program and LED blinking
--It prints a starting message and then contonously the letter A.
-- The Leds blink following a counter.


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity rom_6 is
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

architecture rtl of rom_6 is

type mem_t is array (0 to WORDS-1) of std_logic_vector(31 downto 0);

constant ROM_INIT : mem_t := (


0 =>x"1fc21197",
1 =>x"80a18193",
2 =>x"0fc11117",
3 =>x"ff810113",
4 =>x"00010433",
5 =>x"100102b7",
6 =>x"54524337",
7 =>x"15530313",
8 =>x"0062a023",
9 =>x"0d4b5337",
10=>x"f2030313",
11=>x"0062a223",
12=>x"00a00313",
13=>x"0062a423",
14=>x"104000ef",
15=>x"0000006f",
16=>x"00000013",
17=>x"00000013",
18=>x"fe010113",
19=>x"00812e23",
20=>x"02010413",
21=>x"fea42623",
22=>x"0080006f",
23=>x"00000013",
24=>x"fec42783",
25=>x"fff78713",
26=>x"fee42623",
27=>x"fe0798e3",
28=>x"00000013",
29=>x"00000013",
30=>x"01c12403",
31=>x"02010113",
32=>x"00008067",
33=>x"fe010113",
34=>x"00812e23",
35=>x"02010413",
36=>x"00050793",
37=>x"fef407a3",
38=>x"00000013",
39=>x"100127b7",
40=>x"0007a703",
41=>x"010007b7",
42=>x"00f777b3",
43=>x"fe0798e3",
44=>x"100127b7",
45=>x"fef44703",
46=>x"00e7a023",
47=>x"fef44703",
48=>x"100127b7",
49=>x"10076713",
50=>x"00e7a023",
51=>x"00000013",
52=>x"01c12403",
53=>x"02010113",
54=>x"00008067",
55=>x"fe010113",
56=>x"00112e23",
57=>x"00812c23",
58=>x"02010413",
59=>x"fea42623",
60=>x"0240006f",
61=>x"fec42783",
62=>x"0007c783",
63=>x"0ff7f793",
64=>x"00078513",
65=>x"f81ff0ef",
66=>x"fec42783",
67=>x"00178793",
68=>x"fef42623",
69=>x"fec42783",
70=>x"0007c783",
71=>x"0ff7f793",
72=>x"fc079ae3",
73=>x"00000013",
74=>x"00000013",
75=>x"01c12083",
76=>x"01812403",
77=>x"02010113",
78=>x"00008067",
79=>x"fe010113",
80=>x"00112e23",
81=>x"00812c23",
82=>x"02010413",
83=>x"fe042623",
84=>x"100107b7",
85=>x"00078513",
86=>x"f85ff0ef",
87=>x"fec42783",
88=>x"00178713",
89=>x"fee42623",
90=>x"10011737",
91=>x"00f72023",
92=>x"04100513",
93=>x"f11ff0ef",
94=>x"0007a7b7",
95=>x"12078513",
96=>x"ec9ff0ef",
97=>x"fd9ff06f",


    others => (others => '0')
);

signal mem : mem_t := ROM_INIT;

begin
    -- always ready (single-cycle memory)
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

                    rdata <= mem(to_integer(unsigned(addr)));
                    valid <= '1';
                end if;
            end if;
    end process;

end architecture;
