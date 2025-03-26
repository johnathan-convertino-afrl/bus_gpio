//******************************************************************************
//  file:     axi_lite_gpio.v
//
//  author:   JAY CONVERTINO
//
//  date:     2024/07/25
//
//  about:    Brief
//  AXI Lite GPIO is a core for creating a generic programmable input/output
//
//  license: License MIT
//  Copyright 2024 Jay Convertino
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to
//  deal in the Software without restriction, including without limitation the
//  rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
//  sell copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
//  IN THE SOFTWARE.
//******************************************************************************

`timescale 1ns/100ps

/*
 * Module: axi_lite_gpio
 *
 * AXI Lite based gpio device.
 *
 * Parameters:
 *
 *   ADDRESS_WIDTH   - Width of the axi address bus, max 32 bit.
 *   GPIO_WIDTH      - Width of the GPIO for inputs and outputs
 *   IRQ_ENABLE      - Enable interrupt
 *
 * Ports:
 *
 *   aclk           - Clock for all devices in the core
 *   arstn          - Negative reset
 *   s_axi_awvalid  - Axi Lite aw valid
 *   s_axi_awaddr   - Axi Lite aw addr
 *   s_axi_awprot   - Axi Lite aw prot
 *   s_axi_awready  - Axi Lite aw ready
 *   s_axi_wvalid   - Axi Lite w valid
 *   s_axi_wdata    - Axi Lite w data
 *   s_axi_wstrb    - Axi Lite w strb
 *   s_axi_wready   - Axi Lite w ready
 *   s_axi_bvalid   - Axi Lite b valid
 *   s_axi_bresp    - Axi Lite b resp
 *   s_axi_bready   - Axi Lite b ready
 *   s_axi_arvalid  - Axi Lite ar valid
 *   s_axi_araddr   - Axi Lite ar addr
 *   s_axi_arprot   - Axi Lite ar prot
 *   s_axi_arready  - Axi Lite ar ready
 *   s_axi_rvalid   - Axi Lite r valid
 *   s_axi_rdata    - Axi Lite r data
 *   s_axi_rresp    - Axi Lite r resp
 *   s_axi_rready   - Axi Lite r ready
 *   irq            - Interrupt when data is received
 *   gpio_io_i      - Input for GPIO
 *   gpio_io_o      - Output for GPIO
 *   gpio_io_t      - Tristate for GPIO
 */
module axi_lite_gpio #(
    parameter ADDRESS_WIDTH   = 32,
    parameter GPIO_WIDTH      = 32,
    parameter IRQ_ENABLE      = 0
  )
  (
    input                       aclk,
    input                       arstn,
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
    output                      irq,
    input   [GPIO_WIDTH-1:0]    gpio_io_i,
    output  [GPIO_WIDTH-1:0]    gpio_io_o,
    output  [GPIO_WIDTH-1:0]    gpio_io_t
  );

  // var: up_rreq
  // uP read bus request
  wire                      up_rreq;
  // var: up_rack
  // uP read bus acknowledge
  wire                      up_rack;
  // var: up_raddr
  // uP read bus address
  wire  [ADDRESS_WIDTH-(BUS_WIDTH-1)-1:0] up_raddr;
  // var: up_rdata
  // uP read bus request
  wire  [31:0]              up_rdata;

  // var: up_wreq
  // uP write bus request
  wire                      up_wreq;
  // var: up_wack
  // uP write bus acknowledge
  wire                      up_wack;
  // var: up_waddr
  // uP write bus address
  wire  [ADDRESS_WIDTH-(BUS_WIDTH-1)-1:0] up_waddr;
  // var: up_wdata
  // uP write bus data
  wire  [31:0]              up_wdata;

  //Group: Instantianted Modules

  // Module: inst_up_axi
  //
  // Module instance of up_axi for the AXI Lite bus to the uP bus.
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

  // Module: inst_up_gpio
  //
  // Module instance of up_gpio.
  up_gpio #(
    .ADDRESS_WIDTH(ADDRESS_WIDTH),
    .BUS_WIDTH(4),
    .GPIO_WIDTH(GPIO_WIDTH),
    .IRQ_ENABLE(IRQ_ENABLE)
  ) inst_up_gpio (
    .clk(aclk),
    .rstn(arstn),
    .up_rreq(up_rreq),
    .up_rack(up_rack),
    .up_raddr(up_raddr),
    .up_rdata(up_rdata),
    .up_wreq(up_wreq),
    .up_wack(up_wack),
    .up_waddr(up_waddr),
    .up_wdata(up_wdata),
    .irq(irq),
    .gpio_io_i(gpio_io_i),
    .gpio_io_o(gpio_io_o),
    .gpio_io_t(gpio_io_t)
  );
endmodule
