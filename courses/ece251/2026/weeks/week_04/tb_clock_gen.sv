module tb_clock_gen;
    logic clk;
    
    // Create a 10ns period clock (100 MHz if timescale is 1ns)
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // Toggle every 5ns
    end

    // Monitor and finish
    initial begin
        $display("\n=========================================");
        $display("      Example 3A: Clock Generation       ");
        $display("=========================================");
        $monitor("Time=%0t clk=%b", $time, clk);
        #100;
        $display("=========================================\n");
        $finish;
    end
endmodule
