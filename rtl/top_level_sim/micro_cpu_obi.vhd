--#microporcessor file used for simulation and testing.
--#It has a loader that loads instructions and data into instruction and data memory before starting the cpu core.
--It uses random access delay memories to simulate and test OBI protocol.
--##########################################################################
--##########################################################################
--#Klides Kaba 2025


library ieee;
use ieee.std_logic_1164.all;

entity micro_cpu_obi is
    port(
        x_clk                       : in    std_logic;
        x_rst_n                     : in    std_logic;  
        x_i_LOAD                    : in    std_logic;
        x_i_N_instr                 : in    integer range 0 to 1023;          --number of instructions to load into instruction memory
        x_i_N_data                  : in    integer range 0 to 1023;          --number of data to load into data memory
	    x_i_INSTR_32 	            : in    std_logic_vector(31 downto 0);
        x_i_instr_type              : in    std_logic;                       --type of instruction that is being loaded
        x_o_ready                   : out   std_logic                        --when loading signals cpu is ready for new data write in memory
    );
end entity;

architecture rtl of micro_cpu_obi is

signal w_pl_done,w_rst_n, w_mem_owner, w_start_loading, w_req_dm, w_wren_dm             : std_logic;
signal w_done_in, w_valid_im, w_valid_dm, w_ready_im,w_ready_dm                         : std_logic;   
signal w_wren_im_ext, w_wren_dm_ext, w_req_im_ext, w_req_dm_ext                         : std_logic;
signal w_addr_ext,w_addr_im_cpu, w_addr_dm_cpu, w_addr_im,w_addr_dm, w_addr_i_cpu, w_addr_d_cpu : std_logic_vector(31 downto 0);
signal w_din_ext, w_din_im,w_din_dm, w_dout_from_im, w_dout_from_dm, w_din_dm_cpu                : std_logic_vector(31 downto 0);
signal w_req_im_cpu, w_req_dm_cpu, w_wren_dm_cpu                                        : std_logic;
signal w_req_im, w_wren_im                                                              : std_logic;
signal w_byte_enable_cpu ,w_byte_enable_dm                                              : std_logic_vector(3 downto 0);

begin
    
w_addr_i_cpu 		<= 	"00" & w_addr_im_cpu(31 downto 2)   ;
w_addr_d_cpu 		<= 	"00" & w_addr_dm_cpu(31 downto 2)   ;

--*********CPU_HANDLER_STATES*******************************--
--**HANDLES cpu states
--**********************************************************--
cpu_states : entity work.cpu_handler_states 
        port map(
            grst_n                  => x_rst_n              ,      
            gclk                    => x_clk                ,
            load_prog               => x_i_LOAD             ,
            pl_done                 => w_pl_done            ,
            reset_n                 => W_rst_n              ,
            mem_owner               => w_mem_owner          ,
            start_loading           => w_start_loading  
        );


-- component
-- program loader
program_loader: entity work.pLoader
        port map(
            clk                     =>  x_clk               ,       
            rst_n                   =>  x_rst_n             ,
            load_prog               =>  w_start_loading     ,
            data_in                 =>  x_i_INSTR_32        ,
            N_instr_dm              =>  x_i_N_data          ,
            N_instr_im              =>  x_i_N_instr         ,
            done_in                 =>  w_done_in           ,
            req_new_data            =>  x_o_ready           ,
            ready_im                =>  w_ready_im          ,
            ready_dm                =>  w_ready_dm          ,
            valid_im                =>  w_valid_im          ,
            valid_dm                =>  w_valid_dm          ,
            we_im                   =>  w_wren_im_ext       ,
            we_dm                   =>  w_wren_dm_ext       ,
            request_im              =>  w_req_im_ext        ,
            request_dm              =>  w_req_dm_ext        ,
            addr                    =>  w_addr_ext          ,
            data_out                =>  w_din_ext           ,
            done                    =>  w_pl_done   
        ); 

