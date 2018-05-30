set_global_assignment -entity "ttt2" -library "lib_ttt2" -name IP_TOOL_NAME "altera_pll"
set_global_assignment -entity "ttt2" -library "lib_ttt2" -name IP_TOOL_VERSION "16.1"
set_global_assignment -entity "ttt2" -library "lib_ttt2" -name IP_TOOL_ENV "mwpim"
set_global_assignment -library "lib_ttt2" -name SPD_FILE [file join $::quartus(sip_path) "ttt2.spd"]

set_global_assignment -library "lib_ttt2" -name MISC_FILE [file join $::quartus(sip_path) "ttt2_sim/ttt2.vo"]
