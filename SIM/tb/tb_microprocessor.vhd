library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;
use IEEE.std_logic_textio.all;

entity tb_microprocessor is
    generic (
        FILE_INSTR : string := "main.bin";        -- Default
        FILE_DATA  : string := "data_mem.txt"
    );
end entity;

architecture beh of tb_microprocessor is

signal clk		                : std_logic;
signal rst_n    	            : std_logic;
signal load                     : std_logic;
signal data_in  	            : std_logic_vector(31 downto 0);
signal N_instr, N_data          : integer range 0 to 1023;
signal done_in        	        : std_logic;
signal instr_type           	: std_logic;
signal done_out                 : std_logic;
signal tb_ready                 : std_logic;                          

file instr_file                 : text open read_mode is FILE_INSTR;
file data_file                  : text open read_mode is FILE_DATA;

type reg_file_t is array (0 to 31) of std_logic_vector(31 downto 0);



begin

--clock generator

-- Clock process
clk_gen : process
begin
    while true loop
        clk <= '0';
        wait for 5 ns;
        clk <= '1';
        wait for 5 ns;
    end loop;
end process;

--clk <= not clk after 5 ns;

uut: entity work.micro_cpu_obi 
    port map (
        
        x_clk             =>    clk,         
        x_rst_n           =>    rst_n,          
        x_i_LOAD          =>    load,
        x_i_N_instr       =>    N_instr,         
        x_i_N_data        =>    N_data,         
        x_i_INSTR_32      =>    data_in ,    
        x_i_instr_type    =>    instr_type,         
        x_o_ready         =>    tb_ready         
        );



  -- Stimulus
stim_proc: process
	variable li 		        : line;
	variable instr_hex 	        : string(1 to 8);
	variable instr_val          : std_logic_vector(31 downto 0);
	variable tmp:			    integer;
	
    alias all_registers is << signal .tb_microprocessor.uut.core.ID_STAGE.RF.registers : reg_file_t >>;

    begin
        -- Reset
        rst_n <= '0';
        wait for 20 ns;
        rst_n <= '1';
        wait for 20 ns;

instr_type <= '0';

if not endfile(instr_file) then
	readline(instr_file,li);
	read(li, tmp);
	N_instr <= tmp;
	
	readline(instr_file, li);
        read(li, tmp);
        N_data <= tmp;
end if;
if not endfile(instr_file) then
    readline(instr_file, li);
    hread(li, instr_val);

	
    data_in <= instr_val;  
end if;

	
        instr_type <= '0';
        load  <= '1';
        wait for 10 ns;
        load  <= '0';


	  -- Ciclo di caricamento istruzioni da file
        while not endfile(instr_file) loop
            readline(instr_file, li);
            hread(li, instr_val);
           
	    wait until (rising_edge(clk) and tb_ready = '1');
	    data_in <= instr_val;
	    
	end loop;
	
	--wait for 30 ns;
	wait until (rising_edge(clk) and tb_ready = '1');
	instr_type <= '1';
	if not endfile(data_file) then
        	readline(data_file, li);
    	        hread(li, instr_val);
    		data_in <= instr_val;
	end if;
		--
	while not endfile(data_file) loop
        readline(data_file, li);
        hread(li, instr_val);
           
	    wait until (rising_edge(clk) and tb_ready = '1');
	    data_in <= instr_val;
	end loop;
	
file_close(data_file);
file_close(instr_file);

wait for 150 us;        --assures that after this time, if successfull, the test is ended

wait until falling_edge(clk);

--  check on intenral regiasters of the core, if the test passed or not
--  register 3 contains 1 if test successfully completed (as ISA official test suite requires)

        if all_registers(3) = x"00000001" then
            report "RESULT: PASS";
        else
            report "RESULT: FAIL ( = " & to_hstring(all_registers(3)) & ")" severity error;
        end if;
	--assert false report "Program load finished" severity failure;
    std.env.finish;
	wait;
end process;	
end beh;	
	
	