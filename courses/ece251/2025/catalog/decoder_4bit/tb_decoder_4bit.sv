///////////////////////////////////////////////////////////////////////////////
//
// Module: Testbench for module decoder_4bit
//
// Testbench for decoder_4bit
//
// module: tb_decoder_4bit
// hdl: SystemVerilog
//
// author: Prof. Rob Marano <rob@cooper.edu>
//
///////////////////////////////////////////////////////////////////////////////
`timescale 1ns/100ps

`include "decoder_4bit.sv"

module tb_decoder_4bit;
    //
    // ---------------- DECLARATIONS OF DATA TYPES ----------------
    //

    //inputs are reg for test bench - or use logic
    logic [3:0] sel;

    //outputs are wire for test bench - or use logic
    wire [15:0] y;

    //
    // ---------------- INSTANTIATE UNIT UNDER TEST (UUT) ----------------
    //
    decoder_4bit dut (
        .sel(sel),
        .y(y)
    );

    //
    // ---------------- INITIALIZE TEST BENCH ----------------
    //
    initial begin : initialize_variables
        sel = 4'b0000; // initialize sel 4-bit vector to zero.
    end

    initial begin : dump_variables
        $dumpfile("decoder_4bit.vcd"); // for Makefile, make dump file same as module name
        $dumpvars(2, dut);
    end

    //
    // display variables
    //
    //initial begin: display_variables
        // note: currently only simple signals or constant expressions may be passed to $monitor.
        // $monitor ($time,"ns, X1-X2-X4-X4 = %b, Z1 = %b", {X1,X2,X3,X4}, Z1);
    //end

    //
    // ---------------- APPLY INPUT VECTORS ----------------
    //
    // note: following the keyword begin is the name of the block: apply_stimulus
    initial begin : apply_stimuli
    // Test all possible select values
        for (int i = 0; i < 16; i++) begin
            sel = i;
            #10; // Small delay
            //$display("Select: %04b, Output: %16b", sel, y);
            // Verification (essential for a good testbench)
            for (int j = 0; j < 16; j++) begin
                if (j == i) begin
                    if (y[j] !== 1) begin
                        //$error("Test failed for sel = %0d, y[%0d] should be 1", i, j);
                    end
                    else begin
                        if (y[j] !== 0) begin
                            //$error("Test failed for sel = %0d, y[%0d] should be 0", i, j);
                        end
                    end
                end
            end
        end
        #10 $finish;
    end
endmodule