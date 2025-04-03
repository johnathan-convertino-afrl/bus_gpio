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
from cocotbext.mil_std_1553 import MILSTD1553Source, MILSTD1553Sink
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
  dut._log.info(f'CLOCK NS : {int(1000000000/dut.CLOCK_SPEED.value)}')
  cocotb.start_soon(Clock(dut.clk, int(1000000000/dut.CLOCK_SPEED.value), units="ns").start())

# Function: reset_dut
# Cocotb coroutine for resets, used with await to make sure system is reset.
async def reset_dut(dut):
  dut.rstn.value = 0
  await Timer(20, units="ns")
  dut.rstn.value = 1

# Function: increment_test_cmd_send
# Coroutine that is identified as a test routine. Setup up to send 1553 commands
# ADDRESS MAP FOR uP: 0=0,4=1,8=2,C=3
#
# Parameters:
#   dut - Device under test passed from cocotb.
@cocotb.test()
async def increment_test_cmd_send(dut):

    start_clock(dut)

    up_master = upMaster(dut, "up", dut.clk, dut.rstn)

    milstd1553_sink = MILSTD1553Sink(dut.o_diff)

    await reset_dut(dut)

    for x in range(0, 2**8):

        status = 0b10000001

        data = x

        payload = status << 16 | data

        await up_master.write(1, payload)

        await Timer(30, units="ns")

        status_reg = await up_master.read(2)

        rx_data = await milstd1553_sink.read_cmd()

        assert int.from_bytes(rx_data, byteorder="little") == x, "SENT COMMAND OVER UP DOES NOT MATCH RECEIVED DATA"
        assert (status_reg >> 2) & 1 == 0, "TX FIFO IS EMPTY AFTER WRITE"


# Function: increment_test_cmd_recv
# Coroutine that is identified as a test routine. Setup up to recv 1553 commands
# ADDRESS MAP FOR uP: 0=0,4=1,8=2,C=3
#
# Parameters:
#   dut - Device under test passed from cocotb.
@cocotb.test()
async def increment_test_cmd_recv(dut):

    start_clock(dut)

    up_master = upMaster(dut, "up", dut.clk, dut.rstn)

    milstd1553_source = MILSTD1553Source(dut.i_diff)

    await reset_dut(dut)

    for x in range(0, 2**8):

        data = x.to_bytes(2, byteorder="little")

        await milstd1553_source.write_cmd(data)

        status_reg = await up_master.read(2)

        rx_data = await up_master.read(0)

        assert rx_data & 0x0000FFFF == x, "RECEIVED COMMAND OVER UP DOES NOT MATCH SOURCE DATA"
        assert (rx_data >> 16) & 0xFF == 0b10000001, "RECEIVED DATA IS NOT A COMMAND OR PARITY FAILED"
        assert (status_reg >> 7) & 1 == 1, "PARITY CHECK FAILED"
        assert status_reg & 1 == 1, "RECEIVED DATA IS NOT VALID"

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
