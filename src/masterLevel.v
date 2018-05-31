`timescale 1 ps / 1 ps

// mem max freq: 8*73 = 584MHz

module masterLevel

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
	wire enable_2_reg; // wire which connects to output of Shift register
	reg reset_reg;
	reg enable_reg;
	wire start_signal_reg;


//	wire pll_locked;
//	reg pll_rst;

	output wire enable;
	wire enable_2;
//	wire enable_3;
	wire transfer_done;
	output wire start_signal;


	LFSRBlock #(1, LFSR_SIZE, 1537598292, 2) LFSR_3 (
		.clk(ctrl_clk),
		.reset(start_signal_reg),
//		.enable(enable_2_reg),
		.out(LFSR_out_3_pre)
	);
	

// testing
//	LFSRBlock #(no_of_digits+no_of_digits, LFSR_SIZE, 1451698946, radix_bits) LFSR_1 (
//		.clk(ctrl_clk),
//		.reset(start_signal_reg),
////		.enable(enable_2_reg),
//		.out(LFSR_out)
//	);


	wire [LFSR_SIZE-1:0] LFSR_content;
	LFSRBlock_test #(no_of_digits+no_of_digits, LFSR_SIZE, 1451698946, radix_bits) LFSR_1 (
		.clk(ctrl_clk),
		.reset(start_signal_reg),
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

	assign DUT_out = {3'b000, LFSR_out_2};

	wire [(no_of_digits+1)*radix_bits-1:0] DUT_test;
	assign DUT_test = {1'b0, LFSR_content};

//	assign DUT_out = {13'd0, ram_addr};

// test
//	concatenateDout #(no_of_digits, radix_bits, burst_index) concatenateDout_1 (
//		.Dout(DUT_out),
//		.variable_clk(ctrl_clk),
//		.mem_in(mem_in)
//	);

	concatenateDout #(no_of_digits, radix_bits, burst_index) concatenateDout_1 (
		.Dout(DUT_test),
		.variable_clk(ctrl_clk),
		.mem_in(mem_in)
	);

	

	
	// mem_in_reg
	// shift register enable signal for controlling DUT data going from faster clock domain to slower clock domain
	
	
	reg [burst_index-1:0] transfer_SR;
	
	always @ (posedge ctrl_clk) begin
		if (start_signal_reg) begin
			transfer_SR <= {{(burst_index-2){1'b0}}, 1'b1};
		end
		else begin
			transfer_SR <= {transfer_SR[burst_index-2:0], transfer_SR[burst_index-1]};
		end
	end
	
	always @ (posedge ctrl_clk) begin
		if (transfer_SR[0] == 1'b1) begin
			mem_in_reg = mem_in;
		end
	end
	
	
	// enable_2_reg 
	// shift register for enable_2 signal goes from slower clock domain to faster clock domain
	
	reg [burst_index-1:0] enable_2_SR;
	reg [burst_index-1:0] start_signal_SR;
	
	always @ (posedge variable_clk) begin
		if (start_signal_reg) begin
			transfer_SR <= {{(burst_index-2){1'b0}}, 1'b1};
		end
		else begin
			transfer_SR <= {transfer_SR[burst_index-2:0], transfer_SR[burst_index-1]};
		end
	end
	
	genvar j;
	
	generate
	for (j=0; j<burst_index-1; j=j+1)
	begin : enable_2_SR_gen
	
		always @ (posedge variable_clk) begin
			if (start_signal) begin
				enable_2_SR[j+1] <= 1'b0;
			end
			else begin
				enable_2_SR[j+1] <= enable_2_SR[j];
			end
		end

	end
	endgenerate
	
	always @ (posedge variable_clk) begin
		if (start_signal_reg) begin
			enable_2_SR[0] <= 1'b0;
		end
		else begin
			enable_2_SR[0] <= enable_2;
		end
	end
	
	
	// start_signal_reg 
	// shift register for start_signal signal goes from slower clock domain to faster clock domain
	
	generate
	for (j=0; j<burst_index-1; j=j+1)
	begin : start_signal_SR_gen
	
		always @ (posedge variable_clk) begin
			if (start_signal) begin
				enable_2_SR[j+1] <= 1'b0;
			end
			else begin
				enable_2_SR[j+1] <= enable_2_SR[j];
			end
		end

	end
	endgenerate
	
	always @ (posedge variable_clk) begin
		if (start_signal_reg) begin
			enable_2_SR[0] <= 1'b0;
		end
		else begin
			enable_2_SR[0] <= enable_2;
		end
	end

	
	assign enable_2_reg = enable_2_SR[burst_index-2];
	
	assign start_signal_reg = start_signal_SR[burst_index-2];
	
	ramAddress #(address_width, max_ram_address, burst_index) ramAddress_1 (
		.clk(variable_clk_2),
		.ram_addr(ram_addr),
		.enable(enable_reg),
		.reset(reset_reg)
	);
	
	
	
	onChipRam #(no_of_digits, radix_bits, address_width, max_ram_address, burst_index) RAM_1(
		.clock(variable_clk_2),
		.address(ram_addr),
		.data(mem_in_reg),
		.wren(enable_2_reg&enable_reg),
		.q(mem_read)
	);
	
	memCopyDetector #(no_of_mem_bits) memCopyDetector_1(
		.data_in(mem_read[no_of_mem_bits-1:0]),
		.enable(enable_reg),
		.clk(variable_clk_2),
		.transfer_done(transfer_done)
	);
	
//	assign ctrl_clk = clkin_50;

	clockEnablePLL clk_enable_pll (
		.inclk(variable_clk),  //  altclkctrl_input.inclk
		.ena(enable_2_reg),    //                  .ena
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
	
	ctr_block #(address_width, max_ram_address, burst_index) ctr_block_1(
		.UserPushButton1(UserPushButton1),
		.variable_clk_2(variable_clk_2),
		.enable(enable),
		.enable_2(enable_2),
		.reset(reset),
		.start_signal(start_signal),
		.transfer_done(transfer_done)
	);
	
	always @ (posedge variable_clk_2) begin
		enable_reg = enable;
		reset_reg = reset;
	end
	
endmodule
