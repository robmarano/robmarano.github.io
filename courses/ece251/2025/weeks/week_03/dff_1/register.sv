`ifndef REGISTER
`define REGISTER

`include "dff.sv"

module register #(
  parameter WIDTH = 8 // Default width of 8 bits
) (
  input logic clk,
  input logic rst,
  input logic enable,
  input logic [WIDTH-1:0] d, // Data input, parameterized width
  output logic [WIDTH-1:0] q // Data output, parameterized width
);

  // Array of D flip-flops to form the register
  logic [WIDTH-1:0] q_internal; // Internal storage for the register

  genvar i;
  generate
    for (i = 0; i < WIDTH; i++) begin : flip_flops
      dff flip_flop_inst (
        .clk(clk),
        .rst(rst),
        .enable(enable),
        .d(d[i]),      // Connecting individual bits of d
        .q(q_internal[i]) // Connecting individual bits of q_internal
      );
    end
  endgenerate

  assign q = q_internal; // Assign the internal storage to the output

endmodule

`endif