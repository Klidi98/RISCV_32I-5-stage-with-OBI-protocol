-- ID_stage.vhdl file
-- Instruction decoder stage
-- comprehends register file and Control Unit 
--klides kaba

library ieee;
use ieee.std_logic_1164.all;


entity id_stage is
    port(
        clk                     : in  std_logic;
        i_instruction           : in  std_logic_vector(31 downto 0);
        i_wdata                 : in  std_logic_vector(31 downto 0);
        i_dreg                  : in  std_logic_vector(4 downto 0);             --arriving from write back stage
    
--control unit signals in
        i_ctr_write_rf          : in  std_logic;

--hazard detection unit signals
        o_opcode                : out std_logic_vector(6 downto 0);
        
        i_stall                 : in std_logic;     -- stall signals that follows NOP instruction
        i_instr_valid           : in std_logic;     -- valid signal from IF_ID pipeline register
--control unit signals output
        o_ctr_U_UJ_I            : out std_logic;
        o_ctr_write_rf          : out std_logic;
        o_ctr_sel_alu_src1      : out std_logic;
        o_ctr_sel_alu_src2      : out std_logic;
        o_ctr_addsub            : out std_logic;
        o_ctr_alu_op            : out std_logic_vector(2 downto 0);
        o_ctr_comp_op           : out std_logic_vector(1 downto 0);
        o_ctr_signed            : out std_logic;
        o_ctr_branch            : out std_logic;
        o_ctr_wren_dm           : out std_logic;
        o_ctr_request_dm        : out std_logic;
        o_ctr_jalr              : out std_logic;
        o_ctr_lui               : out std_logic;
        o_ctr_jal               : out std_logic;
        o_ctr_signed_ld         : out std_logic;

--RF outputs
        o_rf_rs1                : out std_logic_vector  (4 downto 0);
        o_rf_rs2                : out std_logic_vector  (4 downto 0);
        o_rf_dreg               : out std_logic_vector  (4 downto 0);
        o_rf_reg1               : out std_logic_vector  (31 downto 0);
        o_rf_reg2               : out std_logic_vector  (31 downto 0);
        o_immediate             : out std_logic_vector  (31 downto 0)
    );
end entity id_stage;

architecture rtl of id_stage is

    -- segnali interni
    signal w_reg1, w_reg2           : std_logic_vector(31 downto 0);
    signal w_registerwrite          : std_logic;
    signal w_alusrc1, w_alusrc2     : std_logic;
    signal w_ctr_branch            : std_logic;
    signal w_ctr_mem_reg, w_ctr_wren_dm  : std_logic;
    signal w_ctr_request_dm         : std_logic;
    signal w_ctr_jalr_mux           : std_logic;
    signal w_ctr_lui_mux            : std_logic;
    signal w_ctr_jal_muxtorf        : std_logic;
    signal w_ctr_signed             : std_logic;
    signal w_ctr_tipo_i_s_sb        : std_logic_vector(1 downto 0);
    signal w_ctr_tipo_u_uj          : std_logic;
    signal w_ctr_U_UJ_I_mux         : std_logic;
    signal w_ctr_muxfinale          : std_logic;
    signal w_ctr_addsub             : std_logic;
    signal w_ctr_signed_ld          : std_logic;
    signal w_ctr_alu_op             : std_logic_vector(2 downto 0);
    signal w_ctr_comp_op            : std_logic_vector(1 downto 0);
    signal w_addr_r1, w_addr_r2     : std_logic_vector(4 downto 0);

    signal w_valid_instr, w_mux_out : std_logic_vector(16 downto 0);
    signal w_opcode                 : std_logic_vector(6 downto 0);
    signal w_funct3	                : std_logic_vector(2 downto 0);
	signal w_funct7                 : std_logic_vector(6 downto 0);
    signal w_sel_cu                 : std_logic;

