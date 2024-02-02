module UART_Transmit  #(parameter ClkFreq = 50000000,  B_Rate = 9600)
  (
   input       Clk,
	input 		reset,
   input       T_EN,
   input [7:0] Data,
   output reg  Serial,
   output reg  Transmit_Done
   );
// ================Module Paramaters==================== 
  localparam IDLE         = 4'b0000;
  localparam START_BIT    = 4'b0001;
  localparam DATA_BIT0    = 4'b0010;
  localparam DATA_BIT1    = 4'b0011;
  localparam DATA_BIT2    = 4'b0100;
  localparam DATA_BIT3    = 4'b0101;
  localparam DATA_BIT4    = 4'b0110;
  localparam DATA_BIT5    = 4'b0111;
  localparam DATA_BIT6    = 4'b1000;
  localparam DATA_BIT7    = 4'b1001;
  localparam STOP_BIT0    = 4'b1010;
  localparam STOP_BIT1    = 4'b1011;
  localparam CLEANUP      = 4'b1100;
   
	
	localparam CLKS_PER_BIT = ClkFreq / B_Rate;	
//----------------Module Variables -----------------
	reg [03:00] state;
	reg [31:00] clk_count;
//================= Main Code ======================

	always @( posedge Clk ) begin 
		if ( reset ) begin 
			state 						<= IDLE;
			clk_count					<= 32'd0;
			Serial   					<= 1'b1;
		end else begin 
			if ( clk_count == CLKS_PER_BIT - 1 ) begin 
				case ( state ) 
					IDLE : begin 
					Transmit_Done		<= 	1'b0;
						if ( T_EN ) begin 
							state			<=		START_BIT;
						end
					end
					
					START_BIT: begin
						Serial			<=		1'b0;
						state				<=		DATA_BIT0;
					end
					DATA_BIT0: begin 
						Serial			<=		Data[0];
						state				<= 	DATA_BIT1;
					end 
					DATA_BIT1:begin 
						Serial			<=		Data[1];
						state				<= 	DATA_BIT2;
					end
					DATA_BIT2:begin 
						Serial			<=		Data[2];
						state				<= 	DATA_BIT3;
					end
					DATA_BIT3:begin 
						Serial			<=		Data[3];
						state				<= 	DATA_BIT4;
					end
					DATA_BIT4:begin 
						Serial			<=		Data[4];
						state				<= 	DATA_BIT5;
					end
					DATA_BIT5:begin 
						Serial			<=		Data[5];
						state				<= 	DATA_BIT6;
					end	
					DATA_BIT6:begin 
						Serial			<=		Data[6];
						state				<= 	DATA_BIT7;
					end
					DATA_BIT7:begin 
						Serial			<=		Data[7];
						state				<= 	STOP_BIT0;
					end
					STOP_BIT0: begin 
						Serial			<=		1'b1;
						state				<= 	STOP_BIT1;					
					end
					STOP_BIT1: begin 
						Serial			<=		1'b1;
						state				<= 	CLEANUP;					
					end
					CLEANUP: begin 
						state				<=		 IDLE;
						Transmit_Done	<= 	 1'b1;
						clk_count		<= 	 32'd0;
						
					end
				endcase 
			end else begin 
				clk_count <= clk_count + 1;
			end
		end 
	end
endmodule
