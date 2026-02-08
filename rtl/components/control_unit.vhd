library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ControlUnit is
  port (
    OPCODE          : in  std_logic_vector(6 downto 0);  
    FUNCT3          : in  std_logic_vector(2 downto 0);  
    FUNCT7          : in  std_logic_vector(6 downto 0);  

    -- segnali di controllo principali
    OpReadWrite     : out std_logic;
    RegisterWrite   : out std_logic;      --write enable
    ALUsrc1         : out std_logic;      --sceglie il primo ingresso della ALU
    ALUsrc2         : out std_logic;      --sceglie il secondo ingresso ALU
    ctr_addsub      : out std_logic;      --sceglie l'operazione della ALU(somma/sottrazione).
  
    ctr_request_dm  : out std_logic;      
    ctr_wren_dm     : out std_logic;
    ctr_alu_op      : out std_logic_vector(2 downto 0);
    ctr_comp_op     : out std_logic_vector(1 downto 0);

  
    -- segnali specifici
    ctr_tipo_I_S_SB : out std_logic_vector(1 downto 0);
    ctr_Signed      : out std_logic;
    ctr_tipo_U_UJ   : out std_logic;
    ctr_MuxFinale   : out std_logic;
    ctr_branch      : out std_logic;    --segnale che indica se bisogna saltare a nuovo indirizzo o andare in sequenza.
    ctr_JALRMux     : out std_logic;   
    ctr_LUIMux      : out std_logic; 
    ctr_U_UJ_I      : out std_logic;
    ctr_jal_MUXtoRF : out std_logic;
    ctr_signed_load : out std_logic
  );
end entity ControlUnit;


architecture beh of ControlUnit is

signal instr_U_UJ_I : std_logic;

constant  TYPE_I    : std_logic_vector(6 downto 0) := "0000011"; -- LW
constant  TYPE_S    : std_logic_vector(6 downto 0) := "0100011"; -- SW
constant  TYPE_SB   : std_logic_vector(6 downto 0) := "1100011"; -- BGE/BLTU
constant  TYPE_R    : std_logic_vector(6 downto 0) := "0110011"; -- ADD/SUB
constant  TYPE_UJ   : std_logic_vector(6 downto 0) := "1101111"; -- JAL

--type R_type instruction
constant ADD_FT3    : std_logic_vector(2 downto 0) := "000";
constant SLL_FT3    : std_logic_vector(2 downto 0) := "001";
constant SLT_FT3    : std_logic_vector(2 downto 0) := "010";
constant SLTU_FT3   : std_logic_vector(2 downto 0) := "011";
constant XOR_FT3    : std_logic_vector(2 downto 0) := "100";
constant SRL_FT3    : std_logic_vector(2 downto 0) := "101";
constant OR_FT3     : std_logic_vector(2 downto 0) := "110";
constant AND_FT3    : std_logic_vector(2 downto 0) := "111";

--type I_type instruction
constant ADDI_FT3  : std_logic_vector(2 downto 0) := "000";
constant SLLI_FT3  : std_logic_vector(2 downto 0) := "001";
constant SLTI_FT3  : std_logic_vector(2 downto 0) := "010";
constant SLTIU_FT3 : std_logic_vector(2 downto 0) := "011";   --set less than immediate unsigned
constant XORI_FT3  : std_logic_vector(2 downto 0) := "100";   --
constant SRLI_FT3  : std_logic_vector(2 downto 0) := "101";
constant ORI_FT3   : std_logic_vector(2 downto 0) := "110";
constant ANDI_FT3  : std_logic_vector(2 downto 0) := "111";

--load type instructions
constant LB_FT3   : std_logic_vector(2 downto 0) := "000";   -- load byte
constant LH_FT3   : std_logic_vector(2 downto 0) := "001";   -- load halfword
constant LW_FT3   : std_logic_vector(2 downto 0) := "010";   -- load word
constant LBU_FT3  : std_logic_vector(2 downto 0) := "100";   -- load byte unsigned
constant LHU_FT3  : std_logic_vector(2 downto 0) := "101";   -- load halfword unsigned

--store type instructions
constant SB_FT3   : std_logic_vector(2 downto 0) := "000";   -- store byte
constant SH_FT3   : std_logic_vector(2 downto 0) := "001";   -- store halfword
constant SW_FT3   : std_logic_vector(2 downto 0) := "010";   -- store word

