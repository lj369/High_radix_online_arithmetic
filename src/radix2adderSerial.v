module radix2adderSerial(din1p, din1n, din2p, din2n, clk, doutp, doutn, start, finish);
	
	parameter no_of_digits = 8;
	input[no_of_digits-1:0] din1p, din1n, din2p, din2n;
	input clk, start;
	output[no_of_digits-1:0] doutp, doutn;
	output finish;
	integer i, j;
	reg[no_of_digits-1:0] doutp_reg, doutn_reg;
	reg din1p_temp, din1n_temp, din2p_temp, din2n_temp, finish_reg;
	wire doutp_temp, doutn_temp;
	
	initial 
	begin
		i=-1;	
	end
	
	assign doutp=doutp_reg;
	assign doutn=doutn_reg;
	assign finish = finish_reg;
	
	radix2adderSerialBlock radix2adderSerialBlock1(din1p_temp, din1n_temp, din2p_temp, din2n_temp, clk, doutp_temp, doutn_temp);
	
	always @ (posedge clk)
	begin
		if (start == 1) i=no_of_digits;
		i = i-1;
		if (i>-1)
		begin
			din1p_temp <=din1p[i];
			din1n_temp <=din1n[i];
			din2p_temp <=din2p[i];
			din2n_temp <=din2n[i];
			finish_reg <= 0;
		end
		if (i>-3 && i< no_of_digits-2)
		begin
			doutp_reg[i+2] <= doutp_temp;
			doutn_reg[i+2] <= doutn_temp;
		end
		if (i<=-3) finish_reg <= 1;
	end
	
	
	
endmodule