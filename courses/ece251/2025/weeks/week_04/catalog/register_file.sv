//////////////////////////////////////////////////////////////////////////////
//
// Module: register_file
//
// Parameterized Register File
//
// hdl: SystemVerilog
// modeling: Behavioral Modeling
//
// author: Prof. Rob Marano <rob@cooper.edu>
//
///////////////////////////////////////////////////////////////////////////////
`ifndef register_file
`define register_file

`include "register.sv"

module register_file
    //
    // ---------------- DECLARATIONS OF PORT IN/OUT & DATA TYPES ----------------
    //
#(
    parameter DEPTH = 8,  // Number of registers (default 8)
    parameter WIDTH = 8   // Width of each register (inherited or specified)
) (
    input logic clk,
    input logic rst,
    input logic enable,

    input logic [$clog2(DEPTH)-1:0] write_addr, // Write address
    input logic [WIDTH-1:0] write_data,      // Write data
    input logic write_en,                  // Write enable

    input logic [$clog2(DEPTH)-1:0] read_addr, // Read address
    output logic [WIDTH-1:0] read_data     // Read data
);
    //
    // ---------------- MODULE DESIGN IMPLEMENTATION ----------------
    //
    // Array of registers
    register #( .WIDTH(WIDTH) ) registers [DEPTH-1:0]; // Parameterized register instances

    localparam bit [WIDTH-1:0] ZERO  = '0;
    logic [WIDTH-1:0] q_internal [DEPTH-1:0]; // Internal signal for register outputs

    genvar i;
    generate
        for (i = 0; i < DEPTH; i++) begin : register_instances
            register #( .WIDTH(WIDTH) ) registers (
                .clk(clk),
                .rst(rst),
                .enable(enable && write_en && (write_addr == i)), // Simplified enable logic
                .d(write_data),
                .q(q_internal[i]) // Output not directly connected within the array
            );
            // Debugging with $display inside the generate block
            `ifdef DEBUG_GENERATE_REGISTERS
                initial begin : debug_generate_registers
                    $display($time, "ns Register %0d: enable=%b, write_en=%b, write_addr=%0d", i, enable && write_en && (write_addr == i), write_en, write_addr);
                end
            `endif // DEBUG_GENERATE_REGISTERS
        end
    endgenerate

    // Inside register_file module:
    always_ff @(posedge clk) begin
        read_data <= q_internal[read_addr];
    end
endmodule : register_file
`endif // register_file