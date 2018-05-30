module mem_speed_test

#(
	parameter LFSR_SIZE = 32,
	parameter no_of_digits = 8,
	parameter radix_bits = 3, // = 1+log2(radix) 
	parameter radix = 4,
	parameter no_of_mem_bits = 3,
	parameter address_width = 14, // = floor(log2(floor(5662720/(no_of_digits+1)/radix_bits/burst_index))) 
	parameter max_ram_address = 1024, // = 2^address_width 
	parameter burst_index = 8,
	parameter target_frequency = "400.000000 MHz",
	parameter target_frequency_2 = "50.000000 MHz" // = target_frequency/burst_index 

)

(
	variable_clk_2,
	mem_in
);

	localparam no_of_bits = no_of_digits * radix_bits;
	
//	input wire clkin_125;
//	wire variable_clk;
	input wire variable_clk_2;
	wire reset;

//	assign clk = clk_100MHz;

	
	wire ctrl_clk;
	wire [(no_of_digits+1)*radix_bits-1:0] DUT_out;
	wire [(no_of_digits+1)*radix_bits*burst_index-1:0] mem_read;
	input wire [(no_of_digits+1)*radix_bits*burst_index-1:0] mem_in;
	wire [(no_of_digits*2+1)*radix_bits-1:0] LFSR_out;
	wire [no_of_bits-1:0] LFSR_out_1, LFSR_out_2;
	wire [radix_bits-1:0] LFSR_out_3;
	wire [no_of_digits*radix_bits-1:0] DUT_dout;
	wire [radix_bits-1:0] DUT_cout;
	wire [address_width-1:0] ram_addr;


	wire pll_locked;
	reg pll_rst;

	wire enable;
	wire enable_2;

	
	assign DUT_out = {13'd0, ram_addr};

	
	ramAddress #(address_width, max_ram_address, burst_index) ramAddress_1 (
		.clk(variable_clk_2),
		.ram_addr(ram_addr),
		.enable(enable),
		.reset(reset)
	);
	
	onChipRam #(no_of_digits, radix_bits, address_width, max_ram_address, burst_index) RAM_1(
		.clock(variable_clk_2),
		.address(ram_addr),
		.data(mem_in),
		.wren(enable_2&enable),
		.q(mem_read)
	);
	
	ctr_block #(address_width, max_ram_address, burst_index) ctr_block_1(
		.variable_clk_2(variable_clk_2),
		.enable(enable),
		.enable_2(enable_2),
		.reset(reset),
		.start_signal(start_signal),
		.transfer_done(transfer_done)
	);

	
endmodule
