module FPGA_Reciever(
	input clk
    );

	UART_Transmit uart (
		 .Clk(Clk), 
		 .reset(reset), 
		 .T_EN(T_EN), 
		 .Data(Data), 
		 .Serial(Serial), 
		 .Transmit_Done(Transmit_Done)
		 );


	Encoder encoder (
		 .reset(reset), 
		 .Clk(Clk), 
		 .start(start), 
		 .Code(Code), 
		 .start_x(start_x), 
		 .start_y(start_y), 
		 .Area(Area), 
		 .Perimiter(Perimiter), 
		 .Done(Done), 
		 .Error(Error)
		 );
endmodule
