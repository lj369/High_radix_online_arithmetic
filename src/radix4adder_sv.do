add wave dout
add wave din1
add wave din2
add wave cin
add wave sum
add wave w
add wave t
add wave z

force {din1[7]} 3'b000
force {din1[6]} 3'b000
force {din1[5]} 3'd1
force {din1[4]} 3'd2
force {din1[3]} 3'd7
force {din1[2]} 3'd3
force {din1[1]} 3'd0
force {din1[0]} 3'd5

force {din2[7]} 3'b000
force {din2[6]} 3'b000
force {din2[5]} 3'd2
force {din2[4]} 3'd5
force {din2[3]} 3'd7
force {din2[2]} 3'd3
force {din2[1]} 3'd2
force {din2[0]} 3'd2

force cin 0

run 1ns