///////////////////////////////////////////////////////////////////////////////
//
// Module: Testbench for module decoder_2to1
//
// Testbench for decoder_2to1
//
// module: tb_decoder_2to1
// hdl: SystemVerilog
//
// author: Prof. Rob Marano <rob@cooper.edu>
//
///////////////////////////////////////////////////////////////////////////////
`timescale 1ns/100ps

`include "decoder_2to1.sv"

module tb_decoder_2to1;
    //
    // ---------------- DECLARATIONS OF DATA TYPES ----------------
    //
    //inputs are reg for test bench - or use logic
    //outputs are wire for test bench - or use logic
    logic sel;
    logic en;
    logic y0;
    logic y1;

    //
    // ---------------- INSTANTIATE DEVICE UNDER TEST (DUT) ----------------
    //
    decoder_2to1 dut (
        .sel(sel),
        .en(en),
        .y0(y0),
        .y1(y1)
    );

    //
    // ---------------- INITIALIZE TEST BENCH ----------------
    //
    initial begin : initialize_variables
        en = 0;
        sel = 0;
    end

    initial begin
        //$monitor ($time,"ns, select:s=%b, inputs:d=%b, output:z1=%b", S, D, Z1);
    end

    initial begin : dump_variables
        $dumpfile("decoder_2to1.vcd"); // for Makefile, make dump file same as module name
        $dumpvars(2, dut);
    end

    /*
    * display variables
    */
    initial begin: display_variables
        // note: currently only simple signals or constant expressions may be passed to $monitor.
        // $monitor ("X1-X2-X4-X4 = %b, Z1 = %b", {X1,X2,X3,X4}, Z1);
    end

    //
    // ---------------- APPLY INPUT VECTORS ----------------
    //
    // note: following the keyword begin is the name of the block: apply_stimulus
    initial begin : apply_stimuli
        #10;  // Wait for a short period after start

        //
        // Test case 1: en = 0, sel = 0
        if (y0 !== 0 || y1 !== 0) begin
        $error("Test case 1 failed: Output should be 0 when en is 0");
        end
        $display("Test Case 1: en=0, sel=0, y0=%b, y1=%b (PASS)", y0, y1);

        //
        // Test case 2: en = 1, sel = 0
        //
        en = 1;
        sel = 0;
        #10;
        if (y0 !== 1 || y1 !== 0) begin
        $error("Test case 2 failed: y0 should be 1 and y1 should be 0");
        end
        $display("Test Case 2: en=1, sel=0, y0=%b, y1=%b (PASS)", y0, y1);

        //
        // Test case 3: en = 1, sel = 1
        //
        en = 1;
        sel = 1;
        #10;
        if (y0 !== 0 || y1 !== 1) begin
        $error("Test case 3 failed: y0 should be 0 and y1 should be 1");
        end
        $display("Test Case 3: en=1, sel=1, y0=%b, y1=%b (PASS)", y0, y1);

        //
        // Test case 4: en = 1, sel changing
        //
        en = 1;
        sel = 0;
        #10;
        sel = 1;
        #10;
        sel = 0;
        #10;
        $display("Test Case 4: en=1, sel changing, y0=%b, y1=%b", y0, y1); // Just display, more complex checking could be added.

        //
        // End the simulation
        //
        $finish;
    end
endmodule