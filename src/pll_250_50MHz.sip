set_global_assignment -entity "pll_250_50MHz" -library "lib_pll_250_50MHz" -name IP_TOOL_NAME "altera_pll"
set_global_assignment -entity "pll_250_50MHz" -library "lib_pll_250_50MHz" -name IP_TOOL_VERSION "16.1"
set_global_assignment -entity "pll_250_50MHz" -library "lib_pll_250_50MHz" -name IP_TOOL_ENV "mwpim"
set_global_assignment -library "lib_pll_250_50MHz" -name SPD_FILE [file join $::quartus(sip_path) "pll_250_50MHz.spd"]

set_global_assignment -library "lib_pll_250_50MHz" -name MISC_FILE [file join $::quartus(sip_path) "pll_250_50MHz_sim/pll_250_50MHz.vo"]
