// max freq: 560MHz
// max freq: 613MHz

module LFSRBlock_test

#(
	// Parameter Declarations
	parameter no_of_digits = 8,
	parameter LFSR_SIZE = 32,
	parameter INIT_OFFSET = 0,
	parameter radix_bits = 3
)

(
	// Input Ports
	clk,
//	enable,
	reset,
	out
);

	localparam NUM_BITS = no_of_digits * radix_bits;
	
	input clk;
	input reset;
//	input enable;

	// Output Ports
	output wire [LFSR_SIZE-1:0] out;
	
	wire [NUM_BITS-1:0] pre_out;
	wire	[LFSR_SIZE-1:0] LFSROut [NUM_BITS-1:0];

	genvar i;
	generate
		for (i=0; i<NUM_BITS; i=i+1)
		begin: LFSRinst
			LFSR
			#(.WIDTH(LFSR_SIZE),.PRESET(i+1+INIT_OFFSET)) LSFRA 
			(
				.clk(clk),
//				,enable(enable),
				.reset(reset),
				.out(LFSROut[i])
			);
			assign pre_out[i] = LFSROut[i][0];
		end
	endgenerate

	assign out = LFSROut[47];


endmodule
