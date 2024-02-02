//module buffer(clk, en, addr, data);
//  input clk;
 // input en;
  //input [



module decoder (
    input [7:0] code,
    input reset,
    input clk,
    input start, 
    input [7:0] perimeter,
    input [11:0] area,
    input [6:0] start_pixel_x,
    input [6:0] start_pixel_y,
    output reg done,
    output reg error,
    output reg [12:0] pixels
  );

  reg [6: 0] x, y;
  reg [11:0] counter = 0;
  reg [11:0] number_codes = perimeter; 
  reg [2:0] state; 
  parameter s_start = 3'b000;
  parameter s_spx = 3'b001 ; parameter s_spy = 3'b010;
  parameter s_per = 3'b011 ; parameter s_data= 3'b100; 
  parameter s_done= 3'b101 ; parameter s_error = 3'b110;
  parameter s_idle = 3'b111;
  initial state = s_start; 

  always@ (posedge clk) begin 
    if (reset) begin 
      state <= s_start; 
    end
    else begin 
      case(state)
        s_start: begin 
          if (start) state <= s_spx;
          else state <= start;
        end 
        s_spx: begin
          x <= start_pixel_x;
          state <= s_spy;
        end
        s_spy: begin 
          y <= start_pixel_y;
          state <= s_per;
        end
        s_per: begin 
          pixels <= {x, y};
          number_codes <= perimeter;
          state <= s_data;
        end
        s_data: begin 
          if (number_codes > counter) begin 
            if (code == 0) begin x <= x + 1; counter <= counter + 1; end
            else if(code == 1) begin x <= x + 1; y <= y - 1; counter <= counter + 1; end
            else if(code == 2) begin y <= y - 1; counter <= counter + 1; end
            else if(code == 3) begin x <= x - 1; y <= y - 1; counter <= counter + 1; end
            else if(code == 4) begin x <= x -1; counter <= counter + 1; end
            else if(code == 5) begin y <= y + 1; x <= x - 1; counter <= counter + 1; end
            else if(code == 6) begin y <= y + 1; counter <= counter + 1; end
            else if(code == 7) begin y <= y + 1; x <= x + 1; counter <= counter + 1; end
          end else begin 
            state <= s_done; 
          end
        end
        s_done: begin 
          if (number_codes == counter) begin state <= s_idle; done <= 1; end 
          else begin 
            state <= s_error;
          end
        end
        s_error: begin 
          error <= 1;
          state <= s_idle;
        end
        s_idle: begin 
          // Can only exit this state using reset 
        end
      endcase
    end
  end

endmodule
