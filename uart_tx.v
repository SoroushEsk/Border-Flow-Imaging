// clk_per_bit = (Frequency of clk)/(Frequency of UART)
// Example: 10 MHz Clock, 115200 baud UART
// (10000000)/(115200) = 87
  
module uart_tx 
  #(parameter clk_per_bit = 87)
  (
   input       clk,
   input       tx_dv_in,
   input [7:0] tx_b, 
   output      tx_active_out,
   output reg  tx_serial_out,
   output      tx_done_out
   );
  
  parameter idle  = 3'b000;
  parameter start = 3'b001;
  parameter data  = 3'b010;
  parameter stop  = 3'b011;
  parameter restart = 3'b100;
   
  reg [2:0]    state = 0;
  reg [7:0]    count = 0;
  reg [2:0]    index = 0;
  reg [7:0]    tx_data = 0;
  reg          tx_done = 0;
  reg          tx_active = 0;
     
  always @(posedge clk)
    begin
       
      case (state)
        idle :
          begin
            tx_serial_out <= 1'b1;
            tx_done <= 1'b0;
            count <= 0;
            index <= 0;
             
            if (tx_dv_in == 1'b1)
              begin
                tx_active <= 1'b1;
                tx_data <= tx_b;
                state <= start;
              end
            else
              state <= idle;
          end
         
         
        // Send out Start Bit. Start bit = 0
        start :
          begin
            tx_serial_out <= 1'b0;
             
            // Wait clk_per_bit-1 clock cycles for start bit to finish
            if (count < clk_per_bit-1)
              begin
                count <= count + 1;
                state <= start;
              end
            else
              begin
                count <= 0;
                state <= data;
              end
          end 
         
         
        // Wait clk_per_bit-1 clock cycles for data bits to finish         
        data :
          begin
            tx_serial_out <= tx_data[index];
             
            if (count < clk_per_bit-1)
              begin
                count <= count + 1;
                state <= data;
              end
            else
              begin
                count <= 0;
                 
                // Check if we have sent out all bits
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
         
         
        // Send out Stop bit.  Stop bit = 1
        stop :
          begin
            tx_serial_out <= 1'b1;
             
            // Wait clk_per_bit-1 clock cycles for Stop bit to finish
            if (count < clk_per_bit-1)
              begin
                count <= count + 1;
                state <= stop;
              end
            else
              begin
                tx_done <= 1'b1;
                count <= 0;
                state <= restart;
                tx_active <= 1'b0;
              end
          end 
         
        // Stay here 1 clock
        restart :
          begin
            tx_done <= 1'b1;
            state <= idle;
          end
         
         
        default :
          state <= idle;
         
      endcase
    end
 
  assign tx_active_out = tx_active;
  assign tx_done_out   = tx_done;
   
endmodule
