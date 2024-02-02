module uart_tb();
  parameter clk_ns = 100;
  parameter clk_per_bit = 87;
  parameter bit_period = 3600;

  reg clk = 0;
  reg tx_dv = 0;
  wire tx_done;
  reg [7:0] tx_b;
  reg rx_serial = 1;
  wire [7:0] rx_b;

  task uart_write_byte;
    input [7:0] data;
    integer ii;
    begin 
      rx_serial <= 1'b0;
      #(bit_period)
      #1000;
      
      for (ii = 0; ii < 8; ii = ii + 1) begin
        rx_serial <= data[ii];
        #(bit_period);
      end

      rx_serial <= 1'b1;
      #(bit_period);
    end
  endtask

  uart_rx #(.clk_per_bit(clk_per_bit)) uart_rx_inst (
    .clk(clk), .rx_serial_in(rx_serial), .rx_dv_out(), .rx_out(rx_b)
  );

  uart_tx #(.clk_per_bit(clk_per_bit)) uart_tx_inst (
    .clk(clk), .tx_dv_in(tx_dv), .tx_b(tx_b), .tx_active_out(), .tx_serial_out(), .tx_done_out(tx_done)
  );

  always
    #(clk_ns/2) clk <= !clk;

  initial begin 
    @(posedge clk);
    @(posedge clk);
    tx_dv <= 1'b1;
    tx_b <= 8'h3F;
    @(posedge clk);
    tx_dv <= 1'b0;
    @(posedge tx_done);

    @(posedge clk);
    uart_write_byte(8'h3F);
    @(posedge clk);

    if (rx_b == 8'h3F)
      $display("OK");
    else
      $display("NOT OK");
  end
endmodule
