
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
	//reg [(no_of_digits+1)*radix_bits-1:0] dout; 	
	reg [(2*no_of_digits+1)*radix_bits-1:0] dout; 
	reg [(2*no_of_digits+1)*radix_bits-1:0] dout_old; 
	reg clk;
	integer counter;
	reg [radix_bits-1:0] x;
	reg [radix_bits-1:0] y;
	wire [radix_bits-1:0] z;
	reg full_result_sel;
	reg extern_reset;
	
	
	integer input_file; // file handler
	integer scan_file; // file handler
	integer output_file;
	integer i;
	reg [11:0] input_data1, input_data2;
	reg [11:0] input_data1_old, input_data2_old;
	`define NULL 0    

	always #5 clk = ~clk;
	
	initial begin
		input_file = $fopen("input_data.txt", "r");
		output_file = $fopen("output.txt","w");
		clk = 0;
		full_result_sel = 1'b1;
		//cin = 0;
		counter = 2*no_of_digits+delta+1;
		extern_reset = 1'b1;
	   if (input_file == `NULL) begin
			$display("data_file handle was NULL");
			$finish;
		end
		#25 extern_reset = 1'b0; 
	end
	
	always @ (posedge clk)
	begin
//		if (counter == no_of_digits+delta+2)begin
		if (counter == 2*no_of_digits+delta+1)begin
			//extern_reset = 1'b1;
			scan_file = $fscanf(input_file, "%b\t%b\n", input_data1, input_data2); 
			if (!$feof(input_file)) begin
					din1 = input_data1;
					din2 = input_data2;
			end
		end

		if (counter == 2*no_of_digits+delta+1)begin
			//extern_reset = 1'b0;
		end
		if (counter<no_of_digits)
		// load input to SR
		begin
			x = din1[no_of_digits*radix_bits-1:(no_of_digits-1)*radix_bits];
			y = din2[no_of_digits*radix_bits-1:(no_of_digits-1)*radix_bits];
			din1 = {din1[(no_of_digits-1)*radix_bits-1:0],{radix_bits{1'b0}}};
			din2 = {din2[(no_of_digits-1)*radix_bits-1:0],{radix_bits{1'b0}}};
			end
		else begin //clear input
			x = {radix_bits{1'd0}};
			y = {radix_bits{1'd0}};
		end
		if (counter>=delta+1 && counter<2*no_of_digits+delta+2)
		// save output to SR
		begin
			//dout = {dout[no_of_digits*radix_bits-1:0],z};
			dout = {dout[(2*no_of_digits)*radix_bits-1:0],z};
		end

		counter = counter + 1;
		
		if (counter > (2*no_of_digits+delta+1))
		begin
			counter = 0;
			dout = 0;
		end
	end
	
	
	radix4multiplier #(no_of_digits, radix_bits, radix, delta) DUT1(
		.xin(x), 
		.yin(y),
		.clk(clk), 
		.z(z),
		.full_result_sel(full_result_sel),
		.extern_reset(extern_reset)
	);

	

/*
	always @(posedge clk) begin
		if (counter >= (no_of_digits+delta+1))
		begin
			scan_file = $fscanf(input_file, "%b\t%b\n", input_data1, input_data2); 
			if (!$feof(input_file)) begin
				din1 = input_data1;
				din2 = input_data2;
		 //use input_data as you would any other wire or reg value;
			end
		end
	end
*/
	initial begin
		for (i = 0; i<20*(2*no_of_digits+delta+1); i=i+1) begin
			@(posedge clk);
			//data_out[i] <= dout;
			if (counter == 0)begin
				#2
				$display("LFSR %b %b %b", input_data1_old, input_data2_old, dout_old);
				$fwrite(output_file,"%b\t%b\t%b\n",input_data1_old, input_data2_old, dout_old);
			end
		end
		$fclose(output_file);  
		$fclose(input_file);
		$finish;
	end
	
	always @ (negedge clk) begin
		if (counter == 2*no_of_digits+delta+1)
		begin
			input_data1_old = input_data1;
			input_data2_old = input_data2;
			dout_old = dout;
		end
	end
	

	
	
endmodule

