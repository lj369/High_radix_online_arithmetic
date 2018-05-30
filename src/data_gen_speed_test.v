// max freq: 300MHz
// max freq: 418MHz

module data_gen_speed_test
#(
	parameter LFSR_SIZE = 32,
	parameter no_of_digits = 8,
	parameter radix_bits = 3, // = 1+log2(radix) 
	parameter radix = 4,
	parameter no_of_mem_bits = 3,
	parameter address_width = 14, // = floor(log2(floor(5662720/(no_of_digits+1)/radix_bits/burst_index))) 
	parameter max_ram_address = 16384, // = 2^address_width 
	parameter burst_index = 8,
	parameter target_frequency = "400.000000 MHz",
	parameter target_frequency_2 = "50.000000 MHz" // = target_frequency/burst_index 
)

(
	ctrl_clk,
	start_signal,
	mem_in
);

	localparam no_of_bits = no_of_digits * radix_bits;

	input wire ctrl_clk;
	input wire start_signal;
	wire [(no_of_digits*2+1)*radix_bits-1:0] LFSR_out;

	wire [(no_of_digits+1)*radix_bits-1:0] DUT_out;
	wire [(no_of_digits+1)*radix_bits*burst_index-1:0] mem_read;
	output wire [(no_of_digits+1)*radix_bits*burst_index-1:0] mem_in;
	wire [no_of_bits-1:0] LFSR_out_1, LFSR_out_2;
	wire [radix_bits-1:0] LFSR_out_3;
	wire [no_of_digits*radix_bits-1:0] DUT_dout;
	wire [radix_bits-1:0] DUT_cout;
	wire [address_width-1:0] ram_addr;

	
	LFSRBlock #(no_of_digits+no_of_digits+1, LFSR_SIZE, 0, radix_bits) LFSR_1 (
		.clk(ctrl_clk),
		.reset(start_signal),
//		.enable(enable_2),
		.out(LFSR_out)
	);
	

	assign LFSR_out_1 = LFSR_out[no_of_bits-1:0];
	assign LFSR_out_2 = LFSR_out[no_of_bits*2-1:no_of_bits];
	assign LFSR_out_3 = LFSR_out[no_of_bits*2+radix_bits-1:no_of_bits*2];
	
	radix4adder_new #(no_of_digits, radix_bits, radix) DUT_1(
		.din1(LFSR_out_1),
		.din2(LFSR_out_2),
		.cin(LFSR_out_3),
		.dout(DUT_dout),
		.cout(DUT_cout)
	);
	
	assign DUT_out = {DUT_cout, DUT_dout};

//	assign DUT_out = {3'b000, LFSR_out_1};

//	assign DUT_out = {13'd0, ram_addr};


	concatenateDout #(no_of_digits, radix_bits, burst_index) concatenateDout_1 (
		.Dout(DUT_out),
		.variable_clk(ctrl_clk),
		.mem_in(mem_in)
	);
	
	
endmodule
