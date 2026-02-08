library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- ==============================================================
--  Random OBI  Memory
--  - req / ready / valid handshake
--  - ready RANDOM ogni ciclo
--  - valid RANDOM ma solo dopo una req accettata
--  - latenza variabile (1 .. MAX_LATENCY)
--  - byte enable supportato
--  - 1 outstanding request
-- ==============================================================

entity random_obi_memory is
    generic (
        MEM_WORDS   : integer := 1024; -- 4KB
        MAX_LATENCY : integer := 8
    );
    port (
        clk   : in  std_logic;
        rst_n   : in  std_logic;

        req   : in  std_logic;
        ready : out std_logic;
        valid : out std_logic;

        we    : in  std_logic;
        be    : in  std_logic_vector(3 downto 0);
        addr  : in  std_logic_vector(9 downto 0);
        wdata : in  std_logic_vector(31 downto 0);
        rdata : out std_logic_vector(31 downto 0)
    );
end entity;

architecture rtl of random_obi_memory is

    -- ==========================================================
    -- Memory array
    -- ==========================================================
    type mem_t is array (0 to MEM_WORDS-1) of std_logic_vector(31 downto 0);
    signal mem : mem_t := (others => (others => '0'));

    -- ==========================================================
    -- LFSR per random (indipendenti)
    -- ==========================================================
    signal lfsr_ready : std_logic_vector(7 downto 0) := x"A5";
    signal lfsr_lat   : std_logic_vector(7 downto 0) := x"3C";

    -- ==========================================================
    -- Stato richiesta
    -- ==========================================================
    signal busy      : std_logic := '0';
    signal delay_cnt : integer range 0 to MAX_LATENCY := 0;

    -- ==========================================================
    -- Request latched
    -- ==========================================================
    signal lat_addr  : unsigned(9 downto 0);
    signal lat_we    : std_logic;
    signal lat_be    : std_logic_vector(3 downto 0);
    signal lat_wdata : std_logic_vector(31 downto 0);

begin

    -- ==========================================================
    -- Random generators (LFSR)
    -- ==========================================================
    process(clk)
    begin
        if rising_edge(clk) then
            -- READY random
            lfsr_ready <= lfsr_ready(6 downto 0) &
                          (lfsr_ready(7) xor lfsr_ready(5));

            -- LATENCY random
            lfsr_lat <= lfsr_lat(6 downto 0) &
                        (lfsr_lat(7) xor lfsr_lat(4));
        end if;
    end process;

 
    ready <= lfsr_ready(0);

    -- ==========================================================
    -- Main memory process
    -- ==========================================================
    process(clk, rst_n)
        variable idx : integer;
    begin
        if rst_n = '0' then
            busy      <= '0';
            valid     <= '0';
            delay_cnt <= 0;
            rdata     <= (others => '0');

        elsif rising_edge(clk) then
            valid <= '0';

            -- Accettazione request
            if busy = '0' and req = '1' and ready = '1' then
                busy      <= '1';
                delay_cnt <= 1 + to_integer(unsigned(lfsr_lat(2 downto 0)));

                lat_addr  <= unsigned(addr);
                lat_we    <= we;
                lat_be    <= be;
                lat_wdata <= wdata;
            end if;

            -- Gestione latenza
            if busy = '1' then
                if delay_cnt > 0 then
                    delay_cnt <= delay_cnt - 1;
                else
                    idx := to_integer(lat_addr(9 downto 0));

                    -- WRITE
                    if lat_we = '1' then
                        for b in 0 to 3 loop
                            if lat_be(b) = '1' then
                                mem(idx)(8*b+7 downto 8*b) <=
                                    lat_wdata(8*b+7 downto 8*b);
                            end if;
                        end loop;
                    end if;

                    -- READ
                    rdata <= mem(idx);

                    valid <= '1';
                    busy  <= '0';
                end if;
            end if;
        end if;
    end process;

end architecture;
