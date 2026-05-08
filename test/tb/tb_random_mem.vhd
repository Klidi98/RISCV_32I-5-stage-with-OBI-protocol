library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;
use IEEE.std_logic_textio.all;

entity tb_random_mem is
    generic (
        FILE_INSTR : string := "main.bin";        -- Default
        FILE_DATA  : string := "data_mem.txt";
        FILE_LOG   : string := "log_rtl.txt";
        LATENCY    : integer:= 0
    );
end entity;

architecture beh of tb_random_mem is

signal clk		                : std_logic;
signal rst_n    	            : std_logic;
signal load                     : std_logic;
signal data_in  	            : std_logic_vector(31 downto 0);
signal N_instr, N_data          : integer range 0 to 1023;
signal done_in        	        : std_logic;
signal instr_type           	: std_logic;
signal done_out                 : std_logic;
signal tb_ready                 : std_logic; 
signal tot_instr                : integer := 0;       --variable for counting all the commited instructions at end of simulation  

signal w_im_addr, w_dm_addr     : std_logic_vector(31 downto 0) ;
signal w_im_din, w_dm_din       : std_logic_vector(31 downto 0) ;
signal w_im_dout, w_dm_dout     : std_logic_vector(31 DOWNTO 0);
signal w_im_we, w_dm_we,w_im_req,w_dm_req,w_commit             : std_logic;
SIGNAL w_im_ready, w_dm_ready, w_im_valid, w_dm_valid : std_logic;
signal w_dm_be : std_logic_vector(3 downto 0);

file instr_file                 : text open read_mode is FILE_INSTR;
file data_file                  : text open read_mode is FILE_DATA;
file log_file                   : text open write_mode is FILE_LOG;



type reg_file_t is array (0 to 31) of std_logic_vector(31 downto 0);
signal addr_to_im, addr_to_dm      : std_logic_vector(31 downto 0) ;


signal pc_mem    : std_logic_vector(31 downto 0);
signal pc_wb     : std_logic_vector(31 downto 0);

begin
    addr_to_im <= (31 downto 10 => '0') & w_im_addr(11 downto 2);
    addr_to_dm <= (31 downto 10 => '0') & w_dm_addr(11 downto 2);

--clk <= not clk after 5 ns;
uut: entity work.core_riscv32i 
    port map (
            x_i_rst_n           =>  rst_n,                         
            x_i_clk             =>  clk,    
            x_instr_32_i        =>  w_im_dout,    
            x_data_32_i         =>  w_dm_dout,   
            x_data_32_o         =>  w_dm_din,
            x_ready_im_i        =>  w_im_ready,    
            x_ready_dm_i        =>  w_dm_ready,    
            x_valid_im_i        =>  w_im_valid,
            x_valid_dm_i        =>  w_dm_valid,
            x_instr_commit_o    =>  w_commit,    
            x_request_im_o      =>  w_im_req,     
            x_request_dm_o      =>  w_dm_req,
            x_wren_dm_o         =>  w_dm_we,    
            x_byte_enable_dm    =>  w_dm_be,    
            x_addr32_im_o       =>  w_im_addr,    
            x_addr32_dm_o       =>  w_dm_addr        
        );

imem: entity work.random_memory 
generic map(
    MEM_FILE => FILE_INSTR,
    LATENCY  => LATENCY
)
port map(
        clk         =>  clk,
        rst_n       =>  rst_n,
        req         =>  w_im_req,
        addr        =>  addr_to_im,
        we          =>  '0'             ,
        be          =>  "1111"          ,
        data_in     =>  (others => 'Z'),
        data_out    =>  w_im_dout      ,
        ready       =>  w_im_ready     ,
        valid       =>  w_im_valid
);

dmem: entity work.random_memory
generic map(
    MEM_FILE => FILE_DATA,
    LATENCY  => LATENCY
)
port map(

        clk         =>  clk,
        rst_n       =>  rst_n,
        req         =>  w_dm_req,
        addr        =>  addr_to_dm,
        we          =>  w_dm_we,
        be          =>  w_dm_be,
        data_in     =>  w_dm_din,
        data_out    =>  w_dm_dout,
        ready       =>  w_dm_ready,
        valid       =>  w_dm_valid
);


--clock generator
clk_gen : process
begin
    clk <= '0';
    wait for 1 ns;
    clk <= '1';
    wait for 1 ns;
end process;

rst_gen: process
begin
        -- Reset
       rst_n <= '0';
       wait for 127 ns;
       rst_n <= '1';
       wait;
end process;


--propagation of pc counter to wb stage for printing pc of committed instrction
pc_propagate_proc:process(clk)
alias pc_exe       is << signal .tb_random_mem.uut.EXE_STAGE.current_pc_i      : std_logic_vector >>;
alias stall_pp     is << signal .tb_random_mem.uut.staller.block_pipe          : std_logic >>;
begin
    if rising_edge(clk) then
        if stall_pp = '0' then
            pc_mem    <= pc_exe;        
            pc_wb     <= pc_mem;
        end if;
    end if;
