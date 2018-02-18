transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+//icnas4.cc.ic.ac.uk/jl14314/Desktop/proj/src {//icnas4.cc.ic.ac.uk/jl14314/Desktop/proj/src/radix4SELM.v}
vlog -vlog01compat -work work +incdir+//icnas4.cc.ic.ac.uk/jl14314/Desktop/proj/src {//icnas4.cc.ic.ac.uk/jl14314/Desktop/proj/src/radix4DigitMultiply.v}
vlog -vlog01compat -work work +incdir+//icnas4.cc.ic.ac.uk/jl14314/Desktop/proj/src {//icnas4.cc.ic.ac.uk/jl14314/Desktop/proj/src/radix4calcVj.v}
vlog -vlog01compat -work work +incdir+//icnas4.cc.ic.ac.uk/jl14314/Desktop/proj/src {//icnas4.cc.ic.ac.uk/jl14314/Desktop/proj/src/radix4multiplier.v}
vlog -vlog01compat -work work +incdir+//icnas4.cc.ic.ac.uk/jl14314/Desktop/proj/src {//icnas4.cc.ic.ac.uk/jl14314/Desktop/proj/src/radix4adder_new.v}
vlog -vlog01compat -work work +incdir+//icnas4.cc.ic.ac.uk/jl14314/Desktop/proj/src {//icnas4.cc.ic.ac.uk/jl14314/Desktop/proj/src/onTheFlyConverterSignedDigit.v}
vlog -vlog01compat -work work +incdir+//icnas4.cc.ic.ac.uk/jl14314/Desktop/proj/src {//icnas4.cc.ic.ac.uk/jl14314/Desktop/proj/src/negateX.v}
vlog -vlog01compat -work work +incdir+//icnas4.cc.ic.ac.uk/jl14314/Desktop/proj/src {//icnas4.cc.ic.ac.uk/jl14314/Desktop/proj/src/radix4WModification.v}
