///////////////////////////////////////////////////////////////////////////////
//
// Module: Testbench for module module
//
// Testbench for MODULE_NAME
//
// module: tb_module
// hdl: SystemVerilog
//
// author: Prof. Rob Marano <rob@cooper.edu>
//
///////////////////////////////////////////////////////////////////////////////
`timescale 1ns/100ps
// ensure you note the scale (ns) below in $monitor

`include "module.sv"

module tb_module;
    //
    // ---------------- DECLARATIONS OF DATA TYPES ----------------
    //

    //inputs are reg for test bench - or use logic

    //outputs are wire for test bench - or use logic

    //
    // ---------------- INSTANTIATE UNIT UNDER TEST (UUT) ----------------
    //
    module dut(
        .d(D), .s(S), .z1(Z1), .en(EN)
    );


    //
    // ---------------- INITIALIZE TEST BENCH ----------------
    //
    initial begin : initialize_variables
    end

    initial begin : dump_variables
        $dumpfile("module.vcd"); // for Makefile, make dump file same as module name
        $dumpvars(0, dut);
    end

    /*
    * display variables
    */
    initial begin: display_variables
        // note: currently only simple signals or constant expressions may be passed to $monitor.
        // $monitor ($time, "ns\tX1-X2-X4-X4 = %b, Z1 = %b", {X1,X2,X3,X4}, Z1);
    end

    //
    // ---------------- APPLY INPUT VECTORS ----------------
    //
    // note: following the keyword begin is the name of the block: apply_stimulus
    initial begin : apply_stimuli
    #10 $finish;
    end

endmodule