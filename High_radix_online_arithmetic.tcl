# Copyright (C) 2016  Intel Corporation. All rights reserved.
# Your use of Intel Corporation's design tools, logic functions 
# and other software and tools, and its AMPP partner logic 
# functions, and any output files from any of the foregoing 
# (including device programming or simulation files), and any 
# associated documentation or information are expressly subject 
# to the terms and conditions of the Intel Program License 
# Subscription Agreement, the Intel Quartus Prime License Agreement,
# the Intel MegaCore Function License Agreement, or other 
# applicable license agreement, including, without limitation, 
# that your use is for the sole purpose of programming logic 
# devices manufactured by Intel and sold by Intel or its 
# authorized distributors.  Please refer to the applicable 
# agreement for further details.

# Quartus Prime: Generate Tcl File for Project
# File: High_radix_online_arithmetic.tcl
# Generated on: Sun Apr 15 21:50:29 2018

# Load Quartus Prime Tcl Project package
package require ::quartus::project

set need_to_close_project 0
set make_assignments 1

# Check that the right project is open
if {[is_project_open]} {
	if {[string compare $quartus(project) "High_radix_online_arithmetic"]} {
		puts "Project High_radix_online_arithmetic is not open"
		set make_assignments 0
	}
} else {
	# Only open if not already open
	if {[project_exists High_radix_online_arithmetic]} {
		project_open -revision High_radix_online_arithmetic High_radix_online_arithmetic
	} else {
		project_new -revision High_radix_online_arithmetic High_radix_online_arithmetic
	}
	set need_to_close_project 1
}

