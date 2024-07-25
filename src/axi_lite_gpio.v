//******************************************************************************
/// @FILE    axi_lite_gpio.v
/// @AUTHOR  JAY CONVERTINO
/// @DATE    2024.07.25
/// @BRIEF   AXIS GPIO
/// @DETAILS
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

`timescale 1ns/100ps

//UART
module axi_lite_gpio #(
    parameter ADDRESS_WIDTH   = 32,
    parameter GPIO_WIDTH      = 32,
    parameter IRQ_ENABLE      = 0
  )
  (
    //clock and reset
    input                       aclk,
    input                       arstn,
    //AXI lite interface
    input                       s_axi_aclk,
    input                       s_axi_aresetn,
    input                       s_axi_awvalid,
    input   [ADDRESS_WIDTH-1:0] s_axi_awaddr,
    input   [ 2:0]              s_axi_awprot,
    output                      s_axi_awready,
    input                       s_axi_wvalid,
    input   [31:0]              s_axi_wdata,
    input   [ 3:0]              s_axi_wstrb,
    output                      s_axi_wready,
    output                      s_axi_bvalid,
    output  [ 1:0]              s_axi_bresp,
    input                       s_axi_bready,
    input                       s_axi_arvalid,
    input   [ADDRESS_WIDTH-1:0] s_axi_araddr,
    input   [ 2:0]              s_axi_arprot,
    output                      s_axi_arready,
    output                      s_axi_rvalid,
    output  [31:0]              s_axi_rdata,
    output  [ 1:0]              s_axi_rresp,
    input                       s_axi_rready,
    //irq
    output                      irq,
    //gpio
    input   [GPIO_WIDTH-1:0]    gpio_io_i,
    output  [GPIO_WIDTH-1:0]    gpio_io_o,
    output  [GPIO_WIDTH-1:0]    gpio_io_t
  );

  //read interface
  wire                      up_rreq;
  wire                      up_rack;
  wire  [ADDRESS_WIDTH-3:0] up_raddr;
  wire  [31:0]              up_rdata;
  //write interface
  wire                      up_wreq;
  wire                      up_wack;
  wire  [ADDRESS_WIDTH-3:0] up_waddr;
  wire  [31:0]              up_wdata;

  up_axi #(
    .AXI_ADDRESS_WIDTH(ADDRESS_WIDTH)
  ) inst_up_axi (
    .up_rstn (arstn),
    .up_clk (aclk),
    .up_axi_awvalid(s_axi_awvalid),
    .up_axi_awaddr(s_axi_awaddr),
    .up_axi_awready(s_axi_awready),
    .up_axi_wvalid(s_axi_wvalid),
    .up_axi_wdata(s_axi_wdata),
    .up_axi_wstrb(s_axi_wstrb),
    .up_axi_wready(s_axi_wready),
    .up_axi_bvalid(s_axi_bvalid),
    .up_axi_bresp(s_axi_bresp),
    .up_axi_bready(s_axi_bready),
    .up_axi_arvalid(s_axi_arvalid),
    .up_axi_araddr(s_axi_araddr),
    .up_axi_arready(s_axi_arready),
    .up_axi_rvalid(s_axi_rvalid),
    .up_axi_rresp(s_axi_rresp),
    .up_axi_rdata(s_axi_rdata),
    .up_axi_rready(s_axi_rready),
    .up_wreq(up_wreq),
    .up_waddr(up_waddr),
    .up_wdata(up_wdata),
    .up_wack(up_wack),
    .up_rreq(up_rreq),
    .up_raddr(up_raddr),
    .up_rdata(up_rdata),
    .up_rack(up_rack)
  );

  up_gpio #(
    .ADDRESS_WIDTH(32),
    .BUS_WIDTH(2),
    .GPIO_WIDTH(GPIO_WIDTH),
    .IRQ_ENABLE(IRQ_ENABLE)
  ) inst_up_gpio (
    //axis clock and reset
    .clk(aclk),
    .rstn(arstn),
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
    .gpio_io_i(gpio_io_i),
    .gpio_io_o(gpio_io_o),
    .gpio_io_t(gpio_io_t)
  );
endmodule
