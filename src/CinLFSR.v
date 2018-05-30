// max freq: 560MHz
// max freq: 613MHz

module CinLFSR

#(
	// Parameter Declarations
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

	
	input clk;
	input reset;
//	input enable;

	// Output Ports
	output reg [radix_bits-1:0] out;
	
	wire [radix_bits-1:0] pre_out;
	wire	[LFSR_SIZE-1:0] LFSROut [radix_bits-1:0];

	genvar i;
	generate
		for (i=0; i<2; i=i+1)
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
		
			if (i % radix_bits == radix_bits-1)
			begin
				always @ (posedge clk) begin : output_mask
					if (pre_out [1:0] == 2'b11) begin
						out= {radix_bits{1'b1}};
					end else if (pre_out [1:0] == 2'b01) begin
						out= {{(radix_bits-1){1'b0}},{1'b1}};
					end else begin
						out = {radix_bits{1'b0}};
					end
				end
			end
		end
	endgenerate
	

endmodule
