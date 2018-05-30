module radix2DigitMultiply(
	din1,
	din2,
	dout
);
	
	parameter no_of_digits = 8;
	parameter radix_bits = 2;
	parameter radix = 2;
	
	input [no_of_digits*radix_bits-1:0] din1;
	input signed [radix_bits-1:0] din2;
	output reg signed [(no_of_digits+1)*radix_bits-1:0] dout;

	wire signed [no_of_digits*radix_bits-1:0] neg_din1_pre;
	
	negateX #(no_of_digits, radix_bits, radix) negate1(
		.x_in(din1),
		.x_out(neg_din1_pre)
	);
	
	always @ (*)
	begin: always_block
		integer temp;
		temp = $signed(din2);
		case(temp)
			-1: begin
				dout = {{radix_bits{1'b0}},neg_din1_pre};
			end
			-0: begin
				dout = {{(no_of_digits+1)*radix_bits{1'b0}}};
			end
			1: begin
				dout = {{radix_bits{1'b0}},din1};
			end
			default: begin
				dout = {{(no_of_digits+1)*radix_bits{1'b0}}};
			end
		endcase
	end

endmodule

