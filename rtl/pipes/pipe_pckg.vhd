library ieee ;
use ieee.std_logic_1164.all ;

package pipe_pckg is

    constant  WB_CTRL_RST   : ctrl_wb_t := ( rf_write => '0', lui      => '0', jal      => '0', commit   => '0' );
    constant  MEM_CTRL_RST  : mem_ctrl_t :=( commit => '0', _signed => '0', branch => '0', jal => '0', jalr => '0', RF_wren => '0', dm_request => '0');
    constant  EXE_CTRL_RST  : exe_ctrl_t := ( commit => '0', RF_wren => '0', branch => '0', jalr => '0', jal => '0', lui => '0', dm_request => '0', u_uj_i => '0');

    constant CTRL_UNIT_RESET : ctrl_unit_t := (
    RF_write        => '0',
    sel_alu_src1    => '0',
    sel_alu_src2    => '0',
    add_sub         => '0',
    dm_request      => '0',
    dm_wren         => '0',
    alu_op          => (others => '0'), -- Inizializza tutto il vettore a 0
    comp_op         => (others => '0'),
    type_I_S_SB     => (others => '0'),
    is_signed       => '0',
    type_U_UJ       => (others => '0'),
    imm_final_mux   => '0',
    branch          => '0',
    jalr            => '0',
    lui             => '0',
    type_U_UJ_I     => '0',
    jal             => '0',
    signed_ld       => '0'
);

    type ctrl_unit_t is record

    RF_write        : std_logic ;
    sel_alu_src1    : std_logic ;
    sel_alu_src2    : std_logic ;
    dm_request      : std_logic ;
    dm_wren         : std_logic ;
    alu_op          : std_logic_vector(2 downto 0) ;
    comp_op         : std_logic_vector(1 downto 0) ;
    type_I_S_SB     : std_logic_vector(1 downto 0) ;
    is_signed         : std_logic ;
    type_U_UJ       : std_logic_vector(1 downto 0) ;
    imm_final_mux   : std_logic ;
    branch          : std_logic ;
    jalr            : std_logic ;
    lui             : std_logic ;
    type_U_UJ_I     : std_logic ;
    jal             : std_logic ;
    signed_ld       : std_logic ;

end ctrl_unit_t;

type wb_ctrl_t is record
    RF_write        : std_logic;
    lui             : std_logic;
    jal             : std_logic;
    commit          : std_logic;
end record;

type wb_data_t is record
    next_pc         : std_logic_vector(31 downto 0);
    data_mem        : std_logic_vector(31 downto 0);
    immediate       : std_logic_vector(31 downto 0);
    dest_reg        : std_logic_vector(4 downto 0);
    debug_instr     : std_logic_vector(31 downto 0);
end record;


--for pipe exe to mem stage
type mem_ctrl_t is record
    dm_req     : std_logic;
    dm_wren    : std_logic;
    lui        : std_logic;
    branch     : std_logic;
    jal        : std_logic;
    jalr       : std_logic;
    RF_write   : std_logic;
    is_signed  : std_logic;
    sign_ld    : std_logic;
    size_dm    : std_logic_vector(1 downto 0) ;
    commit     : std_logic;
end record;

type mem_data_t is record

    debug_istr : std_logic_vector(31 downto 0) ;
    dr_idx     : std_logic_vector(4 downto 0)  ;
    immediate  : std_logic_vector(31 downto 0) ;
    alu_res    : std_logic_vector(31 downto 0) ;
    RF_reg2    : std_logic_vector(31 downto 0) ;
    dm_addr    : std_logic_vector(31 downto 0) ;
    next_pc    : std_logic_vector(31 downto 0) ;      

end record;



type ex_ctrl_t is record
    BP_predict_taken : std_logic;
    commit           : std_logic;
    dm_request       : std_logic;
    RF_write         : std_logic;
    sel_alu_src1     : std_logic;
    sel_alu_src2     : std_logic;
    branch           : std_logic;
    comp_op          : std_logic_vector(1 downto 0) ;
    dm_wren          : std_logic;
    is_signed          : std_logic;
    jalr             : std_logic;
    jal              : std_logic;
    lui              : std_logic;
    u_uj_i           : std_logic;
    addsub           : std_logic;
    signed_ld        : std_logic;
    alu_op           : std_logic_vector(2 downto 0) ;
end ex_ctrl_t;



--for pipe id to exe stage
type exe_data_t is record 
    debug_istr       : std_logic_vector(31 downto 0) ;
    next_pc          : std_logic_vector(31 downto 0) ;
    current_pc       : std_logic_vector(31 downto 0) ;
    istr_opcode      : std_logic_vector(6 downto 0) ;
    idx_rs1          : std_logic_vector(4 downto 0) ;
    idx_rs2          : std_logic_vector(4 downto 0) ;
    idx_dr           : std_logic_vector(4 downto 0) ;
    data_rs1         : std_logic_vector(31 downto 0) ;
    data_rs2         : std_logic_vector(31 downto 0) ;
    immediate        : std_logic_vector(31 downto 0) ;
end exe_data_t;

