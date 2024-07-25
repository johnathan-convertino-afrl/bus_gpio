//******************************************************************************
/// @file    tb_up_uart.v
/// @author  JAY CONVERTINO
/// @date    2024.02.29
/// @brief   TEST BENCH FOR UP UART
///
/// @LICENSE MIT
///  Copyright 2021 Jay Convertino
///
///  Permission is hereby granted, free of charge, to any person obtaining a copy
///  of this software and associated documentation files (the "Software"), to 
///  deal in the Software without restriction, including without limitation the
///  rights to use, copy, modify, merge, publish, distribute, sublicense, and/or 
///  sell copies of the Software, and to permit persons to whom the Software is 
///  furnished to do so, subject to the following conditions:
///
///  The above copyright notice and this permission notice shall be included in 
///  all copies or substantial portions of the Software.
///
///  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR 
///  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, 
///  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
///  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER 
///  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING 
///  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
///  IN THE SOFTWARE.
//******************************************************************************

`timescale 1 ns/10 ps

module tb_up_uart ();
  
  //1ns
  localparam CLK_PERIOD = 20;

  localparam RST_PERIOD = 500;
  localparam CLK_SPEED_HZ = 1000000000/CLK_PERIOD;

  integer     index = 0;

  reg         clk = 0;
  reg         rstn = 0;

  wire        tx;
  wire        rx;
  wire        rts;
  wire        cts;
  wire        irq;

  //read interface
  reg           up_rreq;
  wire          up_rack;
  reg   [13:0]  up_raddr;
  wire  [31:0]  up_rdata;
  //write interface
  reg           up_wreq;
  wire          up_wack;
  reg   [13:0]  up_waddr;
  reg   [31:0]  up_wdata;

  assign rx = tx;
  assign cts = rts;

  //device under test
  up_uart #(
    .CLOCK_SPEED(CLK_SPEED_HZ),
    .BAUD_RATE(115200),
    .PARITY_ENA(0),
    .PARITY_TYPE(0),
    .STOP_BITS(1),
    .DATA_BITS(8),
    .RX_DELAY(3),
    .RX_BAUD_DELAY(3),
    .TX_DELAY(2),
    .TX_BAUD_DELAY(0)
  ) dut (
    //axis clock and reset
    .clk(clk),
    .rstn(rstn),
    //UP interface
    //read interface
    .up_rreq(up_rreq),
    .up_rack(up_rack),
    .up_raddr(up_raddr),
    .up_rdata(up_rdata),
    //write interface
    .up_wreq(up_wreq),
    .up_wack(up_wack),
    .up_waddr(up_waddr),
    .up_wdata(up_wdata),
    //irq
    .irq(irq),
    //UART
    .tx(tx),
    .rx(rx),
    .rts(rts),
    .cts(cts)
  );

  //clock
  always
  begin
    clk <= ~clk;
    
    #(CLK_PERIOD/2);
  end
  
  //reset
  initial
  begin
    rstn <= 1'b0;
    
    #RST_PERIOD;
    
    rstn <= 1'b1;
  end
  
  always @(posedge clk)
  begin
    if(rstn == 1'b0)
    begin
      up_rreq   <= 1'b0;
      up_raddr  <= 0;

      up_wreq   <= 1'b0;
      up_waddr  <= 0;
      up_wdata  <= 'hBE;
    end else begin
      up_wreq  <= 1'b0;
      up_waddr <= 0;

      if(index < 6)
      begin
        up_wreq   <= 1'b1;
        up_waddr  <= 'h4;
        if(up_wack == 1'b1)
        begin
          up_wdata  <= up_wdata + 'h01;
          index = index + 1;
        end
      end else if(index > 400)
      begin
        up_rreq   <= 1'b1;
        up_raddr  <= 'h0;
        if(up_rack == 1'b1)
        begin
          index = index + 1;
        end
      end else begin
        index = index + 1;
      end
    end
  end

  //copy pasta, fst generation
  initial
  begin
    $dumpfile("tb_up_uart.fst");
    $dumpvars(0,tb_up_uart);
  end
endmodule
