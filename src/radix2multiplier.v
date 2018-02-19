
module radix2multiplier(
	x,
	y,
	clk,
	z,
	full_result_sel
	);

	parameter no_of_digits = 4;
	parameter radix_bits = 2;
	parameter radix = 2;
	parameter delta = 3;
	
	input [radix_bits-1:0] x;
	input [radix_bits-1:0] y;
	input clk;
	input full_result_sel;
	output wire [radix_bits-1:0] z;
	
	wire [no_of_digits*radix_bits-1:0] X_j, Y_j;
	reg [no_of_digits*radix_bits-1:0] X_j_1;
	wire signed [radix_bits-1:0] p_j;
	wire signed [radix_bits-1:0] neg_p_j;
	wire [radix_bits*(no_of_digits+1)-1:0] V_j;
	
	//test output
	wire [radix_bits*(no_of_digits+1)-1:0] sum_1;
	wire [(no_of_digits+1)*radix_bits-1:0] X_times_y;
	wire [(no_of_digits+1)*radix_bits-1:0] Y_times_x;
	
	reg [radix_bits*(no_of_digits+1)-1:0] W_j_1;
	wire [radix_bits*(no_of_digits+1)-1:0] W_j;
	reg [3:0] counter;
	reg reset;
	//wire [radix_bits-1:0] cout_from_3input_adder;

	initial
	begin
		counter = 4'd0;
		W_j_1 = 0;
		X_j_1 = 0;
		reset = 1'b0;
	end
	

	onTheFlyConverterSignedDigit #(no_of_digits, radix_bits) CA_X(
		.q (x),
		.clk (clk),
		.Q (X_j),
		.reset (reset)
	);

	onTheFlyConverterSignedDigit #(no_of_digits, radix_bits) CA_Y(
		.q (y),
		.clk (clk),
		.Q (Y_j),
		.reset (reset)
	);

	
	calcVj #(no_of_digits, radix_bits, radix, delta) Vj_1(
		.X_j(X_j_1),
		.Y_j(Y_j),
		.x_j_1(x),
		.y_j_1(y),
		.W_j(W_j_1),
		.clk(clk),
		.p_j(p_j),
		.V_j(V_j),
		.sum_1(sum_1),
		.X_times_y(X_times_y),
		.Y_times_x(Y_times_x),
		.reset(reset)
	);
	
	
	negateX #(1, radix_bits, radix) negate_p (
		.x_in(p_j),
		.x_out(neg_p_j)
	);
	
	radix4adder_new #(no_of_digits+1,radix_bits,radix) adder_2(
		.din1(V_j),
		.din2({neg_p_j, {no_of_digits*radix_bits{1'b0}}}),
		.cin(3'b0),
		.dout(W_j),
		.cout()
	);
	
	
	always @ (posedge clk)
	begin
		X_j_1 = X_j;
		W_j_1 = W_j;
		counter = counter + 1;
		
		if (reset == 1'b1)
		begin
			counter = 4'd0;
			W_j_1 = 0;
			X_j_1 = 0;
			reset = 1'b0;
		end
	end

	always @ (negedge clk)
	begin 
		if (counter > delta+no_of_digits)
		begin
			reset = 1'b1;
		end
	end
	
	assign z = p_j;

endmodule



module SELM(
	V_j,
	p_j,
	reset
);
	parameter no_of_digits = 4;
	parameter radix_bits = 3;
	parameter radix = 4;
	parameter delta = 2;

	input [radix_bits*(no_of_digits+1)-1:radix_bits*(no_of_digits+1-delta)] V_j;
	input wire reset;
	output reg signed [radix_bits-1:0] p_j;
	
	always @ * begin : alway_block
		if (reset == 1'b1)begin
			p_j = 3'b000;
		end
		else begin : case_block
			integer temp_1, temp_2;
			temp_1 = $signed(V_j[radix_bits*(no_of_digits+1)-1:radix_bits*(no_of_digits)]);
			temp_2 = $signed(V_j[radix_bits*(no_of_digits)-1:radix_bits*(no_of_digits-1)]);
			case(temp_1)
				3:begin
					if (temp_2>=-1)begin
						p_j = 3'b011;
					end
					else begin
						p_j = 3'b010;
					end
				end
				2:begin
					if (temp_2==3)begin
						p_j = 3'b011;
					end
					else if (temp_2<-1) begin
						p_j = 3'b001;
					end
					else begin
						p_j = 3'b010;
					end
				end
				1:begin
					if (temp_2==3)begin
						p_j = 3'b010;
					end
					else if (temp_2<-1) begin
						p_j = 3'b000;
					end
					else begin
						p_j = 3'b001;
					end
				end
				0:begin
					if (temp_2==3)begin
						p_j = 3'b001;
					end
					else if (temp_2<-1) begin
						p_j = 3'b111;
					end
					else begin
						p_j = 3'b000;
					end
				end
				-1:begin
					if (temp_2==3)begin
						p_j = 3'b000;
					end
					else if (temp_2<-1) begin
						p_j = 3'b110;
					end
					else begin
						p_j = 3'b111;
					end
				end
				-2:begin
					if (temp_2==3)begin
						p_j = 3'b111;
					end
					else if (temp_2<-1) begin
						p_j = 3'b101;
					end
					else begin
						p_j = 3'b110;
					end
				end
				-3:begin
					if (temp_2==3)begin
						p_j = 3'b110;
					end
					else begin
						p_j = 3'b101;
					end
				end
				default: p_j = 0;
			endcase
		end
	end
	
endmodule



