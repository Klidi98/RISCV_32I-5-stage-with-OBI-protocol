library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use pipe_pckg.all;

entity ControlUnit is
  port (

    OPCODE          : in  std_logic_vector(6 downto 0);  
    FUNCT3          : in  std_logic_vector(2 downto 0);  
    FUNCT7          : in  std_logic_vector(6 downto 0);  
    illegal_instr   : out std_logic;                   --detects an invalid risc-v instruction and to be used for rising exception in future updates
    ctrl_sig        : out ctrl_unit_t
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
constant XORI_FT3  : std_logic_vector(2 downto 0) := "100";   
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
    -- default: all signals to '0' ( deactivated ).
    ctrl_sig <= CTRL_UNIT_RESET;

    case OPCODE is

-- [LW] load instructions       
      when "0000011" =>
        ctrl_sig.RF_write <= '1';
        ctrl_sig.sel_alu_src2 <= '1';
        ctrl_sig.dm_request   <= '1';
        ctrl_sig._signed      <= '1';
        ctrl_sig.type_I_S_SB  <= "00";
        ctrl_sig.type_U_UJ_I  <= '1';


        if FUNCT3 = LB_FT3 then        -- load byte
          ctr_sig.comp_op   <= "00";    
          ctr_sig.signed_ld <= '1';

        elsif FUNCT3 = LH_FT3 then     -- load halfword
          ctr_sig.comp_op   <= "01";
          ctr_sig.signed_ld <= '1';

        elsif FUNCT3 = LW_FT3 then     -- load word
          ctr_sig.comp_op <= "10"; 

        elsif FUNCT3 = LBU_FT3 then    -- load byte unsigned
          ctr_sig.comp_op <= "00";
        
        elsif FUNCT3 = LHU_FT3 then    -- load halfword unsigned
          ctr_sig.comp_op <= "01";  

        else 
          null;
        end if;
                  
-- [ADDI] Add immediate - instruction
-- TYPE I instructions
      when "0010011" =>
        ctr_sig.RF_write     <= '1';
        ctr_sig.sel_alu_src2 <= '1';
        ctr_SIG.type_I_S_SB  <= "00";
        ctr_sig.type_U_UJ_I  <= '1';
        case FUNCT3 is
          when ADDI_FT3 =>
            ctr_alu_op <= "000"; -- ADDI
            ctr_signed <= '1';
          when SLTI_FT3 =>
            ctr_signed <= '1';    --indicates immediate value is signed
            ctr_alu_op <= "010";  -- SLTI
            ctr_comp_op <= "10";
            ctr_addsub <= '1';    --indicates operation is between signed values
            
          when SLTIU_FT3 =>
            ctr_addsub <= '0';   --indicates operation is between unsigned values if set to '0'
            ctr_signed <= '1';   --indicates immediate value is signed
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
    
        
-- R-type instructions
when TYPE_R =>
    ctr_sig.RF_write <= '1';
    
    case FUNCT3 is
        when AND_FT3 =>
            ctr_sig.alu_op <= "111"; -- AND

        when OR_FT3 =>
            ctr_sig.alu_op <= "110"; -- OR

        when XOR_FT3 =>
            ctr_sig.alu_op <= "100"; -- XOR

        when SLL_FT3 =>
            ctr_sig.alu_op <= "001"; -- SLL

        when SRL_FT3 =>
            ctr_sig.alu_op <= "101"; -- SRL/SRA

            if FUNCT7(5) = '1' then
                ctr_sig.comp_op(0) <= '1';
            else
                ctr_sig.comp_op(0) <= '0';
            end if;

        when SLT_FT3 =>
            ctr_sig.alu_op  <= "010"; -- SLT
            ctr_sig.comp_op <= "10";
            ctr_sig._signed <= '1';
            ctr-sig.add_sub <= '1';

        when SLTU_FT3 =>
            ctr_sig.alu_op  <= "010"; -- SLTU
            ctr_sig.comp_op <= "10";
            ctr_sig._signed <= '0';

        when ADD_FT3 =>
            ctr_sig.alu_op <= "000";
            if FUNCT7(5) = '1' then
                ctr_sig.add_sub <= '1'; -- SUB
                
            else
                ctr_sig.add_sub <= '0'; -- ADD
            end if;
         
        when others =>
            ctr_sig.alu_op <= "000";

    end case;

-- [AUIPC] Add upper immediate program counter
when "0010111" =>
    ctr_sig.RF_write       <= '1';
    ctr_sig.sel_alu_src1   <= '1'; -- PC
    ctr_sig.sel_alu_src2   <= '1'; -- Imm
    ctr_sig.is_signed      <= '1';
    ctr_sig.imm_final_mux  <= '1';
    ctr_sig.type_U_UJ_I    <= '1';
    ctr_sig.add_sub        <= '0'; -- AUIPC esegue una somma

-- [SW] Store word/half/byte
when "0100011" =>
    ctr_sig.sel_alu_src2   <= '1'; -- Offset per calcolo indirizzo
    ctr_sig.dm_request     <= '1';
    ctr_sig.dm_wren        <= '1';
    ctr_sig.is_signed      <= '1';
    ctr_sig.type_I_S_SB    <= "01"; -- Formato S
    ctr_sig.add_sub        <= '0'; -- Calcolo indirizzo (base + offset)

    -- Gestione dimensione store tramite comp_op
    case funct3 is
        when SB_FT3 => ctr_sig.comp_op <= "00"; -- store byte
        when SH_FT3 => ctr_sig.comp_op <= "01"; -- store halfword
        when SW_FT3 => ctr_sig.comp_op <= "10"; -- store word
        when others => ctr_sig.comp_op <= "00";
    end case;

-- [LUI] Load upper immediate
when "0110111" =>
    ctr_sig.RF_write       <= '1';
    ctr_sig.lui            <= '1'; -- Attiva il mux specifico per LUI
    ctr_sig.is_signed      <= '1';
    ctr_sig.imm_final_mux  <= '1';
    ctr_sig.type_U_UJ_I    <= '1';
    ctr_sig.add_sub        <= '0';

-- branch instructions
--BEQ  branch equal 
-- Branch instructions (BEQ, BNE, BLT, BGE, BLTU, BGEU)
when TYPE_SB =>
    ctr_sig.branch      <= '1';
    ctr_sig.type_I_S_SB <= "10"; -- Formato B/SB per l'Imm Gen

    case FUNCT3 is
        when "000" => -- BEQ
            ctr_sig._signed  <= '1';
            ctr_sig.comp_op  <= "00";
            ctr_sig.add_sub  <= '1'; -- Indica confronto signed (o sottrazione per comparator)

        when "001" => -- BNE
            ctr_sig._signed  <= '1';
            ctr_sig.comp_op  <= "01";
            ctr_sig.add_sub  <= '1';

        when "100" => -- BLT
            ctr_sig._signed  <= '1';
            ctr_sig.comp_op  <= "10";
            ctr_sig.add_sub  <= '1';

        when "101" => -- BGE
            ctr_sig._signed  <= '1';
            ctr_sig.comp_op  <= "11";
            ctr_sig.add_sub  <= '1';

        when "110" => -- BLTU
            ctr_sig._signed  <= '1';
            ctr_sig.comp_op  <= "10";
            ctr_sig.add_sub  <= '0'; -- Unsigned

        when "111" => -- BGEU
            ctr_sig._signed  <= '1';
            ctr_sig.comp_op  <= "11";
            ctr_sig.add_sub  <= '0'; -- Unsigned

        when others =>
            ctr_sig._signed  <= '0';
            ctr_sig.comp_op  <= "00";
    end case;

-- JALR instruction (Jump and Link Register)
when "1100111" =>
    ctr_sig.RF_write      <= '1';
    ctr_sig.sel_alu_src2  <= '1'; -- Immediato per calcolo target
    ctr_sig.branch        <= '1'; -- Forza il salto
    ctr_sig.jalr          <= '1'; -- Seleziona target da ALU (rs1 + imm)
    ctr_sig._signed       <= '1';
    ctr_sig.type_U_UJ_I   <= '1';
    ctr_sig.jal           <= '1'; -- Mux per scrivere PC+4 nel RF

-- JAL instruction (Jump and Link)
when "1101111" =>
    ctr_sig.RF_write      <= '1';
    ctr_sig.sel_alu_src2  <= '1';
    ctr_sig.branch        <= '1';
    ctr_sig.type_U_UJ     <= "01"; -- Formato J/UJ
    ctr_sig.imm_final_mux <= '1';
    ctr_sig.jal           <= '1'; -- Scrive PC+4 nel RF
    ctr_sig._signed       <= '1';
    ctr_sig.type_U_UJ_I   <= '1';

      when others =>
        null;

    end case;
  end process;
end architecture beh;








