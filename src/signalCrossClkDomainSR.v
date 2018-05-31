module signalCrossClkDomainSR
#(
	parameter burst_index = 5,
	parameter default_setting = {burst_index{1'b0}}
)

(
	signal_in,
	clk,
	reset,
	signal_out

);

	input wire signal_in;
	input wire clk;
	input wire reset;
	output wire signal_out;

	reg [burst_index-1:0] SR;
	
	initial begin
		SR = default_setting;
	end

	always @ (posedge clk) begin
		if (reset) SR <= {burst_index{1'b0}};
		else begin
			SR <= {SR[burst_index-2:0], signal_in};
		end
	end

	assign signal_out = SR[burst_index-1];


endmodule
