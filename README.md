# BUS UART
### UART TO BUS (WISHBONE CLASSIC, AXI_LITE)
---

   author: Jay Convertino   
   
   date: 2024.03.11
   
   details: Interface UART data at some baud to a AXI LITE or Wishbone interface bus, duplicates Xilinx UART Lite registers and behavior.
   
   license: MIT   
   
---

### Version
#### Current
  - V1.0.0 - initial release

#### Previous
  - none

### Dependencies
#### Build
  - AFRL:utility:helper:1.0.0
  - AFRL:device_converter:axis_uart:1.0.0
  - AFRL:buffer:fifo
  - AFRL:bus:up_wishbone_classic:1.0.0 (FOR WISHBONE)
  - AD:common:up_axi:1.0.0 (FOR AXI LITE)
  
#### Simulation
  - AFRL:simulation:axis_stimulator

### IP USAGE
#### INSTRUCTIONS

BUS UART core for TTL rs232 software mode data communications. No hardware handshake.
This contains its own internal baud rate generator that creates an enable to allow data output  
or sampling. Baud clock and aclk can be the same clock.  

RTS/CTS is not implemented, it simply asserts it as if its always ready, and ignores CTS.

This BUS UART uses AXIS UART for its UART data processes.

#### PARAMETERS
* BAUD_CLOCK_SPEED : DEFAULT = 2000000 : Clock speed of the baud clock. Best if it is a integer multiple of the baud rate, but does not have to be.
* BAUD_RATE : DEFAULT = 2000000 : Baud rate of the input/output data for the core.
* PARITY_ENA : DEFAULT = 1 : Enable parity check and generate.
* PARITY_TYPE : DEFAULT = 1 : Set the parity type, 0 = even, 1 = odd, 2 = mark, 3 = space.
* STOP_BITS : DEFAULT = 1 : Number of stop bits, 0 to crazy non-standard amounts.
* DATA_BITS : DEFAULT = 8 : Number of data bits, 1 to crazy non-standard amounts.
* RX_DELAY : DEFAULT = 0 : Delay in rx data input.
* RX_BAUD_DELAY : DEFAULT = 0 : Delay in rx baud enable. This will delay when we sample a bit (default is midpoint when rx delay is 0).
* TX_DELAY : DEFAULT = 0 : Delay in tx data output. Delays the time to output of the data.
* TX_BAUD_DELAY : DEFAULT = 0 : Delay in tx baud enable. This will delay the time the bit output starts.

#### REGISTERS
  - 0x0 = RX_FIFO (R)
    * 32 bit register, DATA_BITS downto 0 hold RX UART data.
  - 0x4 = TX FIFO (W)
    * 32 bit register, DATA_BITS downto 0 hold TX UART data.
  - 0x8 = STATUS REGISTER (W)
    * 32 bit register with the following bits: 4 = Enable INTR, 1 = RST_RX_FIFO, 0 = RST_TX_FIFO.
  - 0xC = CONTROL_REGISTER (R)
    * 32 bit register with the following bits: 7 = Parity Error, 6 = Frame Error, 5 = Overrun Error, 4 = Interupt Enabled, 3 = TX FIFO Full, 2 = TX FIFO Empty, 1 = RX FIFO Full, RX FIFO Data Valid.

### COMPONENTS
#### SRC

* up_uart.v
* wishbone_classic_uart.v
* axi_lite_uart.v
  
#### TB

* tb_up_uart.v
* tb_wishbone_slave.v
  
### fusesoc

* fusesoc_info.core created.
* Simulation uses icarus to run data through the core.

#### TARGETS

* RUN WITH: (fusesoc run --target=sim VENDER:CORE:NAME:VERSION)
  - default (for IP integration builds)
  - sim
