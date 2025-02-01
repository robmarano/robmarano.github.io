///////////////////////////////////////////////////////////////////////////////
//
// Module: Testbench for module full_adder_4bit
//
// Testbench for full_adder_4bit
//
// module: tb_full_adder_4bit
// hdl: SystemVerilog
//
// author: Prof. Rob Marano <rob@cooper.edu>
//
///////////////////////////////////////////////////////////////////////////////
`timescale 1ns/100ps
// ensure you note the scale (ns) below in $monitor

`include "full_adder_4bit.sv"

module tb_full_adder_4bit;
    //
    // ---------------- DECLARATIONS OF DATA TYPES ----------------
    //

    //inputs are reg for test bench - or use logic
    reg [3:0] a;
    reg [3:0] b;
    reg cin;

    //outputs are wire for test bench - or use logic
    wire [3:0] sum;
    wire cout;

    //
    // ---------------- INSTANTIATE UNIT UNDER TEST (UUT) ----------------
    //
    full_adder_4bit dut (
        .a(a),
        .b(b),
        .cin(cin),
        .sum(sum),
        .cout(cout)
    );

    //
    // ---------------- INITIALIZE TEST BENCH ----------------
    //
    initial begin : initialize_variables
        cin = 0;
        a = 4'b0000;
        b = 4'b0000;
    end

    initial begin : dump_variables
        $dumpfile("full_adder_4bit.vcd"); // for Makefile, make dump file same as module name
        $dumpvars(1, dut);
    end

    /*
    * display variables
    */
    initial begin: display_variables
        // note: currently only simple signals or constant expressions may be passed to $monitor.
        $monitor($time, "ns\t sum = %04b, a = %04b, b = %04b, cin = %b, cout = %b", sum, a, b, cin, cout);
    end

    //
    // ---------------- APPLY INPUT VECTORS ----------------
    //
    // note: following the keyword begin is the name of the block: apply_stimulus
    initial begin : apply_stimuli
        // Test cases
        // cin = 0;
        a = 4'b0000;
        b = 4'b0000;
        #10; // Wait for propagation delay

        // cin = 0;
        a = 4'b0001;
        b = 4'b0010;
        #10;

        // cin = 1;
        a = 4'b0111;
        b = 4'b1001;
        #10;

        // cin = 0;
        a = 4'b1111;
        b = 4'b1111;
        #10 $finish;
    end

endmodule