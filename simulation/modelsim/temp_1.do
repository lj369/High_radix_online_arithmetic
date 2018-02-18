add wave -position insertpoint  \
sim:/radix4multiplier/z \
sim:/radix4multiplier/y \
sim:/radix4multiplier/x \
sim:/radix4multiplier/clk \
sim:/radix4multiplier/W_j \
sim:/radix4multiplier/V_j \
sim:/radix4multiplier/reset
force -freeze sim:/radix4multiplier/y 000 0, 000 100, 000 200, 000 300, 011 400, 000 500
force -freeze sim:/radix4multiplier/x 000 0, 011 100, 111 200, 101 300, 010 400, 000 500
#force -freeze sim:/radix4multiplier/x 000 0, 011 300, 000 400 
force -freeze sim:/radix4multiplier/clk 1 0, 0 {50 ps} -r 100
add wave -position insertpoint  \
sim:/radix4multiplier/Y_j \
sim:/radix4multiplier/X_j
add wave -position insertpoint  \
sim:/radix4multiplier/W_j_1 \
sim:/radix4multiplier/p_j

force -freeze sim:/radix4multiplier/reset 1 0, 0 50
