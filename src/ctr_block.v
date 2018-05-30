// max freq: 357MHz

module ctr_block
#(
	parameter address_width = 14,
	parameter max_ram_address = 16384,
	parameter burst_index = 8
)

(
	UserPushButton1,
	variable_clk_2,
	enable,
	enable_2,
	reset,
	start_signal,
	transfer_done
);

	input wire UserPushButton1;
	input wire transfer_done;
	input wire variable_clk_2;
	reg [address_width-1:0] counter;
	output reg enable;
	output reg enable_2;
	output reg reset;
	output reg start_signal;
	
	
	initial begin
		counter = {address_width{1'b0}};
		enable = 1'b0;
		reset = 1'b0;
//		pll_rst = 1'b0;
		enable_2 = 1'b0;
//		enable_3 = 1'b0;
		start_signal <= 1'b1;
	end

	
	always @ (posedge variable_clk_2)
	begin : ctrl_block
		if (UserPushButton1) begin
			start_signal <= 1'b0;
		end
		if (start_signal == 1'b0) begin
			if (enable) begin
				enable_2 = 1'b1;
			end
			else begin
				enable_2 = 1'b0;
			end
			if (reset == 1'b1) begin
				reset = 1'b0;
			end
			if (transfer_done) begin
				counter = {address_width{1'b0}};
				reset = 1'b1;
			end
			if (counter < max_ram_address-2) begin
				counter = counter + {{(address_width-1){1'b0}}, 1'b1};
				enable = 1'b1;
			end
			else begin
				enable = 1'b0;
			end
		end
	end

	
endmodule
