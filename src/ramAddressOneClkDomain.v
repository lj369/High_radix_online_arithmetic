// max freq 382MHz

module ramAddressOneClkDomain
#(
	parameter address_width = 14,
	parameter max_ram_address = 16384,
	parameter burst_index = 8
)

(
	clk,
	ram_addr,
	enable,
	reset
);
	
	input wire clk, enable, reset;
	
	output reg [address_width-1:0] ram_addr;

	initial begin
		ram_addr = {address_width{1'b0}};
	end

	genvar i;
	generate	
	for (i=0; i<address_width-1; i=i+1)
	begin : SR_gen_block_1
		always @ (negedge ram_addr[i]) begin
			if (enable) ram_addr[i+1] <= ~ram_addr[i+1];
			else if (reset) ram_addr[i+1] <= 1'b0;
		end
	end
	endgenerate
	
	always @ (posedge clk) begin
		if (enable) ram_addr[0] = ~ram_addr[0];
		else if (reset) ram_addr[0] <= 1'b0;
	end
	
endmodule