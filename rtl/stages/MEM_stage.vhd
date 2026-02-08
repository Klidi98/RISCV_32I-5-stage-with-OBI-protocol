library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mem_stage is
    port (
        clk                : in  std_logic;               -- Clock input
        rst_n              : in  std_logic;               -- Reset input (active low)

    --signal for blocking pipeline


        i_ctr_jalr           : in  std_logic;               --control unit signal    
        i_ctr_jal            : in  std_logic;
        i_ctr_branch         : in  std_logic;
        i_ctr_size_access    : in  std_logic_vector(1 downto 0);
        i_ctr_signed_ld      : in  std_logic;
      
        pc_jump_o          : out std_logic_vector(31 downto 0);
        pc_branch_i        : in  std_logic_vector(31 downto 0);
        i_Alu_result_MEM   : in  std_logic_vector(31 downto 0);
        
        o_sel_next_pc      : out std_logic; 
    --Data memory signals
        dm_rdata_i         : in  std_logic_vector(31 downto 0);
        dm_wdata_i         : in  std_logic_vector(31 downto 0); 
        dm_req_i           : in  std_logic;
        dm_we_i            : in  std_logic;
        dm_ready_i         : in  std_logic;
        dm_valid_i         : in  std_logic;
    
   --     dm_rdata_o         : out  std_logic_vector(31 downto 0);
        dm_wdata_o         : out  std_logic_vector(31 downto 0);
        dm_req_o           : out  std_logic;
        dm_we_o            : out  std_logic;
        dm_byte_enable_o   : out  std_logic_vector(3 downto 0);
        data_to_wb_o       : out  std_logic_vector(31 downto 0);
        dm_addx_o          : out  std_logic_vector(31 downto 0)
        
    );
end mem_stage;

architecture rtl of mem_stage is
   

    type state_type is (IDLE, WAIT_VALID);
    signal current_state, next_state : state_type := IDLE;

    signal ctr_lw : std_logic;          --signal that tells if the instruction is load word
    signal dm_rdata: std_logic_vector(31 downto 0);

   
begin

    ctr_lw <= dm_req_i and not(dm_we_i);

--sign_extesnsor of data coming from memory
    data_extensor: entity work.sign_extensor
        port map(
            d_in        => dm_rdata_i                   ,
            ctr_size    => i_ctr_size_access            ,
            ctr_sign    => i_ctr_signed_ld              ,             
            offset      => i_Alu_result_MEM(1 downto 0) ,
            d_out       => dm_rdata
        );
    
    muxJalrPC: process(i_ctr_jalr, pc_branch_i, i_Alu_result_MEM)
    begin
        if i_ctr_jalr = '1' then
            pc_jump_o <= i_Alu_result_MEM;
        else
            pc_jump_o <= pc_branch_i;
        end if;
    end process;


-- output to data memory
-- jump signal
    o_sel_next_pc <= i_ctr_jalr or (i_alu_result_mem(0) and i_ctr_branch) or i_ctr_jal;
    
    dm_addx_o     <= i_Alu_result_MEM;
    dm_we_o       <= dm_we_i;





--signal generation for Data Memory during store instruction(write operation).
process(i_ctr_size_access, i_Alu_result_MEM, dm_wdata_i)
begin
    case i_ctr_size_access is
        when "10" =>  --word
            dm_byte_enable_o <= "1111";
            dm_wdata_o <= dm_wdata_i;
        when "01" =>  --halfword
            if i_Alu_result_MEM(1) = '0' then
                dm_byte_enable_o <= "0011";
                dm_wdata_o <= dm_wdata_i(15 downto 0) & dm_wdata_i(15 downto 0);
            else
                dm_byte_enable_o <= "1100";
                dm_wdata_o <= dm_wdata_i(15 downto 0) & dm_wdata_i(15 downto 0);
            end if;
        when "00" =>  --byte
            dm_wdata_o <= dm_wdata_i(7 downto 0) & dm_wdata_i(7 downto 0) & dm_wdata_i(7 downto 0) & dm_wdata_i(7 downto 0);
            case i_Alu_result_MEM(1 downto 0) is
                when "00" =>
                    dm_byte_enable_o <= "0001";
                when "01" =>
                    dm_byte_enable_o <= "0010";
                
                when "10" =>
                    dm_byte_enable_o <= "0100";
                when others =>
                    dm_byte_enable_o <= "1000";
            end case;
        when others =>
            dm_byte_enable_o <= "0000";
            dm_wdata_o <= dm_wdata_i;
    end case;
end process;

            

data_to_wb_o <= dm_rdata when ctr_lw = '1' else 
              i_Alu_result_MEM;


--fsm for generating requests to data memory 
--#########################################################################

process(clk, rst_n)
begin
    if rst_n = '0' then 
        current_state <= IDLE;
    elsif rising_edge(clk) then
        current_state <= next_state;
    end if;
end process;


process(current_state, dm_req_i, dm_ready_i, dm_valid_i)
begin
    
    case current_state is
        when IDLE =>
            if (dm_req_i = '1') and (dm_ready_i = '1') then
                next_state <= wait_valid;
            else
                next_state <= IDLE;
            end if;
        when WAIT_VALID =>
            if dm_valid_i = '1' then
                next_state <= IDLE;
            else
                next_state <= WAIT_VALID;
            end if;
        when others =>
            next_state <= IDLE;
    end case;
end process;


process(current_state, dm_req_i)
begin
    dm_req_o <= '0';

    case current_state is
        when IDLE =>
            if dm_req_i = '1' then
                dm_req_o <= '1';
            else
                dm_req_o <= '0';
            end if;
        when WAIT_VALID =>
        
    end case;
end process;


end rtl;
