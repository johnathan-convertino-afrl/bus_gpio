//******************************************************************************
// file:    up_gpio.v
//
// author:  JAY CONVERTINO
//
// date:    2024/07/25
//
// about:   Brief
// uP Core for interfacing with general purpose input/output.
//
// license: License MIT
// Copyright 2024 Jay Convertino
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to
// deal in the Software without restriction, including without limitation the
// rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
// sell copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
// FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
// IN THE SOFTWARE.
//
//******************************************************************************

`timescale 1ns/100ps

/*
 * Module: up_gpio
 *
 * uP based GPIO device.
 *
 * Parameters:
 *
 *   ADDRESS_WIDTH   - Width of the uP address port, max 32 bit.
 *   BUS_WIDTH       - Width of the uP bus data port.
 *   GPIO_WIDTH      - Width of the GPIO for inputs and outputs
 *   IRQ_ENABLE      - Enable interrupt
 *
 * Ports:
 *
 *   clk            - Clock for all devices in the core
 *   rstn           - Negative reset
 *   up_rreq        - uP bus read request
 *   up_rack        - uP bus read ack
 *   up_raddr       - uP bus read address
 *   up_rdata       - uP bus read data
 *   up_wreq        - uP bus write request
 *   up_wack        - uP bus write ack
 *   up_waddr       - uP bus write address
 *   up_wdata       - uP bus write data
 *   irq            - Interrupt when data is received
 *   gpio_io_i      - Input for GPIO
 *   gpio_io_o      - Output for GPIO
 *   gpio_io_t      - Tristate for GPIO
 */
module up_gpio #(
    parameter ADDRESS_WIDTH   = 32,
    parameter BUS_WIDTH       = 4,
    parameter GPIO_WIDTH      = 32,
    parameter IRQ_ENABLE      = 0
  ) 
  (
    input                                       clk,
    input                                       rstn,
    input                                       up_rreq,
    output                                      up_rack,
    input   [ADDRESS_WIDTH-(BUS_WIDTH-1)-1:0]   up_raddr,
    output  [(BUS_WIDTH*8)-1:0]                 up_rdata,
    input                                       up_wreq,
    output                                      up_wack,
    input   [ADDRESS_WIDTH-(BUS_WIDTH-1)-1:0]   up_waddr,
    input   [(BUS_WIDTH*8)-1:0]                 up_wdata,
    output                                      irq,
    input   [GPIO_WIDTH-1:0]                    gpio_io_i,
    output  [GPIO_WIDTH-1:0]                    gpio_io_o,
    output  [GPIO_WIDTH-1:0]                    gpio_io_t
  );
  // var: DIVISOR
  // Divide the address register default location for 1 byte access to multi byte access. (register offsets are byte offsets).
  localparam DIVISOR = BUS_WIDTH-1;

  // Group: Register Information
  // Core has 4 registers at the offsets that follow.
  //
  //  <GPIO_DATA>   - h000
  //  <GPIO_TRI>    - h004
  //  <GPIO2_DATA>  - h008 N/A
  //  <GPIO2_TRI>   - h00C N/A
  //  <GIER>        - h11C
  //  <IP_ISR>      - h120
  //  <IP_IER>      - h128

  // Register Address: GPIO_DATA
  // Defines the address offset for GPIO DATA
  // (see diagrams/reg_GPIO_DATA.png)
  // Valid bits are from GPIO_WIDTH:0, input or output data.
  localparam GPIO_DATA  = 12'h000 >> DIVISOR;
  // Register Address: GPIO_TRI
  // Defines the address offset for GPIO TRI.
  // (see diagrams/reg_GPIO_TRI.png)
  // Valid bits are from GPIO_WIDTH:0, 1 indicates input, 0 is output.
  localparam GPIO_TRI   = 12'h004 >> DIVISOR;
  // Register Address: GPIO2_DATA
  // Defines the address offset for GPIO2 DATA
  // (see diagrams/reg_GPIO2_DATA.png)
  // Valid bits are from GPIO2_WIDTH:0, input or output data. This Register is not implimented in this design.
  localparam GPIO2_DATA = 12'h008 >> DIVISOR;
  // Register Address: GPIO2_TRI
  // Defines the address offset for GPIO2 TRI.
  // (see diagrams/reg_GPIO2_TRI.png)
  // Valid bits are from GPIO2_WIDTH:0, 1 indicates input, 0 is output. This register is not implimented in this design.
  localparam GPIO2_TRI  = 12'h00C >> DIVISOR;
  // Register Address: GIER
  // Defines the address offset for GIER.
  // (see diagrams/reg_GIER.png)
  // Bit 31 is the Global interrupt enable. Write a 1 to enable interrupts.
  localparam GIER       = 12'h11C >> DIVISOR;
  // Register Address: IP_ISR
  // Defines the address offset for IP_ISR.
  // (see diagrams/reg_IP_ISR.png)
  // Bit 0 is GPIO IRQ status, On write this will toggle(acknowledge) the interrupt.
  localparam IP_ISR     = 12'h120 >> DIVISOR;
  // Register Address: IP_IER
  // Defines the address offset to set the control bits.
  // (see diagrams/reg_IP_IER.png)
  // Bit 0 is GPIO IRQ enable interrupt. Write a 1 to bit 0 to enable interrupt.
  localparam IP_IER     = 12'h128 >> DIVISOR;

  //up registers
  reg                       r_up_rack;
  reg  [(BUS_WIDTH*8)-1:0]  r_up_rdata;
  reg                       r_up_wack;

  //interrupt
  reg                       r_irq;

  //registers
  reg   [GPIO_WIDTH-1:0]    r_gpio_i;
  reg   [GPIO_WIDTH-1:0]    r_gpio_o;
  reg   [GPIO_WIDTH-1:0]    r_gpio_tri;
  reg                       r_gie;
  reg                       r_ch1_irq_ena;
  reg                       r_ch1_irq_status;
  reg                       rr_ch1_irq_status;

  //output signals assigned to registers.
  assign gpio_io_o = r_gpio_o;
  assign gpio_io_t = r_gpio_tri;
  assign up_rack   = r_up_rack & up_rreq;
  assign up_wack   = r_up_wack & up_wreq;
  assign up_rdata  = r_up_rdata;
  assign irq       = r_irq;

  //up registers decoder
  always @(posedge clk)
  begin
    if(rstn == 1'b0)
    begin
      r_up_rack   <= 1'b0;
      r_up_wack   <= 1'b0;
      r_up_rdata  <= 0;

      r_gpio_o   <= 0;
      r_gpio_tri <= 0;
      r_gie      <= 1'b0;
      r_ch1_irq_ena <= 1'b0;
      r_ch1_irq_status <= 1'b0;

    end else begin
      r_up_rack   <= 1'b0;
      r_up_wack   <= 1'b0;
      r_up_rdata  <= r_up_rdata;

      r_ch1_irq_status  <= r_irq;

      if(up_rreq == 1'b1)
      begin
        r_up_rack <= 1'b1;

        case(up_raddr[11:0])
          GPIO_DATA: begin
            r_up_rdata <= {{(BUS_WIDTH*8)-GPIO_WIDTH{1'b0}}, {gpio_io_i & r_gpio_tri}};
          end
          GPIO_TRI: begin
            r_up_rdata <= {{(BUS_WIDTH*8)-GPIO_WIDTH{1'b0}}, r_gpio_tri};
          end
          GPIO2_DATA: begin
            r_up_rdata <= 0;
          end
          GPIO2_TRI: begin
            r_up_rdata <= 0;
          end
          GIER: begin
            r_up_rdata     <= 0;
            r_up_rdata[31] <= r_gie & IRQ_ENABLE;
          end
          IP_IER: begin
            r_up_rdata     <= 0;
            r_up_rdata[0]  <= r_ch1_irq_ena & IRQ_ENABLE;
          end
          IP_ISR: begin
            r_up_rdata         <= 0;
            r_up_rdata[0]      <= r_ch1_irq_status & IRQ_ENABLE;
          end
          default:begin
            r_up_rdata <= 0;
          end
        endcase
      end

      if(up_wreq == 1'b1)
      begin
        r_up_wack <= 1'b1;

        if(r_up_wack == 1'b1) begin
          case(up_waddr[11:0])
            GPIO_DATA: begin
              r_gpio_o  <= up_wdata[GPIO_WIDTH-1:0] & ~r_gpio_tri;
            end
            GPIO_TRI: begin
              r_gpio_tri <= up_wdata[GPIO_WIDTH-1:0];
            end
            GIER: begin
              r_gie <= up_wdata[31] & IRQ_ENABLE;
            end
            IP_IER: begin
              r_ch1_irq_ena <= up_wdata[0] & IRQ_ENABLE;
            end
            IP_ISR: begin
              if((up_wdata[0] == 1'b1) && IRQ_ENABLE)
              begin
                r_ch1_irq_status <= ~r_ch1_irq_status;
              end
            end
            default:begin
            end
          endcase
        end
      end
    end
  end

  //irq
  always @(posedge clk)
  begin
    if(rstn == 1'b0)
    begin
      r_gpio_i <= 0;

      r_irq <= 1'b0;

      rr_ch1_irq_status <= 1'b0;
    end else begin
      r_gpio_i <= gpio_io_i & r_gpio_tri;

      r_irq <= r_irq;

      rr_ch1_irq_status <= r_ch1_irq_status;

      if((r_gpio_i != (gpio_io_i & r_gpio_tri)) && IRQ_ENABLE && (r_gie == 1'b1))
      begin
        r_irq <= r_ch1_irq_ena;
      end

      if(rr_ch1_irq_status != r_ch1_irq_status)
      begin
        r_irq <= 1'b0;
      end
    end
  end
endmodule
