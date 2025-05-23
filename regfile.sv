// Code your design here
//------------------------------------------------------------------------------
// regfile.v
// with x0 hardwired to zero.
`timescale 1ns/1ps

module regfile #(
  parameter WIDTH = 32,
  parameter DEPTH = 32
)(
  input               clk,
  input               we,
  input  [ADDRW-1:0]  waddr,
  input  [WIDTH-1:0]  wdata,
  input  [ADDRW-1:0]  raddr1,
  input  [ADDRW-1:0]  raddr2,
  output [WIDTH-1:0]  rdata1,
  output [WIDTH-1:0]  rdata2
);

  // 手写一个 Verilog-2001 版的 clog2 函数
  function integer clog2(input integer val);
    integer i;
  begin
    clog2 = 0;
    for (i = val - 1; i > 0; i = i >> 1)
      clog2 = clog2 + 1;
  end
  endfunction

  localparam ADDRW = clog2(DEPTH);

  // storage array: 用 reg 数组
  reg [WIDTH-1:0] mem [0:DEPTH-1];

  // synchronous write
  always @(posedge clk) begin
    if (we && waddr != 0)
      mem[waddr] <= wdata;
  end

  // asynchronous read, x0 hardwired to zero
  assign rdata1 = (raddr1 == 0) ? {WIDTH{1'b0}} : mem[raddr1];
  assign rdata2 = (raddr2 == 0) ? {WIDTH{1'b0}} : mem[raddr2];

endmodule
