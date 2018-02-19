module radix4WModification(
	w_in,
	w_out
);

	parameter no_of_digits = 4;
	parameter radix_bits = 3;
	parameter radix = 4;
	parameter delta = 2;
	
	input [radix_bits*(no_of_digits+delta+1)-1:0] w_in;
	output reg [radix_bits*(no_of_digits+delta+1)-1:0] w_out;
	
	always @ (*)
	begin : always_block
		integer d1, d2;
		w_out = w_in;
		d1 = $signed(w_in[radix_bits*(no_of_digits+delta+1)-1:radix_bits*(no_of_digits+delta)]); 
		d2 = $signed(w_in[radix_bits*(no_of_digits+delta)-1:radix_bits*(no_of_digits+delta-1)]); 
		if (d1 == -1)begin
			w_out[radix_bits*(no_of_digits+delta)-1:radix_bits*(no_of_digits+delta-1)] = d2 - radix;
			w_out[radix_bits*(no_of_digits+delta+1)-1:radix_bits*(no_of_digits+delta)] = {radix_bits{1'b0}};
		end
		else if (d1 == 1)begin
			w_out[radix_bits*(no_of_digits+delta+1)-1:radix_bits*(no_of_digits+delta)] = {radix_bits{1'b0}};
			w_out[radix_bits*(no_of_digits+delta)-1:radix_bits*(no_of_digits+delta-1)] = d2 + radix;
		end
	end

endmodule