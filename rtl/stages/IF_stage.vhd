library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity fetch is
    port (

        clk                     : in  std_logic;
        rst_n                   : in  std_logic;
        
    --Memory interface 
        o_request               : out  std_logic;                       -- request for IM
        ready_im                : in   std_logic;                       -- memory is ready for new request
        valid_im                : in   std_logic;                       -- memory access has been executed
        next_instruction_i      : in  std_logic_vector(31 downto 0);   -- Current instruction to be decoded and executed

    --ports toward next pipeline stage
        next_instruction_o      : out std_logic_vector(31 downto 0);
        current_PC_o            : out std_logic_vector(31 downto 0);    -- PC that points to current instruction
        PreviousPC_o            : out std_logic_vector(31 downto 0);    -- PC that points to previous instruction
        next_PC_o               : out std_logic_vector(31 downto 0);    -- PC that points to next instruction
        valid_instr_o           : out std_logic;
    --Ports from other pipeline stages
        i_pc_jump               : in  std_logic_vector(31 downto 0);    -- jump address
        i_selNextPC             : in  std_logic;                        -- it selects the jump address or the next address( +4 ) for the PC
        i_block_pp              : in  std_logic

    );
end entity;

architecture rtl of fetch is  

    signal w_OutputMux1PC        : std_logic_vector(31 downto 0);
    signal w_PC_out,w_next_PC    : std_logic_vector(31 downto 0);
    signal w_pc_enable           : std_logic;
    signal w_req_o               : std_logic;
    signal w_buffered_instruction : std_logic_vector(31 downto 0);
    signal w_buf_instr_valid      : std_logic;          -- signal that indicates if buffered instruction is valid
    signal w_valid_instr_o        : std_logic;
begin

    current_PC_o <= w_PC_out;

-- buffering instruction when pipeline is stalled: belowe an explanation of how it works
-- When the pipeline is stalled (i_block_pp = '1') and a valid instruction is fetched from instruction memory (valid_im = '1'),
-- the instruction is stored in w_buffered_instruction and w_buf_instr_valid is set to '1'.
-- This buffered instruction can then be output on next_instruction_o when the pipeline is no longer stalled.
buff_instr_reg:process(clk, rst_n)
begin
    if rst_n = '0' then
        w_buffered_instruction <= (others => '0');
        w_buf_instr_valid <= '0';
    elsif rising_edge(clk) then
        if valid_im = '1' and i_block_pp = '1' then
            w_buf_instr_valid <= '1';
            w_buffered_instruction <= next_instruction_i;
        else if w_valid_instr_o = '1' and i_block_pp = '0' then
                -- clear the buffered instruction valid signal when pipeline is not stalled  
            w_buf_instr_valid <= '0';
        end if;
        end if;
        end if;
    end process;

        
    next_PC_o    <= w_next_PC;
   -- w_pc_enable     <= (w_req_o and ready_im) or not (i_block_pp);
    --w_pc_enable     <= valid_im and not(i_block_pp);

    w_pc_enable     <= (w_req_o and ready_im);


    req_handler: entity work.request_handler
        port map (
            clk       =>  clk,
            rst_n     =>  rst_n,
            block_pp  =>  i_block_pp,   -- pipeline is blocked, so no request has to be made to IM
            ready_i   =>  ready_im, 
            valid_i   =>  valid_im,
            req_o     =>  w_req_o 
        );

    -- Program Counter register
    PC_register : entity work.PC
        port map (
            clk     => clk,
            rst_n   => rst_n,
            enable  => w_pc_enable,
            data_in => w_OutputMux1PC,
            q       => w_PC_out
        );

    -- Register for previous PC
    -- This rgister represents the address of the next instruction that will be sampled by the pipe.
    previousPC: entity work.generic_reg
        port map (
            CLK    => clk        ,
            RESET  => rst_n      ,
            ENABLE => w_pc_enable,  
            D_IN   => w_PC_out   ,
            D_OUT  => PreviousPC_o
        );

        -- mux1Pc
    muxPc : entity work.mux2to1
        GENERIC map (n => 32)
        port map (
            sel     => i_selNextPC,
            input_0 => w_next_pc,
            input_1 => i_pc_jump,
            q       => w_OutputMux1PC
        );

    -- PC + 4
    PC_Adder: entity work.adder
        port map (
            a   => w_PC_out,
            b   => x"00000004",
            sum => w_next_pc
        );

o_request <= w_req_o;
w_valid_instr_o <= '1' when w_buf_instr_valid = '1' else valid_im;

next_instruction_o <= w_buffered_instruction when w_buf_instr_valid = '1' else next_instruction_i;

valid_instr_o <= w_valid_instr_o;
end architecture;
