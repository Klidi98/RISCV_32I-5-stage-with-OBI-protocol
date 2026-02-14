library ieee;
use ieee.std_logic_1164.all;

entity request_handler is
    port (
        clk       : in  std_logic;
        rst_n     : in  std_logic;
        block_pp  : in  std_logic;   -- stalling pipeline signal (if active pipe is stalled)
        ready_i   : in  std_logic;   -- memory ready to receive
        valid_i   : in  std_logic;   -- memory has responded to last request
        req_o     : out std_logic    -- request to  Instruction memory
    );
end entity;

architecture rtl of request_handler is
    type state_t is (INIT, START_REQ, ISSUE_NEXT);
    signal state, next_state : state_t;
    signal req : std_logic;
begin

    --------------------------------------------------------------------
    --  (Mealy) FSM
    --------------------------------------------------------------------
    process(state, ready_i, valid_i,block_pp)
    begin
        req_o <= '0';
        next_state <= state;

        case state is
            when INIT =>
                next_state <= START_REQ;            -- passa subito a inviare richiesta
                req_o <= '0';
            when START_REQ =>
                if block_pp = '0' then              
                        req_o <= '1';               -- invia richiesta
                    if ready_i = '1' then              
                        next_state <= ISSUE_NEXT;   -- passa in attesa
                    end if;
                else
                    next_state <= START_REQ;        -- pipeline bloccata: ferma richieste
                end if;
            when ISSUE_NEXT =>
                if block_pp = '1' then
                                                      -- pipeline bloccata: ferma richieste
                    if valid_i = '1' then             --if a valid arrives during stall then go in start_req
                        next_state <= START_REQ;
                    end if;

                elsif valid_i = '1' then
                    
                    req_o <= '1';                   -- nuova richiesta immediata nello stesso ciclo
                    
                    if ready_i = '1' then 
                        next_state <= ISSUE_NEXT;   -- resta in attesa della nuova
                    else 
                        next_state <= START_REQ;    -- no ready: ferma richieste
                    end if;
                else
                    next_state <= ISSUE_NEXT;       -- no ready: ferma richieste

                 end if;
            when others => next_state <= INIT;
    
        end case;
    end process;


    process(clk, rst_n)
    begin
        if rst_n = '0' then
            state <= INIT;
        elsif rising_edge(clk) then
            state <= next_state;
        end if;
    end process;

end architecture;
