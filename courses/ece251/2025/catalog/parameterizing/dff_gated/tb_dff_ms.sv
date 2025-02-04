///////////////////////////////////////////////////////////////////////////////
//
// Testbench for master-slave D flip-flop
//
// module: tb_dff_ms
//
// author: Prof. Rob Marano <rob@cooper.edu>
//
///////////////////////////////////////////////////////////////////////////////
`timescale 1ns/100ps
// ensure you note the scale (ns) below in $monitor

`include "dff_ms.sv"

module tb_dff_ms;
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
    dff_ms dut (
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
        $dumpfile("dff_ms.vcd");

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
        #7   d = 1; // Capture '1' 
        #5 d = 0; // Capture '0'
        #5      d = 1; 
        #5 d = 0; // Capture '0'
        #100ps    d = 1; // Capture '1'
        #10 $finish;
    end

endmodule