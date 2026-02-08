library ieee;
use ieee.std_logic_1164.all;


entity pipe_ID_EX is
    port (
        clk                 : in  std_logic;
        rstn                : in  std_logic;
        enable              : in  std_logic;
        flusher             : in  std_logic;
 -- Ingressi*******************************************************
        i_debug_instr       : in  std_logic_vector(31 downto 0);
        i_current_pc        : in  std_logic_vector(31 downto 0);
        i_past_pc           : in  std_logic_vector(31 downto 0);
        i_opcode            : in std_logic_vector( 6 downto 0);
        i_ctr_req_dm        : in std_logic;
        i_rf_write          : in std_logic;
        i_alu_src1          : in std_logic;
        i_alu_src2          : in std_logic;
        i_CTR_branch        : in std_logic;
        i_ctr_comp_op       : in std_logic_vector(1 downto 0);
        i_MemWrite          : in std_logic;
        i_ctr_signed        : in std_logic;
        i_ctr_jalr          : in std_logic;
        i_ctr_LUI           : in std_logic;
        i_ctr_JAL           : in std_logic;
        i_ctr_U_UJ_I        : in std_logic;
        i_ctr_addsub        : in std_logic;
        i_ctr_signed_ld     : in std_logic;
        Rs1Addx_in          : in std_logic_vector(4 downto 0);
        Rs2Addx_in          : in std_logic_vector(4 downto 0);
        DrAddx_in           : in std_logic_vector(4 downto 0);
        i_Reg1              : in std_logic_vector(31 downto 0);
        i_Reg2              : in std_logic_vector(31 downto 0);
        i_Immediate         : in std_logic_vector(31 downto 0);
        i_ctr_alu_op        : in std_logic_vector(2 downto 0);
-- Uscite**********************************************************
        o_debug_instr       : out  std_logic_vector(31 downto 0);
	    o_opcode            : out std_logic_vector( 6 downto 0);
        o_current_pc        : out std_logic_vector(31 downto 0);
        o_past_pc           : out std_logic_vector(31 downto 0);
        o_alu_src1          : out std_logic;
        o_alu_src2          : out std_logic;
        o_ctr_addsub        : out std_logic;
        o_rf_write          : out std_logic;
        o_ctr_branch        : out std_logic;
        o_MemWrite          : out std_logic;
        o_ctr_comp_op       : out std_logic_vector(1 downto 0);
        o_ctr_signed        : out std_logic;
        o_ctr_jalr          : out std_logic;
        o_ctr_LUI           : out std_logic;
        o_ctr_JAL           : out std_logic;
        o_ctr_req_dm        : out std_logic;
        o_ctr_U_UJ_I        : out std_logic;
        o_ctr_signed_ld     : out std_logic;
        Rs1Addx_out         : out std_logic_vector(4 downto 0);
        Rs2Addx_out         : out std_logic_vector(4 downto 0);
        DrAddx_out          : out std_logic_vector(4 downto 0);
        o_Reg1              : out std_logic_vector(31 downto 0);
        o_Reg2              : out std_logic_vector(31 downto 0);
        o_Immediate         : out std_logic_vector(31 downto 0);
        o_ctr_alu_op        : out std_logic_vector(2 downto 0)

    );
end entity;

architecture rtl of pipe_ID_EX is
    -- Registri interni
    signal r_CURRENT_PC  : std_logic_vector(31 downto 0);
    signal r_PAST_PC     : std_logic_vector(31 downto 0);
    signal r_debug_instr : std_logic_vector(31 downto 0);
    signal r_OPCODE      : std_logic_vector(6 downto 0);

    signal r_RegisterWrite                                      : std_logic;
    signal r_signed_ld                                          : std_logic;
    signal r_ALUsrc1, r_ALUsrc2, r_addsub                       : std_logic;
    signal r_alu_op                                             : std_logic_vector(2 downto 0);
    signal r_CTR_branch, r_MemWrite, r_CTR_signed               : std_logic;
    signal r_CTR_jalr, r_CTR_LUI,r_ctr_req_dm                   : std_logic;
    signal r_CTR_JAL, r_forward_enable ,r_ctr_U_UJ_I            : std_logic;
    signal r_ctr_comp_op                                        : std_logic_vector(1 downto 0);
    signal r_Rs1Addx, r_Rs2Addx, r_DrAddx                       : std_logic_vector(4 downto 0);
    signal r_Reg1, r_Reg2, r_Immediate                          : std_logic_vector(31 downto 0);
