set using_top_module 1

if {$using_top_module == 1} {
	set input_clk clkin_50
	set input_clk_pin $input_clk
	set input_clk_period 20

	set fast_clk variable_clk_f
	set fast_clk_pin pll_2|pll3_inst|altera_pll_i|general[0].gpll~PLL_OUTPUT_COUNTER|divclk

	set slow_clk variable_clk_s
	set slow_clk_pin pll_2|pll3_inst|altera_pll_i|general[1].gpll~PLL_OUTPUT_COUNTER|divclk

	create_clock -period $input_clk_period -name $input_clk [get_ports $input_clk_pin]

	derive_pll_clocks

	create_clock -add -period [get_clock_info -period [get_clocks $fast_clk_pin]] -name $fast_clk [get_net_info -name [get_pin_info -net $fast_clk_pin]]
	remove_clock $fast_clk_pin

	create_clock -add -period [get_clock_info -period [get_clocks $slow_clk_pin]] -name $slow_clk [get_net_info -name [get_pin_info -net $slow_clk_pin]]
	remove_clock $slow_clk_pin

	set_false_path -from [get_clocks $input_clk] -to [get_clocks [list $fast_clk $slow_clk]]
	set_false_path -from [get_clocks $fast_clk] -to [get_clocks [list $input_clk $slow_clk]]
	set_false_path -from [get_clocks $slow_clk] -to [get_clocks [list $input_clk $fast_clk]]

	derive_clock_uncertainty
} else {
	create_clock -period 12.50 -name variable_clk_s [ get_ports variable_clk_s]
	create_clock -period 2.50 -name variable_clk_f [ get_ports variable_clk_f]
}