`timescale 1ns / 1ps





module Encoder(	
					input reset,
					input Clk, 
					input start,
					output [2:0] Code,
					output [5:0] start_x, start_y,
					output [11:0] Area,
					output [7:0] Permiter, 
					output Done, 
					output Error
    );
	 
// --- Parameter Decluration ---- 
	parameter Initial       = 0;
	parameter StartPoint    = 1;
	parameter FindCode      = 2;
	parameter FindArea      = 3;
	parameter DoneAnalysing = 4; 
	 
// --- Picture Inst ----

	reg [5:0] addr1, addr2;
	wire [63:00] data1, data2;

Image1 your_instance_name (
  .clka(Clk),
  .addra(addr1), 
  .douta(data1), 
  .clkb(Clk),
  .addrb(addr2), 
  .doutb(data2) 
);	 
	 
// ------ Decluration ----------
	reg [2:0] state;
	reg [7:0] perimiterCounter;
	reg EnDone, EnError;
	
	reg [5:0] row, col;
	reg findStart;
	reg carry ;
	

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
		end else begin 
			case ( state ) 
				 Initial : begin 
					col      <= 6'b000_000;
					row      <= 6'b000_000;
					if ( start ) state    <= StartPoint;
				 end 
				 StartPoint : begin 
				 	if ( !findStart ) begin 
						{carry, col} <= {1'b0, col} + 1'b1;
						if ( carry ) begin
							row    <= row + 1'b1;
						end
						findStart <= data1[63 - col];
						addr1     <= row;
					end else begin 
					addr1     <= addr1;
					end
				 end 
				 /*
				 FindCode :
				 
				 DoneAnalysing: 
				 
				 default : 
					state <= Initial;
			
			*/
			endcase 
		
		
		end 
	
	
	
	end 
	

endmodule
