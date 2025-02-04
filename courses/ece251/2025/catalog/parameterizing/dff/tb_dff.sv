///////////////////////////////////////////////////////////////////////////////
//
// Testbench for dff
//
// module: tb_dff
//
// author: Prof. Rob Marano <rob@cooper.edu>
//
///////////////////////////////////////////////////////////////////////////////
`timescale 1ns/100ps
// ensure you note the scale (ns) below in $monitor

`include "dff.sv"

module tb_df;
    //
    // ---------------- DECLARATIONS OF DATA TYPES ----------------
    //

    // Parameters (match the module)
    parameter WIDTH = 1;

    //inputs are reg for test bench - or use logic
    logic clk;
    logic rst_n;
    logic en;
    logic [WIDTH-1:0] d;

    //outputs are wire for test bench - or use logic
    logic [WIDTH-1:0] q;

    //
    // ---------------- INSTANTIATE UNIT UNDER TEST (UUT) ----------------
    //
    dff #(WIDTH) dut (
        .clk(clk),
        .rst_n(rst_n),
        .en(en),
        .d(d),
        .q(q)
    );

    // Clock generation
    always #5 clk = ~clk; // 10ns period (50MHz)

    //
    // ---------------- INITIALIZE TEST BENCH ----------------
    //
    initial begin : initialize_variables
        clk = 0;
        rst_n = 0;
        en = 0;
        d = 0;
    end

    initial begin : dump_variables
        // Create a VCD file for waveform viewing
        // for Makefile, make dump file same as module name
        $dumpfile("dff.vcd");

        // Dump all signals in the testbench and DUT
        $dumpvars(1, dut);
    end

    /*
    * display variables
    */
    initial begin: display_variables
        // note: currently only simple signals or constant expressions may be passed to $monitor.
        $monitor($time, "ns\t clk=%b rst_n=%b en=%b d=%b q=%b", clk, rst_n, en, d, q);
    end

    //
    // ---------------- APPLY INPUT VECTORS ----------------
    //
    // note: following the keyword begin is the name of the block: apply_stimulus
    initial begin : apply_stimuli
        // Reset sequence
        #10 rst_n = 1; // Release reset after 10ns

        // Test cases
        #10 d = 1; en = 1; // Capture '1'
        #10 d = 0; en = 1; // Capture '0'
        #10 d = 1; en = 0; // Enable low, no change (q should remain 0)
        #10 d = 0; en = 1; // Capture '0'
        #10 d = 1; en = 1; // Capture '1'
        #10 $finish;
    end

endmodule