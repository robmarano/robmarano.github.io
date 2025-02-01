//////////////////////////////////////////////////////////////////////////////
//
// Module: mux_4to1
//
// 4-to-1 multiplexer
//
// module: mux_4to1
// hdl: SystemVerilog
// modeling: Gate-Level Modeling
//
// author: Prof. Rob Marano <rob@cooper.edu>
//
//
///////////////////////////////////////////////////////////////////////////////
`ifndef mux_4to1
`define mux_4to1

module mux_4to1 (
  input logic [3:0] data_in,
  input logic [1:0] sel,
  output logic data_out
);

  logic w0, w1, w2, w3; // Intermediate wires

  // Instantiate AND gates for each data input
  and g0 (w0, data_in[0], ~sel[1], ~sel[0]);
  and g1 (w1, data_in[1], ~sel[1], sel[0]);
  and g2 (w2, data_in[2], sel[1], ~sel[0]);
  and g3 (w3, data_in[3], sel[1], sel[0]);

  // Instantiate an OR gate to combine the AND gate outputs
  or g4 (data_out, w0, w1, w2, w3);

endmodule

`endif // mux_4to1