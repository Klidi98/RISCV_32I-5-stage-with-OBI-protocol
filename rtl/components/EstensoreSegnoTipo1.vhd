library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity EstensoreSegnoTipo1 is
  
  port (
    idato    : in  std_logic_vector(11 downto 0);
    iSIGNED   : in std_logic; -- dice se � necessario fare una estensione di tipo
                              -- signed o unsigned
    q         : out std_logic_vector(31 downto 0));

end EstensoreSegnoTipo1;

architecture beh of EstensoreSegnoTipo1 is

begin  -- architecture beh

  q(11 downto 0)<=idato;
  process (iSIGNED,idato) is
  begin  -- process
    if iSIGNED='1'and idato(11)='1' then
      q(31 downto 12)<=(others=>'1');-- when(INPUT(11)='1') else (others =>'0');
    else
      q(31 downto 12)<=(others=>'0');
    end if;
  end process;
  

end architecture beh;
