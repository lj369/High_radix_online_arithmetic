
module radix4multiplierParallel
#
(
	parameter no_of_digits = 4,
	parameter radix_bits = 3,
	parameter radix = 4,
	parameter delta = 2,
	parameter full_result_sel = 1
)

(
	Xin,
	Yin,
	clk,
	out_1,
	out_2,
	extern_reset
);

	input [no_of_digits*radix_bits-1:0] Xin;
	input [no_of_digits*radix_bits-1:0] Yin;
	input clk;
	input extern_reset;
	output wire [no_of_digits*radix_bits-1:0] out_1;
	output wire [no_of_digits*radix_bits-1:0] out_2;
	wire [2*no_of_digits*radix_bits-1:0] pre_out;

	
	assign out_1 = pre_out[2*no_of_digits*radix_bits-1:no_of_digits*radix_bits];
	assign out_2 = pre_out[no_of_digits*radix_bits-1:0];
	wire [radix_bits-1:0] W;

	
	genvar i;
	
	generate
	for (i=0; i<no_of_digits; i=i+1)
	begin : mult_block
		
	end
	endgenerate
	
endmodule
	