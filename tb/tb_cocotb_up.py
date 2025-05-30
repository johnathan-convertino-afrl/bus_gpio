#******************************************************************************
# file:    tb_cocotb_up.py
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
from cocotbext.up.ad import upMaster

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
  cocotb.start_soon(Clock(dut.clk, 2, units="ns").start())

# Function: reset_dut
# Cocotb coroutine for resets, used with await to make sure system is reset.
async def reset_dut(dut):
  dut.rstn.value = 0
  await Timer(100, units="ns")
  dut.rstn.value = 1

# Function: increment_test_write
# Coroutine that is identified as a test routine. Setup up to write gpio
# ADDRESS MAP FOR uP: 0=0,4=1,8=2,C=3
#
# Parameters:
#   dut - Device under test passed from cocotb.
@cocotb.test()
async def increment_test_write(dut):

    start_clock(dut)

    await reset_dut(dut)

    up_master = upMaster(dut, "up", dut.clk, dut.rstn)

    await up_master.write(1, 0)

    for x in range(0, 2**8):

        await up_master.write(0, x)

        data = dut.gpio_io_o.value.integer

        tri  = dut.gpio_io_t.value.integer

        assert data == x, "SENT DATA OVER UP DOES NOT MATCH GPIO DATA"
        assert tri  == 0, "TRISTATE IS NOT 0 FOR OUTPUT"

# Function: increment_test_read
# Coroutine that is identified as a test routine. Setup up read gpio
# ADDRESS MAP FOR uP: 0=0,4=1,8=2,C=3
#
# Parameters:
#   dut - Device under test passed from cocotb.
@cocotb.test()
async def increment_test_read(dut):

    start_clock(dut)

    await reset_dut(dut)

    up_master = upMaster(dut, "up", dut.clk, dut.rstn)

    await up_master.write(1, ~0)

    for x in range(0, 2**8):

        dut.gpio_io_i.value = x

        data = await up_master.read(0)

        tri  = dut.gpio_io_t.value.integer

        assert data == x, "SENT DATA OVER DOES NOT MATCH GPIO DATA"
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

    dut.rstn.value = 0

    await Timer(100, units="ns")

    assert dut.up_wack.value.integer == 0, "uP WACK is 1!"
    assert dut.up_rack.value.integer == 0, "uP RACK is 1!"

# Function: no_clock
# Coroutine that is identified as a test routine. This routine tests if no ready when clock is lost
# and device is left in reset.
#
# Parameters:
#   dut - Device under test passed from cocotb.
@cocotb.test()
async def no_clock(dut):

    dut.rstn.value = 0

    await Timer(100, units="ns")

    assert dut.up_wack.value.integer == 0, "uP WACK is 1!"
    assert dut.up_rack.value.integer == 0, "uP RACK is 1!"
