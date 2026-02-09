--rom_4.vhd: 4-byte wide Read-Only Memory (ROM) with synchronous read
--Memory  loaded with pseudo_casual generator algorithm for blinking LEDs


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity rom_5 is
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

architecture rtl of rom_5 is

type mem_t is array (0 to WORDS-1) of std_logic_vector(31 downto 0);

constant ROM_INIT : mem_t := (


0 =>x"1fc21197",
1 =>x"80018193",
2 =>x"0fc11117",
3 =>x"ff810113",
4 =>x"00010433",
5 =>x"054000ef",
6 =>x"0000006f",
7 =>x"00000013",
8 =>x"00000013",
9 =>x"fd010113",
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
26=>x"fc010113",
27=>x"02112e23",
28=>x"02812c23",
29=>x"04010413",
30=>x"100117b7",
31=>x"fcf42a23",
32=>x"100107b7",
33=>x"fcf42823",
34=>x"fe042423",
35=>x"0340006f",
36=>x"01000713",
37=>x"fe842783",
38=>x"40f706b3",
39=>x"fe842783",
40=>x"00279793",
41=>x"fd042703",
42=>x"00f707b3",
43=>x"00068713",
44=>x"00e7a023",
45=>x"fe842783",
46=>x"00178793",
47=>x"fef42423",
48=>x"fe842703",
49=>x"00f00793",
50=>x"fce7d4e3",
51=>x"fd442783",
52=>x"00100713",
53=>x"00e7a023",
54=>x"000317b7",
55=>x"d4078513",
56=>x"f45ff0ef",
57=>x"fe042223",
58=>x"0ec0006f",
59=>x"fe042023",
60=>x"0a00006f",
61=>x"fe042783",
62=>x"00279793",
63=>x"fd042703",
64=>x"00f707b3",
65=>x"0007a703",
66=>x"fe042783",
67=>x"00178793",
68=>x"00279793",
69=>x"fd042683",
70=>x"00f687b3",
71=>x"0007a783",
72=>x"06e7f263",
73=>x"fe042783",
74=>x"00279793",
75=>x"fd042703",
76=>x"00f707b3",
77=>x"0007a783",
78=>x"fcf42623",
79=>x"fe042783",
80=>x"00178793",
81=>x"00279793",
82=>x"fd042703",
83=>x"00f70733",
84=>x"fe042783",
85=>x"00279793",
86=>x"fd042683",
87=>x"00f687b3",
88=>x"00072703",
89=>x"00e7a023",
90=>x"fe042783",
91=>x"00178793",
92=>x"00279793",
93=>x"fd042703",
94=>x"00f707b3",
95=>x"fcc42703",
96=>x"00e7a023",
97=>x"fe042783",
98=>x"00178793",
99=>x"fef42023",
100=>x"00f00713",
101=>x"fe442783",
102=>x"40f707b3",
103=>x"fe042703",
104=>x"f4f74ae3",
105=>x"fe442783",
106=>x"00100713",
107=>x"00f717b3",
108=>x"00078713",
109=>x"fd442783",
110=>x"00e7a023",
111=>x"000f47b7",
112=>x"24078513",
113=>x"e61ff0ef",
114=>x"fe442783",
115=>x"00178793",
116=>x"fef42223",
117=>x"fe442703",
118=>x"00e00793",
119=>x"f0e7d8e3",
120=>x"fe042623",
121=>x"fc042e23",
122=>x"0300006f",
123=>x"fdc42783",
124=>x"00279793",
125=>x"fd042703",
126=>x"00f707b3",
127=>x"0007a783",
128=>x"fec42703",
129=>x"00f707b3",
130=>x"fef42623",
131=>x"fdc42783",
132=>x"00178793",
133=>x"fcf42e23",
134=>x"fdc42703",
135=>x"00f00793",
136=>x"fce7d6e3",
137=>x"fec42703",
138=>x"08800793",
139=>x"04f71a63",
140=>x"fc042c23",
141=>x"03c0006f",
142=>x"fd442783",
143=>x"0ff00713",
144=>x"00e7a023",
145=>x"000f47b7",
146=>x"24078513",
147=>x"dd9ff0ef",
148=>x"fd442783",
149=>x"0007a023",
150=>x"000f47b7",
151=>x"24078513",
152=>x"dc5ff0ef",
153=>x"fd842783",
154=>x"00178793",
155=>x"fcf42c23",
156=>x"fd842703",
157=>x"00200793",
158=>x"fce7d0e3",
159=>x"e0dff06f",
160=>x"fd442783",
161=>x"0aa00713",
162=>x"00e7a023",
163=>x"0000006f",


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
