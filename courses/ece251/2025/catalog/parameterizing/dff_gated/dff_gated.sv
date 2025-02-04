//////////////////////////////////////////////////////////////////////////////
//
// D Flip-Flop with Reset and Enable (Gate-Level)
//
// module: dff_gated
// hdl: SystemVerilog
// modeling: Gate Level Modeling
//
// author: Prof. Rob Marano <rob@cooper.edu>
//
///////////////////////////////////////////////////////////////////////////////
`ifndef dff_gated
`define dff_gated

`timescale 1ns/100ps

module dff_gated
(
    //
    // ---------------- DECLARATIONS OF PORT IN/OUT & DATA TYPES ----------------
    //
    input wire d,
    input wire clk,
    input wire rst_n, // Active low reset
    input wire en,
    output reg q,
    output reg q_bar
);

    //
    // ---------------- MODULE DESIGN IMPLEMENTATION ----------------
    //
    wire s, r; // Set and Reset signals for the internal SR latch

    // Combinational logic for Set/Reset generation
    // Set when enable, data is high, and reset is inactive
    assign s = (en & d) & ~rst_n;

    // Reset when enable, data is low, and reset is inactive
    assign r = (en & ~d) & ~rst_n;

    // SR Latch (implemented with NAND gates, and propagation delays)
    wire q_int, q_bar_int;
    nand #(1) g1 (q_int, s, q_bar_int);
    nand #(1) g2 (q_bar_int, r, q_int);

    // Clock Gating for the SR Latch Inputs (to avoid metastability)
    wire s_gated, r_gated;
    and #(1) g3(s_gated, s, clk);
    and #(1) g4(r_gated, r, clk);

    // specify
    //     (a => y) = 1.2; // Delay from input a to output y
    //     (b => y) = 1.0; // Delay from input b to output y
    // endspecify

    // Output assignment (after clock gating)
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
        q <= 0;
        q_bar <= 1;
        end else begin
            q <= q_int;  // Assign after clock gating
            q_bar <= q_bar_int; // Assign after clock gating
        end
    end

endmodule
`endif // dff_gated