//////////////////////////////////////////////////////////////////////////////
//
// Master-slave D flip-flop with preset and clear (Gate-Level)
//
// module: dff_pc
// hdl: SystemVerilog
// modeling: Structural Modeling
//
// author: Prof. Rob Marano <rob@cooper.edu>
//
///////////////////////////////////////////////////////////////////////////////
`ifndef dff_pc
`define dff_pc

`timescale 1ns/100ps

module dff_pc
(
    //
    // ---------------- DECLARATIONS OF PORT IN/OUT & DATA TYPES ----------------
    //
    input wire d,
    input wire clk,
    input preset_n,
    input clear_n,
    output reg q,
    output reg q_bar
);

    //
    // ---------------- MODULE DESIGN IMPLEMENTATION ----------------
    //
    not #(0) g1 (d_bar, d);
    not #(0) g2 (clk_bar, clk);
    nand #(0) g3 (g3out, d, clk);
    nand #(0) g4 (g4out, clk, d_bar);
    nand #(0) g5 (g5out, preset_n, g3out, g6out);
    nand #(0) g6 (g6out, g5out, g4out, clear_n);
    nand #(0) g7 (g7out, g5out, clk_bar);
    nand #(0) g8 (g8out, g6out, clk_bar);
    nand #(0) g9 (q, preset_n, g7out, q_bar);
    nand #(0) g10 (q_bar, clear_n, g8out, q);

endmodule
`endif // gated_d_latch