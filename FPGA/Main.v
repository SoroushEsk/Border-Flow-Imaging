module Main( input Clk , input reset );




//=============== Module Variable ===============

	wire UART_Out ;
	wire [7:0] Data;
	wire Recieve_Done;
	
//--------------- Instance Section ----------------
	FPGA_Sender sender (
		 .Clk(Clk), 
		 .reset(reset), 
		 .UART_Out(UART_Out)
		 );
		 
	UART_REC uart_r (
    .Clk(Clk), 
    .reset(reset), 
    .R_EN(1), 
    .Serial(UART_Out), 
    .Data(Data), 
    .Recieve_Done(Recieve_Done)
    );


endmodule
