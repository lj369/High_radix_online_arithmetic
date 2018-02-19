add wave -position insertpoint  \
sim:/radix2multiplier/z \
sim:/radix2multiplier/y \
sim:/radix2multiplier/x \
sim:/radix2multiplier/clk \
sim:/radix2multiplier/W_j \
sim:/radix2multiplier/V_j \
sim:/radix2multiplier/reset \
sim:/radix2multiplier/full_result_sel \
sim:/radix2multiplier/extern_reset \
sim:/radix2multiplier/counter
force -freeze sim:/radix2multiplier/extern_reset 1 0, 0 100
force -freeze sim:/radix2multiplier/y 00 0, 00 200, 11 300, 01 400, 11 500, 000 600
force -freeze sim:/radix2multiplier/x 00 0, 00 200, 11 300, 01 400, 11 500, 000 600
#force -freeze sim:/radix2multiplier/x 000 0, 011 300, 000 400 
force -freeze sim:/radix2multiplier/clk 1 0, 0 {50 ps} -r 100
force -freeze sim:/radix2multiplier/full_result_sel 1 0
add wave -position insertpoint  \
sim:/radix2multiplier/Y_j \
sim:/radix2multiplier/X_j
add wave -position insertpoint  \
sim:/radix2multiplier/W_j_1 \
sim:/radix2multiplier/p_j 

#force -freeze sim:/radix2multiplier/reset 1 0, 0 50
