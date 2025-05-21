# BUS GPIO
### GPIO TO BUS (WISHBONE STANDARD, AXI_LITE)

![image](docs/manual/img/AFRL.png)

---

  author: Jay Convertino   
  
  date: 2024.07.25
  
  details: Interface GPIO to a AXI LITE or Wishbone interface bus, duplicates Xilinx AXI GPIO registers and behavior.
  
  license: MIT   
   
  Actions:  

  [![Lint Status](../../actions/workflows/lint.yml/badge.svg)](../../actions)  
  [![Manual Status](../../actions/workflows/manual.yml/badge.svg)](../../actions)  
  
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
* wishbone_standard_gpio.v
* axi_lite_gpio.v
  
#### TB

* tb_cocotb_up.v
* tb_cocotb_up.py
* tb_cocotb_axi_lite.v
* tb_cocotb_axi_lite.py
* tb_cocotb_wishbone_standard.v
* tb_cocotb_wishbone_standard.py

### FUSESOC

* fusesoc_info.core created.
* Simulation uses cocotb with icarus to run data through the core.

#### Targets

* RUN WITH: (fusesoc run --target=sim VENDER:CORE:NAME:VERSION)
  - default (for IP integration builds)
  - lint
  - sim_cocotb

