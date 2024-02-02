module Decoder (
						 input [2:0] Code,
						 input reset,
						 input Clk,
						 input start, 
						 input [7:0] Perimeter,
						 input [11:0] Area,
						 input [6:0] start_pixel_x,
						 input [6:0] start_pixel_y,
						 output reg Done,
						 output reg Error,
						 output reg Pixels
  );

// --- Parameter Decluration ---- 
	parameter Initial       = 0;
	parameter StartPoint    = 1;
	parameter FindCode      = 2;
	parameter FindArea      = 3;
	parameter DoneAnalysing = 4; 
	 
// --- Picture Inst ----

	reg [5:0] addr1;
	wire [63:00] data1;
	reg [63:00] w_data;
	reg writeSignal;

	CreatedImage result  (
	  .clka(clka), // input clka
	  .wea(wea), // input [0 : 0] wea
	  .addra(addra), // input [5 : 0] addra
	  .dina(dina), // input [63 : 0] dina
	  .douta(douta), // output [63 : 0] douta
	  .clkb(clkb), // input clkb
	  .web(web), // input [0 : 0] web
	  .addrb(addrb), // input [5 : 0] addrb
	  .dinb(dinb), // input [63 : 0] dinb
	  .doutb(doutb) // output [63 : 0] doutb
	);
	 
// ------ Decluration ----------
	reg [2:0] state;
	reg [7:0] perimiterCounter;
	reg EnDone, EnError;
	
	reg [5:0] row, col;
	reg findStart;
	reg carry ;
	
