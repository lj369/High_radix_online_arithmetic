module adderPerformanceTest(
	input_1,
	input_2,
	cin,
	output_1_reg,
	cout_reg,
	clk
);

	parameter no_of_digits = 8;
	parameter radix_bits = 3;
	parameter radix = 4;
	parameter online_adder = 1;

	input [no_of_digits*radix_bits-1:0] input_1; 
	input [no_of_digits*radix_bits-1:0] input_2;
	input [radix_bits-1:0] cin;
	output reg [no_of_digits*radix_bits-1:0] output_1_reg; 
	output reg [radix_bits-1:0] cout_reg;
	
	input clk;
	
	
	reg [no_of_digits*radix_bits-1:0] input_1_reg; 
	reg [no_of_digits*radix_bits-1:0] input_2_reg;
	reg [radix_bits-1:0] cin_reg;
	wire [no_of_digits*radix_bits-1:0] output_1; 
	wire [radix_bits-1:0] cout;

	
	always @ (posedge clk) begin
		input_1_reg = input_1;
		input_2_reg = input_2;
		cin_reg = cin;
		output_1_reg = output_1;
		cout_reg = cout;
	end
	
	generate
		if(online_adder == 1)
			radix4adder_new #(no_of_digits,radix_bits,radix) adder_1(
				.din1(input_1_reg),
				.din2(input_2_reg),
				.cin(cin_reg),
				.dout(output_1),
				.cout(cout)
			);
		else
			traditional_adder #(no_of_digits*(radix_bits-1),radix_bits,radix) adder_2(
				.cin(cin_reg),
				.dataa(input_1_reg),
				.datab(input_2_reg),
				.cout(cout),
				.result(output_1)
			);
	endgenerate

endmodule