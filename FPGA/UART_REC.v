
module UART_REC #(parameter ClkFreq = 50000000,  B_Rate = 9600)
  (
   input       Clk,
	input 		reset,
   input       R_EN,
   input 	   Serial,
   output reg  [7:0]Data,
   output reg  Recieve_Done
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
  
  
	localparam CLKS_PER_BIT = ClkFreq /(2 * B_Rate);	
	
	//----------------Module Variables -----------------
	reg [03:00] state;
	reg [31:00] clk_count;
	//================= Main Code ======================

	always @( posedge Clk ) begin 
		Recieve_Done		<= 	1'b0;
		if ( reset ) begin 
			state 						<= IDLE;
			clk_count					<= 32'd0;
			Data      					<= 8'd0;
			Recieve_Done				<= 1'b1;
		end else begin 
			if ( clk_count == CLKS_PER_BIT - 1 ) begin 
				case ( state ) 
					IDLE : begin 
						if ( R_EN ) begin 
							state			<=		START_BIT;
						end
					end
					
					START_BIT: begin
						if ( !Serial ) begin
							state				<=		DATA_BIT0;
						end 
					end
					DATA_BIT0: begin 
						Data[0]			<=		Serial;
						state				<= 	DATA_BIT1;
					end 
					DATA_BIT1:begin 
						Data[1]			<=		Serial;
						state				<= 	DATA_BIT2;
					end
					DATA_BIT2:begin 
						Data[2]			<=		Serial;
						state				<= 	DATA_BIT3;
					end
					DATA_BIT3:begin 
						Data[3]			<=		Serial;
						state				<= 	DATA_BIT4;
					end
					DATA_BIT4:begin 
						Data[4]			<=		Serial;
						state				<= 	DATA_BIT5;
					end
					DATA_BIT5:begin 
						Data[5]			<=		Serial;
						state				<= 	DATA_BIT6;
					end	
					DATA_BIT6:begin 
						Data[6]			<=		Serial;
						state				<= 	DATA_BIT7;
					end
					DATA_BIT7:begin 
						Data[7]			<=		Serial;
						state				<= 	STOP_BIT0;
					end
					STOP_BIT0: begin 
						state				<= 	STOP_BIT1;					
					end
					STOP_BIT1: begin 
						state				<= 	CLEANUP;					
					end
					CLEANUP: begin 
						state				<=		 IDLE;
						Recieve_Done	<= 	 1'b1;
					end
				endcase 
			end else begin 
				clk_count <= clk_count + 1;
			end
		end 
	end
endmodule

