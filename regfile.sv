// Code your design here
//------------------------------------------------------------------------------
// regfile.sv
// Parameterized register file: WIDTH×DEPTH, dual async read, single sync write,
// with x0 hardwired to zero.
//------------------------------------------------------------------------
`timescale 1ns/1ps

module regfile #(
  parameter int WIDTH = 32,
  parameter int DEPTH = 32
)(
  input  logic                   clk,
  input  logic                   we,
  input  logic [$clog2(DEPTH)-1:0] waddr,
  input  logic [WIDTH-1:0]       wdata,
  input  logic [$clog2(DEPTH)-1:0] raddr1,
  input  logic [$clog2(DEPTH)-1:0] raddr2,
  output logic [WIDTH-1:0]       rdata1,
  output logic [WIDTH-1:0]       rdata2
);

  // storage array
  logic [WIDTH-1:0] mem [0:DEPTH-1];

  // synchronous write (write-first behavior)
  always_ff @(posedge clk) begin
    if (we && waddr != '0) begin
      mem[waddr] <= wdata;
    end
    // if waddr==0, we ignore writes to x0
  end

  // asynchronous read, with x0 hardwired to zero
  assign rdata1 = (raddr1 == '0) ? '0 : mem[raddr1];
  assign rdata2 = (raddr2 == '0) ? '0 : mem[raddr2];

endmodule
