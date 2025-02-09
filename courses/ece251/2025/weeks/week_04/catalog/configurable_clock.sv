//////////////////////////////////////////////////////////////////////////////
//
// Module: configurable_clock
//
// Clock generator with configurable period and duty cycle
//
// hdl: SystemVerilog
// modeling: Behavioral Modeling
//
// author: Prof. Rob Marano <rob@cooper.edu>
//
///////////////////////////////////////////////////////////////////////////////
`ifndef configurable_clock
`define configurable_clock

module configurable_clock
    //
    // ---------------- DECLARATIONS OF PORT IN/OUT & DATA TYPES ----------------
    //
#(
    parameter integer WIDTH = 8, // Width of the counter and period/duty cycle values
    parameter real FAST_CLK_PERIOD = 1.0 // Period of the faster clock (e.g., 1ns)
) (
    input logic fast_clk, // The faster clock
    input logic rst,      // Reset
    input logic enable,   // Enable the clock generator
    input logic [WIDTH-1:0] period,     // Total period of the output clock
    input logic [WIDTH-1:0] duty_cycle, // "On" time of the output clock
    output logic clk_out   // The output clock with configurable duty cycle
);

    //
    // ---------------- MODULE DESIGN IMPLEMENTATION ----------------
    //
    logic [WIDTH-1:0] counter;

    always_ff @(posedge fast_clk) begin
        if (rst) begin
            counter <= 0;
            clk_out <= 0;
        end else if (enable) begin
            if (counter < duty_cycle) begin
                clk_out <= 1;
            end else begin
                clk_out <= 0;
            end

            if (counter == period - 1) begin // Reset at the end of the period
                counter <= 0;
            end else begin
                counter <= counter + 1;
            end
        end
    end
endmodule : configurable_clock
`endif // configurable_clock