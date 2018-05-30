// max freq: 420MHz
// max freq: after discard control 900MHz

module concatenateDout
#(
	parameter no_of_digits = 8,
	parameter radix_bits = 3,
	parameter burst_index = 8
)

(
	Dout,
	variable_clk,
	mem_in
);
	
	localparam no_of_bits = (no_of_digits+1)*radix_bits;
	
	input wire [no_of_bits-1:0] Dout;
	input wire variable_clk;
	output reg [no_of_bits*burst_index-1:0] mem_in;
	reg [3:0] counter;
	reg [no_of_bits*burst_index-1:0] pre_out;
	
	initial begin
		counter = 3'b111;
		pre_out = {no_of_bits*burst_index{1'b0}};
	end
	
// full control version
//	always @ (posedge variable_clk)	begin
//		pre_out = {pre_out[no_of_bits*(burst_index-1)-1: 0], Dout};
//		if (counter < burst_index-1) begin
//			counter = counter + 4'b1;
//		end
//		else begin
//			mem_in = pre_out;
//			counter = 3'b0;
//		end
//	end
	
	
// faster version
	always @ (posedge variable_clk)	begin
		mem_in = {mem_in[no_of_bits*(burst_index-1)-1: 0], Dout};
	end
	
	
	
endmodule
