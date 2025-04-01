//******************************************************************************
/// @file    tb_wishbone_slave.v
/// @author  JAY CONVERTINO
/// @date    2021.06.23
/// @brief   SIMPLE TEST BENCH
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

module tb_wishbone_slave #(
  parameter IN_FILE_NAME = "in.bin",
  parameter OUT_FILE_NAME = "out.bin",
  parameter RAND_READY = 0);
  
  reg         tb_data_clk = 0;
  reg         tb_rst = 0;

  //up registers
  reg                       r_up_rack;
  reg  [31:0]               r_up_rdata;
  reg                       r_up_wack;

  //control register
  reg  [31:0]               r_control_reg;
  reg  [31:0]               r_address_reg;

  //wishbone registers
  reg r_wb_cyc;
  reg r_wb_stb;
  reg r_wb_we;
  reg [15:0] r_wb_addr;
  reg [31:0] r_wb_data_o;
  reg [3:0]  r_wb_sel_o;
  //wires
  wire tb_wb_ack;
  wire [31:0] tb_wb_data_i;

  wire tb_wb_err;

  wire up_rreq;
  wire up_wreq;
  wire [13:0] up_waddr;
  wire [13:0] up_raddr;
  wire [31:0] up_wdata;

  //gpio
  wire tb_irq;
  wire [31:0] tb_gpio_o;
  wire [31:0] tb_gpio_t;
  reg  [31:0] tb_gpio_i;
  
  //1ns
  localparam CLK_PERIOD = 20;

  localparam RST_PERIOD = 500;
  localparam CLK_SPEED_HZ = 1000000000/CLK_PERIOD;

  //register address decoding
  localparam RX_FIFO_REG = 14'h0;
  localparam ADDRESS_REG = 14'h4;
  localparam STATUS_REG  = 14'h8;
  localparam CONTROL_REG = 14'hC;

  
  //axis clock
  always
  begin
    tb_data_clk <= ~tb_data_clk;
    
    #(CLK_PERIOD/2);
  end
  
  //reset
  initial
  begin
    tb_rst <= 1'b1;
    
    #RST_PERIOD;
    
    tb_rst <= 1'b0;
  end
  
  //copy pasta, fst generation
  initial
  begin
    $dumpfile("tb_wishbone_slave.fst");
    $dumpvars(0,tb_wishbone_slave);
  end

    //up registers decoder
  always @(posedge tb_data_clk)
  begin
    if(tb_rst)
    begin
      r_wb_cyc <= 1'b0;
      r_wb_stb <= 1'b0;
      r_wb_we  <= 1'b0;
      r_wb_addr <= 'h4;
      r_wb_data_o <= 'hAAAA0000;
      r_wb_sel_o <= ~0;
    end else begin
      r_wb_cyc <= 1;//$random%2;
      r_wb_stb <= 1;//$random%2;
      r_wb_we  <= 1'b1;

      if(tb_wb_ack == 1'b1)
      begin
        r_wb_cyc <= 1'b0;
        r_wb_stb <= 1'b0;
        r_wb_we  <= 1'b0;
        // r_wb_addr <= r_wb_addr + 'h4;

        r_wb_data_o <= r_wb_data_o + 'h1;
      end

      r_wb_sel_o <= r_wb_sel_o;
    end
  end

  //device under test
  wishbone_standard_gpio #(
    .ADDRESS_WIDTH(32),
    .BUS_WIDTH(4),
    .GPIO_WIDTH(32),
    .IRQ_ENABLE(0)
  ) dut (
    //clock and reset
    .clk(tb_data_clk),
    .rst(tb_rst),
    //Wishbone
    .s_wb_cyc(r_wb_cyc),
    .s_wb_stb(r_wb_stb),
    .s_wb_we(r_wb_we),
    .s_wb_addr(r_wb_addr),
    .s_wb_data_i(r_wb_data_o),
    .s_wb_sel(r_wb_sel_o),
    .s_wb_ack(tb_wb_ack),
    .s_wb_data_o(tb_wb_data_i),
    .s_wb_err(tb_wb_err),
    //gpio
    .irq(tb_irq),
    //gpio
    .gpio_io_i(tb_gpio_i),
    .gpio_io_o(tb_gpio_o),
    .gpio_io_t(tb_gpio_t)
  );

endmodule
