//////////////////////////////////////////////////////////////////////////////
//
// Module: mux_4_1
//
// 4:1 Multiplexer
//
// module: mux_4_1
// hdl: SystemVerilog
// modeling: Gate Level Modeling
//
// author: Prof. Rob Marano <rob@cooper.edu>
//
///////////////////////////////////////////////////////////////////////////////
`ifndef MUX_4_1
`define MUX_4_1

module mux_4_1 (d, s, en, z1);
    //
    // ---------------- DECLARATIONS OF PORT IN/OUT & DATA TYPES ----------------
    //
    input [3:0] d;
    input [1:0] s;
    input en;
    output z1;

    //
    // ---------------- MODULE DESIGN IMPLEMENTATION ----------------
    //
    not inst1 (net1, s[0]);
    not inst2 (net2, s[1]);
    and inst3 (net3, d[0], net1, net2, en);
    and inst4 (net4, d[1], s[0], net2, en);
    and inst5 (net5, d[2], net1, s[1], en);
    and inst6 (net6, d[3], s[0], s[1], en);
    or inst7 (z1, net3, net4, net5, net6);

endmodule

`endif // MUX_4_1