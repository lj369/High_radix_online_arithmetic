module radix2adderSerialBlock(din1p, din1n, din2p, din2n, clk, doutp, doutn);

	input din1p, din1n, din2p, din2n, clk;
	output doutp, doutn;
	
	reg fa1s_reg, din2n_reg, fa2c_reg, fa2s_reg1, fa2s_reg2;
	wire fa1s, fa1c, fa2s, fa2c;
	
	assign {fa1c,fa1s} = din1p + ~din1n + din2p;
	assign {fa2c,fa2s} = fa1s_reg + fa1c + ~din2n_reg;
//	assign doutn = fa2c_reg;
//	assign doutp = fa2s_reg2;
	assign doutn = fa2c;
	assign doutp = fa2s_reg1;
	
	
	always @ (posedge clk)
	begin
		fa1s_reg <= fa1s;
		din2n_reg <= din2n;
//		fa2c_reg <= fa2c;
		fa2s_reg1 <= fa2s;
//		fa2s_reg2 <= fa2s_reg1;
	end
endmodule
