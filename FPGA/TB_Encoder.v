`timescale 1ns / 1ps


module TB_Encoder;

	// Inputs
	reg reset;
	reg Clk;
	reg start;

	// Outputs
	wire [2:0] Code;
	wire [5:0] start_x;
	wire [5:0] start_y;
	wire [11:0] Area;
	wire [7:0] Permiter;
	wire Done;
	wire Error;

	// Instantiate the Unit Under Test (UUT)
	Encoder uut (
		.reset(reset), 
		.Clk(Clk), 
		.start(start), 
		.Code(Code), 
		.start_x(start_x), 
		.start_y(start_y), 
		.Area(Area), 
		.Permiter(Permiter), 
		.Done(Done), 
		.Error(Error)
	);

	initial begin

		reset = 1;
		Clk = 0; 
		start = 1;

		#16;
        
		reset = 0;
	end
      
		
	always #1 Clk = ~Clk;
endmodule

