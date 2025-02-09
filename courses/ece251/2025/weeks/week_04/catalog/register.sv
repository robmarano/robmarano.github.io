//////////////////////////////////////////////////////////////////////////////
//
// Module: register
//
// Parameterized Register
//
// hdl: SystemVerilog
// modeling: Behavioral Modeling
//
// author: Prof. Rob Marano <rob@cooper.edu>
//
///////////////////////////////////////////////////////////////////////////////
`ifndef register
`define register

`include "dff.sv"

module register
    //
    // ---------------- DECLARATIONS OF PORT IN/OUT & DATA TYPES ----------------
    //
#(
    parameter WIDTH = 8 // Default width of 8 bits
) (
    input logic clk,
    input logic rst,
    input logic enable,
    input logic [WIDTH-1:0] d, // Data input, parameterized width
    output logic [WIDTH-1:0] q // Data output, parameterized width
);
    //
    // ---------------- MODULE DESIGN IMPLEMENTATION ----------------
    //
    logic [WIDTH-1:0] q_internal; // Internal signal for dff outputs

    generate
        genvar i;
        for (i = 0; i < WIDTH; i++) begin : flip_flops
            dff flip_flops (
            .clk(clk),
            .rst(rst),
            .enable(enable),
            .d(d[i]),      // Connecting individual bits of d
            .q(q_internal[i]) // Connecting individual bits of q_internal
            );
        end
    endgenerate

    assign q = q_internal; // Assign internal signal to output q
  
endmodule : register
`endif // register
