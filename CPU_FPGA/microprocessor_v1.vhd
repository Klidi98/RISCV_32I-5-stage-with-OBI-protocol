library ieee;
use ieee.std_logic_1164.all;

entity microprocessor_v1 is
    port(
        x_clk_pll                   : in    std_logic;	                   
        x_rst_n                     : in    std_logic;                          --asynchronous active low reset
		  x_GPIO_LED_o			         : out   std_logic_vector(31 downto 0);
        x_UART_tx_o                 : out   std_logic
 
    );
end entity;

architecture rtl of microprocessor_v1 is
	 
signal x_clk														: std_logic;
signal w_req_dm, w_wren_dm                                          : std_logic;
signal w_valid_im, w_valid_dm, w_ready_im,w_ready_dm                : std_logic;     
signal w_addr_im_cpu, w_addr_dm_cpu                                 : std_logic_vector(31 downto 0);
signal w_dout_from_im, w_dout_from_dm, w_din_dm_cpu                 : std_logic_vector(31 downto 0);
signal w_req_im_cpu, w_req_dm_cpu, w_wren_dm_cpu                    : std_logic;

signal gpio_LED_reg                                                 : std_logic_vector(31 downto 0) := (others => '0');
signal gpio_UART_tx_reg                                             : std_logic_vector(23 downto 0) := (others => '0');
signal gpio_TX_status_reg											: std_logic_vector(7 downto 0);
signal w_sel_gpio_LED, w_data_memory_sel,w_sel_UART_tx, w_cs_dm     : std_logic;

signal w_valid_gpio_LED	,w_ready_peripherals				        : std_logic := '0';
signal w_valid_uart_tx	,w_valid_peripherals					   	: std_logic := '0';
signal w_byte_enable_dm_cpu										   	: std_logic_vector(3 downto 0);
signal rst_n_d1,rst_n_d2										    : std_logic := '0';

signal w_data_to_core												:	std_logic_vector(31 downto 0);


begin

--LED register output assignement
x_GPIO_LED_o		<=    gpio_LED_reg;

--data memory chip select (requires valid address and request from cpu)
w_cs_dm    <= w_req_dm_cpu and w_data_memory_sel;


--************************************************
--* sampling of rst_n for metastability
--************************************************
process(x_clk,x_rst_n)
begin
if x_rst_n = '0' then
	rst_n_d1 <= '0';
	rst_n_d2 <= '0';
elsif rising_edge(x_clk) then
	rst_n_d1 <= x_rst_n;
	rst_n_d2 <= rst_n_d1;
end if;
end process;


--###########################################################
--##PLL 90 Mhz
--###########################################################
PLL: entity work.PLL_90Mhz
	port map(
				inclk0			    =>    x_clk_pll,
				c0					=>	  x_clk
			);
	
--*************************************************
--** riscv_32i OBI core
--**************************************************
core: entity work.core_riscv32i
        port map(

            x_i_rst_n                =>     rst_n_d2                ,
            x_i_clk                  =>     x_clk                   ,
            x_instr_32_i             =>     w_dout_from_im          ,
            x_data_32_i              =>     w_data_to_core          ,
            x_data_32_o              =>     w_din_dm_cpu            ,
            x_ready_im_i             =>     w_ready_im              , 
            x_ready_dm_i             =>     w_ready_peripherals     ,
            x_valid_im_i             =>     w_valid_im              ,
            x_valid_dm_i             =>     w_valid_peripherals     ,
            x_request_im_o           =>     w_req_im_cpu            ,
            x_request_dm_o           =>     w_req_dm_cpu            ,
            x_wren_dm_o              =>     w_wren_dm_cpu           ,
			   x_byte_enable_dm		    =>     w_byte_enable_dm_cpu    ,
            x_addr32_im_o            =>     w_addr_im_cpu           ,
            x_addr32_dm_o            =>     w_addr_dm_cpu
    );

--#######################################################################
--##address decoder for peripherals
--#######################################################################
addr_decoder: process(all)
begin

