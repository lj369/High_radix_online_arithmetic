module radix4adder_sv(din1, din2, cin, dout, cout);
	parameter no_of_digits = 8;
	parameter radix_bits = 3;
	parameter radix = 4;
	
	output signed [1:0] cout;
	output signed [no_of_digits-1:0][radix_bits-1:0] dout;
	input signed [no_of_digits-1:0][radix_bits-1:0] din1, din2;
	input cin;
	integer i = 0;
	reg [no_of_digits-1:0][radix_bits-1:0] w, z;
	reg [1:0] t [no_of_digits-1:0];
	int sum[no_of_digits-1:0], din1_temp[no_of_digits-1:0], din2_temp[no_of_digits-1:0];

	always @ (din1 or din2 or cin)
	begin
		for (i=0; i<no_of_digits; i=i+1)
		begin
			if (din1[i][radix_bits-1]==1'b1)
				din1_temp[i] = -din1[i][radix_bits-2:0];
			else
				din1_temp[i] = din1[i][radix_bits-2:0];
			if (din2[i][radix_bits-1]==1'b1)
				din2_temp[i] = -din2[i][radix_bits-2:0];
			else
				din2_temp[i] = din2[i][radix_bits-2:0];			
			sum[i] = din1_temp[i] + din2_temp[i];
			if (sum[i]>=radix-1)
			begin
				t[i] = 1;
				w[i] = sum[i] - radix;
			end
			else if (sum[i]<=-radix+1)
			begin
				t[i] = 2'b11;
				w[i] = sum[i] + radix;
			end
			else
			begin
				t[i] = 0;
				w[i] = sum[i];
			end
		end
		z[0] = w[0] + cin;
		for (i=1; i<no_of_digits; i=i+1)
		begin
			if ((w[i]<radix) && (t[i-1]<=2'b1))
			z[i] = w[i] + t[i-1];
			else if ((w[i]>=radix) && (t[i-1]<=2'b1))
			z[i] = -(w[i]-radix) - t[i-1];
			else if ((w[i]>=radix) && (t[i-1]>2'b1))
			z[i] = -(w[i]-radix) + 1;
			else if ((w[i]<radix) && (t[i-1]>2'b1))
			z[i] = w[i] - 1;
			else
			z[i] = 0;
		end

	end

	assign dout = z;
	assign cout = t[no_of_digits-1];
	
endmodule
