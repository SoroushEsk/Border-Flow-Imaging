// clk_per_bit = (Frequency of clk)/(Frequency of UART)
// Example: 10 MHz Clock, 115200 baud UART
// (10000000)/(115200) = 87
  
module uart_rx 
  #(parameter clk_per_bit = 87)
  (
   input        clk,
   input        rx_serial_in,
   output       rx_dv_out,
   output [7:0] rx_out
   );
    
  parameter idle  = 3'b000;
  parameter start = 3'b001;
  parameter data  = 3'b010;
  parameter stop  = 3'b011;
  parameter restart = 3'b100;
   
  reg   rx_data_f = 1'b1;
  reg   rx_data   = 1'b1;
   
  reg [7:0] count = 0;
  reg [2:0] index = 0; 
  reg [7:0] rx_b  = 0;
  reg       rx_dv = 0;
  reg [2:0] state = 0;
   
  always @(posedge clk)
    begin
      rx_data_f <= rx_serial_in;
      rx_data   <= rx_data_f;
    end
   
   
  always @(posedge clk)
    begin
       
      case (state)
        idle :
          begin
            rx_dv <= 1'b0;
            count <= 0;
            index <= 0;
             
            if (rx_data == 1'b0)          // Start bit detected
              state <= start;
            else
              state <= idle;
          end
         
        start :
          begin
            if (count == (clk_per_bit-1)/2) // Pick the middle of the start bit to be sure bit is low.
              begin
                if (rx_data == 1'b0)
                  begin
                    count <= 0; 
                    state <= data;
                  end
                else
                  state <= idle;
              end
            else
              begin
                count <= count + 1;
                state <= start;
              end
          end
         
         
        // Wait clk_per_bit-1 clock cycles to sample serial data
        data :
          begin
            if (count < clk_per_bit-1)
              begin
                count <= count + 1;
                state <= data;
              end
            else
              begin
                count <= 0;
                rx_b[index] <= rx_data;
                 
                // Check if we have received all bits
                if (index < 7)
                  begin
                    index <= index + 1;
                    state <= data;
                  end
                else
                  begin
                    index <= 0;
                    state <= stop;
                  end
              end
          end
        
        stop :
          begin
            // Wait clk_per_bit-1 clock cycles for Stop bit to finish
            if (count < clk_per_bit-1)
              begin
                count <= count + 1;
                state     <= stop;
              end
            else
              begin
                rx_dv       <= 1'b1;
                count <= 0;
                state     <= restart;
              end
          end // case: stop
     
         
        // Stay here 1 clock
        restart :
          begin
            state <= idle;
            rx_dv   <= 1'b0;
          end
         
         
        default :
          state <= idle;
         
      endcase
    end   
   
  assign rx_dv_out   = rx_dv;
  assign rx_out = rx_b;
   
endmodule
