// max freq 382MHz

module ramAddress
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

	always @ (posedge clk)
	begin
		if (enable) begin
			ram_addr = ram_addr + 14'b1;
		end
		else begin
			ram_addr = 14'd16383;
		end
		if (reset) begin
			ram_addr = {address_width{1'b0}};
		end
	end

endmodule