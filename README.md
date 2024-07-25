# BUS GPIO
### GPIO TO BUS (WISHBONE CLASSIC, AXI_LITE)
---

   author: Jay Convertino   
   
   date: 2024.07.25
   
   details: Interface GPIO to a AXI LITE or Wishbone interface bus, duplicates Xilinx AXI GPIO registers and behavior.
   
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
  - AFRL:bus:up_wishbone_classic:1.0.0 (FOR WISHBONE)
  - AD:common:up_axi:1.0.0 (FOR AXI LITE)
  
#### Simulation
  - AFRL:simulation:axis_stimulator

### IP USAGE
#### INSTRUCTIONS

  GPIO core is for general purpose input and output modeled after the AXI Xilinx core. This core does not have GPIO2 functionality, only GPIO.

#### PARAMETERS

  * ADDRESS_WIDTH : DEFAULT = 32 : Width of the Address porition of the bus.
  * GPIO_WIDTH : DEFAULT = 32 : Width of the GPIO in, out, and tristate. Can not be larger than the data width (fixed at 32 bits).
  * IRQ_ENABLE : DEFAULT = 0 : Disable or enable pin change interrupt for inputs. 0 is disabled, 1 is enabled.

#### REGISTERS

  - 0x000 = GPIO_DATA (R/W)
    * GPIO_WIDTH bit register, GPIO_WIDTH downto 0 hold GPIO data, or for writing GPIO data.
  - 0x004 = GPIO_TRI (R/W)
    * GPIO_WIDTH bit register, GPIO_WIDTH downto 0 hold GPIO pin state. 0 for output, 1 for input.
  - 0x11C = GIER (R/W)
    * 32 bit (or larger) register with the following bits: 31= Enable Global Interrupt, rest are always 0.
  - 0x128 = IP Interrupt enable (R/W)
    * 32 bit (or larger) register with the following bits: 0 = GPIO IRQ Enable, rest are always 0.
  - 0x120 = IP Interrupt status (R/TOW)
    * 32 bit (or larger) register with the following bits: 0 = GPIO IRQ status, write 1 to toggel. Rest are always 0.

* This core ignores Xilinx GPIO 2 registers, similar to the way it works if they are disabled.

### COMPONENTS
#### SRC

* up_gpio.v
* wishbone_classic_gpio.v
* axi_lite_gpio.v
  
#### TB

* tb_up_gpio.v
* tb_wishbone_slave.v
  
### fusesoc

* fusesoc_info.core created.
* Simulation uses icarus to run data through the core.

#### TARGETS

* RUN WITH: (fusesoc run --target=sim VENDER:CORE:NAME:VERSION)
  - default (for IP integration builds)
  - sim