--*******************************************************
--**core
--*******************************************************
core: entity work.core_riscv32i
        port map(

            x_i_rst_n               =>  w_rst_n             ,
            x_i_clk                 =>  x_clk               ,  
            x_instr_32_i            =>  w_dout_from_im      ,
            x_data_32_i             =>  w_dout_from_dm      , 
            x_data_32_o             =>  w_din_dm_cpu        ,
            x_ready_im_i            =>  w_ready_im          ,
            x_ready_dm_i            =>  w_ready_dm          ,
            x_valid_im_i            =>  w_valid_im          ,
            x_valid_dm_i            =>  w_valid_dm          ,
            x_request_im_o          =>  w_req_im_cpu        ,
            x_request_dm_o          =>  w_req_dm_cpu        ,
            x_wren_dm_o             =>  w_wren_dm_cpu       ,
            x_byte_enable_dm        =>  w_byte_enable_cpu   ,      
            x_addr32_im_o           =>  w_addr_im_cpu       ,
            x_addr32_dm_o           =>  w_addr_dm_cpu

    );

muxer_im: entity work.mux_to_mem
    port map(

             sel                    =>  w_mem_owner         ,
             req_from_cpu           =>  w_req_im_cpu        ,
             req_from_ext           =>  w_req_im_ext        ,
             we_from_cpu            =>  '0'                 ,
             we_from_ext            =>  w_wren_im_ext       ,
             be_from_cpu            =>  (others => '0')     ,
             addr_from_cpu          =>  w_addr_i_cpu        ,
             addr_from_ext          =>  w_addr_ext          ,
             din_from_cpu           =>  w_din_ext           ,
             din_from_ext           =>  w_din_ext           ,
             req                    =>  w_req_im            ,
             we                     =>  w_wren_im           ,
             addr                   =>  w_addr_im           ,
             din                    =>  w_din_im
    );

muxer_dm: entity work.mux_to_mem
    port map(

             sel                    =>  w_mem_owner         ,
             req_from_cpu           =>  w_req_dm_cpu        ,
             req_from_ext           =>  w_req_dm_ext        ,
             we_from_cpu            =>  w_wren_dm_cpu       ,
             we_from_ext            =>  w_wren_dm_ext       ,
             be_from_cpu            =>  w_byte_enable_cpu   ,
             addr_from_cpu          =>  w_addr_d_cpu        ,
             addr_from_ext          =>  w_addr_ext          ,
             din_from_cpu           =>  w_din_dm_cpu        ,
             din_from_ext           =>  w_din_ext           ,
             req                    =>  w_req_dm            ,
             we                     =>  w_wren_dm           ,
             be                     =>  w_byte_enable_dm    ,
             addr                   =>  w_addr_dm           ,
             din                    =>  w_din_dm
    );


instruction_memory: entity work.random_obi_memory
  port map(
         clk                        =>  x_clk                  ,     
         req                        =>  w_req_im               ,
	      rst_n                      =>  x_rst_n		       ,
          be                        => "1111",
         we                         =>  w_wren_im              ,            
         addr                       =>  w_addr_im(9 downto 0)  ,
         wdata                      =>  w_din_im               ,
         ready                      =>  w_ready_im             ,
         valid                      =>  w_valid_im             ,
         rdata                      =>  w_dout_from_im
  );

data_memory: entity work.random_obi_memory
    port map(
           clk                      =>  x_clk			       ,     
           rst_n                    =>  x_rst_n			       ,
           req                      =>  w_req_dm			   ,
           we                       =>  w_wren_dm			   ,
           be                       =>  w_byte_enable_dm       ,
           addr                     =>  w_addr_dm(9 downto 0)  ,
           wdata                    =>  w_din_dm			   ,
           ready                    =>  w_ready_dm			   ,
           valid                    =>  w_valid_dm			   ,
           rdata                    =>  w_dout_from_dm
   );

end rtl; 