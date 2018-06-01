`timescale 1 ps / 1 ps

// mem max freq: 8*73 = 584MHz

module masterLevelNew

#(
	parameter LFSR_SIZE = 32,
	parameter no_of_digits = 10,
	parameter radix_bits = 3, // = 1+log2(radix) 
	parameter radix = 4,
	parameter no_of_mem_bits = 3,
	parameter address_width = 14, // = floor(log2(floor(5662720/(no_of_digits+1)/radix_bits/burst_index))) 
	parameter max_ram_address = 4096, // = 2^address_width 
	parameter burst_index = 5,
	parameter target_frequency = "400.000000 MHz",
	parameter target_frequency_2 = "80.000000 MHz" // = target_frequency/burst_index 
)

(
	UserPushButton1,
	start_signal,
	enable,
	UserLED3,
	variable_clk_f,
	variable_clk_s,
	ctrl_clk
);

	localparam no_of_bits = no_of_digits * radix_bits;
	
	input wire UserPushButton1;
	output reg UserLED3;
	input wire variable_clk_f;
	input wire variable_clk_s;
	wire reset;

//	assign clk = clk_100MHz;
	
	output wire ctrl_clk;
	wire [(no_of_digits+1)*radix_bits-1:0] DUT_out; // Dout_out is the output from DUT
	wire [(no_of_digits+1)*radix_bits*burst_index-1:0] mem_read; // data from RAM
	wire [(no_of_digits+1)*radix_bits*burst_index-1:0] mem_in; // data to RAM before REG
	reg [(no_of_digits+1)*radix_bits*burst_index-1:0] mem_in_reg; // data to RAM after REG
	wire [(no_of_digits*2)*radix_bits-1:0] LFSR_out;
	wire [no_of_bits-1:0] LFSR_out_1, LFSR_out_2;
	wire [1:0] LFSR_out_3_pre;
	wire [radix_bits-1:0] LFSR_out_3;
	wire [no_of_digits*radix_bits-1:0] DUT_dout; 
	wire [radix_bits-1:0] DUT_cout;
	wire [address_width-1:0] ram_addr; // RAM Address
	wire enable_reg_f;
	reg enable_reg_2_s;
	reg enable_reg_1_s;
	wire start_signal_reg_f;
	reg reset_reg_s;


//	wire pll_locked;
//	reg pll_rst;

	output wire enable;
//	wire enable_2;
//	wire enable_3;
	wire transfer_done;
	output wire start_signal;
	wire [LFSR_SIZE-1:0] LFSR_content;
	wire [(no_of_digits+1)*radix_bits-1:0] DUT_test;
	wire transfer_enable;


	
// --------------------------------------------------------------------------------------
// --------------------------------------------------------------------------------------

// controlled fast clock domain

	LFSRBlock #(1, LFSR_SIZE, 1537598292, 2) LFSR_3 (
		.clk(ctrl_clk),
		.reset(1'b0),
//		.enable(enable_reg_f),
		.out(LFSR_out_3_pre)
	);
	

// testing
//	LFSRBlock #(no_of_digits+no_of_digits, LFSR_SIZE, 1451698946, radix_bits) LFSR_1 (
//		.clk(ctrl_clk),
//		.reset(1'b0),
////		.enable(enable_reg_f),
//		.out(LFSR_out)
//	);



	LFSRBlock_test #(no_of_digits+no_of_digits, LFSR_SIZE, 1451698946, radix_bits) LFSR_1 (
		.clk(ctrl_clk),
		.reset(1'b0),
		.out(LFSR_content)
	);

	
	assign LFSR_out_1 = LFSR_out[no_of_bits-1:0];
	assign LFSR_out_2 = LFSR_out[no_of_bits*2-1:no_of_bits];
	assign LFSR_out_3 = {{(radix_bits-2){LFSR_out_3_pre[1]}},LFSR_out_3_pre};
	
	radix4adder_new #(no_of_digits, radix_bits, radix) DUT_1(
		.din1(LFSR_out_1),
		.din2(LFSR_out_2),
		.cin(LFSR_out_3),
		.dout(DUT_dout),
		.cout(DUT_cout)
	);
	

	assign DUT_out = {3'b000, LFSR_out_2};

	assign DUT_test = {1'b0, LFSR_content};


// test
	concatenateDout #(no_of_digits, radix_bits, burst_index) concatenateDout_1 (
		.Dout(DUT_test),
		.variable_clk(ctrl_clk),
		.mem_in(mem_in)
	);

//	concatenateDout #(no_of_digits, radix_bits, burst_index) concatenateDout_1 (
//		.Dout(DUT_test),
//		.variable_clk(ctrl_clk),
//		.mem_in(mem_in)
//	);
	
//	signalCrossClkDomainSR #(burst_index, {{(burst_index-1){1'b0}}, 1'b1}, burst_index-1) transfer_enable_SR (
//		.signal_in(transfer_enable),
//		.clk(ctrl_clk),
//		.reset(1'b0),
//		.signal_out(transfer_enable)
//	);

	// transfer_enable_SR
	reg [burst_index-1:0] transfer_enable_SR;
	
	initial begin
		transfer_enable_SR = {{(burst_index-1){1'b0}}, 1'b1};
	end

	always @ (posedge ctrl_clk) begin
//		if (reset) SR <= {burst_index{1'b0}};
//		else begin
			transfer_enable_SR <= {transfer_enable_SR[burst_index-2:0], transfer_enable_SR[burst_index-1]};
//		end
	end

	assign transfer_enable = transfer_enable_SR[burst_index-2];
	
	always @ (posedge ctrl_clk) begin
		if (transfer_enable) begin
			mem_in_reg <= mem_in;
		end
	end

	
// --------------------------------------------------------------------------------------
// --------------------------------------------------------------------------------------
	// fast clock domain / slow to fast boundary
	// list of clock-crossing signals
	//  1. start_signal -> start_signal_reg_f
	//  2. enable_reg_1_s -> enable_reg_f
	
	signalCrossClkDomainSR #(burst_index, 0, burst_index-1) enable_SR (
		.signal_in(enable_reg_1_s),
		.clk(variable_clk_f),
		.reset(1'b0),
		.signal_out(enable_reg_f)
	);
	
	signalCrossClkDomainSR #(burst_index) start_sig_SR (
		.signal_in(start_signal),
		.clk(variable_clk_f),
		.reset(1'b0),
		.signal_out(start_signal_reg_f)
	);
	
	
	clockEnablePLL clk_enable_pll (
		.inclk(variable_clk_f),  //  altclkctrl_input.inclk
		.ena(enable_reg_f),    //                  .ena
		.outclk(ctrl_clk)  // altclkctrl_output.outclk
	);


// --------------------------------------------------------------------------------------

	
	// slow clock domain
	
	ramAddress #(address_width, max_ram_address, burst_index) ramAddress_1 (
		.clk(variable_clk_s),
		.ram_addr(ram_addr),
		.enable(enable_reg_1_s),
		.reset(reset_reg_s)
	);	
	
	onChipRam #(no_of_digits, radix_bits, address_width, max_ram_address, burst_index) RAM_1(
		.clock(variable_clk_s),
		.address(ram_addr),
		.data(mem_in_reg),
		.wren(enable_reg_2_s),
		.q(mem_read)
	);
	
	memCopyDetector #(no_of_mem_bits) memCopyDetector_1(
		.data_in(mem_read[no_of_mem_bits-1:0]),
		.enable(enable_reg_1_s),
		.clk(variable_clk_s),
		.transfer_done(transfer_done)
	);

	ctr_block #(address_width, max_ram_address, burst_index) ctr_block_1(
		.UserPushButton1(UserPushButton1),
		.variable_clk_2(variable_clk_s),
		.enable(enable),
		.reset(reset),
		.start_signal(start_signal),
		.transfer_done(transfer_done)
	);
	
	initial begin
		enable_reg_1_s <= 1'b0;
		reset_reg_s <= 1'b0;
		enable_reg_2_s <= 1'b0;
	end
	
	always @ (posedge variable_clk_s) begin
		enable_reg_1_s <= enable;
		reset_reg_s <= reset;
		enable_reg_2_s <= enable_reg_1_s;
	end
	
	
	
endmodule
