module radix2SELM(
	V_j,
	p_j,
	reset
);
	parameter no_of_digits = 8;
	parameter radix_bits = 2;
	parameter radix = 2;
	parameter delta = 3;

	input [radix_bits*delta-1:0] V_j;
	input wire reset;
	output reg signed [radix_bits-1:0] p_j;
	
	always @ * begin : alway_block
		if (reset == 1'b1)begin
			p_j = 2'b0;
		end
		else begin : case_block
			integer temp_1, temp_2;
			temp_1 = $signed(V_j[radix_bits*delta-1:radix_bits*(delta-1)]);
			temp_2 = 2*$signed(V_j[radix_bits*(delta-1)-1:radix_bits*(delta-2)])+$signed(V_j[radix_bits*(delta-2)-1:radix_bits*(delta-3)]);
			case(temp_1)
				1:begin
					if (temp_2<-1) begin
						p_j = 2'b00;
					end
					else begin
						p_j = 2'b01;
					end
				end
				0:begin
					if (temp_2==3)begin
						p_j = 2'b01;
					end
					else if (temp_2<-1) begin
						p_j = 2'b11;
					end
					else begin
						p_j = 2'b00;
					end
				end
				-1:begin
					if (temp_2==3)begin
						p_j = 2'b00;
					end
					else begin
						p_j = 2'b11;
					end
				end
				default: p_j = 2'b00;
			endcase
		end
	end
	
endmodule
