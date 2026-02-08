--rom_4.vhd: 4-byte wide Read-Only Memory (ROM) with synchronous read
--Memory loaded witrh pseudo_casual generator algorithm that causes the LEDs to blink wioth different intensity and patterns.



library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity rom_4 is
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

architecture rtl of rom_4 is

type mem_t is array (0 to WORDS-1) of std_logic_vector(31 downto 0);

constant ROM_INIT : mem_t := (



0=> x"1fc21197",
1=> x"80018193",
2=> x"0fc11117",
3=> x"ff810113",
4=> x"00010433",
5=> x"054000ef",
6=> x"0000006f",
7=> x"00000013",
8=> x"00000013",
9=> x"fd010113",
10=>x"02812623",
11=>x"03010413",
12=>x"fca42e23",
13=>x"fe042623",
14=>x"0100006f",
15=>x"fec42783",
16=>x"00178793",
17=>x"fef42623",
18=>x"fec42783",
19=>x"fdc42703",
20=>x"fee7c6e3",
21=>x"00000013",
22=>x"00000013",
23=>x"02c12403",
24=>x"03010113",
25=>x"00008067",
26=>x"fb010113",
27=>x"04812623",
28=>x"05010413",
29=>x"0000b7b7",
30=>x"ce178793",
31=>x"fef42623",
32=>x"fa042a23",
33=>x"fa042c23",
34=>x"fa042e23",
35=>x"fc042023",
36=>x"fc042223",
37=>x"fc042423",
38=>x"fc042623",
39=>x"fc042823",
40=>x"fe042423",
41=>x"fec42783",
42=>x"0027d713",
43=>x"fec42783",
44=>x"00f74733",
45=>x"fec42783",
46=>x"0037d793",
47=>x"00f74733",
48=>x"fec42783",
49=>x"0057d793",
50=>x"00f747b3",
51=>x"0017f793",
52=>x"fcf42c23",
53=>x"fec42783",
54=>x"0017d713",
55=>x"fd842783",
56=>x"00f79793",
57=>x"00f767b3",
58=>x"fef42623",
59=>x"fe842703",
60=>x"000017b7",
61=>x"fff78793",
62=>x"00f777b3",
63=>x"04079663",
64=>x"fe042223",
65=>x"0380006f",
66=>x"fe442783",
67=>x"0017f793",
68=>x"fec42703",
69=>x"00f757b3",
70=>x"0ff7f713",
71=>x"fe442783",
72=>x"00279793",
73=>x"ff078793",
74=>x"008787b3",
75=>x"fce7a223",
76=>x"fe442783",
77=>x"00178793",
78=>x"fef42223",
79=>x"fe442703",
80=>x"00700793",
81=>x"fce7d2e3",
82=>x"fe042023",
83=>x"fe842783",
84=>x"0ff7f793",
85=>x"fcf42a23",
86=>x"fc042e23",
87=>x"0480006f",
88=>x"fdc42783",
89=>x"00279793",
90=>x"ff078793",
91=>x"008787b3",
92=>x"fc47a703",
93=>x"fd442783",
94=>x"02e7f063",
95=>x"fdc42783",
96=>x"00100713",
97=>x"00f717b3",
98=>x"00078713",
99=>x"fe042783",
100=>x"00e7e7b3",
101=>x"fef42023",
102=>x"fdc42783",
103=>x"00178793",
104=>x"fcf42e23",
105=>x"fdc42703",
106=>x"00700793",
107=>x"fae7dae3",
108=>x"100117b7",
109=>x"fe042703",
110=>x"00e7a023",
111=>x"fe842783",
112=>x"00178793",
113=>x"fef42423",
114=>x"eddff06f",

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
