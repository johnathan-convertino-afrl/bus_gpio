﻿NDSummary.OnToolTipsLoaded("File2:tb_cocotb_up.py",{119:"<div class=\"NDToolTip TInformation LPython\"><div class=\"TTSummary\">Cocotb test bench</div></div>",120:"<div class=\"NDToolTip TInformation LPython\"><div class=\"TTSummary\">Copyright 2025 Jay Convertino</div></div>",122:"<div class=\"NDToolTip TFunction LPython\"><div id=\"NDPrototype122\" class=\"NDPrototype\"><div class=\"PSection PPlainSection\"><span class=\"SHKeyword\">def</span> random_bool()</div></div><div class=\"TTSummary\">Return a infinte cycle of random bools</div></div>",123:"<div class=\"NDToolTip TFunction LPython\"><div id=\"NDPrototype123\" class=\"NDPrototype WideForm\"><div class=\"PSection PParameterSection PascalStyle\"><div class=\"PParameterCells\" data-WideColumnCount=\"3\" data-NarrowColumnCount=\"2\"><div class=\"PBeforeParameters\" data-WideGridArea=\"1/1/2/2\" data-NarrowGridArea=\"1/1/2/3\" style=\"grid-area:1/1/2/2\"><span class=\"SHKeyword\">def</span> start_clock(</div><div class=\"PName InFirstParameterColumn InLastParameterColumn\" data-WideGridArea=\"1/2/2/3\" data-NarrowGridArea=\"2/1/3/2\" style=\"grid-area:1/2/2/3\">dut</div><div class=\"PAfterParameters\" data-WideGridArea=\"1/3/2/4\" data-NarrowGridArea=\"3/1/4/3\" style=\"grid-area:1/3/2/4\">)</div></div></div></div><div class=\"TTSummary\">Start the simulation clock generator.</div></div>",124:"<div class=\"NDToolTip TFunction LPython\"><div id=\"NDPrototype124\" class=\"NDPrototype WideForm\"><div class=\"PSection PParameterSection PascalStyle\"><div class=\"PParameterCells\" data-WideColumnCount=\"3\" data-NarrowColumnCount=\"2\"><div class=\"PBeforeParameters\" data-WideGridArea=\"1/1/2/2\" data-NarrowGridArea=\"1/1/2/3\" style=\"grid-area:1/1/2/2\"><span class=\"SHKeyword\">async def</span> reset_dut(</div><div class=\"PName InFirstParameterColumn InLastParameterColumn\" data-WideGridArea=\"1/2/2/3\" data-NarrowGridArea=\"2/1/3/2\" style=\"grid-area:1/2/2/3\">dut</div><div class=\"PAfterParameters\" data-WideGridArea=\"1/3/2/4\" data-NarrowGridArea=\"3/1/4/3\" style=\"grid-area:1/3/2/4\">)</div></div></div></div><div class=\"TTSummary\">Cocotb coroutine for resets, used with await to make sure system is reset.</div></div>",125:"<div class=\"NDToolTip TFunction LPython\"><div id=\"NDPrototype125\" class=\"NDPrototype WideForm\"><div class=\"PSection PPlainSection\"><span class=\"SHMetadata\">@cocotb.test()</span></div><div class=\"PSection PParameterSection PascalStyle\"><div class=\"PParameterCells\" data-WideColumnCount=\"3\" data-NarrowColumnCount=\"2\"><div class=\"PBeforeParameters\" data-WideGridArea=\"1/1/2/2\" data-NarrowGridArea=\"1/1/2/3\" style=\"grid-area:1/1/2/2\"><span class=\"SHKeyword\">async def</span> increment_test_write(</div><div class=\"PName InFirstParameterColumn InLastParameterColumn\" data-WideGridArea=\"1/2/2/3\" data-NarrowGridArea=\"2/1/3/2\" style=\"grid-area:1/2/2/3\">dut</div><div class=\"PAfterParameters\" data-WideGridArea=\"1/3/2/4\" data-NarrowGridArea=\"3/1/4/3\" style=\"grid-area:1/3/2/4\">)</div></div></div></div><div class=\"TTSummary\">Coroutine that is identified as a test routine. Setup up to write gpio ADDRESS MAP FOR uP: 0=0,4=1,8=2,C=3</div></div>",126:"<div class=\"NDToolTip TFunction LPython\"><div id=\"NDPrototype126\" class=\"NDPrototype WideForm\"><div class=\"PSection PPlainSection\"><span class=\"SHMetadata\">@cocotb.test()</span></div><div class=\"PSection PParameterSection PascalStyle\"><div class=\"PParameterCells\" data-WideColumnCount=\"3\" data-NarrowColumnCount=\"2\"><div class=\"PBeforeParameters\" data-WideGridArea=\"1/1/2/2\" data-NarrowGridArea=\"1/1/2/3\" style=\"grid-area:1/1/2/2\"><span class=\"SHKeyword\">async def</span> increment_test_read(</div><div class=\"PName InFirstParameterColumn InLastParameterColumn\" data-WideGridArea=\"1/2/2/3\" data-NarrowGridArea=\"2/1/3/2\" style=\"grid-area:1/2/2/3\">dut</div><div class=\"PAfterParameters\" data-WideGridArea=\"1/3/2/4\" data-NarrowGridArea=\"3/1/4/3\" style=\"grid-area:1/3/2/4\">)</div></div></div></div><div class=\"TTSummary\">Coroutine that is identified as a test routine. Setup up read gpio ADDRESS MAP FOR uP: 0=0,4=1,8=2,C=3</div></div>",127:"<div class=\"NDToolTip TFunction LPython\"><div id=\"NDPrototype127\" class=\"NDPrototype WideForm\"><div class=\"PSection PPlainSection\"><span class=\"SHMetadata\">@cocotb.test()</span></div><div class=\"PSection PParameterSection PascalStyle\"><div class=\"PParameterCells\" data-WideColumnCount=\"3\" data-NarrowColumnCount=\"2\"><div class=\"PBeforeParameters\" data-WideGridArea=\"1/1/2/2\" data-NarrowGridArea=\"1/1/2/3\" style=\"grid-area:1/1/2/2\"><span class=\"SHKeyword\">async def</span> in_reset(</div><div class=\"PName InFirstParameterColumn InLastParameterColumn\" data-WideGridArea=\"1/2/2/3\" data-NarrowGridArea=\"2/1/3/2\" style=\"grid-area:1/2/2/3\">dut</div><div class=\"PAfterParameters\" data-WideGridArea=\"1/3/2/4\" data-NarrowGridArea=\"3/1/4/3\" style=\"grid-area:1/3/2/4\">)</div></div></div></div><div class=\"TTSummary\">Coroutine that is identified as a test routine. This routine tests if device stays in unready state when in reset.</div></div>",128:"<div class=\"NDToolTip TFunction LPython\"><div id=\"NDPrototype128\" class=\"NDPrototype WideForm\"><div class=\"PSection PPlainSection\"><span class=\"SHMetadata\">@cocotb.test()</span></div><div class=\"PSection PParameterSection PascalStyle\"><div class=\"PParameterCells\" data-WideColumnCount=\"3\" data-NarrowColumnCount=\"2\"><div class=\"PBeforeParameters\" data-WideGridArea=\"1/1/2/2\" data-NarrowGridArea=\"1/1/2/3\" style=\"grid-area:1/1/2/2\"><span class=\"SHKeyword\">async def</span> no_clock(</div><div class=\"PName InFirstParameterColumn InLastParameterColumn\" data-WideGridArea=\"1/2/2/3\" data-NarrowGridArea=\"2/1/3/2\" style=\"grid-area:1/2/2/3\">dut</div><div class=\"PAfterParameters\" data-WideGridArea=\"1/3/2/4\" data-NarrowGridArea=\"3/1/4/3\" style=\"grid-area:1/3/2/4\">)</div></div></div></div><div class=\"TTSummary\">Coroutine that is identified as a test routine. This routine tests if no ready when clock is lost and device is left in reset.</div></div>"});