// testbench_template.sv
// Description: Template for a SystemVerilog testbench.

`timescale 1ns / 1ps

module testbench_template;

    // 1. Declare Parameters (must match the module under test)
    parameter PARAM_WIDTH = 8;
    
    // 2. Declare Testbench Signals
    // Inputs to the DUT (Device Under Test) are usually 'logic'
    logic                   clk;
    logic                   reset_n;
    logic [PARAM_WIDTH-1:0] data_in;
    
    // Outputs from the DUT are also 'logic' (or 'wire')
    logic [PARAM_WIDTH-1:0] data_out;

    // 3. Instantiate the DUT
    module_name #(
        .PARAM_WIDTH(PARAM_WIDTH)
    ) dut (
        .clk(clk),
        .reset_n(reset_n),
        .data_in(data_in),
        .data_out(data_out)
    );

    // 4. Clock Generation
    always begin
        #5 clk = ~clk; // 10ns period -> 100MHz clock
    end

    // 5. Stimulus Generation
    initial begin
        // Initialize signals
        clk     = 0;
        reset_n = 0;
        data_in = '0;

        // Apply Reset
        #15;          // Wait a bit
        reset_n = 1;  // Release reset at an offset from clock edge
        #10;

        // Apply Test Vectors
        $display("Starting tests...");
        
        // Test Case 1
        @(posedge clk);
        data_in = 8'hA5;
        
        // Test Case 2
        @(posedge clk);
        data_in = 8'h5A;

        // Wait for processing to complete
        #50;
        
        $display("Tests complete.");
        $finish; // End the simulation
    end

    // 6. (Optional) Waveform Dump for GTKWave or EDA Playground
    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, testbench_template);
    end

endmodule