# Make assignments
if {$make_assignments} {
	set_global_assignment -name FAMILY "Cyclone V"
	set_global_assignment -name DEVICE 5CSXFC6D6F31C6
	set_global_assignment -name TOP_LEVEL_ENTITY masterLevel
	set_global_assignment -name ORIGINAL_QUARTUS_VERSION 16.1.0
	set_global_assignment -name PROJECT_CREATION_TIME_DATE "16:06:01  MARCH 26, 2018"
	set_global_assignment -name LAST_QUARTUS_VERSION "16.1.0 Lite Edition"
	set_global_assignment -name PROJECT_OUTPUT_DIRECTORY output_files
	set_global_assignment -name MIN_CORE_JUNCTION_TEMP 0
	set_global_assignment -name MAX_CORE_JUNCTION_TEMP 85
	set_global_assignment -name ERROR_CHECK_FREQUENCY_DIVISOR 256
	set_global_assignment -name POWER_PRESET_COOLING_SOLUTION "23 MM HEAT SINK WITH 200 LFPM AIRFLOW"
	set_global_assignment -name POWER_BOARD_THERMAL_MODEL "NONE (CONSERVATIVE)"
	set_global_assignment -name EDA_SIMULATION_TOOL "ModelSim-Altera (Verilog)"
	set_global_assignment -name EDA_TIME_SCALE "1 ps" -section_id eda_simulation
	set_global_assignment -name EDA_OUTPUT_DATA_FORMAT "VERILOG HDL" -section_id eda_simulation
	set_global_assignment -name VERILOG_FILE src/concatenateDout.v
	set_global_assignment -name VERILOG_FILE src/clockEnablePLL/synthesis/clockEnablePLL.v
	set_global_assignment -name QIP_FILE src/traditional_adder.qip
	set_global_assignment -name VERILOG_FILE src/test.v
	set_global_assignment -name VERILOG_FILE src/ramAddress.v
	set_global_assignment -name VERILOG_FILE src/radix4WModification.v
	set_global_assignment -name VERILOG_FILE src/radix4SELM.v
	set_global_assignment -name VERILOG_FILE src/radix4MultiplierTestbench.v
	set_global_assignment -name VERILOG_FILE src/radix4multiplier.v
	set_global_assignment -name VERILOG_FILE src/radix4DigitMultiply.v
	set_global_assignment -name VERILOG_FILE src/radix4calcVj.v
	set_global_assignment -name VERILOG_FILE src/radix4AdderTestbench.v
	set_global_assignment -name SYSTEMVERILOG_FILE src/radix4adder_sv.sv
	set_global_assignment -name VERILOG_FILE src/radix4adder_new.v
	set_global_assignment -name VERILOG_FILE src/radix4adder.v
	set_global_assignment -name VERILOG_FILE src/radix2SELM.v
	set_global_assignment -name VERILOG_FILE src/radix2multiplier.v
	set_global_assignment -name VERILOG_FILE src/radix2DigitMultiply.v
	set_global_assignment -name VERILOG_FILE src/radix2calcVj.v
	set_global_assignment -name VERILOG_FILE src/radix2adderSerialBlock.v
	set_global_assignment -name VERILOG_FILE src/radix2adderSerial.v
	set_global_assignment -name VERILOG_FILE src/radix2adderParallelBlock.v
	set_global_assignment -name VERILOG_FILE src/radix2adder.v
	set_global_assignment -name VERILOG_FILE src/onTheFlyConverterSignedDigit.v
	set_global_assignment -name VERILOG_FILE src/onTheFlyConverter.v
	set_global_assignment -name QIP_FILE src/onChipRam.qip
	set_global_assignment -name VERILOG_FILE src/negateX.v
	set_global_assignment -name VERILOG_FILE src/memCopyDetector.v
	set_global_assignment -name VERILOG_FILE src/masterLevel.v
	set_global_assignment -name VERILOG_FILE src/LFSRBlock.v
	set_global_assignment -name VERILOG_FILE src/LFSR.v
	set_global_assignment -name VERILOG_FILE src/convention2rbr.v
	set_global_assignment -name VERILOG_FILE src/arbitraryRadixAdderTestbench.v
	set_global_assignment -name VERILOG_FILE src/adderPerformanceTest.v
	set_global_assignment -name VERILOG_FILE src/clockEnablePLL/synthesis/submodules/clockEnablePLL_altclkctrl_0.v
	set_global_assignment -name CDF_FILE Chain2.cdf
	set_global_assignment -name SDC_FILE SDC1.sdc
	set_global_assignment -name BDF_FILE src/top_trial.bdf
	set_global_assignment -name QIP_FILE src/pll2.qip
	set_global_assignment -name SIP_FILE src/pll2.sip
	set_global_assignment -name CDF_FILE output_files/Chain1.cdf
	set_global_assignment -name VERILOG_FILE src/masterLevelHPS.v
	set_global_assignment -name VERILOG_FILE src/avalon_MM_write_master.v
	set_global_assignment -name QIP_FILE src/pll3.qip
	set_global_assignment -name SIP_FILE src/pll3.sip
	set_global_assignment -name VERILOG_FILE src/ctr_block.v
	set_global_assignment -name VERILOG_FILE src/mem_speed_test.v
	set_global_assignment -name VERILOG_FILE src/data_gen_speed_test.v
	set_global_assignment -name PARTITION_NETLIST_TYPE SOURCE -section_id Top
	set_global_assignment -name PARTITION_FITTER_PRESERVATION_LEVEL PLACEMENT_AND_ROUTING -section_id Top
	set_global_assignment -name PARTITION_COLOR 16764057 -section_id Top
	set_global_assignment -name BOARD "Cyclone V SoC Development Kit"
	# clk_50m_fpga
	set_location_assignment PIN_AC18 -to clkin_50 -comment clk_50m_fpga
	# clk_enet_fpga_p
	set_location_assignment PIN_Y26 -to clkin_125 -comment clk_enet_fpga_p
	set_instance_assignment -name PARTITION_HIERARCHY root_partition -to | -section_id Top

	# Commit assignments
	export_assignments

	# Close project
	if {$need_to_close_project} {
		project_close
	}
}
