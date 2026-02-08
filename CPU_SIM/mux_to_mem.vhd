library ieee;
use ieee.std_logic_1164.all;

entity mux_to_mem is
    port(
        sel             : in  std_logic;

        req_from_cpu    : in  std_logic;
        req_from_ext    : in  std_logic;

        we_from_cpu     : in  std_logic;
        we_from_ext     : in  std_logic;

        addr_from_cpu   : in  std_logic_vector(31 downto 0);
        addr_from_ext   : in  std_logic_vector(31 downto 0);

        din_from_cpu    : in  std_logic_vector(31 downto 0);
        din_from_ext    : in  std_logic_vector(31 downto 0);

        be_from_cpu     : in  std_logic_vector(3 downto 0);

        req             : out std_logic;
        we              : out std_logic;
        be              : out std_logic_vector(3 downto 0);
        addr            : out std_logic_vector(31 downto 0);
        din             : out std_logic_vector(31 downto 0)
    );
end entity mux_to_mem;

architecture beh of mux_to_mem is
begin
    -- Multiplexing tra core ed esterno
    req  <= req_from_ext  when sel = '1' else req_from_cpu;
    we   <= we_from_ext   when sel = '1' else we_from_cpu;
    addr <= addr_from_ext when sel = '1' else addr_from_cpu;
    din  <= din_from_ext  when sel = '1' else din_from_cpu;
    be   <= "1111" when sel = '1' else be_from_cpu;  -- Abilita tutti i byte per operazioni di word (4 byte)
end architecture beh;
