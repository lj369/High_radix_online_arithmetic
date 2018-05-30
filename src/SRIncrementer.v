module SRIncrementer
#(
	parameter length= 14
)

(
	clk,
	out,
	enable,
	reset
);
	
	input wire clk, enable, reset;
	
	output reg [length-1:0] out;

	initial begin
		out = {length{1'b0}};
	end

	genvar i;
	generate	
	for (i=0; i<length-1; i=i+1)
	begin : SR_autogen_block
		always @ (negedge out[i]) begin
			if (enable) out[i+1] <= ~out[i+1];
			else if (reset) out[i+1] <= 1'b0;
		end
	end
	endgenerate
	
	always @ (posedge clk) begin
		if (enable) out[0] = ~out[0];
		else if (reset) out[0] <= 1'b0;
	end
	
endmodule