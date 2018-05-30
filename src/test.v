module test(din1, din2, cin, dout, cout, clk);

	parameter no_of_digits = 4;
	parameter radix_bits = 4;
	parameter radix = 8;
	
	output reg signed [radix_bits-1:0] cout;
	output reg signed [no_of_digits*radix_bits-1:0] dout;
	input signed [no_of_digits*radix_bits-1:0] din1, din2;
	input [radix_bits-1:0] cin;
	input clk;
	reg signed [no_of_digits*radix_bits-1:0] din1_r, din2_r;
	reg [radix_bits-1:0] cin_r;
	wire [no_of_digits*radix_bits-1:0] dout_pre;
	wire signed [radix_bits-1:0] cout_pre;
	
	always @ (posedge clk)begin
		din1_r = din1;
		din2_r = din2;
		cin_r = cin;
		cout = cout_pre;
		dout = dout_pre;
	end
	
	radix4adder_new T1 (din1_r, din2_r, cin_r, dout_pre, cout_pre);


endmodule
