
module radix4adder_new(
	din1,
	din2,
	cin,
	dout,
	cout
	);
	parameter no_of_digits = 8;
	parameter radix_bits = 3;
	parameter radix = 4;
	localparam radix_bits_mi_2 = radix_bits - 2;
	
	input [no_of_digits*radix_bits-1:0] din1; 
	input [no_of_digits*radix_bits-1:0] din2;
	input [radix_bits-1:0] cin;
	output [no_of_digits*radix_bits-1:0] dout; 
	output [radix_bits-1:0] cout;
	
	reg [no_of_digits*radix_bits-1:0] w;
	reg [no_of_digits*radix_bits-1:0] z;
	reg [no_of_digits*2-1:0] t;

	//integer [no_of_digits-1:0] sum;
			
	genvar i;
	
	generate
	for (i=0; i<no_of_digits; i=i+1)
	begin : loop_gen_block_1
		always @ (din1 or din2 or cin)
		begin : alway_block
			integer a,b,sum;
			a = $signed(din1[(i+1)*radix_bits-1:i*radix_bits]);
			b = $signed(din2[(i+1)*radix_bits-1:i*radix_bits]);

			sum = a + b;
			if ($signed(sum)>=radix)
			begin
				t[2*i+1:2*i] = 2'b1;
				w[(i+1)*radix_bits-1:i*radix_bits] = sum - radix;
			end else if ($signed(sum)<=-radix)
			begin
				t[2*i+1:2*i] = 2'b11;
				w[(i+1)*radix_bits-1:i*radix_bits] = sum + radix;
			end
			else
			begin
				t[2*i+1:2*i] = 2'b0;
				w[(i+1)*radix_bits-1:i*radix_bits] = sum;
			end
		end
	end
	endgenerate
	
	always @ (w or cin)
		begin
		z[radix_bits-1:0] = w[radix_bits-1:0] + cin;
		end
	generate
		for (i=1; i<no_of_digits; i=i+1)
		begin : loop_gen_block_2
			always @ (w or t)
			begin
			z[(i+1)*radix_bits-1:i*radix_bits] = w[(i+1)*radix_bits-1:i*radix_bits] + {{radix_bits_mi_2{t[2*i-1]}},t[2*i-1:2*(i-1)]};
			end
		end
	endgenerate

	assign dout = z;
	assign cout = {{radix_bits_mi_2{t[no_of_digits*2-1]}},t[no_of_digits*2-1:no_of_digits*2-2]};
	
endmodule
