add wave doutp
add wave doutn
add wave din1p
add wave din1n
add wave din2p
add wave din2n
#add wave cout
add wave clk
add wave start
add wave finish
#add wave cin
#add wave fa1c
#add wave fa1s
#add wave fa2c
#add wave fa2s
force clk 0 0, 1 10ns -repeat 20ns
force din1n 0 1ps 
force din1p 0 
force din2p 0 0
force din2n 0 1ps
force start 1 10ns, 0 30ns
#force cin 0 0
#run 100ns
