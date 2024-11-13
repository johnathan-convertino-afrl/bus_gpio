﻿NDSummary.OnToolTipsLoaded("File:wishbone_classic_gpio.v",{7:"<div class=\"NDToolTip TInformation LSystemVerilog\"><div class=\"TTSummary\">Wishbone classic UART core.</div></div>",8:"<div class=\"NDToolTip TInformation LSystemVerilog\"><div class=\"TTSummary\">Copyright 2024 Jay Convertino</div></div>",9:"<div class=\"NDToolTip TModule LSystemVerilog\"><div id=\"NDPrototype9\" class=\"NDPrototype WideForm\"><div class=\"PSection PParameterSection CStyle\"><div class=\"PParameterCells\" data-WideColumnCount=\"6\" data-NarrowColumnCount=\"5\"><div class=\"PBeforeParameters\" data-WideGridArea=\"1/1/5/2\" data-NarrowGridArea=\"1/1/2/6\" style=\"grid-area:1/1/5/2\"><span class=\"SHKeyword\">module</span> wishbone_classic_gpio #(</div><div class=\"PType InFirstParameterColumn\" data-WideGridArea=\"1/2/2/3\" data-NarrowGridArea=\"2/1/3/2\" style=\"grid-area:1/2/2/3\"><span class=\"SHKeyword\">parameter</span>&nbsp;</div><div class=\"PName\" data-WideGridArea=\"1/3/2/4\" data-NarrowGridArea=\"2/2/3/3\" style=\"grid-area:1/3/2/4\">ADDRESS_WIDTH</div><div class=\"PDefaultValueSeparator\" data-WideGridArea=\"1/4/2/5\" data-NarrowGridArea=\"2/3/3/4\" style=\"grid-area:1/4/2/5\">&nbsp=&nbsp;</div><div class=\"PDefaultValue InLastParameterColumn\" data-WideGridArea=\"1/5/2/6\" data-NarrowGridArea=\"2/4/3/5\" style=\"grid-area:1/5/2/6\"><span class=\"SHNumber\">32</span>,</div><div class=\"PType InFirstParameterColumn\" data-WideGridArea=\"2/2/3/3\" data-NarrowGridArea=\"3/1/4/2\" style=\"grid-area:2/2/3/3\"><span class=\"SHKeyword\">parameter</span>&nbsp;</div><div class=\"PName\" data-WideGridArea=\"2/3/3/4\" data-NarrowGridArea=\"3/2/4/3\" style=\"grid-area:2/3/3/4\">BUS_WIDTH</div><div class=\"PDefaultValueSeparator\" data-WideGridArea=\"2/4/3/5\" data-NarrowGridArea=\"3/3/4/4\" style=\"grid-area:2/4/3/5\">&nbsp=&nbsp;</div><div class=\"PDefaultValue InLastParameterColumn\" data-WideGridArea=\"2/5/3/6\" data-NarrowGridArea=\"3/4/4/5\" style=\"grid-area:2/5/3/6\"><span class=\"SHNumber\">4</span>,</div><div class=\"PType InFirstParameterColumn\" data-WideGridArea=\"3/2/4/3\" data-NarrowGridArea=\"4/1/5/2\" style=\"grid-area:3/2/4/3\"><span class=\"SHKeyword\">parameter</span>&nbsp;</div><div class=\"PName\" data-WideGridArea=\"3/3/4/4\" data-NarrowGridArea=\"4/2/5/3\" style=\"grid-area:3/3/4/4\">GPIO_WIDTH</div><div class=\"PDefaultValueSeparator\" data-WideGridArea=\"3/4/4/5\" data-NarrowGridArea=\"4/3/5/4\" style=\"grid-area:3/4/4/5\">&nbsp=&nbsp;</div><div class=\"PDefaultValue InLastParameterColumn\" data-WideGridArea=\"3/5/4/6\" data-NarrowGridArea=\"4/4/5/5\" style=\"grid-area:3/5/4/6\"><span class=\"SHNumber\">32</span>,</div><div class=\"PType InFirstParameterColumn\" data-WideGridArea=\"4/2/5/3\" data-NarrowGridArea=\"5/1/6/2\" style=\"grid-area:4/2/5/3\"><span class=\"SHKeyword\">parameter</span>&nbsp;</div><div class=\"PName\" data-WideGridArea=\"4/3/5/4\" data-NarrowGridArea=\"5/2/6/3\" style=\"grid-area:4/3/5/4\">IRQ_ENABLE</div><div class=\"PDefaultValueSeparator\" data-WideGridArea=\"4/4/5/5\" data-NarrowGridArea=\"5/3/6/4\" style=\"grid-area:4/4/5/5\">&nbsp=&nbsp;</div><div class=\"PDefaultValue InLastParameterColumn\" data-WideGridArea=\"4/5/5/6\" data-NarrowGridArea=\"5/4/6/5\" style=\"grid-area:4/5/5/6\"><span class=\"SHNumber\">0</span></div><div class=\"PAfterParameters NegativeLeftSpaceOnWide\" data-WideGridArea=\"4/6/5/7\" data-NarrowGridArea=\"6/1/7/6\" style=\"grid-area:4/6/5/7\">) ( <span class=\"SHKeyword\">input</span> clk, <span class=\"SHKeyword\">input</span> rst, <span class=\"SHKeyword\">input</span> s_wb_cyc, <span class=\"SHKeyword\">input</span> s_wb_stb, <span class=\"SHKeyword\">input</span> s_wb_we, <span class=\"SHKeyword\">input</span> [ADDRESS_WIDTH-<span class=\"SHNumber\">1</span>:<span class=\"SHNumber\">0</span>] s_wb_addr, <span class=\"SHKeyword\">input</span> [BUS_WIDTH*<span class=\"SHNumber\">8</span>-<span class=\"SHNumber\">1</span>:<span class=\"SHNumber\">0</span>] s_wb_data_i, <span class=\"SHKeyword\">input</span> [ <span class=\"SHNumber\">3</span>:<span class=\"SHNumber\">0</span>] s_wb_sel, <span class=\"SHKeyword\">input</span> [ <span class=\"SHNumber\">1</span>:<span class=\"SHNumber\">0</span>] s_wb_bte, <span class=\"SHKeyword\">input</span> [ <span class=\"SHNumber\">2</span>:<span class=\"SHNumber\">0</span>] s_wb_cti, <span class=\"SHKeyword\">output</span> s_wb_ack, <span class=\"SHKeyword\">output</span> [BUS_WIDTH*<span class=\"SHNumber\">8</span>-<span class=\"SHNumber\">1</span>:<span class=\"SHNumber\">0</span>] s_wb_data_o, <span class=\"SHKeyword\">output</span> s_wb_err, <span class=\"SHKeyword\">output</span> irq, <span class=\"SHKeyword\">input</span> [GPIO_WIDTH-<span class=\"SHNumber\">1</span>:<span class=\"SHNumber\">0</span>] gpio_io_i, <span class=\"SHKeyword\">output</span> [GPIO_WIDTH-<span class=\"SHNumber\">1</span>:<span class=\"SHNumber\">0</span>] gpio_io_o, <span class=\"SHKeyword\">output</span> [GPIO_WIDTH-<span class=\"SHNumber\">1</span>:<span class=\"SHNumber\">0</span>] gpio_io_t )</div></div></div></div><div class=\"TTSummary\">AXI Lite based uart device.</div></div>",10:"<div class=\"NDToolTip TVariable LSystemVerilog\"><div id=\"NDPrototype10\" class=\"NDPrototype\"><div class=\"PSection PPlainSection\"><span class=\"SHKeyword\">wire</span> up_rreq</div></div><div class=\"TTSummary\">uP read bus request</div></div>",11:"<div class=\"NDToolTip TVariable LSystemVerilog\"><div id=\"NDPrototype11\" class=\"NDPrototype\"><div class=\"PSection PPlainSection\"><span class=\"SHKeyword\">wire</span> up_rack</div></div><div class=\"TTSummary\">uP read bus acknowledge</div></div>",12:"<div class=\"NDToolTip TVariable LSystemVerilog\"><div id=\"NDPrototype12\" class=\"NDPrototype\"><div class=\"PSection PPlainSection\"><span class=\"SHKeyword\">wire</span> [ADDRESS_WIDTH-<span class=\"SHNumber\">3</span>:<span class=\"SHNumber\">0</span>] up_raddr</div></div><div class=\"TTSummary\">uP read bus address</div></div>",13:"<div class=\"NDToolTip TVariable LSystemVerilog\"><div id=\"NDPrototype13\" class=\"NDPrototype\"><div class=\"PSection PPlainSection\"><span class=\"SHKeyword\">wire</span> [<span class=\"SHNumber\">31</span>:<span class=\"SHNumber\">0</span>] up_rdata</div></div><div class=\"TTSummary\">uP read bus request</div></div>",14:"<div class=\"NDToolTip TVariable LSystemVerilog\"><div id=\"NDPrototype14\" class=\"NDPrototype\"><div class=\"PSection PPlainSection\"><span class=\"SHKeyword\">wire</span> up_wreq</div></div><div class=\"TTSummary\">uP write bus request</div></div>",15:"<div class=\"NDToolTip TVariable LSystemVerilog\"><div id=\"NDPrototype15\" class=\"NDPrototype\"><div class=\"PSection PPlainSection\"><span class=\"SHKeyword\">wire</span> up_wack</div></div><div class=\"TTSummary\">uP write bus acknowledge</div></div>",16:"<div class=\"NDToolTip TVariable LSystemVerilog\"><div id=\"NDPrototype16\" class=\"NDPrototype\"><div class=\"PSection PPlainSection\"><span class=\"SHKeyword\">wire</span> [ADDRESS_WIDTH-<span class=\"SHNumber\">3</span>:<span class=\"SHNumber\">0</span>] up_waddr</div></div><div class=\"TTSummary\">uP write bus address</div></div>",17:"<div class=\"NDToolTip TVariable LSystemVerilog\"><div id=\"NDPrototype17\" class=\"NDPrototype\"><div class=\"PSection PPlainSection\"><span class=\"SHKeyword\">wire</span> [<span class=\"SHNumber\">31</span>:<span class=\"SHNumber\">0</span>] up_wdata</div></div><div class=\"TTSummary\">uP write bus data</div></div>",19:"<div class=\"NDToolTip TModule LSystemVerilog\"><div id=\"NDPrototype19\" class=\"NDPrototype WideForm\"><div class=\"PSection PParameterSection CStyle\"><div class=\"PParameterCells\" data-WideColumnCount=\"4\" data-NarrowColumnCount=\"3\"><div class=\"PBeforeParameters\" data-WideGridArea=\"1/1/3/2\" data-NarrowGridArea=\"1/1/2/4\" style=\"grid-area:1/1/3/2\">up_wishbone_classic #(</div><div class=\"PSymbols InFirstParameterColumn\" data-WideGridArea=\"1/2/2/3\" data-NarrowGridArea=\"2/1/3/2\" style=\"grid-area:1/2/2/3\">.</div><div class=\"PName InLastParameterColumn\" data-WideGridArea=\"1/3/2/4\" data-NarrowGridArea=\"2/2/3/3\" style=\"grid-area:1/3/2/4\">ADDRESS_WIDTH(ADDRESS_WIDTH),</div><div class=\"PSymbols InFirstParameterColumn\" data-WideGridArea=\"2/2/3/3\" data-NarrowGridArea=\"3/1/4/2\" style=\"grid-area:2/2/3/3\">.</div><div class=\"PName InLastParameterColumn\" data-WideGridArea=\"2/3/3/4\" data-NarrowGridArea=\"3/2/4/3\" style=\"grid-area:2/3/3/4\">BUS_WIDTH(BUS_WIDTH)</div><div class=\"PAfterParameters NegativeLeftSpaceOnWide\" data-WideGridArea=\"2/4/3/5\" data-NarrowGridArea=\"4/1/5/4\" style=\"grid-area:2/4/3/5\">) inst_up_wishbone_classic ( .clk(clk), .rst(rst), .s_wb_cyc(s_wb_cyc), .s_wb_stb(s_wb_stb), .s_wb_we(s_wb_we), .s_wb_addr(s_wb_addr), .s_wb_data_i(s_wb_data_i), .s_wb_sel(s_wb_sel), .s_wb_cti(s_wb_cti), .s_wb_bte(s_wb_bte), .s_wb_ack(s_wb_ack), .s_wb_data_o(s_wb_data_o), .s_wb_err(s_wb_err), .up_rreq(up_rreq), .up_rack(up_rack), .up_raddr(up_raddr), .up_rdata(up_rdata), .up_wreq(up_wreq), .up_wack(up_wack), .up_waddr(up_waddr), .up_wdata(up_wdata) )</div></div></div></div><div class=\"TTSummary\">Module instance of up_wishbone_classic for the Wishbone Classic bus to the uP bus.</div></div>",20:"<div class=\"NDToolTip TModule LSystemVerilog\"><div id=\"NDPrototype20\" class=\"NDPrototype WideForm\"><div class=\"PSection PParameterSection CStyle\"><div class=\"PParameterCells\" data-WideColumnCount=\"4\" data-NarrowColumnCount=\"3\"><div class=\"PBeforeParameters\" data-WideGridArea=\"1/1/5/2\" data-NarrowGridArea=\"1/1/2/4\" style=\"grid-area:1/1/5/2\">up_gpio #(</div><div class=\"PSymbols InFirstParameterColumn\" data-WideGridArea=\"1/2/2/3\" data-NarrowGridArea=\"2/1/3/2\" style=\"grid-area:1/2/2/3\">.</div><div class=\"PName InLastParameterColumn\" data-WideGridArea=\"1/3/2/4\" data-NarrowGridArea=\"2/2/3/3\" style=\"grid-area:1/3/2/4\">ADDRESS_WIDTH(ADDRESS_WIDTH),</div><div class=\"PSymbols InFirstParameterColumn\" data-WideGridArea=\"2/2/3/3\" data-NarrowGridArea=\"3/1/4/2\" style=\"grid-area:2/2/3/3\">.</div><div class=\"PName InLastParameterColumn\" data-WideGridArea=\"2/3/3/4\" data-NarrowGridArea=\"3/2/4/3\" style=\"grid-area:2/3/3/4\">BUS_WIDTH(BUS_WIDTH),</div><div class=\"PSymbols InFirstParameterColumn\" data-WideGridArea=\"3/2/4/3\" data-NarrowGridArea=\"4/1/5/2\" style=\"grid-area:3/2/4/3\">.</div><div class=\"PName InLastParameterColumn\" data-WideGridArea=\"3/3/4/4\" data-NarrowGridArea=\"4/2/5/3\" style=\"grid-area:3/3/4/4\">GPIO_WIDTH(GPIO_WIDTH),</div><div class=\"PSymbols InFirstParameterColumn\" data-WideGridArea=\"4/2/5/3\" data-NarrowGridArea=\"5/1/6/2\" style=\"grid-area:4/2/5/3\">.</div><div class=\"PName InLastParameterColumn\" data-WideGridArea=\"4/3/5/4\" data-NarrowGridArea=\"5/2/6/3\" style=\"grid-area:4/3/5/4\">IRQ_ENABLE(IRQ_ENABLE)</div><div class=\"PAfterParameters NegativeLeftSpaceOnWide\" data-WideGridArea=\"4/4/5/5\" data-NarrowGridArea=\"6/1/7/4\" style=\"grid-area:4/4/5/5\">) inst_up_gpio ( .clk(aclk), .rstn(arstn), .up_rreq(up_rreq), .up_rack(up_rack), .up_raddr(up_raddr), .up_rdata(up_rdata), .up_wreq(up_wreq), .up_wack(up_wack), .up_waddr(up_waddr), .up_wdata(up_wdata), .irq(irq), .gpio_io_i(gpio_io_i), .gpio_io_o(gpio_io_o), .gpio_io_t(gpio_io_t) )</div></div></div></div><div class=\"TTSummary\">Module instance of up_gpio.</div></div>"});