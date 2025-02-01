//////////////////////////////////////////////////////////////////////////////
//
// Module: full_adder_4bit
//
// 4-bit full adder
//
// module: full_adder_4bit
// hdl: SystemVerilog
// modeling: Gate Level Modeling
//
// author: Prof. Rob Marano <rob@cooper.edu>
//
///////////////////////////////////////////////////////////////////////////////
`ifndef adder_4bit
`define adder_4bit

`include "full_adder_1bit.sv"

module full_adder_4bit(
    //
    // ---------------- DECLARATIONS OF PORT IN/OUT & DATA TYPES ----------------
    //
    input [3:0] a,
    input [3:0] b,
    input cin,
    output [3:0] sum,
    output cout
);

    //
    // ---------------- MODULE DESIGN IMPLEMENTATION ----------------
    //
    wire [3:0] c; // Internal carries

    // Instantiate full adders for each bit
    full_adder_1bit fa0 (
        .a(a[0]),
        .b(b[0]),
        .cin(cin),
        .sum(sum[0]),
        .cout(c[0])
    );

    full_adder_1bit fa1 (
        .a(a[1]),
        .b(b[1]),
        .cin(c[0]),
        .sum(sum[1]),
        .cout(c[1])
    );

    full_adder_1bit fa2 (
        .a(a[2]),
        .b(b[2]),
        .cin(c[1]),
        .sum(sum[2]),
        .cout(c[2])
    );

    full_adder_1bit fa3 (
        .a(a[3]),
        .b(b[3]),
        .cin(c[2]),
        .sum(sum[3]),
        .cout(cout) // Output carry
    );
endmodule

`endif // full_adder_4bit