//////////////////////////////////////////////////////////////////////////////
//
// Module: fa
//
// Parameterized n-bit full adder
//
// hdl: SystemVerilog
// modeling: Behavioral Modeling
//
// author: Prof. Rob Marano <rob@cooper.edu>
//
///////////////////////////////////////////////////////////////////////////////
`ifndef fa
`define fa

module fa #(parameter N = 8) (
  input logic [N-1:0] a, b,
  input logic cin,
  output logic [N-1:0] sum,
  output logic cout
);

  assign {cout, sum} = a + b + cin;
endmodule : fa
`endif // fa