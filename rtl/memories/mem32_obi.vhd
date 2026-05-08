library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mem32_obi is
    generic (
        MEM_WORDS : integer := 1024  -- 256 * 4 = 1 KB
    );
    port (
        clk   : in  std_logic;
       -- rst_n : in  std_logic;
        -- OBI-like interface
        req   : in  std_logic;               -- request from core
        we    : in  std_logic;               -- write enable
        addr  : in  std_logic_vector(9 downto 0);
        wdata : in  std_logic_vector(31 downto 0);

        ready : out std_logic;               -- memory ready to accept request
        valid : out std_logic;               -- memory returning data
        rdata : out std_logic_vector(31 downto 0)
    );
end entity;

architecture rtl of mem32_obi is

    -- Memory array
    type mem_t is array(0 to MEM_WORDS-1) of std_logic_vector(31 downto 0);
    signal mem : mem_t; --:= (others => (others => '0'));

    -- Internal control
    signal busy         : std_logic := '0';
    signal delay_cnt    : integer := 0;
    signal delay_target : integer := 0;
    signal saved_addr   : unsigned(9 downto 0);

    -- LFSR for pseudo-random latency
    signal lfsr : std_logic_vector(7 downto 0) := "10101010";

begin

    ------------------------------------------
    -- READY = '1' only when not busy
    ------------------------------------------
    ready <= not busy;

    ------------------------------------------
    -- VALID pulse when data available
    ------------------------------------------
    process(clk)
    begin
       
        if rising_edge(clk) then

                ---------------------------------------------------------
                -- LFSR update – used to generate random access latency
                ---------------------------------------------------------
                lfsr <= lfsr(6 downto 0) & (lfsr(7) xor lfsr(5));

                ---------------------------------------------------------
                -- Accept a request when ready = '1'
                ---------------------------------------------------------
                if busy = '0' and req = '1' then
                    busy <= '1';
                    valid <= '0';
                    saved_addr <= unsigned(addr); -- word aligned

                    -- Write immediately
                    if we = '1' then
                        mem(to_integer(unsigned(addr))) <= wdata;
                    end if;

                    -- Random latency target between 1 and 8 cycles
                    delay_target <= (to_integer(unsigned(lfsr(2 downto 0))) mod 5) + 1;
                    delay_cnt <= 0;
                end if;

                ---------------------------------------------------------
                -- If busy, count cycles until latency is reached
                ---------------------------------------------------------
                if busy = '1' then
                    delay_cnt <= delay_cnt + 1;

                    if delay_cnt = delay_target then
                        valid <= '1';
                        busy  <= '0';
                        rdata <= mem(to_integer(saved_addr));
                    else
                        valid <= '0';
                    end if;
                else
                    valid <= '0';
                end if;

            end if;

    end process;

end architecture;
