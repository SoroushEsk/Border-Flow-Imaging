module FPGA_Sen_TB;

	// Inputs
	reg Clk;
	reg reset;

	// Outputs
	wire UART_Out;

	// Instantiate the Unit Under Test (UUT)
	FPGA_Sender uut (
		.Clk(Clk), 
		.reset(reset), 
		.UART_Out(UART_Out)
	);

	initial begin
		// Initialize Inputs
		Clk = 0;
		reset = 1;

		// Wait 100 ns for global reset to finish
		#10;
		reset = 0;
        
		// Add stimulus here

	end
   always #1 Clk = ~Clk;
endmodule

