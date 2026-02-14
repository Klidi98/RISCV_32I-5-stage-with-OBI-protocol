library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pipe_MEM_WB is
    port (
        clk                   : in std_logic;
        reset_n               : in std_logic;  -- reset attivo basso
        enable                : in std_logic;

        -- ingressi
        i_debug_instr         : in  std_logic_vector(31 downto 0); 
        i_ctr_rf_write_mem    : in  std_logic;
        i_ctr_lui_mem         : in  std_logic;
        i_ctr_jal_mem         : in  std_logic;
        i_pc_increment_mem    : in  std_logic_vector(31 downto 0);
--      i_alu_result_mem      : in  std_logic_vector(31 downto 0);

        i_data_dm_mem         : in  std_logic_vector(31 downto 0);
        i_immediate_mem       : in  std_logic_vector(31 downto 0);
        i_dr_mem              : in  std_logic_vector(4 downto 0) ;

        -- uscite
        o_debug_instr         : out  std_logic_vector(31 downto 0); 
        o_ctr_mem_reg_wb      : out std_logic;
        o_ctr_rf_write_wb     : out std_logic;
        o_ctr_lui_wb          : out std_logic;
        o_ctr_jal_wb          : out std_logic;
        o_pc_increment_wb     : out std_logic_vector(31 downto 0);
   --     o_alu_result_wb       : out std_logic_vector(31 downto 0);
        o_data_dm_wb          : out std_logic_vector(31 downto 0);
        o_immediate_wb        : out std_logic_vector(31 downto 0);
        o_dr_mem              : out std_logic_vector(4 downto 0)
    );
end entity;

architecture rtl of Pipe_MEM_WB is

-- Registri interni
    signal r_RegisterWrite   : std_logic;
    signal r_CTR_LUI_mux     : std_logic;
    signal r_CTR_JAL_muxtoRF : std_logic;
    signal r_PCincrement, r_debug_instr     : std_logic_vector(31 downto 0);
    signal r_ALUresult       : std_logic_vector(31 downto 0);
    signal r_DoutDM          : std_logic_vector(31 downto 0);
    signal r_Immediate       : std_logic_vector(31 downto 0);
    signal r_dr              : std_logic_vector(4 downto 0) ;

begin

    process (clk, reset_n)
    begin
        if reset_n = '0' then
            r_RegisterWrite   <= '0';

            r_debug_instr      <= (others => '0');      
        elsif rising_edge(clk) then
            if enable = '1' then
                r_RegisterWrite   <= i_ctr_rf_write_mem ;
                r_CTR_LUI_mux     <= i_ctr_lui_mem 	    ;    
                r_CTR_JAL_muxtoRF <= i_ctr_jal_mem   	;   
                r_PCincrement     <= i_pc_increment_mem ;
                r_DoutDM          <= i_data_dm_mem      ;
                r_Immediate       <= i_immediate_mem    ;
                r_dr              <= i_dr_mem           ;
                r_debug_instr     <= i_debug_instr      ;    --needed for debug only

            end if;
        end if;
    end process;

    --Outputs
    o_ctr_rf_write_wb    <= r_RegisterWrite             ;
    o_ctr_lui_wb         <= r_CTR_LUI_mux               ;
    o_ctr_jal_wb         <= r_CTR_JAL_muxtoRF           ;
    o_pc_increment_wb    <= r_PCincrement               ;
    o_data_dm_wb         <= r_DoutDM                    ;
    o_immediate_wb       <= r_Immediate                 ;
    o_dr_mem             <= r_dr                        ;
    o_debug_instr        <= r_debug_instr               ;

end architecture;
