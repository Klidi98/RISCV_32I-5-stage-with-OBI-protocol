library ieee;
use ieee.std_logic_1164.all;

entity mux2to1 is
  generic (
    N : integer := 1  -- larghezza del bus
  );
  port (
    sel   : in  std_logic;                          -- selettore
    input_0: in  std_logic_vector(N-1 downto 0);     -- ingresso 0
    input_1: in  std_logic_vector(N-1 downto 0);     -- ingresso 1
    q     : out std_logic_vector(N-1 downto 0)      -- uscita
  );
end entity mux2to1;

architecture rtl of mux2to1 is
begin
  q <= input_0 when sel = '0' else
       input_1;
end architecture rtl;

