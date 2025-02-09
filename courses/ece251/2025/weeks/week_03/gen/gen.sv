`timescale 1ns/1ps
`ifndef DEBUG_GENERATE_REGISTERS
    `define DEBUG_GENERATE_REGISTERS
`endif
// ------------------------------------------------------------------------------------------------------------
module gen;
    localparam integer DELAY = 5;
    localparam integer DEPTH = 8; // Number of registers
    localparam integer WIDTH = 8; // Width of each register

    static integer addr = 3'h0;
    static integer val = 8'h00;

    logic clk, fastest_clk;
    logic rst;
    logic enable;

    logic [$clog2(DEPTH)-1:0] write_addr;
    logic [WIDTH-1:0] write_data;
    logic write_en;        
    logic [$clog2(DEPTH)-1:0] read_addr; 
    wire [WIDTH-1:0] read_data;

    configurable_clock clocks (
        .fast_clk(fastest_clk),
        .rst(rst),
        .enable(enable),
        .period(4),
        .duty_cycle(2),
        .clk_out(clk)
    );

    register_file rf (
        .clk(clk),
        .rst(rst),
        .enable(enable),
        .write_addr(write_addr),
        .write_data(write_data),
        .write_en(write_en),
        .read_addr(read_addr),
        .read_data(read_data)
    );

    // // Correct way to probe registers: use a procedural block with a loop and generate block
    // genvar k;
    // generate
    //     for (k = 0; k < DEPTH; k++) begin : probe_registers
    //         always @(posedge clk) begin
    //             $display($time, "ns Register %0d: q=%h", k, rf.registers[k].q);
    //         end
    //     end
    // endgenerate

    /*
    * display variables
    */
    initial begin: display_variables
        // note: currently only simple signals or constant expressions may be passed to $monitor.
        $monitor($time,"ns clk=%b rst=%b enable=%b write_addr=%h write_data=%h write_en=%b read_addr=%h read_data=%h",
            clk, rst, enable, write_addr, write_data, write_en, read_addr, read_data);
    end

    initial begin : dump_variables
        $dumpfile("gen.vcd"); // for Makefile, make dump file same as module name
        $dumpvars(0, gen);
    end

    // Clock generation
    initial begin
        fastest_clk = 0;
        forever #0.1 fastest_clk = ~fastest_clk;
    end

    //
    // ---------------- APPLY INPUT VECTORS ----------------
    //
    // note: following the keyword begin is the name of the block: apply_stimulus
    initial begin : apply_stimuli
        write_addr = addr; write_data = val;
        read_addr = addr;

        rst = 1; enable = 0; write_en = 0;

        #5 rst = 0;
        enable = 1;

        // TEST 0 - initialize all the registers to zero
        for (addr = 0; addr < DEPTH; addr++) begin
            write_addr = addr; write_data = 8'h00;
            write_en = 1;
            #5 write_en = 0;
        end
        addr = 3'h0; val = 8'h00;
        write_addr = addr; write_data = val;
        #5; // finished initialization
        
        // TEST 1
        addr = 3'h4; val = 8'h0A;
        write_addr = addr; write_data = val;
        write_en = 1;
        #10 write_en = 0; write_addr = 3'h0; write_data = 8'h00; read_addr = 3'h0;

        read_addr = addr;
        $display("Addr (%h) = Data (%h), should be %h)", read_addr, read_data, val);
        assert (read_data == val) else $error("Read data mismatch!");
        #10 read_addr = 3'h0;

        // TEST 2
        addr = 3'h6; val = 8'h0B;
        write_addr = addr; write_data = val;
        write_en = 1;
        #10 write_en = 0; write_addr = 3'h0; write_data = 8'h00; read_addr = 3'h0;

        #10;
        read_addr = addr;
        $display("Addr (%h) = Data (%h), should be %h)", read_addr, read_data, val);
        assert (read_data == val) else $error("Read data mismatch!");
        #10 read_addr = 3'h0;

        #20;
        $finish;
    end

endmodule : gen

// ------------------------------------------------------------------------------------------------------------
module configurable_clock #(
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

// ------------------------------------------------------------------------------------------------------------
module register_file #(
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

// ------------------------------------------------------------------------------------------------------------
module register #(
    parameter WIDTH = 8 // Default width of 8 bits
) (
    input logic clk,
    input logic rst,
    input logic enable,
    input logic [WIDTH-1:0] d, // Data input, parameterized width
    output logic [WIDTH-1:0] q // Data output, parameterized width
);

    logic [WIDTH-1:0] q_internal; // Internal signal for dff outputs

    generate
        genvar i;
        for (i = 0; i < WIDTH; i++) begin : flip_flops
            dff flip_flops (
            .clk(clk),
            .rst(rst),
            .enable(enable),
            .d(d[i]),      // Connecting individual bits of d
            .q(q_internal[i]) // Connecting individual bits of q_internal
            );
        end
    endgenerate

    assign q = q_internal; // Assign internal signal to output q
  
endmodule : register

// ------------------------------------------------------------------------------------------------------------
module dff (
  input logic clk,
  input logic rst,
  input logic enable,
  input logic d,
  output logic q
);
  always_ff @(posedge clk) begin
    if (rst) begin
      q <= 0; // Synchronous reset
    end else if (enable) begin
      q <= d; // Data is loaded only when enable is high
    end
  end
endmodule : dff
// ------------------------------------------------------------------------------------------------------------
