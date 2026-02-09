
create_clock -name {x_clk_pll} -period 83.333 [get_ports {x_clk_pll}]


derive_pll_clocks
derive_clock_uncertainty

set_false_path -to [get_ports {x_GPIO_LED_o[*]}]

#reset is asynchronous
set_false_path -from [get_ports {x_rst_n}]

set_false_path -from [get_ports {x_uart_tx_o}]