end process;

verify_proc: process

alias all_registers is << signal .tb_random_mem.uut.ID_STAGE.RF.registers : reg_file_t >>;
begin
--  check on internal regiasters of the core, if the test passed or not
--  register 3 contains 1 if test successfully completed (as ISA official test suite requires).
    if rst_n /= '1' then
        wait until rst_n = '1';  --wait until the cpu is running, then start checking for test result. This is needed because the test program writes 1 in register 3 at the end of the test, so we need to wait until the program is loaded and started before checking the value of register 3.
    end if;

    wait until (falling_edge(clk));
        if all_registers(3) = x"00000001" then
            report "RESULT: PASS";
            report "Total instructions committed: " & integer'image(tot_instr) severity note;

            for i in 0 to 31 loop
            -- Stampiamo ogni registro su una nuova riga della console
                report "  R" & integer'image(i) & ": " & to_hstring(all_registers(i));
            end loop;

          	file_close(log_file);
            std.env.finish;

        elsif now > 1 ms then
            report "RESULT: FAIL ( = " & to_hstring(all_registers(3)) & ")" severity error;
            file_close(log_file);    
            std.env.finish;                  
        end if;
--	wait;
end process;	
process
begin
	report "loading :" & FILE_INSTR & " and " & FILE_DATA severity note;
	wait;
end process;


--monitor process for internal signals in order to create log file with all commited instructions and relative data.

signal_monitor: process

variable row          : line;
alias pc              is << signal .tb_random_mem.uut.WB_STAGE.i_next_pc         : std_logic_vector >>;
alias dest_reg        is << signal .tb_random_mem.uut.MEM_WB_PP.o_dr_mem         : std_logic_vector >>;
alias debug_instr     is << signal .tb_random_mem.uut.MEM_WB_PP.o_debug_instr    : std_logic_vector >>;
alias instr_commit    is << signal .tb_random_mem.uut.x_instr_commit_o           : std_logic >>;
alias data_reg        is << signal .tb_random_mem.uut.WB_STAGE.o_wdata_rf        : std_logic_vector >>;
alias we_dm           is << signal .tb_random_mem.uut.MEM_STAGE.dm_we_i          : std_logic >>;
alias req_dm          is << signal .tb_random_mem.uut.MEM_STAGE.dm_req_i         : std_logic >>;
alias sw_data         is << signal .tb_random_mem.uut.MEM_STAGE.dm_wdata_o       : std_logic_vector >>;
alias sw_addr         is << signal .tb_random_mem.uut.MEM_STAGE.dm_addx_o        : std_logic_vector >>;
alias en_wbpp         is << signal .tb_random_mem.uut.MEM_WB_PP.enable           : std_logic >>;

variable store_flag  : boolean := false;  --flag that indicates if the current instruction is a store, used to print the value stored in memory in the log file
variable cycles      : integer := 0;      --variable for counting the cycles of the simulation, used for debugging purposes
variable target_cyc  : integer := 0;      --variable that indicates the cycle in which the instruction is commited, used to print the value stored in memory in the log file
variable dm_req      : std_logic;
variable dm_addr     : std_logic_vector(31 downto 0);
variable dm_wdata    : std_logic_vector(31 downto 0);

begin

	wait until rising_edge(clk);
    --cycles := cycles + 1;

    --the store instruction is captured in the mem_stage, but it will be commited in the next stage
        if req_dm = '1'and we_dm = '1' then
            store_flag := true;
            target_cyc := cycles;       
            dm_addr    := sw_addr;
            dm_wdata   := sw_data;
        end if;


        if instr_commit = '1' then
            tot_instr <= tot_instr + 1;
            
            hwrite(row, pc_wb); 
            write(row, string'(";"));
            hwrite(row, debug_instr);  
            write(row,  string'(";"));
            write(row,  to_integer(unsigned(dest_reg)));
            write(row,  string'(";"));
            if(dest_reg /= "00000") then
                hwrite(row, data_reg);
            else
                write(row, string'("00000000"));
            end if;

            write(row, string'(";"));
        --  write(row,  string'(";"));
            if (store_flag and (cycles > target_cyc)) then
                hwrite(row, dm_addr);
                write(row, string'(";"));
                hwrite(row, dm_wdata);
                write(row, string'(";"));
                store_flag := false;    --reset store flag after printing the store information in the log file
            else 
                write(row, string'("00000000"));
                write(row, string'(";"));
                write(row, string'("00000000"));
                write(row, string'(";"));
            end if;

            write (row, string'(" @"));
            write (row, (integer'image(now / 1 ns) & " ns" ));
            
            writeline(log_file, row);
            
            report to_hstring(pc_wb) & ";" & to_hstring(debug_instr) & " ; " & integer'image(to_integer(unsigned(dest_reg))) & ": " & to_hstring(data_reg)  severity note;
        
        end if;

        cycles := cycles + 1;
end process;

end beh;	
	
	
