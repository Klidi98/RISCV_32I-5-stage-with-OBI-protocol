library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity EstensoreSegnoTipo2 is
  
  port (
    idato     : in  std_logic_vector(19 downto 0);
    iTYPE_U : in std_logic; -- dice se � necessario fare una estensione di tipo
                            -- signed o unsigned
    q : out std_logic_vector(31 downto 0));

end EstensoreSegnoTipo2;

architecture beh of EstensoreSegnoTipo2 is

begin  -- architecture beh

  
  process (iTYPE_U,idato) is
  begin  -- process
    if iTYPE_U='0' then
      q(11 downto 0)<=(others=>'0');
      q(31 downto 12)<=idato;
      -- if INPUT(19)='1' then
      --   OUTPUT(63 downto 32)<=(others=>'1');-- when INPUT(19)='1' else (others =>'0');
      -- else
      --   OUTPUT(63 downto 32)<=(others=>'0');
      -- end if;
    else
      q(19 downto 0)<=idato; --lo shift che implementa il x2 quando si
                                  --addiziona con il PC tenuto conto fuori da
                                  --immediate generator
      if idato(19)='1' then
        q(31 downto 20)<=(others=>'1');-- when INPUT(19)='1' else (others =>'0');
      else
        q(31 downto 20)<=(others=>'0');
      end if;
    end if;
  end process;
  

end architecture beh;