w_sel_gpio_led    <= '0';
w_data_memory_sel <= '0';
w_sel_UART_tx     <= '0';
w_valid_peripherals<= '0';
w_ready_peripherals<= '0';
w_data_to_core		<= (others =>'0');

    if w_addr_dm_cpu(12) = '1' then
        w_sel_gpio_LED   <= '1';
		  w_valid_peripherals <= w_valid_gpio_led;
		  w_ready_peripherals <= '1';
		  w_data_to_core      <= gpio_LED_reg;
	elsif w_addr_dm_cpu(13) = '1' then
        w_sel_UART_tx  <= '1';
		  
        w_valid_peripherals <= w_valid_uart_tx;
        w_ready_peripherals <= '1';
		  w_data_to_core(31 downto 25) <= (OTHERS => '0'); 
        w_data_to_core(24) <= gpio_tx_status_reg(0);
		  w_data_to_core(23 downto 0) <= gpio_uart_tx_reg;
		  
    else
        w_data_memory_sel   <= '1';
	     w_valid_peripherals <= w_valid_dm;
	     w_ready_peripherals <= w_ready_dm;
		  w_data_to_core      <= w_dout_from_dm;
    end if;
end process;
     
--######################################################################
--**4kB Instruction Memory instance with program already loaded
--######################################################################
instruction_memory: entity work.rom_3
    port map(

           clk                      =>      x_clk                     ,    
           req                      =>      w_req_im_cpu              ,
           we                       =>      '0'                       ,
           addr                     =>      w_addr_im_cpu(11 downto 2),
           wdata                    =>      (others => '0')           ,
           ready                    =>      w_ready_im                ,
           valid                    =>      w_valid_im                ,
           rdata                    =>      w_dout_from_im
    );

--###################################################################
--## 4kB Data Memory instance byte adressable
--##################################################################
data_memory: entity work.mem_fpga
    port map(

            clk                      =>      x_clk			               ,
		      rst_n 				       =>      rst_n_d2		               ,
            req                      =>      w_cs_dm	                  ,
            we                       =>      w_wren_dm_cpu		         ,
		      be					          =>      w_byte_enable_dm_cpu	      ,
            addr                     =>      w_addr_dm_cpu(11 downto 2) ,
            wdata                    =>      w_din_dm_cpu	            , 
            ready                    =>      w_ready_dm		            ,
            valid                    =>      w_valid_dm                 ,
            rdata                    =>      w_dout_from_dm
   );


--##################################################################
--register address for GPIOs
--##################################################################
gpio_LED_process:
process(x_clk, rst_n_d2)

begin

    if rst_n_d2 = '0' then
      gpio_LED_reg 		<= (others=> '0');
		gpio_uart_tx_reg 	<= (others=> '0');
	   w_valid_gpio_LED 	<= '0';
      w_valid_uart_tx 	<= '0';
		
    elsif rising_edge(x_clk) then
			w_valid_gpio_LED <= '0';
			w_valid_uart_tx  <= '0';
			
        if  (w_sel_gpio_LED = '1' and w_req_dm_cpu = '1') then
            gpio_LED_reg  <= w_din_dm_cpu;
            w_valid_gpio_LED <= '1';
        elsif(w_sel_UART_tx = '1' and w_req_dm_cpu = '1') then
            gpio_UART_tx_reg  <= w_din_dm_cpu(23 downto 0);
            w_valid_uart_tx <= '1';
        end if;
    end if;
end process;


--**************************************************************
--UART TX module instance
--**************************************************************
uart_tx: entity work.uart_tx
    port map(
        Din         =>      gpio_uart_tx_reg(7 downto 0)    , 
        wr          =>      gpio_uart_tx_reg(8)             ,
        clk         =>      x_clk                           ,
        rst         =>      not (rst_n_d2)                  ,
        Tx_line     =>      x_uart_tx_o                     ,
        busy        =>      gpio_tx_status_reg(0)
    );

end rtl;