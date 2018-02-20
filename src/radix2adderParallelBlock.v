module radix2adderParallelBlock(din1p, din1n, din2p, din2n, cin, doutp, doutn, cout);
	parameter no_of_digits = 8;

	output cout;
	output[no_of_digits-1:0] doutp, doutn;
	input [no_of_digits-1:0] din1p, din1n, din2p, din2n;
	input cin;
		

	wire[no_of_digits-1:0] fa1c, fa1s, fa2c, fa2s;

	assign {fa1c[0], fa1s[0]} = din1p[0] + !(din1n[0]) + din2p[0];
	assign {fa2c[0], fa2s[0]} = fa1s[0] + cin + !(din2n[0]);

	genvar i;
	generate
		for (i=1; i<no_of_digits; i=i+1)
		begin : generateFAs
			assign {fa1c[i], fa1s[i]} = din1p[i] + !(din1n[i]) + din2p[i];
			assign {fa2c[i], fa2s[i]} = fa1s[i] + fa1c[i-1] + !(din2n[i]);
		end
	endgenerate

	assign doutn[no_of_digits-1:1] = ~fa2c[no_of_digits-2:0];
	assign doutn[0] = 0;
	assign doutp = fa2s;
	assign cout = !(fa2c[no_of_digits-1]);
	
endmodule

/*
module singleUnit(fa2c, fa2s, din1p, din1n, din2p, din2n);
	assign {fa1c[i], fa1s[i]} = din1p[i] + ~din1n[i] + din2p[i];
	assign {fa2c[i], fa2s[i]} = fa1s[i] + fa1c[i-1] + ~din2n[i-1];

endmodule
*/