// max freq: 900MHz

module memCopyDetector

#(
	parameter no_of_mem_bits = 2
)

(
	data_in,
	enable,
	clk,
	transfer_done
);

	input [no_of_mem_bits - 1:0] data_in;
	input enable;
	input clk;
	output reg transfer_done;
	
	reg [1:0] state;
	
	
	initial begin
		state = 2'b0;
	end
	
	always @ (posedge clk)
	begin
		if (enable) begin
			state = 2'b0;
			transfer_done = 1'b0;
		end
		else begin
			case(state)
				0: if (data_in == {no_of_mem_bits{1'b1}}) begin
						state = 2'd1;
						transfer_done = 1'b0;
					end else begin state = 2'd0; transfer_done = 1'b0; end
				1: if (data_in == {no_of_mem_bits{1'b0}}) begin
						state = 2'd2;
						transfer_done = 1'b0;
					end else begin state = 2'd1; transfer_done = 1'b0; end
				2: if (data_in == {no_of_mem_bits{1'b1}}) begin
						state = 2'd3;
						transfer_done = 1'b0;
					end else begin state = 2'd2; transfer_done = 1'b0; end
				3: if (data_in == {no_of_mem_bits{1'b0}}) begin
						state = 2'd3;
						transfer_done = 1'b1;
					end else begin state = 2'd3; transfer_done = 1'b0; end
				default: begin
					state = 2'b0; transfer_done = 1'b0;
				end
			endcase
		end
	end
	
endmodule