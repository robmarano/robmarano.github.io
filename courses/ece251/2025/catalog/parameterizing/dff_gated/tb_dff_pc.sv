///////////////////////////////////////////////////////////////////////////////
//
// Testbench for master-slave D flip-flop with Preset and Clear
//
// module: tb_dff_pc
//
// author: Prof. Rob Marano <rob@cooper.edu>
//
///////////////////////////////////////////////////////////////////////////////
`timescale 1ns/100ps
// ensure you note the scale (ns) below in $monitor

`include "dff_pc.sv"

module tb_dff_pc;
    //
    // ---------------- DECLARATIONS OF DATA TYPES ----------------
    //

    //inputs are reg for test bench - or use logic
    logic clk;
    logic preset_n;
    logic clear_n;
    logic d;

    //outputs are wire for test bench - or use logic
    logic q, q_bar;

    //
    // ---------------- INSTANTIATE UNIT UNDER TEST (UUT) ----------------
    //
    dff_pc dut (
        .d(d),
        .clk(clk),
        .preset_n(preset_n),
        .clear_n(clear_n),
        .q(q),
        .q_bar(q_bar)
    );

    // Clock generation
    always #5 clk = ~clk; // 10ns period (50MHz)

    //
    // ---------------- INITIALIZE TEST BENCH ----------------
    //
    initial begin : initialize_variables
        clk = 0;
        preset_n = 0;
        clear_n = 0;
        d = 0;
    end

    initial begin : dump_variables
        // Create a VCD file for waveform viewing
        // for Makefile, make dump file same as module name
        $dumpfile("dff_pc.vcd");

        // Dump all signals in the testbench and DUT
        $dumpvars(1, dut);
    end

    /*
    * display variables
    */
    initial begin: display_variables
        // note: currently only simple signals or constant expressions may be passed to $monitor.
        $monitor($time, "ns\t clk=%b preset_n=%b clear_n=%b d=%b q=%b q_bar=%b", clk, preset_n, clear_n, d, q, q_bar);
    end

    //
    // ---------------- APPLY INPUT VECTORS ----------------
    //
    // note: following the keyword begin is the name of the block: apply_stimulus
    initial begin : apply_stimuli
        // Reset sequence
        #10 preset_n = 1; // Release reset after 10ns

        // Test cases
        #10 d = 1;  // Capture '1'
        #10 d = 0;  // Capture '0'
        #10 d = 1;  // Enable low, no change (q should remain 0)
        #10 d = 0;  // Capture '0'
        #10 d = 1;  // Capture '1'
        #10 $finish;
    end

endmodule