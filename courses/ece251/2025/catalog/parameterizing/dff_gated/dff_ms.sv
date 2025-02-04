//////////////////////////////////////////////////////////////////////////////
//
// Master-slave D flip-flop (Structural)
//
// module: dff_ms
// hdl: SystemVerilog
// modeling: Structural Modeling
//
// author: Prof. Rob Marano <rob@cooper.edu>
//
///////////////////////////////////////////////////////////////////////////////
`ifndef dff_ms
`define dff_ms

`timescale 1ns/100ps
`include "gated_d_latch.sv"

module dff_ms
(
    //
    // ---------------- DECLARATIONS OF PORT IN/OUT & DATA TYPES ----------------
    //
    input wire d,
    input wire clk,
    output reg q,
    output reg q_bar
);


    //
    // ---------------- MODULE DESIGN IMPLEMENTATION ----------------
    //
    wire qm, qm_bar, qs, clk_bar;
    gated_d_latch #(0) g1 (d, clk, qm, qm_bar);
    not #(0) g2 (clk_bar, clk);
    gated_d_latch #(0) g3 (qm, clk_bar,     q, q_bar);

endmodule
`endif // gated_d_latch