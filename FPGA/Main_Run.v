

module Main_Run;

	// Inputs
	reg Clk;
	reg reset;

	// Instantiate the Unit Under Test (UUT)
	Main uut (
		.Clk(Clk), 
		.reset(reset)
	);

	initial begin
		// Initialize Inputs
		Clk = 0;
		reset = 1;

		// Wait 100 ns for global reset to finish
		#10;
		// Add stimulus here
		reset = 0;

	end
	
	always #1 Clk = ~Clk;
      
endmodule

