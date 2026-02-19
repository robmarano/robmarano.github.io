// module_template.sv
// Description: Template for a standard SystemVerilog module.

`timescale 1ns / 1ps

module module_name #(
    parameter PARAM_WIDTH = 8 // Example parameter
)(
    input  logic                   clk,
    input  logic                   reset_n,  // Active-low reset
    input  logic [PARAM_WIDTH-1:0] data_in,
    output logic [PARAM_WIDTH-1:0] data_out
);

    // ------------------------------------------------------------------------
    // Internal signals
    // ------------------------------------------------------------------------
    logic [PARAM_WIDTH-1:0] internal_reg;
    logic [PARAM_WIDTH-1:0] next_internal_reg;

    // ------------------------------------------------------------------------
    // Combinational Logic 
    // Use always_comb for logic gates & routing without memory
    // * ALWAYS use blocking assignments (=) here.
    // ------------------------------------------------------------------------
    always_comb begin
        // Example: simple combinational add
        next_internal_reg = data_in + 1'b1;
    end

    // ------------------------------------------------------------------------
    // Sequential Logic 
    // Use always_ff for clocked elements like Flip-Flops
    // * ALWAYS use non-blocking assignments (<=) here.
    // ------------------------------------------------------------------------
    always_ff @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            // Reset state
            internal_reg <= '0;
            data_out     <= '0;
        end else begin
            // Normal operation
            internal_reg <= next_internal_reg;
            data_out     <= internal_reg;
        end
    end

endmodule
