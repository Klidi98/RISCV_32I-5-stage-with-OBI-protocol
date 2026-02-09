library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- ENTITY: definisce l'interfaccia tra il protocollo OBI e la memoria SRAM
entity mem_wrap is
    port (
        clk     : in  std_logic;
        rst_n   : in  std_logic;

        -- Interfaccia OBI semplificata
        req     : in  std_logic;                      -- richiesta di transazione (read/write)
        we      : in  std_logic;                      -- write enable: '1' = write, '0' = read
        addr    : in  std_logic_vector(9 downto 0);   -- indirizzo (fino a 1024 parole = 10 bit)
        wdata   : in  std_logic_vector(31 downto 0);  -- dato da scrivere

        ready   : out std_logic;                      -- sempre '1', memoria sempre pronta
        valid   : out std_logic;                      -- valido a '1' per 1 ciclo dopo una lettura
        rdata   : out std_logic_vector(31 downto 0)   -- dato letto
    );
end entity;

architecture beh of mem_wrap is

    -- COMPONENTE: dichiarazione della memoria SRAM vera e propria
    component sram_32_1024_freepdk45 is
        port (
            clk0  : in std_logic;
            csb0  : in std_logic;               -- chip select (active low)
            web0  : in std_logic;               -- write enable (active low)
            addr0 : in std_logic_vector(9 downto 0);
            din0  : in std_logic_vector(31 downto 0);
            dout0 : out std_logic_vector(31 downto 0)
        );
    end component;

    -- SIGNALI INTERNI: segnali collegati alla SRAM
    signal csb0     : std_logic := '1';  -- chip select default disattivo
    signal web0    : std_logic := '1';  -- write enable disattivato
    signal addr0   : std_logic_vector(9 downto 0);  -- indirizzo interno
    signal din0    : std_logic_vector(31 downto 0); -- dato da scrivere
    signal dout0   : std_logic_vector(31 downto 0); -- dato letto
    signal valid_d : std_logic := '0';              -- segnale di valid intermedio
    -- SIGNALI per gestire valid dopo una lettura
    --signal read_pending : std_logic := '0';         -- segnale che indica una lettura in attesa
    --signal valid_reg    : std_logic := '0';         -- segnale di valid ritardato di un ciclo

begin

    mem_inst: sram_32_1024_freepdk45
        port map (
            
            clk0  => clk,
            csb0  => csb0,
            web0  => web0,
            addr0 => addr0,
            din0  => din0,
            dout0 => dout0
        );

ready <= '1';
csb0 <= '0' when req = '1' else '1';
web0 <= '0' when we = '1' else '1';
addr0<= addr;
din0<= wdata;
rdata<=dout0;

process(clk, req)
begin
if rising_edge(clk) then
    valid_d <= req ;
end if;
end process;

process(clk)
begin
if falling_edge(clk) then
    valid <= valid_d ;
end if;
end process;
end beh;