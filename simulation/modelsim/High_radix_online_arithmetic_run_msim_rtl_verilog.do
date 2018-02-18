transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+//icnas4.cc.ic.ac.uk/jl14314/Desktop/proj {//icnas4.cc.ic.ac.uk/jl14314/Desktop/proj/radix4multiplier.v}
vlog -vlog01compat -work work +incdir+//icnas4.cc.ic.ac.uk/jl14314/Desktop/proj {//icnas4.cc.ic.ac.uk/jl14314/Desktop/proj/radix4adder_new.v}
vlog -vlog01compat -work work +incdir+//icnas4.cc.ic.ac.uk/jl14314/Desktop/proj {//icnas4.cc.ic.ac.uk/jl14314/Desktop/proj/onTheFlyConverterSignedDigit.v}

