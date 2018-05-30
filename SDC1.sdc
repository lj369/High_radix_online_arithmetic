set altera_reserved_tck { altera_reserved_tck }
#set clkin_125           { clkin_125 }
create_clock -period 20.00 -name clkin_50  [ get_ports clkin_50  ]
create_clock -period  8.00 -name clkin_125  [ get_ports clkin_125  ]
#create_clock -period 20.00 -name variable_clk_2 [ get_nets variable_clk_2]
#create_clock -period 20.00 -name ctrl_clk [ get_ports ctrl_clk]
#create_clock -period 2.50 -name variable_clk [ get_nets {*pll3:pll_2|pll3_0002:pll3_inst|altera_pll:altera_pll_i|outclk_wire[0]}]
create_clock -name {altera_reserved_tck} -period 41.667 [get_ports { altera_reserved_tck }]
#create_clock -period 20.00 -name variable_clk_2 [ get_ports variable_clk_2]
#create_clock -period 2.50 -name variable_clk [ get_ports variable_clk]
#create_generated_clock

derive_pll_clocks

set_false_path -from [get_clocks {clkin_50}] -to [get_clocks {pll_2|pll3_inst|altera_pll_i|general[0].gpll~PLL_OUTPUT_COUNTER|divclk}]

set_false_path -from [get_clocks {clkin_50}] -to [get_clocks {pll_2|pll3_inst|altera_pll_i|general[1].gpll~PLL_OUTPUT_COUNTER|divclk}]

set_false_path -from [get_clocks {pll_2|pll3_inst|altera_pll_i|general[0].gpll~PLL_OUTPUT_COUNTER|divclk}] -to [get_clocks {pll_2|pll3_inst|altera_pll_i|general[1].gpll~PLL_OUTPUT_COUNTER|divclk}]

set_false_path -from [get_clocks {pll_2|pll3_inst|altera_pll_i|general[0].gpll~PLL_OUTPUT_COUNTER|divclk}] -to [get_clocks {clkin_50}]

set_false_path -from [get_clocks {pll_2|pll3_inst|altera_pll_i|general[1].gpll~PLL_OUTPUT_COUNTER|divclk}] -to [get_clocks {clkin_50}]

set_false_path -from [get_clocks {pll_2|pll3_inst|altera_pll_i|general[1].gpll~PLL_OUTPUT_COUNTER|divclk}] -to [get_clocks {pll_2|pll3_inst|altera_pll_i|general[0].gpll~PLL_OUTPUT_COUNTER|divclk}]


derive_clock_uncertainty