begin
  process(OPCODE, FUNCT3, FUNCT7)
  begin
    -- default: tutti i segnali a 0
    OpReadWrite     <= '0';
    RegisterWrite   <= '0';
    ALUsrc1         <= '0';
    ALUsrc2         <= '0';
    ctr_alu_op	    <= (others => '0');
    ctr_addsub      <= '0';
    ctr_request_dm  <= '0';
    ctr_wren_dm     <= '0';
    CTR_tipo_I_S_SB <= "00";
    CTR_Signed      <= '0';
    CTR_tipo_U_UJ   <= '0';
    CTR_MuxFinale   <= '0';
    CTR_branch      <= '0';
    CTR_JALRMux     <= '0';
    CTR_LUIMux      <= '0';
    CTR_JAL_MUXtoRF <= '0';
    ctr_U_UJ_I      <= '0';
    ctr_comp_op     <= (others => '0');
    ctr_signed_load <= '0';

    case OPCODE is

-- [LW] load instructions       
      when "0000011" =>
        RegisterWrite   <= '1';
        ALUsrc2         <= '1';
        ctr_request_dm  <= '1';
        OpReadWrite     <= '1';
        ctr_signed      <= '1';
        CTR_tipo_I_S_SB <= "00";       
        ctr_U_UJ_I      <= '1';
        if FUNCT3 = LB_FT3 then        -- load byte
          ctr_comp_op <= "00";    
          ctr_signed_load <= '1';
        elsif FUNCT3 = LH_FT3 then     -- load halfword
          ctr_comp_op <= "01";
          ctr_signed_load <= '1';
        elsif FUNCT3 = LW_FT3 then     -- load word
          ctr_comp_op <= "10"; 

        elsif FUNCT3 = LBU_FT3 then    -- load byte unsigned
          ctr_comp_op <= "00";
        
        elsif FUNCT3 = LHU_FT3 then    -- load halfword unsigned
          ctr_comp_op <= "01";  

        end if;
                  
-- [ADDI] Add immediate - instruction
--TYPE I instructions
      when "0010011" =>
        RegisterWrite   <= '1';
        ALUsrc2         <= '1';
        --CTR_Signed      <= '1';
        CTR_tipo_I_S_SB <= "00";
        ctr_U_UJ_I      <= '1';
        case FUNCT3 is
          when ADDI_FT3 =>
            ctr_alu_op <= "000"; -- ADDI
            ctr_signed <= '1';
          when SLTI_FT3 =>
            ctr_signed <= '1';
            ctr_alu_op <= "010"; -- SLTI
            ctr_comp_op <= "10";
            
          when SLTIU_FT3 =>
            ctr_addsub <= '1';
            ctr_signed <= '1';
            ctr_alu_op <= "010"; -- SLTIU
            ctr_comp_op <= "10";
          when ANDI_FT3 =>
            ctr_alu_op <= "111"; -- ANDI
            ctr_signed <= '1';
          when ORI_FT3 =>
            ctr_alu_op <= "110"; -- ORI
            ctr_signed <= '1';
          when XORI_FT3 =>
            ctr_alu_op <= "100"; -- XORI
            ctr_signed <= '1';
          when SLLI_FT3 =>
            ctr_alu_op <= "001"; -- SLLI
--            ctr_signed <= '1';
          when SRLI_FT3 =>        -- SRLI/SRAI
            ctr_alu_op <= "101"; 
            if FUNCT7(5) = '1' then   --SRAI
              ctr_comp_op(0) <= '1';              --forse da rimettere
            else                      --SRLLI
              ctr_comp_op(0) <= '0'; 
            end if;
          when others =>
            null;
        end case;
    
        
