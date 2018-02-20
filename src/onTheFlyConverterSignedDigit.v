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
	reg [no_of_digits*radix_bits-1:0] Q_pre;
	output reg [no_of_digits*radix_bits-1:0] Q;
	integer counter;
	
	initial begin
		Q_pre = 0;
		counter = no_of_digits;
	end
		
	always @ (posedge clk)
	begin
		if (counter > 0) begin
			Q_pre = {Q_pre[radix_bits*(no_of_digits-1)-1:0],q};
			counter = counter - 1;
			Q = Q_pre << counter*radix_bits;
		end
		if (reset == 1'b1)begin
			Q_pre = 0;
			Q = 0;
			counter = no_of_digits;
		end
	end
	
endmodule
	