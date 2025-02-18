//////////////////////////////////////////////////////////////////////////////
//
// Module: full_adder
//
// Parameterized n-bit full adder
//
// hdl: SystemVerilog
// modeling: Behavioral Modeling
//
// author: Prof. Rob Marano <rob@cooper.edu>
//
///////////////////////////////////////////////////////////////////////////////
`ifndef full_adder
`define full_adder

`include "bit_full_adder.sv"

module full_adder #(parameter N = 8) (
  input logic [N-1:0] a, b,
  input logic cin,
  output logic [N-1:0] sum,
  output logic cout
);

  wire [N-1:0] carry;

  genvar i;
  generate
    for (i = 0; i < N; i++) begin: adder_stages
      // LSb gets cin, others get carry from previous stage
      if (i == 0) begin 
          bit_full_adder fa (
              .a(a[i]), .b(b[i]), .cin(cin), 
              .sum(sum[i]), .cout(carry[i])
          );
      // get carry from previous stage
      end else begin 
          bit_full_adder fa (
              .a(a[i]), .b(b[i]), .cin(carry[i-1]), 
              .sum(sum[i]), .cout(carry[i])
          );
      end
    end: adder_stages
  endgenerate

  assign cout = carry[N-1];

endmodule : full_adder
 
`endif // full_adder