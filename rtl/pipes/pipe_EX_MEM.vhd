library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pipe_EX_MEM is
    port (
        clk     : in  std_logic;
        rstn    : in  std_logic;  -- reset attivo basso
        enable  : in  std_logic;
        flusher : in  std_logic;

        -- ingressi
        i_debug_instr   : in  std_logic_vector(31 downto 0);
        dReg_in         : in  std_logic_vector(4 downto 0);
        i_Immediate     : in  std_logic_vector(31 downto 0);
        ALUres_in       : in  std_logic_vector(31 downto 0);
        i_rf_reg2       : in  std_logic_vector(31 downto 0);
        JALres_in       : in  std_logic_vector(31 downto 0);
        i_request_dm    : in  std_logic;
        i_addr_dm       : in  std_logic_vector(31 downto 0);
        i_wren_dm       : in  std_logic;
        i_CTR_LUI       : in  std_logic;
        CTR_branch_in   : in  std_logic;
        i_CTR_jal_muxRF : in  std_logic;
        i_CTR_JALR      : in  std_logic;
        i_CTR_RFwrite   : in  std_logic;
        i_ctr_signed    : in  std_logic;
        i_ctr_signed_ld  : in  std_logic;
        i_ctr_size_dm   : in  std_logic_vector(1 downto 0);
        i_pc_current    : in  std_logic_vector(31 downto 0);

        -- uscite
        o_debug_instr   : out  std_logic_vector(31 downto 0);
        o_request_dm    : out std_logic;
        o_wren_dm       : out std_logic;
        o_Immediate     : out std_logic_vector(31 downto 0);
        dreg_out        : out std_logic_vector( 4 downto 0);
        o_addr_dm       : out std_logic_vector(31 downto 0);        -- idem, in SV non era usato
        ALUres_out      : out std_logic_vector(31 downto 0);
        JALres_out      : out std_logic_vector(31 downto 0);
        o_rf_reg2       : out std_logic_vector(31 downto 0);
        o_pc_current    : out std_logic_vector(31 downto 0);
        o_ctr_signed_ld : out std_logic;
        CTR_branch_out  : out std_logic;
        o_CTR_jal_muxRF : out std_logic;
        o_CTR_JALR      : out std_logic;
        o_CTR_LUI       : out std_logic;
        o_CTR_RFwrite   : out std_logic;
        o_ctr_signed    : out std_logic;
        o_ctr_size_dm   : out std_logic_vector(1 downto 0)
    );
end entity;

architecture rtl of pipe_EX_MEM is


    signal r_signed_ld    : std_logic;
    signal r_destination  : std_logic_vector(4 downto 0);
    signal r_Immediate,r_debug_instr      : std_logic_vector(31 downto 0);
    signal r_ALUres       : std_logic_vector(31 downto 0);
    signal r_JALres       : std_logic_vector(31 downto 0);
    signal r_PC_plus_4    : std_logic_vector(31 downto 0);
    signal r_addr_dm      : std_logic_vector(31 downto 0);
    signal r_rf_reg2      : std_logic_vector(31 downto 0);
    signal r_CTR_LUI      : std_logic;
    signal r_CTR_branch   : std_logic;
    signal r_CTR_jal_muxRF: std_logic;
    signal r_CTR_JALR     : std_logic;
    signal r_CTR_RFwrite  : std_logic;
    signal r_wren_dm      : std_logic;
    signal r_request_dm   : std_logic;
    signal r_ctr_signed   : std_logic;
    signal r_ctr_size_dm  : std_logic_vector(1 downto 0);

begin

    process (CLK, rstn)
    begin
        if RSTN = '0' then
            r_ctr_signed   <= '0';
            r_CTR_branch   <= '0';
            r_CTR_jal_muxRF<= '0';
            r_CTR_JALR     <= '0';
            r_CTR_RFwrite  <= '0';
            r_request_dm   <= '0';
        elsif rising_edge(CLK) then
            if flusher = '1' then
             
                r_CTR_branch   <= '0';
                r_CTR_jal_muxRF<= '0';
                r_CTR_JALR     <= '0';
                r_CTR_RFwrite  <= '0';
                r_wren_dm      <= '0';
                r_request_dm   <= '0';
                r_destination  <= (others => '0');

            elsif enable = '1' then
                r_signed_ld    <= i_ctr_signed_ld;
                r_destination  <= dReg_in;
                r_Immediate    <= i_Immediate;
                r_ALUres       <= ALUres_in;
                r_CTR_LUI      <= i_CTR_LUI;
                r_CTR_branch   <= CTR_branch_in;
                r_CTR_jal_muxRF<= i_CTR_jal_muxRF;
                r_CTR_JALR     <= i_CTR_JALR;
                r_CTR_RFwrite  <= i_CTR_RFwrite;
                r_wren_dm      <= i_wren_dm;
                r_rf_reg2      <= i_rf_reg2;
                r_JALres       <= JALres_in;
                r_request_dm   <= i_request_dm;
                r_debug_instr  <= i_debug_instr;
                r_ctr_signed   <= i_ctr_signed;
                r_ctr_size_dm  <= i_ctr_size_dm;
                r_PC_plus_4    <= i_pc_current;
				r_addr_dm      <= i_addr_dm;
            end if;
        end if;
    end process;


    o_ctr_signed     <= r_ctr_signed;
    o_ctr_size_dm    <= r_ctr_size_dm;
    dReg_out         <= r_destination;
    o_Immediate      <= r_Immediate;
    ALUres_out       <= r_ALUres;
    o_CTR_LUI        <= r_CTR_LUI;
    CTR_branch_out   <= r_CTR_branch;
    o_CTR_jal_muxRF  <= r_CTR_jal_muxRF;
    o_CTR_JALR       <= r_CTR_JALR;
    o_CTR_RFwrite    <= r_CTR_RFwrite;
    o_addr_dm        <= r_addr_dm;
    o_wren_dm        <= r_wren_dm;
    o_rf_reg2        <= r_rf_reg2;
    JALres_out       <= r_JALres;
    o_request_dm     <= r_request_dm;
    o_debug_instr    <= r_debug_instr;
    o_pc_current     <= r_PC_plus_4;  
    o_ctr_signed_ld  <= r_signed_ld;
end architecture;

