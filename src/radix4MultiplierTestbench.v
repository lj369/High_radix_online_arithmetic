
module radix4MultiplierTestbench(
//	din1, 
//	din2, 
//	cin, 
//	dout, 
//	cout,
//	clk
	);
	
	parameter no_of_digits = 4;
	parameter radix_bits = 3;
	parameter radix = 4;
	parameter delta = 2;


	reg [no_of_digits*radix_bits-1:0] din1;
	reg [no_of_digits*radix_bits-1:0] din2; 
	reg [no_of_digits*radix_bits-1:0] dout; 
	reg clk;
	integer counter;
	reg [2:0] x;
	reg [2:0] y;
	wire [2:0] z;
	
	always @ (posedge clk)
	begin
		if (counter<no_of_digits)
		// load input to SR
		begin
			x = din1[no_of_digits*radix_bits-1:(no_of_digits-1)*radix_bits];
			y = din2[no_of_digits*radix_bits-1:(no_of_digits-1)*radix_bits];
			din1 = {din1[(no_of_digits-1)*radix_bits-1:(no_of_digits-2)*radix_bits],{radix_bits{1'b0}}};
			din2 = {din2[(no_of_digits-1)*radix_bits-1:(no_of_digits-2)*radix_bits],{radix_bits{1'b0}}};
			end
		else begin //clear input
			x <= 3'd0;
			y <= 3'd0;
		end
		if (counter>=delta)
		// save output to SR
		begin
			dout = {dout[(no_of_digits-1)*radix_bits-1:(no_of_digits-2)*radix_bits],z};
		end
		counter <= counter + 1;
		if (counter >= (no_of_digits+delta-1))
		begin
			counter <= 0;
		end
		
	end
	
	
	
	
	radix4multiplier #(no_of_digits, radix_bits, radix, delta) DUT1(
		.x(x), 
		.y(y),
		.clk(clk), 
		.z(z)
	);

	integer input_file; // file handler
	integer scan_file; // file handler
	integer output_file;
	integer i;
	reg [11:0] input_data1, input_data2;
	`define NULL 0    

	always #5 clk = ~clk;
	
	initial begin
	  input_file = $fopen("input_data.txt", "r");
		output_file = $fopen("output.txt","w");
		clk = 0;
		//cin = 0;
		counter = 0;
	   if (input_file == `NULL) begin
			$display("data_file handle was NULL");
			$finish;
		end
	end

	always @(posedge clk) begin
		if (counter >= (no_of_digits+delta-1))
		begin
			scan_file = $fscanf(input_file, "%b\t%b\n", input_data1, input_data2); 
			if (!$feof(input_file)) begin
				din1 = input_data1;
				din2 = input_data2;
		 //use input_data as you would any other wire or reg value;
			end
		end
	end
	
	initial begin
	for (i = 0; i<20; i=i+1) begin
		@(posedge clk);
      //data_out[i] <= dout;
		#3
      $display("LFSR %b %b %b", din1, din2, dout);
      $fwrite(output_file,"%b\t%b\t%b%b\n",din1, din2, dout);
   end

   $fclose(output_file);  
	 $fclose(input_file);
   $finish;
	end
	
	
endmodule

