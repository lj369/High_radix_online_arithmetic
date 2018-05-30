
module radix4multiplier
#(
	parameter no_of_digits = 4,
	parameter radix_bits = 3,
	parameter radix = 4,
	parameter delta = 2,
	parameter SD_on_input = 1
)

(
	xin,
	yin,
	clk,
	z,
	full_result_sel,
	extern_reset
);


	
	input [radix_bits-1:0] xin;
	input [radix_bits-1:0] yin;
	input clk;
	input full_result_sel;
	input extern_reset;
	output wire [radix_bits-1:0] z;
	
	reg [radix_bits-1:0] x;
	reg [radix_bits-1:0] y;
	
	
	wire [no_of_digits*radix_bits-1:0] X_j, Y_j;
	reg [no_of_digits*radix_bits-1:0] X_j_1;
	wire signed [radix_bits-1:0] p_j;
	wire signed [radix_bits-1:0] neg_p_j;
	wire [radix_bits*(no_of_digits+delta+1)-1:0] V_j;
	
	//test output
	wire [radix_bits*(no_of_digits+1)-1:0] sum_1;
	wire [(no_of_digits+1)*radix_bits-1:0] X_times_y;
	wire [(no_of_digits+1)*radix_bits-1:0] Y_times_x;
	
	reg [radix_bits*(no_of_digits+delta+1)-1:0] W_j_1;
	wire [radix_bits*(no_of_digits+delta+1)-1:0] W_j;
	wire [radix_bits*(no_of_digits+delta+1)-1:0] pre_W_j;
	reg [4:0] counter;
	reg reset;
	//wire [radix_bits-1:0] cout_from_3input_adder;

	initial
	begin
		counter = 5'd0;
		W_j_1 = 0;
		X_j_1 = 0;
		reset = 1'b1;
	end

	
	// input stage
	generate
		if (SD_on_input == 1)
		begin
		
			onTheFlyConverterSignedDigit #(no_of_digits, radix_bits) CA_X(
				.q (xin),
				.clk (clk),
				.Q (X_j),
				.reset (reset)
			);

			onTheFlyConverterSignedDigit #(no_of_digits, radix_bits) CA_Y(
				.q (yin),
				.clk (clk),
				.Q (Y_j),
				.reset (reset)
			);
			
			
			// multiply inputs
			radix4DigitMultiply #(no_of_digits, radix_bits, radix) X_time_y(
				.din1(X_j_1),
				.din2(y),
				.dout(X_times_y)
			);
	
			radix4DigitMultiply #(no_of_digits, radix_bits, radix) Y_time_x(
				.din1(Y_j),
				.din2(x),
				.dout(Y_times_x)
			);
			
			// calculate V first addition
			radix4adder_new #(no_of_digits+1,radix_bits,radix) adder_V_1(
				.din1(X_times_y),
				.din2(Y_times_x),
				.cin({radix_bits{1'b0}}),
				.dout(sum_1),
				.cout()
			);
					
		end
		
		else begin
			onTheFlyConverter  #(no_of_digits, radix_bits) (
				.q (xin),
				.clk (clk),
				.Q (X_j),
				.reset (reset)
			);
		
		
		end

	endgenerate
	


	// calculate V 2nd addition
	radix4adder_new #(no_of_digits+delta+1,radix_bits,radix) adder_V_2(
		.din1({{delta*radix_bits{1'b0}}, sum_1}),
		.din2({W_j[radix_bits*(no_of_digits+delta)-1:0],{radix_bits{1'b0}}}),
		.cin({radix_bits{1'b0}}),
		.dout(V_j),
		.cout()
	);
	
	// select p
	radix4SELM #(no_of_digits+delta+1,radix_bits,radix,delta) selm_1(
	.V_j(V_j[radix_bits*(no_of_digits+delta+1)-1:radix_bits*(no_of_digits+1)]),
	.p_j(p_j),
	.reset(reset)
	);
	
	
//	radix4calcVj #(no_of_digits, radix_bits, radix, delta) Vj_1(
//		.X_j(X_j_1),
//		.Y_j(Y_j),
//		.x_j_1(x),
//		.y_j_1(y),
//		.W_j(W_j_1),
//		.clk(clk),
//		.p_j(p_j),
//		.V_j(V_j),
//		.sum_1(sum_1),
//		.X_times_y(X_times_y),
//		.Y_times_x(Y_times_x),
//		.reset(reset)
//	);
	
	
	negateX #(1, radix_bits, radix) negate_p (
		.x_in(p_j),
		.x_out(neg_p_j)
	);
	
	radix4adder_new #(no_of_digits+delta+1,radix_bits,radix) adder_W(
		.din1(V_j),
		.din2({neg_p_j, {(no_of_digits+delta)*radix_bits{1'b0}}}),
		.cin({radix_bits{1'b0}}),
		.dout(pre_W_j),
		.cout()
	);
	

	radix4WModification #(no_of_digits, radix_bits, radix, delta) W_modification(
		.w_in(pre_W_j),
		.w_out(W_j)
	);
	
	
	
	// control 
	
	always @ (posedge clk)
	begin
		x = xin;
		y = yin;
		X_j_1 = X_j;
		W_j_1 = W_j;
		counter = counter + 1;
		
		if (reset == 1'b1)
		begin
			counter = 5'd0;
			W_j_1 = 0;
			X_j_1 = 0;
			x = 0;
			y = 0;
		end
	end

	always @ (negedge clk)
	begin 
		if (reset == 1'b1)
		begin
			reset = 1'b0;
		end
		if (extern_reset == 1'b1)
		begin
			reset = 1'b1;
		end
		if (full_result_sel == 1'b0 && counter > delta+no_of_digits)begin
			reset = 1'b1;
		end
		else if (full_result_sel == 1'b1 && counter > 2*no_of_digits+delta)begin
			reset = 1'b1;
		end
	end
	
	assign z = p_j;

endmodule

