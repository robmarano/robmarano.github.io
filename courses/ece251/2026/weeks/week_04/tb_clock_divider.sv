`timescale 1ns/1ps

module tb_clock_divider;
    logic clk;
    logic rst;
    logic slow_clk;

    // Use a smaller width for simulation to avoid waiting forever
    // We will override the logic in simulation/force, or just use bottom bits
    // For this testbench, we'll redefine the module logic slightly for viz or just look at lower bits
    // Actually, let's just create a modified instance or assume 50MHz and wait a bit
    
    // Instantiate DUT
    clock_divider uut (
        .clk(clk),
        .rst(rst),
        .slow_clk(slow_clk)
    );

    // Fast Clock Gen
    initial begin
        clk = 0;
        forever #1 clk = ~clk; // 2ns period (500MHz) - fast
    end

    initial begin
        $display("\n=========================================");
        $display("       Example 3B: Clock Divider         ");
        $display("=========================================");
        $display("(Note: Real divider assumes 26 bits. We monitor internal counter[3:0] for demo)");
        
        rst = 1;
        #10 rst = 0;
        
        // Monitor the internal counter lower bits since bit 25 takes too long
        $monitor("Time=%0t Count[3:0]=%b Slow_Clk(Bit25)=%b", $time, uut.count[3:0], slow_clk);
        
        #100;
        $display("... Simulation truncated (would take seconds to toggle bit 25) ...");
        $display("=========================================\n");
        $finish;
    end
endmodule
