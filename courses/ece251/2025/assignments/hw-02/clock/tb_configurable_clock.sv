///////////////////////////////////////////////////////////////////////////////
//
// Testbench for configurable_clock
//
// module: tb_configurable_clock
// modeling: Structural and Behavioral
//
// author: Prof. Rob Marano <rob@cooper.edu>
//
///////////////////////////////////////////////////////////////////////////////
`timescale 1ns/100ps // Time unit and time precision
// ensure you note the scale (ns) below in $monitor

`include "configurable_clock.sv"

module tb_configurable_clock;
    //
    // ---------------- DECLARATIONS OF DATA TYPES ----------------
    //

    // Parameters
    localparam integer DELAY = 5;
    localparam integer DEPTH = 8; // Number of registers
    localparam integer WIDTH = 8; // Width of each register
    
    //inputs are reg for test bench - or use logic
    reg [WIDTH-1:0] period = 'd2; // note bit width casting using `d4 to WIDTH width
    reg [WIDTH-1:0] duty = 'd1; // note bit width casting using `d4 to WIDTH width
    logic clk, fastest_clk;
    logic rst;
    logic enable;


    //outputs are wire for test bench - or use logic
    wire [WIDTH-1:0] read_data;

    //
    // ---------------- INSTANTIATE UNIT UNDER TEST (UUT) ----------------
    //

    // Base clock generation (fastest_clk)
    // Clock generation
    initial begin
        fastest_clk = 0;
        forever #0.1 fastest_clk = ~fastest_clk;
    end

    // Clock instantiation
    configurable_clock clocks (
        .fast_clk(fastest_clk),
        .rst(rst),
        .enable(enable),
        .period(period),
        .duty_cycle(duty),
        .clk_out(clk)
    );

    //
    // ---------------- INITIALIZE TEST BENCH ----------------
    //

    initial begin : dump_variables
        // Create a VCD file for waveform viewing
        // for Makefile, make dump file same as module name
        $dumpfile("configurable_clock.vcd");

        // Dump all signals in the testbench and DUT
        $dumpvars(0, tb_configurable_clock);
    end

    /*
    * display variables
    */
    initial begin: display_variables
        $monitor($time,"ns clk=%b rst=%b enable=%b",
            clk, rst, enable);
    end

    //
    // ---------------- APPLY INPUT VECTORS ----------------
    //
    // note: following the keyword begin is the name of the block: apply_stimulus
    initial begin : apply_stimuli
        rst = 1; enable = 0; write_en = 0;

        #10 rst = 0;
        enable = 1;

        #10 rst = 1;
        enable = 0;
        #10;
        $finish;
    end
endmodule : tb_configurable_clock