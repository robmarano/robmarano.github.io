`timescale 1ns/1ps // Unit (1ns) / Precision (1ps)

module tb_mux2;
    // 1. Signals (No inputs/outputs in TB)
    logic [3:0] d0, d1;
    logic       sel;
    logic [3:0] y;

    // 2. Instantiate DUT
    mux2 uut (
        .d0(d0), .d1(d1), .sel(sel), .y(y)
    );

    // Helper signal for self-checking
    logic [3:0] expected;
    assign expected = sel ? d1 : d0;

    // 3. Test Stimulus
    initial begin
        // --- A. Waveform Setup ---
        $dumpfile("mux_simulation.vcd");
        $dumpvars(0, tb_mux2); 

        // --- B. Console Logging ---
        $display("\n=========================================");
        $display("       Example 2/7: 2:1 Multiplexor      ");
        $display("=========================================");
        $display(" Time | Sel | D0   | D1   | Output (Y) ");
        $display("------+-----+------+------+------------");
        $monitor(" %4t |  %b  | %h | %h | %h", $time, sel, d0, d1, y);

        // Initialize inputs to avoiding 'x' (undefined) states at start
        sel = 0; d0 = 4'hA; d1 = 4'h5;

        // --- C. Directed Testing (Specific Cases) ---
        #10 sel = 1;     // Case 1: Select D1 (Expect 5)
        #10 d1  = 4'hC;  // Case 2: Change D1 (Expect C)
        #10 sel = 0;     // Case 3: Select D0 (Expect A)
        #10 d0  = 4'h3;  // Case 4: Change D0 (Expect 3)

        // --- D. Randomized Testing ---
        repeat (5) begin
            #10; // Wait 10 time units between tests
            sel = $random;  // Random 1-bit (LSB taken)
            d0  = $random;  // Random 4-bits
            d1  = $random;  // Random 4-bits
            
            // --- E. Self-Checking Logic (Assertions) ---
            #1 $strobe("   -> Check: Expected %h, Got %h", expected, y);
            
            // Golden Model Comparison
            if (y !== expected) begin
                $display("ERROR at time %0t: Mismatch!", $time);
                $stop; 
            end
        end

        // --- F. Simulation Termination ---
        $display("=========================================");
        $display("      Simulation Complete. No Errors.    ");
        $display("=========================================\n");
        $finish; 
    end
endmodule
