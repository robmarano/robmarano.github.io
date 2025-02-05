//////////////////////////////////////////////////////////////////////////////
//
// D Flip-Flop with Reset and Enable (Gate-Level)
//
// module: dff
// hdl: SystemVerilog
// modeling: Behavorial Modeling
//
// author: Prof. Rob Marano <rob@cooper.edu>
//
///////////////////////////////////////////////////////////////////////////////
`ifndef dff
`define dff


module dff (
  input logic clk,
  input logic rst,
  input logic enable,
  input logic d,
  output logic q
);

  always_ff @(posedge clk) begin
    if (rst) begin
      q <= 0; // Synchronous reset
    end else if (enable) begin
      q <= d; // Data is loaded only when enable is high
    end
  end

endmodule

`endif