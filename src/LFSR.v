module LFSR 
#(
	parameter WIDTH = 32,
	parameter PRESET = {WIDTH{1'b1}}
)

(
	input clk,
	input reset,
//	input enable,
	output reg [WIDTH-1:0] out = PRESET
);



	reg [WIDTH-1:0] feedbackmask;

   /*(* romstyle = "logic" *)*/ reg [168:0] rom [255:0];

   initial
   begin
		$readmemb("C:\\Users\\J_Lian\\Desktop\\FYP\\src\\LFSR_taps.dat", rom);
   end

   always @ (*)
   begin
		feedbackmask <= rom[WIDTH][WIDTH-1:0];
   end

	wire feedback;
	assign feedback = ~^(out & feedbackmask);

	initial begin
		out <= PRESET;
	end
	
	
	always @ (posedge clk)
	begin
//		if (!enable)
//			out <= out;
//		else if (reset)
		if (reset)
			out <= PRESET;
		else
			out <= {out[WIDTH-2:0], feedback};
	end

endmodule

