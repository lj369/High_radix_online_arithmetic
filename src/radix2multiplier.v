/*
module radix2multiplier(
	x,
	y,
	clk,
	z
	);

	parameter no_of_digits = 4;
	parameter radix_bits = 3;
	parameter radix = 4;
	parameter delta = 2;
	
	input [radix_bits-1:0] x;
	input [radix_bits-1:0] y;
	input clk;
	output wire [radix_bits-1:0] z;
	
	wire [no_of_digits*radix_bits-1:0] X_j, Y_j;
	reg [no_of_digits*radix_bits-1:0] X_j_1;
	wire signed [radix_bits-1:0] p_j;
	wire [radix_bits*(no_of_digits+1)-1:0] V_j;
	reg [radix_bits*(no_of_digits)-1:0] W_j_1;
	wire [radix_bits*(no_of_digits)-1:0] W_j;
	reg [3:0] counter;
	reg reset;
	wire [radix_bits-1:0] cout_from_3input_adder;

	initial
	begin
		counter = 4'd0;
		W_j_1 = 0;
		X_j_1 = 0;
		reset = 1'b0;
	end
	

	onTheFlyConverterSignedDigit #(no_of_digits, radix_bits) CA_X(
		.q (x),
		.clk (clk),
		.Q (X_j),
		.reset (reset)
	);

	onTheFlyConverterSignedDigit #(no_of_digits, radix_bits) CA_Y(
		.q (y),
		.clk (clk),
		.Q (Y_j),
		.reset (reset)
	);

	
	calcVj #(no_of_digits, radix_bits, radix, delta) Vj_1(
		.X_j(X_j_1),
		.Y_j(Y_j),
		.x_j_1(x),
		.y_j_1(y),
		.W_j(W_j_1),
		.clk(clk),
		.p_j(p_j),
		.V_j(V_j),
		.reset(reset)
	);
	
	radix4adder_new #(no_of_digits+1,radix_bits,radix) adder_2(
		.din1(V_j),
		.din2({p_j, {no_of_digits*radix_bits{1'b0}}}),
		.cin(2'b0),
		.dout(W_j),
		.cout(cout_from_3input_adder)
	);
	
	
	always @ (posedge clk)
	begin
		X_j_1 = X_j;
		W_j_1 = W_j;
		counter = counter + 1;
		
		if (reset == 1'b1)
		begin
			counter = 4'd0;
			W_j_1 = 0;
			X_j_1 = 0;
			reset = 1'b0;
		end
		
		if (counter > delta+no_of_digits)
		begin
			reset = 1'b1;
		end

	end

	assign z = p_j;

endmodule

module calcVj(
	X_j,
	Y_j,
	x_j_1,
	y_j_1,
	W_j,
	clk,
	p_j,
	V_j,
	reset
);
	parameter no_of_digits = 4;
	parameter radix_bits = 3;
	parameter radix = 4;
	parameter delta = 2;
	
	input [no_of_digits*radix_bits-1:0] X_j;
	input [no_of_digits*radix_bits-1:0] Y_j;
	input signed [radix_bits-1:0] x_j_1;
	input signed [radix_bits-1:0] y_j_1;
	wire [(no_of_digits+1)*radix_bits-1:0] X_times_y;
	wire [(no_of_digits+1)*radix_bits-1:0] Y_times_x;
	input [radix_bits*(no_of_digits)-1:0] W_j;
	input clk;
	input reset;
	output wire signed [radix_bits-1:0] p_j;
	output wire [radix_bits*(no_of_digits+1)-1:0] V_j;
	
	wire signed [radix_bits*(no_of_digits+1)-1:0] sum_1;
	wire [radix_bits-1:0] cout_from_3input_adder;
	
	
	
	multiplyByFour #(no_of_digits, radix_bits, radix) X_time_y(
		.din1(X_j),
		.din2(y_j_1),
		.dout(X_times_y)
	);
	
	multiplyByFour #(no_of_digits, radix_bits, radix) Y_time_x(
		.din1(Y_j),
		.din2(x_j_1),
		.dout(Y_times_x)
	);
	
	
	radix4adder_new #(no_of_digits,radix_bits,radix) adder_1(
		.din1(X_times_y),
		.din2(Y_times_x),
		.cin(3'b0),
		.dout(sum_1[no_of_digits*radix_bits-1:0]),
		.cout(sum_1[(no_of_digits+1)*radix_bits-1:no_of_digits*radix_bits])
	); // online or not? -- use online for now

	radix4adder_new #(no_of_digits+1,radix_bits,radix) adder_2(
		.din1(sum_1),
		.din2({W_j,{radix_bits{1'b0}}}),
		.cin(3'b0),
		.dout(V_j),
		.cout(cout_from_3input_adder)
	);
	
	SELM #(no_of_digits,radix_bits,radix,delta) selm_1(
	.V_j(V_j[radix_bits*(no_of_digits+1)-1:radix_bits*(no_of_digits+1-delta)]),
	.p_j(p_j),
	.reset(reset)
	);
	



endmodule

module SELM(
	V_j,
	p_j,
	reset
);
	parameter no_of_digits = 4;
	parameter radix_bits = 3;
	parameter radix = 4;
	parameter delta = 2;

	input [radix_bits*(no_of_digits+1)-1:radix_bits*(no_of_digits+1-delta)] V_j;
	input wire reset;
	output reg signed [radix_bits-1:0] p_j;
	
	always @ * begin : alway_block
		if (reset == 1'b1)begin
			p_j = 3'b000;
		end
		else begin : case_block
			integer temp_1, temp_2;
			temp_1 = $signed(V_j[radix_bits*(no_of_digits+1)-1:radix_bits*(no_of_digits)]);
			temp_2 = $signed(V_j[radix_bits*(no_of_digits)-1:radix_bits*(no_of_digits-1)]);
			case(temp_1)
				3:begin
					if (temp_2>=-1)begin
						p_j = 3'b011;
					end
					else begin
						p_j = 3'b010;
					end
				end
				2:begin
					if (temp_2==3)begin
						p_j = 3'b011;
					end
					else if (temp_2<-1) begin
						p_j = 3'b001;
					end
					else begin
						p_j = 3'b010;
					end
				end
				1:begin
					if (temp_2==3)begin
						p_j = 3'b010;
					end
					else if (temp_2<-1) begin
						p_j = 3'b000;
					end
					else begin
						p_j = 3'b001;
					end
				end
				0:begin
					if (temp_2==3)begin
						p_j = 3'b001;
					end
					else if (temp_2<-1) begin
						p_j = 3'b111;
					end
					else begin
						p_j = 3'b000;
					end
				end
				-1:begin
					if (temp_2==3)begin
						p_j = 3'b000;
					end
					else if (temp_2<-1) begin
						p_j = 3'b110;
					end
					else begin
						p_j = 3'b111;
					end
				end
				-2:begin
					if (temp_2==3)begin
						p_j = 3'b111;
					end
					else if (temp_2<-1) begin
						p_j = 3'b101;
					end
					else begin
						p_j = 3'b110;
					end
				end
				-3:begin
					if (temp_2==3)begin
						p_j = 3'b110;
					end
					else begin
						p_j = 3'b101;
					end
				end
				default: p_j = 0;
			endcase
		end
	end
	
endmodule


module multiplyByFour(
	din1,
	din2,
	dout
);
	
	parameter no_of_digits = 4;
	parameter radix_bits = 3;
	parameter radix = 4;
	
	input [no_of_digits*radix_bits-1:0] din1;
	input signed [radix_bits-1:0] din2;
	output reg [(no_of_digits+1)*radix_bits-1:0] dout;
	
	wire signed [no_of_digits*radix_bits-1:0] neg_din1_pre;
	wire signed [(no_of_digits+1)*radix_bits-1:0] pos_one_din1;
	wire signed [(no_of_digits+1)*radix_bits-1:0] neg_one_din1;
	wire signed [(no_of_digits+1)*radix_bits-1:0] pos_four_din1;
	wire signed [(no_of_digits+1)*radix_bits-1:0] neg_four_din1;
	
	
	assign pos_one_din1 = {{radix_bits{1'b0}},din1};
	
	assign pos_four_din1 = {din1, {radix_bits{1'b0}}};
	
	negateX #(no_of_digits, radix_bits, radix) negate1(
		.x_in(din1),
		.x_out(neg_din1_pre)
	);
	
	assign neg_one_din1 = {{radix_bits{1'b0}},neg_din1_pre};
	
	assign neg_four_din1 = {neg_din1_pre, {radix_bits{1'b0}}};
	
	wire signed [(no_of_digits+1)*radix_bits-1:0] pos_two_din1;
	wire signed [(no_of_digits+1)*radix_bits-1:0] neg_two_din1;
	wire signed [(no_of_digits+1)*radix_bits-1:0] pos_three_din1;
	wire signed [(no_of_digits+1)*radix_bits-1:0] neg_three_din1;	
	
	radix4adder_new #(no_of_digits+1,radix_bits,radix) adder_pos_two(
		.din1(pos_one_din1),
		.din2(pos_one_din1),
		.cin(3'b0),
		.dout(pos_two_din1),
		.cout()
	);
	
	radix4adder_new #(no_of_digits+1,radix_bits,radix) adder_pos_three(
		.din1(pos_four_din1),
		.din2(neg_one_din1),
		.cin(3'b0),
		.dout(pos_three_din1),
		.cout()
	);
	
	radix4adder_new #(no_of_digits+1,radix_bits,radix) adder_neg_two(
		.din1(neg_one_din1),
		.din2(neg_one_din1),
		.cin(3'b0),
		.dout(neg_two_din1),
		.cout()
	);
	
	radix4adder_new #(no_of_digits+1,radix_bits,radix) adder_neg_three(
		.din1(neg_four_din1),
		.din2(pos_one_din1),
		.cin(3'b0),
		.dout(neg_three_din1),
		.cout()
	);
	
	always @ * begin: alway_block
		integer temp;
		temp = $signed(din2);
		case(temp)
			-3: dout = neg_three_din1;
			-2: dout = neg_two_din1;
			-1: dout = neg_one_din1;
			0: dout = 0;
			1: dout = pos_one_din1;
			2: dout = pos_two_din1;
			3: dout = pos_three_din1;
			default: dout = 0;
		endcase
	end

endmodule

module negateX(
	x_in,
	x_out
);

	parameter no_of_digits = 4;
	parameter radix_bits = 3;
	parameter radix = 4;
	
	input [no_of_digits*radix_bits-1:0] x_in;
	output reg [no_of_digits*radix_bits-1:0] x_out;
	
	genvar i;
	
	generate
	for (i=0; i<no_of_digits; i=i+1)
	begin : loop_gen_block_1
		always @ (x_in)
		begin : alway_block
			integer temp;
			temp = $signed(x_in[(i+1)*radix_bits-1:i*radix_bits]);
			x_out[(i+1)*radix_bits-1:i*radix_bits] = -temp;
		end
	end
	endgenerate
	
endmodule
	
*/