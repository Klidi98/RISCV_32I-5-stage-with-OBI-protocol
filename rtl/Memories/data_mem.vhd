library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity data_mem is
    generic (
        WORDS : integer := 1024   -- 1024 * 4 byte = 4 KB
    );
    port (
        clk     : in  std_logic;
        rst_n   : in  std_logic;
        req     : in  std_logic;
        we      : in  std_logic;
        be      : in  std_logic_vector(3 downto 0); 
        addr    : in  std_logic_vector(9 downto 0);
        wdata   : in  std_logic_vector(31 downto 0);
        
        ready   : out std_logic;
        valid   : out std_logic;
        rdata   : out std_logic_vector(31 downto 0)
    );
end entity;

architecture rtl of data_mem is
    -- Un unico banco di memoria da 32 bit
    type mem_t is array (0 to WORDS-1) of std_logic_vector(31 downto 0);
    signal mem : mem_t := (others => (others => '0'));

begin

    ready <= '1';

    process(clk)
    begin
        if rising_edge(clk) then
            if req = '1' then
                -- Scrittura selettiva per byte su un unico banco
                if we = '1' then
                    -- Ogni IF controlla una "fetta" da 8 bit della stessa locazione
                    if be(0) = '1' then mem(to_integer(unsigned(addr)))(7 downto 0)   <= wdata(7 downto 0);   end if;
                    if be(1) = '1' then mem(to_integer(unsigned(addr)))(15 downto 8)  <= wdata(15 downto 8);  end if;
                    if be(2) = '1' then mem(to_integer(unsigned(addr)))(23 downto 16) <= wdata(23 downto 16); end if;
                    if be(3) = '1' then mem(to_integer(unsigned(addr)))(31 downto 24) <= wdata(31 downto 24); end if;
                end if;

                -- Lettura sincrona dell'intera word
                rdata <= mem(to_integer(unsigned(addr)));
            end if;
        end if;
    end process;

    -- Logica del segnale Valid
    process(clk)
    begin
        if rising_edge(clk) then
            if rst_n = '0' then
                valid <= '0';
            else
                valid <= req; 
            end if;
        end if;
    end process;

end architecture;