--R-type instructions
      when TYPE_R =>
        RegisterWrite   <= '1';
        
        case FUNCT3 is
          when AND_FT3 =>
            ctr_alu_op <= "111"; -- AND
          when OR_FT3 =>
            ctr_alu_op <= "110"; -- OR
          when XOR_FT3 =>
            ctr_alu_op <= "100"; -- XOR
          when SLL_FT3 =>
            ctr_alu_op <= "001"; -- SLL
          when SRL_FT3 =>
            ctr_alu_op <= "101"; -- SRL/SRA
            if FUNCT7(5) = '1' then
              ctr_comp_op(0) <= '1';
            else
              ctr_comp_op(0) <= '0';
            end if;
          when SLT_FT3 =>
            ctr_signed <= '1';
            ctr_alu_op <= "010"; -- SLT
            ctr_comp_op <= "10";
          when SLTU_FT3 =>
            ctr_alu_op <= "010"; -- SLTU
            ctr_comp_op <= "10";
          when ADD_FT3 =>
	          ctr_alu_op <= "000";
            if FUNCT7(5) = '1' then
              ctr_addsub <= '1'; -- SUB
            else
              ctr_addsub <= '0'; -- ADD
            end if;
         
          when others =>
            null;
        end case;
-- [AUIPC] Add upper immediate program counter - instruction
      when "0010111" =>
        RegisterWrite   <= '1';
        ALUsrc1         <= '1';
        ALUsrc2         <= '1';
        CTR_Signed      <= '1';
        CTR_MuxFinale   <= '1';
        ctr_U_UJ_I      <= '1';

-- Store word instruction [sw]
      when "0100011" =>
        ALUsrc2         <= '1';     -- Result of address memory is calculated using immediate value.
        ctr_request_dm  <= '1';
        OpReadWrite     <= '1';
        CTR_Signed      <= '1';
        CTR_tipo_I_S_SB <= "01";
        ctr_wren_dm     <= '1';
        if funct3 = SB_FT3 then        -- store byte
          ctr_comp_op <= "00";
        elsif funct3 = SH_FT3 then     -- store halfword
          ctr_comp_op <= "01";
        elsif funct3 = SW_FT3 then     -- store word
          ctr_comp_op <= "10";
        end if;  

-- Load upper immediate - instruction [LUI]
      when "0110111" =>
        RegisterWrite   <= '1';
        CTR_LUIMux      <= '1';
        CTR_Signed      <= '1';
        CTR_MuxFinale   <= '1';
        ctr_U_UJ_I    	<= '1';

-- branch instructions
--BEQ  branch equal 
      when TYPE_SB =>
        ctr_branch      <= '1';
        CTR_tipo_I_S_SB <= "10";
        if FUNCT3 = "000" then      --BEQ
          CTR_Signed <= '1';
          ctr_comp_op <= "00"; 
--          ctr_alu_op <= "011";   
        end if;
        if FUNCT3 = "001" then      --BNE
          CTR_Signed <= '1';
          ctr_comp_op <= "01";  
--          ctr_alu_op <= "011";  
        end if;
        if FUNCT3 = "100" then      --BLT
          CTR_Signed <= '1';
          ctr_comp_op <= "10";   
--          ctr_alu_op <= "011"; 
        end if;
        if FUNCT3 = "101" then      --BGE
          CTR_Signed <= '1';
          ctr_comp_op <= "11";
--          ctr_alu_op <= "011";    
        end if;
        if FUNCT3 = "110" then      --BLTU
          CTR_Signed <= '0';
          ctr_comp_op <= "10";  
--          ctr_alu_op <= "011";  
        end if;
        if FUNCT3 = "111" then      --BGEU
          CTR_Signed <= '0';
          ctr_comp_op <= "11";  
--            ctr_alu_op <= "011";  
        end if;

-- JALR instruction
      when "1100111" =>
        RegisterWrite   <= '1';
        ALUsrc2         <= '1';
        CTR_branch      <= '1';
        CTR_JALRMux     <= '1';
        CTR_Signed      <= '1';
        ctr_U_UJ_I      <= '1';
        CTR_JAL_MUXtoRF <= '1';   --prima non c era


-- JAL instruction
      when "1101111" =>
        RegisterWrite   <= '1';
        ALUsrc2         <= '1';
        CTR_branch      <= '1';
        CTR_tipo_U_UJ   <= '1';
        CTR_MuxFinale   <= '1';
        CTR_JAL_MUXtoRF <= '1';
        CTR_Signed      <= '1';
        ctr_U_UJ_I      <= '1';
        --CTR_JALRMux     <= '1';   --prima nn c era

      -- others => default già impostato

      when others =>
        null;

    end case;
  end process;
end architecture beh;








