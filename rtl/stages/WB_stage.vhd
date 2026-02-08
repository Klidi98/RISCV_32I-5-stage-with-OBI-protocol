library ieee;
use ieee.std_logic_1164.all;

entity WriteBack is
    port (
        
  --      i_dato_dm          : in  std_logic_vector(31 downto 0);
 --       i_alu_result       : in  std_logic_vector(31 downto 0);
        i_dato_mem         : in  std_logic_vector(31 downto 0);
        i_ctr_lui          : in  std_logic;
        i_ctr_jal          : in  std_logic;
        i_pc_increment     : in  std_logic_vector(31 downto 0);
        i_immediate        : in  std_logic_vector(31 downto 0);
        o_wdata_rf         : out std_logic_vector(31 downto 0)
    );
end entity;

architecture beh of WriteBack is

    signal w_wb_muxer   : std_logic_vector(31 downto 0);
    signal w_sel_output : std_logic_vector(1 downto 0);
begin



    w_sel_output <= i_ctr_JAL & i_ctr_LUI;  --concatenazione di due segnali control unit
    

    output_muxer: entity work.mux4to1
        port map (
            sel       => w_sel_output,
            input_0   => i_dato_mem,
            input_1   => i_immediate,
            input_2   => i_pc_increment,
            input_3   => i_dato_mem,
            q         => o_wdata_rf
        );

end beh;








