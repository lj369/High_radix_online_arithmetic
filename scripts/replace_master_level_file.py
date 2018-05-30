import generate_parameters as param_gen

def replaceMasterLevelFile(LFSR_SIZE, no_of_digits, radix ,burst_index, target_frequency):
    
    parameter_str = param_gen.generateParameterStr(LFSR_SIZE, no_of_digits, radix, burst_index, target_frequency);
    file_str = "`timescale 1 ps / 1 ps\n\n// mem max freq: 8*73 = 584MHz\n\nmodule masterLevel\n\n#(\n"
    file_str += parameter_str;
    file_str += ")\n\n(\n	clkin_125,\n);\n\n	localparam no_of_bits = no_of_digits * radix_bits;\n	\n	input wire clkin_125;\n	wire variable_clk;\n	wire variable_clk_2;\n	wire reset;\n\n//	assign clk = clk_100MHz;\n\n	\n	wire ctrl_clk;\n	wire [(no_of_digits+1)*radix_bits-1:0] DUT_out;\n	wire [(no_of_digits+1)*radix_bits*burst_index-1:0] mem_read;\n	wire [(no_of_digits+1)*radix_bits*burst_index-1:0] mem_in;\n	wire [(no_of_digits*2)*radix_bits-1:0] LFSR_out;\n	wire [no_of_bits-1:0] LFSR_out_1, LFSR_out_2;\n	wire [1:0] LFSR_out_3_pre;\n	wire [radix_bits-1:0] LFSR_out_3;\n	wire [no_of_digits*radix_bits-1:0] DUT_dout;\n	wire [radix_bits-1:0] DUT_cout;\n	wire [address_width-1:0] ram_addr;\n\n\n	wire pll_locked;\n	reg pll_rst;\n\n	wire enable;\n	wire enable_2;\n	wire enable_3;\n	wire transfer_done;\n	wire start_signal;\n	\n	\n//	LFSRBlock #(no_of_digits, LFSR_SIZE, 0, radix_bits) LFSR_1 (\n//		.clk(ctrl_clk),\n//		.enable(1'b1),\n////		.enable(enable_2),\n//		.out(LFSR_out_1)\n//	);\n//	\n//	LFSRBlock #(no_of_digits, LFSR_SIZE, 1451698946, radix_bits) LFSR_2 (\n//		.clk(ctrl_clk),\n//		.enable(1'b1),\n////		.enable(enable_2),\n//		.out(LFSR_out_2)\n//	);\n//	\n	LFSRBlock #(1, LFSR_SIZE, 1537598292, 2) LFSR_3 (\n		.clk(ctrl_clk),\n		.reset(start_signal),\n//		.enable(enable_2),\n		.out(LFSR_out_3_pre)\n	);\n	\n\n	\n	LFSRBlock #(no_of_digits+no_of_digits, LFSR_SIZE, 0, radix_bits) LFSR_1 (\n		.clk(ctrl_clk),\n		.reset(start_signal),\n//		.enable(enable_2),\n		.out(LFSR_out)\n	);\n	\n	assign LFSR_out_1 = LFSR_out[no_of_bits-1:0];\n	assign LFSR_out_2 = LFSR_out[no_of_bits*2-1:no_of_bits];\n	assign LFSR_out_3 = {{(radix_bits-2){LFSR_out_3_pre[1]}},LFSR_out_3_pre};\n	\n	radix4adder_new #(no_of_digits, radix_bits, radix) DUT_1(\n		.din1(LFSR_out_1),\n		.din2(LFSR_out_2),\n		.cin(LFSR_out_3),\n		.dout(DUT_dout),\n		.cout(DUT_cout)\n	);\n	\n	assign DUT_out = {DUT_cout, DUT_dout};\n\n//	assign DUT_out = {3'b000, LFSR_out_1};\n\n//	assign DUT_out = {13'd0, ram_addr};\n\n\n	concatenateDout #(no_of_digits, radix_bits, burst_index) concatenateDout_1 (\n		.Dout(DUT_out),\n		.variable_clk(ctrl_clk),\n		.mem_in(mem_in)\n	);\n	\n	ramAddress #(address_width, max_ram_address, burst_index) ramAddress_1 (\n		.clk(variable_clk_2),\n		.ram_addr(ram_addr),\n		.enable(enable),\n		.reset(reset)\n	);\n	\n	onChipRam #(no_of_digits, radix_bits, address_width, max_ram_address, burst_index) RAM_1(\n		.clock(variable_clk_2),\n		.address(ram_addr),\n		.data(mem_in),\n		.wren(enable_2&enable),\n		.q(mem_read)\n	);\n	\n	memCopyDetector #(no_of_mem_bits) memCopyDetector_1(\n		.data_in(mem_read[no_of_mem_bits-1:0]),\n		.enable(enable),\n		.clk(variable_clk),\n		.transfer_done(transfer_done)\n	);\n	\n//	assign ctrl_clk = clkin_50;\n\n	clockEnablePLL clk_enable_pll (\n		.inclk(variable_clk),  //  altclkctrl_input.inclk\n		.ena(enable_2),    //                  .ena\n		.outclk(ctrl_clk)  // altclkctrl_output.outclk\n	);\n	\n//	assign variable_clk = clkin_50;\n	\n	pll3 #(target_frequency, target_frequency_2) pll_2(\n		.refclk(clkin_125),   //  refclk.clk\n		.rst(pll_rst),      //   reset.reset\n		.outclk_0(variable_clk), // outclk0.clk\n		.outclk_1(variable_clk_2),\n		.locked(pll_locked) \n	);\n	\n\n	ctr_block #(address_width, max_ram_address, burst_index) ctr_block_1(\n		.variable_clk_2(variable_clk_2),\n		.enable(enable),\n		.enable_2(enable_2),\n		.reset(reset),\n		.start_signal(start_signal),\n		.transfer_done(transfer_done)\n	);\n	\n	\nendmodule\n"
    master_file = open("../src/masterLevel.v", "w");
    master_file.write(file_str);
    master_file.close();

def main():
    LFSR_SIZE = 32;
    no_of_digits = 8;
    radix = 4;
    burst_index = 8;
    target_frequency = 400;
    replaceMasterLevelFile(LFSR_SIZE, no_of_digits, radix ,burst_index, target_frequency);



if __name__ == "__main__":
    main();
