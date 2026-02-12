`timescale 1ns/1ps

module tb_memory_elements;
    logic clk, rst_n;
    logic d, q_latch, q_dff;

    d_latch u_latch (.clk(clk), .d(d), .q(q_latch));
    d_flip_flop u_dff (.clk(clk), .rst_n(rst_n), .d(d), .q(q_dff));

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        $display("\n=========================================");
        $display("    Example 5: Latch vs Flip-Flop        ");
        $display("=========================================");
        $display(" Time | Clk | D | Latch(Q) | DFF(Q)");
        $display("------+-----+---+----------+-------");
        $monitor(" %4t |  %b  | %b |    %b     |   %b", $time, clk, d, q_latch, q_dff);

        rst_n = 0; d = 0;
        #12 rst_n = 1; // Release reset
        
        // 1. D goes high while Clock LOW
        #10 d = 1; 
        // Latch should hold previous (0), DFF holds (0)

        // 2. D goes high while Clock HIGH
        #10; // Clock is high around 25-30
        // Wait for clock high?
        @(posedge clk);
        #1;
        $display("      >> Edge! DFF captured 1");
        
        #2 d = 0; 
        $display("      >> D changed to 0 while Clk=1. Latch follows?");

        #10;
        $display("=========================================\n");
        $finish;
    end
endmodule
