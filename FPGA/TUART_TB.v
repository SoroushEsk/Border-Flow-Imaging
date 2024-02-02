module TUART_TB;

	// Inputs
	reg Clk;
	reg reset;
	reg T_EN;
	reg [7:0] Data;

	// Outputs
	wire Serial;
	wire Transmit_Done;

	// Instantiate the Unit Under Test (UUT)
	UART_Transmit uut (
		.Clk(Clk), 
		.reset(reset), 
		.T_EN(T_EN), 
		.Data(Data), 
		.Serial(Serial), 
		.Transmit_Done(Transmit_Done)
	);

	initial begin
		// Initialize Inputs
		Clk = 0;
		reset = 1;
		T_EN = 0;
		Data = 62;

		// Wait 100 ns for global reset to finish
		#3;
        
		T_EN = 1;
		reset = 0;
		// Add stimulus here
	
	end
   always @ ( posedge Transmit_Done )begin 
		Data = Data + 1;
	end 
	always #1 Clk =~Clk; 
endmodule

