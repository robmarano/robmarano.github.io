//////////////////////////////////////////////////////////////////////////////
//
// Module: bit_half_adder
//
// Parameterized one bit full adder
//
// hdl: SystemVerilog
// modeling: Behavioral Modeling
//
// author: Prof. Rob Marano <rob@cooper.edu>
//
///////////////////////////////////////////////////////////////////////////////
`ifndef bit_half_adder
`define bit_half_adder

module bit_half_adder (
    input logic a, b,
    output logic sum, cout
);
    always_comb begin : one_bit_half_adder
      sum = a ^ b; 
      cout = (a & b);
    end : one_bit_half_adder

endmodule: bit_half_adder

`endif // bit_half_adder