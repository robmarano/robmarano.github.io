///////////////////////////////////////////////////////////////////////////////
//
// Module: Testbench for module mux_4to1
//
// Testbench for decoder_2mux_4to1to1
//
// module: tb_mux_4to1
// hdl: SystemVerilog
//
// author: Prof. Rob Marano <rob@cooper.edu>
//
///////////////////////////////////////////////////////////////////////////////

`timescale 1ns/100ps
// ensure you note the scale (ns) below in $monitor

`include "mux_4to1.sv"

module tb_mux_4to1;
    //
    // ---------------- DECLARATIONS OF DATA TYPES ----------------
    //
    //inputs are reg for test bench - or use logic
    //outputs are wire for test bench - or use logic
    logic [3:0] data_in;
    logic [1:0] sel;
    logic data_out;

    //
    // ---------------- INSTANTIATE DEVICE UNDER TEST (DUT) ----------------
    //
    mux_4to1 dut (
        .data_in(data_in),
        .sel(sel),
        .data_out(data_out)
    );

    //
    // ---------------- INITIALIZE TEST BENCH ----------------
    //
    initial begin : initialize_variables
        data_in = 4'b0000; // binary value, 4 bits wide
        sel = 2'b00; // binary value, 2 bits wide
    end

    //
    // display variables
    //
    //initial begin: display_variables
    //    // note: currently only simple signals or constant expressions may be passed to $monitor.
    //    $monitor ($time,"ns,\t sel = %b\t data_in = %b\t data_out = %b",sel,data_in,data_out);
    //end

    initial begin : dump_variables
        $dumpfile("mux_4to1.vcd"); // for Makefile, make dump file same as module name
        $dumpvars(2, dut);
    end

    //
    // ---------------- APPLY INPUT VECTORS ----------------
    //
    // note: following the keyword begin is the name of the block: apply_stimulus
    initial begin : apply_stimuli
        // Test all possible combinations
        // Loop on data_in
        for (int i = 0; i < 16; i++) begin
            data_in = i;
            // Loop on sel
            for (int j = 0; j < 4; j++) begin
                sel = j;
                #10; // Small delay for simulation

                $display("Data In: %4b, Select: %2b, Output: %b", data_in, sel, data_out);

                // Verification (optional, but highly recommended)
                case (sel)
                    2'b00: if (data_out !== data_in[0]) $error("Test failed!");
                    2'b01: if (data_out !== data_in[1]) $error("Test failed!");
                    2'b10: if (data_out !== data_in[2]) $error("Test failed!");
                    2'b11: if (data_out !== data_in[3]) $error("Test failed!");
                endcase
            end
        end
        $finish;
    end

endmodule