begin

    -- estrazione registri from instruction word
    o_rf_rs1 <= i_instruction(19 downto 15);
    o_rf_rs2 <= i_instruction(24 downto 20);

    o_rf_dreg<= i_instruction(11 downto 7);

	
    o_ctr_signed <= w_ctr_signed;
	
    w_sel_cu <= i_stall or not(i_instr_valid);

    w_valid_instr  <= w_ctr_signed_ld & w_ctr_comp_op & w_ctr_alu_op & w_ctr_U_UJ_I_mux & w_registerwrite & w_alusrc1 & w_alusrc2 & w_ctr_addsub & 
                    w_ctr_branch & w_ctr_wren_dm & w_ctr_request_dm & 
                    w_ctr_jalr_mux & w_ctr_lui_mux & w_ctr_jal_muxtorf;

    w_addr_r1   <=  i_instruction(19 downto 15);
    w_addr_r2   <=  i_instruction(24 downto 20);

    w_opcode    <=  i_instruction(6 downto 0);
    w_funct3    <=  i_instruction(14 downto 12);
    w_funct7    <=  i_instruction(31 downto 25);


--if there is a stall codmnition from HDU also the dest. register has to be resetted in order to avoid stalling the pipe for more than 1 cycle.
process(w_sel_cu, w_opcode)
    begin
        if w_sel_cu = '1' then
            o_opcode <= (others => '0');
        else
            o_opcode <= w_opcode;
        end if;
end process;

-- Control Unit
    CU: entity work.ControlUnit
        port map(
            OPCODE          => w_opcode,
            FUNCT3          => w_funct3,
            FUNCT7          => w_funct7,
            RegisterWrite   => w_registerwrite,
            ALUsrc1         => w_alusrc1,
            ALUsrc2         => w_alusrc2,
            ctr_branch      => w_ctr_branch,
            ctr_wren_dm     => w_ctr_wren_dm,
            ctr_request_dm  => w_ctr_request_dm,
            ctr_tipo_I_S_SB => w_ctr_tipo_i_s_sb,
            ctr_Signed      => w_ctr_signed,
            ctr_alu_op      => w_ctr_alu_op,
            ctr_comp_op     => w_ctr_comp_op,
            ctr_addsub      => w_ctr_addsub,
            ctr_tipo_U_UJ   => w_ctr_tipo_u_uj,
            ctr_MuxFinale   => w_ctr_muxfinale,
            ctr_JALRMux     => w_ctr_jalr_mux,
            ctr_LUIMux      => w_ctr_lui_mux,
            ctr_u_UJ_I      => w_ctr_U_UJ_I_mux,
            ctr_JAL_MUXtoRF => w_ctr_jal_muxtorf,
            ctr_signed_load => w_ctr_signed_ld
        );

-- Register File
    RF: entity work.register_file
        port map(
            clk             => clk,
            wr_enable       => i_ctr_write_rf,
            readAddr1       => w_addr_r1,
            readAddr2       => w_addr_r2,
            writeAddr       => i_dreg,
            writeData       => i_wdata,
            readData1       => o_rf_reg1,
            readData2       => o_rf_reg2
        );


    -- Immediate Generator
    IG: entity work.ImmediateExtension32
        port map(
            iINSTRUCTION    => i_instruction,
            iCTRL_I_S_SB    => w_ctr_tipo_i_s_sb,
            iCTRL_U_UJ      => w_ctr_tipo_u_uj,
            iCTRL_MuxFinale => w_ctr_muxfinale,
            iCTRL_Signed    => w_ctr_signed,
            outImm          => o_immediate
        );


    -- Control signals muxed with stall a 17 bit
    MUX_CU: entity work.Mux2to1
    generic map (N => 17)
        port map(
            sel             => w_sel_cu,
            input_0         => w_valid_instr,
            input_1         => (others => '0'),
            q               => w_mux_out
        );      

-- o_opcode                    <= w_opcode;

--CONTROL UNIT OUTPUTS ASSIGNEMENT
o_ctr_signed_ld             <= w_mux_out(16);
o_ctr_comp_op               <= w_mux_out(15 downto 14);
o_ctr_alu_op                <= w_mux_out(13 downto 11);
o_ctr_U_UJ_I                <= w_mux_out(10);
o_ctr_write_rf              <= w_mux_out(9);
o_ctr_sel_alu_src1          <= w_mux_out(8);
o_ctr_sel_alu_src2          <= w_mux_out(7);
o_ctr_addsub                <= w_mux_out(6);
o_ctr_branch                <= w_mux_out(5);
o_ctr_wren_dm               <= w_mux_out(4);
o_ctr_request_dm            <= w_mux_out(3);
o_ctr_jalr                  <= w_mux_out(2);
o_ctr_lui                   <= w_mux_out(1);
o_ctr_jal                   <= w_mux_out(0);


end architecture rtl;
