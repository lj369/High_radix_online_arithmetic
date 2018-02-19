module radix4SELM(
	V_j,
	p_j,
	reset
);
	parameter no_of_digits = 4;
	parameter radix_bits = 3;
	parameter radix = 4;
	parameter delta = 2;

	input [radix_bits*delta-1:0] V_j;
	input wire reset;
	output reg signed [radix_bits-1:0] p_j;
	
	always @ * begin : alway_block
		if (reset == 1'b1)begin
			p_j = 3'b000;
		end
		else begin : case_block
			integer temp_1, temp_2;
			temp_1 = $signed(V_j[radix_bits*delta-1:radix_bits*(delta-1)]);
			temp_2 = $signed(V_j[radix_bits*(delta-1)-1:radix_bits*(delta-2)]);
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
				default: p_j = 3'b000;
			endcase
		end
	end
	
endmodule