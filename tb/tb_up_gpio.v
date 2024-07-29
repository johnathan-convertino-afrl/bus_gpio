//******************************************************************************
/// @file    tb_up_gpio.v
/// @author  JAY CONVERTINO
/// @date    2024.07.29
/// @brief   TEST BENCH FOR UP GPIO
///
/// @LICENSE MIT
///  Copyright 2024 Jay Convertino
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

module tb_up_gpio();
  
  //1ns
  localparam CLK_PERIOD = 20;

  localparam RST_PERIOD = 500;
  localparam CLK_SPEED_HZ = 1000000000/CLK_PERIOD;

  localparam GPIO_DATA  = 12'h000;
  localparam GPIO_TRI   = 12'h004;
  localparam GPIO2_DATA = 12'h008;
  localparam GPIO2_TRI  = 12'h00C;
  localparam GIER       = 12'h11C;
  localparam IP_IER     = 12'h128;
  localparam IP_ISR     = 12'h120;

  integer     index = 0;

  reg         clk = 0;
  reg         rstn = 0;

  wire        irq;

  reg   [31:0]  r_gpio_i;
  wire  [31:0]  s_gpio_o;
  wire  [31:0]  s_gpio_t;

  //read interface
  reg           up_rreq;
  wire          up_rack;
  reg   [31:0]  up_raddr;
  wire  [31:0]  up_rdata;
  //write interface
  reg           up_wreq;
  wire          up_wack;
  reg   [31:0]  up_waddr;
  reg   [31:0]  up_wdata;

  //device under test
  //UP GPIO
  up_gpio #(
    .ADDRESS_WIDTH(32),
    .BUS_WIDTH(4),
    .GPIO_WIDTH(32),
    .IRQ_ENABLE(1)
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
    //gpio
    .gpio_io_i(r_gpio_i),
    .gpio_io_o(s_gpio_o),
    .gpio_io_t(s_gpio_t)
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
      r_gpio_i  <= 'hDEADBEEF;
      up_rreq   <= 1'b0;
      up_raddr  <= 0;

      index     <= 0;

      up_wreq   <= 1'b0;
      up_waddr  <= 0;
      up_wdata  <= 0;
    end else begin
      up_wreq  <= 1'b0;
      up_waddr <= 0;
      up_wdata <= 0;

      up_rreq  <= 1'b0;
      up_raddr <= 0;

      index <= index + 1;

      //set to all input
      if(index < 500)
      begin
        if(index < 2)
        begin
          up_wreq   <= 1'b1;
          up_waddr  <= GPIO_TRI;
          up_wdata  <= 'hFFFFFFFF;
        end else begin
        //read data
          up_rreq   <= 1'b1;
          up_raddr  <= GPIO_DATA;
          r_gpio_i  <= index;
        end
      //set to all output
      end else if(index < 1000)
      begin
        if(index < 502)
        begin
          up_wreq   <= 1'b1;
          up_waddr  <= GPIO_TRI;
          up_wdata  <= 'h00000000;
        end else begin
        //write data
          up_wreq   <= 1'b1;
          up_waddr  <= GPIO_DATA;
          up_wdata  <= 'hBABEDEAD;
        end
      end else if(index < 2000)
      begin
        //set to mix 50/50
        if(index < 1002)
        begin
          up_wreq   <= 1'b1;
          up_waddr  <= GPIO_TRI;
          up_wdata  <= 'hFF0000FF;
        //read data
        end else if(index < 1500) begin
          up_rreq   <= 1'b1;
          up_raddr  <= GPIO_DATA;
          r_gpio_i  <= index;
        //write data
        end else begin
          up_wreq <= 1'b1;
          up_waddr <= GPIO_DATA;
          up_wdata <= (index << 8) | 'hFFFF00FF;
        end
      //irq testing
      end else begin
        if(index < 2002)
        begin
          up_wreq   <= 1'b1;
          up_waddr  <= GIER;
          up_wdata  <= 'hFFFFFFFF;
        end else if(index < 2004)
        begin
          up_wreq   <= 1'b1;
          up_waddr  <= IP_IER;
          up_wdata  <= 'hFFFFFFFF;
        end else if(index < 3000)
        begin
          if((index % 10) == 0)
          begin
            r_gpio_i <= index;
          end

          if(irq == 1'b1)
          begin
            up_wreq   <= 1'b1;
            up_waddr  <= IP_ISR;
            up_wdata  <= 'h00000001;
          end
        end else begin
          $finish();
        end
      end
    end
  end

  //copy pasta, fst generation
  initial
  begin
    $dumpfile("tb_up_gpio.fst");
    $dumpvars(0,tb_up_gpio);
  end
endmodule
