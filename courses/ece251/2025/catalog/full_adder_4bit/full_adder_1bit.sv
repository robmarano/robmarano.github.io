//////////////////////////////////////////////////////////////////////////////
//
// Module: full_adder_1bit
//
// 1-bit adder
//
// module: full_adder_1bit
// hdl: SystemVerilog
// modeling: Gate Level Modeling
//
// author: Prof. Rob Marano <rob@cooper.edu>
//
///////////////////////////////////////////////////////////////////////////////
`ifndef full_adder_1bit
`define full_adder_1bit
// DO NOT FORGET TO RENAME MODULE_NAME to match your module_name

module full_adder_1bit(
    //
    // ---------------- DECLARATIONS OF PORT IN/OUT & DATA TYPES ----------------
    //
    input a,
    input b,
    input cin,
    output sum,
    output cout
);

    //
    // ---------------- MODULE DESIGN IMPLEMENTATION ----------------
    //
    wire w1, w2, w3;

    xor g1 (w1, a, b);
    and g2 (w2, w1, cin);
    xor g3 (sum, w1, cin);
    and g4 (w3, a, b);
    or g5 (cout, w2, w3);
endmodule

`endif // full_adder_1bit