--file CPU_HANDLER_STATES
--it decides if the cpu is running or is loading a new pprogram from external.
--Handles the loading of the program and the restart of the cpu when loading is finished.

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
entity cpu_handler_states is
Port (
    GRST_n          : in std_logic ;
    GCLK            : in std_logic ;    
    load_prog       : in std_logic ;    --external comand for loading a new program in memory
    pl_done         : in std_logic ;    --done coming from program loader
    reset_n         : out std_logic;
    mem_owner       : out std_logic;    --assigns memories to cpu ('0') or program loader('1');
    start_loading   : out std_logic     --starts the program loader
);
end entity;

architecture beh of cpu_handler_states is

type state_type is(IDLE, RUN, LOAD_1, LOAD_2);
signal current_state, next_state: state_type;
    
begin

process(GRST_N,GCLK)
begin   
    if GRST_N = '0' then
        current_state <= IDLE;
    else if rising_edge(GCLK) then
        current_state <= next_state;
    end if;
    end if;
end process;    

--EVOLUZIONE STATI
process(current_state, load_prog, pl_done)
begin
    case(current_state) is
    when IDLE =>
        next_state <= RUN;
    
    when RUN =>
        if load_prog = '1' then
            next_state <= LOAD_1;
        else 
            next_state <= current_state;
        end if;
    when LOAD_1 => 
            next_state <= LOAD_2;
    when LOAD_2 =>
        if pl_done = '1' then
            next_state <= IDLE;
        else
            next_state <= current_state;
        end if;
    end case;
end process;

process(current_state)
begin
start_loading <= '0';
reset_n <= '1';
mem_owner <= '0';

    case current_state is
    WHEN IDLE =>
        reset_n <= '0';

    WHEN RUN =>
        mem_owner <= '0';    --CPU CONTROL
        reset_n <= '1';
    
    when LOAD_1 =>
        mem_owner <= '1';    --PROGRAM LOADER CONTROL
        start_loading <= '1';
        reset_n <= '0';

    when LOAD_2 => 
        mem_owner <= '1';
        reset_n <= '0';
    

    end case;
    end process;

    end beh;
