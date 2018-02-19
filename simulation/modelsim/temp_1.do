add wave -position insertpoint  \
sim:/radix4multiplier/z \
sim:/radix4multiplier/y \
sim:/radix4multiplier/x \
sim:/radix4multiplier/clk \
sim:/radix4multiplier/W_j \
sim:/radix4multiplier/V_j \
sim:/radix4multiplier/reset \
sim:/radix4multiplier/full_result_sel \
sim:/radix4multiplier/extern_reset
force -freeze sim:/radix4multiplier/extern_reset 1 0, 0 100
force -freeze sim:/radix4multiplier/y 000 0, 000 200, 110 300, 010 400, 010 500, 000 600
force -freeze sim:/radix4multiplier/x 000 0, 000 200, 110 300, 010 400, 010 500, 000 600
#force -freeze sim:/radix4multiplier/x 000 0, 011 300, 000 400 
force -freeze sim:/radix4multiplier/clk 1 0, 0 {50 ps} -r 100
force -freeze sim:/radix4multiplier/full_result_sel 1 0
add wave -position insertpoint  \
sim:/radix4multiplier/Y_j \
sim:/radix4multiplier/X_j
add wave -position insertpoint  \
sim:/radix4multiplier/W_j_1 \
sim:/radix4multiplier/p_j 

#force -freeze sim:/radix4multiplier/reset 1 0, 0 50
