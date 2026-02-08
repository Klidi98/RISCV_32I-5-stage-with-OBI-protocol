library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ImmediateExtension32 is
    port (
        iINSTRUCTION     : in  std_logic_vector(31 downto 0);
        iCTRL_I_S_SB     : in  std_logic_vector(1 downto 0);
        iCTRL_U_UJ       : in  std_logic;
        iCTRL_MuxFinale  : in  std_logic;
        iCTRL_Signed     : in  std_logic;
        
        outImm           : out std_logic_vector(31 downto 0) -- Il nome suggerisce 64bit ma l'output nel codice era 32
    );
end ImmediateExtension32;

architecture Structural of ImmediateExtension32 is

    -- Dichiarazione dei segnali interni (corrispondenti ai wire)
    signal w_ImmI         : std_logic_vector(11 downto 0);
    signal w_ImmS         : std_logic_vector(11 downto 0);
    signal w_ImmSB        : std_logic_vector(11 downto 0);
    signal w_ImmU         : std_logic_vector(19 downto 0);
    signal w_ImmUJ        : std_logic_vector(19 downto 0);
    signal w_outMux01     : std_logic_vector(11 downto 0);
    signal w_outMux02     : std_logic_vector(19 downto 0);
    signal w_outExtSign1  : std_logic_vector(31 downto 0);
    signal w_outExtSign2  : std_logic_vector(31 downto 0);

    -- Dichiarazione dei Componenti

    component mux4to1
        generic ( N : integer );
        port (
            sel     : in  std_logic_vector(1 downto 0);
            input_0 : in  std_logic_vector(N-1 downto 0);
            input_1 : in  std_logic_vector(N-1 downto 0);
            input_2 : in  std_logic_vector(N-1 downto 0);
            input_3 : in  std_logic_vector(N-1 downto 0);
            q       : out std_logic_vector(N-1 downto 0)
        );
    end component;

    component mux2to1
        generic ( N : integer );
        port (
            sel     : in  std_logic;
            input_0 : in  std_logic_vector(N-1 downto 0);
            input_1 : in  std_logic_vector(N-1 downto 0);
            q       : out std_logic_vector(N-1 downto 0)
        );
    end component;

    component EstensoreSegnoTipo1
        port (
            idato   : in  std_logic_vector(11 downto 0);
            iSIGNED : in  std_logic;
            q       : out std_logic_vector(31 downto 0)
        );
    end component;

    component EstensoreSegnoTipo2
        port (
            idato   : in  std_logic_vector(19 downto 0);
            iTYPE_U : in  std_logic;
            q       : out std_logic_vector(31 downto 0)
        );
    end component;

begin


    -- Istanza Mux 4 a 1 (Tipo I, S, SB)
    MX1: mux4to1
        generic map ( N => 12 )
        port map (
            sel     => iCTRL_I_S_SB,
            input_0 => w_ImmI,
            input_1 => w_ImmS,
            input_2 => w_ImmSB,
            input_3 => w_ImmSB,
            q       => w_outMux01
        );

    -- Istanza Mux 2 a 1 (Tipo U, UJ)
    MX2: mux2to1
        generic map ( N => 20 )
        port map (
            sel     => iCTRL_U_UJ,
            input_0 => w_ImmU,
            input_1 => w_ImmUJ,
            q       => w_outMux02
        );

    -- Istanza Estensore Segno Tipo 1
    ES1: EstensoreSegnoTipo1
        port map (
            idato   => w_outMux01,
            iSIGNED => iCTRL_Signed,
            q       => w_outExtSign1
        );

    -- Istanza Estensore Segno Tipo 2
    ES2: EstensoreSegnoTipo2
        port map (
            idato   => w_outMux02,
            iTYPE_U => iCTRL_U_UJ,
            q       => w_outExtSign2
        );

    -- Istanza Mux Finale
    MX3: mux2to1
        generic map ( N => 32 )
        port map (
            sel     => iCTRL_MuxFinale,
            input_0 => w_outExtSign1,
            input_1 => w_outExtSign2,
            q       => outImm
        );

  w_ImmI(11 downto 0)   <=iINSTRUCTION(31 downto 20); 
  
  w_ImmS(4 downto 0)    <=iINSTRUCTION(11 downto 7); 
  w_ImmS(11 downto 5)   <=iINSTRUCTION(31 downto 25);

 
  w_ImmSB(3 downto 0)   <=iINSTRUCTION(11 downto 8); 
  w_ImmSB(9 downto 4)   <=iINSTRUCTION(30 downto 25);
  w_ImmSB(10)           <=iINSTRUCTION(7);
  w_ImmSB(11)           <=iINSTRUCTION(31);

  w_ImmU(19 downto 0)   <=iINSTRUCTION(31 downto 12);

  w_ImmUJ(9 downto 0)   <=iINSTRUCTION(30 downto 21);
  w_ImmUJ(10)           <=iINSTRUCTION(20);
  w_ImmUJ(18 downto 11) <=iINSTRUCTION(19 downto 12);
  w_ImmUJ(19)           <=iINSTRUCTION(31);

end Structural;