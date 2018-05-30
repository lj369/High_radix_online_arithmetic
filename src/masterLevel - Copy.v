`timescale 1 ps / 1 ps

// mem max freq: 8*73 = 584MHz

module masterLevel

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
	clkin_125,
);

	localparam no_of_bits = no_of_digits * radix_bits;
	
	input wire clkin_125;
	wire variable_clk;
	wire variable_clk_2;
	wire reset;

//	assign clk = clk_100MHz;

	
	wire ctrl_clk;
	wire [(no_of_digits+1)*radix_bits-1:0] DUT_out;
	wire [(no_of_digits+1)*radix_bits*burst_index-1:0] mem_read;
	wire [(no_of_digits+1)*radix_bits*burst_index-1:0] mem_in;
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
	wire transfer_done;
	
	
//	LFSRBlock #(no_of_digits, LFSR_SIZE, 0, radix_bits) LFSR_1 (
//		.clk(ctrl_clk),
//		.enable(1'b1),
////		.enable(enable_2),
//		.out(LFSR_out_1)
//	);
//	
//	LFSRBlock #(no_of_digits, LFSR_SIZE, 1451698946, radix_bits) LFSR_2 (
//		.clk(ctrl_clk),
//		.enable(1'b1),
////		.enable(enable_2),
//		.out(LFSR_out_2)
//	);
//	
//	LFSRBlock #(1, LFSR_SIZE, 1537598292, radix_bits) LFSR_3 (
//		.clk(ctrl_clk),
//		.enable(1'b1),
////		.enable(enable_2),
//		.out(LFSR_out_3)
//	);
	

	
	LFSRBlock #(no_of_digits+no_of_digits+1, LFSR_SIZE, 0, radix_bits) LFSR_1 (
		.clk(ctrl_clk),
		.enable(1'b1),
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

//	assign DUT_out = {3'b000, LFSR_out_2};


	concatenateDout #(no_of_digits, radix_bits, burst_index) concatenateDout_1 (
		.Dout(DUT_out),
		.variable_clk(variable_clk),
		.mem_in(mem_in)
	);
	
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
	
	memCopyDetector #(no_of_mem_bits) memCopyDetector_1(
		.data_in(mem_read[no_of_mem_bits-1:0]),
		.enable(enable),
		.clk(variable_clk),
		.transfer_done(transfer_done)
	);
	
//	assign ctrl_clk = clkin_50;

	clockEnablePLL clk_enable_pll (
		.inclk(variable_clk),  //  altclkctrl_input.inclk
		.ena(enable_2),    //                  .ena
		.outclk(ctrl_clk)  // altclkctrl_output.outclk
	);
	
//	assign variable_clk = clkin_50;
	
	pll3 #(target_frequency) pll_2(
		.refclk(clkin_125),   //  refclk.clk
		.rst(pll_rst),      //   reset.reset
		.outclk_0(variable_clk), // outclk0.clk
		.outclk_1(variable_clk_2),
		.locked(pll_locked) 
	);
	

	ctr_block #(address_width, max_ram_address, burst_index) ctr_block_1(
		.variable_clk_2(variable_clk_2),
		.enable(enable),
		.enable_2(enable_2),
		.reset(reset),
		.transfer_done(transfer_done)
	);
	
endmodule
