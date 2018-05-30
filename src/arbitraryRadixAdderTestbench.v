
module arbitraryRadixAdderTestbench(
//	din1, 
//	din2, 
//	cin, 
//	dout, 
//	cout,
//	clk
	);
	
	parameter no_of_digits = 8;
	parameter radix_bits = 2;
	parameter radix = 2;
/*	
	input wire [no_of_digits*radix_bits-1:0] din1;
	input wire [no_of_digits*radix_bits-1:0] din2; 
	input wire [radix_bits-1:0] cin;
//	input wire clk;
	output wire [no_of_digits*radix_bits-1:0] dout; 
	output wire [radix_bits-1:0] cout;
*/
	reg [no_of_digits*radix_bits-1:0] din1;
	reg [no_of_digits*radix_bits-1:0] din2; 
	reg [radix_bits-1:0] cin;
	wire [no_of_digits*radix_bits-1:0] dout; 
	wire [radix_bits-1:0] cout;
	reg clk;
	
	radix4adder_new #(no_of_digits,radix_bits,radix) DUT1(
		.din1(din1), 
		.din2(din2), 
		.cin(cin), 
		.dout(dout), 
		.cout(cout)
//		.no_of_digits(8),
//		.radix_bits(3),
//		.radix(4)
	);

	integer input_file; // file handler
	integer scan_file; // file handler
	integer output_file;
	integer i;
	reg [no_of_digits*radix_bits-1:0] input_data1, input_data2;
	`define NULL 0    

	always #5 clk = ~clk;
	
	initial begin
	  input_file = $fopen("input_data.txt", "r");
		output_file = $fopen("output.txt","w");
		clk = 0;
		cin = 0;
	   if (input_file == `NULL) begin
			$display("data_file handle was NULL");
			$finish;
		end
	end

	always @(posedge clk) begin
		scan_file = $fscanf(input_file, "%b\t%b\n", input_data1, input_data2); 
		if (!$feof(input_file)) begin
			din1 = input_data1;
			din2 = input_data2;
    //use input_data as you would any other wire or reg value;
		end
	end
	
	initial begin
	for (i = 0; i<20; i=i+1) begin
		@(posedge clk);
      //data_out[i] <= dout;
		#3
      $display("%d", i);
      $display("LFSR %b %b %b", din1, din2, dout);
      $fwrite(output_file,"%b\t%b\t%b%b\n",din1, din2, cout, dout);
   end

   $fclose(output_file);  
	 $fclose(input_file);
   $finish;
	end
	
	
endmodule
