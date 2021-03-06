
module radix2calcVj(
	X_j,
	Y_j,
	x_j_1,
	y_j_1,
	W_j,
	clk,
	p_j,
	V_j,
	//sum_1,
	//X_times_y,
	//Y_times_x
	reset
);
	parameter no_of_digits = 4;
	parameter radix_bits = 2;
	parameter radix = 2;
	parameter delta = 3;
	
	input [no_of_digits*radix_bits-1:0] X_j;
	input [no_of_digits*radix_bits-1:0] Y_j;
	input signed [radix_bits-1:0] x_j_1;
	input signed [radix_bits-1:0] y_j_1;
	wire [(no_of_digits+1)*radix_bits-1:0] X_times_y;
	wire [(no_of_digits+1)*radix_bits-1:0] Y_times_x;
	//output wire [(no_of_digits+1)*radix_bits-1:0] X_times_y;
	//output wire [(no_of_digits+1)*radix_bits-1:0] Y_times_x;
	input [radix_bits*(no_of_digits+delta+1)-1:0] W_j;
	input clk;
	input reset;
	output wire signed [radix_bits-1:0] p_j;
	output wire [radix_bits*(no_of_digits+delta+1)-1:0] V_j;
	
	wire signed [radix_bits*(no_of_digits+1)-1:0] sum_1;
	//output wire signed [radix_bits*(no_of_digits+1)-1:0] sum_1;
	//wire [radix_bits-1:0] cout_from_3input_adder;
	
	
	
	radix2DigitMultiply #(no_of_digits, radix_bits, radix) X_time_y(
		.din1(X_j),
		.din2(y_j_1),
		.dout(X_times_y)
	);
	
	radix2DigitMultiply #(no_of_digits, radix_bits, radix) Y_time_x(
		.din1(Y_j),
		.din2(x_j_1),
		.dout(Y_times_x)
	);
	
	
	radix4adder_new #(no_of_digits+1,radix_bits,radix) adder_1(
		.din1(X_times_y),
		.din2(Y_times_x),
		.cin({radix_bits{1'b0}}),
//		.dout(sum_1[no_of_digits*radix_bits-1:0]),
//		.cout(sum_1[(no_of_digits+1)*radix_bits-1:no_of_digits*radix_bits])
		.dout(sum_1),
		.cout()
	); // online or not? -- use online for now

	radix4adder_new #(no_of_digits+delta+1,radix_bits,radix) adder_2(
		.din1({{delta*radix_bits{1'b0}}, sum_1}),
		.din2({W_j[radix_bits*(no_of_digits+delta)-1:0],{radix_bits{1'b0}}}),
		.cin({radix_bits{1'b0}}),
		.dout(V_j),
		.cout()
	);
	
	radix2SELM #(no_of_digits+delta+1,radix_bits,radix,delta) selm_1(
	.V_j(V_j[radix_bits*(no_of_digits+delta+1)-1:radix_bits*(no_of_digits+1)]),
	.p_j(p_j),
	.reset(reset)
	);
	



endmodule
