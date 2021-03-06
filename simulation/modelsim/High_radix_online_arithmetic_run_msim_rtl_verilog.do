transcript on
if ![file isdirectory High_radix_online_arithmetic_iputf_libs] {
	file mkdir High_radix_online_arithmetic_iputf_libs
}

if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

###### Libraries for IPUTF cores 
###### End libraries for IPUTF cores 
###### MIF file copy and HDL compilation commands for IPUTF cores 


vlog "C:/Users/J_Lian/Desktop/FYP/src/pll2_sim/pll2.vo"
vlog "C:/Users/J_Lian/Desktop/FYP/src/pll3_sim/pll3.vo"

vlog -vlog01compat -work work +incdir+C:/Users/J_Lian/Desktop/FYP/src {C:/Users/J_Lian/Desktop/FYP/src/pll3.vo}
vlib pll3
vmap pll3 pll3
vlog -vlog01compat -work pll3 +incdir+C:/Users/J_Lian/Desktop/FYP/src {C:/Users/J_Lian/Desktop/FYP/src/pll3.v}
vlog -vlog01compat -work work +incdir+C:/Users/J_Lian/Desktop/FYP/src {C:/Users/J_Lian/Desktop/FYP/src/concatenateDout.v}
vlog -vlog01compat -work work +incdir+C:/Users/J_Lian/Desktop/FYP/src/clockEnablePLL/synthesis {C:/Users/J_Lian/Desktop/FYP/src/clockEnablePLL/synthesis/clockEnablePLL.v}
vlog -vlog01compat -work work +incdir+C:/Users/J_Lian/Desktop/FYP/src {C:/Users/J_Lian/Desktop/FYP/src/ramAddress.v}
vlog -vlog01compat -work work +incdir+C:/Users/J_Lian/Desktop/FYP/src {C:/Users/J_Lian/Desktop/FYP/src/radix4adder_new.v}
vlog -vlog01compat -work work +incdir+C:/Users/J_Lian/Desktop/FYP/src {C:/Users/J_Lian/Desktop/FYP/src/onChipRam.v}
vlog -vlog01compat -work work +incdir+C:/Users/J_Lian/Desktop/FYP/src {C:/Users/J_Lian/Desktop/FYP/src/memCopyDetector.v}
vlog -vlog01compat -work work +incdir+C:/Users/J_Lian/Desktop/FYP/src {C:/Users/J_Lian/Desktop/FYP/src/masterLevel.v}
vlog -vlog01compat -work work +incdir+C:/Users/J_Lian/Desktop/FYP/src {C:/Users/J_Lian/Desktop/FYP/src/LFSRBlock.v}
vlog -vlog01compat -work work +incdir+C:/Users/J_Lian/Desktop/FYP/src/clockEnablePLL/synthesis/submodules {C:/Users/J_Lian/Desktop/FYP/src/clockEnablePLL/synthesis/submodules/clockEnablePLL_altclkctrl_0.v}
vlog -vlog01compat -work work +incdir+C:/Users/J_Lian/Desktop/FYP/src {C:/Users/J_Lian/Desktop/FYP/src/avalon_MM_write_master.v}
vlog -vlog01compat -work work +incdir+C:/Users/J_Lian/Desktop/FYP/src {C:/Users/J_Lian/Desktop/FYP/src/ctr_block.v}
vlog -vlog01compat -work work +incdir+C:/Users/J_Lian/Desktop/FYP/src {C:/Users/J_Lian/Desktop/FYP/src/top_module.v}
vlog -vlog01compat -work work +incdir+C:/Users/J_Lian/Desktop/FYP/src {C:/Users/J_Lian/Desktop/FYP/src/LFSR.v}
vlog -vlog01compat -work pll3 +incdir+C:/Users/J_Lian/Desktop/FYP/src/pll3 {C:/Users/J_Lian/Desktop/FYP/src/pll3/pll3_0002.v}

