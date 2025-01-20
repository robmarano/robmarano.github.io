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

`include "module.sv"

module tb_module;
    //
    // ---------------- DECLARATIONS OF DATA TYPES ----------------
    //
    //inputs are reg for test bench - or use logic

    //outputs are wire for test bench - or use logic

    //
    // ---------------- INITIALIZE TEST BENCH ----------------
    //
    initial begin : initialize_variables
    end

    initial begin
        //$monitor ($time,"ns, select:s=%b, inputs:d=%b, output:z1=%b", S, D, Z1);
    end

    initial begin : dump_variables
        $dumpfile("module.vcd"); // for Makefile, make dump file same as module name
        $dumpvars(0, dut);
    end

    /*
    * display variables
    */
//    initial begin: display_variables
        // note: currently only simple signals or constant expressions may be passed to $monitor.
//        $monitor ("X1-X2-X4-X4 = %b, Z1 = %b", {X1,X2,X3,X4}, Z1);
//    end

    //
    // ---------------- APPLY INPUT VECTORS ----------------
    //
    // note: following the keyword begin is the name of the block: apply_stimulus
    initial begin : apply_stimuli
    #0  S = 2'b00; // S[0]=1'b0; S[1]=1'b0;
        D = 4'b1010; // D[0]=1'b0; D[1]=1'b1; D[2]=1'b0; D[3]=1'b1;
        EN = 1'b1; // EN=1'b1;
    #10 S = 2'b00; // S[0]=1'b0; S[1]=1'b0;
        D = 4'b1011; // D[0]=1'b1; D[1]=1'b1; D[2]=1'b0; D[3]=1'b1;
        EN = 1'b1; // EN=1'b1;
    #10 S = 2'b01; // S[0]=1'b1; S[1]=1'b0;
        D = 4'b1011; // D[0]=1'b1; D[1]=1'b1; D[2]=1'b0; D[3]=1'b1;
        EN = 1'b1; // EN=1'b1;
    #10 S = 2'b10; // S[0]=1'b0; S[1]=1'b0;
        D = 4'b1011; // D[0]=1'b1; D[1]=1'b1; D[2]=1'b0; D[3]=1'b1;
        EN = 1'b1; // EN=1'b1;
    #10 S = 2'b01; // S[0]=1'b1; S[1]=1'b0;
        D = 4'b1001; // D[0]=1'b1; D[1]=1'b1; D[2]=1'b0; D[3]=1'b1;
        EN = 1'b1; // EN=1'b1;
    #10 S = 2'b11; // S[0]=1'b1; S[1]=1'b0;
        D = 4'b1011; // D[0]=1'b1; D[1]=1'b1; D[2]=1'b0; D[3]=1'b1;
        EN = 1'b1; // EN=1'b1;
    #10 S = 2'b11; // S[0]=1'b1; S[1]=1'b0;
        D = 4'b0011; // D[0]=1'b1; D[1]=1'b1; D[2]=1'b0; D[3]=1'b1;
        EN = 1'b1; // EN=1'b1;
    #10 S = 2'b11; // S[0]=1'b1; S[1]=1'b0;
        D = 4'b0011; // D[0]=1'b1; D[1]=1'b1; D[2]=1'b0; D[3]=1'b1;
        EN = 1'b0; // EN=1'b1;
    #10 $finish;
    end
    //$finish;
    // note: do not need $finish, since the simulation runs for the set increments and ends.

    //
    // ---------------- INSTANTIATE UNIT UNDER TEST (UUT) ----------------
    //
    module dut(
        .d(D), .s(S), .z1(Z1), .en(EN)
    );

endmodule