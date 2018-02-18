transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -sv -work work +incdir+D:/studies/FYP/Quaterus2_project {D:/studies/FYP/Quaterus2_project/radix4adder_sv.sv}

