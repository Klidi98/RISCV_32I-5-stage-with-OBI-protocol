library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mem_fpga is
    generic (
        WORDS : integer := 1024   -- 1024 * 4 byte = 4 KB
    );
    port (
        clk     : in  std_logic;
        rst_n   : in  std_logic;
        -- Segnali interfaccia tipo OBI
        req     : in  std_logic;
        we      : in  std_logic;
        be      : in  std_logic_vector(3 downto 0); 
        addr    : in  std_logic_vector(9 downto 0);  -- Indirizzo di word
        wdata   : in  std_logic_vector(31 downto 0);
        
        ready   : out std_logic;
        valid   : out std_logic;
        rdata   : out std_logic_vector(31 downto 0)
    );
end entity;

architecture rtl of mem_fpga is
    -- Definiamo 4 banchi di memoria da 8 bit l'uno
    type byte_mem_t is array (0 to WORDS-1) of std_logic_vector(7 downto 0);
    signal mem0 : byte_mem_t := (others => (others => '0'));
    signal mem1 : byte_mem_t := (others => (others => '0'));
    signal mem2 : byte_mem_t := (others => (others => '0'));
    signal mem3 : byte_mem_t := (others => (others => '0'));

    -- Attributo per forzare Quartus a non fare controlli di lettura/scrittura contemporanea
    -- che spesso impediscono l'inferenza della RAM hardware

begin

    -- Memoria sempre pronta per rispondere (protocollo OBI semplificato)
    ready <= '1';

    process(clk)
    begin
        if rising_edge(clk) then
            if req = '1' then
                -- Scrittura selettiva per byte (Inference dei Byte Enable hardware)
                if we = '1' then
                    if be(0) = '1' then mem0(to_integer(unsigned(addr))) <= wdata(7 downto 0);   end if;
                    if be(1) = '1' then mem1(to_integer(unsigned(addr))) <= wdata(15 downto 8);  end if;
                    if be(2) = '1' then mem2(to_integer(unsigned(addr))) <= wdata(23 downto 16); end if;
                    if be(3) = '1' then mem3(to_integer(unsigned(addr))) <= wdata(31 downto 24); end if;
                end if;

                -- Lettura sincrona (Fondamentale: deve essere dentro l'if req)
                rdata(7 downto 0)   <= mem0(to_integer(unsigned(addr)));
                rdata(15 downto 8)  <= mem1(to_integer(unsigned(addr)));
                rdata(23 downto 16) <= mem2(to_integer(unsigned(addr)));
                rdata(31 downto 24) <= mem3(to_integer(unsigned(addr)));
            end if;
        end if;
    end process;

    -- Gestione del segnale valid (separata per permettere il reset)
    process(clk)
    begin
        if rising_edge(clk) then
            if rst_n = '0' then
                valid <= '0';
            else
                valid <= req; -- Il dato è valido nel ciclo successivo alla richiesta
            end if;
        end if;
    end process;

end architecture;