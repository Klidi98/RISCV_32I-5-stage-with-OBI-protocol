library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pLoader is
    port (

        clk             : in  std_logic;
        rst_n           : in  std_logic;

	    load_prog       : in  std_logic;  
        data_in         : in  std_logic_vector(31 downto 0);
                                    	-- signals beginning on loading of a new program in memory.                  
        N_instr_dm      : in  integer range 0 to 1023;
        N_instr_im      : in  integer range 0 to 1023;

        done_in         : in  std_logic;                              	-- segnala che il testbench ha finito di inviare

        req_new_data    : out  std_logic;
        ready_im        : in  std_logic;
        ready_dm        : in  std_logic;
        valid_im        : in  std_logic;                               	-- signals that the writing of the previous request has been completed.
        valid_dm        : in  std_logic;
 	
	we_dm,we_im     : out  std_logic;                            	-- write enable signal for memory
        request_dm      : out  std_logic;
        request_im      : out  std_logic;
        
        addr            : out  std_logic_vector(31 downto 0);
        data_out        : out  std_logic_vector(31 downto 0);          	-- data that will be loaded into memory

        done            : out std_logic                            	-- segnala che la scrittura Ã¨ finita
    );
end entity;

architecture rtl of pLoader is

    type state_type is (IDLE, START_REQ_IM, START_REQ_DM, WAIT_VALID_IM, WAIT_VALID_DM, COUNT_IM, COUNT_DM,WAIT_STATE);
    signal current_state, next_state : state_type;

    signal Instr_counter_im, instr_counter_dm            : integer range 0 to 1024;            --tiene traccia dell'indirizzo corrente
    signal wait_cnt             : integer := 0;
    signal sig_Ninstructions_dm, sig_Ninstructions_im    : integer range 0 to 1024;
    signal cnt_im               : integer := 0;
    signal cnt_dm               : integer := 0;
    signal en_cnt_im            : std_logic := '0';
    signal en_cnt_dm            : std_logic := '0';
    signal en_wait_cnt            : std_logic := '0';
    signal done_valid           : std_logic;                           				-- generated when the memory has given a valid for all the instructions to be written
    signal done_req             : std_logic;                           				-- done generato una volta che la memoria ha ricevuto la richiesta per tutte le istruzioni da scrivere

	
    signal done_valid_im        : std_logic;
    signal done_valid_dm        : std_logic;
    signal current_mem          : std_logic;    						            --says which mem is currently being loaded at the moment

    begin


--PROCESS PER evoluzione degli stati.
  --PROCESS PER evoluzione degli stati.
    process(clk, rst_n)
    begin
        if rst_n = '0' then
            wait_cnt <= 0;
            cnt_im <= 0;
            cnt_dm <= 0;
            current_state <= IDLE;
        elsif rising_edge(clk) then 
            current_state <= next_state;
            if en_cnt_im = '1' then
                cnt_im <= cnt_im + 1;
            end if;
            if en_cnt_dm = '1' then
                cnt_dm <= cnt_dm + 1;
            end if;
            if en_wait_cnt = '1' then
                wait_cnt <= wait_cnt + 1;
            end if;
         
        end if;
    end process;


--current and next_state flow description
    process(current_state,load_prog, ready_dm, ready_im,valid_im,valid_dm, cnt_im, cnt_dm, N_instr_im, N_instr_dm,wait_cnt)
    begin
    case current_state is

        when IDLE => 
            if load_prog = '1' then
                if cnt_im /= N_instr_im - 1 then
                    next_state <=   WAIT_STATE;
                else 
                    next_state <= current_state;
                end if;
            end if;

        when WAIT_STATE =>
            if wait_cnt = 10 then
                next_state <= START_REQ_IM;
            else 
                next_state <= current_state;
            end if;

        when START_REQ_IM => 
            if ready_im = '1' then
                next_state <= WAIT_VALID_IM;
            else
                next_state <= current_state;
            end if;

        when START_REQ_DM =>
            if ready_dm = '1' then
                next_state <= WAIT_VALID_DM;
            else 
                next_state <= current_state;
            end if;

    
        when WAIT_VALID_IM =>
            if valid_im = '1' then
                next_state <= COUNT_IM;
            else 
                next_state <= current_state;
            end if;

        when COUNT_IM =>
            if cnt_im = N_instr_im - 1 then
                if cnt_dm /= N_instr_dm - 1 then
                    next_state <= START_REQ_DM;
                else 
                    next_state <= IDLE;
                end if;
            else 
                next_state <= START_REQ_IM;
            end if;

        when WAIT_VALID_DM =>
            IF VALID_DM = '1' THEN
                next_state <= COUNT_DM;
            ELSE 
                next_state <= current_state;
            END IF;
            
        when COUNT_DM =>
            if cnt_dm = N_instr_dm - 1 then
                next_state <= IDLE;
            else 
                next_state <= START_REQ_DM;
            end if;

        when others =>
                next_state<=IDLE;
    end case;
    end process;
        
--CONTROL unit definition

    process(current_state, valid_im, valid_dm)
    begin
 
        request_im   <= '0';
        request_dm   <= '0';
        req_new_data  <= '0';
        en_cnt_im    <= '0';
        en_cnt_dm    <= '0';
        current_mem  <= '0';
        en_wait_cnt  <= '0';
        case current_state is
        when IDLE =>  
            done <= '1';
    --        cnt_im <= 0;


        when START_REQ_IM =>
            done <= '0';
            request_im   <= '1';
            we_im        <= '1';
            current_mem  <= '0';
           
        WHEN WAIT_STATE =>
            en_wait_cnt <= '1';
            done        <= '0'; 

        when WAIT_VALID_IM =>
            current_mem <= '0';
            done <= '0';
            if valid_im = '1' THEN
                req_new_data <= '1';
                en_cnt_im <= '1';
            END IF;
        
	    when START_REQ_DM =>
            done <= '0';
            request_DM  <= '1';
            we_dm       <= '1';
            current_mem <= '1';
        
        WHEN COUNT_IM =>
            current_mem <= '0';

	
        when WAIT_VALID_DM =>
            current_mem <= '1';
            done <= '0';
            if valid_dm = '1' THEN
                req_new_data <= '1';
                en_cnt_dm <= '1';
                
            end if;
        when others =>
            done <= '0';
        end case;
    end process;

--process( clk,rst_n  )
--begin
--    if rst_n = '0' then
--        cnt_dm <= 0;
--    elsif rising_edge(clk) then
--        if valid_dm = '1' then
--            cnt_dm <= cnt_dm + 1;
--        end if;
--    end if;
--end process;

data_out <= data_in;

addr <= std_logic_vector(to_unsigned(cnt_im, addr'length))  when current_mem = '0' else std_logic_vector(to_unsigned(cnt_dm,addr'length)); 


           
end architecture;