module top_module
#(
	parameter LFSR_SIZE = 32,
	parameter no_of_digits = 10,
	parameter radix_bits = 3, // = 1+log2(radix) 
	parameter radix = 4,
	parameter no_of_mem_bits = 3,
	parameter address_width = 10, // = floor(log2(floor(5662720/(no_of_digits+1)/radix_bits/burst_index))) 
	parameter max_ram_address = 1024, // = 2^address_width 
	parameter burst_index = 5,
	parameter target_frequency = "250.000000 MHz",
	parameter target_frequency_2 = "50.000000 MHz" // = target_frequency/burst_index 
)

(
	clkin_50,
	UserPushButton1,
	UserLED1,
	UserLED2,
	UserLED3,
	UserLED4
);
	
	input wire clkin_50;
	input wire UserPushButton1;
	wire clk;
	wire variable_clk_f;
	wire variable_clk_s;
	wire ctrl_clk;
	wire start_signal;
	reg pll_lock_en;
	wire enable;
	wire pll_locked;
	
	
	assign clk = clkin_50;
	
	// LED signals are active low 
	output wire UserLED1; // start signal indicator -- on when not started
	output wire UserLED2; // button indicator -- on when button is pressed
	output wire UserLED3; // calculation done indicator -- connected to signal "enable" in module "masterlevel"
	output reg UserLED4; // pll lock indicator
	
	wire UserPushButton1_inv;
	
//	assign UserLED2 = UserPushButton1;
	assign UserPushButton1_inv = ~UserPushButton1;
	
	pll3 #(target_frequency, target_frequency_2) pll_2(
		.refclk(clk),   //  refclk.clk
		.rst(pll_rst),      //   reset.reset
		.outclk_0(variable_clk_f), // outclk0.clk
		.outclk_1(variable_clk_s),
		.locked(pll_locked) 
	);

//	pll_250_50MHz pll_3(
//		.refclk(clk),   //  refclk.clk
//		.rst(pll_rst),      //   reset.reset
//		.outclk_0(variable_clk), // outclk0.clk
//		.outclk_1(variable_clk_2),
//		.locked(pll_locked) 
//	);
	
	assign UserLED1 = ~start_signal;	
	assign UserLED2 = pll_lock_en;
	
	reg pll_lock_sm;
	reg [3:0] counter;
	
	initial begin
		UserLED4 = 1'b1;
		pll_lock_en = 1'b1;
		counter = 3'b0;
	end
	
	
	always @ (pll_locked) begin
		if (~pll_locked) UserLED4 = 1'b0;
		else UserLED4 = 1'b1;
		if (pll_lock_sm & ~pll_locked) pll_lock_en <= 1'b0;
		if (~pll_lock_sm) pll_lock_en <= 1'b1;
	end
	
//	always @ (posedge enable) begin
//		pll_lock_sm = 1'b1;
//		counter = counter + 3'b1;
//	end

	wire [3:0] pll_relock_count;

	SRIncrementer #(4) SRIncrementer_Inst_1(
		.clk(pll_locked),
		.out(pll_relock_count),
		.enable(1'b1),
		.reset(1'b0)
	);
	
	always @ (posedge clk) begin
		counter = pll_relock_count;
	end


//-------------------------------------------------	
	// old master level instantiation
//	
////	masterLevelOneClkDomain
//	masterLevel
//	#(
//		LFSR_SIZE, 
//		no_of_digits, 
//		radix_bits, 
//		radix, 
//		no_of_mem_bits, 
//		address_width, 
//		max_ram_address, 
//		burst_index, 
//		target_frequency, 
//		target_frequency_2
//	)
//	masterLevel_Inst(
//	.UserPushButton1(UserPushButton1_inv),
//	.start_signal(start_signal),
//	.enable(enable),
//	.UserLED3(UserLED3),
//	.variable_clk(variable_clk),
//	.variable_clk_2(variable_clk_2),
//	.ctrl_clk(ctrl_clk)
//	);
//-------------------------------------------------	

	masterLevelNew
	#(
		LFSR_SIZE, 
		no_of_digits, 
		radix_bits, 
		radix, 
		no_of_mem_bits, 
		address_width, 
		max_ram_address, 
		burst_index, 
		target_frequency, 
		target_frequency_2
	)
	masterLevel_Inst(
	.UserPushButton1(UserPushButton1_inv),
	.start_signal(start_signal),
	.enable(enable),
	.UserLED3(UserLED3),
	.variable_clk_f(variable_clk_f),
	.variable_clk_s(variable_clk_s),
	.ctrl_clk(ctrl_clk)
	);


endmodule
