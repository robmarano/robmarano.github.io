//////////////////////////////////////////////////////////////////////////////
//
// Gated D Latch (Gate-Level)
//
// module: gated_d_latch
// hdl: SystemVerilog
// modeling: Gate Level Modeling
//
// author: Prof. Rob Marano <rob@cooper.edu>
//
///////////////////////////////////////////////////////////////////////////////
`ifndef gated_d_latch
`define gated_d_latch

`timescale 1ns/100ps

module gated_d_latch
(
    //
    // ---------------- DECLARATIONS OF PORT IN/OUT & DATA TYPES ----------------
    //
    input wire d,
    input wire clk,
    output reg q,
    output reg q_bar
);

    always_comb begin : outblock
        q = g4out;
        q_bar = g5out;
        
    end

    //
    // ---------------- MODULE DESIGN IMPLEMENTATION ----------------
    //
    wire g1out, g2out, g3out, g4out, g5out;
    nand #(0) g1 (g1out, d, clk);
    not #(0) g2 (g2out, d);
    nand #(0) g3 (g3out, clk, g2out);
    nand #(0) g4 (g4out, g1out, g5out);
    nand #(0    ) g5 (g5out, g4out, g3out);

endmodule
`endif // gated_d_latch