`timescale 1ns/1ps

module tb_pwm_generator;
    logic clk, rst, pwm_out;

    pwm_generator uut (.*);

    initial begin
        clk = 0;
        forever #1 clk = ~clk;
    end

    initial begin
        $display("\n=========================================");
        $display("      Example 3C.2: PWM (Hardware)       ");
        $display("=========================================");
        $display("Threshold = 64 (25%% of 256)");
        
        rst = 1;
        #2 rst = 0;
        
        // Monitor specific points
        $monitor("Time=%0t Count=%d PWM_Out=%b", $time, uut.count, pwm_out);
        
        #300; // Run past 64
        $display("=========================================\n");
        $finish;
    end
endmodule
