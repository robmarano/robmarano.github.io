//////////////////////////////////////////////////////////////////////////////
//
// Module: dff
//
// D Flip-Flop with Reset and Enable
//
// hdl: SystemVerilog
// modeling: Behavioral Modeling
//
// author: Prof. Rob Marano <rob@cooper.edu>
//
///////////////////////////////////////////////////////////////////////////////
`ifndef dff
`define dff

module dff
    //
    // ---------------- DECLARATIONS OF PORT IN/OUT & DATA TYPES ----------------
    //
(
  input logic clk,
  input logic rst,
  input logic enable,
  input logic d,
  output logic q
);
    //
    // ---------------- MODULE DESIGN IMPLEMENTATION ----------------
    //
  always_ff @(posedge clk, posedge rst) begin
    if (rst) begin
      q <= 0; // Synchronous reset
    end else if (enable) begin
      q <= d; // Data is loaded only when enable is high
    end
  end
endmodule : dff
`endif // dff