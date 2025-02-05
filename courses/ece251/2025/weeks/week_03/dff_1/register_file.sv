    `ifndef REGISTER_FILE
    `define REGISTER_FILE

    `include "register.sv"

    module register_file #(
    parameter DEPTH = 8,  // Number of registers (default 8)
    parameter WIDTH = 8   // Width of each register (inherited or specified)
    ) (
    input logic clk,
    input logic rst,
    input logic enable,

    input logic [$log2(DEPTH)-1:0] write_addr, // Write address
    input logic [WIDTH-1:0] write_data,      // Write data
    input logic write_en,                  // Write enable

    input logic [$log2(DEPTH)-1:0] read_addr1, // Read address 1
    output logic [WIDTH-1:0] read_data1,     // Read data 1

    input logic [$log2(DEPTH)-1:0] read_addr2, // Read address 2
    output logic [WIDTH-1:0] read_data2      // Read data 2
    );

    // Array of registers
    register #( .WIDTH(WIDTH) ) registers [DEPTH-1:0]; // Parameterized register instances

    parameter bit [WIDTH-1:0] ZERO  = '0;

    genvar i;
    generate
        for (i = 0; i < DEPTH; i++) begin : register_instances
            registers[i] (
                .clk(clk),
                .rst(rst),
                .enable(enable),
                .d( (write_en && (write_addr == i)) ? write_data : ZERO ), // Conditional write
                .q() // Output not directly connected within the array
            );  
        end
    endgenerate

    // Read logic (combinational) - Two independent read ports
    assign read_data1 = registers[read_addr1].q; // Hierarchical access to register output
    assign read_data2 = registers[read_addr2].q; // Hierarchical access to register output

    endmodule

    `endif