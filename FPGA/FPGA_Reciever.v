module FPGA_Reciever(
							input Clk,
							input reset,
							input inputStream
    );

//----------------------------------------------------------
//--------------------Modeule Variable ---------------------
	reg [2:0] state;
	reg [7:0] buffer [00:269];
	reg [8:0] buffer_index;
	//+++++++++++++++++++++ Encoder Variables ++++++++++++++++++
		reg  start;
		wire DnDone, DnError;
		wire pixel;
		reg  [5:0] start_x, start_y;
		reg  [2:0] DnCode;
		reg  [11:00] DnArea;
		reg  [07:00] DnPerimiter;
	
	//+++++++++++++++++++ UART  Variables +++++++++++++++++++++
		reg 	Recieve_EN;
		wire  [7:0] UART_data;
		wire  Recieve_Done;
		
	
//----------------------------------------------------------
//-------------------Module parameter-----------------------

	localparam	Start_State			 = 	3'b000;
	localparam  Set_Start_X_Y		 = 	3'b001;
	localparam  Get_Code				 = 	3'b010;
	localparam 	Get_Area_Perimiter = 	3'b011;
	localparam	UART					 = 	3'b100;
	localparam	Done_With_That		 = 	3'b101;
// ==========================================================
// =======================Module Functionality ==============

	always  @ ( posedge Clk ) begin 
		if ( reset ) begin 
		
			state 						<= Start_State ;
			start							<= 1'b0;
			buffer_index				<= 9'd5;
			Recieve_EN					<= 1'b0;
			UART_data					<= 8'd0;
			DnPerimiter					<= 8'd0;
			DnArea						<= 12'd0;
			start_x						<= 6'd0;
			start_y						<= 6'd0;
			DnCode						<= 3'd0;
			buffer[0] 					<= 8'b0000_0000;
		end else begin 
			case ( state )
				Start_State:begin 
					Recieve_EN			<= 1'b1;
					state					<= UART;
				end 
				UART: begin 
					if ( Recieve_Done ) begin 
						buffer[buffer_index]				<= UART_data;
						buffer_index						<= buffer_index + 1'b1;
						Recieve_EN							<= !(&buffer[buffer_index]);
					end
					if ( !Recieve_EN ) begin 
						state									<= Set_Start_X_Y;
					end
				end	
				Set_Start_X_Y:begin
					start_x[5:3] 			<= buffer[1][2:0];
					start_x[2:0]  			<= buffer[2][2:0];
					start_y[5:3]  			<= buffer[3][2:0];
					start_y[2:0] 			<= buffer[4][2:0];
					
					buffer_index			<= 3'd5;
					state						<= Get_Code;
				end	

				Get_Code: begin 

					if (  buffer[buffer_index][7:4] == 4'b0110  ) begin 
						state					 <= Get_Area_Perimiter;
					end	else begin 
						EnCodebuffer[buffer_index]	 <=	buffer[buffer_index][2:0];
						buffer_index			 		 <= 	buffer_index + 1'b1;
					end 
				end 	
				Get_Area_Perimiter: begin 
					DnArea[11:8]			<= buffer[buffer_index + 0][3:0];
					DnArea[7:4] 			<= buffer[buffer_index + 1][3:0];
					DnArea[3:0] 			<= buffer[buffer_index + 2][3:0];
					DnPerimiter[7:4] 		<= buffer[buffer_index + 3][3:0];
					DnPerimiter[3:0]		<= buffer[buffer_index + 4][3:0];
					DnError					<= buffer[buffer_index + 5][0];

					start						<= 1'b1;
					start 					<= Done_With_That;
				end					
				Done_With_That: begin 
				
				end				
			endcase
		end 
	end		
// ==================================================
// ============== Modules Instance ==================

	UART_REC uart_r (
		 .Clk(Clk), 
		 .reset(reset), 
		 .R_EN(Recieve_EN), 
		 .Serial(inputStream), 
		 .Data(UART_data), 
		 .Recieve_Done(Recieve_Done)
    );
	 
	Decoder instance_name (
		 .Code(DnCode), 
		 .reset(reset), 
		 .Clk(Clk), 
		 .start(start), 
		 .Perimeter(DnPerimiter), 
		 .Area(DnArea), 
		 .start_pixel_x(start_x), 
		 .start_pixel_y(start_y), 
		 .Done(DnDone), 
		 .Error(DnError), 
		 .Pixels(pixel)
		);
// ==================================================
endmodule



					

				

				


