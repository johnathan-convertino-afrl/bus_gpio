# BUS GPIO
### GPIO TO BUS (WISHBONE CLASSIC, AXI_LITE)

![image](docs/manual/img/AFRL.png)

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

### DOCUMENTATION
  For detailed usage information, please navigate to one of the following sources. They are the same, just in a different format.

  - [bus_gpio.pdf](docs/manual/bus_gpio.pdf)
  - [github page](https://johnathan-convertino-afrl.github.io/bus_gpio/)

### DEPENDENCIES
#### Build
  - AFRL:utility:helper:1.0.0
  - AFRL:bus:up_wishbone_classic:1.0.0 (FOR WISHBONE)
  - AD:common:up_axi:1.0.0 (FOR AXI LITE)
  
#### Simulation
  - AFRL:simulation:axis_stimulator

### PARAMETERS

 *   ADDRESS_WIDTH   - Width of the address bus in bits.
 *   BUS_WIDTH       - Width of the data bus in bytes.
 *   GPIO_WIDTH      - Width of the GPIO for inputs and outputs
 *   IRQ_ENABLE      - Enable interrupt

### REGISTERS

  - 0x000 = GPIO_DATA (R/W)
    * GPIO_WIDTH bit register, GPIO_WIDTH downto 0 hold GPIO data, or for writing GPIO data.
  - 0x004 = GPIO_TRI (R/W)
    * GPIO_WIDTH bit register, GPIO_WIDTH downto 0 hold GPIO pin state. 0 for output, 1 for input.
  - 0x11C = GIER (R/W)
    * 32 bit (or larger) register with the following bits: 31= Enable Global Interrupt, rest are always 0.
  - 0x120 = IP Interrupt status (R/TOW)
    * 32 bit (or larger) register with the following bits: 0 = GPIO IRQ status, write 1 to toggel. Rest are always 0.
  - 0x128 = IP Interrupt enable (R/W)
    * 32 bit (or larger) register with the following bits: 0 = GPIO IRQ Enable, rest are always 0.

* This core ignores Xilinx GPIO 2 registers, similar to the way it works if they are disabled.

### COMPONENTS
#### SRC

* up_gpio.v
* wishbone_classic_gpio.v
* axi_lite_gpio.v
  
#### TB

* tb_up_gpio.v
* tb_wishbone_slave.v
  
### FUSESOC

* fusesoc_info.core created.
* Simulation uses icarus to run data through the core.

#### targets

* RUN WITH: (fusesoc run --target=sim VENDER:CORE:NAME:VERSION)
  - default (for IP integration builds)
  - sim
