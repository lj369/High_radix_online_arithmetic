module single_register(
	input din,
	input clk,
	output reg dout
);


	always @ (posedge clk)begin
		dout = din;
	end

endmodule
