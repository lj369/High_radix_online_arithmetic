`timescale 1 ps / 1 ps

// mem max freq: 8*73 = 584MHz

module masterLevelOneClkDomain

#(
	parameter LFSR_SIZE = 32,
	parameter no_of_digits = 10,
	parameter radix_bits = 3, // = 1+log2(radix) 
	parameter radix = 4,
	parameter no_of_mem_bits = 3,
	parameter address_width = 14, // = floor(log2(floor(5662720/(no_of_digits+1)/radix_bits/burst_index))) 
	parameter max_ram_address = 4096, // = 2^address_width 
	parameter burst_index = 1,
	parameter target_frequency = "400.000000 MHz",
	parameter target_frequency_2 = "80.000000 MHz" // = target_frequency/burst_index 
)

(
	UserPushButton1,
	start_signal,
	enable,
	UserLED3,
	variable_clk,
	variable_clk_2,
	ctrl_clk
);


	localparam no_of_bits = no_of_digits * radix_bits;
	
	input wire UserPushButton1;
	output reg UserLED3;
	input wire variable_clk;
	input wire variable_clk_2;
	wire reset;

//	assign clk = clk_100MHz;
	
	output wire ctrl_clk;
	wire [(no_of_digits+1)*radix_bits-1:0] DUT_out;
	reg [(no_of_digits+1)*radix_bits-1:0] mem_in;
	wire [(no_of_digits+1)*radix_bits*burst_index-1:0] mem_read;
	//wire [(no_of_digits+1)*radix_bits*burst_index-1:0] mem_in;
	reg [(no_of_digits+1)*radix_bits*burst_index-1:0] mem_in_reg;
	wire [(no_of_digits*2)*radix_bits-1:0] LFSR_out;
	wire [no_of_bits-1:0] LFSR_out_1, LFSR_out_2;
	wire [1:0] LFSR_out_3_pre;
	wire [radix_bits-1:0] LFSR_out_3;
	wire [no_of_digits*radix_bits-1:0] DUT_dout;
	wire [radix_bits-1:0] DUT_cout;
	wire [address_width-1:0] ram_addr;
	wire enable_2_reg; // wire which connects to output of Shift register
	reg reset_reg;
	reg enable_reg;


//	wire pll_locked;
//	reg pll_rst;

	output wire enable;
	wire enable_2;
//	wire enable_3;
	wire transfer_done;
	output wire start_signal;
	

	LFSRBlock #(1, LFSR_SIZE, 1537598292, 2) LFSR_3 (
		.clk(ctrl_clk),
		.reset(start_signal),
//		.enable(enable_2_reg),
		.out(LFSR_out_3_pre)
	);
	

	LFSRBlock #(no_of_digits+no_of_digits, LFSR_SIZE, 1451698946, radix_bits) LFSR_1 (
		.clk(ctrl_clk),
		.reset(start_signal),
//		.enable(enable_2_reg),
		.out(LFSR_out)
	);

// testing
	wire [LFSR_SIZE-1:0] LFSR_content;
	LFSRBlock_test #(no_of_digits+no_of_digits, LFSR_SIZE, 1451698946, radix_bits) LFSR_test_1 (
		.clk(ctrl_clk),
		.reset(start_signal),
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
	
	
//	assign DUT_out = {DUT_cout, DUT_dout};

	assign DUT_out = {3'b00, LFSR_out_2};

	always @ (posedge variable_clk) begin
		mem_in = DUT_test;
	end
	
	wire [(no_of_digits+1)*radix_bits-1:0] DUT_test;
	assign DUT_test = {1'b0, LFSR_content};

//	assign DUT_out = {13'd0, ram_addr};
	
	ramAddressOneClkDomain #(address_width, max_ram_address, burst_index) ramAddress_1 (
		.clk(variable_clk),
		.ram_addr(ram_addr),
		.enable(enable),
		.reset(reset)
	);
	
	onChipRam #(no_of_digits, radix_bits, address_width, max_ram_address, burst_index) RAM_1(
		.clock(variable_clk),
		.address(ram_addr),
		.data(mem_in),
		.wren(enable),
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
		.ena(enable),    //                  .ena
		.outclk(ctrl_clk)  // altclkctrl_output.outclk
	);
	
//	assign variable_clk = clkin_50;


// LED indicating calculation is done

	always @ (posedge variable_clk) begin
		if (enable) UserLED3 = 1'b0;
	end

	initial begin
		UserLED3 = 1'b1;
	end
	
	ctrBlockOneClkDomain #(address_width, max_ram_address, burst_index) ctr_block_1(
		.UserPushButton1(UserPushButton1),
		.variable_clk_2(variable_clk),
		.enable(enable),
		.enable_2(enable_2),
		.reset(reset),
		.start_signal(start_signal),
		.transfer_done(transfer_done)
	);	


endmodule
