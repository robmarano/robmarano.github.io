`timescale 1ns/1ps

module tb_registers;
    logic clk, rst_n;
    
    // Reg 4
    logic [3:0] r4_d, r4_q;
    reg4_structural u_reg4 (.*, .d(r4_d), .q(r4_q));

    // Reg 8 (Generative)
    logic [7:0] r8_d, r8_q;
    reg_n #(8) u_reg8 (.*, .d(r8_d), .q(r8_q));

    // Register File
    logic        we3;
    logic [4:0]  ra1, ra2, wa3;
    logic [31:0] wd3, rd1, rd2;
    register_file u_rf (.*);

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        $display("\n=========================================");
        $display("      Example 6: Register Types          ");
        $display("=========================================");
        
        rst_n = 0; we3 = 0; r4_d = 0; r8_d = 0;
        #10 rst_n = 1;

        $display("1. Testing Structural 4-bit Register...");
        r4_d = 4'hA;
        @(posedge clk); #1;
        $display("   In=%h Out=%h (Exp A)", r4_d, r4_q);

        $display("2. Testing Generative 8-bit Register...");
        r8_d = 8'hEF;
        @(posedge clk); #1;
        $display("   In=%h Out=%h (Exp EF)", r8_d, r8_q);

        $display("3. Testing Register File...");
        // Write
        @(negedge clk);
        wa3 = 5; wd3 = 32'hDEADBEEF; we3 = 1;
        @(posedge clk); #1; we3 = 0;
        $display("   Wrote DEADBEEF to Reg 5");

        // Read
        ra1 = 5;
        #1;
        $display("   Read Reg 5: %h (Exp DEADBEEF)", rd1);

        $display("=========================================\n");
        $finish;
    end
endmodule
