#******************************************************************************
# file:    tb_cocotb_axi_lite.py
#
# author:  JAY CONVERTINO
#
# date:    2025/03/04
#
# about:   Brief
# Cocotb test bench
#
# license: License MIT
# Copyright 2025 Jay Convertino
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to
# deal in the Software without restriction, including without limitation the
# rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
# sell copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
# FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
# IN THE SOFTWARE.
#
#******************************************************************************

import random
import itertools

import cocotb
from cocotb.clock import Clock
from cocotb.utils import get_sim_time
from cocotb.triggers import FallingEdge, RisingEdge, Timer, Event
from cocotb.binary import BinaryValue
from cocotbext.axi import AxiLiteBus, AxiLiteMaster

# Function: random_bool
# Return a infinte cycle of random bools
#
# Returns: List
def random_bool():
  temp = []

  for x in range(0, 256):
    temp.append(bool(random.getrandbits(1)))

  return itertools.cycle(temp)

# Function: start_clock
# Start the simulation clock generator.
#
# Parameters:
#   dut - Device under test passed from cocotb test function
def start_clock(dut):
  cocotb.start_soon(Clock(dut.aclk, 2, units="ns").start())

# Function: reset_dut
# Cocotb coroutine for resets, used with await to make sure system is reset.
async def reset_dut(dut):
  dut.arstn.value = 0
  await Timer(20, units="ns")
  dut.arstn.value = 1

# Function: increment_test_write
# Coroutine that is identified as a test routine. Setup up to write to GPIO
#
# Parameters:
#   dut - Device under test passed from cocotb.
@cocotb.test()
async def increment_test_write(dut):

    start_clock(dut)

    axil_master = AxiLiteMaster(AxiLiteBus.from_prefix(dut, "s_axi"), dut.aclk, dut.arstn, False)

    await reset_dut(dut)

    await axil_master.write(4, int(0).to_bytes(dut.BUS_WIDTH.value, "little"))

    for x in range(0, 2**8):

        payload_bytes = x.to_bytes(dut.BUS_WIDTH.value, "little")

        await axil_master.write(0, payload_bytes)

        data = dut.gpio_io_o.value.integer

        tri  = dut.gpio_io_t.value.integer

        assert data == x, "SENT DATA OVER UP DOES NOT MATCH GPIO DATA"
        assert tri  == 0, "TRISTATE IS NOT 0 FOR OUTPUT"


# Function: increment_test_read
# Coroutine that is identified as a test routine. Setup to read from gpio
#
# Parameters:
#   dut - Device under test passed from cocotb.
@cocotb.test()
async def increment_test_read(dut):

    start_clock(dut)

    axil_master = AxiLiteMaster(AxiLiteBus.from_prefix(dut, "s_axi"), dut.aclk, dut.arstn, False)

    await reset_dut(dut)

    await axil_master.write(4, int(~0).to_bytes(dut.BUS_WIDTH.value, "little", signed = True))

    for x in range(0, 2**8):

        dut.gpio_io_i.value = x

        packet = await axil_master.read(0, 4)

        tri  = dut.gpio_io_t.value.integer

        assert int.from_bytes(packet.data, "little") == x, "SENT DATA OVER DOES NOT MATCH GPIO DATA"
        assert tri  == 0xFFFFFFFF, "TRISTATE IS NOT ALL 1's FOR INPUT"

# Function: in_reset
# Coroutine that is identified as a test routine. This routine tests if device stays
# in unready state when in reset.
#
# Parameters:
#   dut - Device under test passed from cocotb.
@cocotb.test()
async def in_reset(dut):

    start_clock(dut)

    dut.arstn.value = 0

    await Timer(100, units="ns")

    assert dut.s_axi_arready.value.integer == 0, "s_axi_aready is 1!"
    assert dut.s_axi_wready.value.integer == 0, "s_axi_wready is 1!"

# Function: no_clock
# Coroutine that is identified as a test routine. This routine tests if no ready when clock is lost
# and device is left in reset.
#
# Parameters:
#   dut - Device under test passed from cocotb.
@cocotb.test()
async def no_clock(dut):

    dut.arstn.value = 0

    await Timer(100, units="ns")

    assert dut.s_axi_arready.value.integer == 0, "s_axi_aready is 1!"
    assert dut.s_axi_wready.value.integer == 0, "s_axi_wready is 1!"
