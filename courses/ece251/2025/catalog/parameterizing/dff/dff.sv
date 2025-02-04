//////////////////////////////////////////////////////////////////////////////
//
// Module: dff
//
// 1-bit D flip-flop with reset and enable
//
// module: dff
// hdl: SystemVerilog
// modeling: Behavioral Modeling
//
// author: Prof. Rob Marano <rob@cooper.edu>
//
///////////////////////////////////////////////////////////////////////////////
`ifndef dff
`define dff

module dff #(parameter WIDTH = 1)
(
    //
    // ---------------- DECLARATIONS OF PORT IN/OUT & DATA TYPES ----------------
    //
    input logic clk,
    input logic rst_n, // Active low reset
    input logic en,
    input logic [WIDTH-1:0] d,
    output logic [WIDTH-1:0] q
);

    //
    // ---------------- MODULE DESIGN IMPLEMENTATION ----------------
    //
    always_ff @(posedge clk) begin
        if (!rst_n) begin
            q <= '0; // Reset state
        end else if (en) begin
            q <= d; // Data capture when enabled
        end // No change when reset is high and enable is low.
    end

endmodule
`endif // dff