begin
    process(CLK, RSTn)
    begin
        if RSTn = '0' then
            -- Reset asincrono
            
            r_OPCODE          <= (others => '0');
            r_RegisterWrite   <= '0';
            r_CTR_branch      <= '0';
            r_CTR_jalr        <= '0';
            r_CTR_LUI         <= '0';
            r_CTR_JAL         <= '0';
            r_ctr_req_dm      <= '0';
            r_ctr_U_UJ_I      <= '0';

        elsif rising_edge(CLK) then
            if flusher = '1' then
                r_RegisterWrite   <= '0';
                r_CTR_branch      <= '0';
                r_MemWrite        <= '0';
                r_CTR_jalr        <= '0';
                r_CTR_JAL 	      <= '0';
		        r_ctr_req_dm      <= '0';
                r_CTR_branch      <= '0';
            elsif ENABLE = '1' then
                r_signed_ld       <= i_ctr_signed_ld;
                r_ctr_comp_op     <= i_ctr_comp_op;
                r_alu_op          <= i_ctr_alu_op;
                r_addsub          <= i_ctr_addsub;
                r_CURRENT_PC      <= i_CURRENT_PC;
                r_PAST_PC         <= i_PAST_PC;
                r_OPCODE          <= i_opcode;
                r_RegisterWrite   <= i_rf_write;
                r_ALUsrc1         <= i_alu_src1;
                r_ALUsrc2         <= i_alu_src2;
                r_CTR_branch      <= i_CTR_branch;
                r_MemWrite        <= i_MemWrite;
                r_CTR_signed      <= i_CTR_signed;
                r_CTR_jalr        <= i_CTR_jalr;
                r_CTR_LUI         <= i_CTR_LUI;
                r_CTR_JAL 	      <= i_CTR_JAL;
                r_ctr_U_UJ_I      <= i_ctr_U_UJ_I;
		        r_ctr_req_dm      <= i_ctr_req_dm;
                r_Rs1Addx         <= Rs1Addx_in;
                r_Rs2Addx         <= Rs2Addx_in;
                r_DrAddx          <= DrAddx_in;
                r_Reg1            <= i_Reg1;
                r_Reg2            <= i_Reg2;
                r_Immediate       <= i_Immediate;
                r_debug_instr     <= i_debug_instr;
            end if;
        end if;
    end process;

-- Uscite
    o_CURRENT_PC            <= r_CURRENT_PC;
    o_PAST_PC               <= r_PAST_PC;
    o_opcode                <= r_OPCODE;
    o_rf_write              <= r_RegisterWrite;
    o_alu_src1              <= r_ALUsrc1;
    o_alu_src2              <= r_ALUsrc2;
    o_ctr_branch            <= r_CTR_branch;
    o_MemWrite              <= r_MemWrite;
    o_ctr_signed            <= r_CTR_signed;
    o_ctr_jalr              <= r_CTR_jalr;
    o_ctr_LUI               <= r_CTR_LUI;
    o_ctr_JAL		        <= r_CTR_JAL;
    o_ctr_U_UJ_I            <= r_ctr_U_UJ_I;
    o_ctr_signed_ld         <= r_signed_ld;
    Rs1Addx_out             <= r_Rs1Addx;
    Rs2Addx_out             <= r_Rs2Addx;
    DrAddx_out              <= r_DrAddx;
    o_Reg1                  <= r_Reg1;
    o_Reg2                  <= r_Reg2;
    o_Immediate             <= r_Immediate;
    o_ctr_req_dm            <= r_ctr_req_dm;
    o_debug_instr           <= r_debug_instr;
    o_ctr_addsub            <= r_addsub;
    o_ctr_alu_op            <= r_alu_op;
    o_ctr_comp_op           <= r_ctr_comp_op;
end architecture;
