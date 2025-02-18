//////////////////////////////////////////////////////////////////////////////
//
// Module: bit_full_adder
//
// Parameterized one bit full adder
//
// hdl: SystemVerilog
// modeling: Behavioral Modeling
//
// author: Prof. Rob Marano <rob@cooper.edu>
//
///////////////////////////////////////////////////////////////////////////////
`ifndef bit_full_adder
`define bit_full_adder

module bit_full_adder (
  input logic a, b, cin,
  output logic sum, cout
);

  logic p, g;

  always_comb begin : one_bit_full_adder
    // blocking assignments
    p = a ^ b;
    g = a & b;
    sum = p ^ cin;
    cout = g | (p & cin);    
  end : one_bit_full_adder

endmodule : bit_full_adder

`endif // bit_full_adder

// module bit_full_adder (
//     input logic a, b, cin, 
//     output logic sum, cout
// );
//     always_comb begin : one_bit_full_adder
//       sum = a ^ b ^ cin; 
//       cout = (a & b) | (b & cin) | (a & cin);
//     end : one_bit_full_adder

//   // assign sum = a ^ b ^ cin;
//   // assign cout = (a & b) | (a & cin) | (b & cin);

// endmodule: bit_full_adder
