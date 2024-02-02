`timescale 1ns / 1ps



module FPGA_Sender(
							input Clk, 
							input reset,
							output UART_Out
    );

//----------------------------------------------------------
//--------------------Modeule Variable ---------------------
	reg [2:0] state;
	reg [7:0] buffer [00:269];
	reg [8:0] buffer_index;
	
	//+++++++++++++++++++++ Encoder Variables ++++++++++++++++++
		reg  start;
		wire EnDone, EnError;
		wire [5:0] start_x, start_y;
		wire [2:0] EnCode;
		wire [11:00] EnArea;
		wire [07:00] EnPerimiter;
	
	//+++++++++++++++++++ UART  Variables +++++++++++++++++++++
		reg 	Transmit_EN;
		reg   [7:0] UART_data;
		wire  Trans_Done;
		
//----------------------------------------------------------
//-------------------Module parameter-----------------------

	localparam	Start_State			= 	3'b000;
	localparam  Set_Start_X_Y		= 	3'b001;
	localparam  Get_Code				= 	3'b010;
	localparam 	Get_Area_Perimiter= 	3'b011;
	localparam	UART					= 	3'b100;
	localparam	Done_With_That		= 	3'b101;

// =======================Module Functionality ==============
	always  @ ( posedge Clk ) begin 
		if ( reset ) begin 
			state 						<= Start_State ;
			start							<= 1'b0;
			buffer_index				<= 9'd5;
			Transmit_EN					<= 1'b0;
			UART_data					<= 8'd0;
		end else begin 
			case ( state )
				Start_State:begin 
					start					<= 1'b1;
					buffer[0]			<= 8'b0000_0000;
					state				<= Set_Start_X_Y;
					
				end
				Set_Start_X_Y:begin
					buffer[1]			<= {5'b00010, start_x[5:3]};
					buffer[2] 			<= {5'b00100, start_x[2:0]};
					buffer[3] 			<= {5'b00110, start_y[5:3]};
					buffer[4]			<= {5'b01000, start_y[2:0]};
					if ( EnDone ) begin 
						state			<= Get_Code;
					end 
				end
				Get_Code: begin 
					buffer[buffer_index]	 <=	{5'b01010, EnCode};
					buffer_index			 <= 	buffer_index + 1'b1;
					if ( EnDone ) begin 
						state					 <= Get_Area_Perimiter;
					end	
				end
				Get_Area_Perimiter: begin 
					buffer[buffer_index + 0]			<= {5'b0110, EnArea[11:8]};
					buffer[buffer_index + 1] 			<= {5'b0111, EnArea[7:4]};
					buffer[buffer_index + 2] 			<= {5'b1000, EnArea[3:0]};
					buffer[buffer_index + 3] 			<= {5'b1001, EnPerimiter[7:4]};
					buffer[buffer_index + 4]			<= {5'b1010, EnPerimiter[3:0]};
					buffer[buffer_index + 5]			<= {5'b1011, {4{EnError}}};

					state 								<= UART;
					buffer[buffer_index + 3'b110] <= 8'b1111_1111;
					buffer_index 						<= 9'd1;
					Transmit_EN							<= 1'b1;
					UART_data							<= buffer[0];
 
				end
				UART: begin 
					if ( Trans_Done ) begin 
						UART_data							<= buffer[buffer_index];
						buffer_index						<= buffer_index + 1'b1;
						Transmit_EN							<= !(&buffer[buffer_index]);
					end
					if ( !Transmit_EN ) begin 
						state									<= Done_With_That;
					end
				end	
				Done_With_That: begin 
				
				end
			endcase
		end 
	end
// =========================================================
// =====================Module Instantiate =================
	UART_Transmit uart (
		 .Clk(Clk), 
		 .reset(reset), 
		 .T_EN(Transmit_EN), 
		 .Data(UART_data), 
		 .Serial(UART_Out), 
		 .Transmit_Done(Trans_Done)
		 );


	Encoder encoder (
		 .reset(reset), 
		 .Clk(Clk), 
		 .start(start), 
		 .Code(EnCode), 
		 .start_x(start_x), 
		 .start_y(start_y), 
		 .Area(EnArea), 
		 .Perimiter(EnPerimiter), 
		 .Done(EnDone), 
		 .Error(EnError)
		 );
endmodule
