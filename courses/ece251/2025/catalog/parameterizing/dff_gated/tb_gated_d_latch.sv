///////////////////////////////////////////////////////////////////////////////
//
// Testbench for gated D latch
//
// module: tb_gated_d_latch
//
// author: Prof. Rob Marano <rob@cooper.edu>
//
///////////////////////////////////////////////////////////////////////////////
`timescale 1ns/100ps
// ensure you note the scale (ns) below in $monitor

`include "gated_d_latch.sv"

module tb_gated_d_latch;
    //
    // ---------------- DECLARATIONS OF DATA TYPES ----------------
    //

    //inputs are reg for test bench - or use logic
    reg d;
    reg clk;

    //outputs are wire for test bench - or use logic
    wire q;
    wire q_bar;

    //
    // ---------------- INSTANTIATE UNIT UNDER TEST (UUT) ----------------
    //
    gated_d_latch dut (
        .d(d),
        .clk(clk),
        .q(q),
        .q_bar(q_bar)
    );

    // Clock generation
    // always #5 clk = ~clk; // 10ns period (50MHz)
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 10ns period
    end

    //
    // ---------------- INITIALIZE TEST BENCH ----------------
    //
    initial begin : initialize_variables
        clk = 0;
        d = 0;  
    end

    initial begin : dump_variables
        // Create a VCD file for waveform viewing
        // for Makefile, make dump file same as module name
        $dumpfile("gated_d_latch.vcd");

        // Dump all signals in the testbench and DUT
        $dumpvars(1, dut);
    end

    /*
    * display variables
    */
    initial begin: display_variables
        // note: currently only simple signals or constant expressions may be passed to $monitor.
        $monitor("Time=%0t, D=%0b, CLK=%0b, Q=%0b, Q_BAR=%0b", $time, d, clk, q, q_bar);
    end

    //
    // ---------------- APPLY INPUT VECTORS ----------------
    //
    // note: following the keyword begin is the name of the block: apply_stimulus
    initial begin : apply_stimuli
        #10
        // Test cases
        #10 d = 1; // Capture '1'
        #10 d = 0; // Capture '0'
        #3      d = 1; 
        #10 d = 0; // Capture '0'
        #3   d = 1; // Capture '1'
        #10 $finish;
    end

endmodule