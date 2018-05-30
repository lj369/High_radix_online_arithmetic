`timescale 1 ps / 1 ps

module masterLevelHPS

#(
	parameter LFSR_SIZE = 32,
	parameter INIT_OFFSET = 0,
	parameter no_of_digits = 8,
	parameter radix_bits = 3,
	parameter radix = 4,
	parameter address_width = 14,
	parameter no_of_mem_bits = 2,
	parameter max_ram_address = 16384,
	// avalon interface parameter
	parameter DATAWIDTH = 32,
	parameter BYTEENABLEWIDTH = 4,
	parameter ADDRESSWIDTH = 32,
	parameter FIFODEPTH = 16384,
	parameter FIFODEPTH_LOG2 = 14,
	parameter FIFOUSEMEMORY = 1
)

(
	variable_clk,
	avalon_MM_master_address,
	avalon_MM_master_write,
	avalon_MM_master_byteenable,
	avalon_MM_master_writedata,
	avalon_MM_master_waitrequest,
	avalon_MM_clk,
);

	localparam no_of_bits = no_of_digits * radix_bits;
	
	
	input avalon_MM_master_waitrequest;
	output wire [ADDRESSWIDTH-1:0] avalon_MM_master_address;
	output wire avalon_MM_master_write;
	output wire [BYTEENABLEWIDTH-1:0] avalon_MM_master_byteenable;
	output wire [DATAWIDTH-1:0] avalon_MM_master_writedata;
	input avalon_MM_clk;
	wire avalon_MM_reset;
	
	input wire variable_clk;
//	wire variable_clk;
	reg reset;

	integer counter;
//	assign clk = clk_100MHz;

	
	wire ctrl_clk;
	wire [(no_of_digits+1)*radix_bits-1:0] DUT_out;
	wire [(no_of_digits+1)*radix_bits-1:0] mem_read;
	wire [no_of_bits-1:0] LFSR_out_1, LFSR_out_2;
	wire [radix_bits-1:0] LFSR_out_3;
	wire [no_of_digits*radix_bits-1:0] DUT_dout;
	wire [radix_bits-1:0] DUT_cout;
	wire [address_width-1:0] ram_addr;
	reg enable;
	wire transfer_done;
	wire pll_locked;
	reg pll_rst;

	
	LFSRBlock #(no_of_digits, LFSR_SIZE, INIT_OFFSET, radix_bits) LFSR_1 (
		.clk(ctrl_clk),
//		.enable(1'b1),
		.enable(enable),
		.out(LFSR_out_1)
	);
	
	LFSRBlock #(no_of_digits, LFSR_SIZE, INIT_OFFSET, radix_bits) LFSR_2 (
		.clk(ctrl_clk),
//		.enable(1'b1),
		.enable(enable),
		.out(LFSR_out_2)
	);
	
	LFSRBlock #(1, LFSR_SIZE, INIT_OFFSET, radix_bits) LFSR_3 (
		.clk(ctrl_clk),
//		.enable(1'b1),
		.enable(enable),
		.out(LFSR_out_3)
	);
	
	radix4adder_new #(no_of_digits, radix_bits, radix) DUT_1(
		.din1(LFSR_out_1),
		.din2(LFSR_out_2),
		.cin(LFSR_out_3),
		.dout(DUT_dout),
		.cout(DUT_cout)
	);
	
	
	assign DUT_out = {DUT_cout, DUT_dout};
	
//	ramAddress #(address_width, max_ram_address) ramAddress_1 (
//		.clk(variable_clk),
//		.ram_addr(ram_addr),
//		.enable(enable),
//		.reset(reset)
//	);

	avalon_MM_write_master avalon_MM_write_master_1(
		clk,
		reset,
		
		// control inputs and outputs
		control_fixed_location,
		control_write_base,
		control_write_length,
		control_go,
		control_done,
		
		// user logic inputs and outputs
		user_write_buffer,
		user_buffer_data,
		user_buffer_full,
		
		// master inputs and outputs
		master_address,
		master_write,
		master_byteenable,
		master_writedata,
		master_waitrequest
	);

	
	memCopyDetector #(1) memCopyDetector_1(
		.data_in(mem_read),
		.enable(enable),
		.clk(variable_clk),
		.transfer_done(transfer_done)
	);
	
	clockEnablePLL clk_enable_pll (
		.inclk(variable_clk),  //  altclkctrl_input.inclk
		.ena(enable),    //                  .ena
		.outclk(ctrl_clk)  // altclkctrl_output.outclk
	);
	
	
	initial begin
		counter = 0;
//		enable = 1'b0;
//		#100 enable = 1'b1;
		enable = 1'b0;
		reset = 1'b0;
		
	end

	
	always @ (posedge variable_clk)
	begin : ctrl_block
		if (reset == 1'b1) begin
			reset = 1'b0;
		end
		if (transfer_done) begin
			counter = 0;
			reset = 1'b1;
		end
		if (counter <16382) begin
			counter = counter + 1;
			enable = 1'b1;
		end
		else begin
			enable = 1'b0;
		end
	end
	
	
	
endmodule
