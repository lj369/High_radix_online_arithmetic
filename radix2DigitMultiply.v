/*
module radix2DigitMultiply(
	din1,
	din2,
	dout
);
	
	parameter no_of_digits = 8;
	parameter radix_bits = 2;
	parameter radix = 2;

	wire signed [no_of_digits*radix_bits-1:0] neg_din1_pre;
	
	assign pos_one_din1 = {{radix_bits{1'b0}},din1};
	
	assign pos_four_din1 = {din1, {radix_bits{1'b0}}};
	
	negateX #(no_of_digits, radix_bits, radix) negate1(
		.x_in(din1),
		.x_out(neg_din1_pre)
	);
	
	assign neg_one_din1 = {{radix_bits{1'b0}},neg_din1_pre};
	
	assign neg_four_din1 = {neg_din1_pre, {radix_bits{1'b0}}};
	
	
	// new implementation
	reg signed [(no_of_digits+1)*radix_bits-1:0] mult_in1;
	reg signed [(no_of_digits+1)*radix_bits-1:0] mult_in2;
	
	always @ (*)
	begin: always_block
		integer temp;
		temp = $signed(din2);
		case(temp)
			-3: begin
				mult_in1 = neg_four_din1;
				mult_in2 = pos_one_din1;
			end
			-2: begin
				mult_in1 = neg_one_din1;
				mult_in2 = neg_one_din1;
			end
			-1: begin
				mult_in1 = {(no_of_digits+1)*radix_bits{1'b0}};
				mult_in2 = neg_one_din1;
			end
			-0: begin
				mult_in1 = {(no_of_digits+1)*radix_bits{1'b0}};
				mult_in2 = {(no_of_digits+1)*radix_bits{1'b0}};
			end
			1: begin
				mult_in1 = {(no_of_digits+1)*radix_bits{1'b0}};
				mult_in2 = pos_one_din1;
			end
			2: begin
				mult_in1 = pos_one_din1;
				mult_in2 = pos_one_din1;
			end
			3: begin
				mult_in1 = pos_four_din1;
				mult_in2 = neg_one_din1;
			end
			default: begin
				mult_in1 = 0;
				mult_in2 = 0;
			end
		endcase
	end
		
	radix4adder_new #(no_of_digits+1,radix_bits,radix) adder_pos_two(
		.din1(mult_in1),
		.din2(mult_in2),
		.cin({radix_bits{1'b0}}),
		.dout(dout),
		.cout()
	);

endmodule
*/