// ----- set start x and y -------

	wire borrow;
	reg borrow_current;
	assign {borrow, start_x}  = {1'b0, col} - 1'b1;
	assign start_y            = row - borrow;
// ----- set Done -----------
	assign Error = EnError;
	assign Done  = EnDone;
// ------- current point -------

	reg [5:0] r_current_py, r_current_px;
	
// ------- Code matrix 
	
	reg isStart;
	reg [2:0] EnCode;
	assign Code = EnCode;
// -------- Find Perimiter --------

	reg [7:0]  EnPerimiter;
	assign Perimiter = EnPerimiter;
	
	
// -------- Done Counting Area ----

	reg [11:00] EnAreaCounter;
	reg [05:00] row_a, col_a;
	reg carry_a;
	assign Area = EnAreaCounter;
	reg AreaCalculated;
	reg cellAmount;
	
//-------------
	always @ ( posedge Clk ) begin 
		if ( reset ) begin 
			perimiterCounter <= 8'b0000_0000;
			EnDone           <= 1'b0;
			EnError          <= 1'b0;
			state				  <= Initial;
			row              <= 6'b000_000;
			col              <= 6'b000_000;
			findStart        <= data1[63 - col];
			addr1            <= 6'b000_000;
			EnDone           <= 1'b0;
			EnError          <= 1'b0;
			borrow_current   <= 1'b1;
			isStart          <= 1'b0;
			EnPerimiter      <= 8'b0000_0000;
			EnCode           <= 3'b000;
			AreaCalculated   <= 1'b0;
			EnAreaCounter    <= 12'b0000_0000_0000;
			cellAmount		  <= 1'b0;
			row_a		        <= 6'd0;
			col_a				  <= 6'd0;
			carry_a			  <= 1'b0;
			w_data			  <= 64'd0;
			writeSignal		  <= 1'b1;
		end else begin 
			case ( state ) 
				 Initial : begin 
					addr1      <= start_pixel_y;
					if ( start ) state    <= StartPoint;
				 end 
				 StartPoint : begin 
					w_data	  <= 
				 end // necessary to look for code error
				 				 

				 FindCode :begin 
					isStart     <= 1'b1;
					EnPerimiter <= EnPerimiter + 1'b1;
					EnDone      <= 1'b0;
					if          (w_matrix[0] & !w_matrix[1] ) begin // ------------------Code is 0------------------
					
						r_current_px    <=    r_current_px  +  1'b1;
						addr1           <=    r_current_py - 2;
						EnCode          <=    3'b000; 
						
					end else if (w_matrix[1] & !w_matrix[2] ) begin // ------------------Code is 1------------------
					
						r_current_py    <=    r_current_py  -  1'b1;
						r_current_px    <=    r_current_px  +  1'b1;
						r_row_0         <=    data1;
						r_row_1         <=    r_row_0;
						r_row_2         <=    r_row_1;
						addr1           <=    addr1 - 1'b1;
						addr2           <=    addr2 - 1'b1;
						EnCode          <=    3'b001; 
											
					end else if (w_matrix[2] & !w_matrix[3] ) begin // ------------------Code is 2------------------
					
						r_current_py    <=    r_current_py  -  1'b1;
						r_row_0         <=    data1;
						r_row_1         <=    r_row_0;
						r_row_2         <=    r_row_1;
						addr1           <=    addr1 - 1'b1;
						addr2           <=    addr2 - 1'b1;
						EnCode          <=    3'b010; 
						
					end else if (w_matrix[3] & !w_matrix[4] ) begin // ------------------Code is 3------------------
					
						r_current_py    <=    r_current_py  -  1'b1;
						r_current_px    <=    r_current_px  -  1'b1;
						r_row_0         <=    data1;
						r_row_1         <=    r_row_0;
						r_row_2         <=    r_row_1;
						addr1           <=    addr1 - 1'b1;
						addr2           <=    addr2 - 1'b1;
						EnCode          <=    3'b011; 
											
					end else if (w_matrix[4] & !w_matrix[5] ) begin // ------------------Code is 4------------------
					
						r_current_px    <=    r_current_px  -  1'b1;
						EnCode          <=    3'b100; 
					
					end else if (w_matrix[5] & !w_matrix[6] ) begin // ------------------Code is 5------------------
						

						r_current_px    <=    r_current_px  -  1'b1;						
						r_current_py    <=    r_current_py  +  1'b1;
						r_row_0         <=    r_row_1;
						r_row_1         <=    r_row_2;
						r_row_2         <=    data2;
						addr1           <=    r_current_py - 2;
						addr2           <=    addr2 + 1'b1;
						EnCode          <=    3'b101; 
						
					end else if (w_matrix[6] & !w_matrix[7] ) begin // ------------------Code is 6------------------
					
						r_current_py    <=    r_current_py  +  1'b1;
						r_row_0         <=    r_row_1;
						r_row_1         <=    r_row_2;
						r_row_2         <=    data2;
						addr1           <=    r_current_py - 2;
						addr2           <=    addr2 + 1'b1;
						EnCode          <=    3'b110; 
						
					end else if (w_matrix[7] & !w_matrix[0] ) begin // ------------------Code is 7------------------
					
						r_current_py    <=    r_current_py  +  1'b1;
						r_current_px    <=    r_current_px  +  1'b1;
						r_row_0         <=    r_row_1;
						r_row_1         <=    r_row_2;
						r_row_2         <=    data2;
						addr1           <=    r_current_py - 2;
						addr2           <=    addr2 + 1'b1;		
						EnCode          <=    3'b11; 
						
					end else begin                                  // There is and error accured
						EnError  <=  1'b1;
					end
					
					if ( isStart ) begin 
						
						if ( r_current_px == start_x && r_current_py == start_y ) begin 
							EnDone   <= 1'b1;
							state    <= FindArea;
							
						end
					end 
				 end 
				 FindArea:begin 
					EnDone		<= 1'b0;
				 	if ( !AreaCalculated ) begin 
					
						{carry_a, col_a} 	<= {1'b0, col_a} + 1'b1;
						if ( carry_a ) begin
						
							{AreaCalculated, row_a} <= {1'b0, row_a} + 1'b1;
						end
						cellAmount 		<= data1[col_a];
						EnAreaCounter  <= EnAreaCounter + cellAmount;
						addr1     		<= row_a;
					end else begin 
						addr1     		<= addr1;
						addr2     		<= addr2;
						EnDone    		<= 1'b1;
						state     		<= DoneAnalysing;
					end				 
				 end	
				 DoneAnalysing: EnDone  <= 1'b1;
				 default : 
					state <= Initial;

			endcase 
		end 
	end 



endmodule

