module onTheFlyConverterSignedDigit(
	q,
	clk,
	reset,
	Q
);
	parameter no_of_digits = 4;
	parameter radix_bits = 3;
	
	input signed [radix_bits-1:0] q;
	input clk;
	input reset;
	output reg [no_of_digits*radix_bits-1:0] Q;
	
	initial begin
		Q = 0;
	end
		
	always @ (posedge clk)
	begin
		if (reset == 1'b1)begin
			Q = 0;
		end else begin
		Q = {Q[radix_bits*(no_of_digits-1)-1:0],q};
		end
	end
	
endmodule
	