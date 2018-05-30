module onTheFlyConverter(
  q,
  clk,
  reset,
  Q
);
	parameter no_of_digits = 8;
	parameter radix_bits = 3;
	
	input signed [radix_bits-1:0] q;
	input clk;
	input reset;
	output reg [no_of_digits*(radix_bits-1)-1:0] Q;
	
//	reg [no_of_digits-1:0] Q;
	reg shift_Q, shift_QM;
	reg [no_of_digits*(radix_bits-1)-1:0] QM;
	reg [radix_bits-1:0] Q_in, QM_in;
	
	initial begin
		Q = 0;
		QM = 0;
	end
	
	always @ (posedge clk)
	begin : block1
		if (q>0)
		begin
			shift_Q = 1'b1;
			shift_QM = 1'b0;
			Q_in = q[1:0];
		end
		else if (q<0)
		begin
			shift_Q = 1'b0;
			shift_QM = 1'b1;
			Q_in = q[1:0];
		end
		else
		begin
			shift_Q = 1'b1;
			shift_QM = 1'b1;
			Q_in = 2'b0;
		end
		
		QM_in = Q_in - 2'b01;
		
		if (shift_Q == 1'b1) begin
			Q = {Q[no_of_digits-3:0],Q_in};
		end else begin
			Q = {QM[no_of_digits-3:0],Q_in};
		end
		
		if (shift_QM == 1'b1) begin
			QM = {QM[no_of_digits-3:0],QM_in};
		end else begin
			QM = {Q[no_of_digits-3:0],QM_in};
		end
		if (reset == 1'b1)begin
			Q = 0;
			QM = 0;
		end
	end
	
endmodule